require "selenium-webdriver"
require 'csv'


driver = Selenium::WebDriver.for :chrome
zip_array = %i[90023]
zip_array.each do |zip|
driver.navigate.to "https://nmlsconsumeraccess.org/Home.aspx/SubSearch?searchText=#{zip}"
    begin
        if driver.find_element(:id, "ctl00_MainContent_cbxAgreeToTerms").displayed?
            driver.find_element(:id, "ctl00_MainContent_cbxAgreeToTerms").click
            sleep 10
            filter_total = driver.find_element(:id, "filterTotal").text.split(" ").first.to_i
            puts filter_total
            # table = driver.find_element(:id, "searchResults")

            header = driver.find_elements(:class, "individual")
            # individuals = driver.find_elements(:class, "individual")
            header.length.times do |i|
                puts header[i].text
                header[i].click
                sleep 1
                back = driver.find_element(:xpath, "//*[@id='jsContentWrapper']/div[1]/div[1]/a")
                back.click
                next

            end



            
        #    header.each do |h|
        #         # puts h.text.split("\n").first.strip.to_s
        #         puts 1
        #         h.click
        #         sleep 2
        #         driver.back()
        #         puts 2
        #     end
            

        #    header.each do |h|
        #         puts h.click
        #         sleep 5
        #         sleep 5
        #    end


        end
    rescue => exception
        # sleep 2
        # filter_total = driver.find_element(:id, "filterTotal").text.split(" ").first.to_i
        # puts filter_total
        # table = driver.find_element(:id, "searchResults")
        # puts table.text 
    end
end





        
