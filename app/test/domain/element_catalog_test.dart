import 'package:app/domain/elements/chemical_element.dart';
import 'package:app/domain/elements/periodic_table_data.dart';
import 'package:app/features/elements_catalog/data/element_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('periodic data and repository expose 118 elements', () {
    expect(kPeriodicElements.length, 118);
    const repo = ElementCatalogRepository();
    expect(repo.allElements, same(kPeriodicElements));
  });

  test('category colors are stable for known keys', () {
    expect(
      periodicCategoryColor('noble'),
      isNot(equals(periodicCategoryColor('nonmetal'))),
    );
  });
}
