From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 11:32:00 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912181118390.23738@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
	<200912171708.07899.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
List-Id: dm-devel.ids

On Thu, 17 Dec 2009, Linus Torvalds wrote:

> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Well, it could have been done in the other way:
> > 
> > -			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
> > +			ret = sscanf(buf, "0x%lx - 0x%lx",
> > +				     &start_addr, &end_addr);
> > 
> > Just an example that the limit itself is usually not a problem
> > but its literal interpretation is..
> 
> What? Your version is no better.
> 
> In the above case it doesn't matter, but I've had grep's that fail due to 
> people splitting the actual string etc, which just drives me wild. We 
> fixed that to allow checkpatch to skip those warnings, but the fact is, 
> the fundamnetal problem has always been the "80 character" part.
> 
> I don't think any kernel developers use a vt100 any more. And even if they 
> do, I bet they curse the "24 lines" more than they curse the occasional 
> 80+ character lines.
> 
> I'd be ok with changing the warning to 132 characters, which is another 
> perfectly fine historical limit. Or we can split the difference, and say 
> "ok, 106 characters is too much". I don't care. But 80 characters is 
> causing too many idiotic changes.

The problem with 106 character --- I have 100-character display on one 
computer. If the code were be formatted for 106 characters, it would look 
like
					bla - bla - bla - bla - bla -
bla -
					bla - bla - bla - bla - bla - 
bla;

--- i.e. every second line wasted.

On the other hand, if you go without limit, it will be
					bla - bla - bla - bla -
bla - bla - bla - bla - bla - bla - bla - bla;

--- much better.

The same problem comes for 132 chatacters --- many people have 
128-character display (1024x768 framebuffer) and they see spurious 
wrapping with 132 character text.

In general, if you select "n" as a line width, you find someone with 
"n - delta" column display who will have problems.

It would be best to keep line length is unlimited and say that it is the 
responsibility of the viewer to wrap it.

And make limit of 80 characters only for block comments --- the reader 
doesn't want to read wrapped words in comments.

Mikulas

> There are way worse problems in many patches than long lines. Too complex 
> expressions. Too deep indentation. Pure crap code. People seem to get way 
> too hung up on ".. but at least it passes checkpatch". 
> 
> 		Linus
> 
