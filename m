From: Mike Galbraith <efault@gmx.de>
Subject: Re: IO scheduler based IO controller V10
Date: Mon, 28 Sep 2009 20:24:57 +0200
Message-ID: <1254162297.9820.54.camel@marge.simson.net>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com>
	 <1253976676.7005.40.camel@marge.simson.net>
	 <1254034500.7933.6.camel@marge.simson.net>
	 <20090927164235.GA23126@kernel.dk>
	 <1254075359.7354.66.camel@marge.simson.net>
	 <1254110648.7683.3.camel@marge.simson.net>
	 <20090928174809.GB3643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752830AbZI1SZM@vger.kernel.org>
In-Reply-To: <20090928174809.GB3643@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

On Mon, 2009-09-28 at 13:48 -0400, Vivek Goyal wrote:

> Hmm.., so close to 25% reduction on average in completion time of konsole.
> But this is in presece of writer. Does this help even in presence of 1 or
> more sequential readers going?

Dunno, I've only tested sequential writer.

> So here latency seems to be coming from three sources.
> 
> - Wait in CFQ before request is dispatched (only in case of competing seq readers).
> - seek latencies
> - latencies because of bigger requests are already dispatched to disk.
> 
> So limiting the size of request will help with third factor but not with first  
> two factors and here seek latencies seem to be the biggest contributor.

Yeah, seek latency seems to dominate.

	-Mike
