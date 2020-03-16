From: =?utf-8?Q?Jean-Fran=C3=A7ois_Remy?= <jeff@drivescale.com>
Subject: Regression due to commit
	dbaf971c9cdf10843071a60dcafc1aaab3162354 ?
Date: Mon, 16 Mar 2020 10:35:51 -0700
Message-ID: <D0DB90A1-2222-4D2D-9D8B-55A5E3237296@drivescale.com>
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Content-Type: multipart/mixed; boundary="===============8016481157451520572=="
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

--===============8016481157451520572==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_22C02E9E-EBD8-4446-88AD-1D6ADB1E5C87"

--Apple-Mail=_22C02E9E-EBD8-4446-88AD-1D6ADB1E5C87
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi,
we=E2=80=99re using multipath with queue mode bio and we=E2=80=99ve run int=
o what seem to be a regression introduce by commit dbaf971c9cdf10843071a60d=
cafc1aaab3162354 in 5.5 (which was also back ported to 5.4).
This happens at the time the multipath device is created.
We=E2=80=99re running on a Cisco box with an mpt3sas hba controller, SAS dr=
ives, the kernel is a vanilla kernel from kernel.org <http://kernel.org/> w=
ith a few patches in completely unrelated part of the kernel code, multipat=
h 0.8.3 on a Debian Buster.

We=E2=80=99ve initially bisected the issue on the v5.4.x branch down to com=
mit 7e53ea4a1641c463d5369f800734920f1dac56c2 and then we also verified that=
 a v5.5.9 build without commit dbaf971c9cdf10843071a60dcafc1aaab3162354 did=
 not exhibit the bug while it does with it.

When booting our test platform with this commit included, we see the a lot =
fo kernel WARNING traces like the following one and the multipath devices a=
re unusable:

[   34.559589] ------------[ cut here ]------------
[   34.559600] WARNING: CPU: 3 PID: 1432 at kernel/workqueue.c:1622 __queue=
_delayed_work+0x70/0x90
[   34.559600] Modules linked in: dm_service_time nvmet_tcp mlx5_ib mlx5_co=
re ib_uverbs pci_hyperv_intf nvmet_rdma rdma_cm iw_cm ib_cm ib_core nvmet n=
vme_fabrics iscsi_target_mod target_core_iblock target_core_mod configfs mp=
t3sas raid_class scsi_transport_sas dm_multipath scsi_dh_rdac scsi_dh_emc s=
csi_dh_alua intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal i=
ntel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul ipmi_ssif=
 crc32_pclmul ghash_clmulni_intel snd_pcm snd_timer snd soundcore aesni_int=
el mei_me iTCO_wdt crypto_simd cryptd input_leds joydev glue_helper mei iTC=
O_vendor_support pcspkr ipmi_si ipmi_devintf ipmi_msghandler acpi_pad acpi_=
power_meter mac_hid ip_tables x_tables autofs4 usb_storage hid_generic usbk=
bd usbmouse usbhid hid fnic libfcoe ahci mxm_wmi libfc libahci lpc_ich enic=
 scsi_transport_fc wmi
[   34.559634] CPU: 3 PID: 1432 Comm: systemd-udevd Not tainted 5.5.8 #98
[   34.559634] Hardware name: Cisco Systems Inc UCSC-C3K-M4SRB/UCSC-C3K-M4S=
RB, BIOS C3X60M4.4.0.2f.0.1113190831 11/13/2019
[   34.559637] RIP: 0010:__queue_delayed_work+0x70/0x90
[   34.559638] Code: 41 81 f8 00 02 00 00 48 89 4a 30 75 2a e9 c8 cd 06 00 =
44 89 c7 e9 80 fb ff ff 0f 0b eb cb 0f 0b 48 81 7a 38 40 a0 0a b2 74 ab <0f=
> 0b 48 83 7a 28 00 74 a9 0f 0b eb a5 44 89 c6 e9 ab bc 06 00 90
[   34.559639] RSP: 0018:ffffb6e88e9b3830 EFLAGS: 00010007
[   34.559640] RAX: 0000000000000002 RBX: 0000000000000002 RCX: 00000000000=
00000
[   34.559641] RDX: ffff9e9c38006c30 RSI: ffff9e9c33933c00 RDI: ffff9e9c380=
06c50
[   34.559642] RBP: ffff9e9c33828e00 R08: 0000000000000200 R09: ffff9e7c326=
cc458
[   34.559643] R10: 0000000000000000 R11: 01fffffffffffffe R12: 00000000000=
00000
[   34.559643] R13: ffff9e7c050400b0 R14: ffff9e7c05040000 R15: 00000000000=
00001
[   34.559644] FS:  00007ff73a5cbd40(0000) GS:ffff9e7c3f6c0000(0000) knlGS:=
0000000000000000
[   34.559645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   34.559645] CR2: 00007ffdf1e8ea48 CR3: 0000001ff447a001 CR4: 00000000003=
606e0
[   34.559646] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   34.559646] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   34.559647] Call Trace:
[   34.559651]  queue_delayed_work_on+0x24/0x40
[   34.559656]  __pg_init_all_paths+0x75/0xc0 [dm_multipath]
[   34.559658]  pg_init_all_paths+0x23/0x40 [dm_multipath]
[   34.559660]  __multipath_map_bio+0x1b5/0x230 [dm_multipath]
[   34.559664]  __map_bio+0x42/0x170
[   34.559666]  __split_and_process_non_flush+0x132/0x1d0
[   34.559669]  __split_and_process_bio+0x94/0x240
[   34.559672]  ? blk_throtl_bio+0x141/0xbf0
[   34.559674]  dm_process_bio+0x117/0x230
[   34.559678]  ? generic_make_request_checks+0x23a/0x5c0
[   34.559680]  dm_make_request+0x3b/0xb0
[   34.559681]  generic_make_request+0x11f/0x2e0
[   34.559683]  ? submit_bio+0x72/0x140
[   34.559685]  submit_bio+0x72/0x140
[   34.559689]  mpage_readpages+0x154/0x190
[   34.559692]  ? bdev_evict_inode+0xf0/0xf0
[   34.559697]  read_pages+0x71/0x1a0
[   34.559700]  ? __do_page_cache_readahead+0x199/0x1b0
[   34.559701]  __do_page_cache_readahead+0x199/0x1b0
[   34.559703]  force_page_cache_readahead+0xb7/0xe0
[   34.559705]  generic_file_read_iter+0x7f3/0xbf0
[   34.559708]  ? _copy_to_user+0x22/0x30
[   34.559713]  ? cp_new_stat+0x154/0x190
[   34.559716]  new_sync_read+0x11b/0x1b0
[   34.559718]  vfs_read+0x90/0x130
[   34.559720]  ksys_read+0x5c/0xe0
[   34.559725]  do_syscall_64+0x52/0x1a0
[   34.559730]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   34.559731] RIP: 0033:0x7ff73adac461
[   34.559733] Code: fe ff ff 50 48 8d 3d fe d0 09 00 e8 e9 03 02 00 66 0f =
1f 84 00 00 00 00 00 48 8d 05 99 62 0d 00 8b 00 85 c0 75 13 31 c0 0f 05 <48=
> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54 49 89 d4 55 48
[   34.559734] RSP: 002b:00007ffdf1e90ba8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000000
[   34.559735] RAX: ffffffffffffffda RBX: 0000557789799f50 RCX: 00007ff73ad=
ac461
[   34.559735] RDX: 0000000000000040 RSI: 000055778978b588 RDI: 00000000000=
00006
[   34.559736] RBP: 0000557789799fa0 R08: 000055778978b560 R09: 00007ff73ae=
7e330
[   34.559737] R10: 000055778977d010 R11: 0000000000000246 R12: 0000057541e=
80000
[   34.559737] R13: 0000000000000040 R14: 000055778978b578 R15: 00005577897=
8b560
[   34.559738] ---[ end trace 865597b9b72c7dc2 ]=E2=80=94


Let me know if there is anything else that would help understand what goes =
on

best,
Jean-Francois Remy
--Apple-Mail=_22C02E9E-EBD8-4446-88AD-1D6ADB1E5C87
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dutf-8"></head><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: s=
pace; line-break: after-white-space;" class=3D""><span style=3D"caret-color=
: rgb(0, 0, 0); color: rgb(0, 0, 0);" class=3D"">Hi,</span><div class=3D"" =
style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">we=E2=80=99re usi=
ng multipath with queue mode bio and we=E2=80=99ve run into what seem to be=
 a regression introduce by commit&nbsp;dbaf971c9cdf10843071a60dcafc1aaab316=
2354 in 5.5 (which was also back ported to 5.4).</div><div class=3D"" style=
=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">This happens at the ti=
me the multipath device is created.</div><div class=3D"" style=3D"caret-col=
or: rgb(0, 0, 0); color: rgb(0, 0, 0);">We=E2=80=99re running on a Cisco bo=
x with an mpt3sas hba controller, SAS drives, the kernel is a vanilla kerne=
l from&nbsp;<a href=3D"http://kernel.org" class=3D"">kernel.org</a>&nbsp;wi=
th a few patches in completely unrelated part of the kernel code, multipath=
 0.8.3 on a Debian Buster.</div><div class=3D"" style=3D"caret-color: rgb(0=
, 0, 0); color: rgb(0, 0, 0);"><br class=3D""></div><div class=3D"" style=
=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">We=E2=80=99ve initiall=
y bisected the issue on the v5.4.x branch down to commit&nbsp;7e53ea4a1641c=
463d5369f800734920f1dac56c2 and then we also verified that a v5.5.9 build w=
ithout commit&nbsp;<span class=3D"">dbaf971c9cdf10843071a60dcafc1aaab316235=
4</span><font color=3D"#000000" class=3D"">&nbsp;did not exhibit the bug wh=
ile it does with it.</font></div><div class=3D"" style=3D"caret-color: rgb(=
0, 0, 0); color: rgb(0, 0, 0);"><br class=3D""></div><div class=3D"" style=
=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">When booting our test =
platform with this commit included, we see the a lot fo kernel WARNING trac=
es like the following one and the multipath devices are unusable:</div><div=
 class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><br c=
lass=3D""></div><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: =
rgb(0, 0, 0);"><div class=3D"">[ &nbsp; 34.559589] ------------[ cut here ]=
------------</div><div class=3D"">[ &nbsp; 34.559600] WARNING: CPU: 3 PID: =
1432 at kernel/workqueue.c:1622 __queue_delayed_work+0x70/0x90</div><div cl=
ass=3D"">[ &nbsp; 34.559600] Modules linked in: dm_service_time nvmet_tcp m=
lx5_ib mlx5_core ib_uverbs pci_hyperv_intf nvmet_rdma rdma_cm iw_cm ib_cm i=
b_core nvmet nvme_fabrics iscsi_target_mod target_core_iblock target_core_m=
od configfs mpt3sas raid_class scsi_transport_sas dm_multipath scsi_dh_rdac=
 scsi_dh_emc scsi_dh_alua intel_rapl_msr intel_rapl_common sb_edac x86_pkg_=
temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pc=
lmul ipmi_ssif crc32_pclmul ghash_clmulni_intel snd_pcm snd_timer snd sound=
core aesni_intel mei_me iTCO_wdt crypto_simd cryptd input_leds joydev glue_=
helper mei iTCO_vendor_support pcspkr ipmi_si ipmi_devintf ipmi_msghandler =
acpi_pad acpi_power_meter mac_hid ip_tables x_tables autofs4 usb_storage hi=
d_generic usbkbd usbmouse usbhid hid fnic libfcoe ahci mxm_wmi libfc libahc=
i lpc_ich enic scsi_transport_fc wmi</div><div class=3D"">[ &nbsp; 34.55963=
4] CPU: 3 PID: 1432 Comm: systemd-udevd Not tainted 5.5.8 #98</div><div cla=
ss=3D"">[ &nbsp; 34.559634] Hardware name: Cisco Systems Inc UCSC-C3K-M4SRB=
/UCSC-C3K-M4SRB, BIOS C3X60M4.4.0.2f.0.1113190831 11/13/2019</div><div clas=
s=3D"">[ &nbsp; 34.559637] RIP: 0010:__queue_delayed_work+0x70/0x90</div><d=
iv class=3D"">[ &nbsp; 34.559638] Code: 41 81 f8 00 02 00 00 48 89 4a 30 75=
 2a e9 c8 cd 06 00 44 89 c7 e9 80 fb ff ff 0f 0b eb cb 0f 0b 48 81 7a 38 40=
 a0 0a b2 74 ab &lt;0f&gt; 0b 48 83 7a 28 00 74 a9 0f 0b eb a5 44 89 c6 e9 =
ab bc 06 00 90</div><div class=3D"">[ &nbsp; 34.559639] RSP: 0018:ffffb6e88=
e9b3830 EFLAGS: 00010007</div><div class=3D"">[ &nbsp; 34.559640] RAX: 0000=
000000000002 RBX: 0000000000000002 RCX: 0000000000000000</div><div class=3D=
"">[ &nbsp; 34.559641] RDX: ffff9e9c38006c30 RSI: ffff9e9c33933c00 RDI: fff=
f9e9c38006c50</div><div class=3D"">[ &nbsp; 34.559642] RBP: ffff9e9c33828e0=
0 R08: 0000000000000200 R09: ffff9e7c326cc458</div><div class=3D"">[ &nbsp;=
 34.559643] R10: 0000000000000000 R11: 01fffffffffffffe R12: 00000000000000=
00</div><div class=3D"">[ &nbsp; 34.559643] R13: ffff9e7c050400b0 R14: ffff=
9e7c05040000 R15: 0000000000000001</div><div class=3D"">[ &nbsp; 34.559644]=
 FS: &nbsp;00007ff73a5cbd40(0000) GS:ffff9e7c3f6c0000(0000) knlGS:000000000=
0000000</div><div class=3D"">[ &nbsp; 34.559645] CS: &nbsp;0010 DS: 0000 ES=
: 0000 CR0: 0000000080050033</div><div class=3D"">[ &nbsp; 34.559645] CR2: =
00007ffdf1e8ea48 CR3: 0000001ff447a001 CR4: 00000000003606e0</div><div clas=
s=3D"">[ &nbsp; 34.559646] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=
 0000000000000000</div><div class=3D"">[ &nbsp; 34.559646] DR3: 00000000000=
00000 DR6: 00000000fffe0ff0 DR7: 0000000000000400</div><div class=3D"">[ &n=
bsp; 34.559647] Call Trace:</div><div class=3D"">[ &nbsp; 34.559651] &nbsp;=
queue_delayed_work_on+0x24/0x40</div><div class=3D"">[ &nbsp; 34.559656] &n=
bsp;__pg_init_all_paths+0x75/0xc0 [dm_multipath]</div><div class=3D"">[ &nb=
sp; 34.559658] &nbsp;pg_init_all_paths+0x23/0x40 [dm_multipath]</div><div c=
lass=3D"">[ &nbsp; 34.559660] &nbsp;__multipath_map_bio+0x1b5/0x230 [dm_mul=
tipath]</div><div class=3D"">[ &nbsp; 34.559664] &nbsp;__map_bio+0x42/0x170=
</div><div class=3D"">[ &nbsp; 34.559666] &nbsp;__split_and_process_non_flu=
sh+0x132/0x1d0</div><div class=3D"">[ &nbsp; 34.559669] &nbsp;__split_and_p=
rocess_bio+0x94/0x240</div><div class=3D"">[ &nbsp; 34.559672] &nbsp;? blk_=
throtl_bio+0x141/0xbf0</div><div class=3D"">[ &nbsp; 34.559674] &nbsp;dm_pr=
ocess_bio+0x117/0x230</div><div class=3D"">[ &nbsp; 34.559678] &nbsp;? gene=
ric_make_request_checks+0x23a/0x5c0</div><div class=3D"">[ &nbsp; 34.559680=
] &nbsp;dm_make_request+0x3b/0xb0</div><div class=3D"">[ &nbsp; 34.559681] =
&nbsp;generic_make_request+0x11f/0x2e0</div><div class=3D"">[ &nbsp; 34.559=
683] &nbsp;? submit_bio+0x72/0x140</div><div class=3D"">[ &nbsp; 34.559685]=
 &nbsp;submit_bio+0x72/0x140</div><div class=3D"">[ &nbsp; 34.559689] &nbsp=
;mpage_readpages+0x154/0x190</div><div class=3D"">[ &nbsp; 34.559692] &nbsp=
;? bdev_evict_inode+0xf0/0xf0</div><div class=3D"">[ &nbsp; 34.559697] &nbs=
p;read_pages+0x71/0x1a0</div><div class=3D"">[ &nbsp; 34.559700] &nbsp;? __=
do_page_cache_readahead+0x199/0x1b0</div><div class=3D"">[ &nbsp; 34.559701=
] &nbsp;__do_page_cache_readahead+0x199/0x1b0</div><div class=3D"">[ &nbsp;=
 34.559703] &nbsp;force_page_cache_readahead+0xb7/0xe0</div><div class=3D""=
>[ &nbsp; 34.559705] &nbsp;generic_file_read_iter+0x7f3/0xbf0</div><div cla=
ss=3D"">[ &nbsp; 34.559708] &nbsp;? _copy_to_user+0x22/0x30</div><div class=
=3D"">[ &nbsp; 34.559713] &nbsp;? cp_new_stat+0x154/0x190</div><div class=
=3D"">[ &nbsp; 34.559716] &nbsp;new_sync_read+0x11b/0x1b0</div><div class=
=3D"">[ &nbsp; 34.559718] &nbsp;vfs_read+0x90/0x130</div><div class=3D"">[ =
&nbsp; 34.559720] &nbsp;ksys_read+0x5c/0xe0</div><div class=3D"">[ &nbsp; 3=
4.559725] &nbsp;do_syscall_64+0x52/0x1a0</div><div class=3D"">[ &nbsp; 34.5=
59730] &nbsp;entry_SYSCALL_64_after_hwframe+0x44/0xa9</div><div class=3D"">=
[ &nbsp; 34.559731] RIP: 0033:0x7ff73adac461</div><div class=3D"">[ &nbsp; =
34.559733] Code: fe ff ff 50 48 8d 3d fe d0 09 00 e8 e9 03 02 00 66 0f 1f 8=
4 00 00 00 00 00 48 8d 05 99 62 0d 00 8b 00 85 c0 75 13 31 c0 0f 05 &lt;48&=
gt; 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54 49 89 d4 55 48</div><di=
v class=3D"">[ &nbsp; 34.559734] RSP: 002b:00007ffdf1e90ba8 EFLAGS: 0000024=
6 ORIG_RAX: 0000000000000000</div><div class=3D"">[ &nbsp; 34.559735] RAX: =
ffffffffffffffda RBX: 0000557789799f50 RCX: 00007ff73adac461</div><div clas=
s=3D"">[ &nbsp; 34.559735] RDX: 0000000000000040 RSI: 000055778978b588 RDI:=
 0000000000000006</div><div class=3D"">[ &nbsp; 34.559736] RBP: 00005577897=
99fa0 R08: 000055778978b560 R09: 00007ff73ae7e330</div><div class=3D"">[ &n=
bsp; 34.559737] R10: 000055778977d010 R11: 0000000000000246 R12: 0000057541=
e80000</div><div class=3D"">[ &nbsp; 34.559737] R13: 0000000000000040 R14: =
000055778978b578 R15: 000055778978b560</div><div class=3D"">[ &nbsp; 34.559=
738] ---[ end trace 865597b9b72c7dc2 ]=E2=80=94</div><div class=3D""><br cl=
ass=3D""></div></div><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); co=
lor: rgb(0, 0, 0);"><br class=3D""></div><div class=3D"" style=3D"caret-col=
or: rgb(0, 0, 0); color: rgb(0, 0, 0);">Let me know if there is anything el=
se that would help understand what goes on</div><div class=3D"" style=3D"ca=
ret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);"><br class=3D""></div><div cl=
ass=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);">best,</d=
iv><div class=3D"" style=3D"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0);=
">Jean-Francois Remy</div></body></html>

--Apple-Mail=_22C02E9E-EBD8-4446-88AD-1D6ADB1E5C87--

--===============8016481157451520572==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


--===============8016481157451520572==--
