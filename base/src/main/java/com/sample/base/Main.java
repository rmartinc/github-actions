package com.sample.base;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {

    private static final Pattern hierarchicalUri = Pattern.compile("^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?");

    public static boolean matches(String uri) {
        Matcher match = hierarchicalUri.matcher(uri);
        return match.matches();
    }

    public static void main(String... args) {
        System.out.println(matches(args[0]));
    }
}
