require "selenium-webdriver"
require 'csv'

class Companies_insurance_list_scraper
    def initialize(zip_code)
        @zip_code = zip_code.to_s
    end

    def scrape
        driver = Selenium::WebDriver.for :chrome
        driver.read_timeout = 240
        driver.navigate.to "https://interactive.web.insurance.ca.gov/apex_extprd/f?p=400:50"
        element = driver.find_element(:id, "P50_ZIP")
        element.send_keys @zip_code
        btnSubmit = driver.find_element(:id, "B66921415930572593")
        btnSubmit.click
        sleep 6
        pages = driver.find_element(:class, "t-Report-paginationText").text.split("of").last.strip.to_i / 5
        CSV.open("List insurance companies.csv", "a+") do |csv|
            csv << ["Company Name", "Phone", "Website", "ZIP"]
        pages.ceil.times do
            driver.find_elements(xpath: "//*[@id='report_R251401784479545440']/div/div[1]/table/tbody/tr").each.with_index(1) do |_,index|
                driver.find_elements(:xpath, "//*[@id='report_R251401784479545440']/div/div[1]/table/tbody/tr[#{index}]/td[1]").each do |td|
                    value = td.text.gsub("Company Profile", "")
                    row = value.split("\n")
                        csv << [row[0], row[1], row[2], @zip_code]
                    end
                end
                begin
                    if driver.find_element(:xpath, "//*[@id='report_R251401784479545440']/div/table[2]/tbody/tr/td/table/tbody/tr/td[4]/a").displayed?
                        nextBtn = driver.find_element(:xpath, "//*[@id='report_R251401784479545440']/div/table[2]/tbody/tr/td/table/tbody/tr/td[4]/a")
                        nextBtn.click
                    end
                rescue => exception
                    puts "No more pages"
                end
                sleep 3
            end
        end
    end
end