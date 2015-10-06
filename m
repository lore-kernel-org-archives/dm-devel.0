From: Andreas Hartmann <andihartmann-KuiJ5kEpwI6ELgA04lAiVw@public.gmane.org>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
	READ FPDMA QUEUED errors since Linux 4.0
Date: Tue, 6 Oct 2015 20:37:59 +0200
Message-ID: <56141507.7040103@maya.org>
References: <55B7D054.4070308@maya.org> <20150728192908.GA25264@redhat.com>
	<55BCD5A7.2080708@maya.org> <55BE1D5E.6020709@maya.org>
	<alpine.LRH.2.02.1508021347480.17729@file01.intranet.prod.int.rdu2.redhat.com>
	<55FE5740.2060701@maya.org> <20150929152100.GL3036@8bytes.org>
	<alpine.LRH.2.02.1509291143170.24174@file01.intranet.prod.int.rdu2.redhat.com>
	<20150929162042.GR3036@8bytes.org> <560BF73F.8000008@maya.org>
	<20151006101356.GE12506@8bytes.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000703020406070003070803"
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20151006101356.GE12506-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000703020406070003070803
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/06/2015 at 12:13 PM, Joerg Roedel wrote:
> On Wed, Sep 30, 2015 at 04:52:47PM +0200, Andreas Hartmann wrote:
>>> Alternativly someone who can reproduce it should trace the calls to
>>> __map_single and __unmap_single in the AMD IOMMU driver to find out
>>> whether the addresses which the faults happen on are really mapped, o=
r
>>> at least requested from the AMD IOMMU driver.
>>
>> How can I trace it?
>=20
> Please apply the attached debug patch on-top of Linux v4.3-rc3 and boot
> the machine. After boot you run (as root):
>=20
>=20
> 	# cat /sys/kernel/debug/tracing/trace_pipe > trace-data
>=20
> Please run this in a seperate shell an keep it running.
>=20
> Then trigger the problem while the above command is running. When you
> triggered it, please send me the (compressed) trace-data file, full
> dmesg and output of lspci on the box.

Hmm, *seems* to work fine w/ 4.3-rc2. But I have to do some more tests
to be really sure.


W/ 4.1.10, the problem can be seen most always during boot (systemd) -
but at this point, it is difficult to trace. I have to take a closer
look to find a place to start the trace already during boot process.


But there is another problem w/ 4.3-rc2: Starting a VM w/ PCIe
passthrough doesn't work any more. I'm getting the attached null pointer
dereference and the machine hangs.


Thanks,
regards,
Andreas

--------------000703020406070003070803
Content-Type: text/plain; charset=UTF-8;
 name="trace"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="trace"

Oct  6 20:11:18 localhost kernel: [   32.461794] BUG: unable to handle ke=
rnel NULL pointer dereference at 00000000000000b8
Oct  6 20:11:18 localhost kernel: [   32.461853] IP: [<ffffffff8147a8a4>]=
 do_detach+0x24/0xa0
Oct  6 20:11:18 localhost kernel: [   32.461888] PGD 0=20
Oct  6 20:11:18 localhost kernel: [   32.461902] Oops: 0002 [#1] PREEMPT =
SMP=20
Oct  6 20:11:18 localhost kernel: [   32.461929] Modules linked in: nf_lo=
g_ipv4 nf_log_common xt_LOG ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_def=
rag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables vfio=
_iommu_type1 vfio_pci vfio vfio_virqfd drbg ansi_cprng nfsd lockd grace n=
fs_acl auth_rpcgss sunrpc bridge stp llc tun it87 hwmon_vid snd_hda_codec=
_hdmi kvm_amd snd_hda_codec_realtek kvm snd_hda_codec_generic fam15h_powe=
r usb_storage snd_hda_intel pcspkr serio_raw snd_hda_codec edac_core snd_=
hda_core edac_mce_amd k10temp snd_hwdep snd_pcm firewire_ohci snd_seq e10=
0 firewire_core crc_itu_t amdkfd sp5100_tco amd_iommu_v2 i2c_piix4 mxm_wm=
i sr_mod cdrom radeon snd_timer snd_seq_device snd ttm drm_kms_helper xhc=
i_pci drm r8169 xhci_hcd mii fb_sys_fops sysimgblt sysfillrect syscopyare=
a soundcore i2c_algo_bit shpchp tpm_infineon tpm_tis tpm fjes 8250_fintek=
 wmi button acpi_cpufreq sg thermal xfs libcrc32c linear crct10dif_pclmul=
 crc32_pclmul crc32c_intel ghash_clmulni_intel ohci_pci processor scsi_dh=
_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua raid456 async_raid6_recov as=
ync_pq async_xor xor async_memcpy async_tx raid6_pq raid10 raid1 raid0 md=
_mod dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod=
 aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ata_g=
eneric pata_atiixp
Oct  6 20:11:18 localhost kernel: [   32.462728] CPU: 0 PID: 9374 Comm: q=
emu-system-x86 Not tainted 4.3.0-rc2-4-desktop #1
Oct  6 20:11:18 localhost kernel: [   32.462767] Hardware name: Gigabyte =
Technology Co., Ltd. GA-990XA-UD3/GA-990XA-UD3, BIOS F14b 01/24/2013
Oct  6 20:11:18 localhost kernel: [   32.462814] task: ffff8805f4ecc080 t=
i: ffff8805e1ec4000 task.ti: ffff8805e1ec4000
Oct  6 20:11:18 localhost kernel: [   32.462851] RIP: 0010:[<ffffffff8147=
a8a4>]  [<ffffffff8147a8a4>] do_detach+0x24/0xa0
Oct  6 20:11:18 localhost kernel: [   32.462894] RSP: 0018:ffff8805e1ec7c=
a0  EFLAGS: 00010006
Oct  6 20:11:18 localhost kernel: [   32.462922] RAX: 0000000000000000 RB=
X: ffff880614bef640 RCX: 00000000000000ff
Oct  6 20:11:18 localhost kernel: [   32.462959] RDX: 0000000000000000 RS=
I: ffff88062e70c098 RDI: ffff880614bef640
Oct  6 20:11:18 localhost kernel: [   32.462998] RBP: ffff8805e1ec7ca8 R0=
8: ffff880614befc40 R09: 0000000000000000
Oct  6 20:11:18 localhost kernel: [   32.463033] R10: 0000000000000000 R1=
1: ffffffff81a58df8 R12: ffff880614befc40
Oct  6 20:11:18 localhost kernel: [   32.463071] R13: ffff8806144b9858 R1=
4: 0000000000000082 R15: ffff88062e70c098
Oct  6 20:11:18 localhost kernel: [   32.463110] FS:  00007f27cc824b80(00=
00) GS:ffff88062ec00000(0000) knlGS:0000000000000000
Oct  6 20:11:18 localhost kernel: [   32.463148] CS:  0010 DS: 0000 ES: 0=
000 CR0: 0000000080050033
Oct  6 20:11:18 localhost kernel: [   32.463177] CR2: 00000000000000b8 CR=
3: 00000000c8011000 CR4: 00000000000406f0
Oct  6 20:11:18 localhost kernel: [   32.463211] Stack:
Oct  6 20:11:18 localhost kernel: [   32.463223]  ffff880614bef640 ffff88=
05e1ec7cd8 ffffffff8147a96c ffff880614befc40
Oct  6 20:11:18 localhost kernel: [   32.463268]  ffff88062e70c098 000000=
0000000286 ffff8806144b9800 ffff8805e1ec7d08
Oct  6 20:11:18 localhost kernel: [   32.463310]  ffffffff8147aaf5 ffff88=
0615dd0bc0 ffff8805e8354a00 ffff880614befc40
Oct  6 20:11:18 localhost kernel: [   32.463355] Call Trace:
Oct  6 20:11:18 localhost kernel: [   32.463377]  [<ffffffff8147a96c>] __=
detach_device+0x4c/0x80
Oct  6 20:11:18 localhost kernel: [   32.463412]  [<ffffffff8147aaf5>] de=
tach_device+0x35/0xa0
Oct  6 20:11:18 localhost kernel: [   32.463444]  [<ffffffff8147b706>] am=
d_iommu_attach_device+0x66/0x2b0
Oct  6 20:11:18 localhost kernel: [   32.463481]  [<ffffffff81475d8e>] __=
iommu_attach_device+0x1e/0x80
Oct  6 20:11:18 localhost kernel: [   32.463513]  [<ffffffff81477013>] __=
iommu_attach_group+0x53/0x80
Oct  6 20:11:18 localhost kernel: [   32.463547]  [<ffffffff8147706b>] io=
mmu_attach_group+0x2b/0x40
Oct  6 20:11:18 localhost kernel: [   32.463583]  [<ffffffffa07e9407>] vf=
io_iommu_type1_attach_group+0x187/0x4f8 [vfio_iommu_type1]
Oct  6 20:11:18 localhost kernel: [   32.463655]  [<ffffffffa07297e8>] vf=
io_fops_unl_ioctl+0x1b8/0x290 [vfio]
Oct  6 20:11:18 localhost kernel: [   32.463699]  [<ffffffff811f81cd>] do=
_vfs_ioctl+0x2cd/0x4c0
Oct  6 20:11:18 localhost kernel: [   32.463740]  [<ffffffff811f8439>] Sy=
S_ioctl+0x79/0x90
Oct  6 20:11:18 localhost kernel: [   32.463775]  [<ffffffff816b3936>] en=
try_SYSCALL_64_fastpath+0x16/0x75
Oct  6 20:11:18 localhost kernel: [   32.466223] DWARF2 unwinder stuck at=
 entry_SYSCALL_64_fastpath+0x16/0x75
Oct  6 20:11:18 localhost kernel: [   32.466258]=20
Oct  6 20:11:18 localhost kernel: [   32.466267] Leftover inexact backtra=
ce:
Oct  6 20:11:18 localhost kernel: [   32.466267]=20
Oct  6 20:11:18 localhost kernel: [   32.466298] Code: 1f 84 00 00 00 00 =
00 0f 1f 44 00 00 55 48 8b 05 23 c7 d9 00 48 89 e5 53 0f b7 57 40 48 89 f=
b 48 8b 04 d0 48 63 50 10 48 8b 47 38 <83> ac 90 b8 00 00 00 01 48 8b 47 =
38 83 a8 b4 00 00 00 01 48 8b=20
Oct  6 20:11:18 localhost kernel: [   32.466496] RIP  [<ffffffff8147a8a4>=
] do_detach+0x24/0xa0
Oct  6 20:11:18 localhost kernel: [   32.466527]  RSP <ffff8805e1ec7ca0>
Oct  6 20:11:18 localhost kernel: [   32.466547] CR2: 00000000000000b8
Oct  6 20:11:18 localhost kernel: [   32.476984] ---[ end trace 09ac28af2=
000b365 ]---
Oct  6 20:11:18 localhost kernel: [   32.477031] note: qemu-system-x86[93=
74] exited with preempt_count 2
Oct  6 20:11:19 localhost kernel: [   32.577276] walk_shadow_page_get_mmi=
o_spte: detect reserved bits on spte, addr 0xb8000, dump hierarchy:
Oct  6 20:11:19 localhost kernel: [   32.577279] ------ spte 0x5db618027 =
level 4.
Oct  6 20:11:19 localhost kernel: [   32.577281] ------ spte 0x5db619027 =
level 3.
Oct  6 20:11:19 localhost kernel: [   32.577281] ------ spte 0x5db61a027 =
level 2.
Oct  6 20:11:19 localhost kernel: [   32.577282] ------ spte 0xffff000000=
0b8f6f level 1.
Oct  6 20:11:19 localhost kernel: [   32.577283] ------------[ cut here ]=
------------
Oct  6 20:11:19 localhost kernel: [   32.577301] WARNING: CPU: 2 PID: 938=
9 at ../arch/x86/kvm/mmu.c:3385 handle_mmio_page_fault.isra.85+0x2c/0x31 =
[kvm]()
Oct  6 20:11:19 localhost kernel: [   32.577302] Modules linked in: nf_lo=
g_ipv4 nf_log_common xt_LOG ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_def=
rag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables vfio=
_iommu_type1 vfio_pci vfio vfio_virqfd drbg ansi_cprng nfsd lockd grace n=
fs_acl auth_rpcgss sunrpc bridge stp llc tun it87 hwmon_vid snd_hda_codec=
_hdmi kvm_amd snd_hda_codec_realtek kvm snd_hda_codec_generic fam15h_powe=
r usb_storage snd_hda_intel pcspkr serio_raw snd_hda_codec edac_core snd_=
hda_core edac_mce_amd k10temp snd_hwdep snd_pcm firewire_ohci snd_seq e10=
0 firewire_core crc_itu_t amdkfd sp5100_tco amd_iommu_v2 i2c_piix4 mxm_wm=
i sr_mod cdrom radeon snd_timer snd_seq_device snd ttm drm_kms_helper xhc=
i_pci drm r8169 xhci_hcd mii fb_sys_fops sysimgblt sysfillrect syscopyare=
a soundcore i2c_algo_bit shpchp tpm_infineon tpm_tis tpm fjes 8250_fintek=
 wmi button acpi_cpufreq sg thermal xfs libcrc32c linear crct10dif_pclmul=
 crc32_pclmul crc32c_intel ghash_clmulni_intel ohci_pci processor scsi_dh=
_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua raid456 async_raid6_recov as=
ync_pq async_xor xor async_memcpy async_tx raid6_pq raid10 raid1 raid0 md=
_mod dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod=
 aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ata_g=
eneric pata_atiixp
Oct  6 20:11:19 localhost kernel: [   32.577357] CPU: 2 PID: 9389 Comm: q=
emu-system-x86 Tainted: G      D         4.3.0-rc2-4-desktop #1
Oct  6 20:11:19 localhost kernel: [   32.577358] Hardware name: Gigabyte =
Technology Co., Ltd. GA-990XA-UD3/GA-990XA-UD3, BIOS F14b 01/24/2013
Oct  6 20:11:19 localhost kernel: [   32.577360]  ffffffffa083f3ce ffff88=
05e0f43ba0 ffffffff81368633 0000000000000000
Oct  6 20:11:19 localhost kernel: [   32.577362]  ffff8805e0f43bd8 ffffff=
ff8106a628 ffff8805e2a70040 00000000000b8000
Oct  6 20:11:19 localhost kernel: [   32.577364]  0000000000000000 000000=
000000000f 000000000000000f ffff8805e0f43be8
Oct  6 20:11:19 localhost kernel: [   32.577366] Call Trace:
Oct  6 20:11:19 localhost kernel: [   32.577374]  [<ffffffff810085ee>] tr=
y_stack_unwind+0x17e/0x190
Oct  6 20:11:19 localhost kernel: [   32.577379]  [<ffffffff8100737f>] du=
mp_trace+0x8f/0x3b0
Oct  6 20:11:19 localhost kernel: [   32.577382]  [<ffffffff8100864d>] sh=
ow_trace_log_lvl+0x4d/0x60
Oct  6 20:11:19 localhost kernel: [   32.577385]  [<ffffffff810077a1>] sh=
ow_stack_log_lvl+0x101/0x190
Oct  6 20:11:19 localhost kernel: [   32.577387]  [<ffffffff810086a5>] sh=
ow_stack+0x25/0x50
Oct  6 20:11:19 localhost kernel: [   32.577390]  [<ffffffff81368633>] du=
mp_stack+0x4b/0x78
Oct  6 20:11:19 localhost kernel: [   32.577394]  [<ffffffff8106a628>] wa=
rn_slowpath_common+0x88/0xc0
Oct  6 20:11:19 localhost kernel: [   32.577397]  [<ffffffff8106a71a>] wa=
rn_slowpath_null+0x1a/0x20
Oct  6 20:11:19 localhost kernel: [   32.577408]  [<ffffffffa08318eb>] ha=
ndle_mmio_page_fault.isra.85+0x2c/0x31 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.577427]  [<ffffffffa0816106>] td=
p_page_fault+0x246/0x260 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.577441]  [<ffffffffa080fbd4>] kv=
m_mmu_page_fault+0x24/0x110 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.577446]  [<ffffffffa0cdbfc9>] pf=
_interception+0xc9/0x150 [kvm_amd]
Oct  6 20:11:19 localhost kernel: [   32.577451]  [<ffffffffa0cdf5a0>] ha=
ndle_exit+0x180/0x9b0 [kvm_amd]
Oct  6 20:11:19 localhost kernel: [   32.577462]  [<ffffffffa0805dd9>] vc=
pu_enter_guest+0x769/0xde0 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.577475]  [<ffffffffa080c62a>] kv=
m_arch_vcpu_ioctl_run+0x2da/0x400 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.577486]  [<ffffffffa07f4d8f>] kv=
m_vcpu_ioctl+0x30f/0x5c0 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.577490]  [<ffffffff811f81cd>] do=
_vfs_ioctl+0x2cd/0x4c0
Oct  6 20:11:19 localhost kernel: [   32.577497]  [<ffffffff811f8439>] Sy=
S_ioctl+0x79/0x90
Oct  6 20:11:19 localhost kernel: [   32.577500]  [<ffffffff816b3936>] en=
try_SYSCALL_64_fastpath+0x16/0x75
Oct  6 20:11:19 localhost kernel: [   32.578805] DWARF2 unwinder stuck at=
 entry_SYSCALL_64_fastpath+0x16/0x75
Oct  6 20:11:19 localhost kernel: [   32.578806]=20
Oct  6 20:11:19 localhost kernel: [   32.578806] Leftover inexact backtra=
ce:
Oct  6 20:11:19 localhost kernel: [   32.578806]=20
Oct  6 20:11:19 localhost kernel: [   32.578808] ---[ end trace 09ac28af2=
000b366 ]---
Oct  6 20:11:19 localhost kernel: [   32.655728] walk_shadow_page_get_mmi=
o_spte: detect reserved bits on spte, addr 0xb8000, dump hierarchy:
Oct  6 20:11:19 localhost kernel: [   32.655731] ------ spte 0x5e6703027 =
level 4.
Oct  6 20:11:19 localhost kernel: [   32.655732] ------ spte 0x5e5fb8027 =
level 3.
Oct  6 20:11:19 localhost kernel: [   32.655733] ------ spte 0x5e5fb9027 =
level 2.
Oct  6 20:11:19 localhost kernel: [   32.655734] ------ spte 0xffff000000=
0b8f67 level 1.
Oct  6 20:11:19 localhost kernel: [   32.655735] ------------[ cut here ]=
------------
Oct  6 20:11:19 localhost kernel: [   32.655764] WARNING: CPU: 2 PID: 939=
0 at ../arch/x86/kvm/mmu.c:3385 handle_mmio_page_fault.isra.85+0x2c/0x31 =
[kvm]()
Oct  6 20:11:19 localhost kernel: [   32.655765] Modules linked in: nf_lo=
g_ipv4 nf_log_common xt_LOG ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_def=
rag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables vfio=
_iommu_type1 vfio_pci vfio vfio_virqfd drbg ansi_cprng nfsd lockd grace n=
fs_acl auth_rpcgss sunrpc bridge stp llc tun it87 hwmon_vid snd_hda_codec=
_hdmi kvm_amd snd_hda_codec_realtek kvm snd_hda_codec_generic fam15h_powe=
r usb_storage snd_hda_intel pcspkr serio_raw snd_hda_codec edac_core snd_=
hda_core edac_mce_amd k10temp snd_hwdep snd_pcm firewire_ohci snd_seq e10=
0 firewire_core crc_itu_t amdkfd sp5100_tco amd_iommu_v2 i2c_piix4 mxm_wm=
i sr_mod cdrom radeon snd_timer snd_seq_device snd ttm drm_kms_helper xhc=
i_pci drm r8169 xhci_hcd mii fb_sys_fops sysimgblt sysfillrect syscopyare=
a soundcore i2c_algo_bit shpchp tpm_infineon tpm_tis tpm fjes 8250_fintek=
 wmi button acpi_cpufreq sg thermal xfs libcrc32c linear crct10dif_pclmul=
 crc32_pclmul crc32c_intel ghash_clmulni_intel ohci_pci processor scsi_dh=
_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua raid456 async_raid6_recov as=
ync_pq async_xor xor async_memcpy async_tx raid6_pq raid10 raid1 raid0 md=
_mod dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod=
 aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ata_g=
eneric pata_atiixp
Oct  6 20:11:19 localhost kernel: [   32.655823] CPU: 2 PID: 9390 Comm: q=
emu-system-x86 Tainted: G      D W       4.3.0-rc2-4-desktop #1
Oct  6 20:11:19 localhost kernel: [   32.655824] Hardware name: Gigabyte =
Technology Co., Ltd. GA-990XA-UD3/GA-990XA-UD3, BIOS F14b 01/24/2013
Oct  6 20:11:19 localhost kernel: [   32.655826]  ffffffffa083f3ce ffff88=
05e221fba0 ffffffff81368633 0000000000000000
Oct  6 20:11:19 localhost kernel: [   32.655828]  ffff8805e221fbd8 ffffff=
ff8106a628 ffff8805e1e30080 00000000000b8000
Oct  6 20:11:19 localhost kernel: [   32.655830]  0000000000000000 000000=
000000000f 000000000000000f ffff8805e221fbe8
Oct  6 20:11:19 localhost kernel: [   32.655832] Call Trace:
Oct  6 20:11:19 localhost kernel: [   32.655840]  [<ffffffff810085ee>] tr=
y_stack_unwind+0x17e/0x190
Oct  6 20:11:19 localhost kernel: [   32.655845]  [<ffffffff8100737f>] du=
mp_trace+0x8f/0x3b0
Oct  6 20:11:19 localhost kernel: [   32.655848]  [<ffffffff8100864d>] sh=
ow_trace_log_lvl+0x4d/0x60
Oct  6 20:11:19 localhost kernel: [   32.655852]  [<ffffffff810077a1>] sh=
ow_stack_log_lvl+0x101/0x190
Oct  6 20:11:19 localhost kernel: [   32.655864]  [<ffffffff810086a5>] sh=
ow_stack+0x25/0x50
Oct  6 20:11:19 localhost kernel: [   32.655869]  [<ffffffff81368633>] du=
mp_stack+0x4b/0x78
Oct  6 20:11:19 localhost kernel: [   32.655877]  [<ffffffff8106a628>] wa=
rn_slowpath_common+0x88/0xc0
Oct  6 20:11:19 localhost kernel: [   32.655881]  [<ffffffff8106a71a>] wa=
rn_slowpath_null+0x1a/0x20
Oct  6 20:11:19 localhost kernel: [   32.655894]  [<ffffffffa08318eb>] ha=
ndle_mmio_page_fault.isra.85+0x2c/0x31 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.655917]  [<ffffffffa0816106>] td=
p_page_fault+0x246/0x260 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.655940]  [<ffffffffa080fbd4>] kv=
m_mmu_page_fault+0x24/0x110 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.655956]  [<ffffffffa0cdbfc9>] pf=
_interception+0xc9/0x150 [kvm_amd]
Oct  6 20:11:19 localhost kernel: [   32.655965]  [<ffffffffa0cdf5a0>] ha=
ndle_exit+0x180/0x9b0 [kvm_amd]
Oct  6 20:11:19 localhost kernel: [   32.655983]  [<ffffffffa0805dd9>] vc=
pu_enter_guest+0x769/0xde0 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.656000]  [<ffffffffa080c62a>] kv=
m_arch_vcpu_ioctl_run+0x2da/0x400 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.656012]  [<ffffffffa07f4d8f>] kv=
m_vcpu_ioctl+0x30f/0x5c0 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.656017]  [<ffffffff811f81cd>] do=
_vfs_ioctl+0x2cd/0x4c0
Oct  6 20:11:19 localhost kernel: [   32.656023]  [<ffffffff811f8439>] Sy=
S_ioctl+0x79/0x90
Oct  6 20:11:19 localhost kernel: [   32.656028]  [<ffffffff816b3936>] en=
try_SYSCALL_64_fastpath+0x16/0x75
Oct  6 20:11:19 localhost kernel: [   32.657322] DWARF2 unwinder stuck at=
 entry_SYSCALL_64_fastpath+0x16/0x75
Oct  6 20:11:19 localhost kernel: [   32.657324]=20
Oct  6 20:11:19 localhost kernel: [   32.657324] Leftover inexact backtra=
ce:
Oct  6 20:11:19 localhost kernel: [   32.657324]=20
Oct  6 20:11:19 localhost kernel: [   32.657327] ---[ end trace 09ac28af2=
000b367 ]---
Oct  6 20:11:19 localhost kernel: [   32.715379] walk_shadow_page_get_mmi=
o_spte: detect reserved bits on spte, addr 0xb8000, dump hierarchy:
Oct  6 20:11:19 localhost kernel: [   32.715382] ------ spte 0x5e6707027 =
level 4.
Oct  6 20:11:19 localhost kernel: [   32.715383] ------ spte 0x5e5781027 =
level 3.
Oct  6 20:11:19 localhost kernel: [   32.715384] ------ spte 0x5e2291027 =
level 2.
Oct  6 20:11:19 localhost kernel: [   32.715385] ------ spte 0xffff000000=
0b8f67 level 1.
Oct  6 20:11:19 localhost kernel: [   32.715386] ------------[ cut here ]=
------------
Oct  6 20:11:19 localhost kernel: [   32.715405] WARNING: CPU: 2 PID: 939=
3 at ../arch/x86/kvm/mmu.c:3385 handle_mmio_page_fault.isra.85+0x2c/0x31 =
[kvm]()
Oct  6 20:11:19 localhost kernel: [   32.715407] Modules linked in: nf_lo=
g_ipv4 nf_log_common xt_LOG ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_def=
rag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables x_tables vfio=
_iommu_type1 vfio_pci vfio vfio_virqfd drbg ansi_cprng nfsd lockd grace n=
fs_acl auth_rpcgss sunrpc bridge stp llc tun it87 hwmon_vid snd_hda_codec=
_hdmi kvm_amd snd_hda_codec_realtek kvm snd_hda_codec_generic fam15h_powe=
r usb_storage snd_hda_intel pcspkr serio_raw snd_hda_codec edac_core snd_=
hda_core edac_mce_amd k10temp snd_hwdep snd_pcm firewire_ohci snd_seq e10=
0 firewire_core crc_itu_t amdkfd sp5100_tco amd_iommu_v2 i2c_piix4 mxm_wm=
i sr_mod cdrom radeon snd_timer snd_seq_device snd ttm drm_kms_helper xhc=
i_pci drm r8169 xhci_hcd mii fb_sys_fops sysimgblt sysfillrect syscopyare=
a soundcore i2c_algo_bit shpchp tpm_infineon tpm_tis tpm fjes 8250_fintek=
 wmi button acpi_cpufreq sg thermal xfs libcrc32c linear crct10dif_pclmul=
 crc32_pclmul crc32c_intel ghash_clmulni_intel ohci_pci processor scsi_dh=
_rdac scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua raid456 async_raid6_recov as=
ync_pq async_xor xor async_memcpy async_tx raid6_pq raid10 raid1 raid0 md=
_mod dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod=
 aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ata_g=
eneric pata_atiixp
Oct  6 20:11:19 localhost kernel: [   32.715461] CPU: 2 PID: 9393 Comm: q=
emu-system-x86 Tainted: G      D W       4.3.0-rc2-4-desktop #1
Oct  6 20:11:19 localhost kernel: [   32.715462] Hardware name: Gigabyte =
Technology Co., Ltd. GA-990XA-UD3/GA-990XA-UD3, BIOS F14b 01/24/2013
Oct  6 20:11:19 localhost kernel: [   32.715464]  ffffffffa083f3ce ffff88=
05e93afba0 ffffffff81368633 0000000000000000
Oct  6 20:11:19 localhost kernel: [   32.715466]  ffff8805e93afbd8 ffffff=
ff8106a628 ffff8805ec604140 00000000000b8000
Oct  6 20:11:19 localhost kernel: [   32.715468]  0000000000000000 000000=
000000000f 000000000000000f ffff8805e93afbe8
Oct  6 20:11:19 localhost kernel: [   32.715470] Call Trace:
Oct  6 20:11:19 localhost kernel: [   32.715478]  [<ffffffff810085ee>] tr=
y_stack_unwind+0x17e/0x190
Oct  6 20:11:19 localhost kernel: [   32.715483]  [<ffffffff8100737f>] du=
mp_trace+0x8f/0x3b0
Oct  6 20:11:19 localhost kernel: [   32.715486]  [<ffffffff8100864d>] sh=
ow_trace_log_lvl+0x4d/0x60
Oct  6 20:11:19 localhost kernel: [   32.715488]  [<ffffffff810077a1>] sh=
ow_stack_log_lvl+0x101/0x190
Oct  6 20:11:19 localhost kernel: [   32.715491]  [<ffffffff810086a5>] sh=
ow_stack+0x25/0x50
Oct  6 20:11:19 localhost kernel: [   32.715494]  [<ffffffff81368633>] du=
mp_stack+0x4b/0x78
Oct  6 20:11:19 localhost kernel: [   32.715498]  [<ffffffff8106a628>] wa=
rn_slowpath_common+0x88/0xc0
Oct  6 20:11:19 localhost kernel: [   32.715501]  [<ffffffff8106a71a>] wa=
rn_slowpath_null+0x1a/0x20
Oct  6 20:11:19 localhost kernel: [   32.715512]  [<ffffffffa08318eb>] ha=
ndle_mmio_page_fault.isra.85+0x2c/0x31 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.715532]  [<ffffffffa0816106>] td=
p_page_fault+0x246/0x260 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.715546]  [<ffffffffa080fbd4>] kv=
m_mmu_page_fault+0x24/0x110 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.715551]  [<ffffffffa0cdbfc9>] pf=
_interception+0xc9/0x150 [kvm_amd]
Oct  6 20:11:19 localhost kernel: [   32.715556]  [<ffffffffa0cdf5a0>] ha=
ndle_exit+0x180/0x9b0 [kvm_amd]
Oct  6 20:11:19 localhost kernel: [   32.715567]  [<ffffffffa0805dd9>] vc=
pu_enter_guest+0x769/0xde0 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.715580]  [<ffffffffa080c62a>] kv=
m_arch_vcpu_ioctl_run+0x2da/0x400 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.715590]  [<ffffffffa07f4d8f>] kv=
m_vcpu_ioctl+0x30f/0x5c0 [kvm]
Oct  6 20:11:19 localhost kernel: [   32.715595]  [<ffffffff811f81cd>] do=
_vfs_ioctl+0x2cd/0x4c0
Oct  6 20:11:19 localhost kernel: [   32.715602]  [<ffffffff811f8439>] Sy=
S_ioctl+0x79/0x90
Oct  6 20:11:19 localhost kernel: [   32.715606]  [<ffffffff816b3936>] en=
try_SYSCALL_64_fastpath+0x16/0x75
Oct  6 20:11:19 localhost kernel: [   32.716901] DWARF2 unwinder stuck at=
 entry_SYSCALL_64_fastpath+0x16/0x75
Oct  6 20:11:19 localhost kernel: [   32.716902]=20
Oct  6 20:11:19 localhost kernel: [   32.716902] Leftover inexact backtra=
ce:
Oct  6 20:11:19 localhost kernel: [   32.716902]=20
Oct  6 20:11:19 localhost kernel: [   32.716904] ---[ end trace 09ac28af2=
000b368 ]---

--------------000703020406070003070803
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000703020406070003070803--
