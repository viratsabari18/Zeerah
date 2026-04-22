import 'package:google_fonts/google_fonts.dart';
import 'package:zeerah/core/common/app_exports.dart';
import 'package:zeerah/core/models/user_model.dart';

class WalletHistoryScreen extends StatefulWidget {
  final UserModel user;
  const WalletHistoryScreen({super.key, required this.user});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _allTransactions = [
    {
      'title': 'Deep House Cleaning',
      'subtitle': '22 March, 2026 • 11:30 AM',
      'amount': -1200.0,
      'type': 'payment',
    },
    {
      'title': 'Added to Wallet',
      'subtitle': '20 March, 2026 • 02:15 PM',
      'amount': 2000.0,
      'type': 'topup',
    },
    {
      'title': 'Withdrawal to Bank',
      'subtitle': '19 March, 2026 • 05:00 PM',
      'amount': -500.0,
      'type': 'withdraw',
    },
    {
      'title': 'Refund - AC Repair',
      'subtitle': '18 March, 2026 • 10:00 AM',
      'amount': 800.0,
      'type': 'refund',
    },
    {
      'title': 'AC Repair Service',
      'subtitle': '18 March, 2026 • 10:00 AM',
      'amount': -800.0,
      'type': 'payment',
    },
    {
      'title': 'Bathroom Cleaning',
      'subtitle': '15 March, 2026 • 04:45 PM',
      'amount': -450.0,
      'type': 'payment',
    },
    {
      'title': 'Added to Wallet',
      'subtitle': '10 March, 2026 • 09:00 AM',
      'amount': 1000.0,
      'type': 'topup',
    },
  ];

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_selectedFilter == 'All') return _allTransactions;
    return _allTransactions.where((tx) {
      if (_selectedFilter == 'Payments') return tx['type'] == 'payment';
      if (_selectedFilter == 'Refunds') return tx['type'] == 'refund';
      if (_selectedFilter == 'Withdraw') return tx['type'] == 'withdraw';
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Wallet History',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildBalanceCard(context, user.walletBalance),
            const SizedBox(height: 25),
            _buildFilters(),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Recent Transactions',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildTransactionList(context),
            const SizedBox(height: 40),
            _buildSupportFooter(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryRed,
            AppColors.primaryRed.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildBalanceAction(Icons.add_circle_outline, 'Add Money'),
              const SizedBox(width: 12),
              _buildBalanceAction(Icons.account_balance_outlined, 'Withdraw'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceAction(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Payments', 'Refunds', 'Withdraw'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryRed : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryRed : const Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    final transactions = _filteredTransactions;
    
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'No transactions found',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final bool isCredit = tx['amount'] > 0;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCredit ? const Color(0xFFE8F5E9) : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCredit ? Icons.add_call : Icons.cleaning_services_outlined, // Placeholder icons
                  color: isCredit ? Colors.green : AppColors.primaryRed,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tx['subtitle'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isCredit ? '+' : '-'}₹${tx['amount'].abs().toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isCredit ? Colors.green : AppColors.primaryRed,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSupportFooter() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Having issues? ',
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 13,
          ),
          children: [
            TextSpan(
              text: 'Contact Support',
              style: GoogleFonts.poppins(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
