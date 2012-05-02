From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCHES]: dm lock optimization
Date: Tue, 1 May 2012 22:17:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1205012214560.24798@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1204182249060.12984@file.rdu.redhat.com>
	<4F8F9FDA.1000103@ce.jp.nec.com>
	<Pine.LNX.4.64.1204211215230.3269@file.rdu.redhat.com>
	<4F953574.3000702@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F953574.3000702@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I placed the new code using srcu here: 
http://people.redhat.com/mpatocka/patches/kernel/dm-lock-optimization/

It removes io_lock, map_lock and holders and replaces them with srcu.


On Mon, 23 Apr 2012, Jun'ichi Nomura wrote:

> Hi Mikulas,
> 
> On 04/22/12 01:17, Mikulas Patocka wrote:
> > I created new patches that use rcu instead of map_lock, so they address 
> > the issues you mentioned. Get the new patches here:
> > http://people.redhat.com/mpatocka/patches/kernel/dm-lock-optimization/
> > 
> > performance with new patches:
> > no patch:               69.3
> > patch 1:                54.0
> > patch 1,2:              44.2
> > patch 1,2,3:            39.8
> > patch 1,2,3,4:          32.7
> 
> Thank you. I have 2 comments for the new patches.
> 
> synchronize_rcu could be put in dm_table_destroy() instead of __bind().
> I think it's safer place to wait.

I think the code is more readable if synchronizing rcu is just after 
assigning the pointer that is protected by rcu.

> io_lock could be converted to SRCU.
> I.e. something like:
>   On reader-side:
>     idx = srcu_read_lock(io_srcu);
>     if (!DMF_BLOCK_IO_FOR_SUSPEND)
>       split_and_process_bio();
>     srcu_read_unlock(io_srcu,idx);
>   In dm_suspend:
>     set_bit(DMF_BLOCK_IO_FOR_SUSPEND);
>     mb();
>     synchronize_srcu(io_srcu);
>     <from here, nobody will enter split_and_process_bio>
> That makes dm-optimize-percpu-io-lock.patch simpler.
> dm-optimize-take-io_lock-on-table-swap.patch may become simpler, too.
> 
> -- 
> Jun'ichi Nomura, NEC Corporation

Mikulas
