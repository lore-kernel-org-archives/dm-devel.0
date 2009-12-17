From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 19:05:18 +0100
Message-ID: <874onptr1d.fsf@basil.nowhere.org>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
	<200912171708.07899.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765285AbZLQSFX@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912170816210.15740@localhost.localdomain> (Linus Torvalds's message of "Thu, 17 Dec 2009 08:21:10 -0800 (PST)")
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Linus Torvalds <torvalds@linux-foundation.org> writes:


> fixed that to allow checkpatch to skip those warnings, but the fact is, 
> the fundamnetal problem has always been the "80 character" part.

AFAIK it still warns for it. At least I see those warnings
regularly and I always ignore them for printk/pr_*

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
