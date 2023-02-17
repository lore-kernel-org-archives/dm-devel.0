Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E33C636D6
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 07:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676618131;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aW6KKgPH0YgyrdJklSK160753jNxSfwKqXkTDWK7sYE=;
	b=ALB1TbvqZmOqo92fHcJF9/2F5309R8w2GW6zWQ6/6+wEcRQYHeceS3HRVTAk1XXZXh43Yj
	Gz31PuMwe+xpwDwHyc2jMtiaVhreZrndzKbPEEslqmxAh2msSnmLebf5b89+98ZuiVgN2l
	Ai51+Xx+fno4k/Mft5qKaFEhRlPSCGU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-3vpuRsWdNc2_6kZNikIDjQ-1; Fri, 17 Feb 2023 02:15:27 -0500
X-MC-Unique: 3vpuRsWdNc2_6kZNikIDjQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD98A1C05B02;
	Fri, 17 Feb 2023 07:15:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 42545175A2;
	Fri, 17 Feb 2023 07:15:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C3B21946589;
	Fri, 17 Feb 2023 07:15:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4CFAD1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 05:28:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FEAD492B19; Fri, 17 Feb 2023 05:28:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 065F7492B15
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 05:28:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D62AC3C0D194
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 05:28:45 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11olkn2073.outbound.protection.outlook.com [40.92.18.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-z-V67LznNga3yTUIJY9n-g-1; Fri, 17 Feb 2023 00:28:43 -0500
X-MC-Unique: z-V67LznNga3yTUIJY9n-g-1
Received: from IA1PR20MB5743.namprd20.prod.outlook.com (2603:10b6:208:421::7)
 by DS7PR20MB3758.namprd20.prod.outlook.com (2603:10b6:5:38f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 05:28:41 +0000
Received: from IA1PR20MB5743.namprd20.prod.outlook.com
 ([fe80::e93b:346c:d538:6083]) by IA1PR20MB5743.namprd20.prod.outlook.com
 ([fe80::e93b:346c:d538:6083%9]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 05:28:41 +0000
From: Ganapathi Kamath <hgkamath@hotmail.com>
To: Roger Heflin <rogerheflin@gmail.com>
Thread-Topic: [dm-devel] On allowing remounting the partition containing
 dm-mapped boot disk as read-write
Thread-Index: AQHZQFqncS6Q3itxfEmMM91VE97WIa7P7WIAgAD5mfiAAJp3AIABHr2i
Date: Fri, 17 Feb 2023 05:28:40 +0000
Message-ID: <IA1PR20MB574337C831DAFC0A201D6177DAA19@IA1PR20MB5743.namprd20.prod.outlook.com>
References: <IA1PR20MB5743F5A364EB9E02890364F7DAA29@IA1PR20MB5743.namprd20.prod.outlook.com>
 <CAAMCDefEs9UorPKZ_M_PtvRNxbtaSE1U9-qr-hE=GnBV1dQbag@mail.gmail.com>
 <IA1PR20MB5743D9D4F74B307EE16353F0DAA09@IA1PR20MB5743.namprd20.prod.outlook.com>
 <CAAMCDefLDvk29ZWCeA1DWRjOmBwRwb5aoH02=hVS-UAzUExXRw@mail.gmail.com>
In-Reply-To: <CAAMCDefLDvk29ZWCeA1DWRjOmBwRwb5aoH02=hVS-UAzUExXRw@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [Nyu/xE3EwqQ/I2Ka0Y3WmPOStk6DLJPn]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR20MB5743:EE_|DS7PR20MB3758:EE_
x-ms-office365-filtering-correlation-id: 51730608-cf5f-418c-0c9c-08db10a7d44d
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: F4zQ878Tq7H+Ck0uxaMs6oLatE2RYn6FNXpgCenO+mmEO1WgcdOcL/WhamAJDf5eOMtl5+mXHN0gvAK8qDAQs82lgqpvmO1AJiOYZRQQ3YruOKP05ndR+Wk7LLr+O38WXaoxJoHX97QPkUQogPrXRPTCpS6nsMlMS83WB8Hcuzu5G+OfqWKPK3ekDdkMZxbcQ03YuO3FvY9gycHW6M6bkQW+/NkVt/ZDKF9FFpUb1lwrKqLHL4hkHLEWktRUnarysUo6mR0xufukJ4NBkOXWiSRyhW7vzOc2sP+cUp5a8PMjj2N10XSAj5r+r+0/JxEqSZTDeH5aa/31yQvuk+ZG1c67GDOUQay3myAVlVLFVuvkGE0G5VMTwA2MysyJE7YNP87VVjPxWfeduya9wmkSFszQ3xKJzbxDbqLTNCvdHvT65xjG4fkHi35ln1OoA0XEfG7EaMZt+wY+EETh8F+LRXMOQz+eMrU8VYQ2c6chziDabl8JjLpJRMBNlV4bB84RAU+NXaqv/YAnObnvWk4Y0vZW0aGjn2GtEBngimIeSaK12kjvKAlyU3beUaghjnNM1HTAqc3OEt53jqkf1qIoyl/jWcvrhJVbLjMfrBPes9o5v6DUl29M6AEc2zBt1OKqCM3nV5JS+fhH4h8Wq3lORwBZYIDXUMeBC08ISs7Kzp9/MyElmbxOqhOqjb8M2zzA
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bb/gRBCHSswkuXVwMhc+9J2qCKYkAutmjiDe6YlkTFL2nWPikYK3l4XPx4?=
 =?iso-8859-1?Q?rIa9nOmbAzF87kTTrmcVrEgBLcpPAbjm0/4FFGhXnmzwvnUCc4nc3M52An?=
 =?iso-8859-1?Q?7zljaOz5x8rtYUJSKr1Ovdb9t3DCg/3BJNwsL0gzt1YC0PQwZrPoGHN9XU?=
 =?iso-8859-1?Q?+orBLlBLl4oLVCaFEJ9FdmPTa4QePBTK1IP8ZzV7VvHIdFYtIKKIZJxUiQ?=
 =?iso-8859-1?Q?j/a+qXSGjCf9u2hgVl8N+ARYcOr6b5GZvRCkkPS2C1B3LQF0C/t44fnsUe?=
 =?iso-8859-1?Q?USSUt+S/Qb4iQG1gyw2CUw0Hq2PDbmKKGqoUn6q+FmJrmFy/uyzVIe49Cn?=
 =?iso-8859-1?Q?Aw4H4mL8PpgceyOrVpMBJjNJiYsbKuVLWIVKCTq77AE2w82HstN7GHOyNc?=
 =?iso-8859-1?Q?EIaVcuCOBV9FOMdHMQ0RTsl8fPkIz7u9vra7oig2aWEXxzlVqYG/42F24u?=
 =?iso-8859-1?Q?BkxeMtJoLSFlh67GXnstNFHp+HcR8Z0lL3S7+sLr+Mmb/xzFaZZW4bUCfD?=
 =?iso-8859-1?Q?ji1s5lrQSGnO9YI2N8N9NtpRlbc1DcSsYydlqbnYHIad4KeVNZfuIpjCEt?=
 =?iso-8859-1?Q?kTSvnAiJex8TUpTS5F4KkQxTd635zpfFELkyCR3mTa2dPjKhK6njIsi2UL?=
 =?iso-8859-1?Q?rfXClNfkyT0u3sWJeMJzG63Fip6HkFSq9zRrZURaaSGc8+c0ZkVZEkR/x3?=
 =?iso-8859-1?Q?Ue2Tb3TLPdt3U0duN4KN3AHdi66bmHTBEXMN8npqL2tfAois4KDlR2z2Kk?=
 =?iso-8859-1?Q?Q3vJzvAHQPg8KI11AHpCqhVl54sCEle+Qh7m1/aI+uajPy5heLSib9sxpE?=
 =?iso-8859-1?Q?bWxILcH8cXBGuA4SRITldH2gD49Dn0UFLfQyW4W8SA8TJVV2N52Ue6gC/C?=
 =?iso-8859-1?Q?GE8UCBWZOqkEIpbnNLh1flY1jAUDwfWZTJpxgZiOkmlAz4yy00tN4/r1vx?=
 =?iso-8859-1?Q?F2exkZsQ9mlS2I2fr6GjNRlZ3lhgRfdPHjzi1O9LZgnVtBAZRltjdC9HFr?=
 =?iso-8859-1?Q?WcwkrLIKkvPOpHUPPgPqELr/UqCltq1pgbb3EbznJvUuGXiZ7jCfnWBKuD?=
 =?iso-8859-1?Q?+JSvEWNiMRJVpvNp0tnrzmZ/k1whZCx2wdv30NCbTapCd2kiOajmDf6wCp?=
 =?iso-8859-1?Q?Gd1oENhBjrGsoMu0fHT6cRtb9hyIxUQGFAulXuDW7bQE+raTWz5Pw4pFFZ?=
 =?iso-8859-1?Q?B6A00NLCqK4abpjW6h/7YoK9vBITC7VViTvapdWZIdbqcaiYWoAbVZnDR8?=
 =?iso-8859-1?Q?3a0suZgULiLXOzFH12+BXiqA2ALWq694Nhl8OarSa54QU0lXoBaMQaVGf4?=
 =?iso-8859-1?Q?8LgK?=
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9803a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR20MB5743.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 51730608-cf5f-418c-0c9c-08db10a7d44d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 05:28:40.9834 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR20MB3758
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 17 Feb 2023 07:15:22 +0000
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Firstly, thankyou for your reply, However, I still think you are mistaken.
"There is no double re-mounting of the filesystem".=20

I try again, but in case my writing isn't convincing. Let's agree to disagr=
ee, until
I have more conclusive proof, either to what confirm what you say, or what =
I say.=A0=A0=20

I have captured some logs from the initramfs. Included near the end of this=
 post.
I also tried my antiventoy idea. I believe it worked !!. It is included at =
the end of this post.
The logs help to see whats going on.

> Besides caching at the dm layer, there is caching at the filesystem
> layer (files, directories and other stuff).=A0 The caching at the DM
> layer is not the issue.
If at all there is an issue, its at DM layer, But, if you say there is no i=
ssue at the DM
layer, then maybe there is no issue at all.=20
The 2 filesystems in question, one that sits inside a partition of the=20
dm-mapped vdisk-file and one that sits in the outside partition,
do not touch/interfere with one another's operation and metadata structures
as they change and modify their own filesystem structures. Any 'block write=
' from the=20
dm-mapped disk does not go through the outside filesystem driver, it goes
directly to the blocks on disk.
>
> If rootfs mounts the dm-device someplace as a
> (ntfs)filesystem(readonly), and then later you also mount that same
> (ntfs)filesystem (read-write) someplace then you have mounted the
> filesystem twice (not a shared bind mount that appears to be 2 mounts
> but in reality is only a single mount), and the filesystem code is not
> safe when there are 2 unique separate mount instances, the fs caching
> is not shared.
This is not what is happening.=20
The same filesystem is not being re-mounted.
In fact, by using rd.break=3Dpre-mount, in the initramfs, before pivot, I h=
ave confirmed that=20
no mounts have been done. Other than initramfs filesystem, no disk filesyst=
em exists.
But, using a block table=A0 a device map has been created directly to the b=
locks on disk.
so one can issue : dm table /dev/mapper/ventoy and see the block map.
The blocks correspond the the exact block-locations of the file on disk.=20
After pivot, the filesystem in one the partitions inside /dev/mapper/ventoy=
 (specifically
/dev/mapper/ventoy4), becomes the rootfs of the OS being booted up.=20
The outside /dev/sdc1 is still unmounted.
But, after booting-up and logging-in, it cannot be mounted,=20
Because, I think, the fs driver cannot get exclusive access to all blocks t=
hat constitute
/dev/sdc1 because the device mapper is holding onto some blocks.=20
That's what, I think, the ventoy dm_patch overrides.
(you say its because of a clash with a prior filesystem mount, which is inc=
orrect)
>=20

> ie if the filesystem is already mounted as a filesystem someplace
It is not already mounted as a filesystem someplace.
> (mapping a dm device is not mounting) and you mount it a 2nd time then
> you are at risk of corruption.
As filesytems are separate, there won't be corruption for that reason. It i=
s not a remount.

>=20
> For the mount command to get a busy indicates that something has
> already mounted it someplace and has locked the device(to prevent a
> 2nd corrupting mount from happening), and the entire purpose of the
> module appears to be to disable the safety provided by this locking
> and allow one to mount the fs again.
I've grabbed /proc/mounts to be sure of what I am saying,=20
I think, this mount-busy is not due to a filesystem-vs-filesystem clash but=
 a
dm-map-vs-filesystem clash.=A0 My guess is, the dm_patch is a crude way to =
make=20
the devicemapper think the blocks as still available.

> And note that with double mounts (usually I have seen/debugged the
> crash/ouage from them with shared SAN storage)=A0 they can "APPEAR" to
> kind of work if you do not use them too much, but eventually the 2
> instances of filesystem code step on each other and it ends badly
> (kernel crash, data corruption, loss of the filesystem).
I know how terrible, a double mount can get. Not, exactly a double mount, b=
ut once I
experienced something similar.=A0 I had a virtualbox VM in windows accessin=
g a btrfs partition=20
on a disk partition (pass-through). put VM to sleep/suspend (not shutdown),=
 forgot about it.=20
shutdown windows, and rebooted in linux. There was probably un-committed wr=
ites in
its journal. In Linux, simple mounting failed, linux warned me, but I unwit=
tingly=20
force mounted the btrfs partition, which remounted the partition from some =
earlier state,=20
and each successive modification put the filesystem in a more inconsistent
state, until a full messup. I don't remember specific btrfs terminology, bu=
t had to sift through=20
binary dump of the btrfs fs to find superblocks of the older btrfs root tre=
e of=20
that previous state and then use special btrfs commands to extract the file=
s out.=20

This ventoy situation, is more like, the filesystem on the outside-partitio=
n has full control of it self
and all its files and folders, no one is touching or interfering with it. T=
here exists a file,
the vdisk file, which by self-contract, the user is not supposed to touch. =
Unbeknowst to the
outside-partition-filesystem driver, the device mapper device, which was cr=
eated even
before mounting of the filesystem on the outside-partition, directly writes=
 into its blocks=20
without invoking the partition's filesystem driver. So the containing parti=
tion filesystem
driver would never know that the content of a file are sneakily changing. N=
TFS doesn't=20
do hashes/checksums, if it did it would know something is up. Whenever the =
filesystem
driver sees the file by way of a directory traversal, just sees a static un=
changed fixed size file.

> If you need this module so that you can use another (non-bind) mount
> command someplace on the same device then you are double mounting.
> The point of the busy device is that it is mounted someplace, and the
> entire point of the module is to bypass the protection.
>=20
> It is the filesystem code and filesystem caching that is not safe.
> Both filesystems assume they have total control of filesystem data
> structures, and at the very least the mount writing will change those
> structures, and if the read-only mount may read blocks that were part
> of one file but now aren't part of that file returning the wrong data.
>=20
I got your point, but I think its not double mounting of a filesystem.=20
I'll keep an open mind to try find/see evidence that it is the way you desc=
ribed.=20

=3D=3D=3D LOGS
# rd.break=3Dpre-mount was added to linux cmd line in the grub menu
# the below logs were collected from the initramfs of the vdisk fedora-37 m=
02_lnx.raw.img.vtoy=20
[root@sirius tmp]# cat vtoy3_m02.log
# cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,nosuid,size=3D4096k,nr_inodes=3D1048576,mode=3D75=
5,inode64 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime =
0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,inode64 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmod=
e=3D000 0 0
tmpfs /run tmpfs rw,nosuid,nodev,size=3D3261448k,nr_inodes=3D819200,mode=3D=
755,inode64 0 0
cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate,m=
emory_recursiveprot 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
efivarfs /sys/firmware/efi/efivars efivarfs rw,nosuid,nodev,noexec,relatime=
 0 0
bpf /sys/fs/bpf bpf rw,nosuid,nodev,noexec,relatime,mode=3D700 0 0
ramfs /run/credentials/systemd-sysusers.service ramfs ro,nosuid,nodev,noexe=
c,relatime,mode=3D700 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
#
# cat /etc/mtab
rootfs / rootfs rw 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,nosuid,size=3D4096k,nr_inodes=3D1048576,mode=3D75=
5,inode64 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime =
0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,inode64 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmod=
e=3D000 0 0
tmpfs /run tmpfs rw,nosuid,nodev,size=3D3261448k,nr_inodes=3D819200,mode=3D=
755,inode64 0 0
cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate,m=
emory_recursiveprot 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
efivarfs /sys/firmware/efi/efivars efivarfs rw,nosuid,nodev,noexec,relatime=
 0 0
bpf /sys/fs/bpf bpf rw,nosuid,nodev,noexec,relatime,mode=3D700 0 0
ramfs /run/credentials/systemd-sysusers.service ramfs ro,nosuid,nodev,noexe=
c,relatime,mode=3D700 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
#
# ls -l /etc/mtab
lrwxrwxrwx 1 root root 17 Feb 16 14:59 /etc/mtab -> /proc/self/mounts
#
# ls -l /proc/mounts
lrwxrwxrwx 1 root root 11 Feb 16 14:59 /proc/mounts -> self/mounts
#
# dmsetup status
ventoy: 0 97386496 linear
ventoy1: 0 520192 linear
ventoy2: 0 4096 linear
ventoy3: 0 1572864 linear
ventoy4: 0 95285248 linear
#
# dmsetup ls
ventoy=A0 (253:0)
ventoy1 (253:1)
ventoy2 (253:2)
ventoy3 (253:3)
ventoy4 (253:4)
#
# dmsetup info ventoy
Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 4
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 0
Number of targets: 1

#
# dmsetup status -v
Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 4
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 0
Number of targets: 1

0 97386496 linear

Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy1
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 0
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 1
Number of targets: 1

0 520192 linear

Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy2
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 0
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 2
Number of targets: 1

0 4096 linear

Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy3
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 0
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 3
Number of targets: 1

0 1572864 linear

Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy4
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 0
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 4
Number of targets: 1

0 95285248 linear

#
# dmsetup table
ventoy: 0 97386496 linear 8:33 1973076888
ventoy1: 0 520192 linear 253:0 2048
ventoy2: 0 4096 linear 253:0 522240
ventoy3: 0 1572864 linear 253:0 526336
ventoy4: 0 95285248 linear 253:0 2099200
#
# dmsetup table -v
Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 4
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 0
Number of targets: 1

0 97386496 linear 8:33 1973076888

Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy1
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 0
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 1
Number of targets: 1

0 520192 linear 253:0 2048

Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy2
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 0
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 2
Number of targets: 1

0 4096 linear 253:0 522240

Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy3
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 0
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 3
Number of targets: 1

0 1572864 linear 253:0 526336

Name:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ventoy4
State:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACTIVE
Read Ahead:=A0=A0=A0=A0=A0=A0=A0 256
Tables present:=A0=A0=A0 LIVE
Open count:=A0=A0=A0=A0=A0=A0=A0 0
Event number:=A0=A0=A0=A0=A0 0
Major, minor:=A0=A0=A0=A0=A0 253, 4
Number of targets: 1

0 95285248 linear 253:0 2099200

#
# ls -l /dev/sdc1
brw-rw---- 1 root disk 8, 33 Feb 16 14:59 /dev/sdc1
#
# ls -l /dev/mapper/ventoy
lrwxrwxrwx 1 root root 7 Feb 16 14:59 /dev/mapper/ventoy -> ../dm-0
#
# ls -l /dev/dm-0
brw-rw---- 1 root disk 253, 0 Feb 16 14:59 /dev/dm-0
#
# cat /proc/cmdline
BOOT_IMAGE=3D(hd3,gpt3)/vmlinuz-6.1.11-200.fc37.x86_64 root=3DUUID=3D27857c=
40-0518-4c8e-872a-a55bc80c9847 ro rootflags=3Dsubvol=3Droot_01 rhgb quiet r=
d.break=3Dpre-mount
#
# ls -l /dev/sda
brw-rw---- 1 root disk 8, 0 Feb 16 14:59 /dev/sda
#
# ls -l /dev/sdb
brw-rw---- 1 root disk 8, 16 Feb 16 14:59 /dev/sdb
#
# ls -l /dev/sdc
brw-rw---- 1 root disk 8, 32 Feb 16 14:59 /dev/sdc
#
# cat /proc/devices
Character devices:
=A0 1 mem
=A0 4 /dev/vc/0
=A0 4 tty
=A0 4 ttyS
=A0 5 /dev/tty
=A0 5 /dev/console
=A0 5 /dev/ptmx
=A0 7 vcs
=A010 misc
=A013 input
=A021 sg
=A029 fb
128 ptm
136 pts
180 usb
188 ttyUSB
189 usb_device
202 cpu/msr
203 cpu/cpuid
226 drm
234 megaraid_sas_ioctl
235 megadev_legacy
236 pmcsas
237 nvme-generic
238 nvme
239 uio
240 binder
241 hidraw
242 ttyDBC
243 usbmon
244 wwan_port
245 bsg
246 watchdog
247 ptp
248 pps
249 lirc
250 rtc
251 dma_heap
252 dax
253 tpm
254 gpiochip
509 aux
510 cec
511 aac

Block devices:
=A0 8 sd
=A0 9 md
=A011 sr
=A065 sd
=A066 sd
=A067 sd
=A068 sd
=A069 sd
=A070 sd
=A071 sd
128 sd
129 sd
130 sd
131 sd
132 sd
133 sd
134 sd
135 sd
253 device-mapper
254 mdp
259 blkext
#
# mount /dev/sda12 /tmp/a12
#
# cat /proc/mounts | grep a12 -B 3
bpf /sys/fs/bpf bpf rw,nosuid,nodev,noexec,relatime,mode=3D700 0 0
ramfs /run/credentials/systemd-sysusers.service ramfs ro,nosuid,nodev,noexe=
c,relatime,mode=3D700 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
/dev/sda12 /tmp/a12 btrfs rw,relatime,ssd,space_cache,subvolid=3D5,subvol=
=3D/ 0 0
#
# cp /tmp/vtoy3_m02,log /tmp/a12/gana/vtoy3_m02.log
#
# cat /tmp/vtoy.log
ventoy_do_dm_patch
get_addr=3D0xffffffff92a9f7a0 get_size=3D496
put_addr=3D0xffffffff92a9f990 put_size=3D224
kprobe_reg_addr=3Dffffffff921ed630 kprobe_unreg_addr=3Dffffffff921ecc20
ro_addr=3Dffffffff92089430 rw_addr=3Dffffffff92089460 printk_addr=3D0
template module is /lib/modules/6.1.11-200.fc37.x86_64/kernel/fs/zonefs/zon=
efs.ko.xz zonefs.ko.xz
insmod: ERROR: could not insert module /tmp/dm_patch.ko: Invalid parameters
#
# /usr/bin/vtoydump
=3D=3D=3D ventoy runtime data =3D=3D=3D
disk name : /dev/sdc
disk size : 2000398934016
disk part : 1
filesystem: ntfs
image size: 49861885952
image path: /transcend/m02_lnx.raw.img.vtoy
#
# dmesg | grep dm
[=A0=A0=A0 0.197961] MDS CPU bug present and SMT on, data leak possible. Se=
e https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for m=
ore details.
[=A0=A0=A0 1.441071] device-mapper: ioctl: 4.47.0-ioctl (2022-07-28) initia=
lised: dm-devel@redhat.com
[=A0=A0=A0 6.094644] dm_patch: module verification failed: signature and/or=
 required key missing - tainting kernel
[=A0=A0=A0 7.071137] BTRFS: device fsid 27857c40-0518-4c8e-872a-a55bc80c984=
7 devid 1 transid 7440 /dev/dm-4 scanned by systemd-udevd (656)
#
# dmesg | grep sd
[=A0=A0=A0 1.744888] sd 0:0:0:0: Attached scsi generic sg0 type 0
[=A0=A0=A0 1.745132] sd 0:0:0:0: [sda] 1000215216 512-byte logical blocks: =
(512 GB/477 GiB)
[=A0=A0=A0 1.745148] sd 0:0:0:0: [sda] Write Protect is off
[=A0=A0=A0 1.745151] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[=A0=A0=A0 1.745184] sd 0:0:0:0: [sda] Write cache: enabled, read cache: en=
abled, doesn't support DPO or FUA
[=A0=A0=A0 1.745218] sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
[=A0=A0=A0 1.753036]=A0 sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9 s=
da10 sda11 sda12 sda13 sda14 sda15 sda16 sda17
[=A0=A0=A0 1.753900] sd 0:0:0:0: [sda] Attached SCSI disk
[=A0=A0=A0 2.149445] sd 2:0:0:0: Attached scsi generic sg1 type 0
[=A0=A0=A0 2.149646] sd 2:0:0:0: [sdb] 3907029168 512-byte logical blocks: =
(2.00 TB/1.82 TiB)
[=A0=A0=A0 2.149656] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[=A0=A0=A0 2.149734] sd 2:0:0:0: [sdb] Write Protect is off
[=A0=A0=A0 2.149741] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[=A0=A0=A0 2.149844] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: en=
abled, doesn't support DPO or FUA
[=A0=A0=A0 2.149927] sd 2:0:0:0: [sdb] Preferred minimum I/O size 4096 byte=
s
[=A0=A0=A0 2.150312] sd 4:0:0:0: Attached scsi generic sg2 type 0
[=A0=A0=A0 2.150511] sd 4:0:0:0: [sdc] 3907029168 512-byte logical blocks: =
(2.00 TB/1.82 TiB)
[=A0=A0=A0 2.150542] sd 4:0:0:0: [sdc] 4096-byte physical blocks
[=A0=A0=A0 2.150588] sd 4:0:0:0: [sdc] Write Protect is off
[=A0=A0=A0 2.150596] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[=A0=A0=A0 2.150652] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: en=
abled, doesn't support DPO or FUA
[=A0=A0=A0 2.150717] sd 4:0:0:0: [sdc] Preferred minimum I/O size 4096 byte=
s
[=A0=A0=A0 2.238833]=A0 sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7
[=A0=A0=A0 2.239285] sd 2:0:0:0: [sdb] Attached SCSI disk
[=A0=A0=A0 2.298831]=A0 sdc: sdc1 sdc2 sdc3 sdc4 sdc5 sdc6 sdc7 sdc8 sdc9 s=
dc10 sdc11
[=A0=A0=A0 2.299987] sd 4:0:0:0: [sdc] Attached SCSI disk
[=A0=A0=A0 3.975488] BTRFS: device fsid 487f55dc-4a7c-4424-9941-352386ecc74=
9 devid 1 transid 230715 /dev/sda9 scanned by systemd-udevd (651)
[=A0=A0=A0 3.979333] BTRFS: device fsid 38d6229a-c049-45df-b6eb-dc254746fb6=
b devid 1 transid 538 /dev/sda10 scanned by systemd-udevd (641)
[=A0=A0=A0 3.982654] BTRFS: device fsid 3562d3c6-ea67-4e3b-8231-ce6756f4d3b=
f devid 1 transid 31788 /dev/sda8 scanned by systemd-udevd (640)
[=A0=A0=A0 3.992185] BTRFS: device fsid aaa67901-4412-47cd-b93f-49e758bfc50=
c devid 1 transid 1060161 /dev/sda12 scanned by systemd-udevd (657)
[=A0=A0=A0 4.707518] BTRFS: device fsid 96fe0ea4-ea54-4a58-925c-c978a9b36e0=
9 devid 1 transid 1147 /dev/sdc7 scanned by systemd-udevd (658)
[=A0=A0=A0 4.769927] BTRFS: device fsid 5c4cc4a0-55a2-4cc7-ae39-e0aada6ba74=
b devid 1 transid 2493 /dev/sdb4 scanned by systemd-udevd (637)
[ 1230.681698] BTRFS info (device sda12): using crc32c (crc32c-intel) check=
sum algorithm
[ 1230.681706] BTRFS info (device sda12): disk space caching is enabled
[ 1230.686197] BTRFS info (device sda12): enabling ssd optimizations
[ 1305.232037] BTRFS info (device sda12): using crc32c (crc32c-intel) check=
sum algorithm
[ 1305.232045] BTRFS info (device sda12): disk space caching is enabled
[ 1305.236469] BTRFS info (device sda12): enabling ssd optimizations
#
# ls -l /sys/firmware/efi/efivars | grep toy
-rw-r--r-- 1 root root=A0 516 Feb 16 14:59 VentoyOsParam-77772020-2e77-6576=
-6e74-6f792e6e6574
#

# the efivar file that was copied out and this is its hexdump=20
# ventoy-grub perhaps uses this to send info to ventoy scripts=20
[root@sirius tmp]# cat VentoyOsParam-77772020-2e77-6576-6e74-6f792e6e6574 |=
 od -A x -t x1z -v
000000 06 00 00 00 20 20 77 77 77 2e 76 65 6e 74 6f 79=A0 >....=A0 [http://=
www.ventoy<]www.ventoy<
000010 2e 6e 65 74 38 a9 77 92 6c 88 80 4e 3a a0 29 77=A0 >.net8.w.l..N:.)w=
<
000020 b8 3e 63 06 35 00 60 11 c1 d1 01 00 00 01 00 01=A0 >.>c.5.`.........=
<
000030 00 2f 74 72 61 6e 73 63 65 6e 64 2f 6d 30 32 5f=A0 >./transcend/m02_=
<
000040 6c 6e 78 2e 72 61 77 2e 69 6d 67 2e 76 74 6f 79=A0 >lnx.raw.img.vtoy=
<
000050 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000060 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000070 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000080 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000090 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0000a0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0000b0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0000c0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0000d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0000e0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0000f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000100 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000110 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000120 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000130 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000140 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000150 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000160 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000170 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000180 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000190 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0001a0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0001b0 00 00 00 00 9c 0b 00 00 00 00 70 92 9c 00 00 00=A0 >..........p.....=
<
0001c0 00 2c 00 00 00 00 00 00 00 00 01 00 f3 d9 b6 2d=A0 >.,.............-=
<
0001d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
0001e0 00 00 00 00 00 f3 d9 b6 2d 00 00 00 00 00 00 00=A0 >........-.......=
<
0001f0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=A0 >................=
<
000200 00 00 00 00=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 >....<
000204

=3D=3D=3D ATTEMPTING THE ANTIVENTOY IDEA=20
> > An idea just came to me. There maybe a way around the disk sector cachi=
ng.
> > Will this work or be more safer?
> > What if, in addition to /dev/mapper/ventoy, a second dm device
> > /dev/mapper/antiventoy of the same size of the host partition /dev/sdc1=
 is created
> > by stitching together the other remaining sectors of the host partition=
 /dev/sdc1,
> > with the vdisk sectors swapped for with null sectors. Then the two dm c=
reated disks:
> > /dev/mapper/ventoy and /dev/mapper/antiventoy can be mounted independen=
tly,
> > without overlap of disk sectors, separating their caching.
> > The self-contract will still be needed, to not alter the location/size =
of fs-entry.
> > I'll suggest the above to ventoy. Your thoughts will be helpful.

The below logs are collected after the fedora vdisk boots up.=20

[root@sirius tmp]# cat vtoy4_m02_fedora_postboot.txt
https://www.kernel.org/doc/Documentation/device-mapper/linear.txt
https://www.kernel.org/doc/Documentation/device-mapper/zero.txt

[root@fedora gana]# sgdisk /dev/sdc=A0 -p | grep -i toy
=A0=A0 1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2048=A0=A0=A0=A0=A0 2566852607=A0=
=A0 1.2 TiB=A0=A0=A0=A0 0700=A0 15KJ_Ventoy
=A0=A0 2=A0=A0=A0=A0=A0 2566852608=A0=A0=A0=A0=A0 2566918143=A0=A0 32.0 MiB=
=A0=A0=A0 0700=A0 15KJ_VTOYEFI

[root@fedora gana]# dmsetup table
ventoy: 0 97386496 linear 8:33 1973076888
ventoy1: 0 520192 linear 253:0 2048
ventoy2: 0 4096 linear 253:0 522240
ventoy3: 0 1572864 linear 253:0 526336
ventoy4: 0 95285248 linear 253:0 2099200

size of partition
[root@fedora notes]# echo $((2566852607-2048+1))
2566850560
end of vdisk
[root@fedora notes]# echo $((1973076888+97386496))
2070463384
blocks after vdisk
[root@fedora notes]# echo $((2566850560-2070463384))
496387176

[root@fedora ~]# cat=A0 tmp/dmtab_antiventoy
0 1973076888 linear 8:33 0
1973076888=A0 97386496 zero
2070463384 496387176 linear 8:33 2070463384

[root@fedora ~]# cat tmp/dmtab_antiventoy | dmsetup create antiventoy
[root@fedora ~]# dmsetup table
antiventoy: 0 1973076888 linear 8:33 0
antiventoy: 1973076888 97386496 zero
antiventoy: 2070463384 496387176 linear 8:33 2070463384
ventoy: 0 97386496 linear 8:33 1973076888
ventoy1: 0 520192 linear 253:0 2048
ventoy2: 0 4096 linear 253:0 522240
ventoy3: 0 1572864 linear 253:0 526336
ventoy4: 0 95285248 linear 253:0 2099200

[root@fedora ~]# mount -t ntfs3 /dev/mapper/antiventoy /mnt/t1 -o ro
[root@fedora ~]#

[gana@fedora ~]$ ls /mnt/t1
'$RECYCLE.BIN'=A0=A0=A0=A0=A0=A0 HQ=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tmpq=A0=A0=A0=A0=A0=A0=A0 win10inst
=A0clonezilla=A0=A0=A0=A0=A0=A0=A0=A0=A0 Recovery=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 transcend
=A0DumpStack.log.tmp=A0 'System Volume Information'=A0=A0 ventoy
=A0freshwin=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 test=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vstorage

[gana@fedora ~]$ df | grep t1
/dev/mapper/antiventoy 1283425276 1047620704 235804572=A0 82% /mnt/t1

[gana@fedora ~]$ find /mnt/t1 | wc
=A0 23941=A0=A0 24019 1617981

[root@fedora ~]# umount /dev/mapper/antiventoy
[root@fedora ~]#

By side stepping the blocks that were allocated /dev/mapper/ventoy, the con=
tention for=20
was removed, and the new device /dev/mapper/antiventoy was created.=20

Long ago, I had defragmented the ntfs partition in win10. so the vdisk file=
 is a single
contiguous unfragmented sequence of blocks. It would have been more work if=
 it=20
were fragmented but still do-able. ventoy does not require the file to be c=
ontiguous.=20
However, I think, contiguous dm-maps are more performant.

The advantage of this method is that that no dm-patching is required. Hence=
, no kernel taint.
/dev/mapper/ventoy gives access to filesystems inside designated-blocks (th=
e location of the file on disk)
/dev/mapper/antiventoy gives access to the outside-filesystem.

These block boundary calculations need to be perfect, in order to present a=
 filesystem=20
as perfect as the original. The job of the antiventoy dm-map is to just sub=
stitute the vdisk=20
file-blocks with zero-blocks, in order to avoid the contention that prevent=
s mount.=20
Some testing will help with assurance of safety. I mounted the fs "ro" to b=
e safe.
Don't know what tool I can use to check the sanity of the ntfs filesystem u=
nder linux
ntfsck from ntfsprogs was not helpful. It is an incomplete implemntation, w=
hich, for the=20
moment does nothing.=20

thx
-Gana
=A0
> On Wed, Feb 15, 2023 at 11:23 PM Ganapathi Kamath <hgkamath@hotmail.com> =
wrote:
> >
> >
> > Firstly, thankyou for your reply. I'm not a kernel expert, so I value w=
hat you say.
> > but as I raised the issue I felt I had to defend the usefulness, userba=
se and the need.
> >
> > > Typically double mounts are done via bind mounts (not really double
> > > mounted just the device showing someplace else).=A0=A0 Or one would d=
o a
> > > mount -o remount,rw <originaldir> and remount it rw so you could writ=
e
> > > to it.
> >
> > > A real double mount where the kernel fs modules manages both mounts a=
s
> > > if it was a separate device won't work reliably, as the filesystem
> > > module/caching assumes it has total control.=A0=A0 So writing to a
> > > read-write device that has a separate read-only mount with some data
> > > in the read cache will not return the true data in all cases.=A0=A0=
=A0 2
> > > read-write (done any way--except with a clustering fs modules) are
> > > going to cause corruption of the underlying filesystem.
> >
> > I want to clarify, even though ventoy uses the word 'remount' to descri=
be the
> > feature, the host file system isn't mounted twice.=A0 There is no loopb=
ack-fs
> > to bind mount. and dmsetup status shows linear sequences of blocks allo=
cated
> > to the devmapper device.
> >
> > For this feature to work, the Linux being booted up, creates the devmap=
per
> > device by after having first somehow determined the sectors occupied by
> > the file in the filesystem. Then mounts the partitions inside devmapper=
 device
> > and then pivots to the discovered rootfs and continues booting.
> >
> > So what I think you are saying is that a mount of /dev/sdc1 and
> > /dev/mapper/ventoy are claiming to use the hard-disk sectors, and askin=
g the
> > kernel to consider them as part of its disk-sector caching mechanism.
> >
> > Booting virtual-disks this way is also called nativeboot.
> > The way this nativeboot so far works, has a little danger.
> > Three safe guards are to be followed by self contract:
> > 1) The virtual-disk-file must be a fixed size, it cannot be allowed to =
grow or shrink.
> > 2) The virtual-disk-file must not be manipulated/touched/read from the =
host-partition.
> > 3) The filesystem driver shouldn't defrag, scrub or relocate the virtua=
l-disk-file.
> > This is so that the the file entry in the outside fs remains untouched.
> > Usually, as this is done by root and such administrative user knows wha=
t he is
> > doing, so it is not so much of a problem.
> > If one adheres to the above self-contract, the filesystem code for part=
itions inside
> > the dm-device does not interfere with the filesystem code for the outsi=
de partition.
> >
> > An idea just came to me. There maybe a way around the disk sector cachi=
ng.
> > Will this work or be more safer?
> > What if, in addition to /dev/mapper/ventoy, a second dm device
> > /dev/mapper/antiventoy of the same size of the host partition /dev/sdc1=
 is created
> > by stitching together the other remaining sectors of the host partition=
 /dev/sdc1,
> > with the vdisk sectors swapped for with null sectors. Then the two dm c=
reated disks:
> > /dev/mapper/ventoy and /dev/mapper/antiventoy can be mounted independen=
tly,
> > without overlap of disk sectors, separating their caching.
> > The self-contract will still be needed, to not alter the location/size =
of fs-entry.
> > I'll suggest the above to ventoy. Your thoughts will be helpful.
> >
> > > Given that the use case for the module is dangerous and the use case
> > > is of questionable usefulness I would think that is no point of the
> > > module.=A0 The module's intent seems to be to get around the exclusiv=
e
> > > locks that the filesystem (for good reason) is putting on the device.
> >
> > I believe that the danger can be mitigated with a good idea and proper =
coding.
> > But the door shouldn't be shut.
> >
> > Its usefulness and base of users is really there. The use case is reall=
y important
> > 1) to those users who dualboot windows/linux, multi boot other OS-es
> > and juggle between them for want of SSD space,
> > 2) to multiboot alternate OS. but have limited on-machine disk-space
> > 2) to mounting different live isos often, which are often re-downloaded=
 due to updates.
> > 3) to those keeping a host of recovery isos-s at hand for emergency lik=
e
> > WINRE, WIN-installer, linux-installer, HBCD-PE, gparted, clonezilla,
> > rescuezilla, seabios, samsung-wizard at hand,
> >
> > Why not a VM?:
> > VM-s are nice but a bit slower than nativeboot. Many things cannot be d=
one
> > inside a VM such as get full native experience of a live iso, GPU suppo=
rt and all.
> > Some system level recovery and repair tools must be booted as native.
> >
> > In the old days Harddisks, USB drives, iso files were small.
> > vdisks were inexistent.
> > One had to burn live-isos to cd/dvd. Disks have grown larger.
> > Burning DVDs is such a waste now.
> >
> > At one point I considered having a small number of 8GB microsd cards to=
 function
> > just like tiny dvds/floppies. But managing them is also a hassle, as th=
ey are stored
> > external.
> >
> > Disadvantages of flashing USB drive
> > * flashing a USB drive, which say is 32gb, with a tiny <3gb ISO file. c=
an result in it wasting
> > space as it creates a small partition, limiting the drive's usefulness.
> > * One doesn't want too many usb drives lying around to boot different i=
so-s
> > * In my experience, flashing seems to have a higher frequency of bricki=
ng the USB key.
> >
> > With multiboot solutions, Its much easier to copy in and out liveisos b=
etween
> > large filesytems ExFAT, NTFS, ext4 . Linux (as of 6.1) has mature fs dr=
iver for
> > ExFAT(5.4) and NTFS (5.15)
> >
> > I've have tried creating my own grub2 configurations to loop mount isos=
.
> > but then its too much work to maintain. One has to update grub2 config =
files
> > everytime one downloads and deletes ISOs. Its preferable, that this is
> > auto-detected or dynamically done.
> >
> > Then I considered other multiboot solutions like
> > YUMI, Unetbootin, MultiBootUSB, supergrub2
> >
> > Ventoy seems to best them, by
> > - automatic detection of isos with grub2 menu
> > - also being able to nativeboot vdisks.
> > Ventoy seems to be fork of grub2 with some additional code to handle vd=
isks.
> >
> > One problem with partitioning systems for multi-OS machines is that the
> > limited disk space of a 512gb SSD drive gets broken and underutilized b=
etween partitions.
> > This leaves less usable space in a home partition.
> > Filesystems like btrfs allow having one big volume, installing an OS to
> > subvolumes and allow booting from subvolumes. Thereby sharing unused
> > space. One can then backup-up, offload and restoring subvolumes on need=
.
> > but this isn't cross platform. and requires more mental cognitive invol=
vement.
> >
> > Consider having windows and linux dual boot. and a data partition.
> > One might give 64 gb to each OS. that means when booted into one OS, th=
e
> > space occupied by the other OS is a waste. before you know it, there is=
 very
> > little space on the SSD=A0 due to all the OS partitions.
> >
> > Ventoy allows one to just keep a few 40gb vdisk files in the 512 gb par=
tition.
> > User can easily move all unused images an external backup, until later =
use.
> >
> > Now onto ventoy dm_patch itself.
> > I tried reading the patch code dm_patch.c .
> > It is strange to me. seems to be finding specifc addresses in memory;
> > blanking them, inserting opcodes like 0x80, etc.
> > The method taken (kernel/initramfs patching) is spooky.
> > It also inserts code/scripts/files into the initramfs for liveisos, whi=
ch it can do, because it
> > is the bootloader, and its MOK (machine owner key) has been added to th=
e UEFI.
> > Even though ventoy seems to be honest trustable opensource GPL develope=
r, you never
> > know if the mechanism of side-patching initramfs and kernel allows for =
future exploits by
> > malicious entities/governments.
> > One wants to be tension free on that front and kernel developers have a=
 responsibility
> > to keep linux-users from straying over to risky solutions.
> > This is apart from how duplicated work it seems to maintain it that I m=
entioned in the bug.
> > A legit desirable feature shouldn't have to rely on these techniques.
> > Its better, for the feature to exist with the blessing of kernel code r=
eview and signing
> >
> > Here, I'm not giving a 'because windows does, linux should do so too',
> > justification. But, windows does do nativeboot of vhdx now since Win10-=
1903.
> > Only, to mention, that nativebooting vdisks is a useful enough thing, t=
hat Microsoft
> > also allows for it. As is the case for ventoy, the vhdx should be fixed=
-size and not be
> > touched in the hosting drive. They note their common scenarios and bene=
fits.
> > https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/=
deploy-windows-on-a-vhd--native-boot?view=3Dwindows-11
> > I configured a BCDBOOT/BCDEDIT entry to boot a HBCD-PE vhdx this way.
> >
> > If one completely abandoned windows, without the need for cross-platfor=
m usability,
> > foregoing VM-attachable/host-mountable mountable vdisks. there could be=
 other
> > solutions such as btrfs subvolumes. But most home users laptops, come w=
ith windows,
> > have limited space and getting rid of windows and windows compatible te=
chnology
> > completely may not be an option.
> >
> > Are there dm-devel kernel developers, who have tried ventoy or explored=
 ventoy like solutions.
> > I do want to be assured that some dm-devel developer is put their great=
 mind to this
> > if at least on the backburner.
> >
> > Sorry if too verbose. I value your time.
> > Thanks
> > -Gana
> >
> > On Wed, Feb 15, 2023 at 3:33 AM Ganapathi Kamath <hgkamath@hotmail.com>=
 wrote:
> > >>
> > >> I am just an ordinary user of Linux and ventoy .
> > >> Q)
> > >> https://github.com/ventoy/Ventoy/issues/2234
> > >> Is what I have suggested here, meaningful?
> > >> Is there contra-indications to not do it or an alternative suggestio=
ns?
> > >> thoughts?
> > >>
> > >> Ventoy, a GPL software, uses a small kernel patch to achieve a small=
 remountability feature.
> > >> It seemed to me, that patching the kernel per distribution is sub-op=
timal.
> > >> I couldn't find a previous relevant discussion on this on dm-devel, =
but it seems like a requirement would've been well known and this would hav=
e already been discussed. What does the actually patch do?
> > >>
> > >> Thx
> > >> -Gana
> > >>
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > v https://listman.redhat.com/mailman/listinfo/dm-devel
> > >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

