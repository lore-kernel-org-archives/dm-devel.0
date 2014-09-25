From: Elvin Cako <ecako@cogolabs.com>
Subject: Re: [data] Re: [linux-lvm] Setting up LVM cache causes
	crash
Date: Thu, 25 Sep 2014 17:05:12 -0400
Message-ID: <CACjhXxdVFNT=tkaeoRv=6dijeh6sov6jrXUm35XVnk4b48odzg@mail.gmail.com>
References: <CACjhXxfZak7n=zBvfPX3FtpZeBM88eBm8RnweguOZjpwdoG0ew@mail.gmail.com>
	<590C03FA-0051-4DCF-B568-C0A47B16AA49@redhat.com>
	<CACjhXxdyw1Sx4iMKT7dMUFTRwd--zLpt8BK8iyedCj_bPiTCWg@mail.gmail.com>
	<99ACAC11-1051-4C96-A81F-E4B0845D3145@redhat.com>
	<CACjhXxcvqtBJ2h2efNRDu2FbhQ=v+S_X3NtBOzUb2rXo2L+9og@mail.gmail.com>
	<CF6395F0-64FC-4E39-BDD7-68A98AB6FEC2@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4140096817755161774=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CF6395F0-64FC-4E39-BDD7-68A98AB6FEC2@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, data <data@cogolabs.com>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids

--===============4140096817755161774==
Content-Type: multipart/alternative; boundary=047d7b86de5609a1ef0503ea2899

--047d7b86de5609a1ef0503ea2899
Content-Type: text/plain; charset=UTF-8

Jonathan,

Thank you for your help.
Here is the kernel and lvm info:

Kernel:

Linux  3.10.0-123.6.3.el7.x86_64 #1 SMP Wed Aug 6 21:12:36 UTC 2014 x86_64
x86_64 x86_64 GNU/Linux


LVM:

LVM TOOLS 2.02.105(2)-RHEL7 (2014-03-26)

On Wed, Sep 24, 2014 at 12:45 AM, Brassow Jonathan <jbrassow@redhat.com>
wrote:

> Elvin,
>
> I'll forward this on to the kernel-side development mailing list (
> dm-devel@redhat.com).  I'm sure they will probably want to know what
> kernel you are using and whether your kernel and LVM packages are
> up-to-date.  I've not seen a bug like this myself, but it looks similar to:
> - https://bugzilla.redhat.com/1080894
> - https://bugzilla.redhat.com/1113759
>
>  brassow
>
> On Sep 17, 2014, at 10:59 AM, Elvin Cako wrote:
>
> Hello Jonathan,
>
> Here is the output of the kernel log:
>
> [  933.985159] device-mapper: cache: Metadata device dm-3 is larger than
> 33292800 sectors: excess space will not be used.^M
> [  934.001112] device-mapper: cache-policy-mq: version 1.2.0 loaded^M
> [  937.261742] TECH PREVIEW: DM cache may not be fully supported.^M
> [  937.261742] Please review provided documentation for limitations.^M
> [  937.275035] bio: create slab <bio-2> at 2^M
> [  939.495826] ------------[ cut here ]------------^M
> [  939.501134] kernel BUG at
> drivers/md/persistent-data/dm-btree-spine.c:169!^M
> [  939.508552] invalid opcode: 0000 [#1] SMP ^M
> [  939.513230] Modules linked in: dm_cache_mq dm_cache()
> dm_persistent_data dm_bio_prison dm_bufio raid1 ext4 mbcache jbd2 sg
> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack
> ip6table_filter ip6_tables iTCO_wdt iTCO_vendor_support coretemp kvm_intel
> kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
> aesni_intel lrw gf128mul glue_helper ablk_helper cryptd pcspkr sb_edac
> edac_core i2c_i801 ixgbe igb lpc_ich mdio ptp mei_me mfd_core pps_core mei
> ioatdma ntb dca ses enclosure ipmi_devintf wmi shpchp ipmi_si
> ipmi_msghandler mperf nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c
> sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect
> sysimgblt i2c_algo_bit drm_kms_helper ttm isci ahci drm libsas libahci
> libata mpt2sas(OF) i2c_core raid_class scsi_transport_sas dm_mirror
> dm_region_hash dm_log dm_mod^M
> [  939.594520] CPU: 31 PID: 7241 Comm: vgchange Tainted: GF
> O-------------- T 3.10.0-123.6.3.el7.x86_64 #1^M
> [  939.605410] Hardware name: Supermicro SYS-F617R2-RT+/X9DRFR, BIOS 3.0b
> 04/24/2014^M
> [  939.613653] task: ffff883fd0460b60 ti: ffff883fcfe2a000 task.ti:
> ffff883fcfe2a000^M
> [  939.621891] RIP: 0010:[<ffffffffa052e73a>]  [<ffffffffa052e73a>]
> ro_pop+0x2a/0x30 [dm_persistent_data]^M
> [  939.631988] RSP: 0018:ffff883fcfe2bb20  EFLAGS: 00010246^M
> [  939.638057] RAX: 0000000000000000 RBX: 0000000000000008 RCX:
> 0000000000000000^M
> [  939.645961] RDX: 0000000000000000 RSI: 0000000000000246 RDI:
> ffff883fcfe2bb80^M
> [  939.653867] RBP: ffff883fcfe2bb70 R08: 0000000000000000 R09:
> 0000000000000000^M
> [  939.661774] R10: 0000000000000000 R11: 0000000000000002 R12:
> 0000000000000008^M
> [  939.669687] R13: ffffffffa05277a0 R14: ffff883fcfe2bbd0 R15:
> ffff883e02f2a000^M
> [  939.677596] FS:  00007ff8d7333880(0000) GS:ffff88407fde0000(0000)
> knlGS:0000000000000000^M
> [  939.686477] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
> [  939.693034] CR2: 00007f0139cfd50a CR3: 0000003fcfb75000 CR4:
> 00000000000407e0^M
> [  939.700986] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000^M
> [  939.708930] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400^M
> [  939.716858] Stack:^M
> [  939.719691]  ffffffffa052c5a2 00000000000001fd ffff883fcfe2bb80
> ffff883fcfe2bba0^M
> [  939.728009]  000000006c9004a8 0000000000000106 ffffffffa05277a0
> ffff883fcfe2bbd0^M
> [  939.736314]  ffff883fd2956800 ffff883fcb86d800 ffff883fcfe2bbc0
> ffffffffa052d21e^M
> [  939.744615] Call Trace:^M
> [  939.747897]  [<ffffffffa052c5a2>] ? walk_node+0xc2/0x100
> [dm_persistent_data]^M
> [  939.755880]  [<ffffffffa05277a0>] ? block_dec+0x160/0x160
> [dm_persistent_data]^M
> [  939.763965]  [<ffffffffa052d21e>] dm_btree_walk+0x4e/0x80
> [dm_persistent_data]^M
> [  939.772045]  [<ffffffffa0540a30>] ? complete_migration+0x30/0x30
> [dm_cache]^M
> [  939.779854]  [<ffffffffa05275dc>] dm_array_walk+0x3c/0x60
> [dm_persistent_data]^M
> [  939.787926]  [<ffffffffa0543700>] ?
> blocks_are_unmapped_or_clean+0xd0/0xd0 [dm_cache]^M
> [  939.796622]  [<ffffffffa054451f>] dm_cache_load_mappings+0x7f/0xe0
> [dm_cache]^M
> [  939.804642]  [<ffffffffa0540a30>] ? complete_migration+0x30/0x30
> [dm_cache]^M
> [  939.812510]  [<ffffffff810f0001>] ? kdb_register_repeat+0xe1/0x270^M
> [  939.819600]  [<ffffffffa0542ef9>] cache_preresume+0xf9/0x1a0
> [dm_cache]^M
> [  939.827137]  [<ffffffffa0005ff9>] dm_table_resume_targets+0x49/0xe0
> [dm_mod]^M
> [  939.835103]  [<ffffffffa000389c>] dm_resume+0x4c/0xd0 [dm_mod]^M
> [  939.841870]  [<ffffffffa0008bcb>] dev_suspend+0x12b/0x250 [dm_mod]^M
> [  939.848955]  [<ffffffffa0008aa0>] ? table_load+0x380/0x380 [dm_mod]^M
> [  939.856118]  [<ffffffffa00094e5>] ctl_ioctl+0x255/0x500 [dm_mod]^M
> [  939.863040]  [<ffffffff8123d7c4>] ? SYSC_semtimedop+0x264/0xd10^M
> [  939.869844]  [<ffffffffa00097a3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]^M
> [  939.876845]  [<ffffffff811c2c15>] do_vfs_ioctl+0x2e5/0x4c0^M
> [  939.883229]  [<ffffffff8123c2c9>] ? sem_security+0x9/0x10^M
> [  939.889496]  [<ffffffff8123a8c9>] ? ipcget+0x149/0x1c0^M
> [  939.895492]  [<ffffffff811c2e91>] SyS_ioctl+0xa1/0xc0^M
> [  939.901395]  [<ffffffff815f2799>] system_call_fastpath+0x16/0x1b^M
> [  939.908205] Code: 90 66 66 66 66 90 8b 47 08 85 c0 74 1e 83 e8 01 55 89
> 47 08 48 98 48 8b 74 c7 10 48 8b 07 48 89 e5 48 8b 38 e8 38 d4 ff ff 5d c3
> <0f> 0b 0f 1f 40 00 66 66 66 66 90 8b 47 08 85 c0 74 15 83 e8 01 ^M
> [  939.930089] RIP  [<ffffffffa052e73a>] ro_pop+0x2a/0x30
> [dm_persistent_data]^M
> [  939.937872]  RSP <ffff883fcfe2bb20>^M
>
>
> Let me know if there is anything else I can do.
>
> On Mon, Sep 8, 2014 at 12:03 PM, Brassow Jonathan <jbrassow@redhat.com>
> wrote:
>
>>
>> On Sep 3, 2014, at 10:58 AM, Elvin Cako wrote:
>>
>> > Hello Jonathan,
>> >
>> > Thanks for the reply. In regards to the information you are seeking:
>> >
>> > 1) I've attached the output of the verbose vgchange command
>> >
>> > 2) By crash, I mean the machine hangs then automatically reboots itself.
>> >
>> > Hope that helps.
>> >
>>
>>
>> Thanks for providing the verbose output.  Everything seems to be going
>> fine until it just cuts off at the end.  Is there anything in the log that
>> might suggest what is going on from the kernel's perspective?
>>
>>  brassow
>>
>>
>
>
> --
> Elvin
>
>
>


-- 
Elvin

--047d7b86de5609a1ef0503ea2899
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Jonathan,<div><br></div><div>Thank you for your help.=C2=
=A0</div><div>Here is the kernel and lvm info:</div><div><br></div><div>Ker=
nel:</div><div>
<p style=3D"margin:0px;font-size:11px;font-family:Menlo">Linux =C2=A03.10.0=
-123.6.3.el7.x86_64 #1 SMP Wed Aug 6 21:12:36 UTC 2014 x86_64 x86_64 x86_64=
 GNU/Linux</p><p style=3D"margin:0px;font-size:11px;font-family:Menlo"><br>=
</p><p style=3D"margin:0px;font-size:11px;font-family:Menlo">LVM:</p><p sty=
le=3D"margin:0px;font-size:11px;font-family:Menlo">LVM TOOLS 2.02.105(2)-RH=
EL7 (2014-03-26)<br></p></div></div><div class=3D"gmail_extra"><br><div cla=
ss=3D"gmail_quote">On Wed, Sep 24, 2014 at 12:45 AM, Brassow Jonathan <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:jbrassow@redhat.com" target=3D"_blank">j=
brassow@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
<div style=3D"word-wrap:break-word"><div>Elvin,</div><div><br></div><div>I&=
#39;ll forward this on to the kernel-side development mailing list (<a href=
=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.com</a>).=
=C2=A0 I&#39;m sure they will probably want to know what kernel you are usi=
ng and whether your kernel and LVM packages are up-to-date.=C2=A0 I&#39;ve =
not seen a bug like this myself, but it looks similar to:</div><div>- <a hr=
ef=3D"https://bugzilla.redhat.com/1080894" target=3D"_blank">https://bugzil=
la.redhat.com/1080894</a></div><div>- <a href=3D"https://bugzilla.redhat.co=
m/1113759" target=3D"_blank">https://bugzilla.redhat.com/1113759</a></div><=
span class=3D"HOEnZb"><font color=3D"#888888"><div><br></div><div>=C2=A0bra=
ssow</div></font></span><div><div class=3D"h5"><br><div><div>On Sep 17, 201=
4, at 10:59 AM, Elvin Cako wrote:</div><br><blockquote type=3D"cite"><div d=
ir=3D"ltr">Hello Jonathan,<div><br></div><div>Here is the output of the ker=
nel log:</div><div><br></div><div><div style=3D"margin-top:0px;margin-right=
:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=
=C2=A0 933.985159] device-mapper: cache: Metadata device dm-3 is larger tha=
n 33292800 sectors: excess space will not be used.^M</div><div style=3D"mar=
gin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11=
px;font-family:Menlo">[=C2=A0 934.001112] device-mapper: cache-policy-mq: v=
ersion 1.2.0 loaded^M</div><div style=3D"margin-top:0px;margin-right:0px;ma=
rgin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 9=
37.261742] TECH PREVIEW: DM cache may not be fully supported.^M</div><div s=
tyle=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;f=
ont-size:11px;font-family:Menlo">[=C2=A0 937.261742] Please review provided=
 documentation for limitations.^M</div><div style=3D"margin-top:0px;margin-=
right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menl=
o">[=C2=A0 937.275035] bio: create slab &lt;bio-2&gt; at 2^M</div><div styl=
e=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font=
-size:11px;font-family:Menlo">[=C2=A0 939.495826] ------------[ cut here ]-=
-----------^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bot=
tom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.50113=
4] kernel BUG at drivers/md/persistent-data/dm-btree-spine.c:169!^M</div><d=
iv style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0=
px;font-size:11px;font-family:Menlo">[=C2=A0 939.508552] invalid opcode: 00=
00 [#1] SMP ^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bo=
ttom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.5132=
30] Modules linked in: dm_cache_mq dm_cache() dm_persistent_data dm_bio_pri=
son dm_bufio raid1 ext4 mbcache jbd2 sg ip6t_REJECT nf_conntrack_ipv6 nf_de=
frag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables iTCO_wdt iTC=
O_vendor_support coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32=
c_intel ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helpe=
r cryptd pcspkr sb_edac edac_core i2c_i801 ixgbe igb lpc_ich mdio ptp mei_m=
e mfd_core pps_core mei ioatdma ntb dca ses enclosure ipmi_devintf wmi shpc=
hp ipmi_si ipmi_msghandler mperf nfsd auth_rpcgss nfs_acl lockd sunrpc xfs =
libcrc32c sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrec=
t sysimgblt i2c_algo_bit drm_kms_helper ttm isci ahci drm libsas libahci li=
bata mpt2sas(OF) i2c_core raid_class scsi_transport_sas dm_mirror dm_region=
_hash dm_log dm_mod^M</div><div style=3D"margin-top:0px;margin-right:0px;ma=
rgin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 9=
39.594520] CPU: 31 PID: 7241 Comm: vgchange Tainted: GF=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 O-------------- T 3.10.0-123.6.3.el7.x86_64 #1^M</div><div s=
tyle=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;f=
ont-size:11px;font-family:Menlo">[=C2=A0 939.605410] Hardware name: Supermi=
cro SYS-F617R2-RT+/X9DRFR, BIOS 3.0b 04/24/2014^M</div><div style=3D"margin=
-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;=
font-family:Menlo">[=C2=A0 939.613653] task: ffff883fd0460b60 ti: ffff883fc=
fe2a000 task.ti: ffff883fcfe2a000^M</div><div style=3D"margin-top:0px;margi=
n-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Me=
nlo">[=C2=A0 939.621891] RIP: 0010:[&lt;ffffffffa052e73a&gt;]=C2=A0 [&lt;ff=
ffffffa052e73a&gt;] ro_pop+0x2a/0x30 [dm_persistent_data]^M</div><div style=
=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-=
size:11px;font-family:Menlo">[=C2=A0 939.631988] RSP: 0018:ffff883fcfe2bb20=
=C2=A0 EFLAGS: 00010246^M</div><div style=3D"margin-top:0px;margin-right:0p=
x;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=
=A0 939.638057] RAX: 0000000000000000 RBX: 0000000000000008 RCX: 0000000000=
000000^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0=
px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.645961] RD=
X: 0000000000000000 RSI: 0000000000000246 RDI: ffff883fcfe2bb80^M</div><div=
 style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px=
;font-size:11px;font-family:Menlo">[=C2=A0 939.653867] RBP: ffff883fcfe2bb7=
0 R08: 0000000000000000 R09: 0000000000000000^M</div><div style=3D"margin-t=
op:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;fo=
nt-family:Menlo">[=C2=A0 939.661774] R10: 0000000000000000 R11: 00000000000=
00002 R12: 0000000000000008^M</div><div style=3D"margin-top:0px;margin-righ=
t:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=
=C2=A0 939.669687] R13: ffffffffa05277a0 R14: ffff883fcfe2bbd0 R15: ffff883=
e02f2a000^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-botto=
m:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.677596]=
 FS:=C2=A0 00007ff8d7333880(0000) GS:ffff88407fde0000(0000) knlGS:000000000=
0000000^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:=
0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.686477] C=
S:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M</div><div style=3D"=
margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size=
:11px;font-family:Menlo">[=C2=A0 939.693034] CR2: 00007f0139cfd50a CR3: 000=
0003fcfb75000 CR4: 00000000000407e0^M</div><div style=3D"margin-top:0px;mar=
gin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:=
Menlo">[=C2=A0 939.700986] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=
 0000000000000000^M</div><div style=3D"margin-top:0px;margin-right:0px;marg=
in-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939=
.708930] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^=
M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;marg=
in-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.716858] Stack:^M<=
/div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin=
-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.719691]=C2=A0 fffff=
fffa052c5a2 00000000000001fd ffff883fcfe2bb80 ffff883fcfe2bba0^M</div><div =
style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;=
font-size:11px;font-family:Menlo">[=C2=A0 939.728009]=C2=A0 000000006c9004a=
8 0000000000000106 ffffffffa05277a0 ffff883fcfe2bbd0^M</div><div style=3D"m=
argin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:=
11px;font-family:Menlo">[=C2=A0 939.736314]=C2=A0 ffff883fd2956800 ffff883f=
cb86d800 ffff883fcfe2bbc0 ffffffffa052d21e^M</div><div style=3D"margin-top:=
0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-=
family:Menlo">[=C2=A0 939.744615] Call Trace:^M</div><div style=3D"margin-t=
op:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;fo=
nt-family:Menlo">[=C2=A0 939.747897]=C2=A0 [&lt;ffffffffa052c5a2&gt;] ? wal=
k_node+0xc2/0x100 [dm_persistent_data]^M</div><div style=3D"margin-top:0px;=
margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-fami=
ly:Menlo">[=C2=A0 939.755880]=C2=A0 [&lt;ffffffffa05277a0&gt;] ? block_dec+=
0x160/0x160 [dm_persistent_data]^M</div><div style=3D"margin-top:0px;margin=
-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Men=
lo">[=C2=A0 939.763965]=C2=A0 [&lt;ffffffffa052d21e&gt;] dm_btree_walk+0x4e=
/0x80 [dm_persistent_data]^M</div><div style=3D"margin-top:0px;margin-right=
:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=
=C2=A0 939.772045]=C2=A0 [&lt;ffffffffa0540a30&gt;] ? complete_migration+0x=
30/0x30 [dm_cache]^M</div><div style=3D"margin-top:0px;margin-right:0px;mar=
gin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 93=
9.779854]=C2=A0 [&lt;ffffffffa05275dc&gt;] dm_array_walk+0x3c/0x60 [dm_pers=
istent_data]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bo=
ttom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.7879=
26]=C2=A0 [&lt;ffffffffa0543700&gt;] ? blocks_are_unmapped_or_clean+0xd0/0x=
d0 [dm_cache]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-b=
ottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.796=
622]=C2=A0 [&lt;ffffffffa054451f&gt;] dm_cache_load_mappings+0x7f/0xe0 [dm_=
cache]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0=
px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.804642]=C2=
=A0 [&lt;ffffffffa0540a30&gt;] ? complete_migration+0x30/0x30 [dm_cache]^M<=
/div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin=
-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.812510]=C2=A0 [&lt;=
ffffffff810f0001&gt;] ? kdb_register_repeat+0xe1/0x270^M</div><div style=3D=
"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-siz=
e:11px;font-family:Menlo">[=C2=A0 939.819600]=C2=A0 [&lt;ffffffffa0542ef9&g=
t;] cache_preresume+0xf9/0x1a0 [dm_cache]^M</div><div style=3D"margin-top:0=
px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-f=
amily:Menlo">[=C2=A0 939.827137]=C2=A0 [&lt;ffffffffa0005ff9&gt;] dm_table_=
resume_targets+0x49/0xe0 [dm_mod]^M</div><div style=3D"margin-top:0px;margi=
n-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Me=
nlo">[=C2=A0 939.835103]=C2=A0 [&lt;ffffffffa000389c&gt;] dm_resume+0x4c/0x=
d0 [dm_mod]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bot=
tom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.84187=
0]=C2=A0 [&lt;ffffffffa0008bcb&gt;] dev_suspend+0x12b/0x250 [dm_mod]^M</div=
><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-lef=
t:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.848955]=C2=A0 [&lt;ffff=
ffffa0008aa0&gt;] ? table_load+0x380/0x380 [dm_mod]^M</div><div style=3D"ma=
rgin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:1=
1px;font-family:Menlo">[=C2=A0 939.856118]=C2=A0 [&lt;ffffffffa00094e5&gt;]=
 ctl_ioctl+0x255/0x500 [dm_mod]^M</div><div style=3D"margin-top:0px;margin-=
right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menl=
o">[=C2=A0 939.863040]=C2=A0 [&lt;ffffffff8123d7c4&gt;] ? SYSC_semtimedop+0=
x264/0xd10^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bott=
om:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.869844=
]=C2=A0 [&lt;ffffffffa00097a3&gt;] dm_ctl_ioctl+0x13/0x20 [dm_mod]^M</div><=
div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:=
0px;font-size:11px;font-family:Menlo">[=C2=A0 939.876845]=C2=A0 [&lt;ffffff=
ff811c2c15&gt;] do_vfs_ioctl+0x2e5/0x4c0^M</div><div style=3D"margin-top:0p=
x;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-fa=
mily:Menlo">[=C2=A0 939.883229]=C2=A0 [&lt;ffffffff8123c2c9&gt;] ? sem_secu=
rity+0x9/0x10^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-b=
ottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.889=
496]=C2=A0 [&lt;ffffffff8123a8c9&gt;] ? ipcget+0x149/0x1c0^M</div><div styl=
e=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font=
-size:11px;font-family:Menlo">[=C2=A0 939.895492]=C2=A0 [&lt;ffffffff811c2e=
91&gt;] SyS_ioctl+0xa1/0xc0^M</div><div style=3D"margin-top:0px;margin-righ=
t:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=
=C2=A0 939.901395]=C2=A0 [&lt;ffffffff815f2799&gt;] system_call_fastpath+0x=
16/0x1b^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:=
0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.908205] C=
ode: 90 66 66 66 66 90 8b 47 08 85 c0 74 1e 83 e8 01 55 89 47 08 48 98 48 8=
b 74 c7 10 48 8b 07 48 89 e5 48 8b 38 e8 38 d4 ff ff 5d c3 &lt;0f&gt; 0b 0f=
 1f 40 00 66 66 66 66 90 8b 47 08 85 c0 74 15 83 e8 01 ^M</div><div style=
=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-=
size:11px;font-family:Menlo">[=C2=A0 939.930089] RIP=C2=A0 [&lt;ffffffffa05=
2e73a&gt;] ro_pop+0x2a/0x30 [dm_persistent_data]^M</div><div style=3D"margi=
n-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px=
;font-family:Menlo">[=C2=A0 939.937872]=C2=A0 RSP &lt;ffff883fcfe2bb20&gt;^=
M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;marg=
in-left:0px;font-size:11px;font-family:Menlo"><br></div><div style=3D"margi=
n-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px=
;font-family:Menlo"><br></div><div style=3D"margin-top:0px;margin-right:0px=
;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">Let me=
 know if there is anything else I can do.</div></div></div><div class=3D"gm=
ail_extra"><br><div class=3D"gmail_quote">On Mon, Sep 8, 2014 at 12:03 PM, =
Brassow Jonathan <span dir=3D"ltr">&lt;<a href=3D"mailto:jbrassow@redhat.co=
m" target=3D"_blank">jbrassow@redhat.com</a>&gt;</span> wrote:<br><blockquo=
te class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc so=
lid;padding-left:1ex"><span><br>
On Sep 3, 2014, at 10:58 AM, Elvin Cako wrote:<br>
<br>
&gt; Hello Jonathan,<br>
&gt;<br>
&gt; Thanks for the reply. In regards to the information you are seeking:<b=
r>
&gt;<br>
&gt; 1) I&#39;ve attached the output of the verbose vgchange command<br>
&gt;<br>
&gt; 2) By crash, I mean the machine hangs then automatically reboots itsel=
f.<br>
&gt;<br>
&gt; Hope that helps.<br>
&gt;<br>
<br>
<br>
</span>Thanks for providing the verbose output.=C2=A0 Everything seems to b=
e going fine until it just cuts off at the end.=C2=A0 Is there anything in =
the log that might suggest what is going on from the kernel&#39;s perspecti=
ve?<br>
<span><font color=3D"#888888"><br>
=C2=A0brassow<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div dir=3D"ltr">Elvin</div>
</div>
</blockquote></div><br></div></div></div></blockquote></div><br><br clear=
=3D"all"><div><br></div>-- <br><div dir=3D"ltr">Elvin</div>
</div>

--047d7b86de5609a1ef0503ea2899--


--===============4140096817755161774==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4140096817755161774==--
