From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 23:33:39 +0100
Message-ID: <m3skb7zzcs.fsf@intrepid.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<200912171618.32882.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
	<200912171708.07899.bzolnier@gmail.com>
	<alpine.LFD.2.00.0912170816210.15740@localhost.localdomain>
	<Pine.LNX.4.64.0912181118390.23738@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933178AbZLRWdp@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0912181118390.23738@hs20-bc2-1.build.redhat.com>
	(Mikulas Patocka's message of "Fri, 18 Dec 2009 11:32:00 -0500 (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka <mpatocka@redhat.com> writes:

> It would be best to keep line length is unlimited and say that it is the 
> responsibility of the viewer to wrap it.

It would mean no continuation lines due to length at all.
Perhaps it's the way to go.
-- 
Krzysztof Halasa
