## code to prepare `request` dataset goes here
req_body <- "{\"regionalTotals\":true,\"currencyFY\":true,\"currencyCY\":true,\"constantUSD\":true,\"currentUSD\":true,\"shareOfGDP\":true,\"perCapita\":true,\"shareGovt\":true,\"regionDataDetails\":false,\"getLiveData\":false,\"yearFrom\":null,\"yearTo\":null,\"yearList\":[1949,2050],\"countryList\":[\"Afghanistan\",\"Albania\",\"Algeria\",\"Angola\",\"Argentina\",\"Armenia\",\"Australia\",\"Austria\",\"Azerbaijan\",\"Bahrain\",\"Bangladesh\",\"Belarus\",\"Belgium\",\"Belize\",\"Benin\",\"Bolivia\",\"Bosnia and Herzegovina\",\"Botswana\",\"Brazil\",\"Brunei\",\"Bulgaria\",\"Burkina Faso\",\"Burundi\",\"Cambodia\",\"Cameroon\",\"Canada\",\"Cape Verde\",\"Central African Republic\",\"Chad\",\"Chile\",\"China\",\"Colombia\",\"Congo, DR\",\"Congo, Republic\",\"Costa Rica\",\"Cote d'Ivoire\",\"Croatia\",\"Cuba\",\"Cyprus\",\"Czechia\",\"Czechoslovakia\",\"Denmark\",\"Djibouti\",\"Dominican Republic\",\"Ecuador\",\"Egypt\",\"El Salvador\",\"Equatorial Guinea\",\"Eritrea\",\"Estonia\",\"Eswatini\",\"Ethiopia\",\"European Union\",\"Fiji\",\"Finland\",\"France\",\"Gabon\",\"Gambia, The\",\"Georgia\",\"German Democratic Republic\",\"Germany\",\"Ghana\",\"Greece\",\"Guatemala\",\"Guinea\",\"Guinea-Bissau\",\"Guyana\",\"Haiti\",\"Honduras\",\"Hungary\",\"Iceland\",\"India\",\"Indonesia\",\"Iran\",\"Iraq\",\"Ireland\",\"Israel\",\"Italy\",\"Jamaica\",\"Japan\",\"Jordan\",\"Kazakhstan\",\"Kenya\",\"Korea, North\",\"Korea, South\",\"Kosovo\",\"Kuwait\",\"Kyrgyz Republic\",\"Laos\",\"Latvia\",\"Lebanon\",\"Lesotho\",\"Liberia\",\"Libya\",\"Lithuania\",\"Luxembourg\",\"Madagascar\",\"Malawi\",\"Malaysia\",\"Mali\",\"Malta\",\"Mauritania\",\"Mauritius\",\"Mexico\",\"Moldova\",\"Mongolia\",\"Montenegro\",\"Morocco\",\"Mozambique\",\"Myanmar\",\"Namibia\",\"Nepal\",\"Netherlands\",\"New Zealand\",\"Nicaragua\",\"Niger\",\"Nigeria\",\"North Macedonia\",\"Norway\",\"Oman\",\"Pakistan\",\"Panama\",\"Papua New Guinea\",\"Paraguay\",\"Peru\",\"Philippines\",\"Poland\",\"Portugal\",\"Qatar\",\"Romania\",\"Russia\",\"Rwanda\",\"Saudi Arabia\",\"Senegal\",\"Serbia\",\"Seychelles\",\"Sierra Leone\",\"Singapore\",\"Slovakia\",\"Slovenia\",\"Somalia\",\"South Africa\",\"South Sudan\",\"Spain\",\"Sri Lanka\",\"Sudan\",\"Sweden\",\"Switzerland\",\"Syria\",\"Taiwan\",\"Tajikistan\",\"Tanzania\",\"Thailand\",\"Timor Leste\",\"Togo\",\"Trinidad and Tobago\",\"Tunisia\",\"Turkmenistan\",\"Türkiye\",\"USSR\",\"Uganda\",\"Ukraine\",\"United Arab Emirates\",\"United Kingdom\",\"United States of America\",\"Uruguay\",\"Uzbekistan\",\"Venezuela\",\"Viet Nam\",\"Yemen\",\"Yemen, North\",\"Yugoslavia\",\"Zambia\",\"Zimbabwe\"]}"

xlsx_config <- dplyr::tribble(
  ~sheet_name, ~unit,~skip,~indicator,
  "Constant (2022) US$", 2, 5,'constantUSD',
  "Current US$", 2, 5,'currentUSD',
  "Share of GDP", 1, 5,'shareOfGDP',
  "Share of Govt. spending", 3, 7,'shareGovt',
  "Regional totals", 2, 13,'regionalTotals',
  "Local currency financial years", 2, 7,'currencyFY',
  "Local currency calendar years", 2, 6,'currencyCY',
  "Per capita", 2, 6,'perCapita')

usethis::use_data(xlsx_config,req_body, overwrite = TRUE, internal = TRUE)


