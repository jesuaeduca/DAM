
package ejercicio44tema5;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Ejercicio44Tema5
{

    public static void main(String[] args) throws IOException
    {
        int x, i = 3;
        boolean primo = false, b = true;
        
        BufferedReader bf = new BufferedReader (new InputStreamReader (System.in));
        
        System.out.println("Escribe un número");
        x = Integer.valueOf(bf.readLine());
        
        for (int num = 1; num <= x; num++)
        {
           if (num == 1 || num == 2)
            {
                primo = true;
            }
            else if (num % 2 == 0)
            {
                primo = false;
            }
            else
            {
                i = 3;
                b = true;
                while (b)
                {
                    int c = num / i;
                    int r = num % i;
                
                    if (c <= i)
                    {
                        primo = true;
                        b = false;
                    }
                    else if (r == 0)
                    {
                        primo = false;
                        b = false;
                    }
                
                    i += 2;
                }
            }
        
            if (!primo)
            {
                System.out.println(num + " no es primo");
            }
            else
            {
                System.out.println(num + " es primo");
            }
        }
    }
}
