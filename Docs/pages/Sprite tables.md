The Apple II doesn't support hardware sprites. Furthermore, due to the peculiarities of how high-res graphics are mapped from memory to screen, it is not possible to just push a byte with pixels to memory and hope that it will show correctly. This pertains both to movements both in x and y direction, with different tricks to manage the complexity of the task.

Terminology:
* _sprite_ is a particular pixel pattern as seen by the player
* _strobe_ is a shifted sprite, paying attention to the color-indicating high bit
* _sprite table_ is a catalog containing the pointers to the strobes, one entry for each sprite

For a summary of the sprites used see [Robotron sprites.xlsb](https://github.com/fschuhi/Robotron_2084/blob/master/Docs/Robotron%20sprites.xlsb). You need to activate the VBA object model to use the functions and macros which come with the xlsb.

* _sprite table_ shows the memory layout of the catalog of the sprite entries, with each entry of #$10 bytes sizing the sprite (with in bytes, height in pixel lines) and pointing to 7 "strobes" of the sprite, which are the same pixels moved to the right.
* _entries_ displays the same data in logical format. You can use Ctrl-S anywhere in the strobe[0-6] columns to show the pixel representations of the particular strobe.
* Where the _sprite table_ and _entries_ are just the dictionary, _strobes_ actually shows the pixel-byte data itself, starting with the sprite index 0 down to index 65. Note that the memory layout (in column _strobeAddr_) is not consecutive.
* _strobes (mem,dec)_ shows the layout of the pixel byte data in memory. Bytes in green are first bytes of strobe0, orange of strobe1, yellow the strobes 2-6. Cell comments explain which strobe it is.

![image](https://user-images.githubusercontent.com/47814647/86437417-d63c0d00-bd04-11ea-82f7-db552e7854b3.png)
![image](https://user-images.githubusercontent.com/47814647/86437499-f4097200-bd04-11ea-9bcb-c7e46c9303ef.png)