//
//  WeatherMainView.swift
//  Weather
//
//  Created by Rimo Tech  on 4/30/23.
//

import SwiftUI

struct WeatherMainView: View {
    @ObservedObject var viewModel: WeatherViewModel

        var body: some View {
            NavigationStack {
                if let model = viewModel.weatherDataModel {
                    CurrentWeatherView(weatherData: model)
                        .redacted(reason: viewModel.isLoading ? .placeholder : [])
                } else if !viewModel.errorMessage.isEmpty {
                    ErrorMessageView(message: viewModel.errorMessage,
                                     systemImage: "ladybug")
                    .redacted(reason: viewModel.isLoading ? .placeholder : [])
                } else {
                    ErrorMessageView(message: "No city found.\n Please search a city",
                                     systemImage: "location")
                    .redacted(reason: viewModel.isLoading ? .placeholder : [])
                }
                
                Spacer()
                    .navigationTitle("Weather")
            }
            .searchable( text: $viewModel.city, prompt: "Search a City")
        }
}

struct WeatherMainView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView(viewModel: WeatherViewModel(weatherFetcher: WeatherDataFetcher()))
    }
}

struct CurrentWeatherView: View  {

    var weatherData: WeatherModel

    var body: some View {
        VStack() {
            Text("City: \(weatherData.name)")
            .font(.title)
            .foregroundColor(.gray)
            .bold()
            .padding(.top, 20)
            
            HStack{
                Text(String(format: "%.1f", weatherData.main.temp) + "° F")
                    .fontWeight(Font.Weight.heavy)
                    .font(.system(size: 45))
            }.padding()
            
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather.first?.icon ?? "01d")@2x.png")!) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "photo.fill")
                    }.frame(width: 100, height: 100)
            
            Text("All day \(weatherData.weather.first?.description ?? "").")
                .foregroundColor(.blue)
                .font(.system(size: 20))
        }
    }
}

struct ErrorMessageView: View {
    var message: String
    var systemImage: String
    
    var body: some View {
        VStack {
            Image(systemName: systemImage)
                .foregroundColor(.red)
                .padding()
            
            Text(message)
                .bold()
                .padding()
        }
    }
}
