#ifndef LANGUAGE_H
#define LANGUAGE_H

/* REMEMBER INCLUDE YOUR NEW STRIGNS
   IN language.c - lang_strings */

enum lang_codes 
{
    //VIDEO - ADJUST
    VIDEOADJUST_POSITION,
    VIDEOADJUST_SCALEINFO,
    VIDEOADJUST_EXITINFO,
    VIDEOADJUST_DEFAULTS,
    VIDEOADJUST_SAVED,
    //SELECT - GAME FOLDER
    GAMEFOLDER_WANTUSE,
    GAMEFOLDER_TOINSTALLNTR,
    GAMEFOLDER_USING,
    GAMEFOLDER_TOINSTALL,
    //MAIN
    MAIN_PAYLOADINVALID,
    MAIN_PAYLOADINVALIDMAP,
    MAIN_PAYLOADOLD,
    MAIN_PAYLOADRESIDENT,
    //DRAW SCREEN 1
    DRAWSCREEN_FAVSWAP,
    DRAWSCREEN_FAVINSERT,
    DRAWSCREEN_FAVORITES,
    DRAWSCREEN_PAGE,
    DRAWSCREEN_PRESS,
    DRAWSCREEN_FOPTIONS,
    DRAWSCREEN_FDELETE,
    DRAWSCREEN_PSTARTG,
    DRAWSCREEN_EXITXMB,
    DRAWSCREEN_CANRUNFAV,
    DRAWSCREEN_MARKNOTEXEC,
    DRAWSCREEN_REQBR,
    DRAWSCREEN_EXTEXENOTFND,
    
    //END
    LANGSTRINGS_COUNT
};


int open_language (char * filename);
void close_language(void);

#endif