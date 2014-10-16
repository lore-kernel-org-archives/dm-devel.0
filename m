From: Elvin Cako <ecako@cogolabs.com>
Subject: Re: [data] Re: [linux-lvm] Setting up LVM cache causes
	crash
Date: Thu, 16 Oct 2014 14:31:57 -0400
Message-ID: <CACjhXxe+f4CFik7c_HLkZ_U5XyT+P3gWiknzrNWOW6tbyu20XA@mail.gmail.com>
References: <CACjhXxfZak7n=zBvfPX3FtpZeBM88eBm8RnweguOZjpwdoG0ew@mail.gmail.com>
	<590C03FA-0051-4DCF-B568-C0A47B16AA49@redhat.com>
	<CACjhXxdyw1Sx4iMKT7dMUFTRwd--zLpt8BK8iyedCj_bPiTCWg@mail.gmail.com>
	<99ACAC11-1051-4C96-A81F-E4B0845D3145@redhat.com>
	<CACjhXxcvqtBJ2h2efNRDu2FbhQ=v+S_X3NtBOzUb2rXo2L+9og@mail.gmail.com>
	<CF6395F0-64FC-4E39-BDD7-68A98AB6FEC2@redhat.com>
	<CACjhXxdVFNT=tkaeoRv=6dijeh6sov6jrXUm35XVnk4b48odzg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3441901535149957964=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACjhXxdVFNT=tkaeoRv=6dijeh6sov6jrXUm35XVnk4b48odzg@mail.gmail.com>
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

--===============3441901535149957964==
Content-Type: multipart/alternative; boundary=001a113cd2a8aa319905058e7626

--001a113cd2a8aa319905058e7626
Content-Type: text/plain; charset=UTF-8

Hello,

Any update on this issue?

Thanks,
Elvin

On Thu, Sep 25, 2014 at 5:05 PM, Elvin Cako <ecako@cogolabs.com> wrote:

> Jonathan,
>
> Thank you for your help.
> Here is the kernel and lvm info:
>
> Kernel:
>
> Linux  3.10.0-123.6.3.el7.x86_64 #1 SMP Wed Aug 6 21:12:36 UTC 2014 x86_64
> x86_64 x86_64 GNU/Linux
>
>
> LVM:
>
> LVM TOOLS 2.02.105(2)-RHEL7 (2014-03-26)
>
> On Wed, Sep 24, 2014 at 12:45 AM, Brassow Jonathan <jbrassow@redhat.com>
> wrote:
>
>> Elvin,
>>
>> I'll forward this on to the kernel-side development mailing list (
>> dm-devel@redhat.com).  I'm sure they will probably want to know what
>> kernel you are using and whether your kernel and LVM packages are
>> up-to-date.  I've not seen a bug like this myself, but it looks similar to:
>> - https://bugzilla.redhat.com/1080894
>> - https://bugzilla.redhat.com/1113759
>>
>>  brassow
>>
>> On Sep 17, 2014, at 10:59 AM, Elvin Cako wrote:
>>
>> Hello Jonathan,
>>
>> Here is the output of the kernel log:
>>
>> [  933.985159] device-mapper: cache: Metadata device dm-3 is larger than
>> 33292800 sectors: excess space will not be used.^M
>> [  934.001112] device-mapper: cache-policy-mq: version 1.2.0 loaded^M
>> [  937.261742] TECH PREVIEW: DM cache may not be fully supported.^M
>> [  937.261742] Please review provided documentation for limitations.^M
>> [  937.275035] bio: create slab <bio-2> at 2^M
>> [  939.495826] ------------[ cut here ]------------^M
>> [  939.501134] kernel BUG at
>> drivers/md/persistent-data/dm-btree-spine.c:169!^M
>> [  939.508552] invalid opcode: 0000 [#1] SMP ^M
>> [  939.513230] Modules linked in: dm_cache_mq dm_cache()
>> dm_persistent_data dm_bio_prison dm_bufio raid1 ext4 mbcache jbd2 sg
>> ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack
>> ip6table_filter ip6_tables iTCO_wdt iTCO_vendor_support coretemp kvm_intel
>> kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
>> aesni_intel lrw gf128mul glue_helper ablk_helper cryptd pcspkr sb_edac
>> edac_core i2c_i801 ixgbe igb lpc_ich mdio ptp mei_me mfd_core pps_core mei
>> ioatdma ntb dca ses enclosure ipmi_devintf wmi shpchp ipmi_si
>> ipmi_msghandler mperf nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c
>> sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect
>> sysimgblt i2c_algo_bit drm_kms_helper ttm isci ahci drm libsas libahci
>> libata mpt2sas(OF) i2c_core raid_class scsi_transport_sas dm_mirror
>> dm_region_hash dm_log dm_mod^M
>> [  939.594520] CPU: 31 PID: 7241 Comm: vgchange Tainted: GF
>> O-------------- T 3.10.0-123.6.3.el7.x86_64 #1^M
>> [  939.605410] Hardware name: Supermicro SYS-F617R2-RT+/X9DRFR, BIOS 3.0b
>> 04/24/2014^M
>> [  939.613653] task: ffff883fd0460b60 ti: ffff883fcfe2a000 task.ti:
>> ffff883fcfe2a000^M
>> [  939.621891] RIP: 0010:[<ffffffffa052e73a>]  [<ffffffffa052e73a>]
>> ro_pop+0x2a/0x30 [dm_persistent_data]^M
>> [  939.631988] RSP: 0018:ffff883fcfe2bb20  EFLAGS: 00010246^M
>> [  939.638057] RAX: 0000000000000000 RBX: 0000000000000008 RCX:
>> 0000000000000000^M
>> [  939.645961] RDX: 0000000000000000 RSI: 0000000000000246 RDI:
>> ffff883fcfe2bb80^M
>> [  939.653867] RBP: ffff883fcfe2bb70 R08: 0000000000000000 R09:
>> 0000000000000000^M
>> [  939.661774] R10: 0000000000000000 R11: 0000000000000002 R12:
>> 0000000000000008^M
>> [  939.669687] R13: ffffffffa05277a0 R14: ffff883fcfe2bbd0 R15:
>> ffff883e02f2a000^M
>> [  939.677596] FS:  00007ff8d7333880(0000) GS:ffff88407fde0000(0000)
>> knlGS:0000000000000000^M
>> [  939.686477] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
>> [  939.693034] CR2: 00007f0139cfd50a CR3: 0000003fcfb75000 CR4:
>> 00000000000407e0^M
>> [  939.700986] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000^M
>> [  939.708930] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400^M
>> [  939.716858] Stack:^M
>> [  939.719691]  ffffffffa052c5a2 00000000000001fd ffff883fcfe2bb80
>> ffff883fcfe2bba0^M
>> [  939.728009]  000000006c9004a8 0000000000000106 ffffffffa05277a0
>> ffff883fcfe2bbd0^M
>> [  939.736314]  ffff883fd2956800 ffff883fcb86d800 ffff883fcfe2bbc0
>> ffffffffa052d21e^M
>> [  939.744615] Call Trace:^M
>> [  939.747897]  [<ffffffffa052c5a2>] ? walk_node+0xc2/0x100
>> [dm_persistent_data]^M
>> [  939.755880]  [<ffffffffa05277a0>] ? block_dec+0x160/0x160
>> [dm_persistent_data]^M
>> [  939.763965]  [<ffffffffa052d21e>] dm_btree_walk+0x4e/0x80
>> [dm_persistent_data]^M
>> [  939.772045]  [<ffffffffa0540a30>] ? complete_migration+0x30/0x30
>> [dm_cache]^M
>> [  939.779854]  [<ffffffffa05275dc>] dm_array_walk+0x3c/0x60
>> [dm_persistent_data]^M
>> [  939.787926]  [<ffffffffa0543700>] ?
>> blocks_are_unmapped_or_clean+0xd0/0xd0 [dm_cache]^M
>> [  939.796622]  [<ffffffffa054451f>] dm_cache_load_mappings+0x7f/0xe0
>> [dm_cache]^M
>> [  939.804642]  [<ffffffffa0540a30>] ? complete_migration+0x30/0x30
>> [dm_cache]^M
>> [  939.812510]  [<ffffffff810f0001>] ? kdb_register_repeat+0xe1/0x270^M
>> [  939.819600]  [<ffffffffa0542ef9>] cache_preresume+0xf9/0x1a0
>> [dm_cache]^M
>> [  939.827137]  [<ffffffffa0005ff9>] dm_table_resume_targets+0x49/0xe0
>> [dm_mod]^M
>> [  939.835103]  [<ffffffffa000389c>] dm_resume+0x4c/0xd0 [dm_mod]^M
>> [  939.841870]  [<ffffffffa0008bcb>] dev_suspend+0x12b/0x250 [dm_mod]^M
>> [  939.848955]  [<ffffffffa0008aa0>] ? table_load+0x380/0x380 [dm_mod]^M
>> [  939.856118]  [<ffffffffa00094e5>] ctl_ioctl+0x255/0x500 [dm_mod]^M
>> [  939.863040]  [<ffffffff8123d7c4>] ? SYSC_semtimedop+0x264/0xd10^M
>> [  939.869844]  [<ffffffffa00097a3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]^M
>> [  939.876845]  [<ffffffff811c2c15>] do_vfs_ioctl+0x2e5/0x4c0^M
>> [  939.883229]  [<ffffffff8123c2c9>] ? sem_security+0x9/0x10^M
>> [  939.889496]  [<ffffffff8123a8c9>] ? ipcget+0x149/0x1c0^M
>> [  939.895492]  [<ffffffff811c2e91>] SyS_ioctl+0xa1/0xc0^M
>> [  939.901395]  [<ffffffff815f2799>] system_call_fastpath+0x16/0x1b^M
>> [  939.908205] Code: 90 66 66 66 66 90 8b 47 08 85 c0 74 1e 83 e8 01 55
>> 89 47 08 48 98 48 8b 74 c7 10 48 8b 07 48 89 e5 48 8b 38 e8 38 d4 ff ff 5d
>> c3 <0f> 0b 0f 1f 40 00 66 66 66 66 90 8b 47 08 85 c0 74 15 83 e8 01 ^M
>> [  939.930089] RIP  [<ffffffffa052e73a>] ro_pop+0x2a/0x30
>> [dm_persistent_data]^M
>> [  939.937872]  RSP <ffff883fcfe2bb20>^M
>>
>>
>> Let me know if there is anything else I can do.
>>
>> On Mon, Sep 8, 2014 at 12:03 PM, Brassow Jonathan <jbrassow@redhat.com>
>> wrote:
>>
>>>
>>> On Sep 3, 2014, at 10:58 AM, Elvin Cako wrote:
>>>
>>> > Hello Jonathan,
>>> >
>>> > Thanks for the reply. In regards to the information you are seeking:
>>> >
>>> > 1) I've attached the output of the verbose vgchange command
>>> >
>>> > 2) By crash, I mean the machine hangs then automatically reboots
>>> itself.
>>> >
>>> > Hope that helps.
>>> >
>>>
>>>
>>> Thanks for providing the verbose output.  Everything seems to be going
>>> fine until it just cuts off at the end.  Is there anything in the log that
>>> might suggest what is going on from the kernel's perspective?
>>>
>>>  brassow
>>>
>>>
>>
>>
>> --
>> Elvin
>>
>>
>>
>
>
> --
> Elvin
>



-- 
Elvin

--001a113cd2a8aa319905058e7626
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>Any update on this issue?</div><=
div><br></div><div>Thanks,</div><div>Elvin</div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, Sep 25, 2014 at 5:05 PM, Elvin Cako =
<span dir=3D"ltr">&lt;<a href=3D"mailto:ecako@cogolabs.com" target=3D"_blan=
k">ecako@cogolabs.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><div dir=3D"ltr">Jonathan,<div><br></div><div>Thank you for your help.=
=C2=A0</div><div>Here is the kernel and lvm info:</div><div><br></div><div>=
Kernel:</div><div>
<p style=3D"margin:0px;font-size:11px;font-family:Menlo">Linux =C2=A03.10.0=
-123.6.3.el7.x86_64 #1 SMP Wed Aug 6 21:12:36 UTC 2014 x86_64 x86_64 x86_64=
 GNU/Linux</p><p style=3D"margin:0px;font-size:11px;font-family:Menlo"><br>=
</p><p style=3D"margin:0px;font-size:11px;font-family:Menlo">LVM:</p><p sty=
le=3D"margin:0px;font-size:11px;font-family:Menlo">LVM TOOLS 2.02.105(2)-RH=
EL7 (2014-03-26)<br></p></div></div><div class=3D"gmail_extra"><div><div cl=
ass=3D"h5"><br><div class=3D"gmail_quote">On Wed, Sep 24, 2014 at 12:45 AM,=
 Brassow Jonathan <span dir=3D"ltr">&lt;<a href=3D"mailto:jbrassow@redhat.c=
om" target=3D"_blank">jbrassow@redhat.com</a>&gt;</span> wrote:<br><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex"><div style=3D"word-wrap:break-word"><div>Elvin,</div=
><div><br></div><div>I&#39;ll forward this on to the kernel-side developmen=
t mailing list (<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm=
-devel@redhat.com</a>).=C2=A0 I&#39;m sure they will probably want to know =
what kernel you are using and whether your kernel and LVM packages are up-t=
o-date.=C2=A0 I&#39;ve not seen a bug like this myself, but it looks simila=
r to:</div><div>- <a href=3D"https://bugzilla.redhat.com/1080894" target=3D=
"_blank">https://bugzilla.redhat.com/1080894</a></div><div>- <a href=3D"htt=
ps://bugzilla.redhat.com/1113759" target=3D"_blank">https://bugzilla.redhat=
.com/1113759</a></div><span><font color=3D"#888888"><div><br></div><div>=C2=
=A0brassow</div></font></span><div><div><br><div><div>On Sep 17, 2014, at 1=
0:59 AM, Elvin Cako wrote:</div><br><blockquote type=3D"cite"><div dir=3D"l=
tr">Hello Jonathan,<div><br></div><div>Here is the output of the kernel log=
:</div><div><br></div><div><div style=3D"margin-top:0px;margin-right:0px;ma=
rgin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 9=
33.985159] device-mapper: cache: Metadata device dm-3 is larger than 332928=
00 sectors: excess space will not be used.^M</div><div style=3D"margin-top:=
0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-=
family:Menlo">[=C2=A0 934.001112] device-mapper: cache-policy-mq: version 1=
.2.0 loaded^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bot=
tom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 937.26174=
2] TECH PREVIEW: DM cache may not be fully supported.^M</div><div style=3D"=
margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size=
:11px;font-family:Menlo">[=C2=A0 937.261742] Please review provided documen=
tation for limitations.^M</div><div style=3D"margin-top:0px;margin-right:0p=
x;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=
=A0 937.275035] bio: create slab &lt;bio-2&gt; at 2^M</div><div style=3D"ma=
rgin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:1=
1px;font-family:Menlo">[=C2=A0 939.495826] ------------[ cut here ]--------=
----^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px=
;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.501134] kern=
el BUG at drivers/md/persistent-data/dm-btree-spine.c:169!^M</div><div styl=
e=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font=
-size:11px;font-family:Menlo">[=C2=A0 939.508552] invalid opcode: 0000 [#1]=
 SMP ^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0p=
x;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.513230] Mod=
ules linked in: dm_cache_mq dm_cache() dm_persistent_data dm_bio_prison dm_=
bufio raid1 ext4 mbcache jbd2 sg ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ip=
v6 xt_conntrack nf_conntrack ip6table_filter ip6_tables iTCO_wdt iTCO_vendo=
r_support coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel=
 ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper crypt=
d pcspkr sb_edac edac_core i2c_i801 ixgbe igb lpc_ich mdio ptp mei_me mfd_c=
ore pps_core mei ioatdma ntb dca ses enclosure ipmi_devintf wmi shpchp ipmi=
_si ipmi_msghandler mperf nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc3=
2c sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysim=
gblt i2c_algo_bit drm_kms_helper ttm isci ahci drm libsas libahci libata mp=
t2sas(OF) i2c_core raid_class scsi_transport_sas dm_mirror dm_region_hash d=
m_log dm_mod^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bo=
ttom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.5945=
20] CPU: 31 PID: 7241 Comm: vgchange Tainted: GF=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 O-------------- T 3.10.0-123.6.3.el7.x86_64 #1^M</div><div style=3D=
"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-siz=
e:11px;font-family:Menlo">[=C2=A0 939.605410] Hardware name: Supermicro SYS=
-F617R2-RT+/X9DRFR, BIOS 3.0b 04/24/2014^M</div><div style=3D"margin-top:0p=
x;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-fa=
mily:Menlo">[=C2=A0 939.613653] task: ffff883fd0460b60 ti: ffff883fcfe2a000=
 task.ti: ffff883fcfe2a000^M</div><div style=3D"margin-top:0px;margin-right=
:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=
=C2=A0 939.621891] RIP: 0010:[&lt;ffffffffa052e73a&gt;]=C2=A0 [&lt;ffffffff=
a052e73a&gt;] ro_pop+0x2a/0x30 [dm_persistent_data]^M</div><div style=3D"ma=
rgin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:1=
1px;font-family:Menlo">[=C2=A0 939.631988] RSP: 0018:ffff883fcfe2bb20=C2=A0=
 EFLAGS: 00010246^M</div><div style=3D"margin-top:0px;margin-right:0px;marg=
in-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939=
.638057] RAX: 0000000000000000 RBX: 0000000000000008 RCX: 0000000000000000^=
M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;marg=
in-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.645961] RDX: 0000=
000000000000 RSI: 0000000000000246 RDI: ffff883fcfe2bb80^M</div><div style=
=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-=
size:11px;font-family:Menlo">[=C2=A0 939.653867] RBP: ffff883fcfe2bb70 R08:=
 0000000000000000 R09: 0000000000000000^M</div><div style=3D"margin-top:0px=
;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-fam=
ily:Menlo">[=C2=A0 939.661774] R10: 0000000000000000 R11: 0000000000000002 =
R12: 0000000000000008^M</div><div style=3D"margin-top:0px;margin-right:0px;=
margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0=
 939.669687] R13: ffffffffa05277a0 R14: ffff883fcfe2bbd0 R15: ffff883e02f2a=
000^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;=
margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.677596] FS:=
=C2=A0 00007ff8d7333880(0000) GS:ffff88407fde0000(0000) knlGS:0000000000000=
000^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;=
margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.686477] CS:=
=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M</div><div style=3D"ma=
rgin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:1=
1px;font-family:Menlo">[=C2=A0 939.693034] CR2: 00007f0139cfd50a CR3: 00000=
03fcfb75000 CR4: 00000000000407e0^M</div><div style=3D"margin-top:0px;margi=
n-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Me=
nlo">[=C2=A0 939.700986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0=
000000000000000^M</div><div style=3D"margin-top:0px;margin-right:0px;margin=
-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.7=
08930] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^M<=
/div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin=
-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.716858] Stack:^M</d=
iv><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-l=
eft:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.719691]=C2=A0 fffffff=
fa052c5a2 00000000000001fd ffff883fcfe2bb80 ffff883fcfe2bba0^M</div><div st=
yle=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;fo=
nt-size:11px;font-family:Menlo">[=C2=A0 939.728009]=C2=A0 000000006c9004a8 =
0000000000000106 ffffffffa05277a0 ffff883fcfe2bbd0^M</div><div style=3D"mar=
gin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11=
px;font-family:Menlo">[=C2=A0 939.736314]=C2=A0 ffff883fd2956800 ffff883fcb=
86d800 ffff883fcfe2bbc0 ffffffffa052d21e^M</div><div style=3D"margin-top:0p=
x;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-fa=
mily:Menlo">[=C2=A0 939.744615] Call Trace:^M</div><div style=3D"margin-top=
:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font=
-family:Menlo">[=C2=A0 939.747897]=C2=A0 [&lt;ffffffffa052c5a2&gt;] ? walk_=
node+0xc2/0x100 [dm_persistent_data]^M</div><div style=3D"margin-top:0px;ma=
rgin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family=
:Menlo">[=C2=A0 939.755880]=C2=A0 [&lt;ffffffffa05277a0&gt;] ? block_dec+0x=
160/0x160 [dm_persistent_data]^M</div><div style=3D"margin-top:0px;margin-r=
ight:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo=
">[=C2=A0 939.763965]=C2=A0 [&lt;ffffffffa052d21e&gt;] dm_btree_walk+0x4e/0=
x80 [dm_persistent_data]^M</div><div style=3D"margin-top:0px;margin-right:0=
px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=
=A0 939.772045]=C2=A0 [&lt;ffffffffa0540a30&gt;] ? complete_migration+0x30/=
0x30 [dm_cache]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin=
-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.7=
79854]=C2=A0 [&lt;ffffffffa05275dc&gt;] dm_array_walk+0x3c/0x60 [dm_persist=
ent_data]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-botto=
m:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.787926]=
=C2=A0 [&lt;ffffffffa0543700&gt;] ? blocks_are_unmapped_or_clean+0xd0/0xd0 =
[dm_cache]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bott=
om:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.796622=
]=C2=A0 [&lt;ffffffffa054451f&gt;] dm_cache_load_mappings+0x7f/0xe0 [dm_cac=
he]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;=
margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.804642]=C2=A0=
 [&lt;ffffffffa0540a30&gt;] ? complete_migration+0x30/0x30 [dm_cache]^M</di=
v><div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-le=
ft:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.812510]=C2=A0 [&lt;fff=
fffff810f0001&gt;] ? kdb_register_repeat+0xe1/0x270^M</div><div style=3D"ma=
rgin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:1=
1px;font-family:Menlo">[=C2=A0 939.819600]=C2=A0 [&lt;ffffffffa0542ef9&gt;]=
 cache_preresume+0xf9/0x1a0 [dm_cache]^M</div><div style=3D"margin-top:0px;=
margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-fami=
ly:Menlo">[=C2=A0 939.827137]=C2=A0 [&lt;ffffffffa0005ff9&gt;] dm_table_res=
ume_targets+0x49/0xe0 [dm_mod]^M</div><div style=3D"margin-top:0px;margin-r=
ight:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo=
">[=C2=A0 939.835103]=C2=A0 [&lt;ffffffffa000389c&gt;] dm_resume+0x4c/0xd0 =
[dm_mod]^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom=
:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.841870]=
=C2=A0 [&lt;ffffffffa0008bcb&gt;] dev_suspend+0x12b/0x250 [dm_mod]^M</div><=
div style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:=
0px;font-size:11px;font-family:Menlo">[=C2=A0 939.848955]=C2=A0 [&lt;ffffff=
ffa0008aa0&gt;] ? table_load+0x380/0x380 [dm_mod]^M</div><div style=3D"marg=
in-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11p=
x;font-family:Menlo">[=C2=A0 939.856118]=C2=A0 [&lt;ffffffffa00094e5&gt;] c=
tl_ioctl+0x255/0x500 [dm_mod]^M</div><div style=3D"margin-top:0px;margin-ri=
ght:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo"=
>[=C2=A0 939.863040]=C2=A0 [&lt;ffffffff8123d7c4&gt;] ? SYSC_semtimedop+0x2=
64/0xd10^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bottom=
:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.869844]=
=C2=A0 [&lt;ffffffffa00097a3&gt;] dm_ctl_ioctl+0x13/0x20 [dm_mod]^M</div><d=
iv style=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0=
px;font-size:11px;font-family:Menlo">[=C2=A0 939.876845]=C2=A0 [&lt;fffffff=
f811c2c15&gt;] do_vfs_ioctl+0x2e5/0x4c0^M</div><div style=3D"margin-top:0px=
;margin-right:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-fam=
ily:Menlo">[=C2=A0 939.883229]=C2=A0 [&lt;ffffffff8123c2c9&gt;] ? sem_secur=
ity+0x9/0x10^M</div><div style=3D"margin-top:0px;margin-right:0px;margin-bo=
ttom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=C2=A0 939.8894=
96]=C2=A0 [&lt;ffffffff8123a8c9&gt;] ? ipcget+0x149/0x1c0^M</div><div style=
=3D"margin-top:0px;margin-right:0px;margin-bottom:0px;margin-left:0px;font-=
size:11px;font-family:Menlo">[=C2=A0 939.895492]=C2=A0 [&lt;ffffffff811c2e9=
1&gt;] SyS_ioctl+0xa1/0xc0^M</div><div style=3D"margin-top:0px;margin-right=
:0px;margin-bottom:0px;margin-left:0px;font-size:11px;font-family:Menlo">[=
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
=3D"all"><div><br></div></div></div><span class=3D"HOEnZb"><font color=3D"#=
888888">-- <br><div dir=3D"ltr">Elvin</div>
</font></span></div>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div dir=3D"=
ltr">Elvin</div>
</div></div>

--001a113cd2a8aa319905058e7626--


--===============3441901535149957964==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3441901535149957964==--
