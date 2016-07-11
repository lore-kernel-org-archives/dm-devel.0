From: Jon Bernard <jbernard@tuxion.com>
Subject: poor thin performance, relative to thick
Date: Mon, 11 Jul 2016 16:44:54 -0400
Message-ID: <20160711204454.GA24378@helmut>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I have recently noticed a large difference in performance between thick
and thin LVM volumes and I'm trying to understand why that it the case.

In summary, for the same FIO test (attached), I'm seeing 560k iops on a
thick volume vs. 200k iops for a thin volume and these results are
pretty consistent across different runs.

I noticed that if I run two FIO tests simultaneously on 2 separate thin
pools, I net nearly double the performance of a single pool.  And two
tests on thin volumes within the same pool will split the maximum iops
of the single pool (essentially half).  And I see similar results from
linux 3.10 and 4.6.

I understand that thin must track metadata as part of its design and so
some additional overhead is to be expected, but I'm wondering if we can
narrow the gap a bit.

In case it helps, I also enabled LOCK_STAT and gathered locking
statistics for both thick and thin runs (attached).

I'm curious to know whether this is a know issue, and if I can do
anything the help improve the situation.  I wonder if the use of the
primary spinlock in the pool structure could be improved - the lock
statistics appear to indicate a significant amount of time contending
with that one.  Or maybe it's something else entirely, and in that case
please enlighten me.

If there are any specific questions or tests I can run, I'm happy to do
so.  Let me know how I can help.

-- 
Jon

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="read_rand.fio"

[random]
direct=1 
rw=randrw 
zero_buffers 
norandommap 
randrepeat=0 
ioengine=libaio
group_reporting
rwmixread=100 
bs=4k 
iodepth=32 
numjobs=16 
runtime=600

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="thick-fio-stdout.txt"

# fio --filename=/dev/mapper/thin-thick read_rand.fio                                      
random: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
...
fio-2.2.8
Starting 16 processes
Jobs: 16 (f=16): [r(16)] [100.0% done] [863.4MB/0KB/0KB /s] [221K/0/0 iops] [eta 00m:00s]
random: (groupid=0, jobs=16): err= 0: pid=8912: Wed Jun 22 14:53:39 2016
  read : io=529123MB, bw=903035KB/s, iops=225758, runt=600001msec
    slat (usec): min=6, max=53714, avg=64.57, stdev=93.39
    clat (usec): min=2, max=113018, avg=2201.86, stdev=974.65
     lat (usec): min=51, max=113057, avg=2266.66, stdev=995.55
    clat percentiles (usec):
     |  1.00th=[ 1020],  5.00th=[ 1240], 10.00th=[ 1480], 20.00th=[ 1736],
     | 30.00th=[ 1864], 40.00th=[ 1976], 50.00th=[ 2096], 60.00th=[ 2192],
     | 70.00th=[ 2320], 80.00th=[ 2512], 90.00th=[ 2800], 95.00th=[ 3216],
     | 99.00th=[ 5792], 99.50th=[ 7520], 99.90th=[13248], 99.95th=[16064],
     | 99.99th=[23424]
    bw (KB  /s): min= 3258, max=133280, per=6.25%, avg=56450.27, stdev=10373.47
    lat (usec) : 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%
    lat (usec) : 250=0.01%, 500=0.02%, 750=0.02%, 1000=0.77%
    lat (msec) : 2=41.23%, 4=55.40%, 10=2.32%, 20=0.21%, 50=0.02%
    lat (msec) : 100=0.01%, 250=0.01%
  cpu          : usr=2.16%, sys=95.78%, ctx=1049239, majf=0, minf=18932
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=135455419/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
   READ: io=529123MB, aggrb=903034KB/s, minb=903034KB/s, maxb=903034KB/s, mint=600001msec, maxt=600001msec

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="thick-lock-stats.txt"

lock_stat version 0.4
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        &(&ioc->scsi_lookup_lock)->rlock:     323309477      354021096           0.08        1219.27  5755299178.37          16.26      396179743      406370664           0.05          19.51   330766679.12           0.81
        --------------------------------
        &(&ioc->scsi_lookup_lock)->rlock      117750632          [<ffffffffa01ada2a>] mpt3sas_base_get_smid_scsiio+0x2a/0xa0 [mpt3sas]
        &(&ioc->scsi_lookup_lock)->rlock      117934146          [<ffffffffa01b8400>] _scsih_io_done+0x40/0x9f0 [mpt3sas]
        &(&ioc->scsi_lookup_lock)->rlock      118336318          [<ffffffffa01adb3e>] mpt3sas_base_free_smid+0x2e/0x230 [mpt3sas]
        --------------------------------
        &(&ioc->scsi_lookup_lock)->rlock      106315683          [<ffffffffa01ada2a>] mpt3sas_base_get_smid_scsiio+0x2a/0xa0 [mpt3sas]
        &(&ioc->scsi_lookup_lock)->rlock      117493014          [<ffffffffa01b8400>] _scsih_io_done+0x40/0x9f0 [mpt3sas]
        &(&ioc->scsi_lookup_lock)->rlock      130212399          [<ffffffffa01adb3e>] mpt3sas_base_free_smid+0x2e/0x230 [mpt3sas]

.............................................................................................................................................................................................................................

              &(&q->__queue_lock)->rlock:     164901352      164973127           0.07         228.68   337677482.74           2.05      479757372      677287100           0.06          39.06   752383611.73           1.11
              --------------------------
              &(&q->__queue_lock)->rlock       32326526          [<ffffffff81331caf>] blk_queue_bio+0x9f/0x3d0
              &(&q->__queue_lock)->rlock       33711083          [<ffffffff814e70dd>] scsi_request_fn+0x49d/0x640
              &(&q->__queue_lock)->rlock       31251091          [<ffffffff81331b85>] blk_flush_plug_list+0x175/0x200
              &(&q->__queue_lock)->rlock       31915411          [<ffffffff814e5dae>] scsi_end_request+0x10e/0x1e0
              --------------------------
              &(&q->__queue_lock)->rlock       66075480          [<ffffffff81331b85>] blk_flush_plug_list+0x175/0x200
              &(&q->__queue_lock)->rlock       24384772          [<ffffffff81331caf>] blk_queue_bio+0x9f/0x3d0
              &(&q->__queue_lock)->rlock       12263113          [<ffffffff814e70dd>] scsi_request_fn+0x49d/0x640
              &(&q->__queue_lock)->rlock       52494314          [<ffffffff814e5dae>] scsi_end_request+0x10e/0x1e0

.............................................................................................................................................................................................................................

              &(&sdev->list_lock)->rlock:       1246128        1246366           0.07          10.47      620751.44           0.50      256954899      270913982           0.06          19.56    99705779.19           0.37
              --------------------------
              &(&sdev->list_lock)->rlock         429898          [<ffffffff814ddda9>] scsi_put_command+0x29/0xd0
              &(&sdev->list_lock)->rlock         816468          [<ffffffff814ddc79>] scsi_get_command+0xb9/0x1c0
              --------------------------
              &(&sdev->list_lock)->rlock         192437          [<ffffffff814ddc79>] scsi_get_command+0xb9/0x1c0
              &(&sdev->list_lock)->rlock        1053929          [<ffffffff814ddda9>] scsi_put_command+0x29/0xd0

.............................................................................................................................................................................................................................

                               &rq->lock:         54823          55182           0.13          11.58      101630.09           1.84        4948876       27447986           0.05          33.03    42269136.88           1.54
                               ---------
                               &rq->lock           8959          [<ffffffff810b13a5>] try_to_wake_up+0x1d5/0x460
                               &rq->lock           3602          [<ffffffff810bc724>] update_blocked_averages+0x34/0x490
                               &rq->lock              7          [<ffffffff810b2763>] wake_up_new_task+0xd3/0x280
                               &rq->lock           4456          [<ffffffff8173a324>] __schedule+0x94/0x970
                               ---------
                               &rq->lock           7614          [<ffffffff810b13a5>] try_to_wake_up+0x1d5/0x460
                               &rq->lock             82          [<ffffffff810c3b66>] update_cpu_load_nohz+0x46/0x90
                               &rq->lock             10          [<ffffffff810b2763>] wake_up_new_task+0xd3/0x280
                               &rq->lock          19861          [<ffffffff8173a324>] __schedule+0x94/0x970

.............................................................................................................................................................................................................................

                              &ctx->wait:         42463          42465           0.14          18.21       28938.15           0.68        1747597        3321398           0.06          29.33     3941975.17           1.19
                              ----------
                              &ctx->wait           8532          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                              &ctx->wait          33933          [<ffffffff810cc233>] finish_wait+0x43/0x80
                              ----------
                              &ctx->wait           7918          [<ffffffff810cc233>] finish_wait+0x43/0x80
                              &ctx->wait          34178          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                              &ctx->wait            369          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0

.............................................................................................................................................................................................................................

                            jiffies_lock:         23404          23474           0.22          15.85       28344.50           1.21         347370         629177           0.23          22.68      603590.58           0.96
                            ------------
                            jiffies_lock          23474          [<ffffffff8110f9cb>] tick_do_update_jiffies64+0x3b/0x150
                            ------------
                            jiffies_lock          23474          [<ffffffff8110f9cb>] tick_do_update_jiffies64+0x3b/0x150

.............................................................................................................................................................................................................................

                   random_read_wait.lock:         17513          17513           0.14          19.30       42096.74           2.40        1617602        1617973           0.10          28.13     6151274.50           3.80
                   ---------------------
                   random_read_wait.lock          17513          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                   ---------------------
                   random_read_wait.lock          17513          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

         &(&ctx->completion_lock)->rlock:          2331           2333           0.10           1.41         813.84           0.35         250716      135455423           0.10          18.35    27584883.43           0.20
         -------------------------------
         &(&ctx->completion_lock)->rlock           2333          [<ffffffff8127165f>] aio_complete+0x6f/0x350
         -------------------------------
         &(&ctx->completion_lock)->rlock           2333          [<ffffffff8127165f>] aio_complete+0x6f/0x350

.............................................................................................................................................................................................................................

                 &(&n->list_lock)->rlock:          2118           2121           0.12           3.56        1088.36           0.51        1097814        1797468           0.11          13.22      885214.21           0.49
                 -----------------------
                 &(&n->list_lock)->rlock           1829          [<ffffffff811fb48b>] get_partial_node.isra.68+0x4b/0x250
                 &(&n->list_lock)->rlock            245          [<ffffffff811fb23a>] unfreeze_partials.isra.67+0x6a/0x160
                 &(&n->list_lock)->rlock             47          [<ffffffff811fb792>] __slab_free+0x102/0x240
                 -----------------------
                 &(&n->list_lock)->rlock           1496          [<ffffffff811fb48b>] get_partial_node.isra.68+0x4b/0x250
                 &(&n->list_lock)->rlock            597          [<ffffffff811fb23a>] unfreeze_partials.isra.67+0x6a/0x160
                 &(&n->list_lock)->rlock             28          [<ffffffff811fb792>] __slab_free+0x102/0x240

.............................................................................................................................................................................................................................

                              rcu_node_0:           943            968           0.12           7.00         614.25           0.63          87791         163701           0.06          39.99       59444.79           0.36
                              ----------
                              rcu_node_0            918          [<ffffffff810f850d>] rcu_process_callbacks+0xed/0x6d0
                              rcu_node_0              5          [<ffffffff810f6cd8>] rcu_nocb_kthread+0x2c8/0x5c0
                              rcu_node_0             16          [<ffffffff810f88a2>] rcu_process_callbacks+0x482/0x6d0
                              rcu_node_0             21          [<ffffffff810f77f6>] force_qs_rnp+0x96/0x160
                              ----------
                              rcu_node_0             17          [<ffffffff810f8075>] rcu_gp_kthread+0x7b5/0xa40
                              rcu_node_0             18          [<ffffffff810f6cd8>] rcu_nocb_kthread+0x2c8/0x5c0
                              rcu_node_0            780          [<ffffffff810f850d>] rcu_process_callbacks+0xed/0x6d0
                              rcu_node_0             86          [<ffffffff810f77f6>] force_qs_rnp+0x96/0x160

.............................................................................................................................................................................................................................

                   &(&zone->lock)->rlock:           649            652           0.15          15.54         328.87           0.50         442510         969922           0.11          18.89      310359.54           0.32
                   ---------------------
                   &(&zone->lock)->rlock            408          [<ffffffff811a5ee3>] get_page_from_freelist+0x7b3/0xa30
                   &(&zone->lock)->rlock            233          [<ffffffff811a4578>] free_one_page+0x38/0x2e0
                   &(&zone->lock)->rlock              8          [<ffffffff811a3f83>] free_pcppages_bulk+0x33/0x450
                   &(&zone->lock)->rlock              3          [<ffffffff811a5c62>] get_page_from_freelist+0x532/0xa30
                   ---------------------
                   &(&zone->lock)->rlock            409          [<ffffffff811a5ee3>] get_page_from_freelist+0x7b3/0xa30
                   &(&zone->lock)->rlock            203          [<ffffffff811a4578>] free_one_page+0x38/0x2e0
                   &(&zone->lock)->rlock             33          [<ffffffff811a3f83>] free_pcppages_bulk+0x33/0x450
                   &(&zone->lock)->rlock              7          [<ffffffff811a5c62>] get_page_from_freelist+0x532/0xa30

.............................................................................................................................................................................................................................

                            kernfs_mutex:           198            198           6.38         541.32        9428.75          47.62            948          56987           0.10          30.55       11504.05           0.20
                            ------------
                            kernfs_mutex              4          [<ffffffff812a34f9>] kernfs_iop_follow_link+0x69/0x1c0
                            kernfs_mutex             70          [<ffffffff812a0618>] kernfs_dop_revalidate+0x38/0xc0
                            kernfs_mutex            111          [<ffffffff8129fd54>] kernfs_iop_permission+0x34/0x60
                            kernfs_mutex             11          [<ffffffff812a0cbd>] kernfs_fop_readdir+0x10d/0x250
                            ------------
                            kernfs_mutex              3          [<ffffffff812a0c08>] kernfs_fop_readdir+0x58/0x250
                            kernfs_mutex             12          [<ffffffff812a34f9>] kernfs_iop_follow_link+0x69/0x1c0
                            kernfs_mutex             89          [<ffffffff8129fd54>] kernfs_iop_permission+0x34/0x60
                            kernfs_mutex              4          [<ffffffff8129fcea>] kernfs_iop_getattr+0x2a/0x60

.............................................................................................................................................................................................................................

                    &irq_desc_lock_class:           140            140           0.23           9.25         523.44           3.74           7888      207045273           0.06          20.23    36087804.28           0.17
                    --------------------
                    &irq_desc_lock_class             60          [<ffffffff810eab04>] handle_irq_event+0x44/0x60
                    &irq_desc_lock_class             71          [<ffffffff810edfc0>] handle_edge_irq+0x20/0x140
                    &irq_desc_lock_class              9          [<ffffffff810f2561>] show_interrupts+0x131/0x370
                    --------------------
                    &irq_desc_lock_class            121          [<ffffffff810f2561>] show_interrupts+0x131/0x370
                    &irq_desc_lock_class              7          [<ffffffff810edfc0>] handle_edge_irq+0x20/0x140
                    &irq_desc_lock_class              8          [<ffffffff810ec2b4>] __irq_set_affinity+0x34/0x70
                    &irq_desc_lock_class              4          [<ffffffff810eab04>] handle_irq_event+0x44/0x60

.............................................................................................................................................................................................................................

            &(ptlock_ptr(page))->rlock#2:           135            135           0.19          12.15         212.97           1.58          11805         148779           0.09        4763.10      110750.84           0.74
            ----------------------------
            &(ptlock_ptr(page))->rlock#2             10          [<ffffffff811cf1b7>] handle_pte_fault+0x1177/0x14c0
            &(ptlock_ptr(page))->rlock#2             32          [<ffffffff81201fdc>] remove_migration_pte+0xcc/0x300
            &(ptlock_ptr(page))->rlock#2              7          [<ffffffff8120286a>] __migration_entry_wait+0x1a/0xf0
            &(ptlock_ptr(page))->rlock#2             53          [<ffffffff811da173>] __page_check_address+0xe3/0x1d0
            ----------------------------
            &(ptlock_ptr(page))->rlock#2             10          [<ffffffff811cf1b7>] handle_pte_fault+0x1177/0x14c0
            &(ptlock_ptr(page))->rlock#2              4          [<ffffffff8120286a>] __migration_entry_wait+0x1a/0xf0
            &(ptlock_ptr(page))->rlock#2             30          [<ffffffff81201fdc>] remove_migration_pte+0xcc/0x300
            &(ptlock_ptr(page))->rlock#2             76          [<ffffffff811da173>] __page_check_address+0xe3/0x1d0

.............................................................................................................................................................................................................................

                   &(&base->lock)->rlock:           119            121           0.15           1.42          53.12           0.44          18180       31105320           0.09          90.43     5226569.56           0.17
                   ---------------------
                   &(&base->lock)->rlock             62          [<ffffffff810fc854>] lock_timer_base.isra.31+0x54/0x70
                   &(&base->lock)->rlock             27          [<ffffffff810fcd9f>] run_timer_softirq+0x25f/0x310
                   &(&base->lock)->rlock             17          [<ffffffff810ff130>] get_next_timer_interrupt+0x60/0x240
                   &(&base->lock)->rlock              6          [<ffffffff810fe99a>] add_timer_on+0x8a/0x190
                   ---------------------
                   &(&base->lock)->rlock             33          [<ffffffff810fcd9f>] run_timer_softirq+0x25f/0x310
                   &(&base->lock)->rlock             56          [<ffffffff810fc854>] lock_timer_base.isra.31+0x54/0x70
                   &(&base->lock)->rlock              7          [<ffffffff810fe99a>] add_timer_on+0x8a/0x190
                   &(&base->lock)->rlock             15          [<ffffffff810ff130>] get_next_timer_interrupt+0x60/0x240

.............................................................................................................................................................................................................................

                         &pool->lock#2/1:            78             79           0.20           5.70         133.19           1.69          10931          64226           0.11          22.88      110985.81           1.73
                         ---------------
                         &pool->lock#2/1             19          [<ffffffff8109d980>] process_one_work+0x2a0/0x570
                         &pool->lock#2/1              1          [<ffffffff8109c47b>] flush_work+0x9b/0x280
                         &pool->lock#2/1             34          [<ffffffff8109c0e8>] __queue_work+0x278/0x3c0
                         &pool->lock#2/1             24          [<ffffffff8109dde5>] worker_thread+0x195/0x460
                         ---------------
                         &pool->lock#2/1              4          [<ffffffff8109c47b>] flush_work+0x9b/0x280
                         &pool->lock#2/1             16          [<ffffffff8109dde5>] worker_thread+0x195/0x460
                         &pool->lock#2/1             43          [<ffffffff8109c0e8>] __queue_work+0x278/0x3c0
                         &pool->lock#2/1             16          [<ffffffff8109d980>] process_one_work+0x2a0/0x570

.............................................................................................................................................................................................................................

   &(&(__futex_data.queues)[i].lock)->rl:            74             75           0.16           1.18          22.37           0.30           1012          11967           0.05        2986.31       23813.57           1.99
   -------------------------------------
   &(&(__futex_data.queues)[i].lock)->rl             17          [<ffffffff8111275c>] futex_wait_setup+0xbc/0x140
   &(&(__futex_data.queues)[i].lock)->rl             58          [<ffffffff81111b98>] futex_wake+0xc8/0x170
   -------------------------------------
   &(&(__futex_data.queues)[i].lock)->rl             12          [<ffffffff811123dc>] futex_wake_op+0x3cc/0x630
   &(&(__futex_data.queues)[i].lock)->rl             57          [<ffffffff8111275c>] futex_wait_setup+0xbc/0x140
   &(&(__futex_data.queues)[i].lock)->rl              5          [<ffffffff811123ea>] futex_wake_op+0x3da/0x630
   &(&(__futex_data.queues)[i].lock)->rl              1          [<ffffffff81111b98>] futex_wake+0xc8/0x170

.............................................................................................................................................................................................................................

                &mapping->i_mmap_rwsem-W:            27             30           0.14          35.51         209.63           6.99           1977           8012           0.10          16.20        3028.71           0.38
                &mapping->i_mmap_rwsem-R:             1              5           8.41          19.14          70.43          14.09             13             58           0.62          29.03         457.62           7.89
                ------------------------
                  &mapping->i_mmap_rwsem             30          [<ffffffff811d43e2>] unlink_file_vma+0x32/0x60
                  &mapping->i_mmap_rwsem              5          [<ffffffff811db748>] rmap_walk+0x68/0x2f0
                ------------------------
                  &mapping->i_mmap_rwsem             27          [<ffffffff811d43e2>] unlink_file_vma+0x32/0x60
                  &mapping->i_mmap_rwsem              8          [<ffffffff811db748>] rmap_walk+0x68/0x2f0

.............................................................................................................................................................................................................................

               &(&zone->lru_lock)->rlock:            32             33           0.24           5.95          48.51           1.47            548          18737           0.13          17.17        8785.45           0.47
               -------------------------
               &(&zone->lru_lock)->rlock             11          [<ffffffff811abcd5>] pagevec_lru_move_fn+0x95/0x110
               &(&zone->lru_lock)->rlock              1          [<ffffffff811b121e>] isolate_lru_page+0x5e/0x140
               &(&zone->lru_lock)->rlock             21          [<ffffffff811abb3b>] release_pages+0x15b/0x260
               -------------------------
               &(&zone->lru_lock)->rlock             11          [<ffffffff811abcd5>] pagevec_lru_move_fn+0x95/0x110
               &(&zone->lru_lock)->rlock              2          [<ffffffff811b121e>] isolate_lru_page+0x5e/0x140
               &(&zone->lru_lock)->rlock             20          [<ffffffff811abb3b>] release_pages+0x15b/0x260

.............................................................................................................................................................................................................................

                           slock-AF_INET:            32             32           0.31        1189.05        3604.86         112.65           1485           4809           0.09        2544.33        8747.29           1.82
                           -------------
                           slock-AF_INET             31          [<ffffffff815eb3af>] lock_sock_nested+0x3f/0xb0
                           slock-AF_INET              1          [<ffffffff815ecef7>] release_sock+0x37/0x1b0
                           -------------
                           slock-AF_INET             31          [<ffffffff81672b37>] tcp_v4_rcv+0x9a7/0xbd0
                           slock-AF_INET              1          [<ffffffff8166b35c>] tcp_tasklet_func+0xdc/0x130

.............................................................................................................................................................................................................................

                      &anon_vma->rwsem-W:            25             25           0.10           1.05          10.87           0.43           1412          21325           0.05         741.60       15417.46           0.72
                      &anon_vma->rwsem-R:             0              0           0.00           0.00           0.00           0.00             94            704           0.38         158.93        3846.03           5.46
                      ------------------
                        &anon_vma->rwsem             23          [<ffffffff811db1b4>] unlink_anon_vmas+0x94/0x1c0
                        &anon_vma->rwsem              2          [<ffffffff811dad8d>] __put_anon_vma+0x3d/0xc0
                      ------------------
                        &anon_vma->rwsem             25          [<ffffffff811db1b4>] unlink_anon_vmas+0x94/0x1c0

.............................................................................................................................................................................................................................

                    zone->wait_table + i:            23             23           0.16          44.58          57.28           2.49            759           1135           0.12          67.12        2290.19           2.02
                    --------------------
                    zone->wait_table + i             22          [<ffffffff810cbfe7>] prepare_to_wait+0x27/0x90
                    zone->wait_table + i              1          [<ffffffff810cc233>] finish_wait+0x43/0x80
                    --------------------
                    zone->wait_table + i             22          [<ffffffff810cbfe7>] prepare_to_wait+0x27/0x90
                    zone->wait_table + i              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                           log_wait.lock:            22             22           0.54           9.39          80.61           3.66             62             91           0.63           8.46         339.85           3.73
                           -------------
                           log_wait.lock             22          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                           -------------
                           log_wait.lock             22          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                             logbuf_lock:             0             20           0.30           1.72          16.38           0.82             58          11187           0.10          13.51        2465.46           0.22
                             -----------
                             logbuf_lock             11          [<ffffffff810e7c62>] devkmsg_read+0x82/0x2d0
                             logbuf_lock              9          [<ffffffff810e67b4>] devkmsg_poll+0x44/0x80
                             -----------
                             logbuf_lock             11          [<ffffffff810e67b4>] devkmsg_poll+0x44/0x80
                             logbuf_lock              9          [<ffffffff810e7c62>] devkmsg_read+0x82/0x2d0

.............................................................................................................................................................................................................................

       &(&dentry->d_lockref.lock)->rlock:            20             20           0.27           1.29           8.98           0.45           4643         189468           0.06        1685.49       71664.45           0.38
       ---------------------------------
       &(&dentry->d_lockref.lock)->rlock              8          [<ffffffff81236fce>] dput+0x11e/0x2b0
       &(&dentry->d_lockref.lock)->rlock             10          [<ffffffff8136c5cf>] lockref_get_not_dead+0xf/0x50
       &(&dentry->d_lockref.lock)->rlock              1          [<ffffffff8136c4fd>] lockref_get+0xd/0x20
       &(&dentry->d_lockref.lock)->rlock              1          [<ffffffff81239ea4>] __d_lookup+0xa4/0x1b0
       ---------------------------------
       &(&dentry->d_lockref.lock)->rlock             10          [<ffffffff81236fce>] dput+0x11e/0x2b0
       &(&dentry->d_lockref.lock)->rlock              6          [<ffffffff8136c5cf>] lockref_get_not_dead+0xf/0x50
       &(&dentry->d_lockref.lock)->rlock              2          [<ffffffff8136c4fd>] lockref_get+0xd/0x20
       &(&dentry->d_lockref.lock)->rlock              1          [<ffffffff8136c59d>] lockref_put_or_lock+0xd/0x30

.............................................................................................................................................................................................................................

                     &rnp->nocb_gp_wq[1]:            16             19           0.28           9.13          32.09           1.69            372            776           0.10          24.64        1166.96           1.50
                     -------------------
                     &rnp->nocb_gp_wq[1]             11          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                     &rnp->nocb_gp_wq[1]              8          [<ffffffff810cc233>] finish_wait+0x43/0x80
                     -------------------
                     &rnp->nocb_gp_wq[1]             12          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                     &rnp->nocb_gp_wq[1]              5          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                     &rnp->nocb_gp_wq[1]              2          [<ffffffff810cc233>] finish_wait+0x43/0x80

.............................................................................................................................................................................................................................

             &(&sighand->siglock)->rlock:            15             15           0.36          35.34         113.68           7.58            540           5202           0.07          21.11        2656.68           0.51
             ---------------------------
             &(&sighand->siglock)->rlock              6          [<ffffffff810927c9>] exit_signals+0xa9/0x150
             &(&sighand->siglock)->rlock              3          [<ffffffff8115287f>] taskstats_exit+0x7f/0x410
             &(&sighand->siglock)->rlock              4          [<ffffffff8111e470>] acct_collect+0x1c0/0x1e0
             &(&sighand->siglock)->rlock              2          [<ffffffff81083a79>] release_task+0xf9/0x510
             ---------------------------
             &(&sighand->siglock)->rlock              3          [<ffffffff810927c9>] exit_signals+0xa9/0x150
             &(&sighand->siglock)->rlock              6          [<ffffffff8115287f>] taskstats_exit+0x7f/0x410
             &(&sighand->siglock)->rlock              6          [<ffffffff81083a79>] release_task+0xf9/0x510

.............................................................................................................................................................................................................................

                               pcpu_lock:            12             15           0.28           1.41          13.63           0.91             45             98           0.18           2.30          67.23           0.69
                               ---------
                               pcpu_lock              2          [<ffffffff811c041e>] pcpu_alloc+0x7e/0x640
                               pcpu_lock             13          [<ffffffff811bfec0>] free_percpu+0x40/0x170
                               ---------
                               pcpu_lock              2          [<ffffffff811c041e>] pcpu_alloc+0x7e/0x640
                               pcpu_lock             13          [<ffffffff811bfec0>] free_percpu+0x40/0x170

.............................................................................................................................................................................................................................

                     &rnp->nocb_gp_wq[0]:            13             14           0.26          24.44          72.36           5.17            355            761           0.10          39.29        1129.47           1.48
                     -------------------
                     &rnp->nocb_gp_wq[0]              8          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                     &rnp->nocb_gp_wq[0]              6          [<ffffffff810cc233>] finish_wait+0x43/0x80
                     -------------------
                     &rnp->nocb_gp_wq[0]              6          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                     &rnp->nocb_gp_wq[0]              5          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                     &rnp->nocb_gp_wq[0]              3          [<ffffffff810cc233>] finish_wait+0x43/0x80

.............................................................................................................................................................................................................................

                             vector_lock:            12             13           0.26          16.64          46.81           3.60           1476           2644           0.15          41.71        7231.25           2.73
                             -----------
                             vector_lock              3          [<ffffffff81057fbf>] assign_irq_vector+0x2f/0x430
                             vector_lock              5          [<ffffffff810588ec>] smp_irq_move_cleanup_interrupt+0x4c/0x1b0
                             vector_lock              3          [<ffffffff81058942>] smp_irq_move_cleanup_interrupt+0xa2/0x1b0
                             vector_lock              2          [<ffffffff81057c8b>] __send_cleanup_vector+0x1b/0x80
                             -----------
                             vector_lock              9          [<ffffffff810588ec>] smp_irq_move_cleanup_interrupt+0x4c/0x1b0
                             vector_lock              2          [<ffffffff81057fbf>] assign_irq_vector+0x2f/0x430
                             vector_lock              1          [<ffffffff81058942>] smp_irq_move_cleanup_interrupt+0xa2/0x1b0
                             vector_lock              1          [<ffffffff81057c8b>] __send_cleanup_vector+0x1b/0x80

.............................................................................................................................................................................................................................

                     &(&ep->lock)->rlock:            12             12           0.29           0.86           5.76           0.48            637           4359           0.10          16.56        2332.30           0.54
                     -------------------
                     &(&ep->lock)->rlock              3          [<ffffffff8126bae6>] ep_scan_ready_list+0x56/0x210
                     &(&ep->lock)->rlock              5          [<ffffffff8126c0e6>] ep_poll_callback+0x36/0x1c0
                     &(&ep->lock)->rlock              2          [<ffffffff8126bb47>] ep_scan_ready_list+0xb7/0x210
                     &(&ep->lock)->rlock              1          [<ffffffff8126bdb9>] ep_poll+0xe9/0x320
                     -------------------
                     &(&ep->lock)->rlock              8          [<ffffffff8126c0e6>] ep_poll_callback+0x36/0x1c0
                     &(&ep->lock)->rlock              2          [<ffffffff8126bae6>] ep_scan_ready_list+0x56/0x210
                     &(&ep->lock)->rlock              1          [<ffffffff8126bdb9>] ep_poll+0xe9/0x320
                     &(&ep->lock)->rlock              1          [<ffffffff8126bf36>] ep_poll+0x266/0x320

.............................................................................................................................................................................................................................

                         tasklist_lock-W:             8              8           0.30          40.14          74.32           9.29            104            194           0.29          21.70         686.48           3.54
                         tasklist_lock-R:             0              0           0.00           0.00           0.00           0.00           4224         916572           0.11        8937.06     2040411.30           2.23
                         ---------------
                           tasklist_lock              5          [<ffffffff81085474>] do_exit+0x374/0xb80
                           tasklist_lock              3          [<ffffffff81083a17>] release_task+0x97/0x510
                         ---------------
                           tasklist_lock              3          [<ffffffff81085474>] do_exit+0x374/0xb80
                           tasklist_lock              5          [<ffffffff81083a17>] release_task+0x97/0x510

.............................................................................................................................................................................................................................

                             &rsp->gp_wq:             7              7           0.20           4.81           8.96           1.28           1038          14917           0.10          26.19        6518.98           0.44
                             -----------
                             &rsp->gp_wq              7          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                             -----------
                             &rsp->gp_wq              7          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                         &mm->mmap_sem-W:             2              2          12.07          12.88          24.96          12.48            123           9182           0.10        9874.48      111097.53          12.10
                         &mm->mmap_sem-R:             3              4           1.16          26.07          50.40          12.60            435          91254           0.23       16705.75      491896.12           5.39
                         ---------------
                           &mm->mmap_sem              2          [<ffffffff811e14d0>] SyS_madvise+0x560/0x720
                           &mm->mmap_sem              2          [<ffffffff811d5fa6>] vm_munmap+0x36/0x60
                           &mm->mmap_sem              2          [<ffffffff8108527e>] do_exit+0x17e/0xb80
                         ---------------
                           &mm->mmap_sem              2          [<ffffffff811d5fa6>] vm_munmap+0x36/0x60
                           &mm->mmap_sem              4          [<ffffffff811e14d0>] SyS_madvise+0x560/0x720

.............................................................................................................................................................................................................................

                      &(&u->lock)->rlock:             6              6           0.18           0.59           2.38           0.40            391           1068           0.10          57.30         622.82           0.58
                      ------------------
                      &(&u->lock)->rlock              5          [<ffffffff816c0c5f>] unix_stream_read_generic+0x15f/0x900
                      &(&u->lock)->rlock              1          [<ffffffff816bff12>] unix_stream_sendmsg+0x172/0x3c0
                      ------------------
                      &(&u->lock)->rlock              5          [<ffffffff816bff12>] unix_stream_sendmsg+0x172/0x3c0
                      &(&u->lock)->rlock              1          [<ffffffff816c0820>] unix_release_sock+0xa0/0x350

.............................................................................................................................................................................................................................

   &(&(__futex_data.queues)[i].lock)->/1:             5              5           0.18           0.51           1.82           0.36            338            382           0.08           2.00         156.19           0.41
   -------------------------------------
   &(&(__futex_data.queues)[i].lock)->/1              5          [<ffffffff811123ea>] futex_wake_op+0x3da/0x630
   -------------------------------------
   &(&(__futex_data.queues)[i].lock)->/1              5          [<ffffffff8111275c>] futex_wait_setup+0xbc/0x140

.............................................................................................................................................................................................................................

                           callback_lock:             3              3           0.40           1.08           2.09           0.70             42             48           0.25          18.96          53.43           1.11
                           -------------
                           callback_lock              3          [<ffffffff81130f84>] cpuset_cpus_allowed+0x24/0xa0
                           -------------
                           callback_lock              3          [<ffffffff81130f84>] cpuset_cpus_allowed+0x24/0xa0

.............................................................................................................................................................................................................................

                         &sem->wait_lock:             3              3           0.49           4.27           6.58           2.19             41             61           0.13           9.87         117.73           1.93
                         ---------------
                         &sem->wait_lock              1          [<ffffffff810dbe4c>] rwsem_wake+0x7c/0xa0
                         &sem->wait_lock              2          [<ffffffff8173ee9d>] rwsem_down_write_failed+0x1bd/0x390
                         ---------------
                         &sem->wait_lock              2          [<ffffffff810dbe4c>] rwsem_wake+0x7c/0xa0
                         &sem->wait_lock              1          [<ffffffff8173ee9d>] rwsem_down_write_failed+0x1bd/0x390

.............................................................................................................................................................................................................................

                       &pmd->root_lock-W:             0              0           0.00           0.00           0.00           0.00             63             67        5059.46       27647.39      650602.46        9710.48
                       &pmd->root_lock-R:             2              2        6002.03        7582.72       13584.75        6792.37            474           3165           0.10        4542.03       14844.84           4.69
                       -----------------
                         &pmd->root_lock              2          [<ffffffffa087efde>] dm_pool_issue_prefetches+0x1e/0x40 [dm_thin_pool]
                       -----------------
                         &pmd->root_lock              2          [<ffffffffa087e9a6>] dm_pool_commit_metadata+0x26/0x60 [dm_thin_pool]

.............................................................................................................................................................................................................................

                         &tty->read_wait:             2              2           0.31           0.87           1.17           0.59            639           3922           0.10          22.49        5122.56           1.31
                         ---------------
                         &tty->read_wait              1          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40
                         &tty->read_wait              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                         ---------------
                         &tty->read_wait              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                         &tty->read_wait              1          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40

.............................................................................................................................................................................................................................

                            css_set_lock:             2              2           0.67           3.58           4.25           2.12             92            224           0.12          31.28         728.23           3.25
                            ------------
                            css_set_lock              2          [<ffffffff8112b432>] cgroup_exit+0x32/0xa0
                            ------------
                            css_set_lock              2          [<ffffffff8112b432>] cgroup_exit+0x32/0xa0

.............................................................................................................................................................................................................................

                   &(&host->lock)->rlock:             2              2           0.57           0.58           1.15           0.57            128            225           0.28           7.17         576.02           2.56
                   ---------------------
                   &(&host->lock)->rlock              2          [<ffffffffa006765d>] ata_scsi_queuecmd+0x2d/0x3e0 [libata]
                   ---------------------
                   &(&host->lock)->rlock              1          [<ffffffffa002c1f2>] ahci_single_level_irq_intr+0x32/0x60 [libahci]
                   &(&host->lock)->rlock              1          [<ffffffffa006765d>] ata_scsi_queuecmd+0x2d/0x3e0 [libata]

.............................................................................................................................................................................................................................

                    hrtimer_bases.lock#1:             2              2           0.61           0.80           1.41           0.71              8        4094555           0.09          16.29     1451964.95           0.35
                    --------------------
                    hrtimer_bases.lock#1              2          [<ffffffff810ffa09>] lock_hrtimer_base.isra.23+0x29/0x50
                    --------------------
                    hrtimer_bases.lock#1              2          [<ffffffff810ffa09>] lock_hrtimer_base.isra.23+0x29/0x50

.............................................................................................................................................................................................................................

                        &tty->write_wait:             1              1           1.32           1.32           1.32           1.32           1015           4712           0.10          14.30        1025.87           0.22
                        ----------------
                        &tty->write_wait              1          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40
                        ----------------
                        &tty->write_wait              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                           &u->peer_wait:             1              1          90.43          90.43          90.43          90.43             57            169           0.11         146.57         187.68           1.11
                           -------------
                           &u->peer_wait              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                           -------------
                           &u->peer_wait              1          [<ffffffff816be213>] unix_dgram_peer_wake_disconnect+0x23/0x70

.............................................................................................................................................................................................................................

                             &p->pi_lock:             1              1           1.72           1.72           1.72           1.72        1707977        3003964           0.09          30.77     9382919.05           3.12
                             -----------
                             &p->pi_lock              1          [<ffffffff810b1201>] try_to_wake_up+0x31/0x460
                             -----------
                             &p->pi_lock              1          [<ffffffff810b1201>] try_to_wake_up+0x31/0x460

.............................................................................................................................................................................................................................

              &group->notification_waitq:             1              1           0.44           0.44           0.44           0.44            259           1137           0.10           9.19         729.72           0.64
              --------------------------
              &group->notification_waitq              1          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40
              --------------------------
              &group->notification_waitq              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

            percpu_ref_switch_waitq.lock:             1              1           0.74           0.74           0.74           0.74             32             33           0.14           0.70          11.43           0.35
            ----------------------------
            percpu_ref_switch_waitq.lock              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50
            ----------------------------
            percpu_ref_switch_waitq.lock              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                                   key#3:             1              1           0.37           0.37           0.37           0.37             21            162           0.10           0.43          22.32           0.14
                                   -----
                                   key#3              1          [<ffffffff813874e1>] __percpu_counter_add+0x41/0x70
                                   -----
                                   key#3              1          [<ffffffff813874e1>] __percpu_counter_add+0x41/0x70

.............................................................................................................................................................................................................................

                               &wq->wait:             1              1           3.48           3.48           3.48           3.48           1051           5099           0.10          20.07        4723.88           0.93
                               ---------
                               &wq->wait              1          [<ffffffff810cc198>] __wake_up_sync_key+0x28/0x60
                               ---------
                               &wq->wait              1          [<ffffffff810cc198>] __wake_up_sync_key+0x28/0x60

.............................................................................................................................................................................................................................

                  kernfs_open_file_mutex:             1              1          35.27          35.27          35.27          35.27             62            325           0.36          19.80         210.65           0.65
                  ----------------------
                  kernfs_open_file_mutex              1          [<ffffffff812a315c>] kernfs_fop_open+0x1dc/0x370
                  ----------------------
                  kernfs_open_file_mutex              1          [<ffffffff812a2d17>] kernfs_put_open_node.isra.3+0x27/0x90

.............................................................................................................................................................................................................................

                            memtype_lock:             0              0           0.00           0.00           0.00           0.00              8             12           0.53           2.36          13.94           1.16
                           watchdog_lock:             0              0           0.00           0.00           0.00           0.00           1351           1351           1.73         552.25        4637.23           3.43
                          &port_lock_key:             0              0           0.00           0.00           0.00           0.00              2              4           1.86           2.42           8.38           2.10
                              text_mutex:             0              0           0.00           0.00           0.00           0.00              6             40          34.31        2967.64       13619.38         340.48
                                pgd_lock:             0              0           0.00           0.00           0.00           0.00             47             77           0.17           1.10          36.72           0.48
                            console_lock:             0              0           0.00           0.00           0.00           0.00              0           3373           2.55       22955.01      164888.27          48.88
                      (console_sem).lock:             0              0           0.00           0.00           0.00           0.00              0           6746           0.10           2.25        1599.86           0.24
                      cpu_hotplug.lock#2:             0              0           0.00           0.00           0.00           0.00             15            721           0.15          13.13         222.36           0.31
                               tk_core-W:             0              0           0.00           0.00           0.00           0.00              0         597054           0.24          15.62      486498.04           0.81
                               tk_core-R:             0              0           0.00           0.00           0.00           0.00              0      401194893           0.05          27.38    29552318.47           0.07
                      cpu_hotplug.lock-R:             0              0           0.00           0.00           0.00           0.00              0            721           1.79        2968.39       18293.38          25.37
                            cgroup_mutex:             0              0           0.00           0.00           0.00           0.00             11             50           2.05      202873.29      203601.78        4072.04
                         timekeeper_lock:             0              0           0.00           0.00           0.00           0.00         322560         605555           0.12          16.69      993566.66           1.64
                                rtc_lock:             0              0           0.00           0.00           0.00           0.00              0              1          31.98          31.98          31.98          31.98
                    hrtimer_bases.lock#7:             0              0           0.00           0.00           0.00           0.00              6         940982           0.10          15.40      436232.30           0.46
         &(&s->s_inode_list_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             33            244           0.10           0.68          48.87           0.20
                    hrtimer_bases.lock#3:             0              0           0.00           0.00           0.00           0.00              8        3607477           0.09          20.51     1345992.85           0.37
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              2         900736           0.10          14.44      425423.22           0.47
                          mount_lock#2-R:             0              0           0.00           0.00           0.00           0.00              0          65221           0.05           0.64        5551.17           0.09
                            init_fs.lock:             0              0           0.00           0.00           0.00           0.00              8             10           0.18           1.43           5.29           0.53
                           init_fs.seq-R:             0              0           0.00           0.00           0.00           0.00              0            234           0.05           0.21          20.10           0.09
               &sb->s_type->i_lock_key#2:             0              0           0.00           0.00           0.00           0.00              4             27           0.10           0.64           5.70           0.21
                      proc_subdir_lock-R:             0              0           0.00           0.00           0.00           0.00             49          11547           0.13        5853.57       21121.08           1.83
                             sysctl_lock:             0              0           0.00           0.00           0.00           0.00              4             77           0.10           8.55          19.17           0.25
                         rename_lock#2-W:             0              0           0.00           0.00           0.00           0.00              0             24           2.17           5.59          80.20           3.34
                         rename_lock#2-R:             0              0           0.00           0.00           0.00           0.00              0          12034           0.05           0.44         965.03           0.08
                         cgroup_idr_lock:             0              0           0.00           0.00           0.00           0.00              2              3           0.38           1.41           2.71           0.90
                     cgroup_file_kn_lock:             0              0           0.00           0.00           0.00           0.00              2              2           0.43           0.57           0.99           0.50
                       uevent_sock_mutex:             0              0           0.00           0.00           0.00           0.00              3              5          13.53          31.53         111.79          22.36
              &sb->s_type->i_mutex_key#1:             0              0           0.00           0.00           0.00           0.00              5            347           0.14           0.74          62.07           0.18
             &cgroup_threadgroup_rwsem-W:             0              0           0.00           0.00           0.00           0.00              1              6           4.77          41.29          68.93          11.49
             &cgroup_threadgroup_rwsem-R:             0              0           0.00           0.00           0.00           0.00              0            117           0.10         528.11        8546.93          73.05
                    init_files.file_lock:             0              0           0.00           0.00           0.00           0.00              1              1           2.04           2.04           2.04           2.04
                        pcpu_alloc_mutex:             0              0           0.00           0.00           0.00           0.00             19             49           0.15           3.87          20.72           0.42
                             ioapic_lock:             0              0           0.00           0.00           0.00           0.00              0           1496           0.12           2.26         446.57           0.30
                  &rt_b->rt_runtime_lock:             0              0           0.00           0.00           0.00           0.00           4057           4394           0.14          14.03        1715.47           0.39
                                 sb_lock:             0              0           0.00           0.00           0.00           0.00             15             16           1.72           7.85          50.87           3.18
                         resource_lock-R:             0              0           0.00           0.00           0.00           0.00              8             24           0.61           3.76          35.42           1.48
                     file_systems_lock-R:             0              0           0.00           0.00           0.00           0.00              4              5           4.96          12.24          48.02           9.60
                &(&stopper->lock)->rlock:             0              0           0.00           0.00           0.00           0.00         248102         620620           0.10           9.24      411324.40           0.66
                         simple_ida_lock:             0              0           0.00           0.00           0.00           0.00              8             18           0.23           1.98          17.22           0.96
                              &wq->mutex:             0              0           0.00           0.00           0.00           0.00              2              8           0.51          17.24          26.62           3.33
                              ((&timer)):             0              0           0.00           0.00           0.00           0.00              0          35807           0.05        2383.95      105436.42           2.94
                           &rdp->nocb_wq:             0              0           0.00           0.00           0.00           0.00            912           2320           0.10          14.19        3424.03           1.48
              &(&newf->file_lock)->rlock:             0              0           0.00           0.00           0.00           0.00            178          10691           0.10         638.03        5963.04           0.56
        &(&p->vtime_seqlock)->seqcount-R:             0              0           0.00           0.00           0.00           0.00              0            332           0.05           0.21          24.42           0.07
                 &rt_rq->rt_runtime_lock:             0              0           0.00           0.00           0.00           0.00           7751           8527           0.10           2.23        2215.34           0.26
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              4        7624618           0.09          19.87     2060701.39           0.27
                               bdev_lock:             0              0           0.00           0.00           0.00           0.00             25             52           0.13           4.69          30.46           0.59
                          rcu_callback-R:             0              0           0.00           0.00           0.00           0.00              0          29587           0.11        1843.31       16468.33           0.56
                    hrtimer_bases.lock#4:             0              0           0.00           0.00           0.00           0.00              2        4562867           0.09          14.55     1353499.14           0.30
                    hrtimer_bases.lock#5:             0              0           0.00           0.00           0.00           0.00             10        5074650           0.09          14.76     1435082.49           0.28
                    hrtimer_bases.lock#6:             0              0           0.00           0.00           0.00           0.00              4        2248291           0.09          15.05      861911.33           0.38
                    hrtimer_bases.lock#8:             0              0           0.00           0.00           0.00           0.00             16         834511           0.09          14.85      406407.85           0.49
                    hrtimer_bases.lock#9:             0              0           0.00           0.00           0.00           0.00              6         776825           0.10          14.67      387003.62           0.50
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00             12         929302           0.10          23.41      433479.40           0.47
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              2         746314           0.10          20.46      371742.27           0.50
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              2        4384122           0.09           6.03     1535760.91           0.35
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              2        1172025           0.10           6.01      609822.61           0.52
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              0        2237117           0.09          14.60      821655.01           0.37
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              0        2509880           0.09          12.25      933491.61           0.37
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              2        2435756           0.09           6.15      858026.90           0.35
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              8         828633           0.10          15.41      404444.24           0.49
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              2         920012           0.10           5.77      423459.05           0.46
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              0         973366           0.10           5.71      445440.99           0.46
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              0         832334           0.10          15.03      396124.99           0.48
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              0         845706           0.10           5.77      402691.65           0.48
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              0        1001471           0.10          16.52      450940.52           0.45
                        stop_cpus_lock-R:             0              0           0.00           0.00           0.00           0.00              0             15           5.06          41.88         131.81           8.79
                              &x->wait#2:             0              0           0.00           0.00           0.00           0.00             71            131           0.10          31.68         102.66           0.78
               &sb->s_type->i_lock_key#5:             0              0           0.00           0.00           0.00           0.00             86            851           0.08          18.49         206.75           0.24
                               balancing:             0              0           0.00           0.00           0.00           0.00              0        1795278           0.06        7935.07      816810.95           0.45
                              &fs->seq-W:             0              0           0.00           0.00           0.00           0.00              0              2           0.06           0.09           0.15           0.07
                              &fs->seq-R:             0              0           0.00           0.00           0.00           0.00              0          64792           0.05           0.58        5856.06           0.09
            &(&sbinfo->stat_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             12             66           0.10           1.28          12.16           0.18
               &sb->s_type->i_lock_key#6:             0              0           0.00           0.00           0.00           0.00              5             20           0.14           0.58           4.99           0.25
                             rename_lock:             0              0           0.00           0.00           0.00           0.00              5             24           2.40           6.50          88.69           3.70
                        &dentry->d_seq-W:             0              0           0.00           0.00           0.00           0.00              0             24           0.71           2.06          28.38           1.18
                        &dentry->d_seq-R:             0              0           0.00           0.00           0.00           0.00              0           7244           0.05           0.44         534.37           0.07
                     &(&fs->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             75            121           0.10           2.92          51.66           0.43
                      "events_unbound"-R:             0              0           0.00           0.00           0.00           0.00              0            786           0.06        6387.47       30054.47          38.24
                    &(&k->k_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              1            213           0.11           0.64          33.00           0.15
        &(&mapping->private_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             31             45           0.11           4.23          27.12           0.60
                              rtnl_mutex:             0              0           0.00           0.00           0.00           0.00              0              5           3.02         566.59         581.11         116.22
                           binfmt_lock-R:             0              0           0.00           0.00           0.00           0.00              8             38           0.12           0.71           9.27           0.24
               &sb->s_type->i_lock_key#8:             0              0           0.00           0.00           0.00           0.00             12            616           0.08         504.12         836.76           1.36
                    &(&idp->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              3             20           0.12           1.08           5.44           0.27
                 &(&pool->lock)->rlock#2:             0              0           0.00           0.00           0.00           0.00           3892          40823           0.11          20.38       58947.68           1.44
                     &pool->attach_mutex:             0              0           0.00           0.00           0.00           0.00              5              9           0.41           1.55           8.41           0.93
                                &x->wait:             0              0           0.00           0.00           0.00           0.00             14             18           0.15           7.18          23.55           1.31
                     kthread_create_lock:             0              0           0.00           0.00           0.00           0.00              6             15           0.12           0.48           3.97           0.26
                           irq_2_ir_lock:             0              0           0.00           0.00           0.00           0.00             33            909           1.72           4.23        2105.88           2.32
                      khugepaged_mm_lock:             0              0           0.00           0.00           0.00           0.00             47            246           0.10          34.94         135.75           0.55
                         sparse_irq_lock:             0              0           0.00           0.00           0.00           0.00             35         200480           0.14        2703.87      301087.41           1.50
   &(*(&acpi_gbl_reference_count_lock))-:             0              0           0.00           0.00           0.00           0.00              0         185504           0.10          13.87       30757.42           0.17
                    khugepaged_wait.lock:             0              0           0.00           0.00           0.00           0.00             27            204           0.10           1.65          53.95           0.26
                        block_class_lock:             0              0           0.00           0.00           0.00           0.00             21             46           0.21           3.76          51.18           1.11
         &(*(&acpi_gbl_gpe_lock))->rlock:             0              0           0.00           0.00           0.00           0.00           2992           2992           2.24          25.78       21109.87           7.06
                               &pl->lock:             0              0           0.00           0.00           0.00           0.00             11             21           1.90           4.41          55.35           2.64
                      &pool->manager_arb:             0              0           0.00           0.00           0.00           0.00              0              5          88.05         157.54         586.75         117.35
                 ((&pool->mayday_timer)):             0              0           0.00           0.00           0.00           0.00              0              5           0.08           0.17           0.72           0.14
                              "kacpid"-R:             0              0           0.00           0.00           0.00           0.00              0           1496          70.74       76506.08     1928188.41        1288.90
                            (&dpc->work):             0              0           0.00           0.00           0.00           0.00              0           1496          70.53       76505.75     1924711.57        1286.57
                        "kacpi_notify"-R:             0              0           0.00           0.00           0.00           0.00              0           1496           2.93        3109.86       28683.07          19.17
                          (&dpc->work)#2:             0              0           0.00           0.00           0.00           0.00              0           1496           2.75        3109.53       27950.11          18.68
                            sb_writers-R:             0              0           0.00           0.00           0.00           0.00              0            114           0.28           2.61          95.85           0.84
              &sb->s_type->i_mutex_key#5:             0              0           0.00           0.00           0.00           0.00             12             46           0.43           1.40          42.12           0.92
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00             29            153           0.08           1.66          40.25           0.26
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00              4             18           0.08           1.75           9.95           0.55
                            s_active#1-W:             0              0           0.00           0.00           0.00           0.00              1              7           0.24           0.62           2.92           0.42
                            s_active#1-R:             0              0           0.00           0.00           0.00           0.00              0             36           0.77          11.60         123.53           3.43
                              "events"-R:             0              0           0.00           0.00           0.00           0.00              0           1502           1.85       51024.03      504283.56         335.74
                              &x->wait#6:             0              0           0.00           0.00           0.00           0.00             14            102           0.11          10.36         139.45           1.37
                           (&barr->work):             0              0           0.00           0.00           0.00           0.00              0             31           2.49          14.19         155.63           5.02
                 &(&xattrs->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             17             65           0.10           0.42          10.97           0.17
                         sk_lock-AF_UNIX:             0              0           0.00           0.00           0.00           0.00              0             16           0.16           0.99           6.55           0.41
                              &tbl->lock:             0              0           0.00           0.00           0.00           0.00              0             90           0.70          84.25         211.39           2.35
              "events_power_efficient"-R:             0              0           0.00           0.00           0.00           0.00              0           3471           1.86       22957.09      242443.95          69.85
              (check_lifetime_work).work:             0              0           0.00           0.00           0.00           0.00              0              6          47.23          98.16         443.09          73.85
            (&(&l->destroy_dwork)->work):             0              0           0.00           0.00           0.00           0.00              0              5           1.32           2.83           9.91           1.98
                   rcu_read_lock_sched-R:             0              0           0.00           0.00           0.00           0.00              0     1896387964           0.05       22500.39   370638680.79           0.20
           &(&mapping->tree_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           5572         133278           0.09          16.55       19750.87           0.15
                     fs/file_table.c:262:             0              0           0.00           0.00           0.00           0.00              0              4           2.30           3.82          12.06           3.01
                (delayed_fput_work).work:             0              0           0.00           0.00           0.00           0.00              0              4           6.46          40.32          79.14          19.79
                                     key:             0              0           0.00           0.00           0.00           0.00              2              2           0.32           0.41           0.73           0.36
                &child->perf_event_mutex:             0              0           0.00           0.00           0.00           0.00             52             58           0.20           6.57          39.21           0.68
                     &sig->wait_chldexit:             0              0           0.00           0.00           0.00           0.00           4150        1833015           0.10           5.81      298953.87           0.16
     &(&(&sig->stats_lock)->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             66             86           0.27          10.28         159.45           1.85
         &(&sig->stats_lock)->seqcount-W:             0              0           0.00           0.00           0.00           0.00              0             86           0.09           7.04         111.32           1.29
         &(&sig->stats_lock)->seqcount-R:             0              0           0.00           0.00           0.00           0.00              0             29           0.05           0.12           1.89           0.07
                     audit_freelist_lock:             0              0           0.00           0.00           0.00           0.00              2             14           0.14           0.82           4.03           0.29
                           key_user_lock:             0              0           0.00           0.00           0.00           0.00              1              1           0.57           0.57           0.57           0.57
                         key_serial_lock:             0              0           0.00           0.00           0.00           0.00              3             10           0.15           2.12           7.21           0.72
                  key_construction_mutex:             0              0           0.00           0.00           0.00           0.00              1              1           2.73           2.73           2.73           2.73
                       keyring_name_lock:             0              0           0.00           0.00           0.00           0.00              2              2           0.48           1.01           1.49           0.74
                            destroy_lock:             0              0           0.00           0.00           0.00           0.00             10             10           0.18           0.75           3.69           0.37
               &(&sp->queue_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              3             10           0.12           0.81           3.22           0.32
                      destroy_waitq.lock:             0              0           0.00           0.00           0.00           0.00             10             20           0.10           6.64          31.20           1.56
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00             16            112           0.09           1.94          35.64           0.32
        &(kretprobe_table_locks[i].lock):             0              0           0.00           0.00           0.00           0.00             55             58           0.11           3.88          23.53           0.41
                              &x->wait#8:             0              0           0.00           0.00           0.00           0.00              2              3           0.23           3.18           3.67           1.22
                       (&sub_info->work):             0              0           0.00           0.00           0.00           0.00              0              1          38.10          38.10          38.10          38.10
                         umh_sysctl_lock:             0              0           0.00           0.00           0.00           0.00              1              1           0.55           0.55           0.55           0.55
                  &sig->cred_guard_mutex:             0              0           0.00           0.00           0.00           0.00             13             14           0.50         729.85        4412.19         315.16
          &(&mm->page_table_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             20            696           0.10           1.61         119.92           0.17
              &(ptlock_ptr(page))->rlock:             0              0           0.00           0.00           0.00           0.00            895          19027           0.11        3049.63       19804.75           1.04
                         &bdev->bd_mutex:             0              0           0.00           0.00           0.00           0.00             44            138           0.14         169.97         934.99           6.78
          &(ptlock_ptr(page))->rlock#2/1:             0              0           0.00           0.00           0.00           0.00            120           1580           0.12          25.94         838.35           0.53
                               uts_sem-R:             0              0           0.00           0.00           0.00           0.00              5              5           0.30           0.89           2.65           0.53
     &(&dentry->d_lockref.lock)->rlock/1:             0              0           0.00           0.00           0.00           0.00             29            100           0.11           2.90          36.01           0.36
                             &prev->lock:             0              0           0.00           0.00           0.00           0.00             56             61           0.12           0.69          19.72           0.32
              running_helpers_waitq.lock:             0              0           0.00           0.00           0.00           0.00              1              1           0.56           0.56           0.56           0.56
                    (&ops->cursor_timer):             0              0           0.00           0.00           0.00           0.00              0           3373           1.22        1134.87       28551.59           8.46
                          (&info->queue):             0              0           0.00           0.00           0.00           0.00              0           3373           3.44       22956.81      228855.81          67.85
                            &port->mutex:             0              0           0.00           0.00           0.00           0.00              2              4           2.32           3.27          11.15           2.79
                             &qi->q_lock:             0              0           0.00           0.00           0.00           0.00             33           1819           0.18           2.32        1259.81           0.69
                         semaphore->lock:             0              0           0.00           0.00           0.00           0.00              0          76296           0.10          13.62       11967.43           0.16
                      hrtimer_bases.lock:             0              0           0.00           0.00           0.00           0.00              6        2549735           0.09          16.13     1212224.72           0.48
                        jump_label_mutex:             0              0           0.00           0.00           0.00           0.00              6             10         296.11        4733.30       13689.00        1368.90
                         pci_config_lock:             0              0           0.00           0.00           0.00           0.00              0           2244           0.89          14.67        2280.18           1.02
                              &x->wait#4:             0              0           0.00           0.00           0.00           0.00              2              6           0.20           5.79          10.23           1.70
                        jiffies_lock#2-W:             0              0           0.00           0.00           0.00           0.00              0         629177           0.06          16.59      216989.69           0.34
                        jiffies_lock#2-R:             0              0           0.00           0.00           0.00           0.00              0       20108649           0.05          13.50     1618841.73           0.08
                       (&watchdog_timer):             0              0           0.00           0.00           0.00           0.00              0           1351           2.02         552.65        5352.63           3.96
                        mm/vmstat.c:1452:             0              0           0.00           0.00           0.00           0.00              0            675           2.34          18.98        3242.09           4.80
                         (shepherd).work:             0              0           0.00           0.00           0.00           0.00              0            675           3.01         151.86        5760.50           8.53
                              "vmstat"-R:             0              0           0.00           0.00           0.00           0.00              0           5523           1.39       11095.50      203717.16          36.89
   (&(({ do { const void *__vpp_verify =:             0              0           0.00           0.00           0.00           0.00              0           5523           1.08       11095.23      173637.91          31.44
                           (&cpu->timer):             0              0           0.00           0.00           0.00           0.00              0        1102277           0.77       12085.49     2487036.23           2.26
                 "%s"("ipv6_addrconf")-R:             0              0           0.00           0.00           0.00           0.00              0              5           4.42         568.17         588.80         117.76
                    (addr_chk_work).work:             0              0           0.00           0.00           0.00           0.00              0              5           3.88         567.59         585.97         117.19
                      rcu_read_lock_bh-R:             0              0           0.00           0.00           0.00           0.00              0           3493           0.08         562.20       23465.07           6.72
   (&(({ do { const void *__vpp_verify =:             0              0           0.00           0.00           0.00           0.00              0           5222           0.82          12.24       22813.00           4.37
                               swap_lock:             0              0           0.00           0.00           0.00           0.00              5              6           0.21           0.94           3.44           0.57
                      root_key_user.lock:             0              0           0.00           0.00           0.00           0.00              2              4           0.16           0.44           1.15           0.29
                       &type->lock_class:             0              0           0.00           0.00           0.00           0.00              0              1           5.47           5.47           5.47           5.47
              keyring_serialise_link_sem:             0              0           0.00           0.00           0.00           0.00              1              1           4.57           4.57           4.57           4.57
                     &bp->port.phy_mutex:             0              0           0.00           0.00           0.00           0.00            823           2692         149.27       16106.72      784359.79         291.37
                    (&dom->period_timer):             0              0           0.00           0.00           0.00           0.00              0             40           0.89           6.36         107.72           2.69
                               cdev_lock:             0              0           0.00           0.00           0.00           0.00              9             40           0.14           0.78          10.89           0.27
                            unix_gc_lock:             0              0           0.00           0.00           0.00           0.00              1              4           0.16           0.52           1.03           0.26
                   &tty->termios_rwsem-R:             0              0           0.00           0.00           0.00           0.00            481           1456           0.46        3499.03       26967.04          18.52
                       &tty->ldisc_sem-R:             0              0           0.00           0.00           0.00           0.00            975           7095           0.11    57558379.74    74689846.91       10527.11
                    &(&f->f_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             23            122           0.10          32.57          54.49           0.45
                              &buf->lock:             0              0           0.00           0.00           0.00           0.00            174            697           0.16        3779.80       22848.26          32.78
         &(&ent->pde_unload_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           1353          11247           0.10        5127.62       10789.72           0.96
                            (&buf->work):             0              0           0.00           0.00           0.00           0.00              0           2475           0.05        6387.14       30206.81          12.20
                         inode_hash_lock:             0              0           0.00           0.00           0.00           0.00              2             15           0.39           1.88          12.48           0.83
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00            210            221           0.10           0.63          27.59           0.12
            &(&lru->node[i].lock)->rlock:             0              0           0.00           0.00           0.00           0.00             18             53           0.13           0.78          15.03           0.28
                  &type->i_mutex_dir_key:             0              0           0.00           0.00           0.00           0.00            266            507           0.55          63.79        2221.21           4.38
                          sb_writers#3-R:             0              0           0.00           0.00           0.00           0.00              0            141           0.28          40.91         260.25           1.85
                          sb_writers#4-R:             0              0           0.00           0.00           0.00           0.00              0           2741           2.15        4662.31       54445.21          19.86
                                &p->lock:             0              0           0.00           0.00           0.00           0.00              4           5499           0.17       18845.32      485423.74          88.27
              &sb->s_type->i_mutex_key#9:             0              0           0.00           0.00           0.00           0.00             94            767           0.40         370.68        4282.17           5.58
                          sb_writers#5-R:             0              0           0.00           0.00           0.00           0.00              0            808           0.28         371.15        5365.35           6.64
            &sb->s_type->i_mutex_key#9/1:             0              0           0.00           0.00           0.00           0.00             14             83           1.52          43.45         900.77          10.85
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00              2             54           0.13           1.23          18.84           0.35
            &(&tsk->delays->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            754           2061           0.10           1.40         387.12           0.19
                         task_group_lock:             0              0           0.00           0.00           0.00           0.00             19             34           0.14          11.61          24.22           0.71
                   kernfs_open_node_lock:             0              0           0.00           0.00           0.00           0.00             62            325           0.11           0.88          62.15           0.19
                              &of->mutex:             0              0           0.00           0.00           0.00           0.00              0            124           0.46      202877.00      203377.50        1640.14
                 &tty->atomic_write_lock:             0              0           0.00           0.00           0.00           0.00              0            772           1.68        1829.42       19543.36          25.32
                     &ldata->output_lock:             0              0           0.00           0.00           0.00           0.00            218            805           0.17        1826.91       15466.36          19.21
                 &(&list->lock)->rlock#2:             0              0           0.00           0.00           0.00           0.00            168            610           0.09          15.99         127.69           0.21
                              &nlk->wait:             0              0           0.00           0.00           0.00           0.00             19             57           0.12           0.52          11.52           0.20
                        clock-AF_NETLINK:             0              0           0.00           0.00           0.00           0.00              1             10           0.11           0.47           1.93           0.19
                                &ep->mtx:             0              0           0.00           0.00           0.00           0.00             90           1142           0.14          65.18        1762.03           1.54
                  &sighand->signalfd_wqh:             0              0           0.00           0.00           0.00           0.00             20             23           0.16           8.20          53.71           2.34
       &(&conn->immed_queue_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           3398           0.09         247.70        1137.14           0.33
                      kernfs_rename_lock:             0              0           0.00           0.00           0.00           0.00             10            441           0.14           1.83         127.60           0.29
                &type->i_mutex_dir_key#2:             0              0           0.00           0.00           0.00           0.00              9             55           0.79          51.82         221.39           4.03
                          sb_writers#6-R:             0              0           0.00           0.00           0.00           0.00              0              9           3.15      202878.26      203052.38       22561.38
                              s_active#1:             0              0           0.00           0.00           0.00           0.00              1              1           0.23           0.23           0.23           0.23
                           &rsp->gp_wait:             0              0           0.00           0.00           0.00           0.00              3             15           0.13           0.59           4.04           0.27
                     "cpuset_migrate_mm":             0              0           0.00           0.00           0.00           0.00              0              6           0.08           0.42           0.91           0.15
                               &ctx->wqh:             0              0           0.00           0.00           0.00           0.00             19            193           0.11          11.53         359.87           1.86
                       &mm->context.lock:             0              0           0.00           0.00           0.00           0.00             18             39           0.20           0.82          14.04           0.36
                         &dup_mmap_sem-R:             0              0           0.00           0.00           0.00           0.00              0             28          48.03         503.52        7590.80         271.10
                         &mm->mmap_sem/1:             0              0           0.00           0.00           0.00           0.00              0             28          46.97         502.44        7560.04         270.00
                       &brw->write_waitq:             0              0           0.00           0.00           0.00           0.00              6              9           0.15           0.71           2.72           0.30
                         unix_table_lock:             0              0           0.00           0.00           0.00           0.00             64            206           0.12           2.55          73.96           0.36
                           clock-AF_UNIX:             0              0           0.00           0.00           0.00           0.00             19             93           0.12           2.04          26.34           0.28
      &af_unix_sk_receive_queue_lock_key:             0              0           0.00           0.00           0.00           0.00            396            861           0.10           0.90         177.22           0.21
                   &(&info->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             91          60808           0.10           7.25        6269.38           0.10
                      &newf->resize_wait:             0              0           0.00           0.00           0.00           0.00              1              1           0.37           0.37           0.37           0.37
                          &pipe->mutex/1:             0              0           0.00           0.00           0.00           0.00             42             63           0.19           8.83         101.50           1.61
                             &pipe->wait:             0              0           0.00           0.00           0.00           0.00            367           3085           0.10          10.06         709.15           0.23
                          sb_writers#7-R:             0              0           0.00           0.00           0.00           0.00              0             14           0.46           1.19          11.00           0.79
                &(&br->hash_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0              2           1.39           2.16           3.55           1.77
                      &group->mark_mutex:             0              0           0.00           0.00           0.00           0.00              3              5           2.61           5.08          20.28           4.06
   &(&group->inotify_data.idr_lock)->rlo:             0              0           0.00           0.00           0.00           0.00              5             15           0.36           1.51           9.98           0.67
                   &(&mark->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              2             15           0.10           2.65          12.47           0.83
              &group->notification_mutex:             0              0           0.00           0.00           0.00           0.00            290           1433           0.14          24.95         417.44           0.29
                            &u->readlock:             0              0           0.00           0.00           0.00           0.00             83            485           0.40          75.49        1396.66           2.88
                           slock-AF_UNIX:             0              0           0.00           0.00           0.00           0.00              1             32           0.13           0.32           5.63           0.18
                     &tty->winsize_mutex:             0              0           0.00           0.00           0.00           0.00              3              6           0.21           5.50           7.26           1.21
                &(&wb->list_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             38            144           0.33          54.43         275.07           1.91
              &type->i_mutex_dir_key#2/1:             0              0           0.00           0.00           0.00           0.00              2              2          47.18          63.35         110.54          55.27
                    &cgrp->pidlist_mutex:             0              0           0.00           0.00           0.00           0.00              5             20           0.63           9.76          71.14           3.56
                                   key#2:             0              0           0.00           0.00           0.00           0.00              1              1           2.44           2.44           2.44           2.44
                             &user->lock:             0              0           0.00           0.00           0.00           0.00             20            508           0.75          49.35         761.94           1.50
                            s_active#1-R:             0              0           0.00           0.00           0.00           0.00              0             40           0.16          39.16         230.26           5.76
                    &(&u->lock)->rlock/1:             0              0           0.00           0.00           0.00           0.00              0             17           1.14          55.47         103.36           6.08
                             iattr_mutex:             0              0           0.00           0.00           0.00           0.00              3             10           0.17           0.88           2.99           0.30
               &(&xattrs->lock)->rlock#2:             0              0           0.00           0.00           0.00           0.00              3              5           0.12           0.38           1.37           0.27
              &sb->s_type->i_mutex_key#1:             0              0           0.00           0.00           0.00           0.00              3              5           1.90           6.90          21.32           4.26
             (&cgrp->release_agent_work):             0              0           0.00           0.00           0.00           0.00              0              2           0.07         446.31         446.37         223.19
                         audit_cmd_mutex:             0              0           0.00           0.00           0.00           0.00              4             14           1.03          22.74          61.56           4.40
                 &(&list->lock)->rlock#3:             0              0           0.00           0.00           0.00           0.00              8             21           0.12           0.47           4.52           0.22
                       kauditd_wait.lock:             0              0           0.00           0.00           0.00           0.00              8             28           0.13           8.17          41.45           1.48
                              s_active#1:             0              0           0.00           0.00           0.00           0.00              1              1           0.33           0.33           0.33           0.33
                              s_active#1:             0              0           0.00           0.00           0.00           0.00              1              1           0.27           0.27           0.27           0.27
                 &root->deactivate_waitq:             0              0           0.00           0.00           0.00           0.00              1              1           0.47           0.47           0.47           0.47
                      "cgroup_destroy"-R:             0              0           0.00           0.00           0.00           0.00              0              2           3.67         191.73         195.40          97.70
                    (&css->destroy_work):             0              0           0.00           0.00           0.00           0.00              0              1           2.93           2.93           2.93           2.93
                  (&css->destroy_work)#2:             0              0           0.00           0.00           0.00           0.00              0              1         191.22         191.22         191.22         191.22
              "cgroup_pidlist_destroy"-W:             0              0           0.00           0.00           0.00           0.00              0              1           0.17           0.17           0.17           0.17
              "cgroup_pidlist_destroy"-R:             0              0           0.00           0.00           0.00           0.00              0              5           1.88           3.60          12.92           2.58
               &(&net->nsid_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              5             25           0.11           0.92           6.77           0.27
            &sb->s_type->i_mutex_key#9/4:             0              0           0.00           0.00           0.00           0.00              2             24           0.11           8.89          95.21           3.97
     &(&dentry->d_lockref.lock)->rlock/2:             0              0           0.00           0.00           0.00           0.00              0             24           0.28           0.75          10.14           0.42
     &(&dentry->d_lockref.lock)->rlock/3:             0              0           0.00           0.00           0.00           0.00              0             24           0.14           0.28           4.50           0.19
                        &dentry->d_seq/1:             0              0           0.00           0.00           0.00           0.00              0             24           0.39           1.50          17.38           0.72
                                 epmutex:             0              0           0.00           0.00           0.00           0.00              4              9           0.47          10.33          22.76           2.53
                       ((&br->gc_timer)):             0              0           0.00           0.00           0.00           0.00              0              2           2.59           4.23           6.82           3.41
        &(&adapter->stats64_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              4            683           0.13         241.09         533.57           0.78
                                dca_lock:             0              0           0.00           0.00           0.00           0.00             54            786           0.16           3.70         460.93           0.59
              reservation_ww_class_mutex:             0              0           0.00           0.00           0.00           0.00              0           3373           1.31       22950.39       87296.99          25.88
               &(&glob->lru_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           3373           0.11        2371.43        6705.73           1.99
                  (&mddev->flush_work)#2:             0              0           0.00           0.00           0.00           0.00              0            134           6.35        5848.08       33086.86         246.92
                              &p->lock#2:             0              0           0.00           0.00           0.00           0.00            383           1348           0.39         781.27        2247.76           1.67
                      ata_scsi_rbuf_lock:             0              0           0.00           0.00           0.00           0.00              1              1           1.94           1.94           1.94           1.94
                              &x->wait#1:             0              0           0.00           0.00           0.00           0.00             50             81           0.13           7.34         146.34           1.81
           (&(&l->destroy_dwork)->timer):             0              0           0.00           0.00           0.00           0.00              0              4           4.88           5.67          21.17           5.29
       &(&ioc->diag_trigger_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              3             16           0.27           0.56           5.30           0.33
   &(&ioc->ioc_reset_in_progress_lock)->:             0              0           0.00           0.00           0.00           0.00            200           1348           0.16           3.21        1302.81           0.97
                        &ev->block_mutex:             0              0           0.00           0.00           0.00           0.00              8              9           1.93           3.29          21.66           2.41
                     &(&ev->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              9             36           0.17           4.90          44.81           1.24
                            sd_ref_mutex:             0              0           0.00           0.00           0.00           0.00              3             18           0.36           2.30          11.63           0.65
    "events_freezable_power_efficient"-R:             0              0           0.00           0.00           0.00           0.00              0              9          48.88       11206.04       13920.13        1546.68
                   (&(&ev->dwork)->work):             0              0           0.00           0.00           0.00           0.00              0             18           0.08       11205.46       13916.69         773.15
                &(&ctx->flc_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0              2           0.65           1.45           2.11           1.05
                      file_lock_lglock-R:             0              0           0.00           0.00           0.00           0.00              0              2           0.14           0.25           0.38           0.19
                  &(&ioc->lock)->rlock/1:             0              0           0.00           0.00           0.00           0.00             19             20           0.18           0.63           5.66           0.28
                  &(&ioc->lock)->rlock#2:             0              0           0.00           0.00           0.00           0.00              0             20           0.10           0.16           2.18           0.11
                            s_active#5-R:             0              0           0.00           0.00           0.00           0.00              0             54           0.92           3.84          89.67           1.66
      (&(&ioc->fault_reset_work)->timer):             0              0           0.00           0.00           0.00           0.00              0            674           1.25          22.37        4136.06           6.14
      "%s"ioc->fault_reset_work_q_name-R:             0              0           0.00           0.00           0.00           0.00              0            674           2.22        1712.56        5495.56           8.15
       (&(&ioc->fault_reset_work)->work):             0              0           0.00           0.00           0.00           0.00              0            674           1.95        1712.19        5121.92           7.60
               &(&tty->ctrl_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              4             86           0.10           0.49          17.11           0.20
               &o_tty->termios_rwsem/1-W:             0              0           0.00           0.00           0.00           0.00              0              4           1.59           3.33           8.91           2.23
               &o_tty->termios_rwsem/1-R:             0              0           0.00           0.00           0.00           0.00            543           3454           0.10        1828.67       19335.69           5.60
                       &port->buf.lock/1:             0              0           0.00           0.00           0.00           0.00              2             70           8.14          60.51         865.97          12.37
                &ldata->atomic_read_lock:             0              0           0.00           0.00           0.00           0.00              1            756           1.82    57558378.60    74620486.38       98704.35
           &(&afbdev->dirty_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           3373           0.12           1.47         664.23           0.20
              "xfs-buf/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0             33           0.98          18.44          86.21           2.61
                     (&bp->b_ioend_work):             0              0           0.00           0.00           0.00           0.00              0             55           0.84        1068.82        2757.74          50.14
                       semaphore->lock#3:             0              0           0.00           0.00           0.00           0.00            132            418           0.10           1.67          80.61           0.19
                                   key#4:             0              0           0.00           0.00           0.00           0.00              2              7           1.07           2.76          12.53           1.79
                                   key#5:             0              0           0.00           0.00           0.00           0.00              2              7           0.51           0.86           4.30           0.61
                                   key#6:             0              0           0.00           0.00           0.00           0.00              3              9           0.45           0.77           5.17           0.57
             &(&mp->m_perag_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              5              7           0.15           0.83           3.16           0.45
                &(&ailp->xa_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           1159          27134           0.10        2777.50       34193.43           1.26
            &(&pag->pag_buf_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             17            134           0.16           3.49          97.25           0.73
             &(&ip->i_flags_lock)->rlock:             0              0           0.00           0.00           0.00           0.00            699           1406           0.09          49.99         456.66           0.32
            &(&pag->pag_ici_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              6              8           0.22           3.24          15.43           1.93
               &sb->s_type->i_lock_key#2:             0              0           0.00           0.00           0.00           0.00             48            186           0.13           1.63          68.38           0.37
                    &group->mark_mutex/1:             0              0           0.00           0.00           0.00           0.00              2              5           1.45           3.98          11.01           2.20
                &type->i_mutex_dir_key#3:             0              0           0.00           0.00           0.00           0.00             13            120           0.59          16.84         343.51           2.86
             &(&ip->i_iolock)->mr_lock-W:             0              0           0.00           0.00           0.00           0.00             30            404           0.97         526.14        2473.73           6.12
             &(&ip->i_iolock)->mr_lock-R:             0              0           0.00           0.00           0.00           0.00            167            409           0.14          74.11         985.90           2.41
                  &xfs_dir_ilock_class-R:             0              0           0.00           0.00           0.00           0.00             13            103           0.61           9.63         210.45           2.04
               &xfs_nondir_ilock_class-W:             0              0           0.00           0.00           0.00           0.00             57            129           0.28       26294.73       27306.16         211.68
               &xfs_nondir_ilock_class-R:             0              0           0.00           0.00           0.00           0.00            306            615           0.12          90.56         771.14           1.25
                         clock-AF_INET-W:             0              0           0.00           0.00           0.00           0.00              3              5           0.16           0.44           1.48           0.30
                         clock-AF_INET-R:             0              0           0.00           0.00           0.00           0.00              0              5           0.19           0.24           1.07           0.21
   &(&pgdat->numabalancing_migrate_lock):             0              0           0.00           0.00           0.00           0.00            138            152           0.11          42.33          76.65           0.50
                          sb_writers#8-R:             0              0           0.00           0.00           0.00           0.00              0            414           1.43         529.92        2940.09           7.10
           &(&ip->i_mmaplock)->mr_lock-R:             0              0           0.00           0.00           0.00           0.00            137            209           0.30          17.01         163.97           0.78
                &(&p->alloc_lock)->rlock:             0              0           0.00           0.00           0.00           0.00            119            562           0.08          19.60         197.16           0.35
              &sb->s_type->i_mutex_key#1:             0              0           0.00           0.00           0.00           0.00             30            400           1.23         527.86        2639.77           6.60
                         cache_list_lock:             0              0           0.00           0.00           0.00           0.00              0             25           0.55          26.18          58.12           2.32
               (&(&cache_cleaner)->work):             0              0           0.00           0.00           0.00           0.00              0             25           1.99          28.20         128.11           5.12
              (&(&cache_cleaner)->timer):             0              0           0.00           0.00           0.00           0.00              0             25           2.76           8.25         120.94           4.84
                   &fsnotify_mark_srcu-R:             0              0           0.00           0.00           0.00           0.00              0            550           0.42          40.30        1199.36           2.18
                  &rl->wait[BLK_RW_SYNC]:             0              0           0.00           0.00           0.00           0.00           2320           2382           0.16          26.19        7255.21           3.05
                         rcu_read_lock-R:             0              0           0.00           0.00           0.00           0.00              0     2105575259           0.05       32731.72   917066270.78           0.44
                &(&tbl->locks[i])->rlock:             0              0           0.00           0.00           0.00           0.00              5             20           0.14           1.15           7.58           0.38
                          mem_ctls_mutex:             0              0           0.00           0.00           0.00           0.00            495           1348           0.30          89.73        1071.87           0.80
                       pvclock_gtod_data:             0              0           0.00           0.00           0.00           0.00              0         597054           0.06          13.80       70797.69           0.12
                            s_active#8-R:             0              0           0.00           0.00           0.00           0.00              0             10           1.39           3.66          24.16           2.42
                  (&(&mci->work)->timer):             0              0           0.00           0.00           0.00           0.00              0           1348           0.74          22.93        7135.89           5.29
                     "%s""edac-poller"-R:             0              0           0.00           0.00           0.00           0.00              0           1348           1.36         278.76        4823.82           3.58
                   (&(&mci->work)->work):             0              0           0.00           0.00           0.00           0.00              0           1348           1.09         278.45        4363.28           3.24
               &(&pag->pagb_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              7             93           0.13           1.24          20.22           0.22
                 audit_backlog_wait.lock:             0              0           0.00           0.00           0.00           0.00              2              7           0.13           0.60           2.19           0.31
                             &ctx->wqh#2:             0              0           0.00           0.00           0.00           0.00             29            300           0.11           8.51         146.04           0.49
                                   key#7:             0              0           0.00           0.00           0.00           0.00              5              5           0.37           0.68           2.68           0.54
                      sk_lock-AF_NETLINK:             0              0           0.00           0.00           0.00           0.00              0             12           0.18           2.14          13.90           1.16
                      userns_state_mutex:             0              0           0.00           0.00           0.00           0.00              1              1           0.76           0.76           0.76           0.76
                   (sync_cmos_work).work:             0              0           0.00           0.00           0.00           0.00              0              2           2.42        3234.63        3237.05        1618.52
                         sk_lock-AF_INET:             0              0           0.00           0.00           0.00           0.00              0           1750           0.30       47755.27      340693.06         194.68
          &(&table->hash[i].lock)->rlock:             0              0           0.00           0.00           0.00           0.00              8             15           0.62           2.96          26.09           1.74
         &(&table->hash2[i].lock)->rlock:             0              0           0.00           0.00           0.00           0.00             13             20           0.15           0.55           6.28           0.31
 &(&net->ipv4.ip_local_ports.lock)->se-R:             0              0           0.00           0.00           0.00           0.00              0              5           0.15           0.18           0.82           0.16
                             pidmap_lock:             0              0           0.00           0.00           0.00           0.00             56            117           0.11           1.74          46.11           0.39
                            s_active#9-R:             0              0           0.00           0.00           0.00           0.00              0              4           1.24           3.23           8.54           2.13
                            s_active#9-R:             0              0           0.00           0.00           0.00           0.00              0              2           1.32           1.63           2.95           1.47
                            s_active#9-R:             0              0           0.00           0.00           0.00           0.00              0              4           1.21           1.83           6.42           1.61
              nonblocking_pool.push_work:             0              0           0.00           0.00           0.00           0.00              0            103           2.96        5473.00       12119.12         117.66
             "xfs-data/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0             23           3.22       26304.80       26561.62        1154.85
                       (&ioend->io_work):             0              0           0.00           0.00           0.00           0.00              0             23           3.05       26304.20       26551.30        1154.40
                    (&cil->xc_push_work):             0              0           0.00           0.00           0.00           0.00              0            132           0.05          20.47         259.84           1.97
            &(&cil->xc_push_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             56            396           0.10         172.43         401.85           1.01
              "xfs-cil/%s"mp->m_fsname-W:             0              0           0.00           0.00           0.00           0.00              0             22           0.07           0.22           2.38           0.11
              "xfs-cil/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0             44           2.82          20.82         351.13           7.98
             &(&log->l_icloglock)->rlock:             0              0           0.00           0.00           0.00           0.00             56            374           0.10          61.78         451.05           1.21
      &(&iclog->ic_callback_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             44             66           0.26         136.13         162.27           2.46
                    &cil->xc_commit_wait:             0              0           0.00           0.00           0.00           0.00              0             22           0.16           0.83           5.90           0.27
                   &iclog->ic_force_wait:             0              0           0.00           0.00           0.00           0.00             18             22           0.20           0.80           8.80           0.40
              "xfs-log/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0             88           4.04        1069.37        4613.54          52.43
                   &iclog->ic_write_wait:             0              0           0.00           0.00           0.00           0.00             18             22           0.40           0.83          11.67           0.53
                          &bp->b_waiters:             0              0           0.00           0.00           0.00           0.00             15             20           0.23           0.79           7.34           0.37
                      &log->l_flush_wait:             0              0           0.00           0.00           0.00           0.00             15             22           0.22           1.94           8.60           0.39
               (&adapter->watchdog_task):             0              0           0.00           0.00           0.00           0.00              0            675         247.23       20797.21      433814.66         642.69
                  (&(&wb->dwork)->timer):             0              0           0.00           0.00           0.00           0.00              0            102           4.12          10.30         664.46           6.51
                           "writeback"-R:             0              0           0.00           0.00           0.00           0.00              0            102           5.48         909.80        3623.06          35.52
                   (&(&wb->dwork)->work):             0              0           0.00           0.00           0.00           0.00              0            102           5.22         909.19        3582.42          35.12
                          &p->sequence-W:             0              0           0.00           0.00           0.00           0.00              0             23           0.13           0.36           4.71           0.20
                          &p->sequence-R:             0              0           0.00           0.00           0.00           0.00              0            102           0.08           0.25          12.58           0.12
                                   key#8:             0              0           0.00           0.00           0.00           0.00             11             21           1.36           3.49          39.25           1.87
                                   key#9:             0              0           0.00           0.00           0.00           0.00             14             40           0.46           2.19          44.31           1.11
                 &(&bp->spq_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            673           0.24          13.31         366.66           0.54
                           "%s""bnx2x"-R:             0              0           0.00           0.00           0.00           0.00              0           3365           1.14       16107.80      800706.52         237.95
                 (&(&bp->sp_task)->work):             0              0           0.00           0.00           0.00           0.00              0            673           0.89         478.81        2639.03           3.92
             (&(&bp->period_task)->work):             0              0           0.00           0.00           0.00           0.00              0           2692         149.76       16107.22      787367.36         292.48
          &(&dev->tx_global_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            135          42.70         106.79        9254.02          68.55
                           _xmit_ETHER#2:             0              0           0.00           0.00           0.00           0.00           1022          13635           0.11         271.85        5221.59           0.38
                 &(&list->lock)->rlock#5:             0              0           0.00           0.00           0.00           0.00            447          14985           0.06         203.82        3842.33           0.26
            ((&adapter->watchdog_timer)):             0              0           0.00           0.00           0.00           0.00              0            675           0.87         281.18        3786.26           5.61
            (&(&bp->period_task)->timer):             0              0           0.00           0.00           0.00           0.00              0           2692           0.65          20.63       13565.38           5.04
                            (&bp->timer):             0              0           0.00           0.00           0.00           0.00              0           2695           2.13          30.52       15115.11           5.61
                       semaphore->lock#4:             0              0           0.00           0.00           0.00           0.00              0           5390           0.10           2.01         879.27           0.16
                            s_active#1-R:             0              0           0.00           0.00           0.00           0.00              0              2           3.08           3.54           6.62           3.31
             &(&bond->stats_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              1              4           0.51           1.16           2.86           0.71
              (&(&bond->mii_work)->work):             0              0           0.00           0.00           0.00           0.00              0           6737           0.52        2486.04       15378.67           2.28
               (&(&bond->ad_work)->work):             0              0           0.00           0.00           0.00           0.00              0           6735           1.27        7019.99      130183.00          19.33
              &(&bond->mode_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           1025           6735           0.55         586.22        7933.28           1.18
                    "%s"bond_dev->name-R:             0              0           0.00           0.00           0.00           0.00              0          13472           0.74        7103.46      155597.53          11.55
                              &n->lock-W:             0              0           0.00           0.00           0.00           0.00             35            107           0.71           5.72         182.04           1.70
                              &n->lock-R:             0              0           0.00           0.00           0.00           0.00              0              1           1.70           1.70           1.70           1.70
              &(&n->ha_lock)->seqcount-R:             0              0           0.00           0.00           0.00           0.00              0             14           0.09           0.24           1.67           0.12
              (&(&bond->ad_work)->timer):             0              0           0.00           0.00           0.00           0.00              0           6735           0.62          21.99       28405.47           4.22
             (&(&bond->mii_work)->timer):             0              0           0.00           0.00           0.00           0.00              0           6737           0.64          21.71       28259.15           4.19
           &(&n->hh.hh_lock)->seqcount-R:             0              0           0.00           0.00           0.00           0.00              0           1320           0.06           0.45         136.28           0.10
                    &(&grp->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            261            386           0.23           2.51         427.08           1.11
                   &(&pcpu->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0             86           0.11          21.91          49.24           0.57
               (&(&tbl->gc_work)->timer):             0              0           0.00           0.00           0.00           0.00              0             90           2.70           8.14         429.35           4.77
                (&(&tbl->gc_work)->work):             0              0           0.00           0.00           0.00           0.00              0             90           1.46        3626.09        6156.75          68.41
                   &net->ct.generation-R:             0              0           0.00           0.00           0.00           0.00              0             10           0.14           0.18           1.61           0.16
        &(&nf_conntrack_locks[i])->rlock:             0              0           0.00           0.00           0.00           0.00              8             10           1.72           9.88          39.11           3.91
      &(&nf_conntrack_locks[i])->rlock/1:             0              0           0.00           0.00           0.00           0.00              8             10           0.15           9.03          17.95           1.79
                     &(&ct->lock)->rlock:             0              0           0.00           0.00           0.00           0.00           1716           2422           0.19         328.27        4228.41           1.75
                (&(&log->l_work)->timer):             0              0           0.00           0.00           0.00           0.00              0             66           3.69           9.72         353.38           5.35
                 (&(&log->l_work)->work):             0              0           0.00           0.00           0.00           0.00              0             66           3.81         145.30        1894.32          28.70
                   (&sdev->requeue_work):             0              0           0.00           0.00           0.00           0.00              0              4           0.49           3.40           5.82           1.45
                ((&dev->watchdog_timer)):             0              0           0.00           0.00           0.00           0.00              0            135          43.00         107.48        9309.20          68.96
                   kernel/time/ntp.c:507:             0              0           0.00           0.00           0.00           0.00              0              2           4.32           4.62           8.94           4.47
                      lib/random32.c:217:             0              0           0.00           0.00           0.00           0.00              0             12          12.69         287.75         538.02          44.83
                        ((&ct->timeout)):             0              0           0.00           0.00           0.00           0.00              0              5          15.94          25.07         100.71          20.14
                           ((&n->timer)):             0              0           0.00           0.00           0.00           0.00              0             88           1.25          11.92         225.07           2.56
                        slock-AF_NETLINK:             0              0           0.00           0.00           0.00           0.00              0             24           0.10           0.38           4.79           0.20
                &(&dio->bio_lock)->rlock:             0              0           0.00           0.00           0.00           0.00       37548608      406366257           0.09          19.90    57120476.06           0.14
              &(&stopper->lock)->rlock/1:             0              0           0.00           0.00           0.00           0.00             12             15           4.12           6.44          76.73           5.12
                           &p->pi_lock/1:             0              0           0.00           0.00           0.00           0.00             10             15           0.11           9.90          78.34           5.22
                             &rq->lock/1:             0              0           0.00           0.00           0.00           0.00              6             15           0.13           9.46          50.13           3.34
                         slock-AF_INET/1:             0              0           0.00           0.00           0.00           0.00            847           1094           0.23        1762.80       24081.86          22.01
                &(&wb->work_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             32            204           0.15           2.68         160.10           0.78
        &(&conn->conn_usage_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            540           0.10          14.14         186.64           0.35
    &(&conn->response_queue_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           1866           0.09         232.79         606.88           0.33
                        &conn->queues_wq:             0              0           0.00           0.00           0.00           0.00              0           2315           0.10          18.02        2655.67           1.15
       &(&conn->nopin_timer_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           1620           0.09         331.48        2411.89           1.49
             &(&cil->xc_cil_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             51            112           0.14           1.41          51.28           0.46
            ((&icsk->icsk_delack_timer)):             0              0           0.00           0.00           0.00           0.00              0            347           0.38          56.91         871.34           2.51
        ((&icsk->icsk_retransmit_timer)):             0              0           0.00           0.00           0.00           0.00              0            909           0.39        2544.71        4178.18           4.60
                     &cil->xc_ctx_lock-W:             0              0           0.00           0.00           0.00           0.00             21             22           0.89           3.60          33.15           1.51
                     &cil->xc_ctx_lock-R:             0              0           0.00           0.00           0.00           0.00             58            112           0.17          10.28         119.13           1.06
                             &ids->rwsem:             0              0           0.00           0.00           0.00           0.00             49             52           0.49           9.74          70.76           1.36
   &(&({ do { const void *__vpp_verify =:             0              0           0.00           0.00           0.00           0.00              0            628           0.10           1.46         164.13           0.26
               &(&conn->cmd_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            898           0.10         159.22         569.90           0.63
             &(&cmd->istate_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            434           0.09         132.79         299.40           0.69
                &sb->s_type->i_mutex_key:             0              0           0.00           0.00           0.00           0.00             58          12486           0.76        6889.83      189925.00          15.21
                           sb_internal-R:             0              0           0.00           0.00           0.00           0.00              0            127           0.39       26297.27       27937.43         219.98
                         ((&q->timeout)):             0              0           0.00           0.00           0.00           0.00              0            976           0.32         367.21        3747.97           3.84
                &(&mp->m_sb_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              2              7           0.16           0.72           2.26           0.32
                     &(&br->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            337           0.57           4.17         452.46           1.34
                 &type->s_umount_key#3-R:             0              0           0.00           0.00           0.00           0.00              0             18          20.33         233.18        1008.69          56.04
                      nl_table_wait.lock:             0              0           0.00           0.00           0.00           0.00             10             31           0.10           0.54           6.93           0.22
                                   key#1:             0              0           0.00           0.00           0.00           0.00              1              1           1.43           1.43           1.43           1.43
                      ((&fc->rnd_timer)):             0              0           0.00           0.00           0.00           0.00              0              1           4.60           4.60           4.60           4.60
                          &f->f_pos_lock:             0              0           0.00           0.00           0.00           0.00             29            413           1.80         559.42        3174.65           7.69
               (&(&q->delay_work)->work):             0              0           0.00           0.00           0.00           0.00              0             58           0.41         188.90         247.97           4.28
                             nf_nat_lock:             0              0           0.00           0.00           0.00           0.00              7             10           0.47          50.87          56.69           5.67
                    ((&br->hello_timer)):             0              0           0.00           0.00           0.00           0.00              0            337           0.87           4.78         584.00           1.73
                    (&conn->nopin_timer):             0              0           0.00           0.00           0.00           0.00              0            270           9.79        1976.43       11378.35          42.14
               &(&sess->ttt_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            300           0.11          12.47         137.55           0.46
           (&conn->nopin_response_timer):             0              0           0.00           0.00           0.00           0.00              0            270           0.05           0.28          20.08           0.07
                 net/ipv6/addrconf.c:150:             0              0           0.00           0.00           0.00           0.00              0              5           3.67           5.67          24.00           4.80
             &(&cmd->datain_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0             88           0.10           2.15          20.82           0.24
       &(&se_sess->sess_cmd_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0             58           0.15           1.26          26.92           0.46
                      &sess->cmdsn_mutex:             0              0           0.00           0.00           0.00           0.00              0             30           8.14        1596.30        2127.86          70.93
       &(&dev->execute_task_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             15             60           0.11           0.64          15.40           0.26
            &(&cmd->t_state_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            118           0.11           1.49          41.46           0.35
                   "target_completion"-R:             0              0           0.00           0.00           0.00           0.00              0             30           3.80         343.07         593.31          19.78
                            (&cmd->work):             0              0           0.00           0.00           0.00           0.00              0             30           3.61         342.79         580.58          19.35
        &(&dev->delayed_cmd_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             15             30           0.11           0.55           7.92           0.26
       &(&lun->lun_tg_pt_gp_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             15             15           0.24           0.91           5.21           0.35
                  net/ipv4/devinet.c:438:             0              0           0.00           0.00           0.00           0.00              0              6           3.56           8.98          30.07           5.01
                                   ((t)):             0              0           0.00           0.00           0.00           0.00              0             48           2.46          13.63         169.68           3.54
                     (&pool->idle_timer):             0              0           0.00           0.00           0.00           0.00              0              5           3.24           7.91          30.36           6.07
       (&(&mp->m_eofblocks_work)->timer):             0              0           0.00           0.00           0.00           0.00              0              3           4.23           8.46          18.10           6.03
        "xfs-eofblocks/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0              3          12.28         170.79         292.85          97.62
        (&(&mp->m_eofblocks_work)->work):             0              0           0.00           0.00           0.00           0.00              0              3          11.51         169.95         290.74          96.91
                             "kblockd"-R:             0              0           0.00           0.00           0.00           0.00              0             62           0.65         189.81         371.19           5.99
                                   key#1:             0              0           0.00           0.00           0.00           0.00              1              1           1.37           1.37           1.37           1.37
                                   key#1:             0              0           0.00           0.00           0.00           0.00              1              1           0.93           0.93           0.93           0.93
                     &type->lock_class/1:             0              0           0.00           0.00           0.00           0.00              0              1           3.43           3.43           3.43           3.43
                             key_gc_work:             0              0           0.00           0.00           0.00           0.00              0              3           1.51       51023.47       51033.26       17011.09
                   security/keys/gc.c:33:             0              0           0.00           0.00           0.00           0.00              0              1           4.83           4.83           4.83           4.83
                  &(&mddev->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             70            137           0.17           2.58          79.33           0.58
                   dm_bufio_clients_lock:             0              0           0.00           0.00           0.00           0.00             13             22           1.71           4.24          65.21           2.96
                            _hash_lock-R:             0              0           0.00           0.00           0.00           0.00             70            134           0.86        1473.55        1864.46          13.91
                             _minor_lock:             0              0           0.00           0.00           0.00           0.00             35             74           0.12           1.16          24.17           0.33
                     dm_hash_cells_mutex:             0              0           0.00           0.00           0.00           0.00              7             20           0.26           1.37          11.39           0.57
                       &md->io_barrier-R:             0              0           0.00           0.00           0.00           0.00              0      135456070           0.19       27665.62   530198959.39           3.91
                    &(&new->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             64            102           0.11           8.90          54.34           0.53
                               &md->wait:             0              0           0.00           0.00           0.00           0.00             93            484           0.10           1.69          97.69           0.20
                            s_active#2-R:             0              0           0.00           0.00           0.00           0.00              0             10           1.73           4.75          25.51           2.55
                            s_active#2-R:             0              0           0.00           0.00           0.00           0.00              0             30           0.95           4.36          58.62           1.95
                            s_active#2-R:             0              0           0.00           0.00           0.00           0.00              0             10           0.88           2.49          14.71           1.47
                             &md->eventq:             0              0           0.00           0.00           0.00           0.00             70            134           0.15           1.16          38.53           0.29
                    &c->free_buffer_wait:             0              0           0.00           0.00           0.00           0.00             81            268           0.12           1.37          85.88           0.32
                              &c->lock#2:             0              0           0.00           0.00           0.00           0.00            125            647           0.16        8108.00       33932.02          52.45
                   &(&lock->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             69            268           0.15        4537.91        6507.32          24.28
                     &(&tm->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             48             67           0.76          51.50         146.52           2.19
                                  "md"-R:             0              0           0.00           0.00           0.00           0.00              0            268           6.65       17543.55      128149.80         478.17
                    (&mddev->flush_work):             0              0           0.00           0.00           0.00           0.00              0            134          35.37       17543.21       92368.98         689.32
                              &x->wait#2:             0              0           0.00           0.00           0.00           0.00            240            402           0.14           9.30         820.42           2.04
                         nl_table_lock-W:             0              0           0.00           0.00           0.00           0.00              0             10           0.14           0.63           2.65           0.27
                         nl_table_lock-R:             0              0           0.00           0.00           0.00           0.00             10             21           0.13           0.66           6.39           0.30
                         &mddev->sb_wait:             0              0           0.00           0.00           0.00           0.00             89            143           0.16           5.18          66.84           0.47
               &sb->s_type->i_lock_key#4:             0              0           0.00           0.00           0.00           0.00             62          90757           0.08        1250.66       62298.32           0.69
                 &(&pool->lock)->rlock#4:             0              0           0.00           0.00           0.00           0.00            384           4044           0.10           1.61         829.19           0.21
                          "dm-" "thin"-R:             0              0           0.00           0.00           0.00           0.00              0           2696           1.39        9427.73       63381.32          23.51
                         (&pool->worker):             0              0           0.00           0.00           0.00           0.00              0           1348           3.82        7588.23       33019.31          24.50
                (&(&pool->waker)->timer):             0              0           0.00           0.00           0.00           0.00              0           1348           0.73          20.35        6511.45           4.83
                 (&(&pool->waker)->work):             0              0           0.00           0.00           0.00           0.00              0           1348           1.12        9427.32       29302.69          21.74
              (&(&dm_bufio_work)->timer):             0              0           0.00           0.00           0.00           0.00              0             22           3.76          10.86         129.33           5.88
                  "%s""dm_bufio_cache"-R:             0              0           0.00           0.00           0.00           0.00              0             22           3.53           7.71         120.82           5.49
               (&(&dm_bufio_work)->work):             0              0           0.00           0.00           0.00           0.00              0             22           3.22           6.80         108.23           4.92
                            s_active#3-R:             0              0           0.00           0.00           0.00           0.00              0             32           1.66          39.65         133.56           4.17
                         &ctx->ring_lock:             0              0           0.00           0.00           0.00           0.00         139634      137092745           0.14       18836.84    74350379.12           0.54
                             aio_nr_lock:             0              0           0.00           0.00           0.00           0.00             32             32           0.18           0.79          15.11           0.47
               &(&mm->ioctx_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             31             48           0.13           0.79          18.81           0.39
                                   key#1:             0              0           0.00           0.00           0.00           0.00           3145           3145           0.12           2.09        1081.25           0.34
                         &sk->sk_lock.wq:             0              0           0.00           0.00           0.00           0.00              0              4           0.24           3.91           7.50           1.88
                              &x->wait#2:             0              0           0.00           0.00           0.00           0.00             32             48           0.12           9.04          90.97           1.90
                &(&ctx->ctx_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             15             16           0.26           0.61           5.94           0.37
                       (&ctx->free_work):             0              0           0.00           0.00           0.00           0.00              0             16           7.42          18.93         232.22          14.51
                         input_pool.lock:             0              0           0.00           0.00           0.00           0.00            121        1618053           0.20           4.73      719957.29           0.44
                     &(&tc->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            384           2696           0.12          20.08         595.78           0.22
                  random_write_wait.lock:             0              0           0.00           0.00           0.00           0.00             63            194           0.10          21.29         343.72           1.77
                   nonblocking_pool.lock:             0              0           0.00           0.00           0.00           0.00            141            406           0.22           5.09         291.74           0.72

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="thin-fio-stdout.txt"

# fio --filename=/dev/mapper/thin-thindisk1 read_rand.fio
random: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
...
fio-2.2.8
Starting 16 processes
Jobs: 16 (f=16): [r(16)] [100.0% done] [130.8MB/0KB/0KB /s] [33.5K/0/0 iops] [eta 00m:00s]
random: (groupid=0, jobs=16): err= 0: pid=9025: Wed Jun 22 15:23:34 2016
  read : io=68948MB, bw=117670KB/s, iops=29417, runt=600010msec
    slat (usec): min=5, max=971, avg=43.86, stdev=15.38
    clat (usec): min=98, max=39439, avg=17359.36, stdev=7273.99
     lat (usec): min=110, max=39477, avg=17403.39, stdev=7275.71
    clat percentiles (usec):
     |  1.00th=[ 2512],  5.00th=[ 5472], 10.00th=[ 7712], 20.00th=[10816],
     | 30.00th=[13248], 40.00th=[15296], 50.00th=[17280], 60.00th=[19072],
     | 70.00th=[21120], 80.00th=[23680], 90.00th=[27008], 95.00th=[29824],
     | 99.00th=[34048], 99.50th=[35072], 99.90th=[36608], 99.95th=[37120],
     | 99.99th=[37632]
    bw (KB  /s): min= 6539, max= 8512, per=6.25%, avg=7358.80, stdev=737.53
    lat (usec) : 100=0.01%, 250=0.01%, 500=0.02%, 750=0.04%, 1000=0.07%
    lat (msec) : 2=0.47%, 4=2.00%, 10=14.31%, 20=47.53%, 50=35.56%
  cpu          : usr=0.44%, sys=8.88%, ctx=26831806, majf=0, minf=6972
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=17650755/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
   READ: io=68948MB, aggrb=117669KB/s, minb=117669KB/s, maxb=117669KB/s, mint=600010msec, maxt=600010msec

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="thin-lock-stats.txt"

lock_stat version 0.4
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

        &(&ioc->scsi_lookup_lock)->rlock:     323309477      354021096           0.08        1219.27  5755299178.37          16.26      396180159      406374144           0.05          19.51   330767253.12           0.81
        --------------------------------
        &(&ioc->scsi_lookup_lock)->rlock      117750632          [<ffffffffa01ada2a>] mpt3sas_base_get_smid_scsiio+0x2a/0xa0 [mpt3sas]
        &(&ioc->scsi_lookup_lock)->rlock      117934146          [<ffffffffa01b8400>] _scsih_io_done+0x40/0x9f0 [mpt3sas]
        &(&ioc->scsi_lookup_lock)->rlock      118336318          [<ffffffffa01adb3e>] mpt3sas_base_free_smid+0x2e/0x230 [mpt3sas]
        --------------------------------
        &(&ioc->scsi_lookup_lock)->rlock      106315683          [<ffffffffa01ada2a>] mpt3sas_base_get_smid_scsiio+0x2a/0xa0 [mpt3sas]
        &(&ioc->scsi_lookup_lock)->rlock      117493014          [<ffffffffa01b8400>] _scsih_io_done+0x40/0x9f0 [mpt3sas]
        &(&ioc->scsi_lookup_lock)->rlock      130212399          [<ffffffffa01adb3e>] mpt3sas_base_free_smid+0x2e/0x230 [mpt3sas]

.............................................................................................................................................................................................................................

              &(&q->__queue_lock)->rlock:     164901371      164973146           0.07         228.68   337677521.18           2.05      479759336      677293951           0.06          39.06   752391861.03           1.11
              --------------------------
              &(&q->__queue_lock)->rlock       32326526          [<ffffffff81331caf>] blk_queue_bio+0x9f/0x3d0
              &(&q->__queue_lock)->rlock       33711086          [<ffffffff814e70dd>] scsi_request_fn+0x49d/0x640
              &(&q->__queue_lock)->rlock       31251091          [<ffffffff81331b85>] blk_flush_plug_list+0x175/0x200
              &(&q->__queue_lock)->rlock       31915415          [<ffffffff814e5dae>] scsi_end_request+0x10e/0x1e0
              --------------------------
              &(&q->__queue_lock)->rlock       66075480          [<ffffffff81331b85>] blk_flush_plug_list+0x175/0x200
              &(&q->__queue_lock)->rlock       24384772          [<ffffffff81331caf>] blk_queue_bio+0x9f/0x3d0
              &(&q->__queue_lock)->rlock       12263117          [<ffffffff814e70dd>] scsi_request_fn+0x49d/0x640
              &(&q->__queue_lock)->rlock       52494321          [<ffffffff814e5dae>] scsi_end_request+0x10e/0x1e0

.............................................................................................................................................................................................................................

                   &(&lock->lock)->rlock:      38712311       38715018           0.07          89.71   136420966.35           3.52      120068105      141178451           0.06        4537.91   403786876.73           2.86
                   ---------------------
                   &(&lock->lock)->rlock        9735538          [<ffffffffa085f716>] dm_bm_read_lock+0x66/0x190 [dm_persistent_data]
                   &(&lock->lock)->rlock       24898313          [<ffffffffa085f672>] bl_up_read+0x12/0x50 [dm_persistent_data]
                   &(&lock->lock)->rlock        4081167          [<ffffffffa085fc06>] dm_bm_read_try_lock+0x56/0x150 [dm_persistent_data]
                   ---------------------
                   &(&lock->lock)->rlock       27586590          [<ffffffffa085fc06>] dm_bm_read_try_lock+0x56/0x150 [dm_persistent_data]
                   &(&lock->lock)->rlock       10438661          [<ffffffffa085f716>] dm_bm_read_lock+0x66/0x190 [dm_persistent_data]
                   &(&lock->lock)->rlock         689767          [<ffffffffa085f672>] bl_up_read+0x12/0x50 [dm_persistent_data]

.............................................................................................................................................................................................................................

                               &rq->lock:      12934860       12945743           0.08          37.01    20363962.29           1.57       52187173      233435748           0.05          38.70   226958545.04           0.97
                               ---------
                               &rq->lock         120008          [<ffffffff810b13a5>] try_to_wake_up+0x1d5/0x460
                               &rq->lock          21696          [<ffffffff810bc724>] update_blocked_averages+0x34/0x490
                               &rq->lock             15          [<ffffffff810b2763>] wake_up_new_task+0xd3/0x280
                               &rq->lock          63557          [<ffffffff8173a324>] __schedule+0x94/0x970
                               ---------
                               &rq->lock         125198          [<ffffffff810b13a5>] try_to_wake_up+0x1d5/0x460
                               &rq->lock            493          [<ffffffff810c3b66>] update_cpu_load_nohz+0x46/0x90
                               &rq->lock             19          [<ffffffff810b2763>] wake_up_new_task+0xd3/0x280
                               &rq->lock       12702142          [<ffffffff8173a324>] __schedule+0x94/0x970

.............................................................................................................................................................................................................................

                            &c->lock#2/1:       9938764        9938764           2.97         350.81   114430288.79          11.51       57066958       70577888           0.09          84.93    56199190.41           0.80
                            ------------
                            &c->lock#2/1        3087443          [<ffffffffa0848fc9>] new_read+0x59/0x130 [dm_bufio]
                            &c->lock#2/1        6851321          [<ffffffffa0847902>] dm_bufio_release+0x32/0xb0 [dm_bufio]
                            ------------
                            &c->lock#2/1        5634084          [<ffffffffa0848fc9>] new_read+0x59/0x130 [dm_bufio]
                            &c->lock#2/1        4304563          [<ffffffffa0847902>] dm_bufio_release+0x32/0xb0 [dm_bufio]
                            &c->lock#2/1            117          [<ffffffffa0848899>] dm_bufio_prefetch+0x79/0x1e0 [dm_bufio]

.............................................................................................................................................................................................................................

                              &c->lock#2:       9234764        9234764           2.61         291.11    89334255.77           9.67       36495603       70607844           0.08        8108.00    48483924.50           0.69
                              ----------
                              &c->lock#2        8135030          [<ffffffffa0847902>] dm_bufio_release+0x32/0xb0 [dm_bufio]
                              &c->lock#2        1099606          [<ffffffffa0848fc9>] new_read+0x59/0x130 [dm_bufio]
                              &c->lock#2            124          [<ffffffffa0848899>] dm_bufio_prefetch+0x79/0x1e0 [dm_bufio]
                              &c->lock#2              4          [<ffffffffa0848e78>] work_fn+0xa8/0x1a0 [dm_bufio]
                              ----------
                              &c->lock#2        7085058          [<ffffffffa0848fc9>] new_read+0x59/0x130 [dm_bufio]
                              &c->lock#2        2149705          [<ffffffffa0847902>] dm_bufio_release+0x32/0xb0 [dm_bufio]
                              &c->lock#2              1          [<ffffffffa0848e78>] work_fn+0xa8/0x1a0 [dm_bufio]

.............................................................................................................................................................................................................................

              &(&sdev->list_lock)->rlock:       1246128        1246366           0.07          10.47      620751.44           0.50      256956752      270916504           0.06          19.56    99706202.34           0.37
              --------------------------
              &(&sdev->list_lock)->rlock         429898          [<ffffffff814ddda9>] scsi_put_command+0x29/0xd0
              &(&sdev->list_lock)->rlock         816468          [<ffffffff814ddc79>] scsi_get_command+0xb9/0x1c0
              --------------------------
              &(&sdev->list_lock)->rlock         192437          [<ffffffff814ddc79>] scsi_get_command+0xb9/0x1c0
              &(&sdev->list_lock)->rlock        1053929          [<ffffffff814ddda9>] scsi_put_command+0x29/0xd0

.............................................................................................................................................................................................................................

                 &(&prison->lock)->rlock:       1082605        1090480           0.08          16.95      840597.12           0.77       31440843       35307485           0.06          18.39    15958473.29           0.45
                 -----------------------
                 &(&prison->lock)->rlock         391448          [<ffffffffa08552eb>] dm_bio_detain+0x2b/0x70 [dm_bio_prison]
                 &(&prison->lock)->rlock         699032          [<ffffffffa08553ee>] dm_cell_release_no_holder+0x1e/0x70 [dm_bio_prison]
                 -----------------------
                 &(&prison->lock)->rlock         196897          [<ffffffffa08553ee>] dm_cell_release_no_holder+0x1e/0x70 [dm_bio_prison]
                 &(&prison->lock)->rlock         893583          [<ffffffffa08552eb>] dm_bio_detain+0x2b/0x70 [dm_bio_prison]

.............................................................................................................................................................................................................................

                     &(&tc->lock)->rlock:        125095         125095           0.10          16.52      104491.32           0.84       31528256       35370273           0.06          25.28    23655883.11           0.67
                     -------------------
                     &(&tc->lock)->rlock           9001          [<ffffffffa0877888>] cell_defer_no_holder+0x28/0x80 [dm_thin_pool]
                     &(&tc->lock)->rlock         115673          [<ffffffffa0876c19>] thin_defer_cell+0x39/0x90 [dm_thin_pool]
                     &(&tc->lock)->rlock            153          [<ffffffffa087b090>] do_worker+0x100/0x850 [dm_thin_pool]
                     &(&tc->lock)->rlock            268          [<ffffffffa087b3ca>] do_worker+0x43a/0x850 [dm_thin_pool]
                     -------------------
                     &(&tc->lock)->rlock          28599          [<ffffffffa0876c19>] thin_defer_cell+0x39/0x90 [dm_thin_pool]
                     &(&tc->lock)->rlock          96219          [<ffffffffa0877888>] cell_defer_no_holder+0x28/0x80 [dm_thin_pool]
                     &(&tc->lock)->rlock            175          [<ffffffffa087b090>] do_worker+0x100/0x850 [dm_thin_pool]
                     &(&tc->lock)->rlock            102          [<ffffffffa087b3ca>] do_worker+0x43a/0x850 [dm_thin_pool]

.............................................................................................................................................................................................................................

                            jiffies_lock:         99651         100211           0.16          17.75      119578.43           1.19         763761        1309154           0.23          22.68     1249008.18           0.95
                            ------------
                            jiffies_lock         100211          [<ffffffff8110f9cb>] tick_do_update_jiffies64+0x3b/0x150
                            ------------
                            jiffies_lock         100211          [<ffffffff8110f9cb>] tick_do_update_jiffies64+0x3b/0x150

.............................................................................................................................................................................................................................

                              &ctx->wait:         54909          54921           0.13          18.21       39940.30           0.73       34658498       68995970           0.05          30.11    56312044.61           0.82
                              ----------
                              &ctx->wait          10522          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                              &ctx->wait          44397          [<ffffffff810cc233>] finish_wait+0x43/0x80
                              &ctx->wait              2          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                              ----------
                              &ctx->wait           9896          [<ffffffff810cc233>] finish_wait+0x43/0x80
                              &ctx->wait          44634          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                              &ctx->wait            391          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0

.............................................................................................................................................................................................................................

                   random_read_wait.lock:         17513          17513           0.14          19.30       42096.74           2.40        1618834        1619427           0.10          28.13     6159199.30           3.80
                   ---------------------
                   random_read_wait.lock          17513          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                   ---------------------
                   random_read_wait.lock          17513          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                              rcu_node_0:          5787           5870           0.12           8.85        2673.23           0.46         270457         497287           0.06          39.99      189330.12           0.38
                              ----------
                              rcu_node_0           5789          [<ffffffff810f850d>] rcu_process_callbacks+0xed/0x6d0
                              rcu_node_0              8          [<ffffffff810f6cd8>] rcu_nocb_kthread+0x2c8/0x5c0
                              rcu_node_0             18          [<ffffffff810f88a2>] rcu_process_callbacks+0x482/0x6d0
                              rcu_node_0             33          [<ffffffff810f77f6>] force_qs_rnp+0x96/0x160
                              ----------
                              rcu_node_0             24          [<ffffffff810f8075>] rcu_gp_kthread+0x7b5/0xa40
                              rcu_node_0             29          [<ffffffff810f6cd8>] rcu_nocb_kthread+0x2c8/0x5c0
                              rcu_node_0           5605          [<ffffffff810f850d>] rcu_process_callbacks+0xed/0x6d0
                              rcu_node_0            112          [<ffffffff810f77f6>] force_qs_rnp+0x96/0x160

.............................................................................................................................................................................................................................

                 &(&n->list_lock)->rlock:          3419           3434           0.12           3.75        2294.93           0.67        4693800        5950333           0.08          19.82     3148736.70           0.53
                 -----------------------
                 &(&n->list_lock)->rlock           2824          [<ffffffff811fb48b>] get_partial_node.isra.68+0x4b/0x250
                 &(&n->list_lock)->rlock            518          [<ffffffff811fb23a>] unfreeze_partials.isra.67+0x6a/0x160
                 &(&n->list_lock)->rlock             92          [<ffffffff811fb792>] __slab_free+0x102/0x240
                 -----------------------
                 &(&n->list_lock)->rlock           2435          [<ffffffff811fb48b>] get_partial_node.isra.68+0x4b/0x250
                 &(&n->list_lock)->rlock            953          [<ffffffff811fb23a>] unfreeze_partials.isra.67+0x6a/0x160
                 &(&n->list_lock)->rlock             46          [<ffffffff811fb792>] __slab_free+0x102/0x240

.............................................................................................................................................................................................................................

         &(&ctx->completion_lock)->rlock:          2331           2333           0.10           1.41         813.84           0.35         253738      153106187           0.10          18.35    32726254.90           0.21
         -------------------------------
         &(&ctx->completion_lock)->rlock           2333          [<ffffffff8127165f>] aio_complete+0x6f/0x350
         -------------------------------
         &(&ctx->completion_lock)->rlock           2333          [<ffffffff8127165f>] aio_complete+0x6f/0x350

.............................................................................................................................................................................................................................

                   &(&zone->lock)->rlock:           675            678           0.15          27.38         428.30           0.63         524727        1100741           0.11          22.48      445618.66           0.40
                   ---------------------
                   &(&zone->lock)->rlock            414          [<ffffffff811a5ee3>] get_page_from_freelist+0x7b3/0xa30
                   &(&zone->lock)->rlock            240          [<ffffffff811a4578>] free_one_page+0x38/0x2e0
                   &(&zone->lock)->rlock             20          [<ffffffff811a3f83>] free_pcppages_bulk+0x33/0x450
                   &(&zone->lock)->rlock              4          [<ffffffff811a5c62>] get_page_from_freelist+0x532/0xa30
                   ---------------------
                   &(&zone->lock)->rlock            416          [<ffffffff811a5ee3>] get_page_from_freelist+0x7b3/0xa30
                   &(&zone->lock)->rlock            205          [<ffffffff811a4578>] free_one_page+0x38/0x2e0
                   &(&zone->lock)->rlock             43          [<ffffffff811a3f83>] free_pcppages_bulk+0x33/0x450
                   &(&zone->lock)->rlock             14          [<ffffffff811a5c62>] get_page_from_freelist+0x532/0xa30

.............................................................................................................................................................................................................................

                         &pool->lock#2/1:           392            394           0.20           9.57         408.67           1.04         125366         225137           0.11          26.22      377948.92           1.68
                         ---------------
                         &pool->lock#2/1            150          [<ffffffff8109d980>] process_one_work+0x2a0/0x570
                         &pool->lock#2/1              1          [<ffffffff8109c47b>] flush_work+0x9b/0x280
                         &pool->lock#2/1            108          [<ffffffff8109c0e8>] __queue_work+0x278/0x3c0
                         &pool->lock#2/1            134          [<ffffffff8109dde5>] worker_thread+0x195/0x460
                         ---------------
                         &pool->lock#2/1              5          [<ffffffff8109c47b>] flush_work+0x9b/0x280
                         &pool->lock#2/1            175          [<ffffffff8109dde5>] worker_thread+0x195/0x460
                         &pool->lock#2/1            175          [<ffffffff8109c0e8>] __queue_work+0x278/0x3c0
                         &pool->lock#2/1             39          [<ffffffff8109d980>] process_one_work+0x2a0/0x570

.............................................................................................................................................................................................................................

            &(ptlock_ptr(page))->rlock#2:           318            318           0.10          25.92         313.28           0.99          21048         255370           0.09        4763.10      169620.78           0.66
            ----------------------------
            &(ptlock_ptr(page))->rlock#2             16          [<ffffffff811cf1b7>] handle_pte_fault+0x1177/0x14c0
            &(ptlock_ptr(page))->rlock#2            150          [<ffffffff81201fdc>] remove_migration_pte+0xcc/0x300
            &(ptlock_ptr(page))->rlock#2              7          [<ffffffff8120286a>] __migration_entry_wait+0x1a/0xf0
            &(ptlock_ptr(page))->rlock#2            105          [<ffffffff811da173>] __page_check_address+0xe3/0x1d0
            ----------------------------
            &(ptlock_ptr(page))->rlock#2             16          [<ffffffff811cf1b7>] handle_pte_fault+0x1177/0x14c0
            &(ptlock_ptr(page))->rlock#2              4          [<ffffffff8120286a>] __migration_entry_wait+0x1a/0xf0
            &(ptlock_ptr(page))->rlock#2             91          [<ffffffff81201fdc>] remove_migration_pte+0xcc/0x300
            &(ptlock_ptr(page))->rlock#2            189          [<ffffffff811da173>] __page_check_address+0xe3/0x1d0

.............................................................................................................................................................................................................................

                            kernfs_mutex:           310            310           6.38         541.32       17324.41          55.89           1491         113343           0.10          30.55       22501.84           0.20
                            ------------
                            kernfs_mutex              8          [<ffffffff812a34f9>] kernfs_iop_follow_link+0x69/0x1c0
                            kernfs_mutex            101          [<ffffffff812a0618>] kernfs_dop_revalidate+0x38/0xc0
                            kernfs_mutex            173          [<ffffffff8129fd54>] kernfs_iop_permission+0x34/0x60
                            kernfs_mutex             21          [<ffffffff812a0cbd>] kernfs_fop_readdir+0x10d/0x250
                            ------------
                            kernfs_mutex              3          [<ffffffff812a0c08>] kernfs_fop_readdir+0x58/0x250
                            kernfs_mutex             15          [<ffffffff812a34f9>] kernfs_iop_follow_link+0x69/0x1c0
                            kernfs_mutex            139          [<ffffffff8129fd54>] kernfs_iop_permission+0x34/0x60
                            kernfs_mutex              7          [<ffffffff8129fcea>] kernfs_iop_getattr+0x2a/0x60

.............................................................................................................................................................................................................................

   &(&(__futex_data.queues)[i].lock)->rl:           214            216           0.12          22.14          89.27           0.41           2601          32908           0.05        2986.31       28080.49           0.85
   -------------------------------------
   &(&(__futex_data.queues)[i].lock)->rl             37          [<ffffffff8111275c>] futex_wait_setup+0xbc/0x140
   &(&(__futex_data.queues)[i].lock)->rl            179          [<ffffffff81111b98>] futex_wake+0xc8/0x170
   -------------------------------------
   &(&(__futex_data.queues)[i].lock)->rl             28          [<ffffffff811123dc>] futex_wake_op+0x3cc/0x630
   &(&(__futex_data.queues)[i].lock)->rl            170          [<ffffffff8111275c>] futex_wait_setup+0xbc/0x140
   &(&(__futex_data.queues)[i].lock)->rl              8          [<ffffffff811123ea>] futex_wake_op+0x3da/0x630
   &(&(__futex_data.queues)[i].lock)->rl             10          [<ffffffff81111b98>] futex_wake+0xc8/0x170

.............................................................................................................................................................................................................................

                   &(&base->lock)->rlock:           212            216           0.15           2.05         106.69           0.49          33868       70135281           0.08         101.02     9788207.02           0.14
                   ---------------------
                   &(&base->lock)->rlock            101          [<ffffffff810fc854>] lock_timer_base.isra.31+0x54/0x70
                   &(&base->lock)->rlock             30          [<ffffffff810fcd9f>] run_timer_softirq+0x25f/0x310
                   &(&base->lock)->rlock             57          [<ffffffff810ff130>] get_next_timer_interrupt+0x60/0x240
                   &(&base->lock)->rlock             12          [<ffffffff810fe99a>] add_timer_on+0x8a/0x190
                   ---------------------
                   &(&base->lock)->rlock             35          [<ffffffff810fcd9f>] run_timer_softirq+0x25f/0x310
                   &(&base->lock)->rlock            100          [<ffffffff810fc854>] lock_timer_base.isra.31+0x54/0x70
                   &(&base->lock)->rlock             19          [<ffffffff810fe99a>] add_timer_on+0x8a/0x190
                   &(&base->lock)->rlock             43          [<ffffffff810ff130>] get_next_timer_interrupt+0x60/0x240

.............................................................................................................................................................................................................................

                    &irq_desc_lock_class:           140            140           0.23           9.25         523.44           3.74          10197      207071454           0.06          21.77    36119238.84           0.17
                    --------------------
                    &irq_desc_lock_class             60          [<ffffffff810eab04>] handle_irq_event+0x44/0x60
                    &irq_desc_lock_class             71          [<ffffffff810edfc0>] handle_edge_irq+0x20/0x140
                    &irq_desc_lock_class              9          [<ffffffff810f2561>] show_interrupts+0x131/0x370
                    --------------------
                    &irq_desc_lock_class            121          [<ffffffff810f2561>] show_interrupts+0x131/0x370
                    &irq_desc_lock_class              7          [<ffffffff810edfc0>] handle_edge_irq+0x20/0x140
                    &irq_desc_lock_class              8          [<ffffffff810ec2b4>] __irq_set_affinity+0x34/0x70
                    &irq_desc_lock_class              4          [<ffffffff810eab04>] handle_irq_event+0x44/0x60

.............................................................................................................................................................................................................................

               &(&zone->lru_lock)->rlock:           106            107           0.14           5.95         115.07           1.08           1353          36298           0.12          17.17       16447.90           0.45
               -------------------------
               &(&zone->lru_lock)->rlock             46          [<ffffffff811abcd5>] pagevec_lru_move_fn+0x95/0x110
               &(&zone->lru_lock)->rlock              3          [<ffffffff811b121e>] isolate_lru_page+0x5e/0x140
               &(&zone->lru_lock)->rlock             52          [<ffffffff811abb3b>] release_pages+0x15b/0x260
               &(&zone->lru_lock)->rlock              6          [<ffffffff811ab4bf>] __page_cache_release+0x6f/0x120
               -------------------------
               &(&zone->lru_lock)->rlock             46          [<ffffffff811abcd5>] pagevec_lru_move_fn+0x95/0x110
               &(&zone->lru_lock)->rlock              5          [<ffffffff811b121e>] isolate_lru_page+0x5e/0x140
               &(&zone->lru_lock)->rlock             52          [<ffffffff811abb3b>] release_pages+0x15b/0x260
               &(&zone->lru_lock)->rlock              4          [<ffffffff811ab4bf>] __page_cache_release+0x6f/0x120

.............................................................................................................................................................................................................................

                      &anon_vma->rwsem-W:            98             99           0.10           1.41          49.83           0.50           2765          34449           0.05         741.60       18886.37           0.55
                      &anon_vma->rwsem-R:             0              0           0.00           0.00           0.00           0.00            499           3128           0.38         158.93        7764.88           2.48
                      ------------------
                        &anon_vma->rwsem             91          [<ffffffff811db1b4>] unlink_anon_vmas+0x94/0x1c0
                        &anon_vma->rwsem              8          [<ffffffff811dad8d>] __put_anon_vma+0x3d/0xc0
                      ------------------
                        &anon_vma->rwsem             99          [<ffffffff811db1b4>] unlink_anon_vmas+0x94/0x1c0

.............................................................................................................................................................................................................................

                &mapping->i_mmap_rwsem-W:            89             92           0.09          35.51         246.45           2.68           3998          15328           0.10          22.53        5886.03           0.38
                &mapping->i_mmap_rwsem-R:             1              5           8.41          19.14          70.43          14.09             26             86           0.62          53.03         653.04           7.59
                ------------------------
                  &mapping->i_mmap_rwsem             92          [<ffffffff811d43e2>] unlink_file_vma+0x32/0x60
                  &mapping->i_mmap_rwsem              5          [<ffffffff811db748>] rmap_walk+0x68/0x2f0
                ------------------------
                  &mapping->i_mmap_rwsem             89          [<ffffffff811d43e2>] unlink_file_vma+0x32/0x60
                  &mapping->i_mmap_rwsem              8          [<ffffffff811db748>] rmap_walk+0x68/0x2f0

.............................................................................................................................................................................................................................

                     &(&ep->lock)->rlock:            46             47           0.22           6.34          29.18           0.62           1415           8056           0.08          21.56        4467.52           0.55
                     -------------------
                     &(&ep->lock)->rlock             12          [<ffffffff8126bae6>] ep_scan_ready_list+0x56/0x210
                     &(&ep->lock)->rlock             19          [<ffffffff8126c0e6>] ep_poll_callback+0x36/0x1c0
                     &(&ep->lock)->rlock              5          [<ffffffff8126bb47>] ep_scan_ready_list+0xb7/0x210
                     &(&ep->lock)->rlock              5          [<ffffffff8126bdb9>] ep_poll+0xe9/0x320
                     -------------------
                     &(&ep->lock)->rlock             29          [<ffffffff8126c0e6>] ep_poll_callback+0x36/0x1c0
                     &(&ep->lock)->rlock              5          [<ffffffff8126bae6>] ep_scan_ready_list+0x56/0x210
                     &(&ep->lock)->rlock              2          [<ffffffff8126bdb9>] ep_poll+0xe9/0x320
                     &(&ep->lock)->rlock              8          [<ffffffff8126bf36>] ep_poll+0x266/0x320

.............................................................................................................................................................................................................................

                             logbuf_lock:             0             46           0.24           2.96          38.57           0.84            119          21618           0.10          13.80        4649.06           0.22
                             -----------
                             logbuf_lock             25          [<ffffffff810e7c62>] devkmsg_read+0x82/0x2d0
                             logbuf_lock             21          [<ffffffff810e67b4>] devkmsg_poll+0x44/0x80
                             -----------
                             logbuf_lock             25          [<ffffffff810e67b4>] devkmsg_poll+0x44/0x80
                             logbuf_lock             21          [<ffffffff810e7c62>] devkmsg_read+0x82/0x2d0

.............................................................................................................................................................................................................................

                     &rnp->nocb_gp_wq[1]:            40             44           0.23          13.38          66.30           1.51            916           1603           0.10          31.81        2217.30           1.38
                     -------------------
                     &rnp->nocb_gp_wq[1]             27          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                     &rnp->nocb_gp_wq[1]             17          [<ffffffff810cc233>] finish_wait+0x43/0x80
                     -------------------
                     &rnp->nocb_gp_wq[1]             27          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                     &rnp->nocb_gp_wq[1]             11          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                     &rnp->nocb_gp_wq[1]              6          [<ffffffff810cc233>] finish_wait+0x43/0x80

.............................................................................................................................................................................................................................

                           log_wait.lock:            41             41           0.53          10.26         194.88           4.75            124            166           0.55           8.61         687.47           4.14
                           -------------
                           log_wait.lock             41          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                           -------------
                           log_wait.lock             41          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                           slock-AF_INET:            37             37           0.31        1189.05        3639.76          98.37           2860           9320           0.08        2544.33       10811.19           1.16
                           -------------
                           slock-AF_INET             36          [<ffffffff815eb3af>] lock_sock_nested+0x3f/0xb0
                           slock-AF_INET              1          [<ffffffff815ecef7>] release_sock+0x37/0x1b0
                           -------------
                           slock-AF_INET             34          [<ffffffff81672b37>] tcp_v4_rcv+0x9a7/0xbd0
                           slock-AF_INET              3          [<ffffffff8166b35c>] tcp_tasklet_func+0xdc/0x130

.............................................................................................................................................................................................................................

       &(&dentry->d_lockref.lock)->rlock:            37             37           0.22           1.29          16.72           0.45           8656         318755           0.06        1685.49       87857.03           0.28
       ---------------------------------
       &(&dentry->d_lockref.lock)->rlock             17          [<ffffffff81236fce>] dput+0x11e/0x2b0
       &(&dentry->d_lockref.lock)->rlock             15          [<ffffffff8136c5cf>] lockref_get_not_dead+0xf/0x50
       &(&dentry->d_lockref.lock)->rlock              1          [<ffffffff8136c4fd>] lockref_get+0xd/0x20
       &(&dentry->d_lockref.lock)->rlock              1          [<ffffffff81239ea4>] __d_lookup+0xa4/0x1b0
       ---------------------------------
       &(&dentry->d_lockref.lock)->rlock             15          [<ffffffff81236fce>] dput+0x11e/0x2b0
       &(&dentry->d_lockref.lock)->rlock             15          [<ffffffff8136c5cf>] lockref_get_not_dead+0xf/0x50
       &(&dentry->d_lockref.lock)->rlock              2          [<ffffffff8136c4fd>] lockref_get+0xd/0x20
       &(&dentry->d_lockref.lock)->rlock              3          [<ffffffff8136c59d>] lockref_put_or_lock+0xd/0x30

.............................................................................................................................................................................................................................

                               pcpu_lock:            17             25           0.28           3.46          27.36           1.09             89            196           0.18           2.40         127.38           0.65
                               ---------
                               pcpu_lock              5          [<ffffffff811c041e>] pcpu_alloc+0x7e/0x640
                               pcpu_lock             20          [<ffffffff811bfec0>] free_percpu+0x40/0x170
                               ---------
                               pcpu_lock              5          [<ffffffff811c041e>] pcpu_alloc+0x7e/0x640
                               pcpu_lock             20          [<ffffffff811bfec0>] free_percpu+0x40/0x170

.............................................................................................................................................................................................................................

                     &rnp->nocb_gp_wq[0]:            20             23           0.26          24.44          81.96           3.56            854           1535           0.10          39.29        2083.00           1.36
                     -------------------
                     &rnp->nocb_gp_wq[0]             13          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                     &rnp->nocb_gp_wq[0]             10          [<ffffffff810cc233>] finish_wait+0x43/0x80
                     -------------------
                     &rnp->nocb_gp_wq[0]              8          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                     &rnp->nocb_gp_wq[0]             11          [<ffffffff810cc439>] prepare_to_wait_event+0x59/0xf0
                     &rnp->nocb_gp_wq[0]              4          [<ffffffff810cc233>] finish_wait+0x43/0x80

.............................................................................................................................................................................................................................

                    zone->wait_table + i:            23             23           0.16          44.58          57.28           2.49           1316           1732           0.10          67.12        3534.03           2.04
                    --------------------
                    zone->wait_table + i             22          [<ffffffff810cbfe7>] prepare_to_wait+0x27/0x90
                    zone->wait_table + i              1          [<ffffffff810cc233>] finish_wait+0x43/0x80
                    --------------------
                    zone->wait_table + i             22          [<ffffffff810cbfe7>] prepare_to_wait+0x27/0x90
                    zone->wait_table + i              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                      &(&u->lock)->rlock:            18             18           0.18           1.21          11.11           0.62            894           2025           0.10          57.30        1113.96           0.55
                      ------------------
                      &(&u->lock)->rlock              7          [<ffffffff816c0c5f>] unix_stream_read_generic+0x15f/0x900
                      &(&u->lock)->rlock              4          [<ffffffff816bff12>] unix_stream_sendmsg+0x172/0x3c0
                      &(&u->lock)->rlock              7          [<ffffffff816c235f>] unix_dgram_sendmsg+0x24f/0x690
                      ------------------
                      &(&u->lock)->rlock              7          [<ffffffff816bff12>] unix_stream_sendmsg+0x172/0x3c0
                      &(&u->lock)->rlock              1          [<ffffffff816c0820>] unix_release_sock+0xa0/0x350
                      &(&u->lock)->rlock              7          [<ffffffff816c235f>] unix_dgram_sendmsg+0x24f/0x690
                      &(&u->lock)->rlock              2          [<ffffffff816c0c5f>] unix_stream_read_generic+0x15f/0x900

.............................................................................................................................................................................................................................

             &(&sighand->siglock)->rlock:            17             17           0.36          35.34         118.49           6.97           1109           9963           0.07          21.11        4686.71           0.47
             ---------------------------
             &(&sighand->siglock)->rlock              8          [<ffffffff810927c9>] exit_signals+0xa9/0x150
             &(&sighand->siglock)->rlock              3          [<ffffffff8115287f>] taskstats_exit+0x7f/0x410
             &(&sighand->siglock)->rlock              4          [<ffffffff8111e470>] acct_collect+0x1c0/0x1e0
             &(&sighand->siglock)->rlock              2          [<ffffffff81083a79>] release_task+0xf9/0x510
             ---------------------------
             &(&sighand->siglock)->rlock              3          [<ffffffff810927c9>] exit_signals+0xa9/0x150
             &(&sighand->siglock)->rlock              7          [<ffffffff8115287f>] taskstats_exit+0x7f/0x410
             &(&sighand->siglock)->rlock              7          [<ffffffff81083a79>] release_task+0xf9/0x510

.............................................................................................................................................................................................................................

                             vector_lock:            12             13           0.26          16.64          46.81           3.60           1480           2650           0.15          41.71        7305.24           2.76
                             -----------
                             vector_lock              3          [<ffffffff81057fbf>] assign_irq_vector+0x2f/0x430
                             vector_lock              5          [<ffffffff810588ec>] smp_irq_move_cleanup_interrupt+0x4c/0x1b0
                             vector_lock              3          [<ffffffff81058942>] smp_irq_move_cleanup_interrupt+0xa2/0x1b0
                             vector_lock              2          [<ffffffff81057c8b>] __send_cleanup_vector+0x1b/0x80
                             -----------
                             vector_lock              9          [<ffffffff810588ec>] smp_irq_move_cleanup_interrupt+0x4c/0x1b0
                             vector_lock              2          [<ffffffff81057fbf>] assign_irq_vector+0x2f/0x430
                             vector_lock              1          [<ffffffff81058942>] smp_irq_move_cleanup_interrupt+0xa2/0x1b0
                             vector_lock              1          [<ffffffff81057c8b>] __send_cleanup_vector+0x1b/0x80

.............................................................................................................................................................................................................................

                               &wq->wait:            11             11           0.42           5.70          40.99           3.73           2173           9816           0.10          22.66        8696.65           0.89
                               ---------
                               &wq->wait             10          [<ffffffff810cc198>] __wake_up_sync_key+0x28/0x60
                               &wq->wait              1          [<ffffffff810cbf8c>] add_wait_queue+0x1c/0x50
                               ---------
                               &wq->wait             10          [<ffffffff810cc198>] __wake_up_sync_key+0x28/0x60
                               &wq->wait              1          [<ffffffff810cbf8c>] add_wait_queue+0x1c/0x50

.............................................................................................................................................................................................................................

   &(&(__futex_data.queues)[i].lock)->/1:            10             10           0.18           0.51           3.66           0.37            634            692           0.08          22.00         356.16           0.51
   -------------------------------------
   &(&(__futex_data.queues)[i].lock)->/1              9          [<ffffffff811123ea>] futex_wake_op+0x3da/0x630
   &(&(__futex_data.queues)[i].lock)->/1              1          [<ffffffff811124cb>] futex_wake_op+0x4bb/0x630
   -------------------------------------
   &(&(__futex_data.queues)[i].lock)->/1             10          [<ffffffff8111275c>] futex_wait_setup+0xbc/0x140

.............................................................................................................................................................................................................................

                         tasklist_lock-W:            10             10           0.30          40.14          80.76           8.08            204            377           0.29          22.04        1304.07           3.46
                         tasklist_lock-R:             0              0           0.00           0.00           0.00           0.00          20517        1867029           0.11        8937.06     2408582.02           1.29
                         ---------------
                           tasklist_lock              6          [<ffffffff81085474>] do_exit+0x374/0xb80
                           tasklist_lock              4          [<ffffffff81083a17>] release_task+0x97/0x510
                         ---------------
                           tasklist_lock              3          [<ffffffff81085474>] do_exit+0x374/0xb80
                           tasklist_lock              7          [<ffffffff81083a17>] release_task+0x97/0x510

.............................................................................................................................................................................................................................

                             &rsp->gp_wq:             8              8           0.20           4.81           9.19           1.15           1751          18016           0.10          26.19        8851.25           0.49
                             -----------
                             &rsp->gp_wq              8          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                             -----------
                             &rsp->gp_wq              7          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                             &rsp->gp_wq              1          [<ffffffff810cc233>] finish_wait+0x43/0x80

.............................................................................................................................................................................................................................

                         &mm->mmap_sem-W:             2              2          12.07          12.88          24.96          12.48            216          14288           0.10        9874.48      143294.64          10.03
                         &mm->mmap_sem-R:             3              4           1.16          26.07          50.40          12.60           1445         166782           0.10       16705.75      742188.28           4.45
                         ---------------
                           &mm->mmap_sem              2          [<ffffffff811e14d0>] SyS_madvise+0x560/0x720
                           &mm->mmap_sem              2          [<ffffffff811d5fa6>] vm_munmap+0x36/0x60
                           &mm->mmap_sem              2          [<ffffffff8108527e>] do_exit+0x17e/0xb80
                         ---------------
                           &mm->mmap_sem              2          [<ffffffff811d5fa6>] vm_munmap+0x36/0x60
                           &mm->mmap_sem              4          [<ffffffff811e14d0>] SyS_madvise+0x560/0x720

.............................................................................................................................................................................................................................

                    hrtimer_bases.lock#1:             4              5           0.41           1.01           3.30           0.66             20       20323609           0.09          28.64     7826260.11           0.39
                    --------------------
                    hrtimer_bases.lock#1              5          [<ffffffff810ffa09>] lock_hrtimer_base.isra.23+0x29/0x50
                    --------------------
                    hrtimer_bases.lock#1              5          [<ffffffff810ffa09>] lock_hrtimer_base.isra.23+0x29/0x50

.............................................................................................................................................................................................................................

                  kernfs_open_file_mutex:             5              5          14.95          45.41         144.41          28.88            108            600           0.36          19.80         379.32           0.63
                  ----------------------
                  kernfs_open_file_mutex              4          [<ffffffff812a315c>] kernfs_fop_open+0x1dc/0x370
                  kernfs_open_file_mutex              1          [<ffffffff812a2d17>] kernfs_put_open_node.isra.3+0x27/0x90
                  ----------------------
                  kernfs_open_file_mutex              4          [<ffffffff812a2d17>] kernfs_put_open_node.isra.3+0x27/0x90
                  kernfs_open_file_mutex              1          [<ffffffff812a315c>] kernfs_fop_open+0x1dc/0x370

.............................................................................................................................................................................................................................

                           callback_lock:             4              4           0.40           1.08           2.50           0.63             85             96           0.24          18.96          85.25           0.89
                           -------------
                           callback_lock              4          [<ffffffff81130f84>] cpuset_cpus_allowed+0x24/0xa0
                           -------------
                           callback_lock              4          [<ffffffff81130f84>] cpuset_cpus_allowed+0x24/0xa0

.............................................................................................................................................................................................................................

                             &p->pi_lock:             4              4           0.38           1.72           3.47           0.87       26819525       53133967           0.09          39.70   129423144.64           2.44
                             -----------
                             &p->pi_lock              4          [<ffffffff810b1201>] try_to_wake_up+0x31/0x460
                             -----------
                             &p->pi_lock              4          [<ffffffff810b1201>] try_to_wake_up+0x31/0x460

.............................................................................................................................................................................................................................

                         &sem->wait_lock:             3              3           0.49           4.27           6.58           2.19             41             61           0.13           9.87         117.73           1.93
                         ---------------
                         &sem->wait_lock              1          [<ffffffff810dbe4c>] rwsem_wake+0x7c/0xa0
                         &sem->wait_lock              2          [<ffffffff8173ee9d>] rwsem_down_write_failed+0x1bd/0x390
                         ---------------
                         &sem->wait_lock              2          [<ffffffff810dbe4c>] rwsem_wake+0x7c/0xa0
                         &sem->wait_lock              1          [<ffffffff8173ee9d>] rwsem_down_write_failed+0x1bd/0x390

.............................................................................................................................................................................................................................

                         &tty->read_wait:             3              3           0.31           0.87           1.53           0.51           1994           7541           0.10          22.49        9883.41           1.31
                         ---------------
                         &tty->read_wait              2          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40
                         &tty->read_wait              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                         ---------------
                         &tty->read_wait              2          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                         &tty->read_wait              1          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40

.............................................................................................................................................................................................................................

                  random_write_wait.lock:             3              3           0.55           4.42           5.89           1.96            110            316           0.10          21.29         648.63           2.05
                  ----------------------
                  random_write_wait.lock              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                  random_write_wait.lock              2          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40
                  ----------------------
                  random_write_wait.lock              3          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                   &(&host->lock)->rlock:             2              2           0.57           0.58           1.15           0.57            256            434           0.28           9.67        1053.87           2.43
                   ---------------------
                   &(&host->lock)->rlock              2          [<ffffffffa006765d>] ata_scsi_queuecmd+0x2d/0x3e0 [libata]
                   ---------------------
                   &(&host->lock)->rlock              1          [<ffffffffa002c1f2>] ahci_single_level_irq_intr+0x32/0x60 [libahci]
                   &(&host->lock)->rlock              1          [<ffffffffa006765d>] ata_scsi_queuecmd+0x2d/0x3e0 [libata]

.............................................................................................................................................................................................................................

                   nonblocking_pool.lock:             2              2           0.43           0.62           1.05           0.52            228            725           0.22           5.09         514.04           0.71
                   ---------------------
                   nonblocking_pool.lock              1          [<ffffffff81474260>] mix_pool_bytes+0x70/0x100
                   nonblocking_pool.lock              1          [<ffffffff814769a2>] extract_buf+0x72/0x140
                   ---------------------
                   nonblocking_pool.lock              1          [<ffffffff814769a2>] extract_buf+0x72/0x140
                   nonblocking_pool.lock              1          [<ffffffff81474260>] mix_pool_bytes+0x70/0x100

.............................................................................................................................................................................................................................

                         unix_table_lock:             2              2           0.39           0.57           0.96           0.48            170            398           0.11           2.55         141.99           0.36
                         ---------------
                         unix_table_lock              1          [<ffffffff816c18f8>] unix_find_other+0x88/0x210
                         unix_table_lock              1          [<ffffffff816bea04>] unix_create1+0x174/0x1e0
                         ---------------
                         unix_table_lock              1          [<ffffffff816c18f8>] unix_find_other+0x88/0x210
                         unix_table_lock              1          [<ffffffff816bea04>] unix_create1+0x174/0x1e0

.............................................................................................................................................................................................................................

                             &ids->rwsem:             2              2           1.25           1.91           3.16           1.58             93            104           0.49           9.74         136.13           1.31
                             -----------
                             &ids->rwsem              2          [<ffffffff812bfc50>] shm_close+0x30/0x120
                             -----------
                             &ids->rwsem              2          [<ffffffff812bfc50>] shm_close+0x30/0x120

.............................................................................................................................................................................................................................

                    hrtimer_bases.lock#1:             2              2           0.61           0.80           1.41           0.71              8        4122306           0.09          16.90     1463473.23           0.36
                    --------------------
                    hrtimer_bases.lock#1              2          [<ffffffff810ffa09>] lock_hrtimer_base.isra.23+0x29/0x50
                    --------------------
                    hrtimer_bases.lock#1              2          [<ffffffff810ffa09>] lock_hrtimer_base.isra.23+0x29/0x50

.............................................................................................................................................................................................................................

                       &pmd->root_lock-W:             0              0           0.00           0.00           0.00           0.00            127            131        5059.46       27647.39     1027884.83        7846.45
                       &pmd->root_lock-R:             2              2        6002.03        7582.72       13584.75        6792.37       32966926       35376259           0.10        4542.03  1061397737.58          30.00
                       -----------------
                         &pmd->root_lock              2          [<ffffffffa087efde>] dm_pool_issue_prefetches+0x1e/0x40 [dm_thin_pool]
                       -----------------
                         &pmd->root_lock              2          [<ffffffffa087e9a6>] dm_pool_commit_metadata+0x26/0x60 [dm_thin_pool]

.............................................................................................................................................................................................................................

              &group->notification_mutex:             2              2          12.05          18.90          30.95          15.47            646           2733           0.14          24.95         738.15           0.27
              --------------------------
              &group->notification_mutex              1          [<ffffffff812662cd>] fsnotify_add_event+0x3d/0x140
              &group->notification_mutex              1          [<ffffffff81268625>] inotify_read+0xa5/0x3f0
              --------------------------
              &group->notification_mutex              1          [<ffffffff81268625>] inotify_read+0xa5/0x3f0
              &group->notification_mutex              1          [<ffffffff812662cd>] fsnotify_add_event+0x3d/0x140

.............................................................................................................................................................................................................................

                             aio_nr_lock:             2              2           0.58           0.67           1.24           0.62             63             64           0.09           0.87          28.27           0.44
                             -----------
                             aio_nr_lock              2          [<ffffffff8127260f>] SyS_io_setup+0x58f/0xb10
                             -----------
                             aio_nr_lock              2          [<ffffffff8127260f>] SyS_io_setup+0x58f/0xb10

.............................................................................................................................................................................................................................

            percpu_ref_switch_waitq.lock:             2              2           0.47           0.74           1.21           0.60             59             66           0.10           0.71          20.31           0.31
            ----------------------------
            percpu_ref_switch_waitq.lock              2          [<ffffffff810cbe73>] __wake_up+0x23/0x50
            ----------------------------
            percpu_ref_switch_waitq.lock              2          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

              &group->notification_waitq:             2              2           0.32           0.44           0.76           0.38            587           2230           0.10           9.19        1388.90           0.62
              --------------------------
              &group->notification_waitq              2          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40
              --------------------------
              &group->notification_waitq              2          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                            css_set_lock:             2              2           0.67           3.58           4.25           2.12            180            438           0.11          31.28        1333.69           3.04
                            ------------
                            css_set_lock              2          [<ffffffff8112b432>] cgroup_exit+0x32/0xa0
                            ------------
                            css_set_lock              2          [<ffffffff8112b432>] cgroup_exit+0x32/0xa0

.............................................................................................................................................................................................................................

                        &tty->write_wait:             1              1           1.32           1.32           1.32           1.32           2478           9057           0.10          14.30        1817.51           0.20
                        ----------------
                        &tty->write_wait              1          [<ffffffff810cc149>] remove_wait_queue+0x19/0x40
                        ----------------
                        &tty->write_wait              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50

.............................................................................................................................................................................................................................

                        pcpu_alloc_mutex:             1              1          17.68          17.68          17.68          17.68             41             98           0.15           3.87          37.81           0.39
                        ----------------
                        pcpu_alloc_mutex              1          [<ffffffff811c07e7>] pcpu_alloc+0x447/0x640
                        ----------------
                        pcpu_alloc_mutex              1          [<ffffffff811c07e7>] pcpu_alloc+0x447/0x640

.............................................................................................................................................................................................................................

                      khugepaged_mm_lock:             1              1           0.48           0.48           0.48           0.48             68            480           0.10          34.94         191.21           0.40
                      ------------------
                      khugepaged_mm_lock              1          [<ffffffff812093bb>] __khugepaged_exit+0x1b/0x100
                      ------------------
                      khugepaged_mm_lock              1          [<ffffffff812093bb>] __khugepaged_exit+0x1b/0x100

.............................................................................................................................................................................................................................

              &(ptlock_ptr(page))->rlock:             1              1           1.09           1.09           1.09           1.09           1493          26710           0.11        3049.63       22130.51           0.83
              --------------------------
              &(ptlock_ptr(page))->rlock              1          [<ffffffff812090dc>] do_huge_pmd_anonymous_page+0x2ac/0x460
              --------------------------
              &(ptlock_ptr(page))->rlock              1          [<ffffffff812090dc>] do_huge_pmd_anonymous_page+0x2ac/0x460

.............................................................................................................................................................................................................................

                          &pipe->mutex/1:             1              1          10.33          10.33          10.33          10.33             73            114           0.16           8.83         179.19           1.57
                          --------------
                          &pipe->mutex/1              1          [<ffffffff81227b09>] pipe_wait+0x99/0xd0
                          --------------
                          &pipe->mutex/1              1          [<ffffffff81228588>] pipe_release+0x28/0xd0

.............................................................................................................................................................................................................................

                           &u->peer_wait:             1              1          90.43          90.43          90.43          90.43            140            325           0.10         146.57         221.58           0.68
                           -------------
                           &u->peer_wait              1          [<ffffffff810cbe73>] __wake_up+0x23/0x50
                           -------------
                           &u->peer_wait              1          [<ffffffff816be213>] unix_dgram_peer_wake_disconnect+0x23/0x70

.............................................................................................................................................................................................................................

                                   key#3:             1              1           0.37           0.37           0.37           0.37             41            324           0.10           0.43          43.55           0.13
                                   -----
                                   key#3              1          [<ffffffff813874e1>] __percpu_counter_add+0x41/0x70
                                   -----
                                   key#3              1          [<ffffffff813874e1>] __percpu_counter_add+0x41/0x70

.............................................................................................................................................................................................................................

                              &p->lock#2:             1              1          11.03          11.03          11.03          11.03           6926          45601           0.15         781.27       23154.14           0.51
                              ----------
                              &p->lock#2              1          [<ffffffffa0862d2c>] dm_tm_read_lock+0x7c/0xa0 [dm_persistent_data]
                              ----------
                              &p->lock#2              1          [<ffffffffa0862d2c>] dm_tm_read_lock+0x7c/0xa0 [dm_persistent_data]

.............................................................................................................................................................................................................................

                 &(&pool->lock)->rlock#4:             1              1           0.71           0.71           0.71           0.71            684         110917           0.10          19.81       15459.42           0.14
                 -----------------------
                 &(&pool->lock)->rlock#4              1          [<ffffffffa0876539>] pool_map+0x29/0x50 [dm_thin_pool]
                 -----------------------
                 &(&pool->lock)->rlock#4              1          [<ffffffffa08765a4>] process_prepared+0x44/0xc0 [dm_thin_pool]

.............................................................................................................................................................................................................................

                 &(&pool->lock)->rlock#2:             1              1           1.29           1.29           1.29           1.29           7902          78897           0.11          24.72      109733.46           1.39
                 -----------------------
                 &(&pool->lock)->rlock#2              1          [<ffffffff8109d980>] process_one_work+0x2a0/0x570
                 -----------------------
                 &(&pool->lock)->rlock#2              1          [<ffffffff8109c0e8>] __queue_work+0x278/0x3c0

.............................................................................................................................................................................................................................

                            memtype_lock:             0              0           0.00           0.00           0.00           0.00             16             22           0.53           2.36          27.42           1.25
                              text_mutex:             0              0           0.00           0.00           0.00           0.00             11             88          34.31        2967.64       16058.55         182.48
                           watchdog_lock:             0              0           0.00           0.00           0.00           0.00           2634           2634           1.52         552.25        7610.04           2.89
                          &port_lock_key:             0              0           0.00           0.00           0.00           0.00              4              8           1.79           2.43          16.56           2.07
                                pgd_lock:             0              0           0.00           0.00           0.00           0.00            101            150           0.17           1.10          74.83           0.50
                            console_lock:             0              0           0.00           0.00           0.00           0.00              0           6580           2.21       22955.01      198529.85          30.17
                      (console_sem).lock:             0              0           0.00           0.00           0.00           0.00              0          13161           0.10          13.51        3377.28           0.26
                      cpu_hotplug.lock#2:             0              0           0.00           0.00           0.00           0.00             32           1416           0.15          13.13         396.05           0.28
                          mount_lock#2-R:             0              0           0.00           0.00           0.00           0.00              0         130294           0.05           0.64       10618.39           0.08
                            init_fs.lock:             0              0           0.00           0.00           0.00           0.00             13             17           0.18           1.43           8.90           0.52
                           init_fs.seq-R:             0              0           0.00           0.00           0.00           0.00              0            457           0.05           0.21          35.21           0.08
               &sb->s_type->i_lock_key#2:             0              0           0.00           0.00           0.00           0.00              9             50           0.10           0.91          10.62           0.21
                      proc_subdir_lock-R:             0              0           0.00           0.00           0.00           0.00             62          17362           0.13        5853.57       22591.41           1.30
                             sysctl_lock:             0              0           0.00           0.00           0.00           0.00              7            154           0.09           8.55          29.53           0.19
                         rename_lock#2-W:             0              0           0.00           0.00           0.00           0.00              0             44           2.05           5.74         146.11           3.32
                         rename_lock#2-R:             0              0           0.00           0.00           0.00           0.00              0          18255           0.05           0.44        1319.63           0.07
                         cgroup_idr_lock:             0              0           0.00           0.00           0.00           0.00              4              6           0.38           1.41           5.07           0.85
                     cgroup_file_kn_lock:             0              0           0.00           0.00           0.00           0.00              4              4           0.43           0.57           1.99           0.50
                       uevent_sock_mutex:             0              0           0.00           0.00           0.00           0.00              5              8          13.53          31.53         181.61          22.70
              &sb->s_type->i_mutex_key#1:             0              0           0.00           0.00           0.00           0.00             15            562           0.14           0.74         103.05           0.18
             &cgroup_threadgroup_rwsem-W:             0              0           0.00           0.00           0.00           0.00              2             12           3.28          41.93         129.81          10.82
             &cgroup_threadgroup_rwsem-R:             0              0           0.00           0.00           0.00           0.00              0            227           0.10         528.11       15997.25          70.47
                    init_files.file_lock:             0              0           0.00           0.00           0.00           0.00              2              2           2.04           2.33           4.37           2.19
                               tk_core-W:             0              0           0.00           0.00           0.00           0.00              0        1200012           0.10          18.31      879134.29           0.73
                               tk_core-R:             0              0           0.00           0.00           0.00           0.00              0      720597949           0.05          28.85    47244593.86           0.07
                      cpu_hotplug.lock-R:             0              0           0.00           0.00           0.00           0.00              0           1416           1.79        2968.39       25171.33          17.78
                            cgroup_mutex:             0              0           0.00           0.00           0.00           0.00             27             97           1.57      202873.29      222696.01        2295.84
                         timekeeper_lock:             0              0           0.00           0.00           0.00           0.00         662749        1208732           0.12          19.68     1931147.44           1.60
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00             20       20540280           0.09          28.30     7693035.43           0.37
                                rtc_lock:             0              0           0.00           0.00           0.00           0.00              0              2          31.98          32.78          64.76          32.38
                    hrtimer_bases.lock#7:             0              0           0.00           0.00           0.00           0.00             20       18711791           0.09          26.30     7218237.61           0.39
         &(&s->s_inode_list_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             67            473           0.10           0.71          94.84           0.20
                    hrtimer_bases.lock#3:             0              0           0.00           0.00           0.00           0.00             10        6437124           0.09          21.67     2441827.46           0.38
                             ioapic_lock:             0              0           0.00           0.00           0.00           0.00              0           2916           0.10           2.26         761.08           0.26
                  &rt_b->rt_runtime_lock:             0              0           0.00           0.00           0.00           0.00           7921           8580           0.11          14.03        3106.10           0.36
                                 sb_lock:             0              0           0.00           0.00           0.00           0.00             31             32           1.72           8.26         101.69           3.18
        &(&p->vtime_seqlock)->seqcount-R:             0              0           0.00           0.00           0.00           0.00              0            644           0.05           0.25          47.65           0.07
                 &rt_rq->rt_runtime_lock:             0              0           0.00           0.00           0.00           0.00          15157          17246           0.10          13.78        4028.57           0.23
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              8       12628691           0.09          19.87     3981847.69           0.32
                               bdev_lock:             0              0           0.00           0.00           0.00           0.00             58            102           0.12           4.69          65.30           0.64
                          rcu_callback-R:             0              0           0.00           0.00           0.00           0.00              0          45552           0.11        1843.31       21959.19           0.48
                            s_active#1-W:             0              0           0.00           0.00           0.00           0.00              2             14           0.22           0.62           5.03           0.36
                            s_active#1-R:             0              0           0.00           0.00           0.00           0.00              0             72           0.49          11.66         245.70           3.41
                    hrtimer_bases.lock#4:             0              0           0.00           0.00           0.00           0.00              4        8508465           0.09          25.89     2901373.30           0.34
                    hrtimer_bases.lock#5:             0              0           0.00           0.00           0.00           0.00             12        6371435           0.09          16.69     1936335.49           0.30
                    hrtimer_bases.lock#6:             0              0           0.00           0.00           0.00           0.00              4        3943236           0.09          17.14     1544870.26           0.39
                    hrtimer_bases.lock#8:             0              0           0.00           0.00           0.00           0.00             28       19393748           0.09          28.65     7606911.56           0.39
                    hrtimer_bases.lock#9:             0              0           0.00           0.00           0.00           0.00             22       20238348           0.09          31.17     7605840.87           0.38
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00             30       19681923           0.09          29.00     7613621.85           0.39
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              2        4386007           0.09          17.14     1536878.03           0.35
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              2        1173802           0.10          14.30      610773.61           0.52
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              0        2238915           0.09          14.75      822634.55           0.37
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              0        2517732           0.09          14.33      936725.58           0.37
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              2       11540131           0.09          20.04     4427046.56           0.38
                    hrtimer_bases.lock#1:             0              0           0.00           0.00           0.00           0.00              8        4513907           0.09          16.03     1904722.25           0.42
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              4        3533541           0.09          27.99     1428542.51           0.40
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              4         978544           0.10          14.21      448214.21           0.46
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              4         834562           0.10          15.03      397146.66           0.48
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              2         973766           0.09          15.14      455720.87           0.47
                    hrtimer_bases.lock#2:             0              0           0.00           0.00           0.00           0.00              0        1661729           0.09          16.52      718512.42           0.43
                        stop_cpus_lock-R:             0              0           0.00           0.00           0.00           0.00              0             15           5.06          41.88         131.81           8.79
                              &x->wait#2:             0              0           0.00           0.00           0.00           0.00            104            197           0.10          31.68         117.83           0.60
               &sb->s_type->i_lock_key#5:             0              0           0.00           0.00           0.00           0.00            177           1635           0.08          18.49         374.48           0.23
                               balancing:             0              0           0.00           0.00           0.00           0.00              0        5816324           0.05        7935.07     1333984.49           0.23
                              &fs->seq-W:             0              0           0.00           0.00           0.00           0.00              0              4           0.06           0.10           0.32           0.08
                              &fs->seq-R:             0              0           0.00           0.00           0.00           0.00              0         129453           0.05           0.58       11059.31           0.09
            &(&sbinfo->stat_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             27            120           0.10           1.28          21.87           0.18
               &sb->s_type->i_lock_key#6:             0              0           0.00           0.00           0.00           0.00             10             32           0.14           0.58           8.29           0.26
                             rename_lock:             0              0           0.00           0.00           0.00           0.00             11             44           2.26           6.54         162.26           3.69
                        &dentry->d_seq-W:             0              0           0.00           0.00           0.00           0.00              0             44           0.64           2.34          51.15           1.16
                        &dentry->d_seq-R:             0              0           0.00           0.00           0.00           0.00              0          12352           0.05           0.44         827.16           0.07
                     &(&fs->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            143            236           0.10          19.37         116.88           0.50
                      "events_unbound"-R:             0              0           0.00           0.00           0.00           0.00              0           1512           0.06        6387.47       36626.71          24.22
                    &(&k->k_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              2            426           0.11           0.64          66.32           0.16
        &(&mapping->private_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             63             87           0.11           4.61          72.70           0.84
                              rtnl_mutex:             0              0           0.00           0.00           0.00           0.00              0             10           2.43         566.59         597.94          59.79
                           binfmt_lock-R:             0              0           0.00           0.00           0.00           0.00             16             70           0.12           0.76          17.49           0.25
               &sb->s_type->i_lock_key#8:             0              0           0.00           0.00           0.00           0.00             21           1204           0.08         504.12        1015.37           0.84
              &(&newf->file_lock)->rlock:             0              0           0.00           0.00           0.00           0.00            325          16965           0.10         638.03        7005.14           0.41
                         resource_lock-R:             0              0           0.00           0.00           0.00           0.00             16             44           0.61           3.81          68.59           1.56
                           &rdp->nocb_wq:             0              0           0.00           0.00           0.00           0.00           2084           4696           0.10          25.01        7009.16           1.49
                     file_systems_lock-R:             0              0           0.00           0.00           0.00           0.00              6              8           4.96          12.24          79.68           9.96
                              ((&timer)):             0              0           0.00           0.00           0.00           0.00              0          62858           0.05        2383.95      151512.84           2.41
                &(&stopper->lock)->rlock:             0              0           0.00           0.00           0.00           0.00         248114         620815           0.09           9.24      411455.05           0.66
                         simple_ida_lock:             0              0           0.00           0.00           0.00           0.00             16             33           0.22           3.32          34.07           1.03
                              &wq->mutex:             0              0           0.00           0.00           0.00           0.00              4             16           0.51          17.24          49.84           3.11
                    &(&idp->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              7             38           0.10           1.08           9.61           0.25
                     &pool->attach_mutex:             0              0           0.00           0.00           0.00           0.00              9             15           0.41           1.55          14.23           0.95
                                &x->wait:             0              0           0.00           0.00           0.00           0.00             24             32           0.14           7.18          46.63           1.46
                     kthread_create_lock:             0              0           0.00           0.00           0.00           0.00             14             27           0.12          13.59          21.82           0.81
         &(*(&acpi_gbl_gpe_lock))->rlock:             0              0           0.00           0.00           0.00           0.00           5832           5832           2.19          32.27       40672.72           6.97
                               &pl->lock:             0              0           0.00           0.00           0.00           0.00             24             40           1.76           4.44         106.41           2.66
                      &pool->manager_arb:             0              0           0.00           0.00           0.00           0.00              0              9          87.83         157.54        1044.00         116.00
                 ((&pool->mayday_timer)):             0              0           0.00           0.00           0.00           0.00              0              9           0.08           0.24           1.59           0.18
                              "kacpid"-R:             0              0           0.00           0.00           0.00           0.00              0           2916          69.91       76506.08     2131361.63         730.92
                            (&dpc->work):             0              0           0.00           0.00           0.00           0.00              0           2916          69.72       76505.75     2127506.69         729.60
                        "kacpi_notify"-R:             0              0           0.00           0.00           0.00           0.00              0           2916           2.88        3109.86       33737.43          11.57
                          (&dpc->work)#2:             0              0           0.00           0.00           0.00           0.00              0           2916           2.72        3109.53       32718.23          11.22
                            sb_writers-R:             0              0           0.00           0.00           0.00           0.00              0            175           0.28           2.61         144.20           0.82
              &sb->s_type->i_mutex_key#5:             0              0           0.00           0.00           0.00           0.00             30             64           0.43           1.74          57.48           0.90
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00             49            270           0.08           1.66          69.02           0.26
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00              7             32           0.08           1.99          18.83           0.59
                              "events"-R:             0              0           0.00           0.00           0.00           0.00              0           2859           1.27       51024.03      679730.70         237.75
                              &x->wait#6:             0              0           0.00           0.00           0.00           0.00             18            180           0.11          10.36         212.35           1.18
                           (&barr->work):             0              0           0.00           0.00           0.00           0.00              0             54           2.36          14.19         224.35           4.15
                 &(&xattrs->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             35            108           0.10           0.48          19.08           0.18
                         sk_lock-AF_UNIX:             0              0           0.00           0.00           0.00           0.00              0             32           0.16           0.99          12.66           0.40
                    &cgrp->pidlist_mutex:             0              0           0.00           0.00           0.00           0.00             10             40           0.43           9.76         141.31           3.53
                              &tbl->lock:             0              0           0.00           0.00           0.00           0.00              0            175           0.57          84.25         323.84           1.85
              "events_power_efficient"-R:             0              0           0.00           0.00           0.00           0.00              0           6771           0.76       22957.09      282830.74          41.77
              (check_lifetime_work).work:             0              0           0.00           0.00           0.00           0.00              0             11          35.43          98.16         630.28          57.30
            (&(&l->destroy_dwork)->work):             0              0           0.00           0.00           0.00           0.00              0             10           0.86           2.96          19.39           1.94
                   rcu_read_lock_sched-R:             0              0           0.00           0.00           0.00           0.00              0     2037602141           0.05       22500.39   379602965.10           0.19
           &(&mapping->tree_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           7089         260319           0.09          16.55       38236.35           0.15
                     fs/file_table.c:262:             0              0           0.00           0.00           0.00           0.00              0              8           2.30           3.82          23.32           2.91
                (delayed_fput_work).work:             0              0           0.00           0.00           0.00           0.00              0              8           6.46          50.65         158.03          19.75
                                     key:             0              0           0.00           0.00           0.00           0.00              5              6           0.32           0.63           2.76           0.46
                &child->perf_event_mutex:             0              0           0.00           0.00           0.00           0.00            100            112           0.20           6.57          65.10           0.58
                     &sig->wait_chldexit:             0              0           0.00           0.00           0.00           0.00          20401        3733802           0.10          19.35      503166.03           0.13
     &(&(&sig->stats_lock)->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            128            166           0.27          16.24         318.19           1.92
         &(&sig->stats_lock)->seqcount-W:             0              0           0.00           0.00           0.00           0.00              0            166           0.09          15.69         231.35           1.39
         &(&sig->stats_lock)->seqcount-R:             0              0           0.00           0.00           0.00           0.00              0             56           0.05           0.13           3.62           0.06
                     audit_freelist_lock:             0              0           0.00           0.00           0.00           0.00              3             28           0.11           0.82           7.25           0.26
                           key_user_lock:             0              0           0.00           0.00           0.00           0.00              2              2           0.57           0.73           1.30           0.65
                         key_serial_lock:             0              0           0.00           0.00           0.00           0.00              6             20           0.15           2.12          12.62           0.63
                  key_construction_mutex:             0              0           0.00           0.00           0.00           0.00              2              2           2.38           2.73           5.10           2.55
                       keyring_name_lock:             0              0           0.00           0.00           0.00           0.00              4              4           0.42           1.01           2.38           0.60
                            destroy_lock:             0              0           0.00           0.00           0.00           0.00             16             16           0.18           0.75           6.00           0.38
               &(&sp->queue_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              5             16           0.12           0.81           5.57           0.35
                      destroy_waitq.lock:             0              0           0.00           0.00           0.00           0.00             16             32           0.10           6.93          50.41           1.58
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00             31            224           0.09           1.94          70.51           0.31
        &(kretprobe_table_locks[i].lock):             0              0           0.00           0.00           0.00           0.00            107            112           0.11           3.88          44.02           0.39
                              &x->wait#8:             0              0           0.00           0.00           0.00           0.00              4              6           0.16           3.36           7.53           1.26
                       (&sub_info->work):             0              0           0.00           0.00           0.00           0.00              0              2          38.10          39.28          77.38          38.69
                         umh_sysctl_lock:             0              0           0.00           0.00           0.00           0.00              2              2           0.55           0.61           1.16           0.58
                  &sig->cred_guard_mutex:             0              0           0.00           0.00           0.00           0.00             25             26           0.43         729.85        8529.75         328.07
          &(&mm->page_table_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             39           1273           0.10           1.61         213.28           0.17
                        &ev->block_mutex:             0              0           0.00           0.00           0.00           0.00             15             18           1.84           4.53          47.90           2.66
                         &bdev->bd_mutex:             0              0           0.00           0.00           0.00           0.00             97            270           0.14         169.97        1538.16           5.70
          &(ptlock_ptr(page))->rlock#2/1:             0              0           0.00           0.00           0.00           0.00            246           3069           0.12          41.49        1586.94           0.52
                               uts_sem-R:             0              0           0.00           0.00           0.00           0.00             10             10           0.30           0.96           6.47           0.65
     &(&dentry->d_lockref.lock)->rlock/1:             0              0           0.00           0.00           0.00           0.00             70            184           0.08           2.90          65.35           0.36
                             &prev->lock:             0              0           0.00           0.00           0.00           0.00            109            120           0.12           1.53          38.56           0.32
              running_helpers_waitq.lock:             0              0           0.00           0.00           0.00           0.00              2              2           0.56           0.70           1.27           0.63
                    (&ops->cursor_timer):             0              0           0.00           0.00           0.00           0.00              0           6581           1.22        1134.87       47632.70           7.24
                          (&info->queue):             0              0           0.00           0.00           0.00           0.00              0           6581           0.53       22956.81      267912.37          40.71
                            &port->mutex:             0              0           0.00           0.00           0.00           0.00              4              8           2.22           3.45          21.91           2.74
                           irq_2_ir_lock:             0              0           0.00           0.00           0.00           0.00             35            911           1.72           4.23        2113.25           2.32
                        block_class_lock:             0              0           0.00           0.00           0.00           0.00             50             90           0.19           3.76          95.26           1.06
                    khugepaged_wait.lock:             0              0           0.00           0.00           0.00           0.00             27            396           0.10           1.65          90.48           0.23
                         sparse_irq_lock:             0              0           0.00           0.00           0.00           0.00             40         389504           0.14        2703.87      359319.70           0.92
   &(*(&acpi_gbl_reference_count_lock))-:             0              0           0.00           0.00           0.00           0.00              0         361584           0.10          14.14       52314.20           0.14
                             &qi->q_lock:             0              0           0.00           0.00           0.00           0.00             35           1823           0.18           2.32        1263.52           0.69
                         semaphore->lock:             0              0           0.00           0.00           0.00           0.00              0         148716           0.10          13.84       20287.72           0.14
   (&(({ do { const void *__vpp_verify =:             0              0           0.00           0.00           0.00           0.00              0          10609           1.01       11095.23      188422.02          17.76
                              "vmstat"-R:             0              0           0.00           0.00           0.00           0.00              0          10609           1.19       11095.50      220032.74          20.74
                         (shepherd).work:             0              0           0.00           0.00           0.00           0.00              0           1316           3.01         151.86       10873.20           8.26
                        mm/vmstat.c:1452:             0              0           0.00           0.00           0.00           0.00              0           1316           1.90          18.98        5307.60           4.03
                           (&cpu->timer):             0              0           0.00           0.00           0.00           0.00              0        1464403           0.76       12085.49     3013994.72           2.06
                 "%s"("ipv6_addrconf")-R:             0              0           0.00           0.00           0.00           0.00              0             10           3.44         568.17         614.46          61.45
                    (addr_chk_work).work:             0              0           0.00           0.00           0.00           0.00              0             10           3.15         567.59         608.40          60.84
                      rcu_read_lock_bh-R:             0              0           0.00           0.00           0.00           0.00              0           6819           0.06         562.20       34000.72           4.99
   (&(({ do { const void *__vpp_verify =:             0              0           0.00           0.00           0.00           0.00              0           9832           0.66          19.93       39088.21           3.98
                               swap_lock:             0              0           0.00           0.00           0.00           0.00             10             12           0.15           0.94           7.09           0.59
                      root_key_user.lock:             0              0           0.00           0.00           0.00           0.00              4              8           0.14           0.44           2.31           0.29
                       &type->lock_class:             0              0           0.00           0.00           0.00           0.00              0              2           3.69           5.47           9.16           4.58
              keyring_serialise_link_sem:             0              0           0.00           0.00           0.00           0.00              2              2           2.91           4.57           7.48           3.74
                                   key#9:             0              0           0.00           0.00           0.00           0.00             26             77           0.46           2.19          76.85           1.00
                     &bp->port.phy_mutex:             0              0           0.00           0.00           0.00           0.00            903           5256         149.27       16106.72     1196715.80         227.69
                    (&dom->period_timer):             0              0           0.00           0.00           0.00           0.00              0             77           0.89           6.36         185.23           2.41
                               cdev_lock:             0              0           0.00           0.00           0.00           0.00             15             62           0.13           0.78          17.18           0.28
                            unix_gc_lock:             0              0           0.00           0.00           0.00           0.00              4              8           0.16           0.52           2.43           0.30
                   &tty->termios_rwsem-R:             0              0           0.00           0.00           0.00           0.00           1744           2840           0.40        3499.03       33249.32          11.71
                       &tty->ldisc_sem-R:             0              0           0.00           0.00           0.00           0.00           3059          13840           0.11    57558379.74   115796910.75        8366.83
                    &(&f->f_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             37            230           0.10          32.57          71.37           0.31
                              &buf->lock:             0              0           0.00           0.00           0.00           0.00            463           1374           0.16        3779.80       27922.81          20.32
         &(&ent->pde_unload_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           1459          16758           0.10        5127.62       11521.65           0.69
                            (&buf->work):             0              0           0.00           0.00           0.00           0.00              0           4721           0.05        6387.14       36640.47           7.76
                         inode_hash_lock:             0              0           0.00           0.00           0.00           0.00              4             30           0.33           1.90          24.12           0.80
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00            421            438           0.10           0.63          54.04           0.12
            &(&lru->node[i].lock)->rlock:             0              0           0.00           0.00           0.00           0.00             36            103           0.10           0.80          27.02           0.26
                  &type->i_mutex_dir_key:             0              0           0.00           0.00           0.00           0.00            517            994           0.54          97.16        4213.10           4.24
                          sb_writers#3-R:             0              0           0.00           0.00           0.00           0.00              0            150           0.28          40.91         413.14           2.75
                          sb_writers#4-R:             0              0           0.00           0.00           0.00           0.00              0           2761           2.15        4662.31       54579.48          19.77
                                &p->lock:             0              0           0.00           0.00           0.00           0.00              4           9825           0.16       18845.32      581492.75          59.19
              &sb->s_type->i_mutex_key#9:             0              0           0.00           0.00           0.00           0.00            192           1337           0.40         370.68        6971.50           5.21
                          sb_writers#5-R:             0              0           0.00           0.00           0.00           0.00              0           1421           0.28         371.15        8982.40           6.32
            &sb->s_type->i_mutex_key#9/1:             0              0           0.00           0.00           0.00           0.00             28            156           1.13          43.95        1702.73          10.91
               &sb->s_type->i_lock_key#1:             0              0           0.00           0.00           0.00           0.00              4            108           0.11           1.32          36.36           0.34
            &(&tsk->delays->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            935           2544           0.10           2.87         475.23           0.19
                         task_group_lock:             0              0           0.00           0.00           0.00           0.00             38             68           0.13          11.61          34.99           0.51
                   kernfs_open_node_lock:             0              0           0.00           0.00           0.00           0.00            108            600           0.11           1.64         114.79           0.19
                              &of->mutex:             0              0           0.00           0.00           0.00           0.00              0            227           0.43      202877.00      222270.51         979.17
                 &tty->atomic_write_lock:             0              0           0.00           0.00           0.00           0.00              0           1490           1.68        1829.42       26157.49          17.56
                     &ldata->output_lock:             0              0           0.00           0.00           0.00           0.00            671           1554           0.17        1826.91       20549.62          13.22
                 &(&list->lock)->rlock#2:             0              0           0.00           0.00           0.00           0.00            309           1219           0.09          15.99         218.00           0.18
                              &nlk->wait:             0              0           0.00           0.00           0.00           0.00             36            102           0.10           0.52          21.15           0.21
                        clock-AF_NETLINK:             0              0           0.00           0.00           0.00           0.00              3             20           0.11           0.47           4.28           0.21
                                &ep->mtx:             0              0           0.00           0.00           0.00           0.00            207           2100           0.14          65.18        3134.54           1.49
                  &sighand->signalfd_wqh:             0              0           0.00           0.00           0.00           0.00             34             40           0.13           8.20         103.23           2.58
       &(&conn->immed_queue_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           6614           0.09         247.70        1581.40           0.24
                      kernfs_rename_lock:             0              0           0.00           0.00           0.00           0.00             24            849           0.14           1.83         227.54           0.27
                &type->i_mutex_dir_key#2:             0              0           0.00           0.00           0.00           0.00             18            110           0.62          51.82         411.29           3.74
                          sb_writers#6-R:             0              0           0.00           0.00           0.00           0.00              0             18           2.96      202878.26      221697.55       12316.53
                              s_active#1:             0              0           0.00           0.00           0.00           0.00              2              2           0.23           0.36           0.59           0.29
                           &rsp->gp_wait:             0              0           0.00           0.00           0.00           0.00              6             30           0.10           0.73           7.85           0.26
                     "cpuset_migrate_mm":             0              0           0.00           0.00           0.00           0.00              0             12           0.06           0.42           1.46           0.12
                               &ctx->wqh:             0              0           0.00           0.00           0.00           0.00             50            388           0.10          14.00         683.12           1.76
                       &mm->context.lock:             0              0           0.00           0.00           0.00           0.00             36             74           0.19           0.82          26.96           0.36
                         &dup_mmap_sem-R:             0              0           0.00           0.00           0.00           0.00              0             54          48.03         503.52       14199.33         262.95
                         &mm->mmap_sem/1:             0              0           0.00           0.00           0.00           0.00              0             54          46.97         502.44       14141.35         261.88
                       &brw->write_waitq:             0              0           0.00           0.00           0.00           0.00             14             18           0.15           0.71           6.14           0.34
                           clock-AF_UNIX:             0              0           0.00           0.00           0.00           0.00             39            180           0.10           2.04          44.56           0.25
      &af_unix_sk_receive_queue_lock_key:             0              0           0.00           0.00           0.00           0.00            928           1618           0.10           0.90         344.49           0.21
                   &(&info->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            188         121479           0.10           8.47       12502.72           0.10
                      &newf->resize_wait:             0              0           0.00           0.00           0.00           0.00              2              2           0.37           0.42           0.79           0.40
                             &pipe->wait:             0              0           0.00           0.00           0.00           0.00            682           5914           0.10          10.06        1239.28           0.21
                          sb_writers#7-R:             0              0           0.00           0.00           0.00           0.00              0             24           0.46           1.21          20.10           0.84
                &(&br->hash_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0              4           1.39           2.16           6.95           1.74
                      &group->mark_mutex:             0              0           0.00           0.00           0.00           0.00              6              8           2.61           5.77          34.59           4.32
   &(&group->inotify_data.idr_lock)->rlo:             0              0           0.00           0.00           0.00           0.00             10             24           0.36           1.51          16.91           0.70
                   &(&mark->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              4             24           0.10           2.65          20.41           0.85
                            &u->readlock:             0              0           0.00           0.00           0.00           0.00            164            927           0.36          75.49        2662.06           2.87
                           slock-AF_UNIX:             0              0           0.00           0.00           0.00           0.00              2             64           0.10           0.36          10.28           0.16
                     &tty->winsize_mutex:             0              0           0.00           0.00           0.00           0.00              4             11           0.21           5.50           8.92           0.81
                &(&wb->list_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             88            287           0.31          54.43         401.98           1.40
              &type->i_mutex_dir_key#2/1:             0              0           0.00           0.00           0.00           0.00              4              4          40.37          63.35         212.63          53.16
                                   key#2:             0              0           0.00           0.00           0.00           0.00              2              2           2.44           2.77           5.21           2.61
                             &user->lock:             0              0           0.00           0.00           0.00           0.00             46            887           0.74          49.35        1255.11           1.42
                            s_active#1-R:             0              0           0.00           0.00           0.00           0.00              0             64           0.16          39.16         379.05           5.92
                    &(&u->lock)->rlock/1:             0              0           0.00           0.00           0.00           0.00              0             33           0.72          55.47         120.57           3.65
                             iattr_mutex:             0              0           0.00           0.00           0.00           0.00              5             16           0.16           0.88           4.99           0.31
               &(&xattrs->lock)->rlock#2:             0              0           0.00           0.00           0.00           0.00              5              8           0.12           0.39           2.26           0.28
              &sb->s_type->i_mutex_key#1:             0              0           0.00           0.00           0.00           0.00              5              8           1.69          17.81          42.82           5.35
             (&cgrp->release_agent_work):             0              0           0.00           0.00           0.00           0.00              0              4           0.06         446.31         663.54         165.88
                         audit_cmd_mutex:             0              0           0.00           0.00           0.00           0.00              7             28           0.97          22.74         109.16           3.90
                 &(&list->lock)->rlock#3:             0              0           0.00           0.00           0.00           0.00             22             42           0.12           0.47           8.94           0.21
                       kauditd_wait.lock:             0              0           0.00           0.00           0.00           0.00             22             56           0.10           8.17          82.76           1.48
                              s_active#1:             0              0           0.00           0.00           0.00           0.00              2              2           0.33           0.39           0.72           0.36
                              s_active#1:             0              0           0.00           0.00           0.00           0.00              2              2           0.24           0.27           0.51           0.26
                 &root->deactivate_waitq:             0              0           0.00           0.00           0.00           0.00              2              2           0.47           0.57           1.04           0.52
                      "cgroup_destroy"-R:             0              0           0.00           0.00           0.00           0.00              0              4           3.29         191.73         343.91          85.98
                    (&css->destroy_work):             0              0           0.00           0.00           0.00           0.00              0              2           2.26           2.93           5.20           2.60
                  (&css->destroy_work)#2:             0              0           0.00           0.00           0.00           0.00              0              2         144.53         191.22         335.75         167.88
              "cgroup_pidlist_destroy"-W:             0              0           0.00           0.00           0.00           0.00              0              2           0.17           0.23           0.39           0.20
              "cgroup_pidlist_destroy"-R:             0              0           0.00           0.00           0.00           0.00              0             10           1.53           3.82          25.84           2.58
               &(&net->nsid_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              9             40           0.11           1.06          11.17           0.28
            &sb->s_type->i_mutex_key#9/4:             0              0           0.00           0.00           0.00           0.00              5             44           0.11          10.09         177.91           4.04
     &(&dentry->d_lockref.lock)->rlock/2:             0              0           0.00           0.00           0.00           0.00              0             44           0.24           0.80          17.24           0.39
     &(&dentry->d_lockref.lock)->rlock/3:             0              0           0.00           0.00           0.00           0.00              0             44           0.11           0.28           7.66           0.17
                        &dentry->d_seq/1:             0              0           0.00           0.00           0.00           0.00              0             44           0.35           1.50          30.34           0.69
                                 epmutex:             0              0           0.00           0.00           0.00           0.00              8             16           0.47          16.55          53.23           3.33
                       ((&br->gc_timer)):             0              0           0.00           0.00           0.00           0.00              0              4           2.59           4.23          14.72           3.68
        &(&adapter->stats64_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              8           1332           0.13         241.09         693.96           0.52
                                dca_lock:             0              0           0.00           0.00           0.00           0.00             54            786           0.16           3.70         460.93           0.59
              reservation_ww_class_mutex:             0              0           0.00           0.00           0.00           0.00              0           6580           1.12       22950.39      110163.41          16.74
               &(&glob->lru_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           6580           0.11        2371.43        7600.09           1.16
                  (&mddev->flush_work)#2:             0              0           0.00           0.00           0.00           0.00              0            262           4.99        5848.08       34198.78         130.53
                (&(&pool->waker)->timer):             0              0           0.00           0.00           0.00           0.00              0           2613           0.61          20.35        9812.81           3.76
                      ata_scsi_rbuf_lock:             0              0           0.00           0.00           0.00           0.00              2              2           1.94           2.51           4.45           2.23
                              &x->wait#1:             0              0           0.00           0.00           0.00           0.00             87            162           0.10          10.45         363.91           2.25
           (&(&l->destroy_dwork)->timer):             0              0           0.00           0.00           0.00           0.00              0              8           4.88           6.01          42.89           5.36
       &(&ioc->diag_trigger_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             18             32           0.20           0.77          11.14           0.35
   &(&ioc->ioc_reset_in_progress_lock)->:             0              0           0.00           0.00           0.00           0.00            214           2630           0.16           3.21        2256.52           0.86
                     &(&ds->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             44             92           0.10           0.48          17.38           0.19
                      hrtimer_bases.lock:             0              0           0.00           0.00           0.00           0.00              8        6350609           0.09          17.85     2686579.44           0.42
                     &(&ev->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             25             72           0.17           7.44         109.85           1.53
                            sd_ref_mutex:             0              0           0.00           0.00           0.00           0.00             12             36           0.36           2.30          23.87           0.66
                        jump_label_mutex:             0              0           0.00           0.00           0.00           0.00             11             22         180.09        4733.30       16215.24         737.06
                       (&watchdog_timer):             0              0           0.00           0.00           0.00           0.00              0           2634           1.92         552.65        8778.35           3.33
    "events_freezable_power_efficient"-R:             0              0           0.00           0.00           0.00           0.00              0             18          40.05       11206.04       15203.43         844.63
                   (&(&ev->dwork)->work):             0              0           0.00           0.00           0.00           0.00              0             36           0.08       11205.46       15196.87         422.14
                &(&ctx->flc_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              1              4           0.62           1.65           4.37           1.09
                      file_lock_lglock-R:             0              0           0.00           0.00           0.00           0.00              0              4           0.14           0.25           0.71           0.18
                  &(&ioc->lock)->rlock/1:             0              0           0.00           0.00           0.00           0.00             37             38           0.11           0.63          10.51           0.28
                  &(&ioc->lock)->rlock#2:             0              0           0.00           0.00           0.00           0.00              0             38           0.10           0.20           4.40           0.12
                            s_active#5-R:             0              0           0.00           0.00           0.00           0.00              0            108           0.92           3.84         179.55           1.66
      (&(&ioc->fault_reset_work)->timer):             0              0           0.00           0.00           0.00           0.00              0           1315           0.79          22.37        8447.99           6.42
      "%s"ioc->fault_reset_work_q_name-R:             0              0           0.00           0.00           0.00           0.00              0           1315           1.78        1712.56        7454.64           5.67
       (&(&ioc->fault_reset_work)->work):             0              0           0.00           0.00           0.00           0.00              0           1315           1.61        1712.19        6857.89           5.22
               &(&tty->ctrl_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              7            145           0.10           0.81          29.23           0.20
               &o_tty->termios_rwsem/1-W:             0              0           0.00           0.00           0.00           0.00              0              8           1.59           3.33          18.05           2.26
               &o_tty->termios_rwsem/1-R:             0              0           0.00           0.00           0.00           0.00           1399           6753           0.10        1828.67       26311.88           3.90
                       &port->buf.lock/1:             0              0           0.00           0.00           0.00           0.00              3            114           8.14          60.51        1371.01          12.03
                &ldata->atomic_read_lock:             0              0           0.00           0.00           0.00           0.00              2           1463           1.69    57558378.60   115708999.24       79090.23
           &(&afbdev->dirty_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           6580           0.11           1.47        1223.85           0.19
              "xfs-buf/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0             52           0.84          18.44         150.23           2.89
                     (&bp->b_ioend_work):             0              0           0.00           0.00           0.00           0.00              0             95           0.69        1068.82        3151.74          33.18
                       semaphore->lock#3:             0              0           0.00           0.00           0.00           0.00            198            578           0.10           1.67         111.70           0.19
                                   key#4:             0              0           0.00           0.00           0.00           0.00              5             14           1.07           3.08          24.42           1.74
                                   key#5:             0              0           0.00           0.00           0.00           0.00              5             14           0.48           1.11           8.95           0.64
                                   key#6:             0              0           0.00           0.00           0.00           0.00              7             17           0.40           0.94           9.94           0.58
             &(&mp->m_perag_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              6             10           0.12           0.83           4.08           0.41
                &(&ailp->xa_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           4433          53014           0.10        2777.50       41745.46           0.79
            &(&pag->pag_buf_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             27            162           0.16           3.49         134.71           0.83
             &(&ip->i_flags_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           1120           2454           0.09          49.99         694.39           0.28
            &(&pag->pag_ici_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              7             11           0.22           3.24          20.56           1.87
               &sb->s_type->i_lock_key#2:             0              0           0.00           0.00           0.00           0.00            100            334           0.10           1.63         113.95           0.34
                    &group->mark_mutex/1:             0              0           0.00           0.00           0.00           0.00              4              8           1.32           3.98          18.26           2.28
                &type->i_mutex_dir_key#3:             0              0           0.00           0.00           0.00           0.00             25            158           0.59          16.84         433.54           2.74
             &(&ip->i_iolock)->mr_lock-W:             0              0           0.00           0.00           0.00           0.00             69            758           0.95         526.14        3880.94           5.12
             &(&ip->i_iolock)->mr_lock-R:             0              0           0.00           0.00           0.00           0.00            322            690           0.12          84.62        1669.42           2.42
                  &xfs_dir_ilock_class-R:             0              0           0.00           0.00           0.00           0.00             25            125           0.29           9.63         241.06           1.93
               &xfs_nondir_ilock_class-W:             0              0           0.00           0.00           0.00           0.00            119            233           0.28       26294.73       27673.65         118.77
               &xfs_nondir_ilock_class-R:             0              0           0.00           0.00           0.00           0.00            567           1100           0.12          90.56        1163.22           1.06
                         clock-AF_INET-W:             0              0           0.00           0.00           0.00           0.00              6             11           0.15           0.57           3.23           0.29
                         clock-AF_INET-R:             0              0           0.00           0.00           0.00           0.00              0             11           0.15           0.33           2.20           0.20
   &(&pgdat->numabalancing_migrate_lock):             0              0           0.00           0.00           0.00           0.00            192            212           0.11          42.33          88.11           0.42
                          sb_writers#8-R:             0              0           0.00           0.00           0.00           0.00              0            770           1.40         529.92        4677.64           6.07
           &(&ip->i_mmaplock)->mr_lock-R:             0              0           0.00           0.00           0.00           0.00            262            374           0.30          17.01         279.23           0.75
                         pci_config_lock:             0              0           0.00           0.00           0.00           0.00              0           4374           0.89          14.67        4349.76           0.99
              &sb->s_type->i_mutex_key#1:             0              0           0.00           0.00           0.00           0.00             70            752           1.19         527.86        4174.30           5.55
                         cache_list_lock:             0              0           0.00           0.00           0.00           0.00              0             47           0.51          26.18          80.57           1.71
               (&(&cache_cleaner)->work):             0              0           0.00           0.00           0.00           0.00              0             47           1.75          28.20         184.51           3.93
              (&(&cache_cleaner)->timer):             0              0           0.00           0.00           0.00           0.00              0             47           2.76           8.47         242.76           5.17
                   &fsnotify_mark_srcu-R:             0              0           0.00           0.00           0.00           0.00              0            972           0.42          40.30        2156.32           2.22
                  &rl->wait[BLK_RW_SYNC]:             0              0           0.00           0.00           0.00           0.00           2320           2382           0.16          26.19        7255.21           3.05
                              &x->wait#4:             0              0           0.00           0.00           0.00           0.00              6             12           0.14           5.79          19.46           1.62
                        jiffies_lock#2-W:             0              0           0.00           0.00           0.00           0.00              0        1309154           0.06          21.21      323279.76           0.25
                        jiffies_lock#2-R:             0              0           0.00           0.00           0.00           0.00              0       56765885           0.05          20.11     3889885.99           0.07
                &(&p->alloc_lock)->rlock:             0              0           0.00           0.00           0.00           0.00            247           1082           0.07          19.60         335.75           0.31
                         rcu_read_lock-R:             0              0           0.00           0.00           0.00           0.00              0     2475019255           0.05       32731.72   970213391.66          0.-52
                          mem_ctls_mutex:             0              0           0.00           0.00           0.00           0.00            941           2628           0.24          89.73        1834.09           0.70
                       pvclock_gtod_data:             0              0           0.00           0.00           0.00           0.00              0        1200009           0.06          17.11      119567.23           0.10
                            s_active#8-R:             0              0           0.00           0.00           0.00           0.00              0             16           1.39           3.85          41.55           2.60
                  (&(&mci->work)->timer):             0              0           0.00           0.00           0.00           0.00              0           2628           0.74          25.77       15635.43           5.95
                     "%s""edac-poller"-R:             0              0           0.00           0.00           0.00           0.00              0           2628           1.13         278.76        8201.94           3.12
                   (&(&mci->work)->work):             0              0           0.00           0.00           0.00           0.00              0           2628           0.96         278.45        7291.97           2.77
               &(&pag->pagb_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             10            110           0.11           1.24          24.12           0.22
                 audit_backlog_wait.lock:             0              0           0.00           0.00           0.00           0.00              4             14           0.13           0.62           4.06           0.29
                             &ctx->wqh#2:             0              0           0.00           0.00           0.00           0.00             90            705           0.10           8.51         311.78           0.44
                                   key#7:             0              0           0.00           0.00           0.00           0.00              8              8           0.37           0.69           4.35           0.54
                      userns_state_mutex:             0              0           0.00           0.00           0.00           0.00              2              2           0.76           0.86           1.62           0.81
                   (sync_cmos_work).work:             0              0           0.00           0.00           0.00           0.00              0              4           2.42        3234.63        3274.97         818.74
                         sk_lock-AF_INET:             0              0           0.00           0.00           0.00           0.00              0           3388           0.10       47755.27      364436.89         107.57
          &(&table->hash[i].lock)->rlock:             0              0           0.00           0.00           0.00           0.00             17             33           0.45           2.96          52.29           1.58
         &(&table->hash2[i].lock)->rlock:             0              0           0.00           0.00           0.00           0.00             26             44           0.10           0.55          12.78           0.29
 &(&net->ipv4.ip_local_ports.lock)->se-R:             0              0           0.00           0.00           0.00           0.00              0             11           0.15           0.19           1.81           0.16
                            s_active#9-R:             0              0           0.00           0.00           0.00           0.00              0              8           1.10           3.27          17.73           2.22
                            s_active#9-R:             0              0           0.00           0.00           0.00           0.00              0              4           1.32           1.82           6.37           1.59
                            s_active#9-R:             0              0           0.00           0.00           0.00           0.00              0              8           1.04           1.83          12.19           1.52
              nonblocking_pool.push_work:             0              0           0.00           0.00           0.00           0.00              0            132           2.96        5473.00       12317.00          93.31
             "xfs-data/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0             45           3.22       26304.80       26797.68         595.50
                       (&ioend->io_work):             0              0           0.00           0.00           0.00           0.00              0             45           3.05       26304.20       26777.86         595.06
                    (&cil->xc_push_work):             0              0           0.00           0.00           0.00           0.00              0            260           0.05          20.47         462.25           1.78
            &(&cil->xc_push_lock)->rlock:             0              0           0.00           0.00           0.00           0.00            118            780           0.10         172.43         555.35           0.71
              "xfs-cil/%s"mp->m_fsname-W:             0              0           0.00           0.00           0.00           0.00              0             43           0.07           0.26           4.64           0.11
              "xfs-cil/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0             86           2.57          20.82         614.98           7.15
             &(&log->l_icloglock)->rlock:             0              0           0.00           0.00           0.00           0.00            118            735           0.10          61.78         603.70           0.82
      &(&iclog->ic_callback_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             86            129           0.14         136.13         180.63           1.40
                    &cil->xc_commit_wait:             0              0           0.00           0.00           0.00           0.00              0             43           0.13           0.83          10.26           0.24
                   &iclog->ic_force_wait:             0              0           0.00           0.00           0.00           0.00             26             43           0.13           0.80          12.89           0.30
              "xfs-log/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0            174           3.83        1069.37        6305.05          36.24
                   &iclog->ic_write_wait:             0              0           0.00           0.00           0.00           0.00             26             43           0.25           0.83          19.13           0.44
                          &bp->b_waiters:             0              0           0.00           0.00           0.00           0.00             23             32           0.22           0.79          11.30           0.35
                      &log->l_flush_wait:             0              0           0.00           0.00           0.00           0.00             16             43           0.12           1.94          12.15           0.28
               (&adapter->watchdog_task):             0              0           0.00           0.00           0.00           0.00              0           1316         246.63       20797.21      593960.94         451.34
                  (&(&wb->dwork)->timer):             0              0           0.00           0.00           0.00           0.00              0            201           2.89          10.57        1138.00           5.66
                           "writeback"-R:             0              0           0.00           0.00           0.00           0.00              0            201           5.09         909.80        5101.70          25.38
                   (&(&wb->dwork)->work):             0              0           0.00           0.00           0.00           0.00              0            201           4.70         909.19        5025.30          25.00
                          &p->sequence-W:             0              0           0.00           0.00           0.00           0.00              0             45           0.10           0.36           8.37           0.19
                          &p->sequence-R:             0              0           0.00           0.00           0.00           0.00              0            201           0.07           0.28          21.72           0.11
                                   key#8:             0              0           0.00           0.00           0.00           0.00             24             40           1.31           3.49          75.72           1.89
                 &(&bp->spq_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           1313           0.24          13.31         667.16           0.51
                           "%s""bnx2x"-R:             0              0           0.00           0.00           0.00           0.00              0           6569           0.69       16107.80     1216525.86         185.19
                 (&(&bp->sp_task)->work):             0              0           0.00           0.00           0.00           0.00              0           1313           0.52         478.81        3386.86           2.58
             (&(&bp->period_task)->work):             0              0           0.00           0.00           0.00           0.00              0           5256         149.76       16107.22     1201420.82         228.58
          &(&dev->tx_global_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            263          40.85         106.79       15305.17          58.19
                           _xmit_ETHER#2:             0              0           0.00           0.00           0.00           0.00           1998          26564           0.11         271.85        8433.22           0.32
                 &(&list->lock)->rlock#5:             0              0           0.00           0.00           0.00           0.00            912          29195           0.06         203.82        5481.03           0.19
            ((&adapter->watchdog_timer)):             0              0           0.00           0.00           0.00           0.00              0           1316           0.87         281.18        6634.70           5.04
            (&(&bp->period_task)->timer):             0              0           0.00           0.00           0.00           0.00              0           5256           0.55          23.69       26782.53           5.10
                            (&bp->timer):             0              0           0.00           0.00           0.00           0.00              0           5255           2.13          30.52       30122.91           5.73
                       semaphore->lock#4:             0              0           0.00           0.00           0.00           0.00              0          10510           0.10           3.68        1653.90           0.16
                            s_active#1-R:             0              0           0.00           0.00           0.00           0.00              0              6           1.97           3.54          16.67           2.78
             &(&bond->stats_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              2              8           0.51           1.73           6.57           0.82
              (&(&bond->mii_work)->work):             0              0           0.00           0.00           0.00           0.00              0          13153           0.35        2486.04       22556.04           1.71
               (&(&bond->ad_work)->work):             0              0           0.00           0.00           0.00           0.00              0          13151           0.90        7019.99      145141.15          11.04
              &(&bond->mode_lock)->rlock:             0              0           0.00           0.00           0.00           0.00           1187          13151           0.42         586.22       14703.60           1.12
                    "%s"bond_dev->name-R:             0              0           0.00           0.00           0.00           0.00              0          26304           0.51        7103.46      182110.89           6.92
                              &n->lock-W:             0              0           0.00           0.00           0.00           0.00             41            208           0.40           5.72         365.40           1.76
                              &n->lock-R:             0              0           0.00           0.00           0.00           0.00              0              2           0.54           1.70           2.24           1.12
              &(&n->ha_lock)->seqcount-R:             0              0           0.00           0.00           0.00           0.00              0             36           0.06           0.24           3.79           0.11
              (&(&bond->ad_work)->timer):             0              0           0.00           0.00           0.00           0.00              0          13151           0.54          33.02       53029.33           4.03
             (&(&bond->mii_work)->timer):             0              0           0.00           0.00           0.00           0.00              0          13153           0.54          27.23       52880.80           4.02
           &(&n->hh.hh_lock)->seqcount-R:             0              0           0.00           0.00           0.00           0.00              0           2564           0.06           0.45         244.88           0.10
                    &(&grp->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            381            527           0.15           2.51         545.54           1.04
                   &(&pcpu->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            188           0.10          21.91          70.97           0.38
               (&(&tbl->gc_work)->timer):             0              0           0.00           0.00           0.00           0.00              0            175           2.27          13.03         823.96           4.71
                (&(&tbl->gc_work)->work):             0              0           0.00           0.00           0.00           0.00              0            175           1.06        3626.09        6331.38          36.18
                   &net->ct.generation-R:             0              0           0.00           0.00           0.00           0.00              0             22           0.08           0.30           3.29           0.15
        &(&nf_conntrack_locks[i])->rlock:             0              0           0.00           0.00           0.00           0.00             19             22           0.56           9.88          61.05           2.78
      &(&nf_conntrack_locks[i])->rlock/1:             0              0           0.00           0.00           0.00           0.00             18             22           0.11           9.03          24.04           1.09
                     &(&ct->lock)->rlock:             0              0           0.00           0.00           0.00           0.00           3445           4701           0.19         328.27        5880.71           1.25
                (&(&log->l_work)->timer):             0              0           0.00           0.00           0.00           0.00              0            131           2.62           9.72         646.50           4.94
                 (&(&log->l_work)->work):             0              0           0.00           0.00           0.00           0.00              0            131           3.49         145.30        3215.29          24.54
                   (&sdev->requeue_work):             0              0           0.00           0.00           0.00           0.00              0              8           0.40          11.61          30.06           3.76
                ((&dev->watchdog_timer)):             0              0           0.00           0.00           0.00           0.00              0            263          41.15         107.48       15402.86          58.57
                   kernel/time/ntp.c:507:             0              0           0.00           0.00           0.00           0.00              0              4           4.32           8.13          22.06           5.52
                      lib/random32.c:217:             0              0           0.00           0.00           0.00           0.00              0             22          11.13         287.75         712.92          32.41
                        ((&ct->timeout)):             0              0           0.00           0.00           0.00           0.00              0             11          10.49          25.95         195.61          17.78
                           ((&n->timer)):             0              0           0.00           0.00           0.00           0.00              0            172           1.13          11.92         443.87           2.58
                &(&tbl->locks[i])->rlock:             0              0           0.00           0.00           0.00           0.00             10             40           0.13           1.15          14.00           0.35
              &(&stopper->lock)->rlock/1:             0              0           0.00           0.00           0.00           0.00             12             15           4.12           6.44          76.73           5.12
                           &p->pi_lock/1:             0              0           0.00           0.00           0.00           0.00             10             15           0.11           9.90          78.34           5.22
                             &rq->lock/1:             0              0           0.00           0.00           0.00           0.00              6             15           0.13           9.46          50.13           3.34
                         slock-AF_INET/1:             0              0           0.00           0.00           0.00           0.00           1698           2114           0.23        1762.80       29503.70          13.96
        &(&conn->conn_usage_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           1050           0.10          24.69         301.03           0.29
    &(&conn->response_queue_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           3630           0.09         232.79         846.94           0.23
                        &conn->queues_wq:             0              0           0.00           0.00           0.00           0.00              0           4511           0.10          18.02        4870.24           1.08
       &(&conn->nopin_timer_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           3150           0.09         331.48        3639.56           1.16
            ((&icsk->icsk_delack_timer)):             0              0           0.00           0.00           0.00           0.00              0            654           0.30          56.91        1596.94           2.44
        ((&icsk->icsk_retransmit_timer)):             0              0           0.00           0.00           0.00           0.00              0           1792           0.35        2544.71        5016.06           2.80
                      sk_lock-AF_NETLINK:             0              0           0.00           0.00           0.00           0.00              0             24           0.18           2.14          26.43           1.10
                             pidmap_lock:             0              0           0.00           0.00           0.00           0.00            108            227           0.11           2.90          93.18           0.41
   &(&({ do { const void *__vpp_verify =:             0              0           0.00           0.00           0.00           0.00              0           1216           0.10           1.46         263.85           0.22
               &(&conn->cmd_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0           1741           0.10         159.22         774.31           0.44
             &(&cmd->istate_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            830           0.09         132.79         385.38           0.46
                        slock-AF_NETLINK:             0              0           0.00           0.00           0.00           0.00              0             48           0.10           0.38           8.88           0.18
                &(&dio->bio_lock)->rlock:             0              0           0.00           0.00           0.00           0.00       55247068      459318522           0.09          30.16    62567561.23           0.14
                &(&wb->work_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             73            402           0.15           2.68         290.44           0.72
                     &(&br->lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            657           0.57           4.44         958.49           1.46
             &(&cil->xc_cil_lock)->rlock:             0              0           0.00           0.00           0.00           0.00            115            203           0.13           1.41          92.23           0.45
                     &cil->xc_ctx_lock-W:             0              0           0.00           0.00           0.00           0.00             40             43           0.89           3.60          61.00           1.42
                     &cil->xc_ctx_lock-R:             0              0           0.00           0.00           0.00           0.00            121            203           0.14          10.28         182.79           0.90
                                   key#1:             0              0           0.00           0.00           0.00           0.00              2              2           1.42           1.43           2.85           1.43
                      ((&fc->rnd_timer)):             0              0           0.00           0.00           0.00           0.00              0              2           4.60           5.66          10.27           5.13
                             nf_nat_lock:             0              0           0.00           0.00           0.00           0.00             18             22           0.30          50.87          63.49           2.89
                    ((&br->hello_timer)):             0              0           0.00           0.00           0.00           0.00              0            657           0.87           5.77        1210.97           1.84
                    (&conn->nopin_timer):             0              0           0.00           0.00           0.00           0.00              0            525           8.09        1976.43       14995.37          28.56
               &(&sess->ttt_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            579           0.10          12.47         198.22           0.34
           (&conn->nopin_response_timer):             0              0           0.00           0.00           0.00           0.00              0            525           0.05           0.28          35.94           0.07
                 net/ipv6/addrconf.c:150:             0              0           0.00           0.00           0.00           0.00              0             10           2.26           8.33          51.80           5.18
             &(&cmd->datain_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            161           0.10           2.15          32.46           0.20
       &(&se_sess->sess_cmd_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            107           0.13           1.26          45.67           0.43
                      &sess->cmdsn_mutex:             0              0           0.00           0.00           0.00           0.00              0             54           6.12        1596.30        2345.69          43.44
       &(&dev->execute_task_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             27            108           0.11           0.64          25.69           0.24
            &(&cmd->t_state_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              0            215           0.10           1.49          66.33           0.31
                   "target_completion"-R:             0              0           0.00           0.00           0.00           0.00              0             54           3.67         343.07         742.08          13.74
                            (&cmd->work):             0              0           0.00           0.00           0.00           0.00              0             54           3.45         342.79         721.64          13.36
        &(&dev->delayed_cmd_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             27             54           0.11           0.55          12.71           0.24
       &(&lun->lun_tg_pt_gp_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             24             27           0.15           0.91           8.61           0.32
                  net/ipv4/devinet.c:438:             0              0           0.00           0.00           0.00           0.00              0             11           3.22           8.98          47.76           4.34
                                   ((t)):             0              0           0.00           0.00           0.00           0.00              0             96           2.44          13.63         335.82           3.50
                     (&pool->idle_timer):             0              0           0.00           0.00           0.00           0.00              0              8           1.14           8.29          44.76           5.60
       (&(&mp->m_eofblocks_work)->timer):             0              0           0.00           0.00           0.00           0.00              0              5           4.23           8.46          28.07           5.61
        "xfs-eofblocks/%s"mp->m_fsname-R:             0              0           0.00           0.00           0.00           0.00              0              5          12.28         170.79         439.65          87.93
        (&(&mp->m_eofblocks_work)->work):             0              0           0.00           0.00           0.00           0.00              0              5          11.51         169.95         436.15          87.23
                &sb->s_type->i_mutex_key:             0              0           0.00           0.00           0.00           0.00             81          18333           0.76        6889.83      211411.25          11.53
                           sb_internal-R:             0              0           0.00           0.00           0.00           0.00              0            236           0.32       26297.27       28653.75         121.41
                         ((&q->timeout)):             0              0           0.00           0.00           0.00           0.00              0           1521           0.29         367.21        3988.73           2.62
                                   key#1:             0              0           0.00           0.00           0.00           0.00              2              2           1.28           1.37           2.65           1.33
                                   key#1:             0              0           0.00           0.00           0.00           0.00              2              2           0.69           0.93           1.62           0.81
                     &type->lock_class/1:             0              0           0.00           0.00           0.00           0.00              0              2           3.43           3.57           7.00           3.50
                             key_gc_work:             0              0           0.00           0.00           0.00           0.00              0              6           1.01       51023.47       60018.11       10003.02
                   security/keys/gc.c:33:             0              0           0.00           0.00           0.00           0.00              0              2           4.04           4.83           8.87           4.44
                  &(&mddev->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            192            265           0.17           2.58         112.84           0.43
                   dm_bufio_clients_lock:             0              0           0.00           0.00           0.00           0.00             15             44           1.43          34.47         221.37           5.03
                            _hash_lock-R:             0              0           0.00           0.00           0.00           0.00            192            262           0.83        1473.55        2013.50           7.69
                             _minor_lock:             0              0           0.00           0.00           0.00           0.00             72            144           0.12           1.16          46.78           0.32
                     dm_hash_cells_mutex:             0              0           0.00           0.00           0.00           0.00             12             32           0.26           1.37          19.18           0.60
                       &md->io_barrier-R:             0              0           0.00           0.00           0.00           0.00              0      153107433           0.15       27665.62  1209748277.57           7.90
                    &(&new->lock)->rlock:             0              0           0.00           0.00           0.00           0.00            126            204           0.11           8.90          98.81           0.48
                               &md->wait:             0              0           0.00           0.00           0.00           0.00            286            925           0.10           1.69         174.06           0.19
                            s_active#2-R:             0              0           0.00           0.00           0.00           0.00              0             16           1.73           4.75          43.66           2.73
                            s_active#2-R:             0              0           0.00           0.00           0.00           0.00              0             48           0.95           4.36          92.79           1.93
                            s_active#2-R:             0              0           0.00           0.00           0.00           0.00              0             16           0.88           2.49          22.84           1.43
                             &md->eventq:             0              0           0.00           0.00           0.00           0.00            192            262           0.15           1.16          65.05           0.25
                    &c->free_buffer_wait:             0              0           0.00           0.00           0.00           0.00       13336454       32585352           0.10          16.34     5361217.39           0.16
                &(&mp->m_sb_lock)->rlock:             0              0           0.00           0.00           0.00           0.00              5             14           0.16           0.87           4.76           0.34
                 &type->s_umount_key#3-R:             0              0           0.00           0.00           0.00           0.00              0             36          18.96         233.18        1583.20          43.98
                     &(&tm->lock)->rlock:             0              0           0.00           0.00           0.00           0.00             54            131           0.51          51.50         192.48           1.47
                                  "md"-R:             0              0           0.00           0.00           0.00           0.00              0            524           5.20       17543.55      134698.61         257.06
                    (&mddev->flush_work):             0              0           0.00           0.00           0.00           0.00              0            262          32.99       17543.21       97714.77         372.96
                              &x->wait#2:             0              0           0.00           0.00           0.00           0.00            496            786           0.13          19.56        1496.87           1.90
                         &mddev->sb_wait:             0              0           0.00           0.00           0.00           0.00            210            271           0.16           5.18          99.92           0.37
                      nl_table_wait.lock:             0              0           0.00           0.00           0.00           0.00             18             58           0.10           0.54          12.64           0.22
                          &f->f_pos_lock:             0              0           0.00           0.00           0.00           0.00             67            776           1.80         559.42        5113.91           6.59
                          "dm-" "thin"-R:             0              0           0.00           0.00           0.00           0.00              0          39570           0.93       20171.82   599814832.28       15158.32
                         (&pool->worker):             0              0           0.00           0.00           0.00           0.00              0          36957           2.26       20171.47   599770442.99       16228.87
               (&(&q->delay_work)->work):             0              0           0.00           0.00           0.00           0.00              0            119           0.33         188.90         308.90           2.60
                 (&(&pool->waker)->work):             0              0           0.00           0.00           0.00           0.00              0           2613           0.62        9427.32       31790.72          12.17
              (&(&dm_bufio_work)->timer):             0              0           0.00           0.00           0.00           0.00              0             44           3.03          10.86         282.40           6.42
                  "%s""dm_bufio_cache"-R:             0              0           0.00           0.00           0.00           0.00              0             44           2.90          36.20         321.90           7.32
               (&(&dm_bufio_work)->work):             0              0           0.00           0.00           0.00           0.00              0             44           2.64          35.94         300.76           6.84
                            s_active#3-R:             0              0           0.00           0.00           0.00           0.00              0             64           1.29          53.04         343.05           5.36
                         &ctx->ring_lock:             0              0           0.00           0.00           0.00           0.00        2672195      187574010           0.14       18836.84    88015231.18           0.47
                             "kblockd"-R:             0              0           0.00           0.00           0.00           0.00              0            127           0.65         189.81         498.75           3.93
               &(&mm->ioctx_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             61             96           0.13           0.79          35.36           0.37
                                   key#1:             0              0           0.00           0.00           0.00           0.00           3277           3277           0.12           2.09        1107.18           0.34
                         &sk->sk_lock.wq:             0              0           0.00           0.00           0.00           0.00              0              4           0.24           3.91           7.50           1.88
                         nl_table_lock-W:             0              0           0.00           0.00           0.00           0.00              0             20           0.14           0.63           4.97           0.25
                         nl_table_lock-R:             0              0           0.00           0.00           0.00           0.00             18             38           0.13           0.66          12.07           0.32
                              &x->wait#2:             0              0           0.00           0.00           0.00           0.00             52             96           0.12           9.04         179.04           1.87
                &(&ctx->ctx_lock)->rlock:             0              0           0.00           0.00           0.00           0.00             30             32           0.12           0.61           9.39           0.29
                       (&ctx->free_work):             0              0           0.00           0.00           0.00           0.00              0             32           6.90          20.18         421.87          13.18
               &sb->s_type->i_lock_key#4:             0              0           0.00           0.00           0.00           0.00             86         134896           0.08        1250.66       69782.91           0.52
                              &t->lock-R:             0              0           0.00           0.00           0.00           0.00       16343051       17645375           0.32          51.89    15448708.38           0.88
                         input_pool.lock:             0              0           0.00           0.00           0.00           0.00            189        1619553           0.20          13.72      721140.62           0.45

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--PNTmBPCT7hxwcZjr--
