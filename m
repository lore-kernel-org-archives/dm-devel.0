From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 17:08:07 +0100
Message-ID: <200912171708.07899.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
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
Cc: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thursday 17 December 2009 04:37:41 pm Linus Torvalds wrote:
> 
> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Examples? :)
> 
> They're typically things like this:
> 
> -			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
> +			ret = sscanf(buf, "0x%lx - 0x%lx", &start_addr,
> +				&end_addr);
> 
> ie a line-break that is just annoying and makes the code harder to read 
> rather than easier. 

Well, it could have been done in the other way:

-			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
+			ret = sscanf(buf, "0x%lx - 0x%lx",
+				     &start_addr, &end_addr);

Just an example that the limit itself is usually not a problem
but its literal interpretation is..

I don't feel strongly about it the either way so how's about just
adding the switch and than changing the default (Alasdair?) on top
of it?

--
Bartlomiej Zolnierkiewicz
