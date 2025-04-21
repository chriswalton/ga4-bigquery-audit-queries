// utils/constants.js

/**
 * Project-wide constants and config options.
 * These are optional reference lists used in assertions and reports.
 */

module.exports = {
    knownValidBrowsers: [
      "Chrome",
      "Safari",
      "Firefox",
      "Edge",
      "Samsung Internet",
      "Internet Explorer"
    ],
    requiredEcommerceParams: [
      "transaction_id",
      "item_id",
      "item_name",
      "currency",
      "price",
      "quantity"
    ],
    allowedConsentStates: ["granted", "denied", "unset"]
  };
  