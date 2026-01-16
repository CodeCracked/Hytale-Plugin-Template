package com.example.plugin;

import com.example.commands.TestCommand;
import com.hypixel.hytale.server.core.plugin.JavaPlugin;
import com.hypixel.hytale.server.core.plugin.JavaPluginInit;
import org.checkerframework.checker.nullness.compatqual.NonNullDecl;

public class ExamplePlugin extends JavaPlugin {

    public ExamplePlugin(@NonNullDecl JavaPluginInit init) {
        super(init);
    }

    @Override
    protected void setup() {
        super.setup();
        this.getCommandRegistry().registerCommand(new TestCommand("test", "Simple test command", false));
    }
}
