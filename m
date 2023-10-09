Received: from w1.tutanota.de (w1.tutanota.de [81.3.6.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C0237CBD
	for <dm-devel@lists.linux.dev>; Mon,  9 Oct 2023 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="f+adL4AU"
Received: from tutadb.w10.tutanota.de (unknown [192.168.1.10])
	by w1.tutanota.de (Postfix) with ESMTP id 7D184FBFAFC;
	Mon,  9 Oct 2023 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1696868733;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=uXTHNs5qZsxdUSkSklaqpWYc9IXkpUvOTGWVFFNiNYg=;
	b=f+adL4AUV7ymHUIC8ubYy4SpC2mk8kLLtNKuX6wL1Gw3u5mdLvYyxid0tkz7oBqb
	Zq6UFYrFzSiTVOUEvIcUwxEK5S/n3Pu5LFrmP4xgeWXB+arM3U6VKCE5SKN5q+DWU0D
	rvDgO08Zq4+8ED3Ape7gTngRJsjpUYxd3I7bFcR1qZZhzAZHUngyGVWhh6N2RZKq8WL
	zoTt2Av5TQgGpAW6iuY9f2uzva66huByV6WYkiSpI60bJlHb8Qp9gnu37jZWm1v8Use
	sf7rWBAgm/cyuEgik/8eq8RHS0DUGFfvDk3UUPLvHienBqs6F1yMWIF1qbXE3jaLSzI
	0+cuSmW4sg==
Date: Mon, 9 Oct 2023 18:25:33 +0200 (CEST)
From: charlesfdotz@tutanota.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Dm Devel <dm-devel@lists.linux.dev>
Message-ID: <NgK6QGI--3-9@tutanota.com>
In-Reply-To: <12c1c045-7b52-8c7c-161c-599ceaadf48@redhat.com>
References: <NgGvkdW--3-9@tutanota.com> <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de> <12c1c045-7b52-8c7c-161c-599ceaadf48@redhat.com>
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


Oct 9, 2023, 09:43 by mpatocka@redhat.com:

>
>
> On Mon, 9 Oct 2023, Hannes Reinecke wrote:
>
>> On 10/9/23 02:56, charlesfdotz@tutanota.com wrote:
>> > Hello,
>> >
>> > I would like to request a new device manager layer be added that accep=
ts
>> > trim requests for sectors and instead
>> > writes zeros to those sectors.
>> >
>> > This would be useful to deal with SMR (shingled magnetic recording) dr=
ives
>> > that do not support trim. Currently
>> > after an SMR drive has had enough data written to it the performance d=
rops
>> > dramatically because the disk must
>> > shuffle around data as if it were full and without trim support there =
is no
>> > way to inform the disk which sectors
>> > are no longer used. Currently there's no way to "fix" or reset this wi=
thout
>> > doing an ATA secure erase despite
>> > many of these disk being sold without informing customers that they we=
re SMR
>> > drives (western digital was sued
>> > for selling SMR drives as NAS drives).
>> >
>> Gosh, no, please don't.
>> SMR drives have a write pointer, and if the zone needs to be reset you j=
ust
>> reset the write pointer. Writing zeroes will result in the opposite; the=
 zone
>> continues to be full, and no writes can happen there.
>>
>> Which drive is this?
>>
>> Cheers,
>>
>> Hannes
>>
The drive in the link is a ST8000DM004-2CX188 according to the poster. To b=
e clear I'm talking about device managed SMR drives that don't support trim=
 and do not report being SMR *not* host aware drives. The DM-SMR drives wor=
k fine until you've written their total capacity once then the write perfor=
mance craters permanently because the drive thinks all the data on it is im=
portant and has to reshuffle it constantly during writes. We are talking su=
b-1MiB/s and hangs waiting on the controller to move things around that can=
 be several minutes. WD was recently sued for selling some of these as "WD =
Red NAS" drives.

I'm not sure why writing zeros appears to work so this just speculation=C2=
=A0on my part but I was thinking the drive might be smart enough to mark se=
ctors full of zeros as unused and then return any request for an unused sec=
tor as zeros.=20
>
> BTW. what about converting trims to zone reset? If the trim spans a whole
> zone, the kernel could convert it to REQ_OP_ZONE_RESET on host-aware zone=
d
> devices.
>
> Mikulas
>
This particular request was to try and make (some) device managed SMR drive=
s that don't report to the host that they are SMR more usable. I was thinki=
ng if they are a model where zero sectors appear to "trim" one could just p=
ut this "fake-trim" device mapper layer over it and then it would act like =
a device managed SMR drive that supports trim.

Sincerely,
Chuck
