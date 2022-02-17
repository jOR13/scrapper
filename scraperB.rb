require "selenium-webdriver"
require 'csv'

class Brokers_insurance_list_scraper
    def initialize(zip_code)
        @zip_code = zip_code.to_s
    end

    def scrape
        driver = Selenium::WebDriver.for :chrome
        driver.navigate.to "https://interactive.web.insurance.ca.gov/apex_extprd/f?p=400:50"
        element = driver.find_element(:id, "P50_ZIP")
        element.send_keys @zip_code
        btnSubmit = driver.find_element(:id, "B66921782583572594")
        btnSubmit.click
        sleep 25
        begin
            if driver.find_element(:class, "a-IRR-pagination-label").displayed?
                pages = driver.find_element(:class, "a-IRR-pagination-label").text.split("of").last.strip.to_i / 5
                CSV.open("List insurance brokers.csv", "a+") do |csv|
                    csv << ["Broker Name", "Address", "Phone", "ZIP"]
                    pages.times do
                        driver.find_elements(xpath: "//*[@id='164011617385680979_orig']/tbody/tr").each.with_index(2) do |_,index|
                            driver.find_elements(:xpath, "//*[@id='164011617385680979_orig']/tbody/tr[#{index}]/td[2]").each do |td|
                                value = td.text
                                row = value.split("\n")
                                csv << [row[0], row[1], row[2], @zip_code]
                            end
                        end
                        begin
                            if driver.find_element(:xpath, "//*[@id='R164011470624680978_data_panel']/div[2]/ul/li[3]/button").displayed?
                                nextBtn = driver.find_element(:xpath, "//*[@id='R164011470624680978_data_panel']/div[2]/ul/li[3]/button")
                                nextBtn.click
                            end
                        rescue => exception
                            puts "No more pages"
                        end
                        sleep 3
                    end
                end
            end
        rescue => exception
            puts "No data loaded"
        end
     
    end
end