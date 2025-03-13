import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:road_guard/app/theme/theme.dart';
import 'package:road_guard/utils/utils.dart';

class PhoneField extends StatefulWidget {
  const PhoneField(
    this._controller, {
    super.key,
    this.validator,
    // this.onChanged,
    this.suffix,
  });

  final TextEditingController _controller;
  final String? Function(String?, String)? validator;
  // final String? Function(String?, String)? onChanged;
  final Widget? suffix;

  @override
  State<PhoneField> createState() => PhoneFieldState();
}

class PhoneFieldState extends State<PhoneField> {
  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('ZM');

  Future<void> _openCupertinoCountryPicker() => showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return CountryPickerCupertino(
            itemBuilder: (country) => Row(
              children: [
                Flexible(
                  child: Text(
                    '(+${country.phoneCode}) ${country.name}',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            onValuePicked: (Country country) => setState(() {
              _selectedCountry = country;
            }),
            itemFilter: (c) => [
              'ZM',
              'ZA',
              'CD',
              'MW',
              'TZ',
              'BW',
              'ZW',
              'MZ',
              'NA',
              'AO',
            ].contains(c.isoCode),
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('ZM'),
              CountryPickerUtils.getCountryByIsoCode('ZA'),
            ],
          );
        },
      );

  Future<void> _openCountryPickerDialog() => showDialog<void>(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Theme.of(context).colorScheme.tertiary,
          ),
          child: CountryPickerDialog(
            onValuePicked: (country) => setState(() {
              _selectedCountry = country;
            }),
            isSearchable: true,
            itemBuilder: (country) => Row(
              children: [
                CountryPickerUtils.getDefaultFlagImage(country),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${country.name} (+${country.phoneCode})',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            title: const Text('Select your country'),
            itemFilter: (c) => [
              'ZM',
              'ZA',
              'CD',
              'MW',
              'TZ',
              'BW',
              'ZW',
              'MZ',
              'NA',
              'AO',
            ].contains(c.isoCode),
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('ZM'),
              CountryPickerUtils.getCountryByIsoCode('ZA'),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (text) => widget.validator?.call(
        text,
        _selectedCountry.phoneCode,
      ),
      validator: (text) => widget.validator?.call(
        text,
        _selectedCountry.phoneCode,
      ),
      decoration: kTextFieldDecoration.copyWith(
        hintText: '--- --- ----',
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(8)),
          child: GestureDetector(
            onTap: () async {
              if (Platform.isIOS) {
                await _openCupertinoCountryPicker();
              } else {
                await _openCountryPickerDialog();
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: CountryPickerUtils.getDefaultFlagImage(
                      _selectedCountry,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+${_selectedCountry.phoneCode}  ',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        suffixIcon: widget.suffix,
      ),
    );
  }
}
