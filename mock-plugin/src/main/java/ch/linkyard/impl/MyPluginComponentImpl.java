package ch.linkyard.impl;

import com.atlassian.sal.api.ApplicationProperties;
import ch.linkyard.api.MyPluginComponent;

import javax.inject.Inject;
import javax.inject.Named;

@Named ("myPluginComponent")
public class MyPluginComponentImpl implements MyPluginComponent
{
    @Inject
    private final ApplicationProperties applicationProperties;

    @Inject
    public MyPluginComponentImpl(final ApplicationProperties applicationProperties)
    {
        this.applicationProperties = applicationProperties;
    }

    public String getName()
    {
        if(null != applicationProperties)
        {
            return "myComponent:" + applicationProperties.getDisplayName();
        }
        
        return "myComponent";
    }
}
