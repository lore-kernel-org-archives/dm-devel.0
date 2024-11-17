Received: from vimdzmsp-sfwd05.bluewin.ch (vimdzmsp-sfwd05.bluewin.ch [195.186.120.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9E46AA7
	for <dm-devel@lists.linux.dev>; Sun, 17 Nov 2024 10:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.186.120.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731840201; cv=none; b=IJXi6sNTqebTNjayGjUrUGbu0AYIYlj48Jhaf8qhun+QXpPAr2v2bdJa1QcqKq+jxGNMiv7xAxhFYvFXCQEg60JabPonJFIm3KX9L0u2k8T5SDQIuAQzjTb4YHpwE/56mRvnbILdKvElGE4CXCqYML1c4YsBsVNYm3zL/GlFUtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731840201; c=relaxed/simple;
	bh=vkLySTGaB0GSzm/b0sL3nt09pbH2GM8cXW0/y/gEOdg=;
	h=Message-ID:Date:Subject:From:To:MIME-Version:Content-Type; b=Xo+Fybd8wk6z17oJoyL9X7HFAalLMi9uUZRGMja6AcXI6MW7Lk1xXAIFhdMq772JoSUNZAKkkCtLMxANZmjayBTy5IJ1XLBI3+jtTIMCzNjAY72wD9T0HdT3VTFSfH/zm5t/2ztA881enErOgIwrZTd9aobbUSuyfC3sld/Urag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluewin.ch; spf=pass smtp.mailfrom=bluewin.ch; dkim=pass (2048-bit key) header.d=bluewin.ch header.i=@bluewin.ch header.b=Cx68qROq; arc=none smtp.client-ip=195.186.120.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluewin.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluewin.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluewin.ch header.i=@bluewin.ch header.b="Cx68qROq"
Received: from main ([84.227.21.131])
	by vimdzmsp-sfwd05.bluewin.ch Swisscom AG with ESMTPA
	id CciKtMJOF0k5JCciKtiSOd; Sun, 17 Nov 2024 11:41:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bluewin.ch;
	s=fxzs-2048-20230414; t=1731840068;
	bh=HWv6D8vEK9gorYee9irVtQEUh+JSOz4TeqJZq+DrpbQ=;
	h=Message-ID:Date:Subject:From:To:MIME-Version;
	b=Cx68qROqw4N5WNVfWjwsDKQGK3QENc35ohh9iJB8WWUz2Y8dg8HbhLNnkubNb95GG
	 X6AE8QMJdT1vEgVk9BR3RtYVh2mh8qBssJYq+Pm1ceFb00X4euHMsbH9iUdhriAH9S
	 ACiONpr8jSeu3A6P+TbTI4QLtnLLwPJkP+xg9Gm5KogUX/bU8/E/+a3YBLIspU2zXR
	 Tn3Q6AVY9s8SlN4yOAImAyEshgzur9m3In5K/Q91GN11BFX4dUi4cq2tivbNt1a2j1
	 icC5wpzhm84GNY6nWElhIZhftbSoS2tK1D5y617gulP1bCHDai7bV/DY84iDolJouv
	 niq0wh8uKRG4g==
X-Bluewin-Spam-Analysis: v=2.4 cv=UKV+Hzfy c=1 sm=1 tr=0 ts=6739c844
 a=ig9bzvNBGao8Dw96AwO3EA==:117 a=ig9bzvNBGao8Dw96AwO3EA==:17
 a=8nJEP1OIZ-IA:10 a=VlfZXiiP6vEA:10 a=LLPZWm0_0O8A:10 a=NEAV23lmAAAA:8
 a=T8-9mwnY4gpxhNQUfmoA:9 a=wPNLvfGTeEIA:10
X-Bluewin-Spam-Score: 0.00
X-FXIT-IP: IPv4[84.227.21.131] Epoch[1731840068]
X-Bluewin-AuthAs: public0x05bf@bluewin.ch
Received: from 10.235.2.12
        (SquirrelMail authenticated user public0x05bf)
        by main with HTTP;
        Sun, 17 Nov 2024 11:26:03 +0100
Message-ID: <980e288be81cac6aa86b9934009571c6.squirrel@main>
Date: Sun, 17 Nov 2024 11:26:03 +0100
Subject: (Re * Re): Extending "thin_trim"
From: =?iso-8859-1?Q?=22Thomas_Br=FCcker=22?= <public0x05bf@bluewin.ch>
To: dm-devel@lists.linux.dev
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
X-CMAE-Envelope: MS4xfA+oLRfNo4t8vmQp3GKernTrCl/8XZImXwmW73giJmmH+xnTuBQ3rdfg1ZQCYLqrhlcDy1V1taggvoSUWqbSEoCjFWyeHjXsLw7W5yoGxSZJV+rCFxmj
 cEX0YGxQeJQfSaBx0iaW5iQKEMa9R0GuCX9LGyfAXE529bCJq1kE8TNk/yTcB6aPHMtd5Wip51iCv2ONNdIt7ecbHgiNlw3B/LQFDvg+ToINag7c9EBfBXHL

Hello developers and others,

I agree fully with your '2TB-argument'. So no longer zeroing.

I have taken a closer look to "blk-archive". "Packing to a remote archive"
there not yet works. I have an ((alpha ** n); n --> infinity)-solution of
my own, which can do this (it is accessible as an nbd device).
Furthermore I sometimes really need to copy the data device to another
location (see crazy-rationale, if you want).
Somehow I like modularity, leading to "<progr. a> | <progr. b> | ... " (here
"<...>" means a variable to be set).
(In further text, "data device" means solely a data device of a thin pool.)

Whats with / (I prefer to develop) an utility similar to "dd" (stealing code
from "dd" and "blk-archive" [I hope its all "GPL" or similar]), which skips
unallocated blocks either on a thin device(got idea from "blk-archive") or a
data device.

Sincerely

Thomas Bruecker

PS:
crazy rationale (to be skipped):
* My name: "pseudo-raid": raid5 with legs on the same device, especially a
  hard disk. Ok, I admit, its slow.
  * Reason:
    * Modern hard disks are able to correct defective sectors, if the driver
      knows, what should be in these sectors.
    * You may not equip a notebook with additional hard disk.

* I have an (experimental) server lacking of slots for additional hard disks.
  I just needed more disk space there, and was just able to insert one
additio-
  nal disk.
  I intended to use this diskd for experimental purpose (--> no important
  data).
  I just had (and wanted to use) a hard disk with defective sectors
  (<-- "smartclt"), no longer using this disk in a serious production
  environment.
  I put a "pseudo-raid" on this disk (to protect 'me' from further emerging
  defective sectors).
  On the "pseudo-raid", I installed a thin-provisioning-device combination
  (data, metadata).
  Years passed by.
  Then I had to migrate a server from one location to a not yet existing
  other location. So I temporarely stored the server on THIS experimental
  disk, running it on the experimental server.
  It should have been for some weeks, ev. months.
  Years passed by (in german we say "Providurium" aka. Provisorium).
  Then suddenly another hard disk, also with defective sectors, crashed
  (finally no longer beeing able to start the disk).
  I though Oh, what is with my 'semi-'defective hard disk with the server on
  it, if it crashes ... .
  To copy an about 450G data device (maybe nearly empty) to another location
  by "dd" ...
  So I 'put a raid1 on the "pseudo raid"' (one leg "pseudo-raid", other leg
  a [well working] hard disk).
  Things work slower and slower ... .
  Actually I should renovate the whole combination to a simple raid<n>,
  but copying the data device by "dd" ...
  A "dd" that skips unallocated blocks would really be fine.

===============================================================================
On Sat, November 16, 2024 8:41 pm, Zdenek Kabelac wrote:
> Dne 16. 11. 24 v 17:10 "Thomas Bruecker" napsal(a):
>> Hello developers and others,
>>
>> ['extending "thin_trim", so that it zeroes unallocated blocks.'] [...]
>> [...]
>>
>>Sincerely
>>
>>Thomas Bruecker
>>Wydacker 43A
>>CH-3083 Trimtstein
>
> Hi
> I think you should pro probably examine this project:
> https://github.com/jthornber/blk-archive
>
> IMHO zeroing would likely not be so good plan - i.e. imagine you have
> mostly empty 2TiB thinpool...
>
> blk-archive solves this way more efficiently.
>
> Regards
>
> Zdenek



