From: Janakiram Sistla <janakiram.sistla@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 22:00:53 +0530
Message-ID: <4fb5db50912170830q70c7069ate6ccbc698073079f@mail.gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <200912171618.32882.bzolnier@gmail.com>
	 <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
	 <200912171708.07899.bzolnier@gmail.com>
	 <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755187AbZLQQbS@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 17, 2009 at 9:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
>>
>> Well, it could have been done in the other way:
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sscanf (buf, "0x%l=
x - 0x%lx", &start_addr, &end_addr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sscanf(buf, "0x%lx=
 - 0x%lx",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
&start_addr, &end_addr);
>>
>> Just an example that the limit itself is usually not a problem
>> but its literal interpretation is..
>
> What? Your version is no better.
>
> In the above case it doesn't matter, but I've had grep's that fail du=
e to
> people splitting the actual string etc, which just drives me wild. We
> fixed that to allow checkpatch to skip those warnings, but the fact i=
s,
> the fundamnetal problem has always been the "80 character" part.
>
> I don't think any kernel developers use a vt100 any more. And even if=
 they
> do, I bet they curse the "24 lines" more than they curse the occasion=
al
> 80+ character lines.
>
> I'd be ok with changing the warning to 132 characters, which is anoth=
er
> perfectly fine historical limit. Or we can split the difference, and =
say
> "ok, 106 characters is too much". I don't care. But 80 characters is
> causing too many idiotic changes.
>
> There are way worse problems in many patches than long lines. Too com=
plex
> expressions. Too deep indentation. Pure crap code. People seem to get=
 way
> too hung up on ".. but at least it passes checkpatch".
>
I truely agree on this.It will better if we can change the warning for
100+ as suggested.This cleans the code alot infact.

-Ram
