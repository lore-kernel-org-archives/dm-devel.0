Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD68C636D7
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 08:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676536033;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vNmyrB9t8FOBV8P5ox9+0h2u964pV34M79iajor1vyI=;
	b=C8EpbvSN8Cl53qje32/b7A/GSYEvY5NZgJzQXVKPmvuPkmnGDDieRptuaE/0sMojvn8XIL
	rFzLsKmqVsioFJKXcvV9CzgqVx3tSfyNY7XGDx28+bGS0X75GKBvdU2CBcELcP30FPgdDa
	eKOjp4X86+MIUcBXxkUVkj6Djd69Byc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-HL8xx6qzNT2O9JqzhUf7Fw-1; Thu, 16 Feb 2023 03:27:09 -0500
X-MC-Unique: HL8xx6qzNT2O9JqzhUf7Fw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73B21100F90D;
	Thu, 16 Feb 2023 08:27:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFC0740B40C9;
	Thu, 16 Feb 2023 08:27:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E3F1519465B2;
	Thu, 16 Feb 2023 08:27:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 99C161946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 05:23:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A356492B18; Thu, 16 Feb 2023 05:23:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 818BD492B15
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 05:23:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 629B885CBE2
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 05:23:48 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11olkn2058.outbound.protection.outlook.com [40.92.18.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-fIJWcbpvNcKuOV7i3w3yvg-1; Thu, 16 Feb 2023 00:23:46 -0500
X-MC-Unique: fIJWcbpvNcKuOV7i3w3yvg-1
Received: from IA1PR20MB5743.namprd20.prod.outlook.com (2603:10b6:208:421::7)
 by DS0PR20MB5687.namprd20.prod.outlook.com (2603:10b6:8:11e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:23:44 +0000
Received: from IA1PR20MB5743.namprd20.prod.outlook.com
 ([fe80::e93b:346c:d538:6083]) by IA1PR20MB5743.namprd20.prod.outlook.com
 ([fe80::e93b:346c:d538:6083%9]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 05:23:44 +0000
From: Ganapathi Kamath <hgkamath@hotmail.com>
To: Roger Heflin <rogerheflin@gmail.com>, "dm-devel@redhat.com"
 <dm-devel@redhat.com>
Thread-Topic: [dm-devel] On allowing remounting the partition containing
 dm-mapped boot disk as read-write
Thread-Index: AQHZQFqncS6Q3itxfEmMM91VE97WIa7P7WIAgAD5mfg=
Date: Thu, 16 Feb 2023 05:23:44 +0000
Message-ID: <IA1PR20MB5743D9D4F74B307EE16353F0DAA09@IA1PR20MB5743.namprd20.prod.outlook.com>
References: <IA1PR20MB5743F5A364EB9E02890364F7DAA29@IA1PR20MB5743.namprd20.prod.outlook.com>
 <CAAMCDefEs9UorPKZ_M_PtvRNxbtaSE1U9-qr-hE=GnBV1dQbag@mail.gmail.com>
In-Reply-To: <CAAMCDefEs9UorPKZ_M_PtvRNxbtaSE1U9-qr-hE=GnBV1dQbag@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [X3RLoA6IemUq3hXJHF/ROcjGjt+C0Z0o]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR20MB5743:EE_|DS0PR20MB5687:EE_
x-ms-office365-filtering-correlation-id: f02ff2f8-c37b-4dbe-7442-08db0fddf93d
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VlKO7PbGNhsjSBWw5pXNMK5f9Nu/itOrqPRNoBhdkErT3GmEaNMKiJZCtQBTX7OCJxb8ukGqV3ZGTf5B1Di/YGzDMt6GtBCfvZS3i7un2bgA3e+w8PlpmZ5l5fDm16mfzS5gTQ8q3AbETKOf9D048o8r5Qv2q2/zNT6WeCyGnWYqaIJMFcE44nYMFn0dVmpzDtWMEaZCyB97yj40wOjDn7vdNC+RPDpCL1o+MqFF5zAm7LX6DFzJn25cKqTz/KN94wXLIis+Dil2dfaF0cQstv2LQso3THm9PlqJ7hxjO0ZwcDSIYrexxj6xmeVVTrGqifU1aWd+1Zo0YTD+sCDDgKziIC3aE4BCXEZLZ0ntEKvtgFiEuMUq1T03EsGD7BDXSs1ChWw65t0kVicQkE1QeA1Z3Qv2+18NFsUfUwCgdo4OLr0zHVn8XICRZSzJaqspoBLydLbWzUyDHgH0+XhmA2/+fWdgkVvKwNdu7BRP1DkhmLgynvP7DLw9tITkQqIneHbRdFMjUUgyqz5dEJuU5ons7jVLC1PNZAQ24aDNWiN9V13vn2HD84vGGzTht9ObqsBhGuNWdx88JLT3R3U8YovhhrZ6Ke1awAr/VEGYiw4w5yzhr3XOEffD3RxvbjH6r2Jw5DCIm9Aatfj4dNjLdaz1A9eI8anf6JRUG47tAh4=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?WTeXj5kpVFcq12TdRzZbfOveaWaEovWGTjrAiLhAMLh3V74IofY9ESXxTT?=
 =?iso-8859-1?Q?1dDlj6YW1jVNa8mS/CNPgVTHKmmEG4rsenStCm5W6XqQIqAeHYuTF7s2/e?=
 =?iso-8859-1?Q?rK0m0owqMf5djalT3FvDyh2DIP+qBfZS2sMKP6la6GGG80yZYozBudbDIg?=
 =?iso-8859-1?Q?SO6GCtfZtFCZT3YQ69AkfuE1+LGy60BeorByBzf8RaYuKMWJntuUaO4hV4?=
 =?iso-8859-1?Q?/4I23gGWVr0Gb/whXE+Z5Z0rV1NMZ6kFqaA3+BLu2jieePvhOFLlRDXOin?=
 =?iso-8859-1?Q?s+hRQwtj6giAiUCkNt8a+uKnFnFOxom68PVkb9D5lFO+zYciW+G2CnBekD?=
 =?iso-8859-1?Q?bl3lxszt/DPUZhsHJAP0EG2w+omdJzMji6GfPUrLTvRQeaRalApwfKuHfp?=
 =?iso-8859-1?Q?fnxRpDrTh+vk2o7wQQiMGGT+hIf82VJa4lawtiRgrw+5lVpQLb8nvGRh1m?=
 =?iso-8859-1?Q?17iDE120Nhyc3wZIPKsBB4UOikGicXtDAEJ0ulB4xt7n2F20qRcC2+LDrb?=
 =?iso-8859-1?Q?LgQwjJSAKVB6Z6k9rDvdmYOIWrr1u0aCYLVRvrcmqGlZQhN9B12GZHjpP+?=
 =?iso-8859-1?Q?gs+bP6KfP/ppUCwEDUUJ/Y/ngZ53b01L1HLY6aDXEbnYHS1rDSJPzz0lsM?=
 =?iso-8859-1?Q?gUzLUNQN8CJM7+MnnHpTytKb5HH4C4Hm4lTTy8e95KPihlrFP03/vm2f6B?=
 =?iso-8859-1?Q?ri0uhZvp3XMwb+8qzSkAy45TKJeecKBL18EeU8XkHVvwO/ioJkR01HCBjJ?=
 =?iso-8859-1?Q?mjhe3AKRbMaUjbXLayt/kLfsQMWTwDieO1jTOk6JoAbYVYbwfqxes4tQVs?=
 =?iso-8859-1?Q?6OGJAnlqhkliRMJWLNMNGzOgvdfYfA7xfj1t1ANT4GrAewj5iVbZy+szq2?=
 =?iso-8859-1?Q?svw3SmwtUdhk2k+3b0IcWh7WIhoUE/M/tcX0tciooREMdxwUML8854ql5j?=
 =?iso-8859-1?Q?+8nKzI9nj5Id78Wwd9ngtH8D5x258/QNdf/grHqN5/ocenJt93is272XBM?=
 =?iso-8859-1?Q?ObOzIzSUso/G+HIcsc/xdW7nEfOA7ZpaaM5Gzm0K/4Mnj3bMi+pvilSmOy?=
 =?iso-8859-1?Q?uh8vY67tABcbqfOOL1mekEITO+pySFSqcdKTkwKJRbLD5D6Hz/HtH4B5LJ?=
 =?iso-8859-1?Q?KfhNmNMoaMIAAy90L/tYsFMRUqrapHNsXfUTOeM8iv1LOnPkhGHSM5i+VX?=
 =?iso-8859-1?Q?BRqSaTSdFRkPmRT0BecnlAR7+whJaHM9fzmkAopoVU/CLxP4w3FHMiGzFY?=
 =?iso-8859-1?Q?zlBRM9G6h6/DKkpKJiBQGLgELJ45FfZ75CGIilElaQvVEwSGd1rowauLal?=
 =?iso-8859-1?Q?Ubk+?=
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9803a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR20MB5743.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: f02ff2f8-c37b-4dbe-7442-08db0fddf93d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 05:23:44.6331 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR20MB5687
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 16 Feb 2023 08:27:05 +0000
Subject: Re: [dm-devel] On allowing remounting the partition containing
 dm-mapped boot disk as read-write
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Firstly, thankyou for your reply. I'm not a kernel expert, so I value what =
you say.
but as I raised the issue I felt I had to defend the usefulness, userbase a=
nd the need.

> Typically double mounts are done via bind mounts (not really double
> mounted just the device showing someplace else).=A0=A0 Or one would do a
> mount -o remount,rw <originaldir> and remount it rw so you could write
> to it.

> A real double mount where the kernel fs modules manages both mounts as
> if it was a separate device won't work reliably, as the filesystem
> module/caching assumes it has total control.=A0=A0 So writing to a
> read-write device that has a separate read-only mount with some data
> in the read cache will not return the true data in all cases.=A0=A0=A0 2
> read-write (done any way--except with a clustering fs modules) are
> going to cause corruption of the underlying filesystem.

I want to clarify, even though ventoy uses the word 'remount' to describe t=
he=20
feature, the host file system isn't mounted twice.  There is no loopback-fs=
=20
to bind mount. and dmsetup status shows linear sequences of blocks allocate=
d
to the devmapper device.

For this feature to work, the Linux being booted up, creates the devmapper=
=20
device by after having first somehow determined the sectors occupied by
the file in the filesystem. Then mounts the partitions inside devmapper dev=
ice=20
and then pivots to the discovered rootfs and continues booting.=20

So what I think you are saying is that a mount of /dev/sdc1 and=20
/dev/mapper/ventoy are claiming to use the hard-disk sectors, and asking th=
e
kernel to consider them as part of its disk-sector caching mechanism.

Booting virtual-disks this way is also called nativeboot.=20
The way this nativeboot so far works, has a little danger.=20
Three safe guards are to be followed by self contract:=20
1) The virtual-disk-file must be a fixed size, it cannot be allowed to grow=
 or shrink.
2) The virtual-disk-file must not be manipulated/touched/read from the host=
-partition. =20
3) The filesystem driver shouldn't defrag, scrub or relocate the virtual-di=
sk-file.
This is so that the the file entry in the outside fs remains untouched.
Usually, as this is done by root and such administrative user knows what he=
 is=20
doing, so it is not so much of a problem.
If one adheres to the above self-contract, the filesystem code for partitio=
ns inside=20
the dm-device does not interfere with the filesystem code for the outside p=
artition.

An idea just came to me. There maybe a way around the disk sector caching.=
=20
Will this work or be more safer?=20
What if, in addition to /dev/mapper/ventoy, a second dm device
/dev/mapper/antiventoy of the same size of the host partition /dev/sdc1 is =
created
by stitching together the other remaining sectors of the host partition /de=
v/sdc1,=20
with the vdisk sectors swapped for with null sectors. Then the two dm creat=
ed disks:=20
/dev/mapper/ventoy and /dev/mapper/antiventoy can be mounted independently,=
=20
without overlap of disk sectors, separating their caching. =20
The self-contract will still be needed, to not alter the location/size of f=
s-entry.=20
I'll suggest the above to ventoy. Your thoughts will be helpful.

> Given that the use case for the module is dangerous and the use case
> is of questionable usefulness I would think that is no point of the
> module.=A0 The module's intent seems to be to get around the exclusive
> locks that the filesystem (for good reason) is putting on the device.

I believe that the danger can be mitigated with a good idea and proper codi=
ng.=20
But the door shouldn't be shut.=20

Its usefulness and base of users is really there. The use case is really im=
portant =20
1) to those users who dualboot windows/linux, multi boot other OS-es=20
and juggle between them for want of SSD space,
2) to multiboot alternate OS. but have limited on-machine disk-space
2) to mounting different live isos often, which are often re-downloaded due=
 to updates.
3) to those keeping a host of recovery isos-s at hand for emergency like=20
WINRE, WIN-installer, linux-installer, HBCD-PE, gparted, clonezilla,=20
rescuezilla, seabios, samsung-wizard at hand,

Why not a VM?:=20
VM-s are nice but a bit slower than nativeboot. Many things cannot be done
inside a VM such as get full native experience of a live iso, GPU support a=
nd all.
Some system level recovery and repair tools must be booted as native.

In the old days Harddisks, USB drives, iso files were small.
vdisks were inexistent.
One had to burn live-isos to cd/dvd. Disks have grown larger.=20
Burning DVDs is such a waste now.

At one point I considered having a small number of 8GB microsd cards to fun=
ction
just like tiny dvds/floppies. But managing them is also a hassle, as they a=
re stored
external.

Disadvantages of flashing USB drive
* flashing a USB drive, which say is 32gb, with a tiny <3gb ISO file. can r=
esult in it wasting=20
space as it creates a small partition, limiting the drive's usefulness.
* One doesn't want too many usb drives lying around to boot different iso-s
* In my experience, flashing seems to have a higher frequency of bricking t=
he USB key. =20

With multiboot solutions, Its much easier to copy in and out liveisos betwe=
en=20
large filesytems ExFAT, NTFS, ext4 . Linux (as of 6.1) has mature fs driver=
 for
ExFAT(5.4) and NTFS (5.15) =20

I've have tried creating my own grub2 configurations to loop mount isos.=20
but then its too much work to maintain. One has to update grub2 config file=
s=20
everytime one downloads and deletes ISOs. Its preferable, that this is=20
auto-detected or dynamically done.=20

Then I considered other multiboot solutions like
YUMI, Unetbootin, MultiBootUSB, supergrub2

Ventoy seems to best them, by=20
- automatic detection of isos with grub2 menu
- also being able to nativeboot vdisks.
Ventoy seems to be fork of grub2 with some additional code to handle vdisks=
.

One problem with partitioning systems for multi-OS machines is that the=20
limited disk space of a 512gb SSD drive gets broken and underutilized betwe=
en partitions.=20
This leaves less usable space in a home partition.=20
Filesystems like btrfs allow having one big volume, installing an OS to=20
subvolumes and allow booting from subvolumes. Thereby sharing unused
space. One can then backup-up, offload and restoring subvolumes on need.=20
but this isn't cross platform. and requires more mental cognitive involveme=
nt.

Consider having windows and linux dual boot. and a data partition.=20
One might give 64 gb to each OS. that means when booted into one OS, the
space occupied by the other OS is a waste. before you know it, there is ver=
y=20
little space on the SSD  due to all the OS partitions.

Ventoy allows one to just keep a few 40gb vdisk files in the 512 gb partiti=
on.
User can easily move all unused images an external backup, until later use.=
 =20

Now onto ventoy dm_patch itself.
I tried reading the patch code dm_patch.c .=20
It is strange to me. seems to be finding specifc addresses in memory;
blanking them, inserting opcodes like 0x80, etc. =20
The method taken (kernel/initramfs patching) is spooky.=20
It also inserts code/scripts/files into the initramfs for liveisos, which i=
t can do, because it=20
is the bootloader, and its MOK (machine owner key) has been added to the UE=
FI.=20
Even though ventoy seems to be honest trustable opensource GPL developer, y=
ou never=20
know if the mechanism of side-patching initramfs and kernel allows for futu=
re exploits by
malicious entities/governments.
One wants to be tension free on that front and kernel developers have a res=
ponsibility=20
to keep linux-users from straying over to risky solutions.
This is apart from how duplicated work it seems to maintain it that I menti=
oned in the bug. =20
A legit desirable feature shouldn't have to rely on these techniques.
Its better, for the feature to exist with the blessing of kernel code revie=
w and signing=20

Here, I'm not giving a 'because windows does, linux should do so too',=20
justification. But, windows does do nativeboot of vhdx now since Win10-1903=
.=20
Only, to mention, that nativebooting vdisks is a useful enough thing, that =
Microsoft=20
also allows for it. As is the case for ventoy, the vhdx should be fixed-siz=
e and not be=20
touched in the hosting drive. They note their common scenarios and benefits=
.
https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/depl=
oy-windows-on-a-vhd--native-boot?view=3Dwindows-11=20
I configured a BCDBOOT/BCDEDIT entry to boot a HBCD-PE vhdx this way.

If one completely abandoned windows, without the need for cross-platform us=
ability,
foregoing VM-attachable/host-mountable mountable vdisks. there could be oth=
er=20
solutions such as btrfs subvolumes. But most home users laptops, come with =
windows,=20
have limited space and getting rid of windows and windows compatible techno=
logy=20
completely may not be an option.

Are there dm-devel kernel developers, who have tried ventoy or explored ven=
toy like solutions.
I do want to be assured that some dm-devel developer is put their great min=
d to this
if at least on the backburner.

Sorry if too verbose. I value your time.
Thanks
-Gana

On Wed, Feb 15, 2023 at 3:33 AM Ganapathi Kamath <hgkamath@hotmail.com> wro=
te:
>>
>> I am just an ordinary user of Linux and ventoy .
>> Q)
>> https://github.com/ventoy/Ventoy/issues/2234
>> Is what I have suggested here, meaningful?
>> Is there contra-indications to not do it or an alternative suggestions?
>> thoughts?
>>
>> Ventoy, a GPL software, uses a small kernel patch to achieve a small rem=
ountability feature.
>> It seemed to me, that patching the kernel per distribution is sub-optima=
l.
>> I couldn't find a previous relevant discussion on this on dm-devel, but =
it seems like a requirement would've been well known and this would have al=
ready been discussed. What does the actually patch do?
>>=20
>> Thx
>> -Gana
>>
> --
> dm-devel mailing list
> dm-devel@redhat.com
v https://listman.redhat.com/mailman/listinfo/dm-devel
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

