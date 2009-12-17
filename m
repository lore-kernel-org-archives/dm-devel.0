From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 08:21:10 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
	<200912171708.07899.bzolnier@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200912171708.07899.bzolnier@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> 
> Well, it could have been done in the other way:
> 
> -			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
> +			ret = sscanf(buf, "0x%lx - 0x%lx",
> +				     &start_addr, &end_addr);
> 
> Just an example that the limit itself is usually not a problem
> but its literal interpretation is..

What? Your version is no better.

In the above case it doesn't matter, but I've had grep's that fail due to 
people splitting the actual string etc, which just drives me wild. We 
fixed that to allow checkpatch to skip those warnings, but the fact is, 
the fundamnetal problem has always been the "80 character" part.

I don't think any kernel developers use a vt100 any more. And even if they 
do, I bet they curse the "24 lines" more than they curse the occasional 
80+ character lines.

I'd be ok with changing the warning to 132 characters, which is another 
perfectly fine historical limit. Or we can split the difference, and say 
"ok, 106 characters is too much". I don't care. But 80 characters is 
causing too many idiotic changes.

There are way worse problems in many patches than long lines. Too complex 
expressions. Too deep indentation. Pure crap code. People seem to get way 
too hung up on ".. but at least it passes checkpatch". 

		Linus
