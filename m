From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 20:57:18 +0200
Message-ID: <1254509838.8667.30.camel@marge.simson.net>
References: <20091002092839.GA26962@kernel.dk>
	 <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	 <20091002145610.GD31616@kernel.dk>
	 <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755973AbZJBS5Y@vger.kernel.org>
In-Reply-To: <20091002181903.GN31616@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Fri, 2009-10-02 at 20:19 +0200, Jens Axboe wrote:

> I'm not too worried about the "single IO producer" scenarios, and it
> looks like (from a quick look) that most of your numbers are within some
> expected noise levels. It's the more complex mixes that are likely to
> cause a bit of a stink, but lets worry about that later. One quick thing
> would be to read eg 2 or more files sequentially from disk and see how
> that performs.

Hm.  git(s) should be good for a nice repeatable load.  Suggestions?

> If you could do a cleaned up version of your overload patch based on
> this:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1d2235152dc745c6d94bedb550fea84cffdbf768
> 
> then lets take it from there.

I'll try to find a good repeatable git beater first.  At this point, I
only know it helps with one load.

	-Mike
