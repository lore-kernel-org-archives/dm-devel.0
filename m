From: Vladimir Smolensky <arizal@gmail.com>
Subject: Re: dm-cache fs corruption
Date: Sat, 30 Nov 2013 16:28:09 +0200
Message-ID: <CALwk7=yrb4awYXdyGdf5fAY8pW3=k6b+eabeDA2mooeyetBWYg@mail.gmail.com>
References: <CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
	<20131113144112.GF13882@debian>
	<CALwk7=zWxL1QD3_pujA-QpWOCLLbJKT31p5HqTrzJwYPETh26g@mail.gmail.com>
	<CALwk7=xi2NBOE+bGcoygtsqFYzSE8a7DsC7p7MCRd06QU6jihQ@mail.gmail.com>
	<33A0129EBFD46748804DE81B354CA1B21C031F48@SACEXCMBX06-PRD.hq.netapp.com>
	<20131114143832.GC17651@debian>
	<CALwk7=xBTqtOQqXx6WnGyLAAXz4+wrQ9W3MOjs66mWBRhmqxBw@mail.gmail.com>
	<CALwk7=xGynqqH2CN8Eop7qioSR9FGVt7AmGRLkwWXC87KVO8WA@mail.gmail.com>
	<CALwk7=wgChKoSqnj_CJwRfnRRwrfNnjPkr-zVGKunOTSjWz2Pw@mail.gmail.com>
	<CALwk7=x72BKSFgja2zy38qfusEwTSebcaFBpuAkOaed0F-zJcQ@mail.gmail.com>
	<20131128172813.GA24861@debian>
	<CALwk7=xGqvqsiyGUryFdvuiM76iF6MY+wc4NSa==JGmR3vtZTA@mail.gmail.com>
	<CALwk7=xHQBb9wGcvo-0zhnd7rBaMUXhai2MyVC=WaQ58j8LkQg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4696608402200782884=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALwk7=xHQBb9wGcvo-0zhnd7rBaMUXhai2MyVC=WaQ58j8LkQg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============4696608402200782884==
Content-Type: multipart/alternative; boundary=001a11c229a284f7a504ec65c13e

--001a11c229a284f7a504ec65c13e
Content-Type: text/plain; charset=ISO-8859-1

Hello, the device broke after about a day:

dmesg:

[83086.878182] device-mapper: space map metadata: unable to allocate new
metadata block
[83088.879861] device-mapper: space map metadata: unable to allocate new
metadata block
[83089.414700] device-mapper: space map metadata: unable to allocate new
metadata block
[83089.414706] device-mapper: cache: could not commit metadata for accurate
status
[83090.881533] device-mapper: space map metadata: unable to allocate new
metadata block
[83092.883142] device-mapper: space map metadata: unable to allocate new
metadata block
[83094.884719] device-mapper: space map metadata: unable to allocate new
metadata block
[83096.886355] device-mapper: space map metadata: unable to allocate new
metadata block
[83097.712195] device-mapper: space map metadata: unable to allocate new
metadata block
[83097.712200] device-mapper: cache: could not commit metadata for accurate
status
[83098.283947] device-mapper: space map metadata: unable to allocate new
metadata block
[83098.283952] device-mapper: cache: could not commit metadata for accurate
status
[83098.729396] device-mapper: space map metadata: unable to allocate new
metadata block
[83098.729401] device-mapper: cache: could not commit metadata for accurate
status

dmsetup status:
storage: 0 40963653632 cache 249856/249856 26968230 2678513 711227 30042060
0 248746 248729 0 1 writeback 2 migration_threshold 100000000 4
random_threshold 4 sequential_threshold 10000000

Obviously the metadata partition is full but accourding to the formula I
use it should be more than enough =>  4 MB + ( 16 bytes * nr_blocks ) I get
13341184 ~ 13MB and metadata partiton is 1024MB

device sizes:
 # blockdev --report
RO    RA   SSZ   BSZ   StartSec            Size   Device
rw   256   512  4096          0     26843414528   /dev/sda
rw   256   512  4096       2048      4094689280   /dev/sda1
rw   256   512  4096    7999488     22746759168   /dev/sda2
rw  2048   512  4096          0  20973392756736   /dev/sdb
rw  2048   512  4096       2048  20973390659584   /dev/sdb1
rw  2048   512  4096          0   2397799710720   /dev/sdc
rw  2048   512  4096       2048      1023410176   /dev/sdc1
rw  2048   512  4096    2000896   2396774203392   /dev/sdc2
rw  2048   512   512          0  20973390659584   /dev/dm-0


What am I doing wrong?



regards.



On Fri, Nov 29, 2013 at 5:06 PM, Vladimir Smolensky <arizal@gmail.com>wrote:

> Ok, I compiled it and will test if it works.
>
> When I try to make my cache with blocksize smaller than 8192  I get
>
> # dmsetup  create storage --table '0 40963653632 cache /dev/sdc1 /dev/sdc2
> /dev/sdb1 4096 1 writeback default 0'
> device-mapper: reload ioctl on storage failed: Cannot allocate memory
> Command failed
>
> dnesg:
>
> [  664.940597] device-mapper: cache-policy-mq: version 1.1.0 loaded
> [  665.002924] ------------[ cut here ]------------
> [  665.002943] WARNING: CPU: 0 PID: 18271 at mm/page_alloc.c:2484
> __alloc_pages_nodemask+0x73d/0x820()
> [  665.002945] Modules linked in: dm_cache_mq dm_cache dm_bio_prison
> dm_persistent_data dm_bufio ipv6 bonding coretemp ixgbe i7core_edac
> edac_core kvm processor pcspkr hed button bnx2 dcdbas dca mdio ehci_pci
> thermal_sys microcode joydev sha256_generic libiscsi scsi_transport_iscsi
> tg3 ptp pps_core libphy e1000 fuse nfs lockd sunrpc jfs multipath linear
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor
> async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_region_hash
> dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx
> hid_gyration sl811_hcd usbhid ohci_hcd uhci_hcd usb_storage ehci_hcd
> usbcore usb_common mpt2sas raid_class aic94xx libsas lpfc crc_t10dif
> crct10dif_common qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid
> aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc
> scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280
> imm parport dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx
> aic79xx scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci
> libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via
> sata_svw sata_sil24 sata_sil sata_promise pata_sl82c105 pata_cs5530
> pata_cs5520 pata_via pata_jmicron pata_marvell pata_sis pata_netcell
> pata_sc1200 pata_pdc202xx_old pata_triflex pata_atiixp pata_opti pata_amd
> pata_ali pata_it8213 pata_ns87415 pata_ns87410 pata_serverworks pata_artop
> pata_it821x pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366
> pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys pata_pdc2027x
> pata_mpiix libata
> [  665.003077] CPU: 0 PID: 18271 Comm: dmsetup Not tainted 3.12.0-rc5+ #1
> [  665.003079] Hardware name: Dell Inc. PowerEdge R510/0DPRKF, BIOS 1.5.3
> 10/25/2010
> [  665.003082]  00000000000009b4 ffff881fada458f8 ffffffff81595198
> 00000000000009b4
> [  665.003085]  0000000000000000 ffff881fada45938 ffffffff81043a62
> ffff881fada45918
> [  665.003088]  0000000000000000 ffff881fae8a0000 0000000000000000
> 0000000000000002
> [  665.003092] Call Trace:
> [  665.003101]  [<ffffffff81595198>] dump_stack+0x49/0x61
> [  665.003107]  [<ffffffff81043a62>] warn_slowpath_common+0x82/0xb0
> [  665.003111]  [<ffffffff81043aa5>] warn_slowpath_null+0x15/0x20
> [  665.003114]  [<ffffffff810c595d>] __alloc_pages_nodemask+0x73d/0x820
> [  665.003120]  [<ffffffffa14405b7>] ? mq_create+0x187/0x3a0 [dm_cache_mq]
> [  665.003124]  [<ffffffff810c5ac2>] __get_free_pages+0x12/0x50
> [  665.003130]  [<ffffffff810f69cb>] __kmalloc+0xeb/0xf0
> [  665.003134]  [<ffffffffa1440767>] mq_create+0x337/0x3a0 [dm_cache_mq]
> [  665.003139]  [<ffffffffa1436faa>] dm_cache_policy_create+0x4a/0xcc
> [dm_cache]
> [  665.003143]  [<ffffffffa14339d1>] cache_ctr+0x4a1/0xd40 [dm_cache]
> [  665.003152]  [<ffffffffa065dbb8>] ? dm_split_args+0x78/0x140 [dm_mod]
> [  665.003159]  [<ffffffffa065ddba>] dm_table_add_target+0x13a/0x390
> [dm_mod]
> [  665.003166]  [<ffffffffa0660eb0>] table_load+0xd0/0x330 [dm_mod]
> [  665.003173]  [<ffffffffa0660de0>] ? table_clear+0xd0/0xd0 [dm_mod]
> [  665.003179]  [<ffffffffa0662032>] ctl_ioctl+0x1d2/0x410 [dm_mod]
> [  665.003187]  [<ffffffff8103a718>] ? __do_page_fault+0x208/0x4e0
> [  665.003193]  [<ffffffffa066227e>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
> [  665.003198]  [<ffffffff8110bd2e>] do_vfs_ioctl+0x8e/0x4e0
> [  665.003202]  [<ffffffff810fbc09>] ? ____fput+0x9/0x10
> [  665.003205]  [<ffffffff8110c1d2>] SyS_ioctl+0x52/0x80
> [  665.003211]  [<ffffffff815996f9>] system_call_fastpath+0x16/0x1b
> [  665.003213] ---[ end trace 2afe5f836777e03f ]---
> [  665.008704] device-mapper: table: 253:0: cache: Error creating cache's
> policy
> [  665.008712] device-mapper: ioctl: error adding target to table
>
>
> # blockdev --report
> RO    RA   SSZ   BSZ   StartSec            Size   Device
> rw   256   512  4096          0     26843414528   /dev/sda
> rw   256   512  4096       2048      4094689280   /dev/sda1
> rw   256   512  4096    7999488     22746759168   /dev/sda2
> rw   256   512  4096          0  20973392756736   /dev/sdb
> rw   256   512  4096       2048  20973390659584   /dev/sdb1
> rw   256   512  4096          0   2397799710720   /dev/sdc
> rw   256   512  4096       2048      1023410176   /dev/sdc1
> rw   256   512  4096    2000896   2396774203392   /dev/sdc2
>
> regards.
>
>
>
> On Fri, Nov 29, 2013 at 3:34 PM, Vladimir Smolensky <arizal@gmail.com>wrote:
>
>> This is complete kernel, right?
>>
>>
>> On Thu, Nov 28, 2013 at 7:28 PM, Joe Thornber <thornber@redhat.com>wrote:
>>
>>> On Thu, Nov 28, 2013 at 06:50:39PM +0200, Vladimir Smolensky wrote:
>>> > Hello, I would like to test the latest dm-cache available to see if the
>>> > problem I was having still exists. Where can I get this code?
>>>
>>> My latest stable code lives in the 'thin-dev' branch of my github tree:
>>>
>>> https://github.com/jthornber/linux-2.6/tree/thin-dev
>>>
>>> This has the latest versions of both the thin-provisioning and cache
>>> targets, and will shortly have the era target too.
>>>
>>>
>>> - Joe
>>>
>>> --
>>> dm-devel mailing list
>>> dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>
>>
>>
>

--001a11c229a284f7a504ec65c13e
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hello, the device broke after about a =
day:<br><br></div>dmesg:<br><br>[83086.878182] device-mapper: space map met=
adata: unable to allocate new metadata block<br>[83088.879861] device-mappe=
r: space map metadata: unable to allocate new metadata block<br>
[83089.414700] device-mapper: space map metadata: unable to allocate new me=
tadata block<br>[83089.414706] device-mapper: cache: could not commit metad=
ata for accurate status<br>[83090.881533] device-mapper: space map metadata=
: unable to allocate new metadata block<br>
[83092.883142] device-mapper: space map metadata: unable to allocate new me=
tadata block<br>[83094.884719] device-mapper: space map metadata: unable to=
 allocate new metadata block<br>[83096.886355] device-mapper: space map met=
adata: unable to allocate new metadata block<br>
[83097.712195] device-mapper: space map metadata: unable to allocate new me=
tadata block<br>[83097.712200] device-mapper: cache: could not commit metad=
ata for accurate status<br>[83098.283947] device-mapper: space map metadata=
: unable to allocate new metadata block<br>
[83098.283952] device-mapper: cache: could not commit metadata for accurate=
 status<br>[83098.729396] device-mapper: space map metadata: unable to allo=
cate new metadata block<br>[83098.729401] device-mapper: cache: could not c=
ommit metadata for accurate status<br>
<br>dmsetup status:<br></div>storage: 0 40963653632 cache 249856/249856 269=
68230 2678513 711227 30042060 0 248746 248729 0 1 writeback 2 migration_thr=
eshold 100000000 4 random_threshold 4 sequential_threshold 10000000<br>
<br></div>Obviously the metadata partition is full but accourding to the fo=
rmula I use it should be more than enough =3D&gt;=A0 <code>4 MB + ( 16 byte=
s * nr_blocks ) I get 13341184 ~ 13MB and metadata partiton is 1024MB<br><b=
r>
</code></div><div><code>device sizes:<br>=A0# blockdev --report<br>RO=A0=A0=
=A0 RA=A0=A0 SSZ=A0=A0 BSZ=A0=A0 StartSec=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
Size=A0=A0 Device<br>rw=A0=A0 256=A0=A0 512=A0 4096=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0 26843414528=A0=A0 /dev/sda<br>rw=A0=A0 256=A0=A0 512=A0 4=
096=A0=A0=A0=A0=A0=A0 2048=A0=A0=A0=A0=A0 4094689280=A0=A0 /dev/sda1<br>
rw=A0=A0 256=A0=A0 512=A0 4096=A0=A0=A0 7999488=A0=A0=A0=A0 22746759168=A0=
=A0 /dev/sda2<br>rw=A0 2048=A0=A0 512=A0 4096=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=
=A0 20973392756736=A0=A0 /dev/sdb<br>rw=A0 2048=A0=A0 512=A0 4096=A0=A0=A0=
=A0=A0=A0 2048=A0 20973390659584=A0=A0 /dev/sdb1<br>rw=A0 2048=A0=A0 512=A0=
 4096=A0=A0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0 2397799710720=A0=A0 /dev/sdc<br>
rw=A0 2048=A0=A0 512=A0 4096=A0=A0=A0=A0=A0=A0 2048=A0=A0=A0=A0=A0 10234101=
76=A0=A0 /dev/sdc1<br>rw=A0 2048=A0=A0 512=A0 4096=A0=A0=A0 2000896=A0=A0 2=
396774203392=A0=A0 /dev/sdc2<br>rw=A0 2048=A0=A0 512=A0=A0 512=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 0=A0 20973390659584=A0=A0 /dev/dm-0<br><br></code></div><di=
v><code><br>
</code></div><div><code>What am I doing wrong?<br><br><br></code></div><div=
><code><br></code></div><code>regards.<br><br></code></div><div class=3D"gm=
ail_extra"><br><br><div class=3D"gmail_quote">On Fri, Nov 29, 2013 at 5:06 =
PM, Vladimir Smolensky <span dir=3D"ltr">&lt;<a href=3D"mailto:arizal@gmail=
.com" target=3D"_blank">arizal@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>Ok, I compiled it and =
will test if it works.<br><br></div><div>When I try to make my cache with b=
locksize smaller than 8192=A0 I get<br>
<br># dmsetup=A0 create storage --table &#39;0 40963653632 cache /dev/sdc1 =
/dev/sdc2 /dev/sdb1 4096 1 writeback default 0&#39;<br>
device-mapper: reload ioctl on storage failed: Cannot allocate memory<br>Co=
mmand failed<br><br></div><div>dnesg:<br><br>[=A0 664.940597] device-mapper=
: cache-policy-mq: version 1.1.0 loaded<br>[=A0 665.002924] ------------[ c=
ut here ]------------<br>

[=A0 665.002943] WARNING: CPU: 0 PID: 18271 at mm/page_alloc.c:2484 __alloc=
_pages_nodemask+0x73d/0x820()<br>[=A0 665.002945] Modules linked in: dm_cac=
he_mq dm_cache dm_bio_prison dm_persistent_data dm_bufio ipv6 bonding coret=
emp ixgbe i7core_edac edac_core kvm processor pcspkr hed button bnx2 dcdbas=
 dca mdio ehci_pci thermal_sys microcode joydev sha256_generic libiscsi scs=
i_transport_iscsi tg3 ptp pps_core libphy e1000 fuse nfs lockd sunrpc jfs m=
ultipath linear raid10 raid456 async_raid6_recov async_memcpy async_pq asyn=
c_xor xor async_tx raid6_pq raid1 raid0 dm_snapshot dm_crypt dm_mirror dm_r=
egion_hash dm_log dm_mod hid_sunplus hid_sony hid_samsung hid_pl hid_petaly=
nx hid_gyration sl811_hcd usbhid ohci_hcd uhci_hcd usb_storage ehci_hcd usb=
core usb_common mpt2sas raid_class aic94xx libsas lpfc crc_t10dif crct10dif=
_common qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8=
 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc scsi_transpor=
t_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 imm parport dm=
x3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx aic79xx scsi_=
transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_=
qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_si=
l24 sata_sil sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pa=
ta_jmicron pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old=
 pata_triflex pata_atiixp pata_opti pata_amd pata_ali pata_it8213 pata_ns87=
415 pata_ns87410 pata_serverworks pata_artop pata_it821x pata_optidma pata_=
hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz10=
00 pata_sil680 pata_radisys pata_pdc2027x pata_mpiix libata<br>

[=A0 665.003077] CPU: 0 PID: 18271 Comm: dmsetup Not tainted 3.12.0-rc5+ #1=
<br>[=A0 665.003079] Hardware name: Dell Inc. PowerEdge R510/0DPRKF, BIOS 1=
.5.3 10/25/2010<br>[=A0 665.003082]=A0 00000000000009b4 ffff881fada458f8 ff=
ffffff81595198 00000000000009b4<br>

[=A0 665.003085]=A0 0000000000000000 ffff881fada45938 ffffffff81043a62 ffff=
881fada45918<br>[=A0 665.003088]=A0 0000000000000000 ffff881fae8a0000 00000=
00000000000 0000000000000002<br>[=A0 665.003092] Call Trace:<br>[=A0 665.00=
3101]=A0 [&lt;ffffffff81595198&gt;] dump_stack+0x49/0x61<br>

[=A0 665.003107]=A0 [&lt;ffffffff81043a62&gt;] warn_slowpath_common+0x82/0x=
b0<br>[=A0 665.003111]=A0 [&lt;ffffffff81043aa5&gt;] warn_slowpath_null+0x1=
5/0x20<br>[=A0 665.003114]=A0 [&lt;ffffffff810c595d&gt;] __alloc_pages_node=
mask+0x73d/0x820<br>

[=A0 665.003120]=A0 [&lt;ffffffffa14405b7&gt;] ? mq_create+0x187/0x3a0 [dm_=
cache_mq]<br>[=A0 665.003124]=A0 [&lt;ffffffff810c5ac2&gt;] __get_free_page=
s+0x12/0x50<br>[=A0 665.003130]=A0 [&lt;ffffffff810f69cb&gt;] __kmalloc+0xe=
b/0xf0<br>

[=A0 665.003134]=A0 [&lt;ffffffffa1440767&gt;] mq_create+0x337/0x3a0 [dm_ca=
che_mq]<br>[=A0 665.003139]=A0 [&lt;ffffffffa1436faa&gt;] dm_cache_policy_c=
reate+0x4a/0xcc [dm_cache]<br>[=A0 665.003143]=A0 [&lt;ffffffffa14339d1&gt;=
] cache_ctr+0x4a1/0xd40 [dm_cache]<br>

[=A0 665.003152]=A0 [&lt;ffffffffa065dbb8&gt;] ? dm_split_args+0x78/0x140 [=
dm_mod]<br>[=A0 665.003159]=A0 [&lt;ffffffffa065ddba&gt;] dm_table_add_targ=
et+0x13a/0x390 [dm_mod]<br>[=A0 665.003166]=A0 [&lt;ffffffffa0660eb0&gt;] t=
able_load+0xd0/0x330 [dm_mod]<br>

[=A0 665.003173]=A0 [&lt;ffffffffa0660de0&gt;] ? table_clear+0xd0/0xd0 [dm_=
mod]<br>[=A0 665.003179]=A0 [&lt;ffffffffa0662032&gt;] ctl_ioctl+0x1d2/0x41=
0 [dm_mod]<br>[=A0 665.003187]=A0 [&lt;ffffffff8103a718&gt;] ? __do_page_fa=
ult+0x208/0x4e0<br>

[=A0 665.003193]=A0 [&lt;ffffffffa066227e&gt;] dm_ctl_ioctl+0xe/0x20 [dm_mo=
d]<br>[=A0 665.003198]=A0 [&lt;ffffffff8110bd2e&gt;] do_vfs_ioctl+0x8e/0x4e=
0<br>[=A0 665.003202]=A0 [&lt;ffffffff810fbc09&gt;] ? ____fput+0x9/0x10<br>=
[=A0 665.003205]=A0 [&lt;ffffffff8110c1d2&gt;] SyS_ioctl+0x52/0x80<br>

[=A0 665.003211]=A0 [&lt;ffffffff815996f9&gt;] system_call_fastpath+0x16/0x=
1b<br>[=A0 665.003213] ---[ end trace 2afe5f836777e03f ]---<br>[=A0 665.008=
704] device-mapper: table: 253:0: cache: Error creating cache&#39;s policy<=
br>
[=A0 665.008712] device-mapper: ioctl: error adding target to table<br>
</div><div><br><br># blockdev --report<br>RO=A0=A0=A0 RA=A0=A0 SSZ=A0=A0 BS=
Z=A0=A0 StartSec=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0=A0 Device<br>rw=
=A0=A0 <a href=3D"tel:256%C2%A0%C2%A0%20512%C2%A0%204096" value=3D"+1256512=
4096" target=3D"_blank">256=A0=A0 512=A0 4096</a>=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0=A0=A0 26843414528=A0=A0 /dev/sda<br>
rw=A0=A0 <a href=3D"tel:256%C2%A0%C2%A0%20512%C2%A0%204096" value=3D"+12565=
124096" target=3D"_blank">256=A0=A0 512=A0 4096</a>=A0=A0=A0=A0=A0=A0 2048=
=A0=A0=A0=A0=A0 <a href=3D"tel:4094689280" value=3D"+14094689280" target=3D=
"_blank">4094689280</a>=A0=A0 /dev/sda1<br>
rw=A0=A0 256=A0=A0 512=A0 4096=A0=A0=A0 7999488=A0=A0=A0=A0 22746759168=A0=
=A0 /dev/sda2<br>rw=A0=A0 <a href=3D"tel:256%C2%A0%C2%A0%20512%C2%A0%204096=
" value=3D"+12565124096" target=3D"_blank">256=A0=A0 512=A0 4096</a>=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 0=A0 20973392756736=A0=A0 /dev/sdb<br>rw=A0=A0 <a hre=
f=3D"tel:256%C2%A0%C2%A0%20512%C2%A0%204096" value=3D"+12565124096" target=
=3D"_blank">256=A0=A0 512=A0 4096</a>=A0=A0=A0=A0=A0=A0 2048=A0 20973390659=
584=A0=A0 /dev/sdb1<br>
rw=A0=A0 <a href=3D"tel:256%C2%A0%C2%A0%20512%C2%A0%204096" value=3D"+12565=
124096" target=3D"_blank">256=A0=A0 512=A0 4096</a>=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 0=A0=A0 2397799710720=A0=A0 /dev/sdc<br>
rw=A0=A0 <a href=3D"tel:256%C2%A0%C2%A0%20512%C2%A0%204096" value=3D"+12565=
124096" target=3D"_blank">256=A0=A0 512=A0 4096</a>=A0=A0=A0=A0=A0=A0 2048=
=A0=A0=A0=A0=A0 1023410176=A0=A0 /dev/sdc1<br>rw=A0=A0 256=A0=A0 512=A0 409=
6=A0=A0=A0 2000896=A0=A0 2396774203392=A0=A0 /dev/sdc2<br><br>
</div><div>regards.<br><br></div></div><div class=3D"HOEnZb"><div class=3D"=
h5"><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">
On Fri, Nov 29, 2013 at 3:34 PM, Vladimir Smolensky <span dir=3D"ltr">&lt;<=
a href=3D"mailto:arizal@gmail.com" target=3D"_blank">arizal@gmail.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div dir=3D"ltr">This is complete kernel, right?<br></div><div><div><div cl=
ass=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Thu, Nov 28, 2013=
 at 7:28 PM, Joe Thornber <span dir=3D"ltr">&lt;<a href=3D"mailto:thornber@=
redhat.com" target=3D"_blank">thornber@redhat.com</a>&gt;</span> wrote:<br>


<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div>On Thu, Nov 28, 2013 at 06:50:39PM +020=
0, Vladimir Smolensky wrote:<br>
&gt; Hello, I would like to test the latest dm-cache available to see if th=
e<br>
&gt; problem I was having still exists. Where can I get this code?<br>
<br>
</div>My latest stable code lives in the &#39;thin-dev&#39; branch of my gi=
thub tree:<br>
<br>
<a href=3D"https://github.com/jthornber/linux-2.6/tree/thin-dev" target=3D"=
_blank">https://github.com/jthornber/linux-2.6/tree/thin-dev</a><br>
<br>
This has the latest versions of both the thin-provisioning and cache<br>
targets, and will shortly have the era target too.<br>
<div><div><br>
<br>
- Joe<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--001a11c229a284f7a504ec65c13e--


--===============4696608402200782884==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4696608402200782884==--
