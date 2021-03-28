//
//  ContentView.swift
//  tuffy2020
//
//  Created by Alex Truong on 3/27/21.
//  Copyright © 2021 Alex Truong. All rights reserved.
//

import SwiftUI
import AVKit
import Firebase

struct ContentView: View {
    var body: some View {
        
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKeyPath: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.status{
                    
                    Homescreen()
                    
                }
                else{

                    ZStack{
                              
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                                  
                        Text("")
                        }
                        .hidden()
                              
                              Login(show: self.$show)
                          }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKeyPath: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct Homescreen : View {
    
    var body: some View{
        
 
        Menu()
    }
}

struct Login : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topTrailing) {
                       
                       GeometryReader{_ in
                           
                           VStack{
                               Image("logo")
                               
                               Text("The Boring App")
                                   .font(.title)
                                   .fontWeight(.bold)
                                   .foregroundColor(self.color)
                                   .padding(.top, 5)
                                   
                            TextField("Email", text : self.$email).autocapitalization(.none)
                               .padding()
                               .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color_Menu") : self.color, lineWidth : 2))
                               .padding(.top, 25)
                               
                               HStack(spacing: 15){
                                   
                                   VStack{
                                       if self.visible{
                                           
                                        TextField("Password", text: self.$pass).autocapitalization(.none)
                                       }
                                       else{
                                           
                                        SecureField("Password", text: self.$pass).autocapitalization(.none)
                                       }
                                   }
                                   Button(action: {
                                       self.visible.toggle()
                                   }) {
                                       Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill").foregroundColor(self.color)
                                   }
                               }
                               .padding()
                               .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color_Menu") : self.color, lineWidth : 2))
                               .padding(.top, 25)
                               
                               HStack{
                                   
                                   Spacer()
                                   
                                   Button(action: {
                                    self.reset()
                                   }) {
                                       Text("Forget password")
                                           .fontWeight(.bold)
                                           .foregroundColor(Color("Color_Menu"))
                                       
                                   }
                               }
                               .padding(.top, 20)
                               
                               Button(action: {
                                   
                                    self.verify()
                               }) {
                                   
                                   Text("Log in")
                                       .foregroundColor(.white)
                                       .padding(.vertical)
                                       .frame(width: UIScreen.main.bounds.width - 50)
                                   
                               }
                               .background(Color("Color_Menu"))
                               .cornerRadius(10)
                               .padding(.top, 25)
                           }
                           .padding(.horizontal, 25)
                       }
                       
                       Button(action: {
                           
                           self.show.toggle()
                       }) {
                           Text("Register")
                               .fontWeight(.bold)
                           .foregroundColor(Color("Color_Menu"))
                       }
                       .padding()
                   }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    func verify(){
        
        if self.email != "" && self.pass != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                UserDefaults.standard.set(true, forKey:  "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else{
            
            self.error = "Please fill all the content properly"
            self.alert.toggle()
        }
    }
    
    func reset(){
        
        if self.email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}

struct SignUp : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        Image("logo")
                        
                        Text("The Boring App")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                            
                        TextField("Email", text : self.$email).autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color_Menu") : self.color, lineWidth : 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass).autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass).autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill").foregroundColor(self.color)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color_Menu") : self.color, lineWidth : 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                                               
                                               VStack{
                                                   if self.revisible{
                                                       
                                                    TextField("Re-enter", text: self.$repass).autocapitalization(.none)
                                                   }
                                                   else{
                                                       
                                                    SecureField("Re-enter", text: self.$repass).autocapitalization(.none)
                                                   }
                                               }
                                               Button(action: {
                                                
                                                   self.revisible.toggle()
                                                
                                               }) {
                                                   Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill").foregroundColor(self.color)
                                               }
                                           }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color_Menu") : self.color, lineWidth : 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            
                            self.register()
                            
                        }) {
                            
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                            
                        }
                        .background(Color("Color_Menu"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                }
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("Color_Menu"))
                }
                .padding()
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func register(){
        
        if self.email != ""{
            
            if self.pass == self.repass{
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    print("sucess")
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
            else{
                
                self.error = "Password mismatch"
                self.alert.toggle()
                
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
}

struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "Error" )
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link hash been sent" : self.error)
                .foregroundColor(self.color)
                .padding(.top)
                .padding(.horizontal, 25)
                
                
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    Text(self.error == "RESET" ? "Ok" :"Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color_Menu"))
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}

struct Menu : View {
    
    @State var index = 0
    @State var show = false
    
    var body: some View{
        
        ZStack{
            
            //Menu
            
            HStack{
                
                VStack(alignment: .leading, spacing: 12){
                    
                    Image("avatar")
                    
                    Text("Welcome to")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 10)
                    
                    Text("Boring Land")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.black)
                    
                    Button(action: {
                        
                        self.index = 0
                        
                        //animate views
                        
                        
                        withAnimation{
                            
                            self.show.toggle()
                        }
                        
                    }) {
                        
                        HStack(spacing: 25){
                            
                            Image("vid")
//                                .foregroundColor(self.index == 0 ? Color("Color_Select") : Color.white)
                                
                            
                            Text("Vid Land") .foregroundColor(self.index == 0 ? Color("Color_Select") : Color.black)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(self.index == 0 ? Color("Color_Select").opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    }
                    .padding(.top, 25)
                    
                    Button(action: {
                        
                        self.index = 1
                        
                        withAnimation{
                            
                            self.show.toggle()
                        }
                        
                    }) {
                        
                        HStack(spacing: 25){
                            
                            Image("posts")
//                                .foregroundColor(self.index == 1 ? Color("Color_Select") : Color.white)
                                
                            
                            Text("Potatoe Farm") .foregroundColor(self.index == 1 ? Color("Color_Select") : Color.black)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(self.index == 1 ? Color("Color_Select").opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        
                        self.index = 2
                        
                        withAnimation{
                            
                            self.show.toggle()
                        }
                        
                    }) {
                        
                        HStack(spacing: 25){
                            
                            Image("list")
//                                .foregroundColor(self.index == 2 ? Color("Color_Select") : Color.white)
                                
                            
                            Text("Friends") .foregroundColor(self.index == 2 ? Color("Color_Select") : Color.black)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(self.index == 2 ? Color("Color_Select").opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        
                        self.index = 3
                        
                        withAnimation{
                            
                            self.show.toggle()
                        }
                        
                    }) {
                        
                        HStack(spacing: 25){
                            
                            Image("fav")
//                                .foregroundColor(self.index == 3 ? Color("Color_Select") : Color.white)
                                
                            
                            Text("Fav") .foregroundColor(self.index == 3 ? Color("Color_Select") : Color.black)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(self.index == 3 ? Color("Color_Select").opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    }
                    
                    Divider()
                        .frame(width: 150, height: 1)
                        .background(Color.black)
                        .padding(.vertical, 30)
                        
                    Button(action: {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                            
                        }) {
                                            
                    HStack(spacing: 25){
                                                
                        Image("out")
                    //                                .foregroundColor(Color.white)
                                                    
                                                
                    Text("Sign Out") .foregroundColor(Color.black)
                                            }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                                            
                    }
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.top, 25)
                .padding(.horizontal, 20)
                
                Spacer(minLength: 0)
            }
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            
            //First Tab
            
            VStack(spacing: 0){
                
                HStack(spacing: 15){
                    
                    Button(action: {
                        
                        withAnimation{
                            
                            self.show.toggle()
                        }
                        
                    }) {
                        //close button
                        
                        
                        Image(systemName: self.show ? "xmark" : "line.horizontal.3")
                            .resizable()
                            .frame(width: self.show ? 18 : 22, height: 18)
                        .foregroundColor(Color("Color1"))
//                            .foregroundColor(Color.black.opacity(0.4))
                        
                    }
                    
                    Text("Home")
                        .font(.title)
                         .foregroundColor(Color("Color1"))
//                        .foregroundColor(Color.black.opacity(0.6))
                    
                    Spacer(minLength: 0)
                }
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding()
                .background(Color.black)
                
                //Content for first page
//                VStack(spacing: 12){
//                    Image("top")
//                    .resizable()
//                    .frame(width: 210)
//
//                    Text
//                }
                GeometryReader{_ in
                    
                    VStack{
                        
                        //Switching screen based on index
                        
                        if self.index == 0{
                            NavigationView {
                                MainPage().navigationBarTitle("")
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                                
                            }.preferredColorScheme(.dark)
                            
                        }
                        else if self.index == 1{
                            Pota()
                        }
                        else if self.index == 2{
                            
                            Friends()
                        }
                        else if self.index == 3{
                            Favourites()
                        }
                        
                    }
                }
                
//                Spacer(minLength: 0)
            }
            .background(Color.white)
        //Corner Radius
            .cornerRadius(self.show ? 30 : 0)
        //shrinking and moving view right side when menu clicked
            .scaleEffect(self.show ? 0.9 : 1)
            .offset(x: self.show ? UIScreen.main.bounds.width / 2 : 0, y : self.show ? 15 : 0)
            //Roatte
            .rotationEffect(.init(degrees: self.show ? -5 : 0))
        }
        .background(Color("Color_Slide").edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
    }
}

//Mainpage View

struct MainPage :View {
    
    @State var txt = ""
    @State var show = false
    
    var body: some View{
        
        
//        VStack{
//            Text("Main Page")
//        }
        
        VStack(alignment: .leading, spacing: 20){
            
            HStack (spacing : 15){
                
                Image(systemName: "magnifyingglass").font(.body)
                
                TextField("Search for Videos or Movies or Shows", text: $txt)
            }.padding()
            .background(Color("Color_Search"))
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Shows of the Day").font(.title)
                        
                        ZStack{
                            
                            NavigationLink(destination: Detail(show: $show), isActive: $show) {
                                
                                Text("")
                            }
                            
                            
                            Image("top").resizable().onTapGesture {
                                self.show.toggle()
                            }
                            
                            VStack{
                                
                                Spacer()
                                
                                HStack{
                                    
                                    VStack(alignment: .leading, spacing: 10){
                                        
                                        Text("Star Wars").font(.body)
                                        Text("The Book of Boba Fett").font(.body)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                    }) {
                                        
                                        Image("play").renderingMode(.original)
                                    }
                                }
                            }.padding()
                            
                        }.frame(height: 190)
                    
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            
                            Text("See All Movies")
                        }.foregroundColor(Color("Color1"))
                    }
                    
                    bottomView()
                    Text("Videos of the Day")
                    middleView()
              
                }
                
            }.padding(.bottom, 25)
                
        }.padding(.horizontal)
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
    }
}

struct middleView : View {
    
    @State var show = false
    
    var body : some View{
        VStack(spacing: 15){
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 15){
                    
                    ForEach(datas){i in
                        
                        VStack(alignment: .leading, spacing: 0){
                            
                            Image(i.image)
                            
                            HStack{
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                }) {
                                    
                                    Image("play").renderingMode(.original).resizable().frame(width: 25, height: 25)
                                }.padding(.top, -12)
                            }
                            VStack(alignment: .leading){
                               
                                Text(i.name)
                                Text(i.epname).foregroundColor(.gray)
                                                            
                                    ZStack{
                                                                
                            Capsule().fill(Color.gray)
                                                                
                                //                                HStack{
                                //
                                //                                    Capsule().fill(Color("Color1")).frame(width: i.per)
                                //                                }
                                }.frame(height: 5)
                    
                                
                            }.padding(.horizontal, 10)
                                .padding(.bottom, 10)
                            
                            }.background(Color("Color_Search"))
                            .padding(.bottom)
                    }
                }
            }
            
            Text("Trending Videos").font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 15) {
                    
                    NavigationLink(destination: DetailV(show: $show), isActive: $show) {
                        
                        Text("")
                    }
                    
                    ForEach(bottom,id: \.self){i in
                        
                        Image(i).resizable().onTapGesture {
                            self.show.toggle()
                        }
                        
                    }
                    
                }
            }
        }
    }
}



struct bottomView : View{
    
    var body: some View{
        
        VStack(alignment: .leading, spacing: 15){
            
            Text("Explore")
            
            HStack(spacing: 15){
                
                Button(action: {
                    
                }) {
                    
                    Text("Trending").padding()
                    
                }.foregroundColor(.white)
                .background(Color("Color1"))
                .cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Text("Gaming").padding()
                    
                }.foregroundColor(.white)
                .background(Color("Color1"))
                .cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Text("News").padding()
                    
                }.foregroundColor(.white)
                .background(Color("Color1"))
                .cornerRadius(10)
            }.padding(.horizontal, 20)
            
//            Text("Trending Videos")
//
//            ScrollView(.horizontal, showsIndicators: false) {
//
//                HStack(spacing: 15) {
//
//                    ForEach(bottom,id: \.self){i in
//
//                        Image(i)
//                    }
//                }
//            }
        }
    }
}



struct Detail : View {
    
    @Binding var show : Bool
    var body: some View{
        
        VStack(spacing: 15){
            
            HStack(spacing: 15){
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Image("back").renderingMode(.original)
                }
                
                Spacer()
                
                Button(action: {
                                   
                }) {
                                   
                    Image("share").renderingMode(.original)
                }
                Button(action: {
                                   
                }) {
                                   
                Image("info").renderingMode(.original)
                }
            }.padding()
            
            ZStack{
                
                Image("detail").resizable()
                
                VStack(alignment: .leading, spacing: 12){
                    
                    Spacer()
                    
                    Text("Movie . Advanture")
                    Text("Star Wars").font(.title).foregroundColor(Color("Color1"))
                    Text("The Book of Boba Fett").font(.title).foregroundColor(Color("Color1"))
                    
                    HStack(spacing: 10){
                        
                        Text("100% Match").foregroundColor(.green)
                        Text("2021")
                        Image("hd")
                        
                        Spacer()
                        
                    }
                }.padding()
                
            }.frame(height: 490)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(alignment: .leading, spacing: 15){
                    
                    HStack{
                        
                        Button(action: {
                            
                        }) {
                            
                            HStack(spacing: 10){
                                
                                Image(systemName: "play.fill")
                                Text("Play")
                            }.padding()
                        }.foregroundColor(.white)
                        .background(Color("Color1"))
                        .cornerRadius(10)
                        
                        Button(action: {
                            
                        }) {
                            
                            HStack(spacing: 10){
                                
                                Image(systemName: "plus")
                                Text("Save")
                            }.padding()
                        }.foregroundColor(.white)
                        .background(Color("Color_Search"))
                        .cornerRadius(10)
                        
                        Spacer()
                    }
                    
                    HStack{
                        
                        VStack(alignment: .leading, spacing: 10){
                            
                            Text("Description")
                            Text("The Book of Boba Fett is a separate spinoff series of The Mandalorian with new adventures centered on Boba Fett (Temeura Morrison) and partner Fennec Shand (Ming-Na Wen).")
                        }
                    }
                    
                }
            }.padding(.top, 15)
                .padding(.horizontal, 15)
        }
    }
}

struct DetailV : View {
    
    @Binding var show : Bool
    var body: some View{
        
        VStack(spacing: 15){
            
            HStack(spacing: 15){
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Image("back").renderingMode(.original)
                }
                
                Spacer()
                
                Button(action: {
                                   
                }) {
                                   
                    Image("share").renderingMode(.original)
                }
                Button(action: {
                                   
                }) {
                                   
                Image("info").renderingMode(.original)
                }
            }.padding()
            
            ZStack{
                
//                Image("detail").resizable()
                
                VStack(alignment: .leading, spacing: 12){
                    
                    player().frame(height: UIScreen.main.bounds.height / 3)
                                       
                    Spacer()
                    
                    HStack{
                        
                        VStack(alignment: .leading, spacing: 10){
                            
                            Text("Description")
                            Text("Meme video of the day ")
                        }
                    }

                    
//                    Spacer()
                    
//                    Text("Movie . Advanture")
//                    Text("Star Wars").font(.title).foregroundColor(Color.black)
//                    Text("The Book of Boba Fett").font(.title).foregroundColor(Color.black)
//
//                    HStack(spacing: 10){
//
//                        Text("100% Match").foregroundColor(.green)
//                        Text("2021")
//                        Image("hd")
//
//                        Spacer()
//
//                    }
                }.padding()
                
            }.frame(height: 490)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
//            ScrollView(.vertical, showsIndicators: false){
//
//                VStack(alignment: .leading, spacing: 15){
//
//                    player().frame(height: UIScreen.main.bounds.height / 2)
//
//                    Spacer()
//                    HStack{
//
//                        Button(action: {
//
//                        }) {
//
//                            HStack(spacing: 10){
//
//                                Image(systemName: "play.fill")
//                                Text("Play")
//                            }.padding()
//                        }.foregroundColor(.white)
//                        .background(Color("Color1"))
//                        .cornerRadius(10)
//
//                        Button(action: {
//
//                        }) {
//
//                            HStack(spacing: 10){
//
//                                Image(systemName: "plus")
//                                Text("Save")
//                            }.padding()
//                        }.foregroundColor(.white)
//                        .background(Color("Color_Search"))
//                        .cornerRadius(10)
//
//                        Spacer()
//                    }
//
//                    HStack{
//
//                        VStack(alignment: .leading, spacing: 10){
//
//                            Text("Description")
//                            Text("The Book of Boba Fett is a separate spinoff series of The Mandalorian with new adventures centered on Boba Fett (Temeura Morrison) and partner Fennec Shand (Ming-Na Wen).")
//                        }
//                    }
//
//                }
//            }.padding(.top, 15)
//                .padding(.horizontal, 15)
        }
    }
}

struct player : UIViewControllerRepresentable{
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<player>) ->
        
        AVPlayerViewController {
            
            
        
            let controller = AVPlayerViewController()
            let url = "https://www.youtube.com/watch?v=AFRJsSaIaeo&t=22s&ab_channel=AmazonPrimeVideo"
            let player1 = AVPlayer(url: URL(string: url)!)
            controller.player = player1
            return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context:
    UIViewControllerRepresentableContext<player>) {
        
    }
}

struct Pota :View{
    
    var body: some View{
        
        VStack{
            Text("Potatoe Farm")
        }
    
    }
}

struct Friends :View{
    
    var body: some View{
        
        VStack{
           
            HStack{
                
                Text("Friend List")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Image(systemName: "line.horizontal.3.decrease")
                        .font(.title)
                        .foregroundColor(.white)
                    
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(spacing: 10){
                    
                    ForEach(data){i in
                        
                        Friend(data: i)
                    }
                }
                .padding(.bottom)
            }
            
            
        }
        .background(LinearGradient(gradient: .init(colors: [Color("Color_Menu"), Color("Color_Menu")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)).edgesIgnoringSafeArea(.bottom)
    }
}

struct Friend : View {
    
    var data : Player
    var body : some View{
        
        HStack{
            
            Image(self.data.image)
            .resizable()
            .frame(width: UIScreen.main.bounds.width / 1.8)
            
            Spacer()
            
            VStack(spacing: 20){
                
                Image(systemName: "cloud.bolt.fill").foregroundColor(.white)
                .padding()
                .background(
                    ZStack{
                        self.data.color
                        
                        Circle().stroke(Color.black.opacity(0.1), lineWidth: 5)
                        
                        Circle().stroke(Color.white, lineWidth: 5)
                        
                    }
                )
                .clipShape(Circle())
                
                Image(systemName: "bolt.circle.fill").foregroundColor(.white)
                .padding()
                .background(
                    ZStack{
                        self.data.color
                        
                        Circle().stroke(Color.black.opacity(0.1), lineWidth: 5)
                        
                        Circle().stroke(Color.white, lineWidth: 5)
                        
                    }
                )
                .clipShape(Circle())

                Text(self.data.name)
                Spacer(minLength: 0)
                
                Button(action: {
                    
                }) {
                    
                    Text("Message")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 25)
                        .background(Capsule().stroke(Color.white, lineWidth: 2))
                        .offset(y: -35)
                }
                
            }
            .padding(.trailing)
        }
        .frame(height: 290)
        .background(Color.white.opacity(0.2)
        .cornerRadius(25)
        .rotation3DEffect(.init(degrees: 20), axis: (x: 0, y: -1, z: 0))
        
        .padding(.vertical, 35)
        .padding(.trailing, 25)
        )
        .padding(.horizontal)
    }
}

struct Favourites :View{
    
    var body: some View{
        
        VStack{
            Text("Fav")
        }
    }
}


//Dummy data

struct Player : Identifiable{
    
    var id : Int
    var image : String
    var name : String
    var color : Color
    
}

var data = [


    Player(id: 0, image: "Player1", name: "Axe Rumble", color: Color("Color")),
    Player(id: 1, image: "Player2", name: "Ily Gwyn", color: Color("Color_Slide")),
    Player(id: 2, image: "Player3", name: "Thy Sarus", color: Color("Color_Select")),

]

struct type : Identifiable {
    
    var id : Int
    var name : String
    var epname : String
    var image : String
  
}

var datas = [
    type(id: 0, name: "The Mandalorian", epname: "Ep - S2",image: "m1"),
    type(id: 1, name: "The Falcon and the Winter Soldier", epname: "Ep - S1",image: "m2")
]

var clips = [
    type(id: 0, name: "Popular Mem Clips", epname: "",image: "b1"),
    type(id: 1, name: "Top Funny Memes", epname: "",image: "b2")
]

var bottom = ["b1","b2"]



