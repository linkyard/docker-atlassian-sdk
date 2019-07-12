package ut.ch.linkyard;

import org.junit.Test;
import ch.linkyard.api.MyPluginComponent;
import ch.linkyard.impl.MyPluginComponentImpl;

import static org.junit.Assert.assertEquals;

public class MyComponentUnitTest
{
    @Test
    public void testMyName()
    {
        MyPluginComponent component = new MyPluginComponentImpl(null);
        assertEquals("names do not match!", "myComponent",component.getName());
    }
}