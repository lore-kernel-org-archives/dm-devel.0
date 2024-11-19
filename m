Received: from sfwd06.p.bluenet.ch (sfwd06.p.bluenet.ch [193.247.246.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77A6136337
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 02:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.247.246.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731983379; cv=none; b=W6eAU4UhLHYax87MJgvFskPS+1RHWke+PjXf1k3m1GSyOqVI7ljO42o8/h1Q8Oyowro7V2ZjYpgUrFhC+hNIM/r4No9dgR98FL/ninVmJSpg4gWv/6huiMtKohKfzPO+5wS0ImrL/ggth83w4RoJ6X8V6sCv17qYxK//7jCfN5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731983379; c=relaxed/simple;
	bh=lyq2Gvwz+rd3RyhgmFbtNJ25AUH555iQKSqWQSaqiQw=;
	h=Message-ID:Date:Subject:From:To:MIME-Version:Content-Type; b=N9/ukGxp835GTjxZNyeZOBaMKui/0ro8kWsI4LJ5/qdVtYeJrgitt9f+XAtDrDeXouG2KG5J2Su3ZO6A/20s1PYOEYvCtF684ERnF1J9MQJiJWjq97QPIcn0huYdh6eBqpKuMMRtQwivMRO/wBGf4+rHxYFzA0WxiBMC9LUTZ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluewin.ch; spf=pass smtp.mailfrom=bluewin.ch; dkim=pass (2048-bit key) header.d=bluewin.ch header.i=@bluewin.ch header.b=NKyfH/o2; arc=none smtp.client-ip=193.247.246.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluewin.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluewin.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluewin.ch header.i=@bluewin.ch header.b="NKyfH/o2"
Received: from main ([84.227.21.131])
	by vimdzmsp-sfwd06.bluewin.ch Swisscom AG with ESMTPA
	id DDxetjmttWdHXDDxetrWPB; Tue, 19 Nov 2024 03:27:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bluewin.ch;
	s=fxzs-2048-20230414; t=1731983247;
	bh=5novlyOmOxrp7FrQH+bqX03fKBi4SUXYi8nASWV6I1Q=;
	h=Message-ID:Date:Subject:From:To:MIME-Version;
	b=NKyfH/o2Kzbfozj3V/09QGyl/SLAac21VhcsqDYVzSZDj1ylr7FOP3wcMcrrvYF6y
	 IptnG+b9AjJxk/3ytdCCZ2CNw6I9SaKQ2vdza+fOxgJbxZiyTBzNUkpUdFQ5+QB9JD
	 SnupGVfTX9mssAimzdGuzNv251/TJYfByooiikzwkpuX6D5jfI8HkLWCqm3ADgEFfx
	 xL7jyNo1A2b2vlwG0jQcfTUYktH/yX7YyXKs9v7Pke8bijZjQK6/kpvZDlv/0EoJHl
	 PSPHpYCt9X7y16CTWOo/r/q8w1l8QALnVghKmRfPatZrbvF6nfLjxkKtJD0kTFih7T
	 a+z9xi4v96DGQ==
X-Bluewin-Spam-Analysis: v=2.4 cv=M5juKDws c=1 sm=1 tr=0 ts=673bf78f
 a=ig9bzvNBGao8Dw96AwO3EA==:117 a=ig9bzvNBGao8Dw96AwO3EA==:17
 a=8nJEP1OIZ-IA:10 a=VlfZXiiP6vEA:10 a=LLPZWm0_0O8A:10
 a=67-_CUpwOAyJreL14z8A:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Bluewin-Spam-Score: 0.00
X-FXIT-IP: IPv4[84.227.21.131] Epoch[1731983247]
X-Bluewin-AuthAs: public0x05bf@bluewin.ch
Received: from 10.235.1.189
        (SquirrelMail authenticated user public0x05bf)
        by main with HTTP;
        Tue, 19 Nov 2024 03:11:36 +0100
Message-ID: <d50d1467115519a407d7a987e3e1fa0a.squirrel@main>
Date: Tue, 19 Nov 2024 03:11:36 +0100
Subject: (Re ** 4)[1]: Extending "thin_trim" (about pseudo-raid)
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
X-CMAE-Envelope: MS4xfDO2miVqf9JxUpauBMX+4GBb8UytMqEdew2CpkNmijeEWqI/NgQyn3Pkk9Z3Uzek0ulTXm9bsNdhZQNxl+zZbVUlRUXPsVjcut2OgVyckwM22XzMZzte
 AH199jQHu9YxzCJkY3YsfUtiqRNtpqggihcWXbFCZ0zU5LdDrinLxx9ZFtwr+zE6/B/d4aDilGzHKNrEWEpocOwcytBJLtY54IDMEzGEkEpcLIkBzuBFmvqo
 sUQmW1FgCX0BUjnbAvaSeOab7dl2+eqhCsN+ImoZEmA=

Dear Mr. Kabelac,

I have (at first) not been aware, that at the end of your mail, you asked
me probably 'about pseudo-raid'. It is difficult for me to give you an
abstract definition of it, so I give you an example:

* splitting the device '8:16' == /dev/sdb into 17 chunks of equal size by
  the following table:

* "dmsetup table ..." --> extended by the mappig 'from the names' to
  /dev/dm-<n> (omitting "dmsetup ls", --> mapping "name -> /dev/dm-<n>"
  in a separate list).
  /dev/dm-20 <-- AFE37B55.A0:  0 86183752 linear 8:16 8
  /dev/dm-21 <-- AFE37B55.A1:  0 86183752 linear 8:16 86183760
  /dev/dm-22 <-- AFE37B55.A2:  0 86183752 linear 8:16 172367512
  /dev/dm-23 <-- AFE37B55.A3:  0 86183752 linear 8:16 258551264
  /dev/dm-24 <-- AFE37B55.A4:  0 86183752 linear 8:16 344735016
  /dev/dm-25 <-- AFE37B55.A5:  0 86183752 linear 8:16 430918768
  /dev/dm-26 <-- AFE37B55.A6:  0 86183752 linear 8:16 517102520
  /dev/dm-27 <-- AFE37B55.A7:  0 86183752 linear 8:16 603286272
  /dev/dm-28 <-- AFE37B55.A8:  0 86183752 linear 8:16 689470024
  /dev/dm-29 <-- AFE37B55.A9:  0 86183752 linear 8:16 775653776
  /dev/dm-30 <-- AFE37B55.A10: 0 86183752 linear 8:16 861837528
  /dev/dm-31 <-- AFE37B55.A11: 0 86183752 linear 8:16 948021280
  /dev/dm-32 <-- AFE37B55.A12: 0 86183752 linear 8:16 1034205032
  /dev/dm-33 <-- AFE37B55.A13: 0 86183752 linear 8:16 1120388784
  /dev/dm-34 <-- AFE37B55.A14: 0 86183752 linear 8:16 1206572536
  /dev/dm-35 <-- AFE37B55.A15: 0 86183752 linear 8:16 1292756288
  /dev/dm-36 <-- AFE37B55.A16: 0 86183752 linear 8:16 1378940040

* having a raid4 with these chunks (see /proc/mdstat):
  md255 : active raid4 dm-36[17] dm-35[15] dm-34[14] dm-33[13] \
          dm-32[12]    dm-31[11] dm-30[10] dm-29[9]  dm-28[8]  \
          dm-27[7]     dm-26[6]  dm-25[5]  dm-24[4]  dm-23[3]  \
          dm-22[2]     dm-21[1]  dm-20[0]
          689438720 blocks super 1.0 level 4, 4096k chunk,     \
          algorithm 0 [17/17] [UUUUUUUUUUUUUUUUU]

  (Ok. its actually "raid4", because distributing reads / writes on diffe-
  rent legs is not sensible, if these legs reside on the same disk.)

* according to them man page "md": MD(4)
  [...]
  In later kernels, a read-error  will  instead
  cause  md  to  attempt a recovery by overwriting the bad block. i.e. it
  will find the correct data from elsewhere, write it over the block that
  failed, and then try to read it back again.
  [Modern hard disks have spare sectors; a defective sector is at least,
  when it is written to,(sorry for my english) replaced by such a spare-
  sector.]
  [...]


Sincerely

Thomas

============================================================================
On Mon, November 18, 2024 10:28 am, Zdenek Kabelac wrote:
> Dne 17. 11. 24 v 11:26 "Thomas Bruecker" napsal(a):
>> [...]
>  [...]
>> [...]
>> * My name: "pseudo-raid": raid5 with legs on the same device, especially
>>   a hard disk. Ok, I admit, its slow.
>>   * Reason:
>>     * Modern hard disks are able to correct defective sectors, if the
>>       driver ('md') knows, what should be in these sectors.
>>     * You may not equip a notebook with additional hard disk.
> Is this some sort of 'raid1 + writemostly' ?
> And there is also another target 'dm-era' - which is however not
> supported (yet)  by lvm2...


