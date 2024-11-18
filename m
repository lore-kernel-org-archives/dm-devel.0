Received: from sfwd05.p.bluenet.ch (sfwd05.p.bluenet.ch [193.247.246.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBCE1BD9E1
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 20:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.247.246.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731961955; cv=none; b=aMg3PQS7X1kpRYpFuWJgn1jTZa7knwESqFzscN6lDjVKzVKKNtu5mhwv8Ya4sSrlbe1kDxg5d4jeG9Zx3y+vVNhK/XUI4+NWsX4/XH+ib49S206dY6EPZdFJisnyEYNWns6WwA0E+Nk94Co2Zi13fl5LXQT1P4up0AI+4ohArIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731961955; c=relaxed/simple;
	bh=/vpbiatyM2PblSQYI+y3yGn2e/2zutYGYGWqVnZQlPo=;
	h=Message-ID:Date:Subject:From:To:MIME-Version:Content-Type; b=p+8jul39lIzItDRw1+/ZWd1R53LZ+kywL/A5Aqc+wrN7r1/Wdts6IbLtQoLkdmQAYhkgeyxB+IfqLW4d3Z6Lr2y0YqKdffQr3y6MJS/eS2yVa8byL4cnD0u9WJ1NDQl4hguwxdRUfr3C8gVqL+IBG6BnbgxGbeH1846sc+65Sms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluewin.ch; spf=pass smtp.mailfrom=bluewin.ch; dkim=pass (2048-bit key) header.d=bluewin.ch header.i=@bluewin.ch header.b=T98LFSin; arc=none smtp.client-ip=193.247.246.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluewin.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluewin.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluewin.ch header.i=@bluewin.ch header.b="T98LFSin"
Received: from main ([84.227.21.131])
	by vimdzmsp-sfwd05.bluewin.ch Swisscom AG with ESMTPA
	id D8O7tQRYb0k5JD8O7tjkBc; Mon, 18 Nov 2024 21:30:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bluewin.ch;
	s=fxzs-2048-20230414; t=1731961823;
	bh=KO4nC7FWuDm/G9Gw3PbxCahkaLgin9HYleMsnx7vzOs=;
	h=Message-ID:Date:Subject:From:To:MIME-Version;
	b=T98LFSinJx6+jZzRYOpjLCZUlrGLPHNT3xEVLHURBqBbx6FG73tC1IiY0ZZcsvDCL
	 60TL/sJjb1SGYufB/lt3OuS0WcMOp8iIQ6Um5XmwZZOTtMR7SpAKKbhNwtJV8Ra+IB
	 1zuCbXtDiaNM3QOKmmJRmJ0xiHpetyG2HGjJwJNBXFHvIZeyP8BC3DFXk/FYn7L2WT
	 +b12+1RtoUstBe4ddjXqLyC+EMqIW6VRtGDjdaTXOJSh3KM8N+hFNd5fKja21PnErW
	 6Ab2BV4psj1YdTh7y+FBgbOlimEVI1HAXhHryUWJa3VANQrbhOKD2mZhBZIvFfkc91
	 SPB1kUg/wV8mQ==
X-Bluewin-Spam-Analysis: v=2.4 cv=UKV+Hzfy c=1 sm=1 tr=0 ts=673ba3df
 a=ig9bzvNBGao8Dw96AwO3EA==:117 a=ig9bzvNBGao8Dw96AwO3EA==:17
 a=8nJEP1OIZ-IA:10 a=VlfZXiiP6vEA:10 a=LLPZWm0_0O8A:10
 a=zdeXWzcDJinJY2TJB_QA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Bluewin-Spam-Score: 0.00
X-FXIT-IP: IPv4[84.227.21.131] Epoch[1731961823]
X-Bluewin-AuthAs: public0x05bf@bluewin.ch
Received: from 10.235.1.189
        (SquirrelMail authenticated user public0x05bf)
        by main with HTTP;
        Mon, 18 Nov 2024 21:14:38 +0100
Message-ID: <2316655d90ef08ed99e1911f2953da3b.squirrel@main>
Date: Mon, 18 Nov 2024 21:14:38 +0100
Subject: (Re ** 4): Extending "thin_trim"
From: =?iso-8859-1?Q?=22Thomas_Br=FCcker=22?= <public0x05bf@bluewin.ch>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
 dm-devel@lists.linux.dev
User-Agent: SquirrelMail/1.4.21
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-CMAE-Envelope: MS4xfKtNtDNnl/wBjWRQyoVvnRxOrFARq61LG1ShQIa2qpmZkwqXb1LZASXTA9Q2U7dJywDgm4Wk9vdrPAUtrjFPf+Ik9GDo7fhnkV18N7PRZbxL8LJLAIzx
 eS2IkyeYDsUvsrRw2gBugSdw3V4CilOLBpB4VK347esIeDMRtJraK4cdzzwhPnAsddXFjZ+Br+swPyIEfg4ZcQvneDklXwKNRjPd6rfTjTdiMzbdfFYXt00k
 w2YVBkCck2H9Zh1SHaBgozLaJmz73p0g2i8pwMKRXh4=

Dear Mr. Kabelac,

I am sorry for stealing your precious time. You are right, I could get
the allocated blocks by the the text-output from thin_rmap. It is easier
to recognize, if the output of thin_rmap changes (whenever at all?), than
dealing direct with the metadata.
Besides I like to
* make experiments with things e.g. metadata.
* have ideas on how to make something, and program it, e.g. backup program.
I must admit, that "blk_archive" is more sophisticated than my things.

Although 'blaming' me, you have helped me a lot.


Sincerley

Thomas


===========================================================================
On Mon, November 18, 2024 10:28 am, Zdenek Kabelac wrote:
> Dne 17. 11. 24 v 11:26 "Thomas Brücker" napsal(a):
>> Hello developers and others,
>>
>> I agree fully with your '2TB-argument'. So no longer zeroing.
>>
>> I have taken a closer look to "blk-archive". "Packing to a remote
>> archive"
>> there not yet works. I have an ((alpha ** n); n --> infinity)-solution
>> of
>> my own, which can do this (it is accessible as an nbd device).
>> Furthermore I sometimes really need to copy the data device to another
>> location (see crazy-rationale, if you want).
>> Somehow I like modularity, leading to "<progr. a> | <progr. b> | ... "
>> (here
>> "<...>" means a variable to be set).
>> (In further text, "data device" means solely a data device of a thin
>> pool.)
>>
>> Whats with / (I prefer to develop) an utility similar to "dd" (stealing
>> code
>> from "dd" and "blk-archive" [I hope its all "GPL" or similar]), which
>> skips
>> unallocated blocks either on a thin device(got idea from "blk-archive")
>> or a
>> data device.
>
>
> Hi
>
>
> Of course you can always recreate the wheel as long as you have fun doing
> that
> - so yep you can full be inspired how to deal with 'thin-pool' metadata to
> know which areas have some real data inside - although I'd  probably
> highly
> recommend to stick with the use of original 'thin tools' - since those are
> the
> 'real tools' to work with thin-pool metadata - they know the format - they
> are
> regularly updated when format change and so on...    once you do you
> 'copy' of
> this rust code - you are loosing all those feature -  IMHO not
> worth.    (Note
> - sooner or later there will be a new format of metadata...)
>
>
> And if there are missing features in blk-archive - let's open the issue -
> AFAIK this tool is still in development - so reasonable feature requests
> will
> be certainly implemented - you just need to write some good
> examples/justifications  how the feature should be working.
>
>
> Regards
>
> Zdenek
>
>
>>
>> Sincerely
>>
>> Thomas Bruecker
>>
>> PS:
>> crazy rationale (to be skipped):
>> * My name: "pseudo-raid": raid5 with legs on the same device, especially
>> a
>>    hard disk. Ok, I admit, its slow.
>>    * Reason:
>>      * Modern hard disks are able to correct defective sectors, if the
>> driver
>>        knows, what should be in these sectors.
>>      * You may not equip a notebook with additional hard disk.
>
>
> Is this some sort of   'raid1 + writemostly'  ?
>
> And there is also another target -   'dm-era'   - which is however not
> supported (yet)  by lvm2...



