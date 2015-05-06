#JHChainableAnimations
Easy to read and write chainable Animations in Objective-C

<table>
<tr>
<td width="65%">
<pre>
view.moveX(50).rotate(360).animate(1.0);  
</pre>
</td>
<td width=35%">
<img src="./Gifs/JHChainableAnimationsExample1.gif"></img>
</td>
</tr>
<tr>
<td width="65%">
<pre>
view.moveX(30).thenAfter(1.0).makeScale(2.0).spring.animate(1.0); 
</pre>
</td>
<td width="35%">
<img src="./Gifs/JHChainableAnimationsExample2.gif"></img>
</td>
</tr>
<tr>
<td width="65%">
<pre>
UIColor *purple = [UIColor purpleColor];
self.myView.moveWidth(50).bounce.makeBackground(purple).easeIn.anchorTopLeft.
        thenAfter(0.8).wait(0.2).rotate(95).easeBack.
        thenAfter(0.5).moveY(300).easeIn.makeOpacity(0.0).animate(0.4);  
</pre>
</td>
<td width="35%">
<img src="./Gifs/JHChainableAnimationsExample3.gif" ></img>
</td>
</tr>
</table>


