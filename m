Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF28FC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 11:15:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4F1E423104
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 11:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F1E423104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-Bmb_586COl-Ze0bWsLZDew-1; Tue, 26 Jan 2021 06:15:14 -0500
X-MC-Unique: Bmb_586COl-Ze0bWsLZDew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A3FE1005513;
	Tue, 26 Jan 2021 11:15:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8EA95D9C2;
	Tue, 26 Jan 2021 11:15:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60044180954D;
	Tue, 26 Jan 2021 11:15:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QBEREM017173 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 06:14:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ADEBC2166B29; Tue, 26 Jan 2021 11:14:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A84832166B28
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 11:14:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70B70858EEC
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 11:14:25 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-231-z2H57Eo7NaenE1V-ksnOhw-1; Tue, 26 Jan 2021 06:14:20 -0500
X-MC-Unique: z2H57Eo7NaenE1V-ksnOhw-1
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ3xT4qrwzjCpT;
	Tue, 26 Jan 2021 19:13:01 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server
	id 14.3.498.0; Tue, 26 Jan 2021 19:14:04 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list
	<dm-devel@redhat.com>
References: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
	<f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
	<d8ba8118-ce98-249a-cafd-021f0c1831a5@huawei.com>
	<f1961d4104b14c80183b161a53262e1766e0df70.camel@suse.com>
	<c52487a2-5c15-977c-704b-7cad5f6e275e@huawei.com>
	<cd3cae852bffc2d4a9be2e7f4334eb346cfaae8d.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <ef4f29d8-a20b-2b4d-97ab-a83fb4bca5ac@huawei.com>
Date: Tue, 26 Jan 2021 19:14:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cd3cae852bffc2d4a9be2e7f4334eb346cfaae8d.camel@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QBEREM017173
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>, lihaotian9@huawei.com
Subject: Re: [dm-devel] [QUESTION]: multipath device with wrong path lead to
	metadata err
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable


>> Hi,
>> =A0 Unfortunately the verify_path() called before *and* after domap()
>> in
>> coalesce_paths can't solve this problem. I think it is another way to
>> lead multipath with wrong path, but now I can't find the way from
>> log.
>=20
> Can you provide multipathd -v3 logs, and kernel logs? Maybe I'll see
> something.
>=20

Logs in first sence:
Jan 26 12:37:47 client1 multipathd[2532437]: reconfigure (operator)
Jan 25 12:37:47 client1 multipathd[2532437]: 3600140584e11eb1818c4afab12c17=
800: remove multipath map
Jan 25 12:37:47 client1 multipathd[2532437]: sdh: orphan path, map flushed
Jan 25 12:37:47 client1 multipathd[2532437]: BUG: orphaning path sdh that h=
olds hwe of 3600140584e11eb1818c4afab12c17800
Jan 25 12:37:47 client1 multipathd[2532437]: 3600140531f063b3e19349bc82028e=
0cc: remove multipath map
Jan 25 12:37:47 client1 multipathd[2532437]: sdn: orphan path, map flushed
Jan 25 12:37:47 client1 multipathd[2532437]: BUG: orphaning path sdn that h=
olds hwe of 3600140531f063b3e19349bc82028e0cc
Jan 25 12:37:47 client1 multipathd[2532437]: 36001405ca5165367d67447ea68108=
e1d: remove multipath map
Jan 25 12:37:47 client1 multipathd[2532437]: sdi: orphan path, map flushed
Jan 25 12:37:47 client1 multipathd[2532437]: BUG: orphaning path sdi that h=
olds hwe of 36001405ca5165367d67447ea68108e1d
Jan 25 12:37:47 client1 multipathd[2532437]: 8:208: cannot find block devic=
e
Jan 25 12:37:47 client1 multipathd[2532437]: 3600140531f063b3e19349bc82028e=
0cc: remove multipath map
Jan 25 12:37:47 client1 multipathd[2532437]: 8:128: cannot find block devic=
e
Jan 25 12:37:47 client1 multipathd[2532437]: 36001405ca5165367d67447ea68108=
e1d: remove multipath map
Jan 25 12:37:47 client1 multipathd[2532437]: 8:112: cannot find block devic=
e
Jan 25 12:37:47 client1 multipathd[2532437]: 3600140584e11eb1818c4afab12c17=
800: remove multipath map
Jan 25 12:37:47 client1 multipathd[2532437]: sda: orphan path, blacklisted
Jan 25 12:37:47 client1 multipathd[2532437]: sdb: orphan path, blacklisted
Jan 25 12:37:47 client1 multipathd[2532437]: 3600140584e11eb1818c4afab12c17=
800: set ACT_CREATE (map does not exist)
Jan 25 12:37:47 client1 kernel: [1202538.089589] device-mapper: multipath: =
Reinstating path 8:208.
Jan 25 12:37:47 client1 kernel: [1202538.089606] lxk kernel params 0 1 alua=
 1 1 service-time 0 1 1 8:48 1
Jan 25 12:37:47 client1 kernel: [1202538.089607] name dm-3; majir:minor 253=
:3; dm-3
Jan 25 12:37:47 client1 kernel: [1202538.089688] device-mapper: multipath: =
Reinstating path 8:128.
Jan 25 12:37:47 client1 kernel: [1202538.089762] lxk load_table success 0
Jan 25 12:37:47 client1 kernel: [1202538.089768] device-mapper: multipath: =
Reinstating path 8:112.
Jan 25 12:37:47 client1 kernel: [1202538.090266] lxk kernel params 0 1 alua=
 1 1 service-time 0 1 1 8:48 1
Jan 25 12:37:47 client1 kernel: [1202538.090268] name dm-3; majir:minor 253=
:3; dm-3
Jan 25 12:37:47 client1 multipath[788570]: loading /lib64/multipath/libchec=
ktur.so checker
Jan 25 12:37:47 client1 multipath[788570]: 8:112: cannot find block device
Jan 25 12:37:47 client1 multipath[788570]: 8:112: Empty device name
Jan 25 12:37:47 client1 multipath[788570]: 8:112: Empty device name
Jan 25 12:37:47 client1 multipath[788570]: get_udev_device: failed to look =
up 8:112 with type 1
Jan 25 12:37:47 client1 multipath[788570]: dm-3: no usable paths found
Jan 25 12:37:47 client1 multipath[788569]: loading /lib64/multipath/libchec=
ktur.so checker
Jan 25 12:37:47 client1 multipath[788571]: loading /lib64/multipath/libchec=
ktur.so checker
Jan 25 12:37:47 client1 multipath[788569]: 8:128: cannot find block device
Jan 25 12:37:47 client1 multipath[788569]: 8:128: Empty device name
Jan 25 12:37:47 client1 multipath[788569]: 8:128: Empty device name
Jan 25 12:37:47 client1 multipath[788569]: get_udev_device: failed to look =
up 8:128 with type 1
Jan 25 12:37:47 client1 multipath[788569]: dm-6: no usable paths found
Jan 25 12:37:47 client1 multipath[788571]: 8:208: cannot find block device
Jan 25 12:37:47 client1 multipath[788571]: 8:208: Empty device name
Jan 25 12:37:47 client1 multipath[788571]: 8:208: Empty device name
Jan 25 12:37:47 client1 multipath[788571]: get_udev_device: failed to look =
up 8:208 with type 1
Jan 25 12:37:47 client1 multipath[788571]: dm-4: no usable paths found
Jan 25 12:37:47 client1 multipath[788580]: loading /lib64/multipath/libchec=
ktur.so checker
Jan 25 12:37:47 client1 kernel: [1202538.090340] lxk load_table success 0
Jan 25 12:37:47 client1 kernel: [1202538.128005] device-mapper: multipath: =
Failing path 8:208.
Jan 25 12:37:47 client1 kernel: [1202538.128937] device-mapper: multipath: =
Failing path 8:128.
Jan 25 12:37:47 client1 multipathd[2532437]: 3600140584e11eb1818c4afab12c17=
800: load table [0 20971520 multipath 0 1 alua 1 1 service-time 0 1 1 8:48 =
1]
Jan 25 12:37:47 client1 multipathd[2532437]: 3600140531f063b3e19349bc82028e=
0cc: set ACT_CREATE (map does not exist)
Jan 25 12:37:47 client1 kernel: [1202538.132361] scsi 3:0:0:0: alua: Detach=
ed
Jan 25 12:37:47 client1 kernel: [1202538.132370] lxk ref put after: name sd=
h; count 0
Jan 25 12:37:47 client1 kernel: [1202538.133024] EXT4-fs error: 1 callbacks=
 suppressed
Jan 25 12:37:47 client1 kernel: [1202538.133027] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:47 client1 kernel: [1202538.133031] EXT4-fs: 12 callbacks supp=
ressed
Jan 25 12:37:47 client1 kernel: [1202538.133033] EXT4-fs (dm-6): ext4_commi=
t_super: ec42fbc81d447c94 78c83f8f086afab0 seed is 0xca479c5b
Jan 25 12:37:47 client1 kernel: [1202538.133550] lxk kernel params 0 1 alua=
 1 1 service-time 0 1 1 8:224 1
Jan 25 12:37:47 client1 kernel: [1202538.133552] name dm-4; majir:minor 253=
:4; dm-4
Jan 25 12:37:47 client1 kernel: [1202538.133682] lxk load_table success 0
Jan 25 12:37:47 client1 kernel: [1202538.133968] lxk kernel params 0 1 alua=
 1 1 service-time 0 1 1 8:224 1
Jan 25 12:37:47 client1 kernel: [1202538.133970] name dm-4; majir:minor 253=
:4; dm-4
Jan 25 12:37:47 client1 kernel: [1202538.134017] lxk load_table success 0
Jan 25 12:37:47 client1 kernel: [1202538.135805] EXT4-fs (dm-6): I/O error =
while writing superblock
Jan 25 12:37:47 client1 kernel: [1202538.136029] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:47 client1 kernel: [1202538.136032] EXT4-fs (dm-6): ext4_commi=
t_super: ec42fbc81d447c94 78c83f8f086afab0 seed is 0xca479c5b
Jan 25 12:37:47 client1 kernel: [1202538.142127] EXT4-fs (dm-6): I/O error =
while writing superblock
Jan 25 12:37:47 client1 kernel: [1202538.143920] sd 4:0:0:0: alua: port gro=
up 00 state A non-preferred supports TOlUSNA
Jan 25 12:37:47 client1 kernel: [1202538.144911] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:47 client1 kernel: [1202538.144915] EXT4-fs (dm-6): ext4_commi=
t_super: ec42fbc81d447c94 78c83f8f086afab0 seed is 0xca479c5b
Jan 25 12:37:47 client1 kernel: [1202538.145373] EXT4-fs (dm-6): I/O error =
while writing superblock
Jan 25 12:37:47 client1 kernel: [1202538.145960] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:47 client1 kernel: [1202538.145963] EXT4-fs (dm-6): ext4_commi=
t_super: ec42fbc81d447c94 78c83f8f086afab0 seed is 0xca479c5b
Jan 25 12:37:47 client1 kernel: [1202538.146046] EXT4-fs (dm-6): I/O error =
while writing superblock
Jan 25 12:37:47 client1 kernel: [1202538.146195] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:47 client1 kernel: [1202538.146196] EXT4-fs (dm-6): ext4_commi=
t_super: ec42fbc81d447c94 78c83f8f086afab0 seed is 0xca479c5b
Jan 25 12:37:47 client1 kernel: [1202538.148027] EXT4-fs (dm-6): I/O error =
while writing superblock
Jan 25 12:37:47 client1 kernel: [1202538.148920] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:47 client1 kernel: [1202538.149466] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:47 client1 kernel: [1202538.149578] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:48 client1 kernel: [1202538.149639] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:48 client1 kernel: [1202538.149673] EXT4-fs error (device dm-6=
): ext4_find_entry:1456: inode #131073: comm fsstress: reading directory lb=
lock 0
Jan 25 12:37:48 client1 kernel: [1202538.149961] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202538.155906] scsi 3:0:0:1: alua: Detach=
ed
Jan 25 12:37:48 client1 kernel: [1202538.155914] lxk ref put after: name sd=
n; count 0
Jan 25 12:37:48 client1 kernel: [1202538.158130] lxk kernel params 0 1 alua=
 1 1 service-time 0 1 1 8:80 1
Jan 25 12:37:48 client1 kernel: [1202538.158132] name dm-5; majir:minor 253=
:5; dm-5
Jan 25 12:37:48 client1 kernel: [1202538.159310] dm destory name dm-7; maji=
r:minor 253:7; dm-7
Jan 25 12:37:48 client1 kernel: [1202538.161448] lxk load_table success 0
Jan 25 12:37:48 client1 kernel: [1202538.163417] lxk kernel params 0 1 alua=
 1 1 service-time 0 1 1 8:64 1
Jan 25 12:37:48 client1 kernel: [1202538.163419] name dm-6; majir:minor 253=
:6; dm-6
Jan 25 12:37:48 client1 kernel: [1202538.163498] lxk load_table success 0
Jan 25 12:37:48 client1 kernel: [1202538.163972] dm destory name dm-5; maji=
r:minor 253:5; dm-5
Jan 25 12:37:48 client1 kernel: [1202538.196041] sd 4:0:0:3: alua: port gro=
up 00 state A non-preferred supports TOlUSNA
Jan 25 12:37:48 client1 kernel: [1202538.200208] scsi 3:0:0:3: alua: Detach=
ed
Jan 25 12:37:48 client1 kernel: [1202538.224361] lxk ref put after: name sd=
i; count 0
Jan 25 12:37:48 client1 kernel: [1202538.225086] lxk kernel params 0 1 alua=
 1 1 service-time 0 1 1 8:64 1
Jan 25 12:37:48 client1 kernel: [1202538.225088] name dm-6; majir:minor 253=
:6; dm-6
Jan 25 12:37:48 client1 kernel: [1202538.226914] lxk load_table success 0
Jan 25 12:37:48 client1 kernel: [1202538.311125] sd 4:0:0:0: [sdd] Synchron=
izing SCSI cache
Jan 25 12:37:48 client1 kernel: [1202538.312397] sd 4:0:0:3: alua: port gro=
up 00 state A non-preferred supports TOlUSNA
Jan 25 12:37:48 client1 kernel: [1202538.350483] device-mapper: multipath: =
Failing path 8:48.
Jan 25 12:37:48 client1 kernel: [1202538.378721] sd 4:0:0:3: [sde] Synchron=
izing SCSI cache
Jan 25 12:37:48 client1 kernel: [1202538.404214] device-mapper: multipath: =
Failing path 8:64.
Jan 25 12:37:48 client1 kernel: [1202538.404656] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202538.405940] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202538.467014] sd 4:0:0:2: [sdf] Synchron=
izing SCSI cache
Jan 25 12:37:48 client1 kernel: [1202538.568195] scsi 4:0:0:2: alua: Detach=
ed
Jan 25 12:37:48 client1 kernel: [1202538.569470] sd 4:0:0:1: [sdo] Synchron=
izing SCSI cache
Jan 25 12:37:48 client1 kernel: [1202538.621389] scsi host2: iSCSI Initiato=
r over TCP/IP
Jan 25 12:37:48 client1 kernel: [1202538.625805] scsi 2:0:0:0: Direct-Acces=
s     LIO-ORG  disk1            4.0  PQ: 0 ANSI: 5
Jan 25 12:37:48 client1 kernel: [1202538.627294] scsi 2:0:0:0: alua: suppor=
ts implicit and explicit TPGS
Jan 25 12:37:48 client1 kernel: [1202538.627302] scsi 2:0:0:0: alua: device=
 naa.600140584e11eb1818c4afab12c17800 port group 0 rel port 1
Jan 25 12:37:48 client1 kernel: [1202538.627875] sd 2:0:0:0: Attached scsi =
generic sg2 type 0
Jan 25 12:37:48 client1 kernel: [1202538.630344] scsi 2:0:0:3: Direct-Acces=
s     LIO-ORG  disk4            4.0  PQ: 0 ANSI: 5
Jan 25 12:37:48 client1 kernel: [1202538.630507] sd 2:0:0:0: [sdf] 20971520=
 512-byte logical blocks: (10.7 GB/10.0 GiB)
Jan 25 12:37:48 client1 kernel: [1202538.630655] sd 2:0:0:0: [sdf] Write Pr=
otect is off
Jan 25 12:37:48 client1 kernel: [1202538.630787] scsi 2:0:0:3: alua: suppor=
ts implicit and explicit TPGS
Jan 25 12:37:48 client1 kernel: [1202538.630793] scsi 2:0:0:3: alua: device=
 naa.6001405ca5165367d67447ea68108e1d port group 0 rel port 1
Jan 25 12:37:48 client1 kernel: [1202538.630914] sd 2:0:0:0: [sdf] Write ca=
che: enabled, read cache: enabled, supports DPO and FUA
Jan 25 12:37:48 client1 kernel: [1202538.631010] sd 2:0:0:3: Attached scsi =
generic sg3 type 0
Jan 25 12:37:48 client1 kernel: [1202538.632201] scsi 2:0:0:2: Direct-Acces=
s     LIO-ORG  disk3            4.0  PQ: 0 ANSI: 5
Jan 25 12:37:48 client1 kernel: [1202538.632388] sd 2:0:0:0: [sdf] Optimal =
transfer size 33488896 bytes
Jan 25 12:37:48 client1 kernel: [1202538.632590] scsi 2:0:0:2: alua: suppor=
ts implicit and explicit TPGS
Jan 25 12:37:48 client1 kernel: [1202538.632595] scsi 2:0:0:2: alua: device=
 naa.6001405b7679bd96b094bccbf971bc90 port group 0 rel port 1
Jan 25 12:37:48 client1 kernel: [1202538.632798] sd 2:0:0:2: Attached scsi =
generic sg4 type 0
Jan 25 12:37:48 client1 kernel: [1202538.633665] scsi 2:0:0:1: Direct-Acces=
s     LIO-ORG  disk2            4.0  PQ: 0 ANSI: 5
Jan 25 12:37:48 client1 kernel: [1202538.633869] sd 2:0:0:3: [sdh] 20971520=
 512-byte logical blocks: (10.7 GB/10.0 GiB)
Jan 25 12:37:48 client1 kernel: [1202538.634858] scsi 2:0:0:1: alua: suppor=
ts implicit and explicit TPGS
Jan 25 12:37:48 client1 kernel: [1202538.634864] scsi 2:0:0:1: alua: device=
 naa.600140531f063b3e19349bc82028e0cc port group 0 rel port 1
Jan 25 12:37:48 client1 kernel: [1202538.635089] sd 2:0:0:1: Attached scsi =
generic sg5 type 0
Jan 25 12:37:48 client1 kernel: [1202538.635295] sd 2:0:0:3: [sdh] Write Pr=
otect is off
Jan 25 12:37:48 client1 kernel: [1202538.635851] sd 2:0:0:2: [sdi] 20971520=
 512-byte logical blocks: (10.7 GB/10.0 GiB)
Jan 25 12:37:48 client1 kernel: [1202538.636726] sd 2:0:0:2: [sdi] Write Pr=
otect is off
Jan 25 12:37:48 client1 kernel: [1202538.636763] sd 2:0:0:0: alua: port gro=
up 00 state A non-preferred supports TOlUSNA
Jan 25 12:37:48 client1 kernel: [1202538.636988] sd 2:0:0:2: [sdi] Write ca=
che: enabled, read cache: enabled, supports DPO and FUA
Jan 25 12:37:48 client1 kernel: [1202538.638092] sd 2:0:0:1: [sdk] 20971520=
 512-byte logical blocks: (10.7 GB/10.0 GiB)
Jan 25 12:37:48 client1 kernel: [1202538.638188] sd 2:0:0:2: [sdi] Optimal =
transfer size 33488896 bytes
Jan 25 12:37:48 client1 kernel: [1202538.638271] sd 2:0:0:1: [sdk] Write Pr=
otect is off
Jan 25 12:37:48 client1 kernel: [1202538.638454] sd 2:0:0:1: [sdk] Write ca=
che: enabled, read cache: enabled, supports DPO and FUA
Jan 25 12:37:48 client1 kernel: [1202538.638618] sd 2:0:0:1: [sdk] Optimal =
transfer size 33488896 bytes
Jan 25 12:37:48 client1 kernel: [1202538.639700] sd 2:0:0:3: [sdh] Write ca=
che: enabled, read cache: enabled, supports DPO and FUA
Jan 25 12:37:48 client1 kernel: [1202538.640445] sd 2:0:0:3: alua: port gro=
up 00 state A non-preferred supports TOlUSNA
Jan 25 12:37:48 client1 kernel: [1202538.640798] sd 2:0:0:3: [sdh] Optimal =
transfer size 33488896 bytes
Jan 25 12:37:48 client1 kernel: [1202538.648538] sd 2:0:0:1: alua: port gro=
up 00 state A non-preferred supports TOlUSNA
Jan 25 12:37:48 client1 kernel: [1202538.648550] sd 2:0:0:2: alua: port gro=
up 00 state A non-preferred supports TOlUSNA
Jan 25 12:37:48 client1 kernel: [1202538.808805] sd 2:0:0:1: [sdk] Attached=
 SCSI disk
Jan 25 12:37:48 client1 kernel: [1202538.814309] sd 2:0:0:2: [sdi] Attached=
 SCSI disk
Jan 25 12:37:48 client1 kernel: [1202538.820568] sd 2:0:0:3: [sdh] Attached=
 SCSI disk
Jan 25 12:37:48 client1 kernel: [1202538.825745] sd 2:0:0:0: [sdf] Attached=
 SCSI disk
Jan 25 12:37:48 client1 kernel: [1202539.030796] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202539.033019] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202539.033378] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202539.039261] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202539.039337] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202539.039377] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 kernel: [1202539.040013] device-mapper: multipath: =
Failing path 8:224.
Jan 25 12:37:48 client1 kernel: [1202539.116181] EXT4-fs warning (device dm=
-6): htree_dirblock_to_tree:995: inode #131073: lblock 0: comm fsstress: er=
ror -5 reading directory block
Jan 25 12:37:48 client1 multipath[788595]: loading /lib64/multipath/libchec=
ktur.so checker
Jan 25 12:37:48 client1 multipathd[2532437]: 3600140531f063b3e19349bc82028e=
0cc: load table [0 20971520 multipath 0 1 alua 1 1 service-time 0 1 1 8:224=
 1]
Jan 25 12:37:48 client1 multipathd[2532437]: 36001405b7679bd96b094bccbf971b=
c90: set ACT_CREATE (map does not exist)
Jan 25 12:37:48 client1 multipathd[2532437]: 36001405b7679bd96b094bccbf971b=
c90: load table [0 20971520 multipath 0 1 alua 1 1 service-time 0 1 1 8:80 =
1]
Jan 25 12:37:48 client1 multipathd[2532437]: 36001405ca5165367d67447ea68108=
e1d: set ACT_CREATE (map does not exist)
Jan 25 12:37:48 client1 multipathd[2532437]: 36001405ca5165367d67447ea68108=
e1d: load table [0 20971520 multipath 0 1 alua 1 1 service-time 0 1 1 8:64 =
1]



(1)multipath -r: The sdf is found as a path of 36001405b7679bd96b094bccbf97=
1bc90
(iscsi node is 4:0:0:2)

(2)iscsi logout: The sdf is removed in iscsi in system time [1202538.467014=
].

(3)iscsi login: The sdf appears in iscsi in system time [1202538.825745].
It is a path of 3600140584e11eb1818c4afab12c17800 (iscsi node 2:0:0:0)

Here I have a doubt. When I stop in domap using gdb and iscsi log out/in,
the sdf will not  be used again becasue the disk refcount is not zero. I
add a print if the disk refcount is zero in put_disk_and_module (for
example lxk ref put after: name sdi; count 0), but there is not this print
about sdf.

(4)domap successd.

Do you have any advice about this?

Regards;
Lixiaokeng


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

