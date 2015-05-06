From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Wed, 6 May 2015 09:45:18 +0200
Message-ID: <5549C68E.2050705@sandisk.com>
References: <5548CDE5.9@sandisk.com> <20150506022332.GA12096@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150506022332.GA12096@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/06/15 04:23, Mike Snitzer wrote:
> On Tue, May 05 2015 at 10:04am -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>> While retesting my SRP initiator patches on top of kernel v4.1-rc2
>> with DM_MQ_DEFAULT=y I ran into the kernel warning below. Does this
>> mean that I'm missing any device mapper related patches ? This
>> warning was reported shortly after scsi_remove_host() had been
>> invoked.
> 
> I put the warning in place because, to me, if it triggers it speaks to
> unsafe teardown occuring (request is still completing but the queue it
> was issued from no longer exists).
> 
> Like I said before I'm open to removing the WARN_ON_ONCE() if this
> scenario is perfectly valid.  But I just haven't had time to revisit
> what appears to be a potentially serious problem with the underlying
> paths' teardown vs upper level mpath IO.
> 
> I'll try to revisit this week.  But I welcome input from others too.
> 
> (Just thinking about it further now, it could be that the way the clone
> request is allocated in the case of blk-mq DM is as part of the original
> request's pdu... meaning there isn't a proper get_request() call against
> the underlying queue.. so the expected refcounting likely isn't
> happening.  And given the request won't be free'd from that underlying
> request_queue there really isn't a need to artificially link these
> cloned requests with the underlying request_queue... so I'm now leaning
> toward just removing the WARN_ON_ONCE.. but I'll look closer tomorrow)

Hello Mike,

With CONFIG_SCSI_MQ_DEFAULT=y and CONFIG_DM_MQ_DEFAULT=n I just ran into
the bug report below. I will continue my v4.1-rc2 tests with SCSI_MQ=n.

[  288.035205] BUG: unable to handle kernel NULL pointer dereference at 0000000000000068
[  288.035415] IP: [<ffffffff812bda07>] blk_rq_prep_clone+0x87/0x160
[  288.035565] PGD a1890067 PUD a432f067 PMD 0 
[  288.035753] Oops: 0000 [#1] PREEMPT SMP 
[  288.035957] Modules linked in: dm_service_time dm_multipath scsi_dh netconsole configfs fuse dm_crypt xts gf128mul algif_skcipher af_alg loop rdma_ucm rdma_cm iw_cm ib_srp scsi_transport_srp ib_ipoib ib_cm ib_uverbs ib_umad mlx4_en ptp pps_core mlx4_ib ib_sa iscsi_ibft ib_mad iscsi_boot_sysfs ib_core ib_addr af_packet mlx4_core iTCO_wdt tpm_infineon tpm_tis iTCO_vendor_support sky2 lpc_ich tpm mfd_core shpchp serio_raw acpi_cpufreq i2c_i801 asus_atk0110 button processor pcspkr coretemp dm_mod sr_mod cdrom ata_generic ata_piix firewire_ohci radeon firewire_core crc_itu_t i2c_algo_bit drm_kms_helper ttm drm pata_marvell floppy sg
[  288.040008] CPU: 0 PID: 2223 Comm: kdmwork-254:1 Not tainted 4.1.0-rc2-debug+ #4
[  288.040008] Hardware name: System manufacturer P5Q DELUXE/P5Q DELUXE, BIOS 2301    07/10/2009
[  288.040008] task: ffff8801a2f75180 ti: ffff88019d008000 task.ti: ffff88019d008000
[  288.040008] RIP: 0010:[<ffffffff812bda07>]  [<ffffffff812bda07>] blk_rq_prep_clone+0x87/0x160
[  288.040008] RSP: 0018:ffff88019d00bd38  EFLAGS: 00010246
[  288.040008] RAX: 0000000000000000 RBX: ffffffffa02914f0 RCX: 0000000000000001
[  288.040008] RDX: ffff8800a0cec660 RSI: ffff8801b7d22880 RDI: ffff8800a0cbed10
[  288.040008] RBP: ffff88019d00bd88 R08: 0000000000000020 R09: 0000000000000000
[  288.040008] R10: 0000000000000001 R11: ffff8800a0cbd200 R12: ffff8800a43cc618
[  288.040008] R13: ffff8801b7d22880 R14: ffff8800a0cbed10 R15: 0000000000000000
[  288.040008] FS:  0000000000000000(0000) GS:ffff8801bfc00000(0000) knlGS:0000000000000000
[  288.040008] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  288.040008] CR2: 0000000000000068 CR3: 00000000a1a15000 CR4: 00000000000407f0
[  288.040008] Stack:
[  288.040008]  ffff88019d00bda0 ffff88019b80c828 ffff8800a0cec660 00000020a0cec660
[  288.040008]  ffff8801b6101148 ffff8800a0cec660 0000000000000002 ffff88019b80c828
[  288.040008]  ffffc90001f12040 0000000000000000 ffff88019d00bdd8 ffffffffa0292a71
[  288.040008] Call Trace:
[  288.040008]  [<ffffffffa0292a71>] map_request.isra.39+0x191/0x230 [dm_mod]
[  288.040008]  [<ffffffffa0292b2a>] map_tio_request+0x1a/0x40 [dm_mod]
[  288.040008]  [<ffffffff8107318e>] kthread_worker_fn+0x7e/0x1b0
[  288.040008]  [<ffffffff81073110>] ? __init_kthread_worker+0x60/0x60
[  288.040008]  [<ffffffff81073099>] kthread+0xf9/0x110
[  288.040008]  [<ffffffff81072fa0>] ? kthread_create_on_node+0x230/0x230
[  288.040008]  [<ffffffff8160fee2>] ret_from_fork+0x42/0x70
[  288.040008]  [<ffffffff81072fa0>] ? kthread_create_on_node+0x230/0x230

# gdb vmlinux
(gdb) list *(blk_rq_prep_clone+0x87)
0xffffffff812bda07 is in blk_rq_prep_clone (block/blk-core.c:2976).
2971                            goto free_and_out;
2972
2973                    if (bio_ctr && bio_ctr(bio, bio_src, data))
2974                            goto free_and_out;
2975
2976                    if (rq->bio) {
2977                            rq->biotail->bi_next = bio;
2978                            rq->biotail = bio;
2979                    } else
2980                            rq->bio = rq->biotail = bio;

Bart.
