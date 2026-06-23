import 'package:expense_tracker_app/src/core/constants/app_enums.dart';
import 'package:expense_tracker_app/src/core/widgets/app_shell.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/entities/reimbursement.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/providers/reimbursement_controller.dart';
import 'package:expense_tracker_app/src/features/reimbursements/domain/repositories/providers/reimbursement_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReimbursementsPage extends ConsumerWidget {
  const ReimbursementsPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final reimbursements =
    ref.watch(
      reimbursementsProvider,
    );

    return AppShell(
      currentIndex: 2,
      title: 'Paybacks',
      child: reimbursements.when(
        data: (items) {
          final pending =items.where((item) =>item.status ==ReimbursementStatus.pending,).toList();

          final partial =
          items
              .where(
                (item) =>
            item.status ==
                ReimbursementStatus
                    .partial,
          )
              .toList();

          final completed =
          items
              .where(
                (item) =>
            item.status ==
                ReimbursementStatus
                    .completed,
          )
              .toList();

          final totalPending =
          items.fold<double>(
            0,
                (sum, item) =>
            sum +
                item.pendingAmount,
          );

          return ListView(
            padding:
            const EdgeInsets.all(
              16,
            ),
            children: [
              _SummaryCard(
                title:
                'Pending Amount',
                value:
                '₹${totalPending.toStringAsFixed(0)}',
                icon: Icons
                    .payments_outlined,
              ),

              const SizedBox(
                height: 20,
              ),

              _StatusSection(
                title: 'Pending',
                items: pending,
              ),

              const SizedBox(
                height: 20,
              ),

              _StatusSection(
                title: 'Partial',
                items: partial,
              ),

              const SizedBox(
                height: 20,
              ),

              _StatusSection(
                title:
                'Completed',
                items:
                completed,
              ),
            ],
          );
        },
        loading: () =>
        const Center(
          child:
          CircularProgressIndicator(),
        ),
        error: (e, _) =>
            Center(
              child: Text(
                e.toString(),
              ),
            ),
      ),
    );
  }
}

class _SummaryCard
    extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(
        20,
      ),
      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(
          24,
        ),
        gradient:
        const LinearGradient(
          colors: [
            Color(0xFF10B981),
            Color(0xFF34D399),
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: Colors.white,
          ),

          const SizedBox(
            width: 16,
          ),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                title,
                style:
                const TextStyle(
                  color:
                  Colors.white70,
                ),
              ),

              Text(
                value,
                style:
                const TextStyle(
                  color:
                  Colors.white,
                  fontSize: 28,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _StatusSection
    extends StatelessWidget {
  const _StatusSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<Reimbursement> items;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge,
        ),

        const SizedBox(
          height: 12,
        ),

        if (items.isEmpty)
          const Card(
            child: ListTile(
              title: Text(
                'No records',
              ),
            ),
          )
        else
          ...items.map(
                (item) =>
                _ReimbursementTile(
                  reimbursement: item,
                ),
          ),
      ],
    );
  }
}

class _ReimbursementTile
    extends ConsumerWidget {
  const _ReimbursementTile({
    required this.reimbursement,
  });

  final Reimbursement reimbursement;

  Color _statusColor() {
    switch (
    reimbursement.status) {
      case ReimbursementStatus
          .pending:
        return Colors.red;

      case ReimbursementStatus
          .partial:
        return Colors.orange;

      case ReimbursementStatus
          .completed:
        return Colors.green;
    }
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Card(
      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    reimbursement
                        .personName[0]
                        .toUpperCase(),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Text(
                        reimbursement
                            .personName,
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight
                              .bold,
                          fontSize: 16,
                        ),
                      ),

                      Text(
                        reimbursement
                            .source ==
                            ReimbursementSource
                                .shared
                            ? 'Shared Expense'
                            : 'Reimbursement',
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    _statusColor()
                        .withOpacity(
                      0.15,
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                      12,
                    ),
                  ),
                  child: Text(
                    reimbursement
                        .status.name
                        .toUpperCase(),
                    style:
                    TextStyle(
                      color:
                      _statusColor(),
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            Row(
              children: [
                Expanded(
                  child: _InfoChip(
                    label: 'Total',
                    value:
                    '₹${reimbursement.totalAmount.toStringAsFixed(0)}',
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                Expanded(
                  child: _InfoChip(
                    label:
                    'Received',
                    value:
                    '₹${reimbursement.receivedAmount.toStringAsFixed(0)}',
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                Expanded(
                  child: _InfoChip(
                    label:
                    'Pending',
                    value:
                    '₹${reimbursement.pendingAmount.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            Row(
              children: [
                if (reimbursement
                    .status !=
                    ReimbursementStatus
                        .completed)
                  Expanded(
                    child:
                    FilledButton.icon(
                      onPressed: () {
                        _showReceivePaymentDialog(
                          context,
                          ref,
                          reimbursement,
                        );
                      },
                      icon:
                      const Icon(
                        Icons
                            .payments,
                      ),
                      label:
                      const Text(
                        'Receive Payment',
                      ),
                    ),
                  ),

                if (reimbursement
                    .status ==
                    ReimbursementStatus
                        .completed)
                  Expanded(
                    child:
                    OutlinedButton.icon(
                      onPressed:
                          () async {
                        await ref
                            .read(
                          reimbursementControllerProvider,
                        )
                            .deleteReimbursement(
                          reimbursement,
                        );
                      },
                      icon:
                      const Icon(
                        Icons
                            .delete_outline,
                      ),
                      label:
                      const Text(
                        'Delete',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip
    extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(
        10,
      ),
      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(
          12,
        ),
        color: Theme.of(
            context)
            .colorScheme
            .surfaceContainerHighest,
      ),
      child: Column(
        children: [
          Text(
            label,
            style:
            const TextStyle(
              fontSize: 12,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            value,
            style:
            const TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> _showReceivePaymentDialog(
    BuildContext context,
    WidgetRef ref,
    Reimbursement reimbursement,
    ) async {
  final controller =
  TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Receive Payment',
        ),

        content: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Text(
              reimbursement
                  .personName,
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Pending: ₹${reimbursement.pendingAmount.toStringAsFixed(0)}',
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
              controller,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration:
              const InputDecoration(
                labelText:
                'Amount Received',
                prefixIcon:
                Icon(
                  Icons
                      .currency_rupee,
                ),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            child: const Text(
              'Cancel',
            ),
          ),

          FilledButton(
            onPressed: () async {
              final amount =
                  double.tryParse(
                    controller.text,
                  ) ??
                      0;

              if (amount <= 0) {
                return;
              }

              await ref
                  .read(
                reimbursementControllerProvider,
              )
                  .receivePayment(
                reimbursement:
                reimbursement,
                amountReceived:
                amount,
              );

              if (context
                  .mounted) {
                Navigator.pop(
                  context,
                );
              }
            },
            child: const Text(
              'Save',
            ),
          ),
        ],
      );
    },
  );
}