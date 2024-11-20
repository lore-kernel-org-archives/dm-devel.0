Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB0199E94
	for <dm-devel@lists.linux.dev>; Wed, 20 Nov 2024 10:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732099345; cv=none; b=Vy2bHDhZ9t+n8C8fvrQjs9Iz+bVIMKXWWM6PDJmJ/JW2ugpGhV0OsCUZz94bgy1CCU/XV+mgDVr4Pd4ZlJ6TpzKUCMrSaQSxmKeo3eYidJ5HAcR+vhHkR1pRCfJRN3WJCDPvpWyhs7zb+BjcoJUmIIgljj0nLIWjJR4mxermsng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732099345; c=relaxed/simple;
	bh=XyODa1LCzuhYX4RqTNQ6KQqHj00PZAoaT6QpjBVjnBQ=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:References:
	 In-Reply-To:Content-Type; b=UnrprYE1K93FuBoBlMTbUmmyezPNZfnsaq2GBJYf0bqfBrR4To6OPj4d1Jn7Xm8B0wBh86OWAxxni5jZDwXkeKKdBiJUjtLlz0S/INFatISBZd0cN4MCJwo8kaOM7LSIWFt+5zh3VRTA1gwaMQvZ7WLD0JXMrFGKV14be15pCFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YrYBNhh6; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YrYBNhh6"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-382026ba43eso4040685f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Nov 2024 02:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732099342; x=1732704142; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:user-agent:mime-version:date:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScJfAgXX0lE+CCVupy6tpeJiinu5z4i+DcsVPJlyG7s=;
        b=YrYBNhh6Td+Fomasi3cof8WsInhmphTIYDtEmgyFxtCBDNP/1OSMW4MJG+t2SanthF
         DHq1T1FaG7GchOKwg89r96fan4JlOBjz7ID3tbRZeHrjBxJ7/P8+hOJd2dV/kF4RKaqH
         /W2BYDPusCpGsF295sOcyMn4TnBjqgL3C1v7w734syOEBnZLy9CqUV6q4tKhU4KSL8Y9
         e+NS5MUM47OuODQ9KNB3JqJsVWt0Ab0tj2wrnOeeYecd5HsP8GsH1l6MWRZy/YLVTEJF
         wypL7+EyxbMUUyjIdiQFHQUkbKVaeHNeGxTMVH2cWi8tX7anrOBSe9xJI1CxeV6TamP0
         b6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099342; x=1732704142;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ScJfAgXX0lE+CCVupy6tpeJiinu5z4i+DcsVPJlyG7s=;
        b=ok2mppEKKDIAAkbXtwPGtH2sdEOW47SgFX5DebXc1NhFQp5Xk3zfRAdw5DFp4tElOQ
         Swmr93MmLl8WSJYu86Wv72QNH5Jn8WUgGxHlH0zYK6mEEjoGra6/aYqRqnd6LyCWFkPr
         p8Wi8MLWfPcGjW3PiVdPk6SsAPYvRPq5+vQojGUCfi5JoqUv5cN6qZl7Ny0mSlAB+8xG
         hfQ3kDuycf0QIDV/AxF95d7Hnu8xdKWRY30ZxiqTbLayvlsRYQO8N2V3YLxkPLsw9HIm
         3rTA4EekAhX4SK9q5F9anBx0iNYTmkb7EqjYecIDfIHQkxe/s0NBby+chWlsxnQMC64P
         iJtg==
X-Forwarded-Encrypted: i=1; AJvYcCVp5AITqBYMCLkMpQwIqumiOOH7ua2uTbupAgJ0kce4PMLKqMfkHq9ctmn6tIUVzuxDkpk9CXGtyQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyvyTF1WSyYkXDEWtE0pJNqn0RJcnRIvCDG/yjS8I4hCu1wCAay
	UEZEUAINJy6YxpMxYgogZ5qKbIpbXXIwQxfnRVGcTjg5OBcfXPE2wiTW9A==
X-Google-Smtp-Source: AGHT+IHEXHQz6vTfGMdeFyyHcucT5EaBSjb9jyFC9tt5/6kUvROuwXJhhU6RY2tttec4ZZ5WGHsYNg==
X-Received: by 2002:a05:6000:1a85:b0:382:31a1:8dc3 with SMTP id ffacd0b85a97d-38254b014fdmr1390617f8f.35.1732099341586;
        Wed, 20 Nov 2024 02:42:21 -0800 (PST)
Received: from [10.43.17.62] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825494ca3fsm1682729f8f.111.2024.11.20.02.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 02:42:21 -0800 (PST)
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
X-Google-Original-From: Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <91d94f48-bae4-48eb-8604-a7522f7062c8@redhat.com>
Date: Wed, 20 Nov 2024 11:42:20 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (Re ** 6)[1]: Extending "thin_trim" (about pseudo-raid: Why!)
To: =?UTF-8?Q?Thomas_Br=C3=BCcker?= <public0x05bf@bluewin.ch>,
 Zdenek Kabelac <zdenek.kabelac@gmail.com>, dm-devel@lists.linux.dev
References: <16c198593dc27302ab90ca7fe39bb71c.squirrel@main>
Content-Language: en-US, cs
In-Reply-To: <16c198593dc27302ab90ca7fe39bb71c.squirrel@main>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 20. 11. 24 v 2:28 "Thomas Brücker" napsal(a):
> Dear Mr. Kabelac,
>
> * I have had two (real!) cases which three mechanical harddisks, that have
> had defective sectors (within warranty time!), not just announced as
> defective, but really unreadable.
>
> 1st case: Two ecolocical, energy saving samsung disks, that have both got
> unreadable sectors, happyly mutually not on the same location, connected
> as raid1: All data could be read and saved.
>
> 2nd case: An usb-disk that had got unreadable sectors with a 'pseudo-raid'
> on it: All data could be read and saved.


Hi


Any device that is showing  'error' sectors (aka  smartctl shows badblocks, 
uncorrectable errors)   should be ASAP 'recovered/copied' to another new disk 
- and such faulty disk should no longer be used for anything you care about!

If you think  the disk is still 'good enough' to not be thrown to 
trash/recycle bin -  you could probably do a surface analysis - and i.e. 
allocate partitions on a drive in such a way that HUGE portion of drive before 
and after the error  is left  as not being used/allocated   (works for HDD -   
for SSD/NVMe this obviously makes no sense) -  so then HDD reading heads are 
not damaging those errori places any more - and then you can try to use it to 
store something unimportant - i.e.  3rd. backup of something....

Using faulty drive as 'daily work  disk'  with the idea you've 'saved' 
something  makes no sense - you are just preparing yourself big troubles....


> * Experimental case: Test of 'pseudo-raid' on a dvd, the dvd was scratched
> and could partially not be read: The pseudo raid could be read without any
> problem (


Just backup all your DVDs on TiB drives  while they are still readable....


>
> * I have had at least two (real) cases of harddisks with each having a
> unreadable first sector (== the partition table): The laptops could
> neither

Such drives are simply an electronic waste for recycling...


> * So, for me, it is a good idea, to protect myself from defective sectors.
>
> * 'Normal' raid(1):
>    * notebooks with two harddisks in it ...?
>    * travelling with a laptop and two usb-harddisks ...?


Seriously you should really use real  raid1 instead of these rather highly 
'questionable' data protection ideas...  (if you care about your data)

And yes - all notebooks I know  have at least  2 slots for drives - one is 
typically equipped when being sold - other one is usually empty - one just has 
to dismount laptop cover and add the drive to unused slot...


Regards

Zdenek


