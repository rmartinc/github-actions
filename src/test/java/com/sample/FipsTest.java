package com.sample;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.SecureRandom;
import org.hamcrest.CoreMatchers;
import org.hamcrest.MatcherAssert;
import org.junit.Assert;
import org.junit.Test;

/**
 *
 * @author rmartinc
 */
public class FipsTest {

    @Test
    public void showEnv() {
        System.getenv().entrySet().stream()
                .forEach(e -> System.out.println(e.getKey() + "=" + e.getValue()));
    }

    @Test
    public void showSystemProps() {
        System.getProperties().entrySet().stream()
                .forEach(e -> System.out.println(e.getKey() + "=" + e.getValue()));
    }

    @Test
    public void isFIPSEnabledSystemLevel() throws IOException {
         String enable = new String(Files.readAllBytes(Paths.get("/proc/sys/crypto/fips_enabled")), StandardCharsets.UTF_8);
         Assert.assertEquals("/proc/sys/crypto/fips_enabled fips is " + enable, "1", enable);
    }

    @Test
    public void isFipsEnabledJavaLevel() {
        MatcherAssert.assertThat(new SecureRandom().getProvider().getName().toLowerCase(),
                CoreMatchers.containsString("fips"));
    }
}
