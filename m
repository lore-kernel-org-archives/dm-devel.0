From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH] dm thin: fix a memory leak when passing
 discard bio down
Date: Tue, 18 Apr 2017 09:59:47 +0200
Message-ID: <d08f2cac-f5aa-d797-7114-84892b986502@redhat.com>
References: <1492500426-11166-1-git-send-email-dennisyang@qnap.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1492500426-11166-1-git-send-email-dennisyang@qnap.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>, dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Dne 18.4.2017 v 09:27 Dennis Yang napsal(a):
> dm-thin does not free the discard_parent bio after all chained sub
> bios finished. The following kmemleak report could be observed after
> pool with discard_passdown option processes discard bios in
> linux v4.11-rc7. To fix this, we drop the discard_parent bio reference
> when its endio (passdown_endio) called.
> 
> unreferenced object 0xffff8803d6b29700 (size 256):
>    comm "kworker/u8:0", pid 30349, jiffies 4379504020 (age 143002.776s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      01 00 00 00 00 00 00 f0 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff81a5efd9>] kmemleak_alloc+0x49/0xa0
>      [<ffffffff8114ec34>] kmem_cache_alloc+0xb4/0x100
>      [<ffffffff8110eec0>] mempool_alloc_slab+0x10/0x20
>      [<ffffffff8110efa5>] mempool_alloc+0x55/0x150
>      [<ffffffff81374939>] bio_alloc_bioset+0xb9/0x260
>      [<ffffffffa018fd20>] process_prepared_discard_passdown_pt1+0x40/0x1c0 [dm_thin_pool]
>      [<ffffffffa018b409>] break_up_discard_bio+0x1a9/0x200 [dm_thin_pool]
>      [<ffffffffa018b484>] process_discard_cell_passdown+0x24/0x40 [dm_thin_pool]
>      [<ffffffffa018b24d>] process_discard_bio+0xdd/0xf0 [dm_thin_pool]
>      [<ffffffffa018ecf6>] do_worker+0xa76/0xd50 [dm_thin_pool]
>      [<ffffffff81086239>] process_one_work+0x139/0x370
>      [<ffffffff810867b1>] worker_thread+0x61/0x450
>      [<ffffffff8108b316>] kthread+0xd6/0xf0
>      [<ffffffff81a6cd1f>] ret_from_fork+0x3f/0x70
>      [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Signed-off-by: Dennis Yang <dennisyang@qnap.com>
> ---
>   drivers/md/dm-thin.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 2b266a2..5742e5e 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1069,6 +1069,7 @@ static void passdown_endio(struct bio *bio)
>   	 * to unmap (we ignore err).
>   	 */
>   	queue_passdown_pt2(bio->bi_private);
> +	bio_put(bio);
>   }
>   
>   static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)

Thanks

https://bugzilla.redhat.com/show_bug.cgi?id=1420462


Regards

Zdenek





https://bugzilla.redhat.com/show_bug.cgi?id=1420462
