class SignUpBody{
  String name;
  String phone;
  String email;
  String password;
  SignUpBody(
    {
      required this.name,
      required this.phone,
      required this.email,
      required this.password,
            

    }
  );
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data=<String,dynamic >{};
    data["f_name"]=name;
    data["email"]=email;
    data["phone"]=phone;
    data["password"]=password;
    return data;
  }
  
}