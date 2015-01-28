From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq DM changes for 3.20 [was: Re: blk-mq request
 allocation stalls]
Date: Wed, 28 Jan 2015 12:44:43 -0500
Message-ID: <20150128174442.GA11951@redhat.com>
References: <54B3F78D.2020704@kernel.dk> <54B3FE89.200@sandisk.com>
	<54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk> <20150127184258.GB2078@redhat.com>
	<54C91172.10002@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54C91172.10002@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Wed, Jan 28 2015 at 11:42am -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 01/27/2015 11:42 AM, Mike Snitzer wrote:
> >Hey Jens,
> >
> >I _think_ we've resolved the issues Bart raised for request-based DM's
> >support for blk-mq devices (anything remaining seems specific to iSER's
> >blk-mq support which is in development).  Though Keith did have that one
> >additional patch for that block scatter gather attribute that we still
> >need to review closer.
> >
> >Anyway, I think what we have is a solid start and see no reason to hold
> >these changes back further.  So I've rebased the 'dm-for-3.20' branch of
> >linux-dm.git ontop of 3.19-rc6 and reordered the required block changes
> >to be at the front of the series, see:
> >https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20
> >
> >(these changes have been in Linux next for a month, via linux-dm.git
> >'for-next')
> >
> >With your OK, I'd be happy to carry the required block changes and
> >ultimately request Linus pull them for 3.20 (I can backfill your Acks if
> >you approve).  BUT I also have no problem with you picking up the block
> >changes to submit via your block tree (I'd just have to rebase ontop of
> >your 3.20 branch once you pull them in).
> 
> I'd prefer to take these prep patches through the block tree.

Great, should I send the patches or can you cherry-pick?

> Only one I don't really like is this one:
> 
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20&id=23556c2461407495099d1eb20b0de43432dc727d
> 
> I prefer keeping the alloc path as lean as possible, normal allocs
> always initialize ->bio since they need to associate a bio with it.

Would be very surprised if this initialization were measurable but..
I could push this initialization into the DM-mpath driver (just after
blk_get_request, like Keith opted for) but that seemed really gross.

> Do you have the oops trace from this one? Just curious if we can get
> rid of it, depending on how deep in the caller this is.

I did't but it was easy enough to recreate:

[    3.112949] BUG: unable to handle kernel NULL pointer dereference at           (null)                                                                               |
[    3.113416] IP: [<ffffffff812f6734>] blk_rq_prep_clone+0x44/0x160                                                                                                   |
[    3.113416] PGD 0                                                                                                                                                   |
[    3.113416] Oops: 0002 [#1] SMP                                                                                                                                     |
[    3.113416] Modules linked in: dm_service_time crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel glue_helper lrw gf128mul ablk_helper crypt|
d serio_raw pcspkr virtio_balloon 8139too i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath dm_mod ext4 mbcache jbd2 sd_mod ata_generic cirrus pata_ac|
pi syscopyarea sysfillrect sysimgblt drm_kms_helper ttm drm virtio_scsi virtio_blk 8139cp virtio_pci mii i2c_core virtio_ring ata_piix virtio libata floppy            |
[    3.113416] CPU: 0 PID: 483 Comm: kdmwork-252:3 Tainted: G        W      3.18.0+ #29                                                                                |
[    3.113416] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011                                                                                                       |
[    3.113416] task: ffff880035c1ad20 ti: ffff8800d6900000 task.ti: ffff8800d6900000                                                                                   |
[    3.113416] RIP: 0010:[<ffffffff812f6734>]  [<ffffffff812f6734>] blk_rq_prep_clone+0x44/0x160                                                                       |
[    3.113416] RSP: 0000:ffff8800d6903d48  EFLAGS: 00010286                                                                                                            |
[    3.113416] RAX: 0000000000000000 RBX: ffffffffa0208500 RCX: 0000000000000001                                                                                       |
[    3.113416] RDX: ffff8800d7a3b0a0 RSI: ffff880035d0ab00 RDI: ffff880119f8f510                                                                                       |
[    3.113416] RBP: ffff8800d6903d98 R08: 00000000000185a0 R09: 00000000000000d0                                                                                       |
[    3.113416] R10: ffff8800d7547680 R11: ffff880035c1b8c8 R12: ffff8800d83d7900
[    3.113416] R13: ffff880035d0ab00 R14: ffff880119f8f510 R15: ffff8800d7547680
[    3.113416] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[    3.113416] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.113416] CR2: 0000000000000000 CR3: 00000000daeec000 CR4: 00000000000407f0
[    3.113416] Stack:
[    3.113416]  ffff8800d6903db8 ffff8800d71502e0 ffff8800d7a3b0a0 000000d0d71502e0
[    3.113416]  ffff8800d6e89800 ffff8800d71502e0 ffff8800d6e89800 0000000000000001
[    3.113416]  ffff8800d7a3b0a0 ffffc90000998040 ffff8800d6903df8 ffffffffa0209c69
[    3.113416] Call Trace:
[    3.113416]  [<ffffffffa0209c69>] map_tio_request+0x219/0x2b0 [dm_mod]
[    3.113416]  [<ffffffff8109a4ee>] kthread_worker_fn+0x7e/0x1b0
[    3.113416]  [<ffffffff8109a470>] ? __init_kthread_worker+0x60/0x60
[    3.113416]  [<ffffffff8109a3f7>] kthread+0x107/0x120
[    3.113416]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240
[    3.113416]  [<ffffffff816952bc>] ret_from_fork+0x7c/0xb0
[    3.113416]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240
[    3.113416] Code: 89 c3 48 83 ec 28 4c 8b 6e 68 48 85 d2 4c 0f 44 25 22 b7 92 01 48 89 75 b8 89 4d cc 4c 89 4d c0 4d 85 ed 75 16 eb 60 49 8b 47 70 <4c> 89 30 4d 89
77 70 4d 8b 6d 00 4d 85 ed 74 4c 8b 75 cc 4c 89
[    3.113416] RIP  [<ffffffff812f6734>] blk_rq_prep_clone+0x44/0x160
[    3.113416]  RSP <ffff8800d6903d48>
[    3.113416] CR2: 0000000000000000
[    3.113416] ---[ end trace 9b3bb6dd6cc4435d ]---

crash> dis -l blk_rq_prep_clone+0x44
/home/snitm/git/linux/block/blk-core.c: 2945
0xffffffff812f6734 <blk_rq_prep_clone+0x44>:    mov    %r14,(%rax)

crash> l /home/snitm/git/linux/block/blk-core.c: 2945
2940    
2941                    if (bio_ctr && bio_ctr(bio, bio_src, data))
2942                            goto free_and_out;
2943    
2944                    if (rq->bio) {
2945                            rq->biotail->bi_next = bio;
2946                            rq->biotail = bio;
2947                    } else
2948                            rq->bio = rq->biotail = bio;
2949            }

Given it would seem the NULL pointer occurs when attempting to
dereference rq->biotail a revised check of "if (rq->bio && rq->biotail)"
should suffice but I unfortunately then get:

[    2.801634] general protection fault: 0000 [#1] SMP
[    2.802504] Modules linked in: dm_service_time crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel glue_helper lrw gf128mul ablk_helper crypt
d pcspkr serio_raw 8139too virtio_balloon i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath dm_mod ext4 mbcache jbd2 ata_generic sd_mod pata_acpi cirr
us syscopyarea sysfillrect sysimgblt drm_kms_helper ttm virtio_scsi virtio_blk drm virtio_pci virtio_ring ata_piix 8139cp libata mii i2c_core virtio floppy
[    2.802504] CPU: 0 PID: 474 Comm: kdmwork-252:1 Tainted: G        W      3.18.0+ #30
[    2.802504] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.802504] task: ffff8801194b1690 ti: ffff880119abc000 task.ti: ffff880119abc000
[    2.802504] RIP: 0010:[<ffffffff812f6739>]  [<ffffffff812f6739>] blk_rq_prep_clone+0x49/0x160
[    2.802504] RSP: 0018:ffff880119abfd48  EFLAGS: 00010206                                                                                                            
[    2.802504] RAX: 6de900000000e800 RBX: ffffffffa0218500 RCX: 0000000000000001                                                                                       
[    2.802504] RDX: ffff8800daca30a0 RSI: ffff880119dcaf00 RDI: ffff880119dca310                                                                                       
[    2.802504] RBP: ffff880119abfd98 R08: 00000000000185a0 R09: 00000000000000d0                                                                                       
[    2.802504] R10: ffff880035937680 R11: ffff8801194b2238 R12: ffff880035876900                                                                                       
[    2.802504] R13: ffff880119dcaf00 R14: ffff880119dca310 R15: ffff880035937680                                                                                       
[    2.802504] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000                                                                            
[    2.802504] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                       
[    2.802504] CR2: 00007f45598c2350 CR3: 000000003614a000 CR4: 00000000000407f0                                                                                       
[    2.802504] Stack:                                                                                                                                                  
[    2.802504]  ffff880119abfdb8 ffff8800dae602e0 ffff8800daca30a0 000000d0dae602e0                                                                                    
[    2.802504]  ffff8800dad6a000 ffff8800dae602e0 ffff8800dad6a000 0000000000000001                                                                                    
[    2.802504]  ffff8800daca30a0 ffffc9000097d040 ffff880119abfdf8 ffffffffa0219c69                                                                                    
[    2.802504] Call Trace:                                                                                                                                             
[    2.802504]  [<ffffffffa0219c69>] map_tio_request+0x219/0x2b0 [dm_mod]                                                                                              
[    2.802504]  [<ffffffff8109a4ee>] kthread_worker_fn+0x7e/0x1b0                                                                                                      
[    2.802504]  [<ffffffff8109a470>] ? __init_kthread_worker+0x60/0x60                                                                                                 
[    2.802504]  [<ffffffff8109a3f7>] kthread+0x107/0x120                                                                                                               
[    2.802504]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240                                                                                              
[    2.802504]  [<ffffffff816952bc>] ret_from_fork+0x7c/0xb0                                                                                                           
[    2.802504]  [<ffffffff8109a2f0>] ? kthread_create_on_node+0x240/0x240                                                                                              
[    2.802504] Code: 28 4c 8b 6e 68 48 85 d2 4c 0f 44 25 22 b7 92 01 48 89 75 b8 89 4d cc 4c 89 4d c0 4d 85 ed 75 1b eb 64 49 8b 47 70 48 85 c0 74 4a <4c> 89 30 4d 89 
77 70 4d 8b 6d 00 4d 85 ed 74 4b 8b 75 cc 4c 89                                                                                                                        
[    2.802504] RIP  [<ffffffff812f6739>] blk_rq_prep_clone+0x49/0x160                                                                                                  
[    2.802504]  RSP <ffff880119abfd48>                                                                                                                                 
[    2.802386] general protection fault: 0000 [#2] [    2.893050] ---[ end trace 20d230269dc05eca ]---                                  

Not sure what to make of this (other than rq->biotail is pointing at
crap too, which is actually likely if rq->bio is):

crash> dis -l blk_rq_prep_clone+0x49
/home/snitm/git/linux/block/blk-core.c: 2945
0xffffffff812f6739 <blk_rq_prep_clone+0x49>:    mov    %r14,(%rax)

crash> l /home/snitm/git/linux/block/blk-core.c: 2945
2940    
2941                    if (bio_ctr && bio_ctr(bio, bio_src, data))
2942                            goto free_and_out;
2943    
2944                    if (rq->bio && rq->biotail) {
2945                            rq->biotail->bi_next = bio;
2946                            rq->biotail = bio;
2947                    } else
2948                            rq->bio = rq->biotail = bio;
2949            }
