import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/localizations.dart';

/// The translations for Estonian (`et`).
class SfLocalizationsIt extends SfLocalizations {
  SfLocalizationsIt();

  @override
  String get noEventsCalendarLabel => 'noEventsCalendarLabel';

  @override
  String get noSelectedDateCalendarLabel => 'Nessuna data selezionata';

  @override
  String get allowedViewDayLabel => 'Giorno';

  @override
  String get allowedViewMonthLabel => 'allowedViewMonthLabel';

  @override
  String get allowedViewScheduleLabel => 'Agenda';

  @override
  String get allowedViewTimelineDayLabel => 'allowedViewTimelineDayLabel';

  @override
  String get allowedViewTimelineMonthLabel => 'Cronologia';

  @override
  String get allowedViewTimelineWeekLabel => 'Settimana';

  @override
  String get allowedViewTimelineWorkWeekLabel =>
      'allowedViewTimelineWorkWeekLabel';

  @override
  String get allowedViewWeekLabel => 'Semaine';

  @override
  String get allowedViewWorkWeekLabel => 'allowedViewWorkWeekLabel';

  @override
  String get dhualhiLabel => 'dhualhiLabel';

  @override
  String get dhualqiLabel => 'dhualqiLabel';

  @override
  String get itemsDataPagerLabel => 'itemsDataPagerLabel';

  @override
  String get jumada1Label => 'jumada1Label';

  @override
  String get jumada2Label => 'jumada2Label';

  @override
  String get muharramLabel => 'ofDataPagerLabel';

  @override
  String get ofDataPagerLabel => 'ofDataPagerLabel';

  @override
  String get pagesDataPagerLabel => 'pagesDataPagerLabel';

  @override
  String get pdfBookmarksLabel => 'pdfBookmarksLabel';

  @override
  String get pdfEnterPageNumberLabel => 'pdfEnterPageNumberLabel';

  @override
  String get pdfGoToPageLabel => 'pdfGoToPageLabel';

  @override
  String get pdfInvalidPageNumberLabel => 'pdfInvalidPageNumberLabel';

  @override
  String get pdfNoBookmarksLabel => 'pdfNoBookmarksLabel';

  @override
  String get pdfPaginationDialogCancelLabel => 'pdfPaginationDialogCancelLabel';

  @override
  String get pdfPaginationDialogOkLabel => 'pdfPaginationDialogOkLabel';

  @override
  String get pdfScrollStatusOfLabel => 'pdfScrollStatusOfLabel';

  @override
  String get rabi1Label => 'rabi1Label';

  @override
  String get rabi2Label => 'rabi2Label';

  @override
  String get rajabLabel => 'rajabLabel';

  @override
  String get ramadanLabel => 'ramadanLabel';

  @override
  String get safarLabel => 'safarLabel';

  @override
  String get shaabanLabel => 'shaabanLabel';

  @override
  String get shawwalLabel => 'shawwalLabel';

  @override
  String get shortDhualhiLabel => 'shortDhualhiLabel';

  @override
  String get shortDhualqiLabel => 'shortDhualqiLabel';

  @override
  String get shortJumada1Label => 'shortJumada1Label';

  @override
  String get shortJumada2Label => 'shortJumada2Label';

  @override
  String get shortMuharramLabel => 'shortMuharramLabel';

  @override
  String get shortRabi1Label => 'shortRabi1Label';

  @override
  String get shortRabi2Label => 'shortRabi2Label';

  @override
  String get shortRajabLabel => 'shortRajabLabel';

  @override
  String get shortRamadanLabel => 'shortRamadanLabel';

  @override
  String get shortSafarLabel => 'shortSafarLabel';

  @override
  String get shortShaabanLabel => 'shortShaabanLabel';

  @override
  String get shortShawwalLabel => 'shortShawwalLabel';

  @override
  String get todayLabel => 'todayLabel';

  @override
  // TODO: implement daySpanCountLabel
  String get daySpanCountLabel => '';

  @override
  // TODO: implement allDayLabel
  String get allDayLabel => throw UnimplementedError();

  @override
  // TODO: implement passwordDialogContentLabel
  String get passwordDialogContentLabel => throw UnimplementedError();

  @override
  // TODO: implement passwordDialogHeaderTextLabel
  String get passwordDialogHeaderTextLabel => throw UnimplementedError();

  @override
  // TODO: implement passwordDialogHintTextLabel
  String get passwordDialogHintTextLabel => throw UnimplementedError();

  @override
  // TODO: implement passwordDialogInvalidPasswordLabel
  String get passwordDialogInvalidPasswordLabel => throw UnimplementedError();

  @override
  // TODO: implement pdfPasswordDialogCancelLabel
  String get pdfPasswordDialogCancelLabel => throw UnimplementedError();

  @override
  // TODO: implement pdfPasswordDialogOpenLabel
  String get pdfPasswordDialogOpenLabel => throw UnimplementedError();

  @override
  // TODO: implement rowsPerPageDataPagerLabel
  String get rowsPerPageDataPagerLabel => throw UnimplementedError();

  @override
  // TODO: implement series
  String get series => throw UnimplementedError();

  @override
  // TODO: implement weeknumberLabel
  String get weeknumberLabel => throw UnimplementedError();
}

class SfLocalizationsItDelegate extends LocalizationsDelegate<SfLocalizations> {
  const SfLocalizationsItDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'it';

  @override
  Future<SfLocalizations> load(Locale locale) {
    return SynchronousFuture<SfLocalizations>(SfLocalizationsIt());
  }

  @override
  bool shouldReload(LocalizationsDelegate<SfLocalizations> old) => true;
}
