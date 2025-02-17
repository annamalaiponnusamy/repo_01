using System;
using System.Net;

class Program
{
    static void Main(string[] args)
    {
        string username = Environment.GetEnvironmentVariable("SECRET_USERNAME");
        string password = Environment.GetEnvironmentVariable("SECRET_PASSWORD");

        if (username == null || password == null)
        {
            Console.WriteLine("Username or password environment variables are not set.");
            return;
        }

        NetworkCredential credentials = new NetworkCredential(username, password);

        Console.WriteLine($"Username: {credentials.UserName}");
        // For security reasons, it's generally not recommended to print passwords.
        Console.WriteLine($"Password: {credentials.Password}");
        Console.WriteLine(username == "UCN\\annamalai.ponnusamy");
        Console.WriteLine(username == "malai");
        Console.WriteLine(password == "Dhar@9876543212$");
    }
}