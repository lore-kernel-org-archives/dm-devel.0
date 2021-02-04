Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F93C433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 07:41:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1119D64F48
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 07:41:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1119D64F48
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-J9FKG0BlOaalh6hIdr5DoA-1; Thu, 04 Feb 2021 02:41:51 -0500
X-MC-Unique: J9FKG0BlOaalh6hIdr5DoA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D29901020C21;
	Thu,  4 Feb 2021 07:41:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77F9C10016F9;
	Thu,  4 Feb 2021 07:41:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E76BC18095CB;
	Thu,  4 Feb 2021 07:41:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1147ff4Q005151 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Feb 2021 02:41:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F16A10EB293; Thu,  4 Feb 2021 07:41:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0966311558B6
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 07:41:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E9B785A59D
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 07:41:38 +0000 (UTC)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-219-LmviXXGIMSSAcCN4PRu6SA-1; Thu, 04 Feb 2021 02:41:32 -0500
X-MC-Unique: LmviXXGIMSSAcCN4PRu6SA-1
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DWVp00wcvzjHb5;
	Thu,  4 Feb 2021 15:40:24 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server
	id 14.3.498.0; Thu, 4 Feb 2021 15:41:22 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210202195744.2384-1-mwilck@suse.com>
	<4c3bb639-b359-85a4-ea76-ba83347acd7c@huawei.com>
	<85a30ad88a76e01600aa0879f727da09debf0c42.camel@suse.com>
	<6bafec0c-91e9-37cd-4c68-18f4175be51c@huawei.com>
	<82440fdb64a3722c4e3cba49ec6b94ebbf2db1ca.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <9f76457a-5a15-b6ee-8f92-60e23be07e48@huawei.com>
Date: Thu, 4 Feb 2021 15:41:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <82440fdb64a3722c4e3cba49ec6b94ebbf2db1ca.camel@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] libmultipath: check if adopt_path() really
 added current path
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="------------91120BEF6E86C70311F17856"
Content-Language: en-GB

--------------91120BEF6E86C70311F17856
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable



On 2021/2/3 21:14, Martin Wilck wrote:
> On Wed, 2021-02-03 at 17:42 +0800, lixiaokeng wrote:
>>
>>
>> On 2021/2/3 16:14, Martin Wilck wrote:
>>> Is this also a Tested-by:?=20
>>> IOW, did it fix your issue?
>>
>> Yes, it solves the crash.But there is an other issue.
>>
>> multipath.conf
>> defaults {
>> =A0=A0=A0=A0=A0=A0=A0 find_multipaths no
>> }
>>
>> [root@localhost coredump]# multipathd add path sdb
>> fail
>> [root@localhost coredump]# multipath -ll
>> [root@localhost coredump]# multipathd add path sdb
>> ok
>> [root@localhost coredump]# multipath -ll
>> 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1 dm-3 QEMU,QEMU HARDDISK
>> size=3D1.0G features=3D'0' hwhandler=3D'0' wp=3Drw
>> `-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
>> =A0 `- 2:0:0:1 sdb 8:16 active ready running
>>
>> I add local path twice. The first fails while the second
>> succeeds.
>=20
> More details please. What exactly were you doing? Was this a regression
> caused by my patch? Please provide multipathd -v3 logs.

I did nothing just "multipathd add path sdb" twice.
Here I do that again with multipath -v3. The attachment shows all
messages.

> Also, you're aware that "find_multipaths no" is discouraged?
> It leads to inconsistent behavior between multipath and multipathd.
>=20
There are some different things about local disks between 0.8.5 and 0.7.7.
I just test that.

Regards,
Lixiaokeng

--------------91120BEF6E86C70311F17856
Content-Type: text/plain; charset="UTF-8";
	name="multipathd add path sdb twice.txt"
Content-Disposition: attachment; filename="multipathd add path sdb twice.txt"
Content-Transfer-Encoding: quoted-printable

[root@localhost uppatch]# lsblk
NAME             MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                8:0    0  140G  0 disk=20
=E2=94=9C=E2=94=80sda1             8:1    0    1G  0 part /boot
=E2=94=94=E2=94=80sda2             8:2    0  139G  0 part=20
  =E2=94=9C=E2=94=80euleros-root 253:0    0   50G  0 lvm  /
  =E2=94=9C=E2=94=80euleros-swap 253:1    0    4G  0 lvm  [SWAP]
  =E2=94=94=E2=94=80euleros-home 253:2    0   85G  0 lvm  /home
sdb                8:16   0   10G  0 disk=20
sdc                8:32   0   10G  0 disk=20
sdd                8:48   0   10G  0 disk=20
sde                8:64   0   10G  0 disk=20
sdf                8:80   0    1G  0 disk=20
[root@localhost uppatch]# multipath -ll
[root@localhost uppatch]# multipath -v3
Feb 04 15:12:44 | set open fds limit to 1073741816/1073741816
Feb 04 15:12:44 | loading /lib64/multipath/libchecktur.so checker
Feb 04 15:12:44 | checker tur: message table size =3D 3
Feb 04 15:12:44 | loading /lib64/multipath/libprioconst.so prioritizer
Feb 04 15:12:44 | _init_foreign: foreign library "nvme" is not enabled
Feb 04 15:12:44 | sda: size =3D 293601280
Feb 04 15:12:44 | sda: vendor =3D QEMU
Feb 04 15:12:44 | sda: product =3D QEMU HARDDISK
Feb 04 15:12:44 | sda: rev =3D 2.5+
Feb 04 15:12:44 | sda: h:b:t:l =3D 2:0:0:0
Feb 04 15:12:44 | sda: tgt_node_name =3D=20
Feb 04 15:12:44 | sda: 18275 cyl, 255 heads, 63 sectors/track, start at 0
Feb 04 15:12:44 | sda: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:12:44 | 2:0:0:0: attribute vpd_pg80 not found in sysfs
Feb 04 15:12:44 | failed to read sysfs vpd pg80
Feb 04 15:12:44 | sda: fail to get serial
Feb 04 15:12:44 | sda: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sda: path_checker =3D tur (setting: multipath internal)
Feb 04 15:12:44 | sda: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:12:44 | sda: tur state =3D up
Feb 04 15:12:44 | sda: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:12:44 | sda: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0 (udev)
Feb 04 15:12:44 | sda: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sda: prio =3D const (setting: multipath internal)
Feb 04 15:12:44 | sda: prio args =3D "" (setting: multipath internal)
Feb 04 15:12:44 | sda: const prio =3D 1
Feb 04 15:12:44 | sdf: size =3D 2097152
Feb 04 15:12:44 | sdf: vendor =3D QEMU
Feb 04 15:12:44 | sdf: product =3D QEMU HARDDISK
Feb 04 15:12:44 | sdf: rev =3D 2.5+
Feb 04 15:12:44 | sdf: h:b:t:l =3D 2:0:0:1
Feb 04 15:12:44 | sdf: tgt_node_name =3D=20
Feb 04 15:12:44 | sdf: 1011 cyl, 34 heads, 61 sectors/track, start at 0
Feb 04 15:12:44 | sdf: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:12:44 | 2:0:0:1: attribute vpd_pg80 not found in sysfs
Feb 04 15:12:44 | failed to read sysfs vpd pg80
Feb 04 15:12:44 | sdf: fail to get serial
Feb 04 15:12:44 | sdf: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sdf: path_checker =3D tur (setting: multipath internal)
Feb 04 15:12:44 | sdf: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:12:44 | sdf: tur state =3D up
Feb 04 15:12:44 | sdf: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:12:44 | sdf: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1 (udev)
Feb 04 15:12:44 | sdf: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sdf: prio =3D const (setting: multipath internal)
Feb 04 15:12:44 | sdf: prio args =3D "" (setting: multipath internal)
Feb 04 15:12:44 | sdf: const prio =3D 1
Feb 04 15:12:44 | sde: size =3D 20971520
Feb 04 15:12:44 | sde: vendor =3D QEMU
Feb 04 15:12:44 | sde: product =3D QEMU HARDDISK
Feb 04 15:12:44 | sde: rev =3D 2.5+
Feb 04 15:12:44 | sde: h:b:t:l =3D 2:0:0:2
Feb 04 15:12:44 | sde: tgt_node_name =3D=20
Feb 04 15:12:44 | sde: 10240 cyl, 64 heads, 32 sectors/track, start at 0
Feb 04 15:12:44 | sde: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:12:44 | 2:0:0:2: attribute vpd_pg80 not found in sysfs
Feb 04 15:12:44 | failed to read sysfs vpd pg80
Feb 04 15:12:44 | sde: fail to get serial
Feb 04 15:12:44 | sde: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sde: path_checker =3D tur (setting: multipath internal)
Feb 04 15:12:44 | sde: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:12:44 | sde: tur state =3D up
Feb 04 15:12:44 | sde: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:12:44 | sde: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-2 (udev)
Feb 04 15:12:44 | sde: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sde: prio =3D const (setting: multipath internal)
Feb 04 15:12:44 | sde: prio args =3D "" (setting: multipath internal)
Feb 04 15:12:44 | sde: const prio =3D 1
Feb 04 15:12:44 | sdd: size =3D 20971520
Feb 04 15:12:44 | sdd: vendor =3D QEMU
Feb 04 15:12:44 | sdd: product =3D QEMU HARDDISK
Feb 04 15:12:44 | sdd: rev =3D 2.5+
Feb 04 15:12:44 | sdd: h:b:t:l =3D 2:0:0:3
Feb 04 15:12:44 | sdd: tgt_node_name =3D=20
Feb 04 15:12:44 | sdd: 10240 cyl, 64 heads, 32 sectors/track, start at 0
Feb 04 15:12:44 | sdd: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:12:44 | 2:0:0:3: attribute vpd_pg80 not found in sysfs
Feb 04 15:12:44 | failed to read sysfs vpd pg80
Feb 04 15:12:44 | sdd: fail to get serial
Feb 04 15:12:44 | sdd: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sdd: path_checker =3D tur (setting: multipath internal)
Feb 04 15:12:44 | sdd: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:12:44 | sdd: tur state =3D up
Feb 04 15:12:44 | sdd: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:12:44 | sdd: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-3 (udev)
Feb 04 15:12:44 | sdd: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sdd: prio =3D const (setting: multipath internal)
Feb 04 15:12:44 | sdd: prio args =3D "" (setting: multipath internal)
Feb 04 15:12:44 | sdd: const prio =3D 1
Feb 04 15:12:44 | sdc: size =3D 20971520
Feb 04 15:12:44 | sdc: vendor =3D QEMU
Feb 04 15:12:44 | sdc: product =3D QEMU HARDDISK
Feb 04 15:12:44 | sdc: rev =3D 2.5+
Feb 04 15:12:44 | sdc: h:b:t:l =3D 2:0:0:4
Feb 04 15:12:44 | sdc: tgt_node_name =3D=20
Feb 04 15:12:44 | sdc: 10240 cyl, 64 heads, 32 sectors/track, start at 0
Feb 04 15:12:44 | sdc: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:12:44 | 2:0:0:4: attribute vpd_pg80 not found in sysfs
Feb 04 15:12:44 | failed to read sysfs vpd pg80
Feb 04 15:12:44 | sdc: fail to get serial
Feb 04 15:12:44 | sdc: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sdc: path_checker =3D tur (setting: multipath internal)
Feb 04 15:12:44 | sdc: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:12:44 | sdc: tur state =3D up
Feb 04 15:12:44 | sdc: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:12:44 | sdc: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-4 (udev)
Feb 04 15:12:44 | sdc: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sdc: prio =3D const (setting: multipath internal)
Feb 04 15:12:44 | sdc: prio args =3D "" (setting: multipath internal)
Feb 04 15:12:44 | sdc: const prio =3D 1
Feb 04 15:12:44 | sdb: size =3D 20971520
Feb 04 15:12:44 | sdb: vendor =3D QEMU
Feb 04 15:12:44 | sdb: product =3D QEMU HARDDISK
Feb 04 15:12:44 | sdb: rev =3D 2.5+
Feb 04 15:12:44 | sdb: h:b:t:l =3D 2:0:0:5
Feb 04 15:12:44 | sdb: tgt_node_name =3D=20
Feb 04 15:12:44 | sdb: 10240 cyl, 64 heads, 32 sectors/track, start at 0
Feb 04 15:12:44 | sdb: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:12:44 | 2:0:0:5: attribute vpd_pg80 not found in sysfs
Feb 04 15:12:44 | failed to read sysfs vpd pg80
Feb 04 15:12:44 | sdb: fail to get serial
Feb 04 15:12:44 | sdb: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sdb: path_checker =3D tur (setting: multipath internal)
Feb 04 15:12:44 | sdb: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:12:44 | sdb: tur state =3D up
Feb 04 15:12:44 | sdb: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:12:44 | sdb: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-5 (udev)
Feb 04 15:12:44 | sdb: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:12:44 | sdb: prio =3D const (setting: multipath internal)
Feb 04 15:12:44 | sdb: prio args =3D "" (setting: multipath internal)
Feb 04 15:12:44 | sdb: const prio =3D 1
Feb 04 15:12:44 | dm-0: device node name blacklisted
Feb 04 15:12:44 | dm-1: device node name blacklisted
Feb 04 15:12:44 | dm-2: device node name blacklisted
=3D=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D
uuid                                  hcil    dev dev_t pri dm_st chk_st ve=
nd/
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0 2:0:0:0 sda 8:0   1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1 2:0:0:1 sdf 8:80  1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-2 2:0:0:2 sde 8:64  1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-3 2:0:0:3 sdd 8:48  1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-4 2:0:0:4 sdc 8:32  1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-5 2:0:0:5 sdb 8:16  1   undef undef  QE=
MU,
Feb 04 15:12:44 | libdevmapper version 1.02.170 (2020-03-24)
Feb 04 15:12:44 | DM multipath kernel driver v1.13.0
Feb 04 15:12:44 | sda: blacklisted, udev property missing
Feb 04 15:12:44 | sda: orphan path, blacklisted
Feb 04 15:12:44 | sdf: blacklisted, udev property missing
Feb 04 15:12:44 | sdf: orphan path, blacklisted
Feb 04 15:12:44 | sde: blacklisted, udev property missing
Feb 04 15:12:44 | sde: orphan path, blacklisted
Feb 04 15:12:44 | sdd: blacklisted, udev property missing
Feb 04 15:12:44 | sdd: orphan path, blacklisted
Feb 04 15:12:44 | sdc: blacklisted, udev property missing
Feb 04 15:12:44 | sdc: orphan path, blacklisted
Feb 04 15:12:44 | sdb: blacklisted, udev property missing
Feb 04 15:12:44 | sdb: orphan path, blacklisted
Feb 04 15:12:44 | unloading const prioritizer
Feb 04 15:12:44 | unloading tur checker
[root@localhost uppatch]# multipathd add path sdb
fail
[root@localhost uppatch]# multipathd add path sdb
ok
[root@localhost uppatch]# lsblk
NAME                                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOIN=
T
sda                                       8:0    0  140G  0 disk =20
=E2=94=9C=E2=94=80sda1                                    8:1    0    1G  0=
 part  /boot
=E2=94=94=E2=94=80sda2                                    8:2    0  139G  0=
 part =20
  =E2=94=9C=E2=94=80euleros-root                        253:0    0   50G  0=
 lvm   /
  =E2=94=9C=E2=94=80euleros-swap                        253:1    0    4G  0=
 lvm   [SWAP]
  =E2=94=94=E2=94=80euleros-home                        253:2    0   85G  0=
 lvm   /home
sdb                                       8:16   0   10G  0 disk =20
=E2=94=94=E2=94=800QEMU_QEMU_HARDDISK_drive-scsi0-0-0-5 253:3    0   10G  0=
 mpath=20
sdc                                       8:32   0   10G  0 disk =20
sdd                                       8:48   0   10G  0 disk =20
sde                                       8:64   0   10G  0 disk =20
sdf                                       8:80   0    1G  0 disk =20
[root@localhost uppatch]# multipath -ll
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-5 dm-3 QEMU,QEMU HARDDISK
size=3D10G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'service-time 0' prio=3D1 status=3Denabled
  `- 2:0:0:5 sdb 8:16 active ready running
[root@localhost uppatch]# multipath -v3
Feb 04 15:13:18 | set open fds limit to 1073741816/1073741816
Feb 04 15:13:18 | loading /lib64/multipath/libchecktur.so checker
Feb 04 15:13:18 | checker tur: message table size =3D 3
Feb 04 15:13:18 | loading /lib64/multipath/libprioconst.so prioritizer
Feb 04 15:13:18 | _init_foreign: foreign library "nvme" is not enabled
Feb 04 15:13:18 | sda: size =3D 293601280
Feb 04 15:13:18 | sda: vendor =3D QEMU
Feb 04 15:13:18 | sda: product =3D QEMU HARDDISK
Feb 04 15:13:18 | sda: rev =3D 2.5+
Feb 04 15:13:18 | sda: h:b:t:l =3D 2:0:0:0
Feb 04 15:13:18 | sda: tgt_node_name =3D=20
Feb 04 15:13:18 | sda: 18275 cyl, 255 heads, 63 sectors/track, start at 0
Feb 04 15:13:18 | sda: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:13:18 | 2:0:0:0: attribute vpd_pg80 not found in sysfs
Feb 04 15:13:18 | failed to read sysfs vpd pg80
Feb 04 15:13:18 | sda: fail to get serial
Feb 04 15:13:18 | sda: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sda: path_checker =3D tur (setting: multipath internal)
Feb 04 15:13:18 | sda: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:13:18 | sda: tur state =3D up
Feb 04 15:13:18 | sda: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:13:18 | sda: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0 (udev)
Feb 04 15:13:18 | sda: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sda: prio =3D const (setting: multipath internal)
Feb 04 15:13:18 | sda: prio args =3D "" (setting: multipath internal)
Feb 04 15:13:18 | sda: const prio =3D 1
Feb 04 15:13:18 | sdf: size =3D 2097152
Feb 04 15:13:18 | sdf: vendor =3D QEMU
Feb 04 15:13:18 | sdf: product =3D QEMU HARDDISK
Feb 04 15:13:18 | sdf: rev =3D 2.5+
Feb 04 15:13:18 | sdf: h:b:t:l =3D 2:0:0:1
Feb 04 15:13:18 | sdf: tgt_node_name =3D=20
Feb 04 15:13:18 | sdf: 1011 cyl, 34 heads, 61 sectors/track, start at 0
Feb 04 15:13:18 | sdf: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:13:18 | 2:0:0:1: attribute vpd_pg80 not found in sysfs
Feb 04 15:13:18 | failed to read sysfs vpd pg80
Feb 04 15:13:18 | sdf: fail to get serial
Feb 04 15:13:18 | sdf: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sdf: path_checker =3D tur (setting: multipath internal)
Feb 04 15:13:18 | sdf: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:13:18 | sdf: tur state =3D up
Feb 04 15:13:18 | sdf: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:13:18 | sdf: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1 (udev)
Feb 04 15:13:18 | sdf: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sdf: prio =3D const (setting: multipath internal)
Feb 04 15:13:18 | sdf: prio args =3D "" (setting: multipath internal)
Feb 04 15:13:18 | sdf: const prio =3D 1
Feb 04 15:13:18 | sde: size =3D 20971520
Feb 04 15:13:18 | sde: vendor =3D QEMU
Feb 04 15:13:18 | sde: product =3D QEMU HARDDISK
Feb 04 15:13:18 | sde: rev =3D 2.5+
Feb 04 15:13:18 | sde: h:b:t:l =3D 2:0:0:2
Feb 04 15:13:18 | sde: tgt_node_name =3D=20
Feb 04 15:13:18 | sde: 10240 cyl, 64 heads, 32 sectors/track, start at 0
Feb 04 15:13:18 | sde: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:13:18 | 2:0:0:2: attribute vpd_pg80 not found in sysfs
Feb 04 15:13:18 | failed to read sysfs vpd pg80
Feb 04 15:13:18 | sde: fail to get serial
Feb 04 15:13:18 | sde: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sde: path_checker =3D tur (setting: multipath internal)
Feb 04 15:13:18 | sde: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:13:18 | sde: tur state =3D up
Feb 04 15:13:18 | sde: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:13:18 | sde: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-2 (udev)
Feb 04 15:13:18 | sde: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sde: prio =3D const (setting: multipath internal)
Feb 04 15:13:18 | sde: prio args =3D "" (setting: multipath internal)
Feb 04 15:13:18 | sde: const prio =3D 1
Feb 04 15:13:18 | sdd: size =3D 20971520
Feb 04 15:13:18 | sdd: vendor =3D QEMU
Feb 04 15:13:18 | sdd: product =3D QEMU HARDDISK
Feb 04 15:13:18 | sdd: rev =3D 2.5+
Feb 04 15:13:18 | sdd: h:b:t:l =3D 2:0:0:3
Feb 04 15:13:18 | sdd: tgt_node_name =3D=20
Feb 04 15:13:18 | sdd: 10240 cyl, 64 heads, 32 sectors/track, start at 0
Feb 04 15:13:18 | sdd: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:13:18 | 2:0:0:3: attribute vpd_pg80 not found in sysfs
Feb 04 15:13:18 | failed to read sysfs vpd pg80
Feb 04 15:13:18 | sdd: fail to get serial
Feb 04 15:13:18 | sdd: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sdd: path_checker =3D tur (setting: multipath internal)
Feb 04 15:13:18 | sdd: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:13:18 | sdd: tur state =3D up
Feb 04 15:13:18 | sdd: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:13:18 | sdd: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-3 (udev)
Feb 04 15:13:18 | sdd: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sdd: prio =3D const (setting: multipath internal)
Feb 04 15:13:18 | sdd: prio args =3D "" (setting: multipath internal)
Feb 04 15:13:18 | sdd: const prio =3D 1
Feb 04 15:13:18 | sdc: size =3D 20971520
Feb 04 15:13:18 | sdc: vendor =3D QEMU
Feb 04 15:13:18 | sdc: product =3D QEMU HARDDISK
Feb 04 15:13:18 | sdc: rev =3D 2.5+
Feb 04 15:13:18 | sdc: h:b:t:l =3D 2:0:0:4
Feb 04 15:13:18 | sdc: tgt_node_name =3D=20
Feb 04 15:13:18 | sdc: 10240 cyl, 64 heads, 32 sectors/track, start at 0
Feb 04 15:13:18 | sdc: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:13:18 | 2:0:0:4: attribute vpd_pg80 not found in sysfs
Feb 04 15:13:18 | failed to read sysfs vpd pg80
Feb 04 15:13:18 | sdc: fail to get serial
Feb 04 15:13:18 | sdc: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sdc: path_checker =3D tur (setting: multipath internal)
Feb 04 15:13:18 | sdc: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:13:18 | sdc: tur state =3D up
Feb 04 15:13:18 | sdc: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:13:18 | sdc: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-4 (udev)
Feb 04 15:13:18 | sdc: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sdc: prio =3D const (setting: multipath internal)
Feb 04 15:13:18 | sdc: prio args =3D "" (setting: multipath internal)
Feb 04 15:13:18 | sdc: const prio =3D 1
Feb 04 15:13:18 | sdb: size =3D 20971520
Feb 04 15:13:18 | sdb: vendor =3D QEMU
Feb 04 15:13:18 | sdb: product =3D QEMU HARDDISK
Feb 04 15:13:18 | sdb: rev =3D 2.5+
Feb 04 15:13:18 | sdb: h:b:t:l =3D 2:0:0:5
Feb 04 15:13:18 | sdb: tgt_node_name =3D=20
Feb 04 15:13:18 | sdb: 10240 cyl, 64 heads, 32 sectors/track, start at 0
Feb 04 15:13:18 | sdb: vpd_vendor_id =3D 0 "undef" (setting: multipath inte=
rnal)
Feb 04 15:13:18 | 2:0:0:5: attribute vpd_pg80 not found in sysfs
Feb 04 15:13:18 | failed to read sysfs vpd pg80
Feb 04 15:13:18 | sdb: fail to get serial
Feb 04 15:13:18 | sdb: detect_checker =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sdb: path_checker =3D tur (setting: multipath internal)
Feb 04 15:13:18 | sdb: checker timeout =3D 30 s (setting: kernel sysfs)
Feb 04 15:13:18 | sdb: tur state =3D up
Feb 04 15:13:18 | sdb: uid_attribute =3D ID_SERIAL (setting: multipath inte=
rnal)
Feb 04 15:13:18 | sdb: uid =3D 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-5 (udev)
Feb 04 15:13:18 | sdb: detect_prio =3D yes (setting: multipath internal)
Feb 04 15:13:18 | sdb: prio =3D const (setting: multipath internal)
Feb 04 15:13:18 | sdb: prio args =3D "" (setting: multipath internal)
Feb 04 15:13:18 | sdb: const prio =3D 1
Feb 04 15:13:18 | dm-0: device node name blacklisted
Feb 04 15:13:18 | dm-1: device node name blacklisted
Feb 04 15:13:18 | dm-2: device node name blacklisted
Feb 04 15:13:18 | dm-3: device node name blacklisted
=3D=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D
uuid                                  hcil    dev dev_t pri dm_st chk_st ve=
nd/
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-0 2:0:0:0 sda 8:0   1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1 2:0:0:1 sdf 8:80  1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-2 2:0:0:2 sde 8:64  1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-3 2:0:0:3 sdd 8:48  1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-4 2:0:0:4 sdc 8:32  1   undef undef  QE=
MU,
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-5 2:0:0:5 sdb 8:16  1   undef undef  QE=
MU,
Feb 04 15:13:18 | libdevmapper version 1.02.170 (2020-03-24)
Feb 04 15:13:18 | DM multipath kernel driver v1.13.0
Feb 04 15:13:18 | sda: blacklisted, udev property missing
Feb 04 15:13:18 | sda: orphan path, blacklisted
Feb 04 15:13:18 | sdf: blacklisted, udev property missing
Feb 04 15:13:18 | sdf: orphan path, blacklisted
Feb 04 15:13:18 | sde: blacklisted, udev property missing
Feb 04 15:13:18 | sde: orphan path, blacklisted
Feb 04 15:13:18 | sdd: blacklisted, udev property missing
Feb 04 15:13:18 | sdd: orphan path, blacklisted
Feb 04 15:13:18 | sdc: blacklisted, udev property missing
Feb 04 15:13:18 | sdc: orphan path, blacklisted
Feb 04 15:13:18 | sdb: blacklisted, udev property missing
Feb 04 15:13:18 | sdb: orphan path, blacklisted
Feb 04 15:13:18 | unloading const prioritizer
Feb 04 15:13:18 | unloading tur checker
[root@localhost uppatch]# 
--------------91120BEF6E86C70311F17856
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--------------91120BEF6E86C70311F17856--

