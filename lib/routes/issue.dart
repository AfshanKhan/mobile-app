import 'package:flutter/material.dart';
import 'package:support_app/utils/helpers.dart';
import 'package:support_app/widgets/form_view.dart';
import 'package:support_app/widgets/filter_list.dart';
import 'package:support_app/widgets/list_view.dart';

Map wireframe = {
  "doctype": "Issue",
  "subject_field": "subject",
  "fields": [
    {
      "header": "header",
      "fieldtype": "Link",
      "refDoctype": 'Issue',
      "hint": 'Issue Type',
      "doctype": 'Issue Type',
      "fieldname": 'issue_type',
      "in_standard_filter": true,
      "hidden": false
    },
    {
      "header": "header",
      "fieldtype": "Link",
      "refDoctype": 'Issue',
      "hint": 'Issue Priority',
      "doctype": 'Issue Priority',
      "fieldname": 'priority',
      "hidden": false
    },
    {
      "header": "header",
      "fieldtype": "Select",
      "hint": 'Issues Found In',
      "fieldname": 'module',
      "is_custom_field": 1,
      "hidden": false
    },
    {
      "header": "header",
      "fieldtype": "Select",
      "fieldname": 'agreement_fulfilled',
      "hint": "SLA",
      "hidden": false
    },
    {"header": "header", "fieldname": 'name', "in_list_view": true},
    {
      "header": "header",
      "fieldtype": "Select",
      "fieldname": 'status',
      "hint": "Issue Status",
      "in_list_view": true,
      "hidden": false
    },
    {
      "header": "header",
      "fieldname": 'subject',
      "in_list_view": true
    },
    {"header": "header", "fieldname": 'raised_by', "in_list_view": true},
    {"header": "header", "fieldname": '_comments', "in_list_view": true},
  ]
};

class IssueDetail extends StatefulWidget {
  final String name;

  const IssueDetail(this.name);

  @override
  _IssueDetailState createState() => _IssueDetailState();
}

class _IssueDetailState extends State<IssueDetail> {
  Future futureProcessedData;

  @override
  void initState() {
    super.initState();
    futureProcessedData = processData(wireframe, true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureProcessedData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FormView(
              app_bar_title: 'Issue Form',
              doctype: 'Issue',
              name: widget.name,
              wireframe: wireframe,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        });
  }
}

class FilterIssue extends StatefulWidget {
  @override
  _FilterIssueState createState() => _FilterIssueState();
}

class _FilterIssueState extends State<FilterIssue> {
  Future futureProcessedData;

  @override
  void initState() {
    super.initState();
    futureProcessedData = processData(wireframe, true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureProcessedData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FilterList(
              app_bar_title: 'Filter Issue',
              filterCallback: (f) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return IssueList(filters: f);
                }));
              },
              wireframe: wireframe,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Center(child: CircularProgressIndicator());
        });
  }
}

class IssueList extends StatefulWidget {
  final filters;

  IssueList({this.filters});
  @override
  _IssueListState createState() => _IssueListState();
}

class _IssueListState extends State<IssueList> {
  Future futureProcessedData;

  @override
  void initState() {
    super.initState();
    futureProcessedData = processData(wireframe, false);
  }

  Future fetchData() async {
    futureProcessedData = processData(wireframe, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: FutureBuilder(
      future: futureProcessedData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomListView(
            app_bar_title: 'Issue List',
            doctype: 'Issue',
            fieldnames: wireframe["fieldnames"],
            filters: widget.filters,
            wireframe: wireframe,
            filterCallback: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FilterIssue();
              }));
            },
            detailCallback: (f) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return IssueDetail(f);
              }));
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      }),
    );
  }
}
