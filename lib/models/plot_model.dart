class PlotModel {
  String name;
  String iconPath;
  String size;
  int status;
  String crop;
  String score;
  bool isCurrentlySelected;

  PlotModel({
    required this.name,
    required this.iconPath,
    required this.size,
    required this.status,
    required this.crop,
    required this.score,
    required this.isCurrentlySelected,
  });

  static List<PlotModel> getPlots() {
    List<PlotModel> plots = [];

    plots.add(
      PlotModel(
        name: 'Plot 1',
        iconPath: 'assets/icons/field.svg',
        size: '1.5 Acres',
        status: 1,
        crop: 'Maize',
        score: '80',
        isCurrentlySelected: true,
      ),
    );

    plots.add(
      PlotModel(
        name: 'Plot 2',
        iconPath: 'assets/icons/field.svg',
        size: '2 Acres',
        status: 0,
        crop: 'Beans',
        score: '70',
        isCurrentlySelected: false,
      ),
    );

    plots.add(
      PlotModel(
        name: 'Plot 3',
        iconPath: 'assets/icons/field.svg',
        size: '1.5 Acres',
        status: 0,
        crop: 'Maize',
        score: '90',
        isCurrentlySelected: false,
      ),
    );

    plots.add(
      PlotModel(
        name: 'Plot 4',
        iconPath: 'assets/icons/field.svg',
        size: '2 Acres',
        status: 1,
        crop: 'Beans',
        score: '60',
        isCurrentlySelected: false,
      ),
    );

    plots.add(
      PlotModel(
        name: 'Plot 5',
        iconPath: 'assets/icons/field.svg',
        size: '1.5 Acres',
        status: 1,
        crop: 'Maize',
        score: '70',
        isCurrentlySelected: false,
      ),
    );
    return plots;
  }
}