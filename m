From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/5] block: make bio_inc_remaining()
 interface accessible again
Date: Fri, 6 May 2016 12:19:16 -0400
Message-ID: <20160506161915.GA905@redhat.com>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-3-git-send-email-snitzer@redhat.com>
	<20160506152535.GA6738@lst.de> <20160506155633.GA7318@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506155633.GA7318@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, May 06 2016 at 11:56am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, May 06, 2016 at 05:25:35PM +0200, Christoph Hellwig wrote:
> > Can you explain that code flow to me?  I still fail to why exactly
> > dm-thinp (and only dm-thinp) needs this.  Maybe start by pointing me
> > to the additional bio_endio that pairs with the bio_inc_remaining
> > call.
> > 
> > > All said, bio_inc_remaining() should really only be used in conjunction
> > > with bio_chain().  It isn't intended for generic bio reference counting.
> > 
> > It's obviously used outside bio_chain in dm-thinp, so this sentence
> > doesn't make too much sense to me.
> 
> FYI, this untested patch should fix the abuse in dm-think.  Not abusing
> bio_inc_remaining actually makes the code a lot simpler and more obvious.

But sadly I've tried this very same approach and it crashes, as I just
verified again with your patch (nevermind the fugly proprietary fusionio symbols ;):

(this is a direct result of completing the discard bio before all
mappings, and associated sub-discards, have):

73232.788728] BUG: unable to handle kernel paging request at 0000000000619df0
[73232.796519] IP: [<ffffffff810ca68a>] native_queued_spin_lock_slowpath+0x10a/0x1a0
[73232.804876] PGD 2a19e6067 PUD 29d5d0067 PMD 2a1cac067 PTE 0
[73232.811132] Oops: 0002 [#1] SMP
[73232.814750] Modules linked in: dm_thin_pool(O) dm_persistent_data(O) dm_bio_prison(O) dm_bufio(O) ext4 jbd2 mbcache iomemory_vsl(POE) iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel iTCO_wdt glue_helper iTCO_vendor_support lrw sg i7core_edac gf128mul ablk_helper edac_core ipmi_si pcspkr acpi_power_meter cryptd shpchp ipmi_msghandler lpc_ich i2c_i801 mfd_core acpi_cpufreq ip_tables xfs libcrc32c sr_mod sd_mod cdrom mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ata_generic ttm pata_acpi ixgbe igb drm mdio ata_piix ptp libata crc32c_intel i2c_algo_bit megaraid_sas pps_core skd i2c_core dca dm_mod [last unloaded: dm_bufio]
[73232.888557] CPU: 1 PID: 29156 Comm: fct0-worker Tainted: P          IOE   4.6.0-rc6.snitm+ #162
[73232.898266] Hardware name: FUJITSU                          PRIMERGY RX300 S6             /D2619, BIOS 6.00 Rev. 1.10.2619.N1           05/24/2011
[73232.912919] task: ffff880330901900 ti: ffff8802a9b54000 task.ti: ffff8802a9b54000
[73232.921269] RIP: 0010:[<ffffffff810ca68a>]  [<ffffffff810ca68a>] native_queued_spin_lock_slowpath+0x10a/0x1a0
[73232.932347] RSP: 0018:ffff8802a9b57848  EFLAGS: 00010006
[73232.938272] RAX: 0000000000003ffe RBX: 0000000000000086 RCX: 0000000000080000
[73232.946234] RDX: 0000000000619df0 RSI: 00000000ffffc900 RDI: ffff88029fc9a2cc
[73232.954197] RBP: ffff8802a9b57848 R08: ffff880333257900 R09: 0000000000000000
[73232.962161] R10: 000000009fcc5b01 R11: ffff88029fcc5e00 R12: ffff88029fc9a280
[73232.970122] R13: ffff88032f9472a0 R14: ffff88029fc9a2cc R15: 0000000000000000
[73232.978085] FS:  0000000000000000(0000) GS:ffff880333240000(0000) knlGS:0000000000000000
[73232.987115] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[73232.993524] CR2: 0000000000619df0 CR3: 00000002a1597000 CR4: 00000000000006e0
[73233.001485] Stack:
[73233.003727]  ffff8802a9b57858 ffffffff8117faf1 ffff8802a9b57870 ffffffff81695427
[73233.012017]  0000000000000000 ffff8802a9b578a8 ffffffffa0671788 ffff88029fc9a420
[73233.020307]  0000000000000000 ffff88029fc9a420 ffff88032a6442a0 0000000000000000
[73233.028598] Call Trace:
[73233.031326]  [<ffffffff8117faf1>] queued_spin_lock_slowpath+0xb/0xf
[73233.038321]  [<ffffffff81695427>] _raw_spin_lock_irqsave+0x37/0x40
[73233.045221]  [<ffffffffa0671788>] cell_defer_no_holder+0x28/0x80 [dm_thin_pool]
[73233.053378]  [<ffffffffa0671a4d>] thin_endio+0x14d/0x180 [dm_thin_pool]
[73233.060760]  [<ffffffff811e5e69>] ? kmem_cache_free+0x1c9/0x1e0
[73233.067372]  [<ffffffffa00016aa>] clone_endio+0x3a/0xe0 [dm_mod]
[73233.074076]  [<ffffffff812fb345>] bio_endio+0x55/0x60
[73233.079713]  [<ffffffffa0000d3e>] dec_pending+0x12e/0x280 [dm_mod]
[73233.086611]  [<ffffffffa00016cb>] clone_endio+0x5b/0xe0 [dm_mod]
[73233.093313]  [<ffffffff812fb345>] bio_endio+0x55/0x60
[73233.098951]  [<ffffffffa0000d3e>] dec_pending+0x12e/0x280 [dm_mod]
[73233.105849]  [<ffffffffa00016cb>] clone_endio+0x5b/0xe0 [dm_mod]
[73233.112552]  [<ffffffff812fb345>] bio_endio+0x55/0x60
[73233.118187]  [<ffffffff81303fc7>] blk_update_request+0x87/0x320
[73233.124793]  [<ffffffff8130427c>] blk_update_bidi_request+0x1c/0x70
[73233.131786]  [<ffffffff81304da7>] __blk_end_bidi_request+0x17/0x40
[73233.138684]  [<ffffffff81304de0>] __blk_end_request+0x10/0x20
[73233.145128]  [<ffffffffa0530a68>] complete_list_entries.isra.9+0x38/0x90 [iomemory_vsl]
[73233.154074]  [<ffffffffa0530b66>] kfio_blk_complete_request+0xa6/0x140 [iomemory_vsl]
[73233.162828]  [<ffffffffa0530c2c>] kfio_req_completor+0x2c/0x50 [iomemory_vsl]
[73233.170810]  [<ffffffffa054e282>] ifio_f9142.4bb664afe4728d2c3817c99088f2b5dd004.3.2.9.1461+0x12/0x50 [iomemory_vsl]
[73233.182574]  [<ffffffffa054b62c>] ? fio_device_ptrim_available+0x9c/0x2c0 [iomemory_vsl]
[73233.191606]  [<ffffffff810b57c8>] ? dequeue_entity+0x468/0x900
[73233.198136]  [<ffffffffa05b84ad>] ? ifio_1e5a3.5e62afc90b8d1b25ae145e583e480994677.3.2.9.1461+0xb0d/0x17c0 [iomemory_vsl]
[73233.210390]  [<ffffffffa05b913f>] ? ifio_1e5a3.5e62afc90b8d1b25ae145e583e480994677.3.2.9.1461+0x179f/0x17c0 [iomemory_vsl]
[73233.222740]  [<ffffffffa05bcbd0>] ? ifio_fbeca.b91e0233dee7fc9112bb37f58c4e526bcd8.3.2.9.1461+0x840/0xf20 [iomemory_vsl]
[73233.234889]  [<ffffffffa0532343>] ? __fusion_condvar_timedwait+0xb3/0x120 [iomemory_vsl]
[73233.243941]  [<ffffffffa05bdd78>] ? ifio_5fb65.a9c484151da25a9eb60ef9a6e7309d1a95f.3.2.9.1461+0xf8/0x2a0 [iomemory_vsl]
[73233.255998]  [<ffffffffa05bdc80>] ? ifio_f0cee.039ff5a1c1f314a171e2a8a425361a5875d.3.2.9.1461+0x50/0x50 [iomemory_vsl]
[73233.267960]  [<ffffffffa05bdc80>] ? ifio_f0cee.039ff5a1c1f314a171e2a8a425361a5875d.3.2.9.1461+0x50/0x50 [iomemory_vsl]
[73233.279899]  [<ffffffff8109ffe8>] ? kthread+0xd8/0xf0
[73233.285535]  [<ffffffff81695702>] ? ret_from_fork+0x22/0x40
[73233.291754]  [<ffffffff8109ff10>] ? kthread_park+0x60/0x60
[73233.297873] Code: c1 e0 10 45 31 c9 85 c0 74 46 48 89 c2 c1 e8 12 48 c1 ea 0c 83 e8 01 83 e2 30 48 98 48 81 c2 00 79 01 00 48 03 14 c5 c0 87 d1 81 <4c> 89 02 41 8b 40 08 85 c0 75 0a f3 90 41 8b 40 08 85 c0 74 f6
[73233.319551] RIP  [<ffffffff810ca68a>] native_queued_spin_lock_slowpath+0x10a/0x1a0
[73233.328010]  RSP <ffff8802a9b57848>
[73233.331899] CR2: 0000000000619df0
[73233.341412] ---[ end trace c81cf06a98ad2d88 ]---

> I'm not a 100% sure, but it seems the current pattern can also lead
> to a leak of the bi_remaining references when set_pool_mode managed
> to set a new process_prepared_discard function pointer after the
> references have been grabbed already.

We have quite a few tests in the device-mapper-test-suite that hammer
discards (in conjunction with the pool running out of space or if the
pool fails).  The replacement process_prepared_discard functions will
issue a bio_endio() per mapping anyway.. so there should be no risk of a
bi_remaining reference leaking like you thought.
 
> Jens, I noticed you've already applied this patch - I'd really prefer
> to see it reverted as using bio_inc_remaining outside bio_chain leads
> to this sort of convoluted code.

As you know not all code is simple.  I've looked at this for quite a bit
this week and unfortunately I don't see a way forward (yet) that doesn't
require the use of bio_inc_remaining() to take extra bi_remaining
references.

> ---
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index e4bb9da..5875749 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -382,7 +382,6 @@ static void end_discard(struct discard_op *op, int r)
>  	 */
>  	if (r && !op->parent_bio->bi_error)
>  		op->parent_bio->bi_error = r;
> -	bio_endio(op->parent_bio);
>  }
>  
>  /*----------------------------------------------------------------*/
> @@ -1056,11 +1055,9 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
>  	r = dm_thin_remove_range(tc->td, m->virt_begin, m->virt_end);
>  	if (r) {
>  		metadata_operation_failed(pool, "dm_thin_remove_range", r);
> -		bio_io_error(m->bio);
> -
> +		m->bio->bi_error = -EIO;
>  	} else if (m->maybe_shared) {
>  		passdown_double_checking_shared_status(m);
> -
>  	} else {
>  		struct discard_op op;
>  		begin_discard(&op, tc, m->bio);
> @@ -1069,6 +1066,7 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
>  		end_discard(&op, r);
>  	}
>  
> +	bio_endio(m->bio);
>  	cell_defer_no_holder(tc, m->cell);
>  	mempool_free(m, pool->mapping_pool);
>  }
> @@ -1537,15 +1535,6 @@ static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t
>  		m->cell = data_cell;
>  		m->bio = bio;
>  
> -		/*
> -		 * The parent bio must not complete before sub discard bios are
> -		 * chained to it (see end_discard's bio_chain)!
> -		 *
> -		 * This per-mapping bi_remaining increment is paired with
> -		 * the implicit decrement that occurs via bio_endio() in
> -		 * end_discard().
> -		 */
> -		bio_inc_remaining(bio);
>  		if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
>  			pool->process_prepared_discard(m);
>  
> @@ -1565,13 +1554,6 @@ static void process_discard_cell_passdown(struct thin_c *tc, struct dm_bio_priso
>  	 */
>  	h->cell = virt_cell;
>  	break_up_discard_bio(tc, virt_cell->key.block_begin, virt_cell->key.block_end, bio);
> -
> -	/*
> -	 * We complete the bio now, knowing that the bi_remaining field
> -	 * will prevent completion until the sub range discards have
> -	 * completed.
> -	 */
> -	bio_endio(bio);
>  }
>  
>  static void process_discard_bio(struct thin_c *tc, struct bio *bio)
