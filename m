From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 20:22:34 +0200
Message-ID: <1254507754.8667.15.camel@marge.simson.net>
References: <20091002092839.GA26962@kernel.dk>
	 <alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	 <20091002145610.GD31616@kernel.dk>
	 <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk> <20091002175629.GA14860@elte.hu>
	 <20091002180437.GL31616@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758029AbZJBSWi@vger.kernel.org>
In-Reply-To: <20091002180437.GL31616@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Fri, 2009-10-02 at 20:04 +0200, Jens Axboe wrote:

> I'm not too crazy about it either. How about just using 'desktop' since
> this is obviously what we are really targetting? 'latency' isn't fully
> descriptive either, since it may not necessarily provide the best single
> IO latency (noop would).

Grin. "Perfect is the enemy of good" :)
                                                  Avg
     16.24   175.82   154.38   228.97   147.16  144.5     noop
     43.23    57.39    96.13   148.25   180.09  105.0     deadline
