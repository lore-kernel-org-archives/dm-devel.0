From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: WARNING: at fs/block_dev.c:5 when removing LV on removed device
Date: Thu, 18 Jun 2015 14:04:08 -0400
Message-ID: <20150618180408.GD2321@redhat.com>
References: <20150618165713.GB19417@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150618165713.GB19417@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jun 18 2015 at 12:57pm -0400,
Andi Kleen <andi@firstfloor.org> wrote:

> 
> I was trying to remove a LVM logical volume on a hotplugged device
> that had been removed, to also remove its VG, which resulted in:
> 
> [1728002.718174] ------------[ cut here ]------------
> [1728002.718179] WARNING: CPU: 10 PID: 15454 at fs/block_dev.c:57
> __blkdev_put+0xc1/0x220()
> [1728002.718180] Modules linked in: dm_crypt mce_inject vfat fat bnep
> bluetooth rfkill xt_CHECKSUM iptable_mangle ipt_MASQUERADE
> nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
> nf_defrag_ipv4 xt_conntrack nf_conntrack tun bridge stp llc
> ebtable_filter ebtables ip6table_filter ip6_tables fuse
> snd_hda_codec_realtek x86_pkg_temp_thermal coretemp
> snd_hda_codec_generic snd_hda_codec_hdmi kvm_intel snd_hda_intel kvm
> snd_hda_controller iTCO_wdt xfs snd_hda_codec iTCO_vendor_support
> snd_hwdep snd_seq mxm_wmi snd_seq_device crct10dif_pclmul snd_pcm
> crc32_pclmul crc32c_intel snd_timer sb_edac snd libcrc32c mei_me
> ghash_clmulni_intel lpc_ich edac_core serio_raw i2c_i801 soundcore mei
> shpchp mfd_core nuvoton_cir rc_core wmi binfmt_misc uas usb_storage
> radeon i2c_algo_bit drm_kms_helper ttm
> [1728002.718209]  e1000e drm firewire_ohci firewire_core ptp pps_core
> crc_itu_t
> [1728002.718213] CPU: 10 PID: 15454 Comm: umount Not tainted
> 4.0.4-301.fc22.x86_64 #1
> [1728002.718214] Hardware name:                  /DX79SI, BIOS
> SIX7910D.86A.1827.2013.0701.1715 07/01/2013
> [1728002.718215]  0000000000000000 000000007fcff292 ffff88008f4abd98
> ffffffff81782644
> [1728002.718217]  0000000000000000 0000000000000000 ffff88008f4abdd8
> ffffffff8109c66a
> [1728002.718218]  0000000000000000 ffff8800c67584b8 ffff8800c6758340
> ffff8800c6758430
> [1728002.718220] Call Trace:
> [1728002.718224]  [<ffffffff81782644>] dump_stack+0x45/0x57
> [1728002.718226]  [<ffffffff8109c66a>] warn_slowpath_common+0x8a/0xc0
> [1728002.718228]  [<ffffffff8109c79a>] warn_slowpath_null+0x1a/0x20
> [1728002.718230]  [<ffffffff81258171>] __blkdev_put+0xc1/0x220
> [1728002.718231]  [<ffffffff81258760>] blkdev_put+0x50/0x130
> [1728002.718234]  [<ffffffff8121f9e1>] kill_block_super+0x41/0x80
> [1728002.718236]  [<ffffffff8121fd39>] deactivate_locked_super+0x49/0x80
> [1728002.718238]  [<ffffffff812201ac>] deactivate_super+0x6c/0x80
> [1728002.718241]  [<ffffffff8123ebb3>] cleanup_mnt+0x43/0xa0
> [1728002.718245]  [<ffffffff81140bd6>] ?
> __audit_syscall_exit+0x1f6/0x290
> [1728002.718246]  [<ffffffff8123ec62>] __cleanup_mnt+0x12/0x20
> [1728002.718249]  [<ffffffff810b9a24>] task_work_run+0xc4/0xe0
> [1728002.718252]  [<ffffffff81013d0d>] do_notify_resume+0x9d/0xa0
> [1728002.718255]  [<ffffffff81788ee3>] int_signal+0x12/0x17
> [1728002.718256] ---[ end trace 4975e97dd7331e63 ]---

Hmm, so you have a filesystem active on it too?
 
> Also the VG removal did not work of course.

Once you resolve the filesystem piece, from vgremove man page:

"vgremove allows you to remove one or more volume groups.  If one or
more physical volumes in the volume group are lost, consider vgreduce
--removemissing to make the volume group metadata consistent again."
