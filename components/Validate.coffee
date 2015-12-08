noflo = require 'noflo'
_ = require 'underscore'
moment = require 'moment'
validateId = require 'uuid-validate'
{ExtendedComponent} = require '../src/Finance.coffee'

currencies = JSON.parse('{
  "AED": "United Arab Emirates Dirham",
  "AFN": "Afghan Afghani",
  "ALL": "Albanian Lek",
  "AMD": "Armenian Dram",
  "ANG": "Netherlands Antillean Guilder",
  "AOA": "Angolan Kwanza",
  "ARS": "Argentine Peso",
  "AUD": "Australian Dollar",
  "AWG": "Aruban Florin",
  "AZN": "Azerbaijani Manat",
  "BAM": "Bosnia-Herzegovina Convertible Mark",
  "BBD": "Barbadian Dollar",
  "BDT": "Bangladeshi Taka",
  "BGN": "Bulgarian Lev",
  "BHD": "Bahraini Dinar",
  "BIF": "Burundian Franc",
  "BMD": "Bermudan Dollar",
  "BND": "Brunei Dollar",
  "BOB": "Bolivian Boliviano",
  "BRL": "Brazilian Real",
  "BSD": "Bahamian Dollar",
  "BTC": "Bitcoin",
  "BTN": "Bhutanese Ngultrum",
  "BWP": "Botswanan Pula",
  "BYR": "Belarusian Ruble",
  "BZD": "Belize Dollar",
  "CAD": "Canadian Dollar",
  "CDF": "Congolese Franc",
  "CHF": "Swiss Franc",
  "CLF": "Chilean Unit of Account (UF)",
  "CLP": "Chilean Peso",
  "CNY": "Chinese Yuan",
  "COP": "Colombian Peso",
  "CRC": "Costa Rican Colón",
  "CUC": "Cuban Convertible Peso",
  "CUP": "Cuban Peso",
  "CVE": "Cape Verdean Escudo",
  "CZK": "Czech Republic Koruna",
  "DJF": "Djiboutian Franc",
  "DKK": "Danish Krone",
  "DOP": "Dominican Peso",
  "DZD": "Algerian Dinar",
  "EEK": "Estonian Kroon",
  "EGP": "Egyptian Pound",
  "ERN": "Eritrean Nakfa",
  "ETB": "Ethiopian Birr",
  "EUR": "Euro",
  "FJD": "Fijian Dollar",
  "FKP": "Falkland Islands Pound",
  "GBP": "British Pound Sterling",
  "GEL": "Georgian Lari",
  "GGP": "Guernsey Pound",
  "GHS": "Ghanaian Cedi",
  "GIP": "Gibraltar Pound",
  "GMD": "Gambian Dalasi",
  "GNF": "Guinean Franc",
  "GTQ": "Guatemalan Quetzal",
  "GYD": "Guyanaese Dollar",
  "HKD": "Hong Kong Dollar",
  "HNL": "Honduran Lempira",
  "HRK": "Croatian Kuna",
  "HTG": "Haitian Gourde",
  "HUF": "Hungarian Forint",
  "IDR": "Indonesian Rupiah",
  "ILS": "Israeli New Sheqel",
  "IMP": "Manx pound",
  "INR": "Indian Rupee",
  "IQD": "Iraqi Dinar",
  "IRR": "Iranian Rial",
  "ISK": "Icelandic Króna",
  "JEP": "Jersey Pound",
  "JMD": "Jamaican Dollar",
  "JOD": "Jordanian Dinar",
  "JPY": "Japanese Yen",
  "KES": "Kenyan Shilling",
  "KGS": "Kyrgystani Som",
  "KHR": "Cambodian Riel",
  "KMF": "Comorian Franc",
  "KPW": "North Korean Won",
  "KRW": "South Korean Won",
  "KWD": "Kuwaiti Dinar",
  "KYD": "Cayman Islands Dollar",
  "KZT": "Kazakhstani Tenge",
  "LAK": "Laotian Kip",
  "LBP": "Lebanese Pound",
  "LKR": "Sri Lankan Rupee",
  "LRD": "Liberian Dollar",
  "LSL": "Lesotho Loti",
  "LTL": "Lithuanian Litas",
  "LVL": "Latvian Lats",
  "LYD": "Libyan Dinar",
  "MAD": "Moroccan Dirham",
  "MDL": "Moldovan Leu",
  "MGA": "Malagasy Ariary",
  "MKD": "Macedonian Denar",
  "MMK": "Myanma Kyat",
  "MNT": "Mongolian Tugrik",
  "MOP": "Macanese Pataca",
  "MRO": "Mauritanian Ouguiya",
  "MTL": "Maltese Lira",
  "MUR": "Mauritian Rupee",
  "MVR": "Maldivian Rufiyaa",
  "MWK": "Malawian Kwacha",
  "MXN": "Mexican Peso",
  "MYR": "Malaysian Ringgit",
  "MZN": "Mozambican Metical",
  "NAD": "Namibian Dollar",
  "NGN": "Nigerian Naira",
  "NIO": "Nicaraguan Córdoba",
  "NOK": "Norwegian Krone",
  "NPR": "Nepalese Rupee",
  "NZD": "New Zealand Dollar",
  "OMR": "Omani Rial",
  "PAB": "Panamanian Balboa",
  "PEN": "Peruvian Nuevo Sol",
  "PGK": "Papua New Guinean Kina",
  "PHP": "Philippine Peso",
  "PKR": "Pakistani Rupee",
  "PLN": "Polish Zloty",
  "PYG": "Paraguayan Guarani",
  "QAR": "Qatari Rial",
  "RON": "Romanian Leu",
  "RSD": "Serbian Dinar",
  "RUB": "Russian Ruble",
  "RWF": "Rwandan Franc",
  "SAR": "Saudi Riyal",
  "SBD": "Solomon Islands Dollar",
  "SCR": "Seychellois Rupee",
  "SDG": "Sudanese Pound",
  "SEK": "Swedish Krona",
  "SGD": "Singapore Dollar",
  "SHP": "Saint Helena Pound",
  "SLL": "Sierra Leonean Leone",
  "SOS": "Somali Shilling",
  "SRD": "Surinamese Dollar",
  "STD": "São Tomé and Príncipe Dobra",
  "SVC": "Salvadoran Colón",
  "SYP": "Syrian Pound",
  "SZL": "Swazi Lilangeni",
  "THB": "Thai Baht",
  "TJS": "Tajikistani Somoni",
  "TMT": "Turkmenistani Manat",
  "TND": "Tunisian Dinar",
  "TOP": "Tongan Paʻanga",
  "TRY": "Turkish Lira",
  "TTD": "Trinidad and Tobago Dollar",
  "TWD": "New Taiwan Dollar",
  "TZS": "Tanzanian Shilling",
  "UAH": "Ukrainian Hryvnia",
  "UGX": "Ugandan Shilling",
  "USD": "United States Dollar",
  "UYU": "Uruguayan Peso",
  "UZS": "Uzbekistan Som",
  "VEF": "Venezuelan Bolívar Fuerte",
  "VND": "Vietnamese Dong",
  "VUV": "Vanuatu Vatu",
  "WST": "Samoan Tala",
  "XAF": "CFA Franc BEAC",
  "XAG": "Silver (troy ounce)",
  "XAU": "Gold (troy ounce)",
  "XCD": "East Caribbean Dollar",
  "XDR": "Special Drawing Rights",
  "XOF": "CFA Franc BCEAO",
  "XPD": "Palladium Ounce",
  "XPF": "CFP Franc",
  "XPT": "Platinum Ounce",
  "YER": "Yemeni Rial",
  "ZAR": "South African Rand",
  "ZMK": "Zambian Kwacha (pre-2013)",
  "ZMW": "Zambian Kwacha",
  "ZWL": "Zimbabwean Dollar"
}')

# 422 - ujnprocessable entity
# 415 - unsupported media type
class Validate extends ExtendedComponent
  description: 'Validate income from xpress request.'
  icon: 'filter'

  currency: (currency) ->
    unless _.isString(currency) and _.contains Object.keys(currencies), currency.toUpperCase()
      @errors.push
        key: 'currency'
        error: "currency `#{currency}` was not a valid currency."

  amount: (amount) ->
    unless parseInt(amount) >= 0
      @errors.push
        key: 'amount'
        error: "amount `#{amount}`is not at least 0."

  datePart: (part) ->
    unless parseInt(part) >= 0
      @errors.push
        key: 'datePart'
        error: "datePart `#{part}`is not at least 0."

  date: (dateAndOrTime) ->
    return if _.isFinite dateAndOrTime
    try
      d = new Date(dateAndOrTime)
    catch e
      return @errors.push
        key: 'date'
        error: "created_at|date `#{dateAndOrTime}`is not a valid date. " + e.message

    unless moment(d).isValid()
      @errors.push
        key: 'date'
        error: "created_at|date `#{dateAndOrTime}`is not a valid date."

  descriptions: (descriptions) -> #xss?

  tags: (tags) ->
    unless _.isArray(tags) or _.isString(tags)
      @errors.push
        key: 'tags'
        error: "tags `#{tags}` were not valid"

  idv: (id) ->
    unless validateId id
      @errors.push
        key: 'id'
        error: "id `#{id}` is not a valid id"

  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'object'
        description: 'Object being Validated'

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
        required: true
      error:
        datatype: 'object'
        description: 'sent through the error port if not valid.'

    # passing in Req
    @inPorts.in.on 'data', (data) =>
      @errors = []

      # _.isObject(data.query)
      # @TODO: error if it doesn't have .id
      # if its params, it should be the only one
      # if it uses * (such as in list) params has a 0 key
      pKeys = Object.keys data.params
      if pKeys.length > 0 and pKeys[0] isnt '0'
        @idv data.params.id

      # if its a query, that means date or tag
      if Object.keys(data.query).length > 0
        query = data.query

        if query.month? and query.year?
          @datePart query.month
          @datePart query.year
        else if query.date?
          @date query.date
        else if query.start?
          @date query.start
          @date query.end
        else if query.tags?
          @tags query.tags
        else if query.tag?
          @tags query.tag
        else
          @errors.push
            key: 'query'
            error: "query `#{query}` did not contain supported media-types"
            data: data

      if Object.keys(data.body).length > 0
        body = data.body
        @amount body.amount
        @currency body.currency
        @date body.created_at if body.created_at?
        @descriptions body.descriptions if body.descriptions?
        @tags body.tags if body.tags?

        # IF IT IS UPDATE, IT REQUIRES ID... check the req.path.contains?
        @idv body.id if body.id?

      if @errors.length > 0
        @error
          errors: @errors
          req: data
      else
        @sendThenDiscon data

exports.getComponent = -> new Validate
