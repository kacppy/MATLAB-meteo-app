classdef matlab_meteo_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        CzyjestsenswtymtygodniuwstazkaButton  matlab.ui.control.Button
        CzyjestsensdziwstazkaButton  matlab.ui.control.Button
        ListBox                      matlab.ui.control.ListBox
        PodajmiastoTextArea          matlab.ui.control.TextArea
        PodajmiastoTextAreaLabel     matlab.ui.control.Label
        SearchButton                 matlab.ui.control.Button
    end

    properties (Access = private)

    globaldata=[]
    apikey = '<PASS_YOUR_API_KEY_HERE>'

    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SearchButton
        function SearchButtonPushed(app, event)
            num_letters = length(regexpi(string(app.PodajmiastoTextArea.Value), '[a-zA-Z]'));
            app.ListBox.Items = {'Szukam miasta...'};
            pause(0.01);
            
            if (num_letters > 3)
               cities_table = readtable('miasta.csv');
               matching_indices = contains(lower(cities_table{:, 1}), lower(app.PodajmiastoTextArea.Value));
               matching_cities = cities_table(matching_indices, :);
               matching_cities_names = table2array(matching_cities(:, 1));
               app.globaldata = [matching_cities];
               app.ListBox.Items = matching_cities_names;
            else
                app.ListBox.Items = {'Podaj więcej niż 3 znaki'};
            end

        end

        % Value changed function: ListBox
        function ListBoxValueChanged(app, event)

        end

        % Button pushed function: CzyjestsensdziwstazkaButton
        function CzyjestsensdziwstazkaButtonPushed(app, event)
            selected_location = app.ListBox.Value;
            all_locations_data = app.globaldata;
            num_rows = height(all_locations_data);
            
            for i = 1:num_rows
                if (string(all_locations_data{i, 1}) == selected_location)
                    lat = all_locations_data{i, 2};
                    lon = all_locations_data{i, 3};
                    break;
                end
            end
            
            weather_api_url = "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&appid="+app.apikey+"&lang=pl&units=metric";
            weather_data = webread(weather_api_url);
            weather_details = struct2cell(weather_data.weather);
            
            fig = uifigure('Name','Aktualna Pogoda ');
            fig.Color = '#CCCCFF'; 
            
            weather_status = uilabel(fig, 'Position', [200 375 211 25]);
            pressure = uilabel(fig, 'Position', [200 350 211 25]);
            temperature = uilabel(fig, 'Position', [200 325 211 25]);
            feels_like_temperature = uilabel(fig, 'Position', [200 300 211 25]);
            wind_speed = uilabel(fig, 'Position', [200 275 211 25]);
            cloudiness = uilabel(fig, 'Position', [200 250 211 25]);
            
            icon_url = "http://openweathermap.org/img/wn/" + weather_data.weather.icon + "@4x.png";
            axes = uiaxes(fig, 'Position', [0 200 200 250]);
            [icon_data, ~, icon_alpha] = imread(icon_url);
            image(icon_data, "AlphaData", icon_alpha, "Parent", axes);
            disableDefaultInteractivity(axes);
            axes.Visible = "off";
            
            weather_status.Text = string("Dziś jest: " + weather_details{3, 1});
            pressure.Text = string("Ciśnienie: " + weather_data.main.pressure + " hPa");
            temperature.Text = string("Temperatura: " + weather_data.main.temp + " °C");
            feels_like_temperature.Text = string("Temperatura odczuwalna: " + weather_data.main.feels_like + " °C");
            wind_speed.Text = string("Wiatr: " + weather_data.wind.speed + " m/s");
            cloudiness.Text = string("Zachmurzenie: " + weather_data.clouds.all + " %");

        end

        % Button pushed function: CzyjestsenswtymtygodniuwstazkaButton
        function CzyjestsenswtymtygodniuwstazkaButtonPushed(app, event)
            selected_city = app.ListBox.Value;
            city_data = app.globaldata;
            num_rows = height(city_data);
            
            for row = 1:num_rows
                if string(city_data{row, 1}) == selected_city
                   latitude = city_data{row, 2};
                   longitude = city_data{row, 3};
                   break;
                end
            end
            
            data_url = "https://api.openweathermap.org/data/2.5/forecast?lat="+latitude+"&lon="+longitude+"&appid="+app.apikey+"&lang=pl&units=metric";
            web_data = webread(data_url);
            
            num_forecasts = height(web_data.list);
            for i = 1:num_forecasts
                temperatures{i} = web_data.list{i,1}.main.temp;
                pressures{i} = web_data.list{i,1}.main.pressure;
                humidities{i} = web_data.list{i,1}.main.humidity;
                precipitation_probabilities{i} = web_data.list{i,1}.pop;
                date_times{i} = datetime(web_data.list{i, 1}.dt_txt);
            end
            
            temperatures_array = [temperatures{:}];
            pressures_array = [pressures{:}];
            humidities_array = [humidities{:}];
            precipitation_probabilities_array = [precipitation_probabilities{:}];
            dates_array = [date_times{:}];
            
            subplot(2,2,1);
            plot(dates_array, temperatures_array);
            xlabel('Data i godzina');
            ylabel('Temperatura [ ℃ ]');
            zoom xon;
            
            subplot(2,2,2); 
            plot(dates_array, pressures_array);
            xlabel('Data i godzina');
            ylabel('Ciśnienie [hPa ]');
            zoom xon;
            
            subplot(2,2,3); 
            plot(dates_array, humidities_array);
            xlabel('Data i godzina');
            ylabel('Wilgotność [ % ]');
            zoom xon;
            
            subplot(2,2,4); 
            plot(dates_array, precipitation_probabilities_array);
            xlabel('Data i godzina');
            ylabel('Szansa opadów');
            zoom xon;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 578 245];
            app.UIFigure.Name = 'MATLAB App';

            % Create SearchButton
            app.SearchButton = uibutton(app.UIFigure, 'push');
            app.SearchButton.ButtonPushedFcn = createCallbackFcn(app, @SearchButtonPushed, true);
            app.SearchButton.Position = [394 175 100 27];
            app.SearchButton.Text = 'Search';

            % Create PodajmiastoTextAreaLabel
            app.PodajmiastoTextAreaLabel = uilabel(app.UIFigure);
            app.PodajmiastoTextAreaLabel.HorizontalAlignment = 'right';
            app.PodajmiastoTextAreaLabel.Position = [75 177 75 22];
            app.PodajmiastoTextAreaLabel.Text = 'Podaj miasto';

            % Create PodajmiastoTextArea
            app.PodajmiastoTextArea = uitextarea(app.UIFigure);
            app.PodajmiastoTextArea.Position = [165 176 211 25];

            % Create ListBox
            app.ListBox = uilistbox(app.UIFigure);
            app.ListBox.Items = {};
            app.ListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChanged, true);
            app.ListBox.Position = [165 107 211 54];
            app.ListBox.Value = {};

            % Create CzyjestsensdziwstazkaButton
            app.CzyjestsensdziwstazkaButton = uibutton(app.UIFigure, 'push');
            app.CzyjestsensdziwstazkaButton.ButtonPushedFcn = createCallbackFcn(app, @CzyjestsensdziwstazkaButtonPushed, true);
            app.CzyjestsensdziwstazkaButton.WordWrap = 'on';
            app.CzyjestsensdziwstazkaButton.Position = [165 24 100 54];
            app.CzyjestsensdziwstazkaButton.Text = 'Czy jest sens dziś wstać z łóżka?';

            % Create CzyjestsenswtymtygodniuwstazkaButton
            app.CzyjestsenswtymtygodniuwstazkaButton = uibutton(app.UIFigure, 'push');
            app.CzyjestsenswtymtygodniuwstazkaButton.ButtonPushedFcn = createCallbackFcn(app, @CzyjestsenswtymtygodniuwstazkaButtonPushed, true);
            app.CzyjestsenswtymtygodniuwstazkaButton.WordWrap = 'on';
            app.CzyjestsenswtymtygodniuwstazkaButton.Position = [276 24 100 54];
            app.CzyjestsenswtymtygodniuwstazkaButton.Text = 'Czy jest sens w tym tygodniu wstać z łóżka?';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = matlab_meteo_app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end