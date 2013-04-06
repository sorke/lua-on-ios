//
//  LuaManager.m
//  Lua on iOS
//
//  Created by Maciej Konieczny on 2013-04-07.
//  Copyright (c) 2013 Maciej Konieczny. All rights reserved.
//

#import "LuaManager.h"

#define to_cString(s) ([s cStringUsingEncoding:[NSString defaultCStringEncoding]])


@interface LuaManager ()

@property (nonatomic) lua_State *state;

@end


@implementation LuaManager

- (lua_State *)state {
    if (!_state) {
        _state = luaL_newstate();
        luaL_openlibs(_state);
        lua_settop(_state, 0);
    }

    return _state;
}

- (void)runCodeFromString:(NSString *)code {
    // get state
    lua_State *L = self.state;

    // compile
    int error = luaL_loadstring(L, to_cString(code));
    if (error) {
        luaL_error(L, "cannot compile Lua code: %s", lua_tostring(L, -1));
        return;
    }

    // run
    error = lua_pcall(L, 0, 0, 0);
    if (error) {
        luaL_error(L, "cannot run Lua code: %s", lua_tostring(L, -1));
        return;
    }
}

- (void)runCodeFromFileWithPath:(NSString *)path {
    // get state
    lua_State *L = self.state;

    // compile
    int error = luaL_loadfile(L, to_cString(path));
    if (error) {
        luaL_error(L, "cannot compile Lua file: %s", lua_tostring(L, -1));
        return;
    }

    // run
    error = lua_pcall(L, 0, 0, 0);
    if (error) {
        luaL_error(L, "cannot run Lua code: %s", lua_tostring(L, -1));
        return;
    }
}

@end