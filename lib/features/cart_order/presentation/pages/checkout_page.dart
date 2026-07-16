import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/address_suggestion_service.dart';
import '../../../../core/utils/country_codes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/top_toast.dart';
import '../../../home/application/store_controller.dart';
import '../../../home/domain/store_models.dart';
import '../../../order/application/order_controller.dart';
import '../widgets/country_code_picker.dart';
import '../widgets/order_confirmed_sheet.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressFocus = FocusNode();
  final _phoneController = TextEditingController();
  final _addressService = AddressSuggestionService();

  CountryCode _country = kDefaultCountryCode;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _addressFocus.dispose();
    _phoneController.dispose();
    _addressService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final storeState = ref.watch(storeControllerProvider);
    final catalog = ref.watch(storeCatalogProvider);

    final cartItems = storeState.cartQuantities.entries
        .where((e) => catalog.any((b) => b.id == e.key))
        .map((e) => catalog.firstWhere((b) => b.id == e.key))
        .toList();

    final subtotal = ref
        .read(storeControllerProvider.notifier)
        .subtotal(cartItems);
    final deliveryFee = ref
        .read(storeControllerProvider.notifier)
        .deliveryFee(cartItems);
    final total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF243041),
            size: 28,
          ),
        ),
        title: Text(
          l10n.paymentDetails,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF243041),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8EBF0)),
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.checkout,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF243041),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.completeOrderDetails,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E98A5),
                  ),
                ),
                const SizedBox(height: 24),

                _buildInputLabel(Icons.person_outline, l10n.name),
                const SizedBox(height: 8),
                _buildTextFormField(
                  controller: _nameController,
                  hintText: l10n.enterYourName,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _validateName(value, l10n),
                ),
                const SizedBox(height: 16),

                _buildInputLabel(Icons.location_on_outlined, l10n.address),
                const SizedBox(height: 8),
                _buildAddressField(l10n),
                const SizedBox(height: 16),

                _buildInputLabel(
                  Icons.phone_in_talk_outlined,
                  l10n.phoneNumber,
                ),
                const SizedBox(height: 8),
                _buildPhoneField(l10n),
                const SizedBox(height: 24),

                // Order Summary
                Row(
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 16,
                      color: Color(0xFF5A91C4),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.orderSummary,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF243041),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSummaryRow(
                  l10n.subtotal,
                  '\$${subtotal.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  l10n.deliveryFee,
                  '\$${deliveryFee.toStringAsFixed(2)}',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: Color(0xFFE8EBF0), height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.total,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF243041),
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A91C4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Payment
                Row(
                  children: [
                    const Icon(
                      Icons.payment_outlined,
                      size: 16,
                      color: Color(0xFF5A91C4),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.payment,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF243041),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F8FC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Stripe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF6772E5),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting
                        ? null
                        : () =>
                              _placeOrder(catalog, subtotal, deliveryFee, total),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A91C4),
                      disabledBackgroundColor: const Color(0xFFB9CFE4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 20,
                          ),
                    label: Text(
                      l10n.placeOrder,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF5A91C4)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF243041),
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration(String hintText, {Widget? prefixIcon}) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF8E98A5)),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: const Color(0xFFF3F8FC),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      errorStyle: const TextStyle(fontSize: 11, color: Color(0xFFE5484D)),
      enabledBorder: border(Colors.transparent, 0),
      focusedBorder: border(const Color(0xFF5A91C4), 1.4),
      errorBorder: border(const Color(0xFFE5484D), 1),
      focusedErrorBorder: border(const Color(0xFFE5484D), 1.4),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(fontSize: 13, color: Color(0xFF243041)),
      decoration: _fieldDecoration(hintText),
    );
  }

  Widget _buildAddressField(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = constraints.maxWidth;
        return Autocomplete<AddressSuggestion>(
          textEditingController: _addressController,
          focusNode: _addressFocus,
          displayStringForOption: (option) => option.fullAddress,
          optionsBuilder: (textEditingValue) =>
              _addressService.search(textEditingValue.text),
          fieldViewBuilder:
              (context, controller, focusNode, onFieldSubmitted) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => onFieldSubmitted(),
                  validator: (value) => _validateAddress(value, l10n),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF243041),
                  ),
                  decoration: _fieldDecoration(l10n.enterYourAddress),
                );
              },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, child) => Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, (1 - t) * -4),
                      child: child,
                    ),
                  ),
                  child: Material(
                    elevation: 8,
                    color: Colors.white,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: fieldWidth,
                      constraints: const BoxConstraints(maxHeight: 280),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE8EBF0)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                            child: Text(
                              l10n.suggestions.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: Color(0xFF8E98A5),
                              ),
                            ),
                          ),
                          Flexible(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 6),
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options.elementAt(index);
                                final highlighted =
                                    AutocompleteHighlightedOption.of(
                                      context,
                                    ) ==
                                    index;
                                return _SuggestionTile(
                                  suggestion: option,
                                  query: _addressController.text,
                                  highlighted: highlighted,
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPhoneField(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CountryCodePicker(
          selected: _country,
          onChanged: (country) {
            setState(() => _country = country);
            // Re-run validation against the newly selected country.
            _formKey.currentState?.validate();
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTextFormField(
            controller: _phoneController,
            hintText: l10n.enterYourPhoneNumber,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(_country.maxDigits),
            ],
            validator: (value) => _validatePhone(value, l10n),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8E98A5)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF243041),
          ),
        ),
      ],
    );
  }

  String? _validateName(String? value, AppLocalizations l10n) {
    final requiredMessage = Validators.required(
      value,
      label: l10n.name,
      l10n: l10n,
    );
    if (requiredMessage != null) {
      return requiredMessage;
    }
    final trimmed = value!.trim();
    if (trimmed.length < 2) {
      return l10n.minLengthMessage(l10n.name, 2);
    }
    // Letters (incl. accents), spaces, hyphens and apostrophes only.
    final pattern = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ' -]+$");
    if (!pattern.hasMatch(trimmed)) {
      return l10n.enterValidName;
    }
    return null;
  }

  String? _validateAddress(String? value, AppLocalizations l10n) {
    final requiredMessage = Validators.required(
      value,
      label: l10n.address,
      l10n: l10n,
    );
    if (requiredMessage != null) {
      return requiredMessage;
    }
    if (value!.trim().length < 8) {
      return l10n.enterCompleteAddress;
    }
    return null;
  }

  String? _validatePhone(String? value, AppLocalizations l10n) {
    final requiredMessage = Validators.required(
      value,
      label: l10n.phoneNumber,
      l10n: l10n,
    );
    if (requiredMessage != null) {
      return requiredMessage;
    }
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < _country.minDigits) {
      return l10n.phoneTooShort;
    }
    if (digits.length > _country.maxDigits) {
      return l10n.phoneTooLong;
    }
    return null;
  }

  void _placeOrder(
    List<BookItem> catalog,
    double subtotal,
    double deliveryFee,
    double total,
  ) async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      showTopToast(context, title: l10n.pleaseFixErrors, type: ToastType.error);
      return;
    }

    final storeState = ref.read(storeControllerProvider);
    if (storeState.cartQuantities.isEmpty) {
      showTopToast(context, title: l10n.cartIsEmpty, type: ToastType.info);
      return;
    }

    final phone = '${_country.dialCode} ${_phoneController.text.trim()}';
    final input = CheckoutInput(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      city: 'Book City',
      phone: phone,
      paymentMethod: PaymentMethod.stripe,
    );

    setState(() => _isSubmitting = true);
    final result = await ref
        .read(orderControllerProvider.notifier)
        .placeOrder(
          catalog: catalog,
          quantities: storeState.cartQuantities,
          input: input,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    switch (result) {
      case Success():
        ref.read(storeControllerProvider.notifier).clearCart();
      case ResultFailure(error: final e):
        showTopToast(context, title: e.message, type: ToastType.error);
        return;
    }

    OrderConfirmedSheet.show(
      context,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      onBackToHome: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}

/// A rich two-line suggestion row: bold-highlighted place name on top,
/// locality/region below, with a distinct icon for cities vs streets.
class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.suggestion,
    required this.query,
    required this.highlighted,
    required this.onTap,
  });

  final AddressSuggestion suggestion;
  final String query;
  final bool highlighted;
  final VoidCallback onTap;

  /// Bolds the part of [text] that matches the typed [query].
  TextSpan _highlightSpan(String text) {
    const base = TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w400,
      color: Color(0xFF243041),
    );
    const bold = TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w700,
      color: Color(0xFF243041),
    );
    final q = query.trim();
    if (q.isEmpty) {
      return TextSpan(text: text, style: base);
    }
    final index = text.toLowerCase().indexOf(q.toLowerCase());
    if (index < 0) {
      return TextSpan(text: text, style: base);
    }
    return TextSpan(
      children: [
        TextSpan(text: text.substring(0, index), style: base),
        TextSpan(text: text.substring(index, index + q.length), style: bold),
        TextSpan(text: text.substring(index + q.length), style: base),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: highlighted ? const Color(0xFFF3F8FC) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F8FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                suggestion.isCity
                    ? Icons.location_city_rounded
                    : Icons.place_outlined,
                size: 18,
                color: const Color(0xFF5A91C4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: _highlightSpan(suggestion.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    suggestion.secondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF8E98A5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
