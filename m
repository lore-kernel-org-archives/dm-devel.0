From: Jouni Karvo <Jouni.Karvo@iki.fi>
Subject: General protection fault with ext4 - LVM - raid456 (Raid
	6)
Date: Tue, 23 Jun 2015 12:37:23 +0300
Message-ID: <558928D3.3020906@iki.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

I have 5 sata disks running as raid6, on which lvm, on which server partitions and home partition.  Root partition is on separate raid1

 From boot it takes from two hours to a couple of days until the whole machine crashes.  This is the kern.log excerpt from the last crash this evening.
After crash, when rebooting, it is always /dev/mapper/xpcvg-home that needs repair, even when there is activity on other partitions.

I am running 4.1 at the moment.  The machine has crashed once since upgrade, but with -rc8 I got kern.log excerpts.  For the last crash, I did not get the log.  I can post the log excerpts for 4.1 as soon as one crash happens where the machine is able to log before totally hanging.

Here log exceprts for -rc8:

Linux xpc 4.1.0-rc8 #2 SMP Sun Jun 21 11:16:21 EEST 2015 x86_64 x86_64 x86_64 GNU/Linux

Jun 22 20:55:34 xpc kernel: [26361.124389] general protection fault: 0000 [#1] SMP
Jun 22 20:55:34 xpc kernel: [26361.124408] Modules linked in: usblp binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi intel_rapl iosf_mbi x86_pkg_temp_thermal cx23885 intel_powerclamp kvm_intel altera_ci tda18271 altera_stapl kvm videobuf2_dvb tveeprom cx2341x snd_hda_intel dvb_core snd_hda_controller hid_logitech_hidpp rc_core i915 videobuf2_dma_sg crct10dif_pclmul snd_hda_codec videobuf2_memops crc32_pclmul videobuf2_core ghash_clmulni_intel snd_hda_core v4l2_common snd_hwdep aesni_intel videodev snd_seq_midi aes_x86_64 snd_seq_midi_event lrw media gf128mul snd_rawmidi snd_pcm glue_helper snd_seq ablk_helper drm_kms_helper cryptd snd_seq_device serio_raw snd_timer drm snd m
 ei_me i2c_algo_bit soundcore mei lpc_ich shpchp mac_hid video wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc nct6775 hwmon_vid coretemp parport_pc ppdev lp parport autofs4 raid10 raid456 a!
 sync_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 hid_logitech_dj raid0 e1000e usbhid ahci multipath ptp hid libahci psmouse pps_core linear
Jun 22 20:55:34 xpc kernel: [26361.124689] CPU: 6 PID: 797 Comm: jbd2/dm-1-8 Not tainted 4.1.0-rc8 #2
Jun 22 20:55:34 xpc kernel: [26361.124702] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 20:55:34 xpc kernel: [26361.124718] task: ffff8801b66e2840 ti: ffff8801b60a8000 task.ti: ffff8801b60a8000
Jun 22 20:55:34 xpc kernel: [26361.124732] RIP: 0010:[<ffffffffc0181490>]  [<ffffffffc0181490>] __find_stripe+0x30/0xc0 [raid456]
Jun 22 20:55:34 xpc kernel: [26361.124754] RSP: 0018:ffff8801b60ab988  EFLAGS: 00010002
Jun 22 20:55:34 xpc kernel: [26361.124765] RAX: 0001880035c19000 RBX: 0000000000000000 RCX: 0000000000000000
Jun 22 20:55:34 xpc kernel: [26361.124779] RDX: 0000000000000b98 RSI: 000000000248cb98 RDI: ffff880035c07400
Jun 22 20:55:34 xpc kernel: [26361.124793] RBP: ffff8801b60ab9a8 R08: 0000000000000000 R09: 0000000000000000
Jun 22 20:55:34 xpc kernel: [26361.124807] R10: 0000000000000398 R11: 0000000000000003 R12: 000000000248cb98
Jun 22 20:55:34 xpc kernel: [26361.124820] R13: ffff880035c07400 R14: ffff880035c07414 R15: ffff880035c07400
Jun 22 20:55:34 xpc kernel: [26361.124834] FS:  0000000000000000(0000) GS:ffff8801bfb80000(0000) knlGS:0000000000000000
Jun 22 20:55:34 xpc kernel: [26361.124849] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 20:55:34 xpc kernel: [26361.124860] CR2: 0000000000708470 CR3: 0000000001c0d000 CR4: 00000000001407e0
Jun 22 20:55:34 xpc kernel: [26361.124874] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 20:55:34 xpc kernel: [26361.124887] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 20:55:34 xpc kernel: [26361.124900] Stack:
Jun 22 20:55:34 xpc kernel: [26361.125844]  0000000000000000 0000000000000000 0000000000000003 ffff88019d63cb20
Jun 22 20:55:34 xpc kernel: [26361.126788]  ffff8801b60aba78 ffffffffc018836d ffff8801b8253250 0000000000000246
Jun 22 20:55:34 xpc kernel: [26361.127752]  ffff8801b60aba30 ffff880035c0740c ffff8801b60aba30 0000000000000003
Jun 22 20:55:34 xpc kernel: [26361.128699] Call Trace:
Jun 22 20:55:34 xpc kernel: [26361.129636]  [<ffffffffc018836d>] get_active_stripe+0x12d/0x7e0 [raid456]
Jun 22 20:55:34 xpc kernel: [26361.130576]  [<ffffffff810bc097>] ? prepare_to_wait+0x57/0x90
Jun 22 20:55:34 xpc kernel: [26361.131534]  [<ffffffffc018e00d>] make_request+0x19d/0xda0 [raid456]
Jun 22 20:55:34 xpc kernel: [26361.132479]  [<ffffffff8165e6cb>] ? __split_and_process_bio+0x2fb/0x3f0
Jun 22 20:55:34 xpc kernel: [26361.133410]  [<ffffffff810bc3b0>] ? wait_woken+0x90/0x90
Jun 22 20:55:34 xpc kernel: [26361.134332]  [<ffffffff8164bbfc>] md_make_request+0xdc/0x220
Jun 22 20:55:34 xpc kernel: [26361.135254]  [<ffffffff8165e83a>] ? dm_make_request+0x7a/0xd0
Jun 22 20:55:34 xpc kernel: [26361.136174]  [<ffffffff81386580>] generic_make_request+0xc0/0x110
Jun 22 20:55:34 xpc kernel: [26361.137073]  [<ffffffff81386648>] submit_bio+0x78/0x180
Jun 22 20:55:34 xpc kernel: [26361.137965]  [<ffffffff812df62b>] ? jbd2_journal_write_metadata_buffer+0x2cb/0x390
Jun 22 20:55:34 xpc kernel: [26361.138857]  [<ffffffff81233d3c>] _submit_bh+0x11c/0x190
Jun 22 20:55:34 xpc kernel: [26361.139748]  [<ffffffff81233dc0>] submit_bh+0x10/0x20
Jun 22 20:55:34 xpc kernel: [26361.140621]  [<ffffffff812d7481>] jbd2_journal_commit_transaction+0x7e1/0x1820
Jun 22 20:55:34 xpc kernel: [26361.141504]  [<ffffffff8101ddd9>] ? sched_clock+0x9/0x10
Jun 22 20:55:34 xpc kernel: [26361.142381]  [<ffffffff810e50ef>] ? try_to_del_timer_sync+0x4f/0x70
Jun 22 20:55:34 xpc kernel: [26361.143249]  [<ffffffff812dbe4b>] kjournald2+0xbb/0x250
Jun 22 20:55:34 xpc kernel: [26361.144110]  [<ffffffff810bc3b0>] ? wait_woken+0x90/0x90
Jun 22 20:55:34 xpc kernel: [26361.144957]  [<ffffffff812dbd90>] ? commit_timeout+0x10/0x10
Jun 22 20:55:34 xpc kernel: [26361.145799]  [<ffffffff81098c49>] kthread+0xc9/0xe0
Jun 22 20:55:34 xpc kernel: [26361.146634]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 20:55:34 xpc kernel: [26361.147470]  [<ffffffff817e2de2>] ret_from_fork+0x42/0x70
Jun 22 20:55:34 xpc kernel: [26361.148283]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 20:55:34 xpc kernel: [26361.149094] Code: 55 48 89 e5 41 55 41 54 53 49 89 fd 49 89 f4 89 d3 48 83 ec 08 f6 05 39 1b 01 00 04 75 5e 49 8b 45 00 4c 89 e2 81 e2 f8 0f 00 00 <48> 8b 04 02 48 85 c0 75 2d 31 db f6 05 f0 1a 01 00 04 75 57 48
Jun 22 20:55:34 xpc kernel: [26361.149989] RIP  [<ffffffffc0181490>] __find_stripe+0x30/0xc0 [raid456]
Jun 22 20:55:34 xpc kernel: [26361.150833]  RSP <ffff8801b60ab988>
Jun 22 20:55:34 xpc kernel: [26361.156521] ---[ end trace c430f52499aa3b3a ]---
Jun 22 20:55:36 xpc kernel: [26363.223855] general protection fault: 0000 [#2] SMP
Jun 22 20:55:36 xpc kernel: [26363.225306] Modules linked in: usblp binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi intel_rapl iosf_mbi x86_pkg_temp_thermal cx23885 intel_powerclamp kvm_intel altera_ci tda18271 altera_stapl kvm videobuf2_dvb tveeprom cx2341x snd_hda_intel dvb_core snd_hda_controller hid_logitech_hidpp rc_core i915 videobuf2_dma_sg crct10dif_pclmul snd_hda_codec videobuf2_memops crc32_pclmul videobuf2_core ghash_clmulni_intel snd_hda_core v4l2_common snd_hwdep aesni_intel videodev snd_seq_midi aes_x86_64 snd_seq_midi_event lrw media gf128mul snd_rawmidi snd_pcm glue_helper snd_seq ablk_helper drm_kms_helper cryptd snd_seq_device serio_raw snd_timer drm snd m
 ei_me i2c_algo_bit soundcore mei lpc_ich shpchp mac_hid video wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc nct6775 hwmon_vid coretemp parport_pc ppdev lp parport autofs4 raid10 raid456 a!
 sync_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 hid_logitech_dj raid0 e1000e usbhid ahci multipath ptp hid libahci psmouse pps_core linear
Jun 22 20:55:36 xpc kernel: [26363.233599] CPU: 5 PID: 22633 Comm: kworker/u16:1 Tainted: G      D         4.1.0-rc8 #2
Jun 22 20:55:36 xpc kernel: [26363.235288] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 20:55:36 xpc kernel: [26363.236982] Workqueue: writeback bdi_writeback_workfn (flush-252:1)
Jun 22 20:55:36 xpc kernel: [26363.238665] task: ffff880020984670 ti: ffff880071bfc000 task.ti: ffff880071bfc000
Jun 22 20:55:36 xpc kernel: [26363.240340] RIP: 0010:[<ffffffffc0181490>]  [<ffffffffc0181490>] __find_stripe+0x30/0xc0 [raid456]
Jun 22 20:55:36 xpc kernel: [26363.242027] RSP: 0018:ffff880071bff578  EFLAGS: 00010002
Jun 22 20:55:36 xpc kernel: [26363.243693] RAX: 0001880035c19000 RBX: 0000000000000000 RCX: 0000000000000000
Jun 22 20:55:36 xpc kernel: [26363.245370] RDX: 0000000000000368 RSI: 000000005047f368 RDI: ffff880035c07400
Jun 22 20:55:36 xpc kernel: [26363.247046] RBP: ffff880071bff598 R08: 0000000000000000 R09: 0000000000000000
Jun 22 20:55:36 xpc kernel: [26363.248704] R10: 0000000000000368 R11: 0000000000000000 R12: 000000005047f368
Jun 22 20:55:36 xpc kernel: [26363.250343] R13: ffff880035c07400 R14: ffff880035c0741c R15: ffff880035c07400
Jun 22 20:55:36 xpc kernel: [26363.251937] FS:  0000000000000000(0000) GS:ffff8801bfb40000(0000) knlGS:0000000000000000
Jun 22 20:55:36 xpc kernel: [26363.253493] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 20:55:36 xpc kernel: [26363.254996] CR2: 00007f25ff0651a0 CR3: 0000000001c0d000 CR4: 00000000001407e0
Jun 22 20:55:36 xpc kernel: [26363.256456] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 20:55:36 xpc kernel: [26363.257861] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 20:55:36 xpc kernel: [26363.259226] Stack:
Jun 22 20:55:36 xpc kernel: [26363.260574]  ffff8801bfa94e40 0000000000000000 0000000000000005 ffff88011a296620
Jun 22 20:55:36 xpc kernel: [26363.261945]  ffff880071bff668 ffffffffc018836d 000000005047e3f8 ffff88011a296620
Jun 22 20:55:36 xpc kernel: [26363.263303]  00000000ffffffff ffff880035c07414 000000000000ffff 0000000000000005
Jun 22 20:55:36 xpc kernel: [26363.264653] Call Trace:
Jun 22 20:55:36 xpc kernel: [26363.265994]  [<ffffffffc018836d>] get_active_stripe+0x12d/0x7e0 [raid456]
Jun 22 20:55:36 xpc kernel: [26363.267351]  [<ffffffff81186600>] ? mempool_alloc+0x20/0x150
Jun 22 20:55:36 xpc kernel: [26363.268706]  [<ffffffff810bc097>] ? prepare_to_wait+0x57/0x90
Jun 22 20:55:36 xpc kernel: [26363.270064]  [<ffffffffc018e00d>] make_request+0x19d/0xda0 [raid456]
Jun 22 20:55:36 xpc kernel: [26363.271420]  [<ffffffff8165e6cb>] ? __split_and_process_bio+0x2fb/0x3f0
Jun 22 20:55:36 xpc kernel: [26363.272770]  [<ffffffff810bc3b0>] ? wait_woken+0x90/0x90
Jun 22 20:55:36 xpc kernel: [26363.274111]  [<ffffffff8164bbfc>] md_make_request+0xdc/0x220
Jun 22 20:55:36 xpc kernel: [26363.275446]  [<ffffffff8165e83a>] ? dm_make_request+0x7a/0xd0
Jun 22 20:55:36 xpc kernel: [26363.276784]  [<ffffffff81386580>] generic_make_request+0xc0/0x110
Jun 22 20:55:36 xpc kernel: [26363.278132]  [<ffffffff81386648>] submit_bio+0x78/0x180
Jun 22 20:55:36 xpc kernel: [26363.279469]  [<ffffffff8118ed32>] ? __test_set_page_writeback+0x132/0x1b0
Jun 22 20:55:36 xpc kernel: [26363.280805]  [<ffffffff8128dd19>] ext4_io_submit+0x29/0x60
Jun 22 20:55:36 xpc kernel: [26363.282131]  [<ffffffff8128dee8>] ext4_bio_write_page+0x168/0x410
Jun 22 20:55:36 xpc kernel: [26363.283460]  [<ffffffff811be580>] ? page_referenced_one+0x190/0x190
Jun 22 20:55:36 xpc kernel: [26363.284783]  [<ffffffff81284c71>] mpage_submit_page+0x61/0x90
Jun 22 20:55:36 xpc kernel: [26363.286097]  [<ffffffff81284db0>] mpage_process_page_bufs+0x110/0x120
Jun 22 20:55:36 xpc kernel: [26363.287409]  [<ffffffff81285f8d>] mpage_prepare_extent_to_map+0x1dd/0x2d0
Jun 22 20:55:36 xpc kernel: [26363.288722]  [<ffffffff8128a03c>] ext4_writepages+0x38c/0xca0
Jun 22 20:55:36 xpc kernel: [26363.290031]  [<ffffffff813b94e4>] ? cpumask_next_and+0x44/0x50
Jun 22 20:55:36 xpc kernel: [26363.291339]  [<ffffffff811910fe>] do_writepages+0x1e/0x30
Jun 22 20:55:36 xpc kernel: [26363.292646]  [<ffffffff8122a755>] __writeback_single_inode+0x45/0x2c0
Jun 22 20:55:36 xpc kernel: [26363.293958]  [<ffffffff8122ac2d>] writeback_sb_inodes+0x25d/0x450
Jun 22 20:55:36 xpc kernel: [26363.295268]  [<ffffffff8122aebf>] __writeback_inodes_wb+0x9f/0xd0
Jun 22 20:55:36 xpc kernel: [26363.296578]  [<ffffffff8122b113>] wb_writeback+0x223/0x2c0
Jun 22 20:55:36 xpc kernel: [26363.297883]  [<ffffffff81218541>] ? get_nr_inodes+0x51/0x80
Jun 22 20:55:36 xpc kernel: [26363.299181]  [<ffffffff8122b78c>] bdi_writeback_workfn+0x1cc/0x440
Jun 22 20:55:36 xpc kernel: [26363.300485]  [<ffffffff81092bf8>] process_one_work+0x158/0x440
Jun 22 20:55:36 xpc kernel: [26363.301785]  [<ffffffff8109375b>] worker_thread+0x5b/0x540
Jun 22 20:55:36 xpc kernel: [26363.303078]  [<ffffffff81093700>] ? rescuer_thread+0x3a0/0x3a0
Jun 22 20:55:36 xpc kernel: [26363.304369]  [<ffffffff81098c49>] kthread+0xc9/0xe0
Jun 22 20:55:36 xpc kernel: [26363.305655]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 20:55:36 xpc kernel: [26363.306950]  [<ffffffff817e2de2>] ret_from_fork+0x42/0x70
Jun 22 20:55:36 xpc kernel: [26363.308245]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 20:55:36 xpc kernel: [26363.309545] Code: 55 48 89 e5 41 55 41 54 53 49 89 fd 49 89 f4 89 d3 48 83 ec 08 f6 05 39 1b 01 00 04 75 5e 49 8b 45 00 4c 89 e2 81 e2 f8 0f 00 00 <48> 8b 04 02 48 85 c0 75 2d 31 db f6 05 f0 1a 01 00 04 75 57 48
Jun 22 20:55:36 xpc kernel: [26363.310985] RIP  [<ffffffffc0181490>] __find_stripe+0x30/0xc0 [raid456]
Jun 22 20:55:36 xpc kernel: [26363.312362]  RSP <ffff880071bff578>
Jun 22 20:55:36 xpc kernel: [26363.313736] ---[ end trace c430f52499aa3b3b ]---
Jun 22 20:55:36 xpc kernel: [26363.313786] BUG: unable to handle kernel paging request at ffffffffffffffd8

Jun 22 22:35:27 xpc kernel: [ 5636.261686] general protection fault: 0000 [#1] SMP
Jun 22 22:35:27 xpc kernel: [ 5636.261704] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:35:27 xpc kernel: [ 5636.261985] CPU: 3 PID: 758 Comm: jbd2/dm-1-8 Not tainted 4.1.0-rc8 #2
Jun 22 22:35:27 xpc kernel: [ 5636.261998] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:35:27 xpc kernel: [ 5636.262014] task: ffff8800aef3e4a0 ti: ffff880035f94000 task.ti: ffff880035f94000
Jun 22 22:35:27 xpc kernel: [ 5636.262028] RIP: 0010:[<ffffffffc0124490>]  [<ffffffffc0124490>] __find_stripe+0x30/0xc0 [raid456]
Jun 22 22:35:27 xpc kernel: [ 5636.262050] RSP: 0018:ffff880035f97988  EFLAGS: 00010006
Jun 22 22:35:27 xpc kernel: [ 5636.262060] RAX: 00018801b4dd2000 RBX: 0000000000000000 RCX: 0000000000000000
Jun 22 22:35:27 xpc kernel: [ 5636.262073] RDX: 0000000000000a50 RSI: 0000000002487a50 RDI: ffff8801b504e400
Jun 22 22:35:27 xpc kernel: [ 5636.262087] RBP: ffff880035f979a8 R08: 0000000000000000 R09: 0000000000000000
Jun 22 22:35:27 xpc kernel: [ 5636.262101] R10: 0000000000000250 R11: 0000000000000003 R12: 0000000002487a50
Jun 22 22:35:27 xpc kernel: [ 5636.262114] R13: ffff8801b504e400 R14: ffff8801b504e410 R15: ffff8801b504e400
Jun 22 22:35:27 xpc kernel: [ 5636.262127] FS:  0000000000000000(0000) GS:ffff8801bfac0000(0000) knlGS:0000000000000000
Jun 22 22:35:27 xpc kernel: [ 5636.262142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:35:27 xpc kernel: [ 5636.262153] CR2: 00007f25f0892000 CR3: 0000000001c0d000 CR4: 00000000001407e0
Jun 22 22:35:27 xpc kernel: [ 5636.262166] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:35:27 xpc kernel: [ 5636.262180] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:35:27 xpc kernel: [ 5636.262193] Stack:
Jun 22 22:35:27 xpc kernel: [ 5636.262197]  0000000000000000 0000000000000000 0000000000000002 ffff8800ae94d820
Jun 22 22:35:27 xpc kernel: [ 5636.262213]  ffff880035f97a78 ffffffffc012b36d ffff8801b8251420 0000000000000246
Jun 22 22:35:27 xpc kernel: [ 5636.262229]  ffff880035f97a30 ffff8801b504e408 ffff880035f97a30 0000000000000002
Jun 22 22:35:27 xpc kernel: [ 5636.262245] Call Trace:
Jun 22 22:35:27 xpc kernel: [ 5636.262254]  [<ffffffffc012b36d>] get_active_stripe+0x12d/0x7e0 [raid456]
Jun 22 22:35:27 xpc kernel: [ 5636.263196]  [<ffffffff810bc097>] ? prepare_to_wait+0x57/0x90
Jun 22 22:35:27 xpc kernel: [ 5636.264128]  [<ffffffffc013100d>] make_request+0x19d/0xda0 [raid456]
Jun 22 22:35:27 xpc kernel: [ 5636.265068]  [<ffffffff8165e6cb>] ? __split_and_process_bio+0x2fb/0x3f0
Jun 22 22:35:27 xpc kernel: [ 5636.265993]  [<ffffffff810bc3b0>] ? wait_woken+0x90/0x90
Jun 22 22:35:27 xpc kernel: [ 5636.266898]  [<ffffffff8164bbfc>] md_make_request+0xdc/0x220
Jun 22 22:35:27 xpc kernel: [ 5636.267780]  [<ffffffff8165e83a>] ? dm_make_request+0x7a/0xd0
Jun 22 22:35:27 xpc kernel: [ 5636.268668]  [<ffffffff81386580>] generic_make_request+0xc0/0x110
Jun 22 22:35:27 xpc kernel: [ 5636.269546]  [<ffffffff81386648>] submit_bio+0x78/0x180
Jun 22 22:35:27 xpc kernel: [ 5636.270396]  [<ffffffff812df62b>] ? jbd2_journal_write_metadata_buffer+0x2cb/0x390
Jun 22 22:35:27 xpc kernel: [ 5636.271255]  [<ffffffff81233d3c>] _submit_bh+0x11c/0x190
Jun 22 22:35:27 xpc kernel: [ 5636.272140]  [<ffffffff81233dc0>] submit_bh+0x10/0x20
Jun 22 22:35:27 xpc kernel: [ 5636.273023]  [<ffffffff812d7481>] jbd2_journal_commit_transaction+0x7e1/0x1820
Jun 22 22:35:27 xpc kernel: [ 5636.273865]  [<ffffffff8101ddd9>] ? sched_clock+0x9/0x10
Jun 22 22:35:27 xpc kernel: [ 5636.274697]  [<ffffffff810e50ef>] ? try_to_del_timer_sync+0x4f/0x70
Jun 22 22:35:27 xpc kernel: [ 5636.275551]  [<ffffffff812dbe4b>] kjournald2+0xbb/0x250
Jun 22 22:35:27 xpc kernel: [ 5636.276395]  [<ffffffff810bc3b0>] ? wait_woken+0x90/0x90
Jun 22 22:35:27 xpc kernel: [ 5636.277212]  [<ffffffff812dbd90>] ? commit_timeout+0x10/0x10
Jun 22 22:35:27 xpc kernel: [ 5636.278056]  [<ffffffff81098c49>] kthread+0xc9/0xe0
Jun 22 22:35:27 xpc kernel: [ 5636.278846]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 22:35:27 xpc kernel: [ 5636.279653]  [<ffffffff817e2de2>] ret_from_fork+0x42/0x70
Jun 22 22:35:27 xpc kernel: [ 5636.280483]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 22:35:27 xpc kernel: [ 5636.281275] Code: 55 48 89 e5 41 55 41 54 53 49 89 fd 49 89 f4 89 d3 48 83 ec 08 f6 05 39 1b 01 00 04 75 5e 49 8b 45 00 4c 89 e2 81 e2 f8 0f 00 00 <48> 8b 04 02 48 85 c0 75 2d 31 db f6 05 f0 1a 01 00 04 75 57 48
Jun 22 22:35:27 xpc kernel: [ 5636.282143] RIP  [<ffffffffc0124490>] __find_stripe+0x30/0xc0 [raid456]
Jun 22 22:35:27 xpc kernel: [ 5636.282985]  RSP <ffff880035f97988>
Jun 22 22:35:27 xpc kernel: [ 5636.288562] ---[ end trace a7acce1acaef3212 ]---
Jun 22 22:35:31 xpc kernel: [ 5640.056699] ------------[ cut here ]------------
Jun 22 22:35:31 xpc kernel: [ 5640.056707] WARNING: CPU: 5 PID: 0 at net/sched/sch_generic.c:303 dev_watchdog+0x240/0x250()
Jun 22 22:35:31 xpc kernel: [ 5640.056708] NETDEV WATCHDOG: eth1 (e1000e): transmit queue 0 timed out
Jun 22 22:35:31 xpc kernel: [ 5640.056709] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:35:31 xpc kernel: [ 5640.056773] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G      D         4.1.0-rc8 #2
Jun 22 22:35:31 xpc kernel: [ 5640.056774] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:35:31 xpc kernel: [ 5640.056775]  ffffffff81b4143e ffff8801bfb43d58 ffffffff817db798 0000000000000007
Jun 22 22:35:31 xpc kernel: [ 5640.056778]  ffff8801bfb43da8 ffff8801bfb43d98 ffffffff8107986a ffff8801b5b09c08
Jun 22 22:35:31 xpc kernel: [ 5640.056779]  0000000000000000 ffff880036741080 0000000000000005 ffff8801b4be0000
Jun 22 22:35:31 xpc kernel: [ 5640.056781] Call Trace:
Jun 22 22:35:31 xpc kernel: [ 5640.056783]  <IRQ>  [<ffffffff817db798>] dump_stack+0x45/0x57
Jun 22 22:35:31 xpc kernel: [ 5640.056790]  [<ffffffff8107986a>] warn_slowpath_common+0x8a/0xc0
Jun 22 22:35:31 xpc kernel: [ 5640.056792]  [<ffffffff810798e6>] warn_slowpath_fmt+0x46/0x50
Jun 22 22:35:31 xpc kernel: [ 5640.056796]  [<ffffffff81677261>] ? intel_pstate_timer_func+0x321/0x3c0
Jun 22 22:35:31 xpc kernel: [ 5640.056801]  [<ffffffff816f8f60>] dev_watchdog+0x240/0x250
Jun 22 22:35:31 xpc kernel: [ 5640.056803]  [<ffffffff816f8d20>] ? dev_graft_qdisc+0x80/0x80
Jun 22 22:35:31 xpc kernel: [ 5640.056805]  [<ffffffff810e3d39>] call_timer_fn+0x39/0x110
Jun 22 22:35:31 xpc kernel: [ 5640.056807]  [<ffffffff816f8d20>] ? dev_graft_qdisc+0x80/0x80
Jun 22 22:35:31 xpc kernel: [ 5640.056809]  [<ffffffff810e5af0>] run_timer_softirq+0x250/0x320
Jun 22 22:35:31 xpc kernel: [ 5640.056812]  [<ffffffff8104e0b2>] ? lapic_next_deadline+0x32/0x40
Jun 22 22:35:31 xpc kernel: [ 5640.056815]  [<ffffffff8107dc99>] __do_softirq+0x109/0x270
Jun 22 22:35:31 xpc kernel: [ 5640.056818]  [<ffffffff8107df75>] irq_exit+0x95/0xa0
Jun 22 22:35:31 xpc kernel: [ 5640.056821]  [<ffffffff817e5776>] smp_apic_timer_interrupt+0x46/0x60
Jun 22 22:35:31 xpc kernel: [ 5640.056822]  [<ffffffff817e383e>] apic_timer_interrupt+0x6e/0x80
Jun 22 22:35:31 xpc kernel: [ 5640.056823]  <EOI>  [<ffffffff81677edf>] ? cpuidle_enter_state+0xaf/0x1f0
Jun 22 22:35:31 xpc kernel: [ 5640.056827]  [<ffffffff81677eaf>] ? cpuidle_enter_state+0x7f/0x1f0
Jun 22 22:35:31 xpc kernel: [ 5640.056829]  [<ffffffff81678057>] cpuidle_enter+0x17/0x20
Jun 22 22:35:31 xpc kernel: [ 5640.056831]  [<ffffffff810bcb0f>] cpu_startup_entry+0x35f/0x3e0
Jun 22 22:35:31 xpc kernel: [ 5640.056833]  [<ffffffff8104c8ce>] start_secondary+0x17e/0x1a0
Jun 22 22:35:31 xpc kernel: [ 5640.056835] ---[ end trace a7acce1acaef3213 ]---
Jun 22 22:35:31 xpc kernel: [ 5640.056841] e1000e 0000:00:19.0 eth1: Reset adapter unexpectedly
Jun 22 22:35:54 xpc kernel: [ 5648.254552] ------------[ cut here ]------------
Jun 22 22:35:54 xpc kernel: [ 5648.254560] WARNING: CPU: 1 PID: 1190 at kernel/watchdog.c:304 watchdog_overflow_callback+0x92/0xc0()
Jun 22 22:35:54 xpc kernel: [ 5648.254561] Watchdog detected hard LOCKUP on cpu 1
Jun 22 22:35:54 xpc kernel: [ 5648.254563] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:35:54 xpc kernel: [ 5648.254620] CPU: 1 PID: 1190 Comm: nfsd Tainted: G      D W       4.1.0-rc8 #2
Jun 22 22:35:54 xpc kernel: [ 5648.254622] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:35:54 xpc kernel: [ 5648.254623]  ffffffff81ab3c33 ffff8801bfa45ab0 ffffffff817db798 0000000000000007
Jun 22 22:35:54 xpc kernel: [ 5648.254625]  ffff8801bfa45b00 ffff8801bfa45af0 ffffffff8107986a 0000000000000000
Jun 22 22:35:54 xpc kernel: [ 5648.254627]  ffff8801b82a8000 0000000000000000 ffff8801bfa45c40 ffff8801bfa45ef8
Jun 22 22:35:54 xpc kernel: [ 5648.254630] Call Trace:
Jun 22 22:35:54 xpc kernel: [ 5648.254631]  <NMI>  [<ffffffff817db798>] dump_stack+0x45/0x57
Jun 22 22:35:54 xpc kernel: [ 5648.254638]  [<ffffffff8107986a>] warn_slowpath_common+0x8a/0xc0
Jun 22 22:35:54 xpc kernel: [ 5648.254640]  [<ffffffff810798e6>] warn_slowpath_fmt+0x46/0x50
Jun 22 22:35:54 xpc kernel: [ 5648.254642]  [<ffffffff811323d2>] watchdog_overflow_callback+0x92/0xc0
Jun 22 22:35:54 xpc kernel: [ 5648.254645]  [<ffffffff811791cc>] __perf_event_overflow+0x8c/0x220
Jun 22 22:35:54 xpc kernel: [ 5648.254649]  [<ffffffff8102baca>] ? x86_perf_event_set_period+0xda/0x180
Jun 22 22:35:54 xpc kernel: [ 5648.254651]  [<ffffffff81179d34>] perf_event_overflow+0x14/0x20
Jun 22 22:35:54 xpc kernel: [ 5648.254653]  [<ffffffff81033eea>] intel_pmu_handle_irq+0x1da/0x450
Jun 22 22:35:54 xpc kernel: [ 5648.254656]  [<ffffffff8102a8bb>] perf_event_nmi_handler+0x2b/0x50
Jun 22 22:35:54 xpc kernel: [ 5648.254658]  [<ffffffff81018200>] nmi_handle+0x80/0x120
Jun 22 22:35:54 xpc kernel: [ 5648.254660]  [<ffffffff81018835>] default_do_nmi+0xd5/0x140
Jun 22 22:35:54 xpc kernel: [ 5648.254662]  [<ffffffff81018928>] do_nmi+0x88/0xd0
Jun 22 22:35:54 xpc kernel: [ 5648.254664]  [<ffffffff817e4caf>] end_repeat_nmi+0x1e/0x2e
Jun 22 22:35:54 xpc kernel: [ 5648.254667]  [<ffffffff817e261a>] ? _raw_spin_lock_irq+0x3a/0x80
Jun 22 22:35:54 xpc kernel: [ 5648.254668]  [<ffffffff817e261a>] ? _raw_spin_lock_irq+0x3a/0x80
Jun 22 22:35:54 xpc kernel: [ 5648.254670]  [<ffffffff817e261a>] ? _raw_spin_lock_irq+0x3a/0x80
Jun 22 22:35:54 xpc kernel: [ 5648.254671]  <<EOE>>  [<ffffffffc0126ffb>] drop_one_stripe+0x3b/0xe0 [raid456]
Jun 22 22:35:54 xpc kernel: [ 5648.254682]  [<ffffffffc01270e5>] raid5_cache_scan+0x45/0x60 [raid456]
Jun 22 22:35:54 xpc kernel: [ 5648.254685]  [<ffffffff81195919>] shrink_slab+0x1f9/0x390
Jun 22 22:35:54 xpc kernel: [ 5648.254688]  [<ffffffff8109ccce>] ? groups_alloc+0x3e/0x130
Jun 22 22:35:54 xpc kernel: [ 5648.254690]  [<ffffffff8119a0c4>] shrink_zone+0x2a4/0x2b0
Jun 22 22:35:54 xpc kernel: [ 5648.254692]  [<ffffffff8119a245>] do_try_to_free_pages+0x175/0x450
Jun 22 22:35:54 xpc kernel: [ 5648.254693]  [<ffffffff8119a5da>] try_to_free_pages+0xba/0x140
Jun 22 22:35:54 xpc kernel: [ 5648.254697]  [<ffffffff8118d742>] __alloc_pages_nodemask+0x642/0xa70
Jun 22 22:35:54 xpc kernel: [ 5648.254709]  [<ffffffffc01b69b8>] ? svc_sendto+0x68/0x1f0 [sunrpc]
Jun 22 22:35:54 xpc kernel: [ 5648.254712]  [<ffffffff811d3131>] alloc_pages_current+0x91/0x110
Jun 22 22:35:54 xpc kernel: [ 5648.254723]  [<ffffffffc01c32af>] svc_recv+0x8f/0xb00 [sunrpc]
Jun 22 22:35:54 xpc kernel: [ 5648.254731]  [<ffffffffc02368ed>] nfsd+0xed/0x170 [nfsd]
Jun 22 22:35:54 xpc kernel: [ 5648.254736]  [<ffffffffc0236800>] ? nfsd_destroy+0x80/0x80 [nfsd]
Jun 22 22:35:54 xpc kernel: [ 5648.254737]  [<ffffffff81098c49>] kthread+0xc9/0xe0
Jun 22 22:35:54 xpc kernel: [ 5648.254739]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 22:35:54 xpc kernel: [ 5648.254741]  [<ffffffff817e2de2>] ret_from_fork+0x42/0x70
Jun 22 22:35:54 xpc kernel: [ 5648.254742]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 22:35:54 xpc kernel: [ 5648.254744] ---[ end trace a7acce1acaef3214 ]---
Jun 22 22:35:54 xpc kernel: [ 5663.352710] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [systemd-journal:399]
Jun 22 22:35:54 xpc kernel: [ 5663.352712] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:35:54 xpc kernel: [ 5663.352773] CPU: 2 PID: 399 Comm: systemd-journal Tainted: G      D W       4.1.0-rc8 #2
Jun 22 22:35:54 xpc kernel: [ 5663.352774] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:35:54 xpc kernel: [ 5663.352775] task: ffff880036334670 ti: ffff880035914000 task.ti: ffff880035914000
Jun 22 22:35:54 xpc kernel: [ 5663.352776] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:35:54 xpc kernel: [ 5663.352781] RSP: 0018:ffff880035917af8  EFLAGS: 00000202
Jun 22 22:35:54 xpc kernel: [ 5663.352781] RAX: 0000000000000003 RBX: ffff8801bfdfa078 RCX: 0000000000000001
Jun 22 22:35:54 xpc kernel: [ 5663.352782] RDX: ffff8801bfa5bac8 RSI: 0000000000000100 RDI: ffff8801bfa98a08
Jun 22 22:35:54 xpc kernel: [ 5663.352783] RBP: ffff880035917b38 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:35:54 xpc kernel: [ 5663.352783] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000297
Jun 22 22:35:54 xpc kernel: [ 5663.352784] R13: ffff880035917aa8 R14: ffff8800359d66f8 R15: 0000000000401b5f
Jun 22 22:35:54 xpc kernel: [ 5663.352785] FS:  00007fe239f58880(0000) GS:ffff8801bfa80000(0000) knlGS:0000000000000000
Jun 22 22:35:54 xpc kernel: [ 5663.352786] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:35:54 xpc kernel: [ 5663.352786] CR2: 00007f63f00050a8 CR3: 00000000359ae000 CR4: 00000000001407e0
Jun 22 22:35:54 xpc kernel: [ 5663.352787] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:35:54 xpc kernel: [ 5663.352788] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:35:54 xpc kernel: [ 5663.352788] Stack:
Jun 22 22:35:54 xpc kernel: [ 5663.352789]  00000000000189c0 0100000000000001 0000000000000000 0000000000000002
Jun 22 22:35:54 xpc kernel: [ 5663.352790]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:35:54 xpc kernel: [ 5663.352791]  ffff880035917b68 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:35:54 xpc kernel: [ 5663.352793] Call Trace:
Jun 22 22:35:54 xpc kernel: [ 5663.352797]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:35:54 xpc kernel: [ 5663.352798]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:35:54 xpc kernel: [ 5663.352800]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:35:54 xpc kernel: [ 5663.352802]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:35:54 xpc kernel: [ 5663.352805]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:35:54 xpc kernel: [ 5663.352808]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:35:54 xpc kernel: [ 5663.352811]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:35:54 xpc kernel: [ 5663.352812]  [<ffffffff811bb2ff>] ? do_mmap_pgoff+0x30f/0x3f0
Jun 22 22:35:54 xpc kernel: [ 5663.352813]  [<ffffffff811b93d0>] ? vma_merge+0x230/0x370
Jun 22 22:35:54 xpc kernel: [ 5663.352816]  [<ffffffff811a1569>] ? vm_mmap_pgoff+0x99/0xc0
Jun 22 22:35:54 xpc kernel: [ 5663.352817]  [<ffffffff811ba6eb>] ? do_brk+0x22b/0x310
Jun 22 22:35:54 xpc kernel: [ 5663.352819]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:35:54 xpc kernel: [ 5663.352820]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:35:54 xpc kernel: [ 5663.352823]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:35:54 xpc kernel: [ 5663.352824] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:36:22 xpc kernel: [ 5691.309526] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [systemd-journal:399]
Jun 22 22:36:22 xpc kernel: [ 5691.309540] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:36:22 xpc kernel: [ 5691.309606] CPU: 2 PID: 399 Comm: systemd-journal Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:36:22 xpc kernel: [ 5691.309607] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:36:22 xpc kernel: [ 5691.309609] task: ffff880036334670 ti: ffff880035914000 task.ti: ffff880035914000
Jun 22 22:36:22 xpc kernel: [ 5691.309610] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:36:22 xpc kernel: [ 5691.309616] RSP: 0018:ffff880035917af8  EFLAGS: 00000202
Jun 22 22:36:22 xpc kernel: [ 5691.309617] RAX: 0000000000000003 RBX: ffff8801bfdfa078 RCX: 0000000000000001
Jun 22 22:36:22 xpc kernel: [ 5691.309618] RDX: ffff8801bfa5bac8 RSI: 0000000000000100 RDI: ffff8801bfa98a08
Jun 22 22:36:22 xpc kernel: [ 5691.309619] RBP: ffff880035917b38 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:36:22 xpc kernel: [ 5691.309620] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000297
Jun 22 22:36:22 xpc kernel: [ 5691.309621] R13: ffff880035917aa8 R14: ffff8800359d66f8 R15: 0000000000401b5f
Jun 22 22:36:22 xpc kernel: [ 5691.309622] FS:  00007fe239f58880(0000) GS:ffff8801bfa80000(0000) knlGS:0000000000000000
Jun 22 22:36:22 xpc kernel: [ 5691.309624] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:36:22 xpc kernel: [ 5691.309625] CR2: 00007f63f00050a8 CR3: 00000000359ae000 CR4: 00000000001407e0
Jun 22 22:36:22 xpc kernel: [ 5691.309626] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:36:22 xpc kernel: [ 5691.309627] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:36:22 xpc kernel: [ 5691.309628] Stack:
Jun 22 22:36:22 xpc kernel: [ 5691.309629]  00000000000189c0 0100000000000001 0000000000000000 0000000000000002
Jun 22 22:36:22 xpc kernel: [ 5691.309631]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:36:22 xpc kernel: [ 5691.309633]  ffff880035917b68 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:36:22 xpc kernel: [ 5691.309635] Call Trace:
Jun 22 22:36:22 xpc kernel: [ 5691.309640]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:36:22 xpc kernel: [ 5691.309642]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:36:22 xpc kernel: [ 5691.309644]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:36:22 xpc kernel: [ 5691.309646]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:36:22 xpc kernel: [ 5691.309650]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:36:22 xpc kernel: [ 5691.309653]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:36:22 xpc kernel: [ 5691.309657]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:36:22 xpc kernel: [ 5691.309659]  [<ffffffff811bb2ff>] ? do_mmap_pgoff+0x30f/0x3f0
Jun 22 22:36:22 xpc kernel: [ 5691.309661]  [<ffffffff811b93d0>] ? vma_merge+0x230/0x370
Jun 22 22:36:22 xpc kernel: [ 5691.309663]  [<ffffffff811a1569>] ? vm_mmap_pgoff+0x99/0xc0
Jun 22 22:36:22 xpc kernel: [ 5691.309665]  [<ffffffff811ba6eb>] ? do_brk+0x22b/0x310
Jun 22 22:36:22 xpc kernel: [ 5691.309668]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:36:22 xpc kernel: [ 5691.309670]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:36:22 xpc kernel: [ 5691.309673]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:36:22 xpc kernel: [ 5691.309674] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:36:22 xpc kernel: [ 5691.357451] NMI watchdog: BUG: soft lockup - CPU#6 stuck for 22s! [kernel_oops:25728]
Jun 22 22:36:22 xpc kernel: [ 5691.357464] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:36:22 xpc kernel: [ 5691.357529] CPU: 6 PID: 25728 Comm: kernel_oops Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:36:22 xpc kernel: [ 5691.357530] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:36:22 xpc kernel: [ 5691.357532] task: ffff880035c5b250 ti: ffff8801b0364000 task.ti: ffff8801b0364000
Jun 22 22:36:22 xpc kernel: [ 5691.357533] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:36:22 xpc kernel: [ 5691.357538] RSP: 0018:ffff8801b0367818  EFLAGS: 00000202
Jun 22 22:36:22 xpc kernel: [ 5691.357539] RAX: 0000000000000003 RBX: ffff8801bfb979b0 RCX: 0000000000000001
Jun 22 22:36:22 xpc kernel: [ 5691.357540] RDX: ffff8801bfa5bf60 RSI: 0000000000000100 RDI: ffff8801bfb98a08
Jun 22 22:36:22 xpc kernel: [ 5691.357541] RBP: ffff8801b0367858 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:36:22 xpc kernel: [ 5691.357542] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000293
Jun 22 22:36:22 xpc kernel: [ 5691.357543] R13: ffff8801b03677c8 R14: ffffffff810ace9c R15: ffff8801b03677c8
Jun 22 22:36:22 xpc kernel: [ 5691.357544] FS:  00007f7e7e9df700(0000) GS:ffff8801bfb80000(0000) knlGS:0000000000000000
Jun 22 22:36:22 xpc kernel: [ 5691.357545] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:36:22 xpc kernel: [ 5691.357546] CR2: 00007f7e78400000 CR3: 0000000102a18000 CR4: 00000000001407e0
Jun 22 22:36:22 xpc kernel: [ 5691.357548] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:36:22 xpc kernel: [ 5691.357549] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:36:22 xpc kernel: [ 5691.357549] Stack:
Jun 22 22:36:22 xpc kernel: [ 5691.357550]  00000000000189c0 01ff880100000001 ffff880100000000 0000000000000006
Jun 22 22:36:22 xpc kernel: [ 5691.357552]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:36:22 xpc kernel: [ 5691.357554]  ffff8801b0367888 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:36:22 xpc kernel: [ 5691.357556] Call Trace:
Jun 22 22:36:22 xpc kernel: [ 5691.357561]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:36:22 xpc kernel: [ 5691.357563]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:36:22 xpc kernel: [ 5691.357564]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:36:22 xpc kernel: [ 5691.357567]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:36:22 xpc kernel: [ 5691.357570]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:36:22 xpc kernel: [ 5691.357573]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:36:22 xpc kernel: [ 5691.357577]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:36:22 xpc kernel: [ 5691.357581]  [<ffffffff810126f3>] ? __switch_to+0x263/0x5d0
Jun 22 22:36:22 xpc kernel: [ 5691.357583]  [<ffffffff810b2cdf>] ? put_prev_task_fair+0x2f/0x50
Jun 22 22:36:22 xpc kernel: [ 5691.357587]  [<ffffffff817ddd57>] ? __schedule+0x397/0xa10
Jun 22 22:36:22 xpc kernel: [ 5691.357590]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:36:22 xpc kernel: [ 5691.357592]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:36:22 xpc kernel: [ 5691.357594]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:36:22 xpc kernel: [ 5691.357597]  [<ffffffff813cd698>] ? copy_page_to_iter+0x68/0x330
Jun 22 22:36:22 xpc kernel: [ 5691.357599]  [<ffffffff8118466d>] ? pagecache_get_page+0x2d/0x1a0
Jun 22 22:36:22 xpc kernel: [ 5691.357601]  [<ffffffff811853f1>] generic_file_read_iter+0x281/0x650
Jun 22 22:36:22 xpc kernel: [ 5691.357604]  [<ffffffff81114f12>] ? from_kgid_munged+0x12/0x20
Jun 22 22:36:22 xpc kernel: [ 5691.357606]  [<ffffffff811fcbfb>] __vfs_read+0xab/0xf0
Jun 22 22:36:22 xpc kernel: [ 5691.357608]  [<ffffffff811fd23a>] vfs_read+0x8a/0x140
Jun 22 22:36:22 xpc kernel: [ 5691.357610]  [<ffffffff811fe0f6>] SyS_read+0x46/0xb0
Jun 22 22:36:22 xpc kernel: [ 5691.357611]  [<ffffffff81066f1f>] ? do_page_fault+0x2f/0x80
Jun 22 22:36:22 xpc kernel: [ 5691.357613]  [<ffffffff817e29b2>] system_call_fastpath+0x16/0x75
Jun 22 22:36:22 xpc kernel: [ 5691.357614] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:36:24 xpc kernel: [ 5693.094766] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 6, t=15002 jiffies, g=500946, c=500945, q=0)
Jun 22 22:36:24 xpc kernel: [ 5693.094782] Task dump for CPU 1:
Jun 22 22:36:24 xpc kernel: [ 5693.094783] nfsd            R  running task        0  1190      2 0x00000008
Jun 22 22:36:24 xpc kernel: [ 5693.094786]  ffffffff817ddd57 ffff8801b8250000 ffff8801b5bfa840 ffff8801afedf9e0
Jun 22 22:36:24 xpc kernel: [ 5693.094788]  ffff8800aea38000 ffff8801bfa57940 7fffffffffffffff 0000000000000002
Jun 22 22:36:24 xpc kernel: [ 5693.094790]  ffffffff817ded30 ffff8800aea377c8 ffffffff817de407 0000000000000001
Jun 22 22:36:24 xpc kernel: [ 5693.094792] Call Trace:
Jun 22 22:36:24 xpc kernel: [ 5693.094797]  [<ffffffff817ddd57>] ? __schedule+0x397/0xa10
Jun 22 22:36:24 xpc kernel: [ 5693.094800]  [<ffffffff817ded30>] ? bit_wait_timeout+0x70/0x70
Jun 22 22:36:24 xpc kernel: [ 5693.094811]  [<ffffffff817de407>] ? schedule+0x37/0x90
Jun 22 22:36:24 xpc kernel: [ 5693.094814]  [<ffffffff8118acde>] ? free_one_page+0x25e/0x370
Jun 22 22:36:24 xpc kernel: [ 5693.094816]  [<ffffffff8118b7dd>] ? __free_pages+0x1d/0x30
Jun 22 22:36:24 xpc kernel: [ 5693.094819]  [<ffffffff811dbc31>] ? __free_slab+0xd1/0x1e0
Jun 22 22:36:24 xpc kernel: [ 5693.094821]  [<ffffffff8118b1ae>] ? free_pcppages_bulk+0x2ce/0x4d0
Jun 22 22:36:24 xpc kernel: [ 5693.094823]  [<ffffffff811dd5c8>] ? __slab_free+0x1b8/0x2c0
Jun 22 22:36:24 xpc kernel: [ 5693.094824]  [<ffffffff811dd8b6>] ? kmem_cache_free+0x1e6/0x210
Jun 22 22:36:24 xpc kernel: [ 5693.094837]  [<ffffffffc0126ffb>] ? drop_one_stripe+0x3b/0xe0 [raid456]
Jun 22 22:36:24 xpc kernel: [ 5693.094842]  [<ffffffffc01270e5>] ? raid5_cache_scan+0x45/0x60 [raid456]
Jun 22 22:36:24 xpc kernel: [ 5693.094844]  [<ffffffff81195919>] ? shrink_slab+0x1f9/0x390
Jun 22 22:36:24 xpc kernel: [ 5693.094848]  [<ffffffff8109ccce>] ? groups_alloc+0x3e/0x130
Jun 22 22:36:24 xpc kernel: [ 5693.094850]  [<ffffffff8119a0c4>] ? shrink_zone+0x2a4/0x2b0
Jun 22 22:36:24 xpc kernel: [ 5693.094852]  [<ffffffff8119a245>] ? do_try_to_free_pages+0x175/0x450
Jun 22 22:36:24 xpc kernel: [ 5693.094854]  [<ffffffff8119a5da>] ? try_to_free_pages+0xba/0x140
Jun 22 22:36:24 xpc kernel: [ 5693.094856]  [<ffffffff8118d742>] ? __alloc_pages_nodemask+0x642/0xa70
Jun 22 22:36:24 xpc kernel: [ 5693.094868]  [<ffffffffc01b69b8>] ? svc_sendto+0x68/0x1f0 [sunrpc]
Jun 22 22:36:24 xpc kernel: [ 5693.094871]  [<ffffffff811d3131>] ? alloc_pages_current+0x91/0x110
Jun 22 22:36:24 xpc kernel: [ 5693.094881]  [<ffffffffc01c32af>] ? svc_recv+0x8f/0xb00 [sunrpc]
Jun 22 22:36:24 xpc kernel: [ 5693.094888]  [<ffffffffc02368ed>] ? nfsd+0xed/0x170 [nfsd]
Jun 22 22:36:24 xpc kernel: [ 5693.094892]  [<ffffffffc0236800>] ? nfsd_destroy+0x80/0x80 [nfsd]
Jun 22 22:36:24 xpc kernel: [ 5693.094894]  [<ffffffff81098c49>] ? kthread+0xc9/0xe0
Jun 22 22:36:24 xpc kernel: [ 5693.094896]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 22:36:24 xpc kernel: [ 5693.094898]  [<ffffffff817e2de2>] ? ret_from_fork+0x42/0x70
Jun 22 22:36:24 xpc kernel: [ 5693.094899]  [<ffffffff81098b80>] ? kthread_create_on_node+0x180/0x180
Jun 22 22:36:50 xpc kernel: [ 5719.266341] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [systemd-journal:399]
Jun 22 22:36:50 xpc kernel: [ 5719.266354] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:36:50 xpc kernel: [ 5719.266418] CPU: 2 PID: 399 Comm: systemd-journal Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:36:50 xpc kernel: [ 5719.266419] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:36:50 xpc kernel: [ 5719.266421] task: ffff880036334670 ti: ffff880035914000 task.ti: ffff880035914000
Jun 22 22:36:50 xpc kernel: [ 5719.266422] RIP: 0010:[<ffffffff810fb972>]  [<ffffffff810fb972>] smp_call_function_many+0x222/0x280
Jun 22 22:36:50 xpc kernel: [ 5719.266427] RSP: 0018:ffff880035917af8  EFLAGS: 00000202
Jun 22 22:36:50 xpc kernel: [ 5719.266428] RAX: 0000000000000003 RBX: ffff8801bfdfa078 RCX: 0000000000000001
Jun 22 22:36:50 xpc kernel: [ 5719.266429] RDX: ffff8801bfa5bac8 RSI: 0000000000000100 RDI: ffff8801bfa98a08
Jun 22 22:36:50 xpc kernel: [ 5719.266430] RBP: ffff880035917b38 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:36:50 xpc kernel: [ 5719.266431] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000297
Jun 22 22:36:50 xpc kernel: [ 5719.266432] R13: ffff880035917aa8 R14: ffff8800359d66f8 R15: 0000000000401b5f
Jun 22 22:36:50 xpc kernel: [ 5719.266434] FS:  00007fe239f58880(0000) GS:ffff8801bfa80000(0000) knlGS:0000000000000000
Jun 22 22:36:50 xpc kernel: [ 5719.266435] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:36:50 xpc kernel: [ 5719.266436] CR2: 00007f63f00050a8 CR3: 00000000359ae000 CR4: 00000000001407e0
Jun 22 22:36:50 xpc kernel: [ 5719.266437] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:36:50 xpc kernel: [ 5719.266438] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:36:50 xpc kernel: [ 5719.266439] Stack:
Jun 22 22:36:50 xpc kernel: [ 5719.266440]  00000000000189c0 0100000000000001 0000000000000000 0000000000000002
Jun 22 22:36:50 xpc kernel: [ 5719.266442]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:36:50 xpc kernel: [ 5719.266444]  ffff880035917b68 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:36:50 xpc kernel: [ 5719.266446] Call Trace:
Jun 22 22:36:50 xpc kernel: [ 5719.266451]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:36:50 xpc kernel: [ 5719.266453]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:36:50 xpc kernel: [ 5719.266455]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:36:50 xpc kernel: [ 5719.266457]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:36:50 xpc kernel: [ 5719.266461]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:36:50 xpc kernel: [ 5719.266465]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:36:50 xpc kernel: [ 5719.266468]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:36:50 xpc kernel: [ 5719.266470]  [<ffffffff811bb2ff>] ? do_mmap_pgoff+0x30f/0x3f0
Jun 22 22:36:50 xpc kernel: [ 5719.266472]  [<ffffffff811b93d0>] ? vma_merge+0x230/0x370
Jun 22 22:36:50 xpc kernel: [ 5719.266475]  [<ffffffff811a1569>] ? vm_mmap_pgoff+0x99/0xc0
Jun 22 22:36:50 xpc kernel: [ 5719.266476]  [<ffffffff811ba6eb>] ? do_brk+0x22b/0x310
Jun 22 22:36:50 xpc kernel: [ 5719.266479]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:36:50 xpc kernel: [ 5719.266481]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:36:50 xpc kernel: [ 5719.266484]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:36:50 xpc kernel: [ 5719.266485] Code: c4 00 89 c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 <8b> 42 18 a8 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89
Jun 22 22:36:50 xpc kernel: [ 5719.314266] NMI watchdog: BUG: soft lockup - CPU#6 stuck for 22s! [kernel_oops:25728]
Jun 22 22:36:50 xpc kernel: [ 5719.314278] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:36:50 xpc kernel: [ 5719.314340] CPU: 6 PID: 25728 Comm: kernel_oops Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:36:50 xpc kernel: [ 5719.314341] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:36:50 xpc kernel: [ 5719.314342] task: ffff880035c5b250 ti: ffff8801b0364000 task.ti: ffff8801b0364000
Jun 22 22:36:50 xpc kernel: [ 5719.314343] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:36:50 xpc kernel: [ 5719.314348] RSP: 0018:ffff8801b0367818  EFLAGS: 00000202
Jun 22 22:36:50 xpc kernel: [ 5719.314349] RAX: 0000000000000003 RBX: ffff8801bfb979b0 RCX: 0000000000000001
Jun 22 22:36:50 xpc kernel: [ 5719.314350] RDX: ffff8801bfa5bf60 RSI: 0000000000000100 RDI: ffff8801bfb98a08
Jun 22 22:36:50 xpc kernel: [ 5719.314351] RBP: ffff8801b0367858 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:36:50 xpc kernel: [ 5719.314352] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000293
Jun 22 22:36:50 xpc kernel: [ 5719.314353] R13: ffff8801b03677c8 R14: ffffffff810ace9c R15: ffff8801b03677c8
Jun 22 22:36:50 xpc kernel: [ 5719.314354] FS:  00007f7e7e9df700(0000) GS:ffff8801bfb80000(0000) knlGS:0000000000000000
Jun 22 22:36:50 xpc kernel: [ 5719.314355] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:36:50 xpc kernel: [ 5719.314356] CR2: 00007f7e78400000 CR3: 0000000102a18000 CR4: 00000000001407e0
Jun 22 22:36:50 xpc kernel: [ 5719.314357] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:36:50 xpc kernel: [ 5719.314358] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:36:50 xpc kernel: [ 5719.314359] Stack:
Jun 22 22:36:50 xpc kernel: [ 5719.314360]  00000000000189c0 01ff880100000001 ffff880100000000 0000000000000006
Jun 22 22:36:50 xpc kernel: [ 5719.314362]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:36:50 xpc kernel: [ 5719.314364]  ffff8801b0367888 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:36:50 xpc kernel: [ 5719.314366] Call Trace:
Jun 22 22:36:50 xpc kernel: [ 5719.314370]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:36:50 xpc kernel: [ 5719.314372]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:36:50 xpc kernel: [ 5719.314374]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:36:50 xpc kernel: [ 5719.314376]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:36:50 xpc kernel: [ 5719.314380]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:36:50 xpc kernel: [ 5719.314383]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:36:50 xpc kernel: [ 5719.314387]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:36:50 xpc kernel: [ 5719.314391]  [<ffffffff810126f3>] ? __switch_to+0x263/0x5d0
Jun 22 22:36:50 xpc kernel: [ 5719.314393]  [<ffffffff810b2cdf>] ? put_prev_task_fair+0x2f/0x50
Jun 22 22:36:50 xpc kernel: [ 5719.314397]  [<ffffffff817ddd57>] ? __schedule+0x397/0xa10
Jun 22 22:36:50 xpc kernel: [ 5719.314400]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:36:50 xpc kernel: [ 5719.314401]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:36:50 xpc kernel: [ 5719.314403]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:36:50 xpc kernel: [ 5719.314407]  [<ffffffff813cd698>] ? copy_page_to_iter+0x68/0x330
Jun 22 22:36:50 xpc kernel: [ 5719.314409]  [<ffffffff8118466d>] ? pagecache_get_page+0x2d/0x1a0
Jun 22 22:36:50 xpc kernel: [ 5719.314411]  [<ffffffff811853f1>] generic_file_read_iter+0x281/0x650
Jun 22 22:36:50 xpc kernel: [ 5719.314413]  [<ffffffff81114f12>] ? from_kgid_munged+0x12/0x20
Jun 22 22:36:50 xpc kernel: [ 5719.314416]  [<ffffffff811fcbfb>] __vfs_read+0xab/0xf0
Jun 22 22:36:50 xpc kernel: [ 5719.314418]  [<ffffffff811fd23a>] vfs_read+0x8a/0x140
Jun 22 22:36:50 xpc kernel: [ 5719.314419]  [<ffffffff811fe0f6>] SyS_read+0x46/0xb0
Jun 22 22:36:50 xpc kernel: [ 5719.314421]  [<ffffffff81066f1f>] ? do_page_fault+0x2f/0x80
Jun 22 22:36:50 xpc kernel: [ 5719.314423]  [<ffffffff817e29b2>] system_call_fastpath+0x16/0x75
Jun 22 22:36:50 xpc kernel: [ 5719.314424] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:36:52 xpc kernel: [ 5720.931756] usb 1-10.1.1: USB disconnect, device number 5
Jun 22 22:37:18 xpc kernel: [ 5747.223154] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [systemd-journal:399]
Jun 22 22:37:18 xpc kernel: [ 5747.223156] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:37:18 xpc kernel: [ 5747.223212] CPU: 2 PID: 399 Comm: systemd-journal Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:37:18 xpc kernel: [ 5747.223213] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:37:18 xpc kernel: [ 5747.223214] task: ffff880036334670 ti: ffff880035914000 task.ti: ffff880035914000
Jun 22 22:37:18 xpc kernel: [ 5747.223215] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:37:18 xpc kernel: [ 5747.223220] RSP: 0018:ffff880035917af8  EFLAGS: 00000202
Jun 22 22:37:18 xpc kernel: [ 5747.223222] RAX: 0000000000000003 RBX: ffff8801bfdfa078 RCX: 0000000000000001
Jun 22 22:37:18 xpc kernel: [ 5747.223223] RDX: ffff8801bfa5bac8 RSI: 0000000000000100 RDI: ffff8801bfa98a08
Jun 22 22:37:18 xpc kernel: [ 5747.223224] RBP: ffff880035917b38 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:37:18 xpc kernel: [ 5747.223225] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000297
Jun 22 22:37:18 xpc kernel: [ 5747.223226] R13: ffff880035917aa8 R14: ffff8800359d66f8 R15: 0000000000401b5f
Jun 22 22:37:18 xpc kernel: [ 5747.223227] FS:  00007fe239f58880(0000) GS:ffff8801bfa80000(0000) knlGS:0000000000000000
Jun 22 22:37:18 xpc kernel: [ 5747.223228] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:37:18 xpc kernel: [ 5747.223229] CR2: 00007f63f00050a8 CR3: 00000000359ae000 CR4: 00000000001407e0
Jun 22 22:37:18 xpc kernel: [ 5747.223231] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:37:18 xpc kernel: [ 5747.223232] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:37:18 xpc kernel: [ 5747.223232] Stack:
Jun 22 22:37:18 xpc kernel: [ 5747.223233]  00000000000189c0 0100000000000001 0000000000000000 0000000000000002
Jun 22 22:37:18 xpc kernel: [ 5747.223235]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:37:18 xpc kernel: [ 5747.223237]  ffff880035917b68 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:37:18 xpc kernel: [ 5747.223239] Call Trace:
Jun 22 22:37:18 xpc kernel: [ 5747.223244]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:37:18 xpc kernel: [ 5747.223245]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:37:18 xpc kernel: [ 5747.223247]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:37:18 xpc kernel: [ 5747.223250]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:37:18 xpc kernel: [ 5747.223254]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:37:18 xpc kernel: [ 5747.223256]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:37:18 xpc kernel: [ 5747.223260]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:37:18 xpc kernel: [ 5747.223261]  [<ffffffff811bb2ff>] ? do_mmap_pgoff+0x30f/0x3f0
Jun 22 22:37:18 xpc kernel: [ 5747.223263]  [<ffffffff811b93d0>] ? vma_merge+0x230/0x370
Jun 22 22:37:18 xpc kernel: [ 5747.223266]  [<ffffffff811a1569>] ? vm_mmap_pgoff+0x99/0xc0
Jun 22 22:37:18 xpc kernel: [ 5747.223267]  [<ffffffff811ba6eb>] ? do_brk+0x22b/0x310
Jun 22 22:37:18 xpc kernel: [ 5747.223270]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:37:18 xpc kernel: [ 5747.223272]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:37:18 xpc kernel: [ 5747.223275]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:37:18 xpc kernel: [ 5747.223276] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:37:18 xpc kernel: [ 5747.271080] NMI watchdog: BUG: soft lockup - CPU#6 stuck for 22s! [kernel_oops:25728]
Jun 22 22:37:18 xpc kernel: [ 5747.271081] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:37:18 xpc kernel: [ 5747.271121] CPU: 6 PID: 25728 Comm: kernel_oops Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:37:18 xpc kernel: [ 5747.271122] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:37:18 xpc kernel: [ 5747.271123] task: ffff880035c5b250 ti: ffff8801b0364000 task.ti: ffff8801b0364000
Jun 22 22:37:18 xpc kernel: [ 5747.271124] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:37:18 xpc kernel: [ 5747.271126] RSP: 0018:ffff8801b0367818  EFLAGS: 00000202
Jun 22 22:37:18 xpc kernel: [ 5747.271127] RAX: 0000000000000003 RBX: ffff8801bfb979b0 RCX: 0000000000000001
Jun 22 22:37:18 xpc kernel: [ 5747.271128] RDX: ffff8801bfa5bf60 RSI: 0000000000000100 RDI: ffff8801bfb98a08
Jun 22 22:37:18 xpc kernel: [ 5747.271129] RBP: ffff8801b0367858 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:37:18 xpc kernel: [ 5747.271130] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000293
Jun 22 22:37:18 xpc kernel: [ 5747.271131] R13: ffff8801b03677c8 R14: ffffffff810ace9c R15: ffff8801b03677c8
Jun 22 22:37:18 xpc kernel: [ 5747.271132] FS:  00007f7e7e9df700(0000) GS:ffff8801bfb80000(0000) knlGS:0000000000000000
Jun 22 22:37:18 xpc kernel: [ 5747.271133] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:37:18 xpc kernel: [ 5747.271134] CR2: 00007f7e78400000 CR3: 0000000102a18000 CR4: 00000000001407e0
Jun 22 22:37:18 xpc kernel: [ 5747.271135] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:37:18 xpc kernel: [ 5747.271136] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:37:18 xpc kernel: [ 5747.271137] Stack:
Jun 22 22:37:18 xpc kernel: [ 5747.271138]  00000000000189c0 01ff880100000001 ffff880100000000 0000000000000006
Jun 22 22:37:18 xpc kernel: [ 5747.271140]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:37:18 xpc kernel: [ 5747.271142]  ffff8801b0367888 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:37:18 xpc kernel: [ 5747.271143] Call Trace:
Jun 22 22:37:18 xpc kernel: [ 5747.271146]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:37:18 xpc kernel: [ 5747.271147]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:37:18 xpc kernel: [ 5747.271149]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:37:18 xpc kernel: [ 5747.271151]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:37:18 xpc kernel: [ 5747.271153]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:37:18 xpc kernel: [ 5747.271155]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:37:18 xpc kernel: [ 5747.271157]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:37:18 xpc kernel: [ 5747.271161]  [<ffffffff810126f3>] ? __switch_to+0x263/0x5d0
Jun 22 22:37:18 xpc kernel: [ 5747.271163]  [<ffffffff810b2cdf>] ? put_prev_task_fair+0x2f/0x50
Jun 22 22:37:18 xpc kernel: [ 5747.271167]  [<ffffffff817ddd57>] ? __schedule+0x397/0xa10
Jun 22 22:37:18 xpc kernel: [ 5747.271169]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:37:18 xpc kernel: [ 5747.271171]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:37:18 xpc kernel: [ 5747.271172]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:37:18 xpc kernel: [ 5747.271176]  [<ffffffff813cd698>] ? copy_page_to_iter+0x68/0x330
Jun 22 22:37:18 xpc kernel: [ 5747.271178]  [<ffffffff8118466d>] ? pagecache_get_page+0x2d/0x1a0
Jun 22 22:37:18 xpc kernel: [ 5747.271179]  [<ffffffff811853f1>] generic_file_read_iter+0x281/0x650
Jun 22 22:37:18 xpc kernel: [ 5747.271182]  [<ffffffff81114f12>] ? from_kgid_munged+0x12/0x20
Jun 22 22:37:18 xpc kernel: [ 5747.271184]  [<ffffffff811fcbfb>] __vfs_read+0xab/0xf0
Jun 22 22:37:18 xpc kernel: [ 5747.271186]  [<ffffffff811fd23a>] vfs_read+0x8a/0x140
Jun 22 22:37:18 xpc kernel: [ 5747.271188]  [<ffffffff811fe0f6>] SyS_read+0x46/0xb0
Jun 22 22:37:18 xpc kernel: [ 5747.271189]  [<ffffffff81066f1f>] ? do_page_fault+0x2f/0x80
Jun 22 22:37:18 xpc kernel: [ 5747.271191]  [<ffffffff817e29b2>] system_call_fastpath+0x16/0x75
Jun 22 22:37:18 xpc kernel: [ 5747.271192] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:37:22 xpc kernel: [ 5751.201009] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [colord-sane:25738]
Jun 22 22:37:22 xpc kernel: [ 5751.201011] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:37:22 xpc kernel: [ 5751.201042] CPU: 0 PID: 25738 Comm: colord-sane Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:37:22 xpc kernel: [ 5751.201043] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:37:22 xpc kernel: [ 5751.201044] task: ffff88009d40da90 ti: ffff8801b5ce0000 task.ti: ffff8801b5ce0000
Jun 22 22:37:22 xpc kernel: [ 5751.201045] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:37:22 xpc kernel: [ 5751.201047] RSP: 0018:ffff8801b5ce3b48  EFLAGS: 00000202
Jun 22 22:37:22 xpc kernel: [ 5751.201048] RAX: 0000000000000003 RBX: ffff8801b5ce3ae8 RCX: 0000000000000001
Jun 22 22:37:22 xpc kernel: [ 5751.201049] RDX: ffff8801bfa5b378 RSI: 0000000000000100 RDI: ffff8801bfa18a08
Jun 22 22:37:22 xpc kernel: [ 5751.201049] RBP: ffff8801b5ce3b88 R08: ffffffffffffffff R09: 0000000000000000
Jun 22 22:37:22 xpc kernel: [ 5751.201050] R10: 0000000000000004 R11: ffffea0002316f80 R12: 0000000000000293
Jun 22 22:37:22 xpc kernel: [ 5751.201050] R13: ffff8801b5ce3af8 R14: ffff8801b018e668 R15: 0000000000000001
Jun 22 22:37:22 xpc kernel: [ 5751.201051] FS:  00007f4959ae1800(0000) GS:ffff8801bfa00000(0000) knlGS:0000000000000000
Jun 22 22:37:22 xpc kernel: [ 5751.201052] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:37:22 xpc kernel: [ 5751.201053] CR2: 00007f4959b0c000 CR3: 00000001b01fa000 CR4: 00000000001407f0
Jun 22 22:37:22 xpc kernel: [ 5751.201054] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:37:22 xpc kernel: [ 5751.201054] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:37:22 xpc kernel: [ 5751.201055] Stack:
Jun 22 22:37:22 xpc kernel: [ 5751.201055]  00000000000189c0 0100010000000001 0000000000000003 ffff8801b5ce3c38
Jun 22 22:37:22 xpc kernel: [ 5751.201057]  ffffffff8106d810 0000000000000000 ffff8801bfbd2b48 ffff8801bfbd2b18
Jun 22 22:37:22 xpc kernel: [ 5751.201058]  ffff8801b5ce3bb8 ffffffff810fbb31 ffff8801af876960 ffff8801b5ce3c38
Jun 22 22:37:22 xpc kernel: [ 5751.201059] Call Trace:
Jun 22 22:37:22 xpc kernel: [ 5751.201062]  [<ffffffff8106d810>] ? leave_mm+0xe0/0xe0
Jun 22 22:37:22 xpc kernel: [ 5751.201063]  [<ffffffff810fbb31>] on_each_cpu+0x31/0x60
Jun 22 22:37:22 xpc kernel: [ 5751.201064]  [<ffffffff8106dd1c>] flush_tlb_kernel_range+0x3c/0x60
Jun 22 22:37:22 xpc kernel: [ 5751.201066]  [<ffffffff811c069a>] ? free_vmap_block+0x6a/0x80
Jun 22 22:37:22 xpc kernel: [ 5751.201069]  [<ffffffff813ce635>] ? find_next_bit+0x15/0x30
Jun 22 22:37:22 xpc kernel: [ 5751.201070]  [<ffffffff811c09b5>] __purge_vmap_area_lazy+0x305/0x380
Jun 22 22:37:22 xpc kernel: [ 5751.201071]  [<ffffffff811c0b57>] vm_unmap_aliases+0x127/0x140
Jun 22 22:37:22 xpc kernel: [ 5751.201073]  [<ffffffff8106993f>] change_page_attr_set_clr+0xdf/0x480
Jun 22 22:37:22 xpc kernel: [ 5751.201076]  [<ffffffff816eb642>] ? bpf_convert_filter+0x9b2/0xa00
Jun 22 22:37:22 xpc kernel: [ 5751.201077]  [<ffffffff8106a7af>] set_memory_ro+0x2f/0x40
Jun 22 22:37:22 xpc kernel: [ 5751.201080]  [<ffffffff81169e89>] bpf_prog_select_runtime+0x29/0x40
Jun 22 22:37:22 xpc kernel: [ 5751.201081]  [<ffffffff816eb7d0>] bpf_prepare_filter+0x140/0x170
Jun 22 22:37:22 xpc kernel: [ 5751.201082]  [<ffffffff816ebb46>] sk_attach_filter+0xf6/0x1a0
Jun 22 22:37:22 xpc kernel: [ 5751.201085]  [<ffffffff816bea55>] sock_setsockopt+0x3f5/0x990
Jun 22 22:37:22 xpc kernel: [ 5751.201086]  [<ffffffff816b58d7>] ? sock_alloc_file+0x97/0x110
Jun 22 22:37:22 xpc kernel: [ 5751.201088]  [<ffffffff816b94e6>] SyS_setsockopt+0xb6/0xd0
Jun 22 22:37:22 xpc kernel: [ 5751.201089]  [<ffffffff817e29b2>] system_call_fastpath+0x16/0x75
Jun 22 22:37:22 xpc kernel: [ 5751.201090] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:37:38 xpc kernel: [ 5767.204289] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [gcc:27663]
Jun 22 22:37:38 xpc kernel: [ 5767.204291] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:37:38 xpc kernel: [ 5767.204320] CPU: 3 PID: 27663 Comm: gcc Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:37:38 xpc kernel: [ 5767.204321] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:37:38 xpc kernel: [ 5767.204322] task: ffff880106a8bc60 ti: ffff880106548000 task.ti: ffff880106548000
Jun 22 22:37:38 xpc kernel: [ 5767.204323] RIP: 0010:[<ffffffff810fb970>]  [<ffffffff810fb970>] smp_call_function_many+0x220/0x280
Jun 22 22:37:38 xpc kernel: [ 5767.204325] RSP: 0018:ffff88010654ba28  EFLAGS: 00000202
Jun 22 22:37:38 xpc kernel: [ 5767.204325] RAX: 0000000000000003 RBX: ffff8801bfdf8e38 RCX: 0000000000000001
Jun 22 22:37:38 xpc kernel: [ 5767.204326] RDX: ffff8801bfa5bf00 RSI: 0000000000000100 RDI: ffff8801bfad8a08
Jun 22 22:37:38 xpc kernel: [ 5767.204327] RBP: ffff88010654ba68 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:37:38 xpc kernel: [ 5767.204327] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000293
Jun 22 22:37:38 xpc kernel: [ 5767.204328] R13: ffff88010654b9d8 R14: ffff8801984b4278 R15: 000000000001c6ef
Jun 22 22:37:38 xpc kernel: [ 5767.204329] FS:  00007fb3c7bfb740(0000) GS:ffff8801bfac0000(0000) knlGS:0000000000000000
Jun 22 22:37:38 xpc kernel: [ 5767.204330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:37:38 xpc kernel: [ 5767.204330] CR2: 00007f911727c458 CR3: 000000010645e000 CR4: 00000000001407e0
Jun 22 22:37:38 xpc kernel: [ 5767.204331] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:37:38 xpc kernel: [ 5767.204332] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:37:38 xpc kernel: [ 5767.204332] Stack:
Jun 22 22:37:38 xpc kernel: [ 5767.204333]  00000000000189c0 0100000000000001 0000000000000000 0000000000000003
Jun 22 22:37:38 xpc kernel: [ 5767.204334]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:37:38 xpc kernel: [ 5767.204335]  ffff88010654ba98 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:37:38 xpc kernel: [ 5767.204337] Call Trace:
Jun 22 22:37:38 xpc kernel: [ 5767.204339]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:37:38 xpc kernel: [ 5767.204340]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:37:38 xpc kernel: [ 5767.204341]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:37:38 xpc kernel: [ 5767.204343]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:37:38 xpc kernel: [ 5767.204346]  [<ffffffff811d3131>] alloc_pages_current+0x91/0x110
Jun 22 22:37:38 xpc kernel: [ 5767.204347]  [<ffffffff811de4eb>] new_slab+0x38b/0x480
Jun 22 22:37:38 xpc kernel: [ 5767.204348]  [<ffffffff811de9bf>] __slab_alloc+0x3df/0x4d0
Jun 22 22:37:38 xpc kernel: [ 5767.204351]  [<ffffffff81077173>] ? copy_process.part.26+0xf3/0x1a70
Jun 22 22:37:38 xpc kernel: [ 5767.204354]  [<ffffffff817ddd57>] ? __schedule+0x397/0xa10
Jun 22 22:37:38 xpc kernel: [ 5767.204355]  [<ffffffff811df1c9>] kmem_cache_alloc_node+0x89/0x230
Jun 22 22:37:38 xpc kernel: [ 5767.204356]  [<ffffffff81077173>] ? copy_process.part.26+0xf3/0x1a70
Jun 22 22:37:38 xpc kernel: [ 5767.204357]  [<ffffffff81077173>] copy_process.part.26+0xf3/0x1a70
Jun 22 22:37:38 xpc kernel: [ 5767.204360]  [<ffffffff8101ddd9>] ? sched_clock+0x9/0x10
Jun 22 22:37:38 xpc kernel: [ 5767.204362]  [<ffffffff810a99bd>] ? sched_clock_cpu+0x9d/0xb0
Jun 22 22:37:38 xpc kernel: [ 5767.204364]  [<ffffffff81078ca1>] do_fork+0xd1/0x350
Jun 22 22:37:38 xpc kernel: [ 5767.204365]  [<ffffffff811fa61a>] ? filp_close+0x5a/0x80
Jun 22 22:37:38 xpc kernel: [ 5767.204366]  [<ffffffff81078f8c>] sys_vfork+0x1c/0x20
Jun 22 22:37:38 xpc kernel: [ 5767.204367]  [<ffffffff817e29b2>] system_call_fastpath+0x16/0x75
Jun 22 22:37:38 xpc kernel: [ 5767.204368] Code: cb 11 c4 00 89 c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 <f3> 90 8b 42 18 a8 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6
Jun 22 22:37:46 xpc kernel: [ 5775.179969] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [systemd-journal:399]
Jun 22 22:37:46 xpc kernel: [ 5775.179970] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:37:46 xpc kernel: [ 5775.180010] CPU: 2 PID: 399 Comm: systemd-journal Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:37:46 xpc kernel: [ 5775.180011] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:37:46 xpc kernel: [ 5775.180012] task: ffff880036334670 ti: ffff880035914000 task.ti: ffff880035914000
Jun 22 22:37:46 xpc kernel: [ 5775.180013] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:37:46 xpc kernel: [ 5775.180016] RSP: 0018:ffff880035917af8  EFLAGS: 00000202
Jun 22 22:37:46 xpc kernel: [ 5775.180017] RAX: 0000000000000003 RBX: ffff8801bfdfa078 RCX: 0000000000000001
Jun 22 22:37:46 xpc kernel: [ 5775.180018] RDX: ffff8801bfa5bac8 RSI: 0000000000000100 RDI: ffff8801bfa98a08
Jun 22 22:37:46 xpc kernel: [ 5775.180019] RBP: ffff880035917b38 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:37:46 xpc kernel: [ 5775.180020] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000297
Jun 22 22:37:46 xpc kernel: [ 5775.180021] R13: ffff880035917aa8 R14: ffff8800359d66f8 R15: 0000000000401b5f
Jun 22 22:37:46 xpc kernel: [ 5775.180022] FS:  00007fe239f58880(0000) GS:ffff8801bfa80000(0000) knlGS:0000000000000000
Jun 22 22:37:46 xpc kernel: [ 5775.180024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:37:46 xpc kernel: [ 5775.180025] CR2: 00007f63f00050a8 CR3: 00000000359ae000 CR4: 00000000001407e0
Jun 22 22:37:46 xpc kernel: [ 5775.180026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:37:46 xpc kernel: [ 5775.180027] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:37:46 xpc kernel: [ 5775.180027] Stack:
Jun 22 22:37:46 xpc kernel: [ 5775.180028]  00000000000189c0 0100000000000001 0000000000000000 0000000000000002
Jun 22 22:37:46 xpc kernel: [ 5775.180030]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:37:46 xpc kernel: [ 5775.180032]  ffff880035917b68 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:37:46 xpc kernel: [ 5775.180034] Call Trace:
Jun 22 22:37:46 xpc kernel: [ 5775.180036]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:37:46 xpc kernel: [ 5775.180038]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:37:46 xpc kernel: [ 5775.180040]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:37:46 xpc kernel: [ 5775.180042]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:37:46 xpc kernel: [ 5775.180044]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:37:46 xpc kernel: [ 5775.180047]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:37:46 xpc kernel: [ 5775.180049]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:37:46 xpc kernel: [ 5775.180051]  [<ffffffff811bb2ff>] ? do_mmap_pgoff+0x30f/0x3f0
Jun 22 22:37:46 xpc kernel: [ 5775.180052]  [<ffffffff811b93d0>] ? vma_merge+0x230/0x370
Jun 22 22:37:46 xpc kernel: [ 5775.180055]  [<ffffffff811a1569>] ? vm_mmap_pgoff+0x99/0xc0
Jun 22 22:37:46 xpc kernel: [ 5775.180056]  [<ffffffff811ba6eb>] ? do_brk+0x22b/0x310
Jun 22 22:37:46 xpc kernel: [ 5775.180058]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:37:46 xpc kernel: [ 5775.180060]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:37:46 xpc kernel: [ 5775.180062]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:37:46 xpc kernel: [ 5775.180063] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:37:46 xpc kernel: [ 5775.227895] NMI watchdog: BUG: soft lockup - CPU#6 stuck for 22s! [kernel_oops:25728]
Jun 22 22:37:46 xpc kernel: [ 5775.227896] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:37:46 xpc kernel: [ 5775.227935] CPU: 6 PID: 25728 Comm: kernel_oops Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:37:46 xpc kernel: [ 5775.227936] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:37:46 xpc kernel: [ 5775.227937] task: ffff880035c5b250 ti: ffff8801b0364000 task.ti: ffff8801b0364000
Jun 22 22:37:46 xpc kernel: [ 5775.227938] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:37:46 xpc kernel: [ 5775.227940] RSP: 0018:ffff8801b0367818  EFLAGS: 00000202
Jun 22 22:37:46 xpc kernel: [ 5775.227941] RAX: 0000000000000003 RBX: ffff8801bfb979b0 RCX: 0000000000000001
Jun 22 22:37:46 xpc kernel: [ 5775.227942] RDX: ffff8801bfa5bf60 RSI: 0000000000000100 RDI: ffff8801bfb98a08
Jun 22 22:37:46 xpc kernel: [ 5775.227943] RBP: ffff8801b0367858 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:37:46 xpc kernel: [ 5775.227944] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000293
Jun 22 22:37:46 xpc kernel: [ 5775.227945] R13: ffff8801b03677c8 R14: ffffffff810ace9c R15: ffff8801b03677c8
Jun 22 22:37:46 xpc kernel: [ 5775.227946] FS:  00007f7e7e9df700(0000) GS:ffff8801bfb80000(0000) knlGS:0000000000000000
Jun 22 22:37:46 xpc kernel: [ 5775.227947] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:37:46 xpc kernel: [ 5775.227948] CR2: 00007f7e78400000 CR3: 0000000102a18000 CR4: 00000000001407e0
Jun 22 22:37:46 xpc kernel: [ 5775.227950] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:37:46 xpc kernel: [ 5775.227951] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:37:46 xpc kernel: [ 5775.227951] Stack:
Jun 22 22:37:46 xpc kernel: [ 5775.227952]  00000000000189c0 01ff880100000001 ffff880100000000 0000000000000006
Jun 22 22:37:46 xpc kernel: [ 5775.227954]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:37:46 xpc kernel: [ 5775.227956]  ffff8801b0367888 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:37:46 xpc kernel: [ 5775.227958] Call Trace:
Jun 22 22:37:46 xpc kernel: [ 5775.227960]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:37:46 xpc kernel: [ 5775.227961]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:37:46 xpc kernel: [ 5775.227963]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:37:46 xpc kernel: [ 5775.227965]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:37:46 xpc kernel: [ 5775.227967]  [<ffffffff811d4fef>] alloc_pages_vma+0x1df/0x200
Jun 22 22:37:46 xpc kernel: [ 5775.227969]  [<ffffffff811ea394>] do_huge_pmd_anonymous_page+0x104/0x3f0
Jun 22 22:37:46 xpc kernel: [ 5775.227971]  [<ffffffff811b3ab0>] handle_mm_fault+0x210/0x16f0
Jun 22 22:37:46 xpc kernel: [ 5775.227975]  [<ffffffff810126f3>] ? __switch_to+0x263/0x5d0
Jun 22 22:37:46 xpc kernel: [ 5775.227977]  [<ffffffff810b2cdf>] ? put_prev_task_fair+0x2f/0x50
Jun 22 22:37:46 xpc kernel: [ 5775.227979]  [<ffffffff817ddd57>] ? __schedule+0x397/0xa10
Jun 22 22:37:46 xpc kernel: [ 5775.227981]  [<ffffffff81066c24>] __do_page_fault+0x1c4/0x490
Jun 22 22:37:46 xpc kernel: [ 5775.227983]  [<ffffffff81066f1f>] do_page_fault+0x2f/0x80
Jun 22 22:37:46 xpc kernel: [ 5775.227984]  [<ffffffff817e4958>] page_fault+0x28/0x30
Jun 22 22:37:46 xpc kernel: [ 5775.227987]  [<ffffffff813cd698>] ? copy_page_to_iter+0x68/0x330
Jun 22 22:37:46 xpc kernel: [ 5775.227989]  [<ffffffff8118466d>] ? pagecache_get_page+0x2d/0x1a0
Jun 22 22:37:46 xpc kernel: [ 5775.227990]  [<ffffffff811853f1>] generic_file_read_iter+0x281/0x650
Jun 22 22:37:46 xpc kernel: [ 5775.227993]  [<ffffffff81114f12>] ? from_kgid_munged+0x12/0x20
Jun 22 22:37:46 xpc kernel: [ 5775.227995]  [<ffffffff811fcbfb>] __vfs_read+0xab/0xf0
Jun 22 22:37:46 xpc kernel: [ 5775.227997]  [<ffffffff811fd23a>] vfs_read+0x8a/0x140
Jun 22 22:37:46 xpc kernel: [ 5775.227998]  [<ffffffff811fe0f6>] SyS_read+0x46/0xb0
Jun 22 22:37:46 xpc kernel: [ 5775.228000]  [<ffffffff81066f1f>] ? do_page_fault+0x2f/0x80
Jun 22 22:37:46 xpc kernel: [ 5775.228001]  [<ffffffff817e29b2>] system_call_fastpath+0x16/0x75
Jun 22 22:37:46 xpc kernel: [ 5775.228002] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:37:50 xpc kernel: [ 5779.157824] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [colord-sane:25738]
Jun 22 22:37:50 xpc kernel: [ 5779.157826] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:37:50 xpc kernel: [ 5779.157854] CPU: 0 PID: 25738 Comm: colord-sane Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:37:50 xpc kernel: [ 5779.157855] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:37:50 xpc kernel: [ 5779.157856] task: ffff88009d40da90 ti: ffff8801b5ce0000 task.ti: ffff8801b5ce0000
Jun 22 22:37:50 xpc kernel: [ 5779.157857] RIP: 0010:[<ffffffff810fb975>]  [<ffffffff810fb975>] smp_call_function_many+0x225/0x280
Jun 22 22:37:50 xpc kernel: [ 5779.157859] RSP: 0018:ffff8801b5ce3b48  EFLAGS: 00000202
Jun 22 22:37:50 xpc kernel: [ 5779.157860] RAX: 0000000000000003 RBX: ffff8801b5ce3ae8 RCX: 0000000000000001
Jun 22 22:37:50 xpc kernel: [ 5779.157861] RDX: ffff8801bfa5b378 RSI: 0000000000000100 RDI: ffff8801bfa18a08
Jun 22 22:37:50 xpc kernel: [ 5779.157861] RBP: ffff8801b5ce3b88 R08: ffffffffffffffff R09: 0000000000000000
Jun 22 22:37:50 xpc kernel: [ 5779.157862] R10: 0000000000000004 R11: ffffea0002316f80 R12: 0000000000000293
Jun 22 22:37:50 xpc kernel: [ 5779.157863] R13: ffff8801b5ce3af8 R14: ffff8801b018e668 R15: 0000000000000001
Jun 22 22:37:50 xpc kernel: [ 5779.157863] FS:  00007f4959ae1800(0000) GS:ffff8801bfa00000(0000) knlGS:0000000000000000
Jun 22 22:37:50 xpc kernel: [ 5779.157864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:37:50 xpc kernel: [ 5779.157865] CR2: 00007f4959b0c000 CR3: 00000001b01fa000 CR4: 00000000001407f0
Jun 22 22:37:50 xpc kernel: [ 5779.157866] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:37:50 xpc kernel: [ 5779.157866] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:37:50 xpc kernel: [ 5779.157867] Stack:
Jun 22 22:37:50 xpc kernel: [ 5779.157867]  00000000000189c0 0100010000000001 0000000000000003 ffff8801b5ce3c38
Jun 22 22:37:50 xpc kernel: [ 5779.157869]  ffffffff8106d810 0000000000000000 ffff8801bfbd2b48 ffff8801bfbd2b18
Jun 22 22:37:50 xpc kernel: [ 5779.157870]  ffff8801b5ce3bb8 ffffffff810fbb31 ffff8801af876960 ffff8801b5ce3c38
Jun 22 22:37:50 xpc kernel: [ 5779.157871] Call Trace:
Jun 22 22:37:50 xpc kernel: [ 5779.157873]  [<ffffffff8106d810>] ? leave_mm+0xe0/0xe0
Jun 22 22:37:50 xpc kernel: [ 5779.157874]  [<ffffffff810fbb31>] on_each_cpu+0x31/0x60
Jun 22 22:37:50 xpc kernel: [ 5779.157875]  [<ffffffff8106dd1c>] flush_tlb_kernel_range+0x3c/0x60
Jun 22 22:37:50 xpc kernel: [ 5779.157877]  [<ffffffff811c069a>] ? free_vmap_block+0x6a/0x80
Jun 22 22:37:50 xpc kernel: [ 5779.157878]  [<ffffffff813ce635>] ? find_next_bit+0x15/0x30
Jun 22 22:37:50 xpc kernel: [ 5779.157879]  [<ffffffff811c09b5>] __purge_vmap_area_lazy+0x305/0x380
Jun 22 22:37:50 xpc kernel: [ 5779.157881]  [<ffffffff811c0b57>] vm_unmap_aliases+0x127/0x140
Jun 22 22:37:50 xpc kernel: [ 5779.157882]  [<ffffffff8106993f>] change_page_attr_set_clr+0xdf/0x480
Jun 22 22:37:50 xpc kernel: [ 5779.157884]  [<ffffffff816eb642>] ? bpf_convert_filter+0x9b2/0xa00
Jun 22 22:37:50 xpc kernel: [ 5779.157885]  [<ffffffff8106a7af>] set_memory_ro+0x2f/0x40
Jun 22 22:37:50 xpc kernel: [ 5779.157887]  [<ffffffff81169e89>] bpf_prog_select_runtime+0x29/0x40
Jun 22 22:37:50 xpc kernel: [ 5779.157888]  [<ffffffff816eb7d0>] bpf_prepare_filter+0x140/0x170
Jun 22 22:37:50 xpc kernel: [ 5779.157889]  [<ffffffff816ebb46>] sk_attach_filter+0xf6/0x1a0
Jun 22 22:37:50 xpc kernel: [ 5779.157891]  [<ffffffff816bea55>] sock_setsockopt+0x3f5/0x990
Jun 22 22:37:50 xpc kernel: [ 5779.157892]  [<ffffffff816b58d7>] ? sock_alloc_file+0x97/0x110
Jun 22 22:37:50 xpc kernel: [ 5779.157894]  [<ffffffff816b94e6>] SyS_setsockopt+0xb6/0xd0
Jun 22 22:37:50 xpc kernel: [ 5779.157895]  [<ffffffff817e29b2>] system_call_fastpath+0x16/0x75
Jun 22 22:37:50 xpc kernel: [ 5779.157896] Code: c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 f3 90 8b 42 18 <a8> 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6 44 89 ef e8 c3
Jun 22 22:38:06 xpc kernel: [ 5795.161105] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [gcc:27663]
Jun 22 22:38:06 xpc kernel: [ 5795.161107] Modules linked in: binfmt_misc cfg80211 sp2 si2157 si2168 i2c_mux cx25840 snd_hda_codec_hdmi joydev eeepc_wmi asus_wmi sparse_keymap mxm_wmi cx23885 intel_rapl altera_ci iosf_mbi tda18271 x86_pkg_temp_thermal altera_stapl videobuf2_dvb intel_powerclamp tveeprom cx2341x snd_hda_codec_realtek kvm_intel dvb_core snd_hda_codec_generic kvm rc_core hid_logitech_hidpp videobuf2_dma_sg i915 snd_hda_intel videobuf2_memops crct10dif_pclmul videobuf2_core v4l2_common crc32_pclmul snd_hda_controller videodev ghash_clmulni_intel snd_hda_codec snd_hda_core aesni_intel media aes_x86_64 snd_hwdep lrw snd_pcm gf128mul snd_seq_midi snd_seq_midi_event glue_helper snd_rawmidi drm_kms_helper ablk_helper snd_seq snd_seq_device cryptd drm snd_timer snd mei_me i2c_algo_b
 it mei soundcore shpchp lpc_ich serio_raw wmi mac_hid video nfsd auth_rpcgss nfs_acl lockd nct6775 grace hwmon_vid sunrpc coretemp parport_pc ppdev lp parport autofs4 e1000e ptp raid10 raid!
 456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_logitech_dj raid1 raid6_pq raid0 usbhid psmouse multipath ahci hid libahci pps_core linear
Jun 22 22:38:06 xpc kernel: [ 5795.161140] CPU: 3 PID: 27663 Comm: gcc Tainted: G      D W    L  4.1.0-rc8 #2
Jun 22 22:38:06 xpc kernel: [ 5795.161141] Hardware name: ASUS All Series/MAXIMUS VI EXTREME, BIOS 1603 08/15/2014
Jun 22 22:38:06 xpc kernel: [ 5795.161142] task: ffff880106a8bc60 ti: ffff880106548000 task.ti: ffff880106548000
Jun 22 22:38:06 xpc kernel: [ 5795.161143] RIP: 0010:[<ffffffff810fb970>]  [<ffffffff810fb970>] smp_call_function_many+0x220/0x280
Jun 22 22:38:06 xpc kernel: [ 5795.161146] RSP: 0018:ffff88010654ba28  EFLAGS: 00000202
Jun 22 22:38:06 xpc kernel: [ 5795.161147] RAX: 0000000000000003 RBX: ffff8801bfdf8e38 RCX: 0000000000000001
Jun 22 22:38:06 xpc kernel: [ 5795.161147] RDX: ffff8801bfa5bf00 RSI: 0000000000000100 RDI: ffff8801bfad8a08
Jun 22 22:38:06 xpc kernel: [ 5795.161148] RBP: ffff88010654ba68 R08: fffffffffffffffe R09: 0000000000000000
Jun 22 22:38:06 xpc kernel: [ 5795.161149] R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000293
Jun 22 22:38:06 xpc kernel: [ 5795.161149] R13: ffff88010654b9d8 R14: ffff8801984b4278 R15: 000000000001c6ef
Jun 22 22:38:06 xpc kernel: [ 5795.161150] FS:  00007fb3c7bfb740(0000) GS:ffff8801bfac0000(0000) knlGS:0000000000000000
Jun 22 22:38:06 xpc kernel: [ 5795.161151] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 22 22:38:06 xpc kernel: [ 5795.161152] CR2: 00007f911727c458 CR3: 000000010645e000 CR4: 00000000001407e0
Jun 22 22:38:06 xpc kernel: [ 5795.161152] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 22 22:38:06 xpc kernel: [ 5795.161153] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jun 22 22:38:06 xpc kernel: [ 5795.161154] Stack:
Jun 22 22:38:06 xpc kernel: [ 5795.161154]  00000000000189c0 0100000000000001 0000000000000000 0000000000000003
Jun 22 22:38:06 xpc kernel: [ 5795.161156]  ffffffff81fc0020 ffffffff8118b520 0000000000000000 0000000000000007
Jun 22 22:38:06 xpc kernel: [ 5795.161157]  ffff88010654ba98 ffffffff810fbb88 0000000000000100 0000000000000000
Jun 22 22:38:06 xpc kernel: [ 5795.161158] Call Trace:
Jun 22 22:38:06 xpc kernel: [ 5795.161161]  [<ffffffff8118b520>] ? page_alloc_cpu_notify+0x50/0x50
Jun 22 22:38:06 xpc kernel: [ 5795.161162]  [<ffffffff810fbb88>] on_each_cpu_mask+0x28/0x60
Jun 22 22:38:06 xpc kernel: [ 5795.161164]  [<ffffffff8118954b>] drain_all_pages+0xeb/0x100
Jun 22 22:38:06 xpc kernel: [ 5795.161165]  [<ffffffff8118d7c6>] __alloc_pages_nodemask+0x6c6/0xa70
Jun 22 22:38:06 xpc kernel: [ 5795.161168]  [<ffffffff811d3131>] alloc_pages_current+0x91/0x110
Jun 22 22:38:06 xpc kernel: [ 5795.161170]  [<ffffffff811de4eb>] new_slab+0x38b/0x480
Jun 22 22:38:06 xpc kernel: [ 5795.161171]  [<ffffffff811de9bf>] __slab_alloc+0x3df/0x4d0
Jun 22 22:38:06 xpc kernel: [ 5795.161173]  [<ffffffff81077173>] ? copy_process.part.26+0xf3/0x1a70
Jun 22 22:38:06 xpc kernel: [ 5795.161175]  [<ffffffff817ddd57>] ? __schedule+0x397/0xa10
Jun 22 22:38:06 xpc kernel: [ 5795.161177]  [<ffffffff811df1c9>] kmem_cache_alloc_node+0x89/0x230
Jun 22 22:38:06 xpc kernel: [ 5795.161178]  [<ffffffff81077173>] ? copy_process.part.26+0xf3/0x1a70
Jun 22 22:38:06 xpc kernel: [ 5795.161179]  [<ffffffff81077173>] copy_process.part.26+0xf3/0x1a70
Jun 22 22:38:06 xpc kernel: [ 5795.161181]  [<ffffffff8101ddd9>] ? sched_clock+0x9/0x10
Jun 22 22:38:06 xpc kernel: [ 5795.161183]  [<ffffffff810a99bd>] ? sched_clock_cpu+0x9d/0xb0
Jun 22 22:38:06 xpc kernel: [ 5795.161184]  [<ffffffff81078ca1>] do_fork+0xd1/0x350
Jun 22 22:38:06 xpc kernel: [ 5795.161186]  [<ffffffff811fa61a>] ? filp_close+0x5a/0x80
Jun 22 22:38:06 xpc kernel: [ 5795.161187]  [<ffffffff81078f8c>] sys_vfork+0x1c/0x20
Jun 22 22:38:06 xpc kernel: [ 5795.161188]  [<ffffffff817e29b2>] system_call_fastpath+0x16/0x75
Jun 22 22:38:06 xpc kernel: [ 5795.161189] Code: cb 11 c4 00 89 c1 0f 8d 79 fe ff ff 48 98 49 8b 55 00 48 03 14 c5 00 ab d3 81 8b 42 18 a8 01 74 ca 66 2e 0f 1f 84 00 00 00 00 00 <f3> 90 8b 42 18 a8 01 75 f7 eb b5 0f b6 4d c8 4c 89 fa 4c 89 f6

The filesystems on LVM:

sudo tune2fs -l /dev//mapper/xpcvg-home
tune2fs 1.42.12 (29-Aug-2014)
Filesystem volume name:   <none>
Last mounted on:          /home
Filesystem UUID:          db583624-afb4-41cb-8b2d-640bee2de61b
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent sparse_super large_file uninit_bg
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              65536000
Block count:              262144000
Reserved block count:     13107200
Free blocks:              199344244
Free inodes:              65338714
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      961
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              128
RAID stripe width:        384
Filesystem created:       Mon Jul 25 12:23:50 2011
Last mount time:          Mon Jun 22 21:07:06 2015
Last write time:          Mon Jun 22 21:07:06 2015
Mount count:              35
Maximum mount count:      157
Last checked:             Mon Jun 15 12:21:47 2015
Check interval:           15552000 (6 months)
Next check after:         Sat Dec 12 11:21:47 2015
Lifetime writes:          500 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       65143016
Default directory hash:   half_md4
Directory Hash Seed:      ea4a0233-d8af-4c51-9302-140a4affacdf
Journal backup:           inode blocks

sudo tune2fs -l /dev//mapper/xpcvg-data
tune2fs 1.42.12 (29-Aug-2014)
Filesystem volume name:   <none>
Last mounted on:          /backup
Filesystem UUID:          1949c800-eb8c-4368-b809-3e2606c33d83
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent sparse_super large_file uninit_bg
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              42008576
Block count:              168034304
Reserved block count:     8401715
Free blocks:              114693777
Free inodes:              42005415
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      983
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              128
RAID stripe width:        384
Filesystem created:       Sun Jul 10 16:17:30 2011
Last mount time:          Mon Jun 22 21:04:50 2015
Last write time:          Mon Jun 22 21:04:50 2015
Mount count:              40
Maximum mount count:      157
Last checked:             Sat Jun  6 22:02:49 2015
Check interval:           15552000 (6 months)
Next check after:         Thu Dec  3 21:02:49 2015
Lifetime writes:          1889 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      a45f9ba2-ceb3-4a22-ab77-a2d5af71b82a
Journal backup:           inode blocks
sudo tune2fs -l /dev//mapper/xpcvg-video
tune2fs 1.42.12 (29-Aug-2014)
Filesystem volume name:   <none>
Last mounted on:          /var/lib/video.00
Filesystem UUID:          0a8f2b37-4a27-4a06-b236-971af0cf1907
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent sparse_super large_file uninit_bg
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              256114688
Block count:              1024458752
Reserved block count:     51222927
Free blocks:              463675406
Free inodes:              256097372
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      779
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              128
RAID stripe width:        384
Filesystem created:       Mon Sep 21 21:47:18 2009
Last mount time:          Mon Jun 22 21:04:50 2015
Last write time:          Mon Jun 22 21:04:50 2015
Mount count:              137
Maximum mount count:      200
Last checked:             Thu Apr 16 06:08:46 2015
Check interval:           17280000 (6 months, 2 weeks, 6 days)
Next check after:         Mon Nov  2 05:08:46 2015
Lifetime writes:          15 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      ef0f022c-b41f-4a14-9957-e0f69e74987b
Journal backup:           inode blocks

yours,
		Jouni
