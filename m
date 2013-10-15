From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] loop: fix crash if blk_alloc_queue fails
Date: Tue, 15 Oct 2013 09:43:59 -0400
Message-ID: <20131015134359.GH3141@htj.dyndns.org>
References: <alpine.LRH.2.02.1310141138500.24159@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1310141210280.24159@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1310141211410.24159@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1310141211410.24159@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Kay Sievers <kay.sievers@vrfy.org>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Ken Chen <kenchen@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Zdenek Kabelac <zkabelac@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 14, 2013 at 12:12:24PM -0400, Mikulas Patocka wrote:
> loop: fix crash if blk_alloc_queue fails
> 
> If blk_alloc_queue fails, loop_add cleans up, but it doesn't clean up the
> identifier allocated with idr_alloc. That causes crash on module unload in
> idr_for_each(&loop_index_idr, &loop_exit_cb, NULL); where we attempt to
> remove non-existed device with that id.
...
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@kernel.org	# 3.1+

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
