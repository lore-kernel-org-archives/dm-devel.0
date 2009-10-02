From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 02 Oct 2009 20:29:57 +0200
Message-ID: <1254508197.8667.22.camel@marge.simson.net>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254340730.7695.32.camel@marge.simson.net>
	 <1254341139.7695.36.camel@marge.simson.net>
	 <20090930202447.GA28236@redhat.com>
	 <1254382405.7595.9.camel@marge.simson.net>
	 <20091002180857.GM31616@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758064AbZJBSaB@vger.kernel.org>
In-Reply-To: <20091002180857.GM31616@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

On Fri, 2009-10-02 at 20:08 +0200, Jens Axboe wrote:
> On Thu, Oct 01 2009, Mike Galbraith wrote:
> >  	max_dispatch = cfqd->cfq_quantum;
> >  	if (cfq_class_idle(cfqq))
> >  		max_dispatch = 1;
> >  
> > +	if (cfqd->busy_queues > 1)
> > +		cfqd->od_stamp = jiffies;
> > +
> 
> ->busy_queues > 1 just means that they have requests ready for dispatch,
> not that they are dispatched.

But we're not alone, somebody else is using disk.  I'm trying to make
sure we don't have someone _about_ to come back.. like a reader, so when
there's another player, stamp to give him some time to wake up/submit
before putting the pedal to the metal.

	-Mike
