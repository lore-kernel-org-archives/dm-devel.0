From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: dm-rdac not working?
Date: Mon, 27 Aug 2007 10:33:46 -0700
Message-ID: <1188236026.9504.10.camel@linuxchandra>
References: <46D2E298.1020702@linpro.no>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46D2E298.1020702@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2007-08-27 at 16:41 +0200, Tore Anderson wrote:

Looks like the MODE_SELECT command (to change the passive path to be
active) that is sent to the device is failing (for whatever reason) and
hence that path is not getting activated.

What version of multipath tools are you using ?

Can you attach your multipath.conf file. You should be using the rdac
path checker instead of the tur path checker. 

Can you attach the o/p of "multipath -ll"

Look below for more comments.

>   I've got a Sun StorageTek 6140 (an Engenio 3994 with a Sun sticker),
>  which is an RDAC active/passive array.  When I configure it to use RDAC
>  mode and set up my host (2.6.23-rc3, x86_64) to use the rdac hardware
>  handler, it doesn't really seem to work.  I yank the two paths to the
>  active controller using "echo 1 > /sys/block/$dev/device/delete" while
>  generating heavy I/O and wait for a pg switch to happen, but all I get
>  in the logs is the following:
> 
> Aug 27 16:17:45 atalanta multipathd: sdj: remove path (uevent)
> Aug 27 16:17:45 atalanta kernel: [264107.296729] sd 4:0:1:1: [sdj] Synchronizing SCSI cache
> Aug 27 16:17:45 atalanta kernel: [264107.296894] device-mapper: multipath rdac: using RDAC command with timeout 6000
> Aug 27 16:17:45 atalanta kernel: [264107.297271] device-mapper: multipath: Failing path 8:144.
> Aug 27 16:17:47 atalanta multipathd: mysql: load table [0 41943040 multipath 0 1 rdac 2 1 round-robin 0 1 1 8:96 1000 round-robin 0 2 1 8:64 1000 8:112 1000]
> Aug 27 16:18:10 atalanta multipathd: sdg: remove path (uevent)
> Aug 27 16:18:10 atalanta kernel: [264131.733301] sd 3:0:1:1: [sdg] Synchronizing SCSI cache
> Aug 27 16:18:10 atalanta kernel: [264131.733435] device-mapper: multipath rdac: using RDAC command with timeout 6000
> Aug 27 16:18:10 atalanta kernel: [264131.759010] device-mapper: multipath: Failing path 8:96.

> Aug 27 16:18:10 atalanta kernel: [264131.829770] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:64
> Aug 27 16:19:12 atalanta kernel: [264193.753980] device-mapper: multipath: Failing path 8:64.
> Aug 27 16:19:12 atalanta kernel: [264193.754944] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:112
> Aug 27 16:20:14 atalanta kernel: [264255.632988] device-mapper: multipath: Failing path 8:112.

I presume 8:64 and 8:112 are the devices corresponding to other paths of
the device.

You can see that the MODE_SELECT command is sent and immediately the
path is failed (which means the MODE_SELECT command has failed).

And this the same thing that repeats below.

> Aug 27 16:20:14 atalanta kernel: [264255.633032] printk: 12 messages suppressed.
> Aug 27 16:20:14 atalanta kernel: [264255.633035] Buffer I/O error on device dm-4, logical block 1821127
> Aug 27 16:20:14 atalanta kernel: [264255.670535] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.670545] Buffer I/O error on device dm-4, logical block 1821128
> Aug 27 16:20:14 atalanta kernel: [264255.708064] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.708070] Buffer I/O error on device dm-4, logical block 1821129
> Aug 27 16:20:14 atalanta kernel: [264255.745599] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.745608] Buffer I/O error on device dm-4, logical block 1821130
> Aug 27 16:20:14 atalanta kernel: [264255.783080] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.783089] Buffer I/O error on device dm-4, logical block 1821131
> Aug 27 16:20:14 atalanta kernel: [264255.820614] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.820622] Buffer I/O error on device dm-4, logical block 1821132
> Aug 27 16:20:14 atalanta kernel: [264255.858158] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.858165] Buffer I/O error on device dm-4, logical block 1821133
> Aug 27 16:20:14 atalanta kernel: [264255.895633] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.895639] Buffer I/O error on device dm-4, logical block 1821134
> Aug 27 16:20:14 atalanta kernel: [264255.933099] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.933105] Buffer I/O error on device dm-4, logical block 1821135
> Aug 27 16:20:14 atalanta kernel: [264255.970556] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264255.970562] Buffer I/O error on device dm-4, logical block 1821136
> Aug 27 16:20:14 atalanta kernel: [264256.008010] lost page write due to I/O error on dm-4
> Aug 27 16:20:14 atalanta kernel: [264256.061324] Aborting journal on device dm-4.
> Aug 27 16:20:14 atalanta kernel: [264256.088223] journal commit I/O error
> Aug 27 16:20:14 atalanta kernel: [264256.113352] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113383] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113401] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113405] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113409] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113413] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113418] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113422] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113425] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113477] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113541] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113547] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113557] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113565] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113583] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.113771] __journal_remove_journal_head: freeing b_committed_data
> Aug 27 16:20:14 atalanta kernel: [264256.114328] WARNING: at fs/buffer.c:1154 mark_buffer_dirty()
> Aug 27 16:20:14 atalanta kernel: [264256.114329] 
> Aug 27 16:20:14 atalanta kernel: [264256.114330] Call Trace:
> Aug 27 16:20:14 atalanta kernel: [264256.114347]  [mark_buffer_dirty+117/144] mark_buffer_dirty+0x75/0x90
> Aug 27 16:20:14 atalanta kernel: [264256.114359]  [_end+128966711/2129771920] :ext3:ext3_commit_super+0x57/0xa0
> Aug 27 16:20:14 atalanta kernel: [264256.114364]  [freeze_bdev+138/176] freeze_bdev+0x8a/0xb0
> Aug 27 16:20:14 atalanta kernel: [264256.114374]  [_end+128731225/2129771920] :dm_mod:dm_suspend+0x119/0x450
> Aug 27 16:20:14 atalanta kernel: [264256.114379]  [default_wake_function+0/16] default_wake_function+0x0/0x10
> Aug 27 16:20:14 atalanta kernel: [264256.114383]  [__up_write+49/368] __up_write+0x31/0x170
> Aug 27 16:20:14 atalanta kernel: [264256.114390]  [_end+128744272/2129771920] :dm_mod:dev_suspend+0x0/0x210
> Aug 27 16:20:14 atalanta kernel: [264256.114396]  [_end+128744602/2129771920] :dm_mod:dev_suspend+0x14a/0x210
> Aug 27 16:20:14 atalanta kernel: [264256.114402]  [_end+128742063/2129771920] :dm_mod:ctl_ioctl+0x1df/0x2e0
> Aug 27 16:20:14 atalanta kernel: [264256.114406]  [do_wp_page+964/1280] do_wp_page+0x3c4/0x500
> Aug 27 16:20:14 atalanta kernel: [264256.114416]  [do_ioctl+125/192] do_ioctl+0x7d/0xc0
> Aug 27 16:20:14 atalanta kernel: [264256.114418]  [vfs_ioctl+116/720] vfs_ioctl+0x74/0x2d0
> Aug 27 16:20:14 atalanta kernel: [264256.114421]  [sys_ioctl+149/176] sys_ioctl+0x95/0xb0
> Aug 27 16:20:14 atalanta kernel: [264256.114425]  [system_call+126/131] system_call+0x7e/0x83
> Aug 27 16:20:14 atalanta kernel: [264256.114428] 
> Aug 27 16:20:14 atalanta kernel: [264256.128587] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:64
> Aug 27 16:21:16 atalanta kernel: [264318.014646] device-mapper: multipath: Failing path 8:64.
> Aug 27 16:21:16 atalanta kernel: [264318.014987] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:112
> Aug 27 16:22:18 atalanta kernel: [264379.906125] device-mapper: multipath: Failing path 8:112.
> Aug 27 16:22:18 atalanta kernel: [264379.906159] printk: 22947 messages suppressed.
> Aug 27 16:22:18 atalanta kernel: [264379.906163] Buffer I/O error on device dm-4, logical block 0
> Aug 27 16:22:18 atalanta kernel: [264379.940530] lost page write due to I/O error on dm-4
> Aug 27 16:22:18 atalanta kernel: [264379.940562] ext3_abort called.
> Aug 27 16:22:18 atalanta multipathd: mysql: load table [0 41943040 multipath 0 1 rdac 1 1 round-robin 0 2 1 8:64 1000 8:112 1000]
> Aug 27 16:22:18 atalanta kernel: [264379.959340] EXT3-fs error (device dm-4): ext3_journal_start_sb: Detected aborted journal
> Aug 27 16:22:18 atalanta kernel: [264380.008425] Remounting filesystem read-only
> Aug 27 16:22:18 atalanta kernel: [264380.035388] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:112
> Aug 27 16:23:20 atalanta kernel: [264441.923876] device-mapper: multipath: Failing path 8:112.
> Aug 27 16:23:20 atalanta multipathd: 8:112: mark as failed
> Aug 27 16:23:20 atalanta multipathd: mysql: remaining active paths: 1
> Aug 27 16:23:20 atalanta kernel: [264441.924715] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:64
> Aug 27 16:23:30 atalanta multipathd: 8:112: tur checker reports path is up
> Aug 27 16:23:30 atalanta multipathd: 8:112: reinstated
> Aug 27 16:23:30 atalanta multipathd: mysql: remaining active paths: 2
> Aug 27 16:24:22 atalanta kernel: [264503.821431] device-mapper: multipath: Failing path 8:64.
> Aug 27 16:24:22 atalanta multipathd: 8:64: mark as failed
> Aug 27 16:24:22 atalanta multipathd: mysql: remaining active paths: 1
> Aug 27 16:24:22 atalanta kernel: [264503.822237] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:112
> Aug 27 16:24:32 atalanta multipathd: 8:64: tur checker reports path is up
> Aug 27 16:24:32 atalanta multipathd: 8:64: reinstated
> Aug 27 16:24:32 atalanta multipathd: mysql: remaining active paths: 2
> Aug 27 16:25:24 atalanta kernel: [264565.701064] device-mapper: multipath: Failing path 8:112.
> Aug 27 16:25:24 atalanta kernel: [264565.701395] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:64
> Aug 27 16:25:24 atalanta multipathd: 8:112: mark as failed
> Aug 27 16:25:24 atalanta multipathd: mysql: remaining active paths: 1
> Aug 27 16:25:35 atalanta multipathd: 8:112: tur checker reports path is up
> Aug 27 16:25:35 atalanta multipathd: 8:112: reinstated
> Aug 27 16:25:35 atalanta multipathd: mysql: remaining active paths: 2
> Aug 27 16:26:26 atalanta kernel: [264627.593359] device-mapper: multipath: Failing path 8:64.
> Aug 27 16:26:26 atalanta kernel: [264627.594446] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:112
> Aug 27 16:26:26 atalanta multipathd: 8:64: mark as failed
> Aug 27 16:26:26 atalanta multipathd: mysql: remaining active paths: 1
> Aug 27 16:26:37 atalanta multipathd: 8:64: tur checker reports path is up
> Aug 27 16:26:37 atalanta multipathd: 8:64: reinstated
> Aug 27 16:26:37 atalanta multipathd: mysql: remaining active paths: 2
> Aug 27 16:27:28 atalanta kernel: [264689.478050] device-mapper: multipath: Failing path 8:112.
> Aug 27 16:27:28 atalanta kernel: [264689.478771] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:64
> Aug 27 16:27:28 atalanta multipathd: 8:112: mark as failed
> Aug 27 16:27:28 atalanta multipathd: mysql: remaining active paths: 1
> Aug 27 16:27:39 atalanta multipathd: 8:112: tur checker reports path is up
> Aug 27 16:27:39 atalanta multipathd: 8:112: reinstated
> Aug 27 16:27:39 atalanta multipathd: mysql: remaining active paths: 2
> Aug 27 16:28:30 atalanta kernel: [264751.365417] device-mapper: multipath: Failing path 8:64.
> Aug 27 16:28:30 atalanta kernel: [264751.366649] device-mapper: multipath rdac: queueing MODE_SELECT command on 8:112
> Aug 27 16:28:30 atalanta multipathd: 8:64: mark as failed
> Aug 27 16:28:30 atalanta multipathd: mysql: remaining active paths: 1
> Aug 27 16:28:41 atalanta multipathd: 8:64: tur checker reports path is up
> Aug 27 16:28:41 atalanta multipathd: 8:64: reinstated
> Aug 27 16:28:41 atalanta multipathd: mysql: remaining active paths: 2
> 
>   The last messages appear to be looping forever.  The passive
>  controller never goes active, and there's nothing in the logs on the
>  array that indicates any attempt to move the volume.  It seems like the
>  hardware handler is simply broken...
> 
>   Another quite nasty thing is that even though I'm using
>  queue_if_no_path, I/O errors still made it up to the file system layer,
>  making it read-only.  Isn't that exactly what queue_if_no_path is
>  supposed to prevent?
> 
> Regards
> -- 
> Tore Anderson
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
