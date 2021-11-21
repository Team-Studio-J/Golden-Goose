enum AccountType { rank, unrank }

extension AccountTypeExtension on AccountType {
  String get name => toString().split('.').last;
}
