import '../../../domain/elements/chemical_element.dart';
import '../../../domain/elements/periodic_table_data.dart';

/// Local static catalog (no network); keeps presentation testable by swapping this type.
class ElementCatalogRepository {
  const ElementCatalogRepository();

  List<ChemicalElement> get allElements => kPeriodicElements;
}
