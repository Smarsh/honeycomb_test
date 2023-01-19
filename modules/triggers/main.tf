data "honeycombio_query_specification" "query_spec" {
  calculation {
    op     = "COUNT"
  }

  filter {
    column = "library.name"
    op     = "="
    value = "com.smarsh"
  }

  filter {
    column = "span.kind"
    op     = "="
    value = "internal"
  }

  filter_combination = "AND"
  time_range = 1800
}

resource "honeycombio_query" "query" {
  dataset    = var.dataset
  query_json = data.honeycombio_query_specification.query_spec.json
}


data "honeycombio_recipient" "slack" {
  type    = "slack"

  detail_filter {
    name  = "channel"
    value = "#cc-analysis-based-alerts"
  }
}

resource "honeycombio_trigger" "trigger" {
  name        = "[TERRAFORM][RTRA] Test custom trace count"
  description = "Custom trace count"

  query_id = honeycombio_query.query.id
  dataset  = var.dataset

  frequency = 600 // in seconds, 10 minutes

  alert_type = "on_change" // on_change is default, on_true can refers to the "Alert on True" checkbox in the UI

  threshold {
    op    = ">"
    value = 1
  }

  # zero or more recipients
  recipient {
    id = data.honeycombio_recipient.slack.id
  }
}