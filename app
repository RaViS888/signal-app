classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        GridLayout               matlab.ui.container.GridLayout
        LeftPanel                matlab.ui.container.Panel
        UIAxes                   matlab.ui.control.UIAxes
        RightPanel               matlab.ui.container.Panel
        timeSlider               matlab.ui.control.Slider
        timeSliderLabel          matlab.ui.control.Label
        phaseEditField           matlab.ui.control.NumericEditField
        phaseEditFieldLabel      matlab.ui.control.Label
        FrequencyEditField       matlab.ui.control.NumericEditField
        FrequencyEditFieldLabel  matlab.ui.control.Label
        AmplitudeEditField       matlab.ui.control.NumericEditField
        AmplitudeEditFieldLabel  matlab.ui.control.Label
        DropDown                 matlab.ui.control.DropDown
        DropDownLabel            matlab.ui.control.Label
        runButton                matlab.ui.control.Button
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: runButton
        function runButtonPushed(app, event)
            Phase = app.phaseEditField.Value;
            freq = app.FrequencyEditField.Value;
            Ampl =app.AmplitudeEditField.Value;
            T = app.timeSlider.Value;
            time = 0:0.10:T;
          
            switch app.DropDown.Value
                case 'sine'
                    Volt = Ampl*sin(2*pi*freq*time+Phase);
                    plot(app.UIAxes, time, Volt);     
                case 'square'
                    offset=0;
                    duty=50;
                    sq_wav=offset+Ampl*square(2*pi*freq*time,duty);
                    plot(app.UIAxes, time, sq_wav);
                case 'triangle'
                    plot(app.UIAxes, time, Ampl*sawtooth(2*pi*freq*time,1/2)); 
                case 'sawtooth'
                    plot(app.UIAxes, time, Ampl*sawtooth(2*pi*freq*time));
            end          
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {413, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {413, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create UIAxes
            app.UIAxes = uiaxes(app.LeftPanel);
            title(app.UIAxes, 'Waveform')
            xlabel(app.UIAxes, 'TIME')
            ylabel(app.UIAxes, 'AMPLITUDE')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [20 172 385 263];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create runButton
            app.runButton = uibutton(app.RightPanel, 'push');
            app.runButton.ButtonPushedFcn = createCallbackFcn(app, @runButtonPushed, true);
            app.runButton.Position = [78 180 100 22];
            app.runButton.Text = 'run';

            % Create DropDownLabel
            app.DropDownLabel = uilabel(app.RightPanel);
            app.DropDownLabel.Position = [24 413 65 22];
            app.DropDownLabel.Text = 'Drop Down';

            % Create DropDown
            app.DropDown = uidropdown(app.RightPanel);
            app.DropDown.Items = {'sine', 'square', 'triangle', 'sawtooth', 'Option 4'};
            app.DropDown.Position = [104 413 89 22];
            app.DropDown.Value = 'sine';

            % Create AmplitudeEditFieldLabel
            app.AmplitudeEditFieldLabel = uilabel(app.RightPanel);
            app.AmplitudeEditFieldLabel.Position = [21 371 58 22];
            app.AmplitudeEditFieldLabel.Text = 'Amplitude';

            % Create AmplitudeEditField
            app.AmplitudeEditField = uieditfield(app.RightPanel, 'numeric');
            app.AmplitudeEditField.Position = [94 371 100 22];

            % Create FrequencyEditFieldLabel
            app.FrequencyEditFieldLabel = uilabel(app.RightPanel);
            app.FrequencyEditFieldLabel.Position = [17 330 62 22];
            app.FrequencyEditFieldLabel.Text = 'Frequency';

            % Create FrequencyEditField
            app.FrequencyEditField = uieditfield(app.RightPanel, 'numeric');
            app.FrequencyEditField.Position = [94 330 100 22];

            % Create phaseEditFieldLabel
            app.phaseEditFieldLabel = uilabel(app.RightPanel);
            app.phaseEditFieldLabel.Position = [21 294 38 22];
            app.phaseEditFieldLabel.Text = 'phase';

            % Create phaseEditField
            app.phaseEditField = uieditfield(app.RightPanel, 'numeric');
            app.phaseEditField.Position = [94 294 100 22];

            % Create timeSliderLabel
            app.timeSliderLabel = uilabel(app.RightPanel);
            app.timeSliderLabel.HorizontalAlignment = 'right';
            app.timeSliderLabel.Position = [24 256 28 22];
            app.timeSliderLabel.Text = 'time';

            % Create timeSlider
            app.timeSlider = uislider(app.RightPanel);
            app.timeSlider.Limits = [0 10];
            app.timeSlider.Position = [73 265 130 3];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1

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
