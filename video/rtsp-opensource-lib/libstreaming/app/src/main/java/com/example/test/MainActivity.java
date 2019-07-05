package com.example.test;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends Activity implements View.OnClickListener {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        findViewById(R.id.example1).setOnClickListener(this);
        findViewById(R.id.example2).setOnClickListener(this);
        findViewById(R.id.example3).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        Intent intent = new Intent();
        switch (v.getId()) {
            case R.id.example1:
                intent.setClass(this, MainActivity1.class);
                break;
            case R.id.example2:
                intent.setClass(this, MainActivity2.class);
                break;
            case R.id.example3:
                intent.setClass(this, MainActivity3.class);
                break;
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }
}
