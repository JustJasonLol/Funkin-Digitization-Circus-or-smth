function onCreatePost()
	setProperty('gf.alpha', 0)
end    

function onStepHit() 
    if curStep == 1984 then 
        setProperty('gf.alpha', 1)
    end   
    if curStep == 2968 then  
        doTweenAlpha('girldfriend', 'gf', 0, 1, "linear")
    end    
end        