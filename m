From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 20:08:57 +0200
Message-ID: <20091002180857.GM31616@kernel.dk>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com> <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com> <1253976676.7005.40.camel@marge.simson.net> <1254034500.7933.6.camel@marge.simson.net> <20090927164235.GA23126@kernel.dk> <1254340730.7695.32.camel@marge.simson.net> <1254341139.7695.36.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757878AbZJBSI4@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1254382405.7595.9.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

On Thu, Oct 01 2009, Mike Galbraith wrote:
>  	max_dispatch = cfqd->cfq_quantum;
>  	if (cfq_class_idle(cfqq))
>  		max_dispatch = 1;
>  
> +	if (cfqd->busy_queues > 1)
> +		cfqd->od_stamp = jiffies;
> +

->busy_queues > 1 just means that they have requests ready for dispatch,
not that they are dispatched.


-- 
Jens Axboe
