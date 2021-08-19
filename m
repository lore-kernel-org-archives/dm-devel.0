Return-Path: <SRS0=6+Yd=NK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BBEC432BE
	for <dm-devel@archiver.kernel.org>; Thu, 19 Aug 2021 16:01:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DFECE6109E
	for <dm-devel@archiver.kernel.org>; Thu, 19 Aug 2021 16:01:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DFECE6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1629388872;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=L6ESIexJrzSFS++Z5O8kVlCjza8Yn7GZFOi4SwYraOA=;
	b=VgFUhQlCpWLo1t33CPIFtBH2ntL4+JESroKL29C0GraDBZNd79CIkx6f5jOBdFiqPh3lR8
	b3t9uUiCcKl/gELGivMbFDyX+w22W2cWBQHUh0DWD2tFzy0sLNR7lalFWVmxGoSADCS8r0
	5nDfvFikuP3HTlLB1vbQV4+K6JHWGwE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-jYsjSvYdPXCilHIMKWwgTw-1; Thu, 19 Aug 2021 12:01:10 -0400
X-MC-Unique: jYsjSvYdPXCilHIMKWwgTw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20CFD363B1;
	Thu, 19 Aug 2021 16:01:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BC8560916;
	Thu, 19 Aug 2021 16:01:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E59464BB7C;
	Thu, 19 Aug 2021 16:00:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17JFx3jR026818 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Aug 2021 11:59:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8B3DC20285B3; Thu, 19 Aug 2021 15:59:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84EA620285B1
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 15:59:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02CD718A01A9
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 15:59:00 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
	[209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-530-AzjQ93vZNcWWFEpfbuS1LQ-1; Thu, 19 Aug 2021 11:58:58 -0400
X-MC-Unique: AzjQ93vZNcWWFEpfbuS1LQ-1
Received: by mail-qk1-f199.google.com with SMTP id
	o4-20020ae9f504000000b003d39d97b227so4479839qkg.2
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 08:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=Me1COlJE+fNf2MA2i+p9n93Ad6ij71m4GnFgud0n3B8=;
	b=iYq5gXa6/zWj0nSgh5hrdx1RYwhqwW0kJAo1I5bgMLuj6g3sIMgj/C99MqCakr+Bpb
	vYoJR6hnBO0h3fPttxnaJ49rcmpnswCyofhZ/IGvY39SlJOaKkP2Zmw+ogVQ60HrkzNn
	9OnKHDTfqbisSzWp6WYZjLdEsaqnj5ng+sCRzfJ2ihOBU/xQK7BQ12P2Cq/iDBjoFwPX
	+GKpzEd7Fdopgq14IRUCSFLmcm0o9wqvR7pF62jI/+tXYBSuOvY8e2eW1/O9iLl2TuQq
	b5FfVm8ugJzdKftmSDG+2/YK8p8UaTn+xd5HneKto9FxaLUTWMm93Tg9qhCjEBOmPYe8
	m4Rg==
X-Gm-Message-State: AOAM533JsxuCzx8kcgEe5my10qn+/CL0qJp+24j+ziCwGKsBdLBJMk0P
	1ltrIaKuQe6JrIcAw37vcyDfFPbdwqhYh4od3Oqmd7ewaN4bzAi+QcER8Q/HrxBo45TFCKRH8X7
	SBTEcqNw7ExSmyg==
X-Received: by 2002:a37:758:: with SMTP id 85mr4435136qkh.85.1629388737457;
	Thu, 19 Aug 2021 08:58:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxefvr/mOUSF1fGm4FdKDFibnkNOEf+USNOW/H/TjXlLx7KD2LZw74sb0iRe3TRHkSoeB8WRg==
X-Received: by 2002:a37:758:: with SMTP id 85mr4435120qkh.85.1629388737202;
	Thu, 19 Aug 2021 08:58:57 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	d20sm1795263qkl.13.2021.08.19.08.58.56
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 19 Aug 2021 08:58:56 -0700 (PDT)
Date: Thu, 19 Aug 2021 11:58:56 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YR5/wMEkr1TwV7FD@redhat.com>
References: <20210804094147.459763-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210804094147.459763-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: [dm-devel] holders not working properly,
 regression [was: Re: use regular gendisk registration in device
 mapper v2]
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 04 2021 at  5:41P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
>=20
> The device mapper code currently has a somewhat odd gendisk registration
> scheme where it calls add_disk early, but uses a special flag to skip the
> "queue registration", which is a major part of add_disk.  This series
> improves the block layer holder tracking to work on an entirely
> unregistered disk and thus allows device mapper to use the normal scheme
> of calling add_disk when it is ready to accept I/O.
>=20
> Note that this leads to a user visible change - the sysfs attributes on
> the disk and the dm directory hanging off it are not only visible once
> the initial table is loaded.  This did not make a different to my testing
> using dmsetup and the lvm2 tools.
>=20
> Changes since v1:
>  - rebased on the lastes for-5.15/block tree
>  - improve various commit messages, including commit references

Hi,

This was originally reported to me by Tushar (cc'd).

Unfortunately I too am seeing a block-5.15/linux-next regression
related to holders when testing dm-multipath with an mptest test
case. To reproduce the following trcaes and crash simply do:

git clone=A0git://github.com/snitm/mptest.git
cd mptest
./runtest tests/test_02_sdev_delete

I got bogged with trying different kernels, because I _thought_ I
verified mptest's tests all passed when I reviewed v1 of this
patchset.  ut I'll pivot to looking closer at these traces and the
code to try to find the issue. But I've sat on this regression since
Tuesday so need to at least share with others now:

** Running: ./tests/test_02_sdev_delete

[ 1411.113642] ------------[ cut here ]------------
[ 1411.118260] kernfs: can not remove 'dm-0', no directory
[ 1411.123488] WARNING: CPU: 16 PID: 23326 at fs/kernfs/dir.c:1509 kernfs_r=
emove_by_name_ns+0x81/0x90
[ 1411.132446] Modules linked in: dm_queue_length dm_multipath tcm_loop tar=
get_core_user uio target_core_pscsi target_core_file target_core_iblock isc=
si_target_mod target_core_mod dm_mod nfsv3 nfs_acl nfs lockd grace sunrpc i=
ntel_rapl_msr intel_rapl_common skx_edac nfit intel_powerclamp coretemp kvm=
_intel kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pc=
lmul nd_pmem mei_me ghash_clmulni_intel i2c_i801 nd_btt ipmi_si joydev pcsp=
kr mei sg i2c_smbus lpc_ich wmi ipmi_devintf ipmi_msghandler acpi_pad acpi_=
power_meter ip_tables xfs libcrc32c sd_mod ast i2c_algo_bit drm_vram_helper=
 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_ttm_helpe=
r ttm drm ahci nvme libahci i40e nvme_core libata crc32c_intel i2c_core t10=
_pi
[ 1411.197935] CPU: 16 PID: 23326 Comm: dmsetup Tainted: G        W        =
 5.14.0-rc4.snitm+ #196
[ 1411.206624] Hardware name: Supermicro SYS-1029P-WTR/X11DDW-L, BIOS 2.0a =
12/06/2017
[ 1411.214190] RIP: 0010:kernfs_remove_by_name_ns+0x81/0x90
[ 1411.219504] Code: 45 8f 58 00 31 c0 5b 5d 41 5c c3 48 c7 c7 e0 e1 6a 85 =
e8 32 8f 58 00 b8 fe ff ff ff eb e8 48 c7 c7 c8 78 f3 84 e8 9e ef 53 00 <0f=
> 0b b8 fe ff ff ff eb d3 66 0f 1f 44 00 00 0f 1f 44 00 00 41 57
[ 1411.238251] RSP: 0018:ffffb6c3a198fc00 EFLAGS: 00010286
[ 1411.243474] RAX: 0000000000000000 RBX: ffff963d80d08980 RCX: 00000000000=
00000
[ 1411.250608] RDX: 0000000000000001 RSI: ffff963d600979d0 RDI: ffff963d600=
979d0
[ 1411.257741] RBP: ffff96360771a7d8 R08: 0000000000000000 R09: c0000000fff=
f7fff
[ 1411.264875] R10: 0000000000000001 R11: ffffb6c3a198fa10 R12: ffff963d835=
f5800
[ 1411.272007] R13: ffff963d835f5870 R14: dead000000000122 R15: dead0000000=
00100
[ 1411.279140] FS:  00007f9e557e1840(0000) GS:ffff963d60080000(0000) knlGS:=
0000000000000000
[ 1411.287227] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1411.292973] CR2: 0000000002dd9020 CR3: 000000014209e002 CR4: 00000000007=
706e0
[ 1411.300102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1411.307238] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 1411.314370] PKRU: 55555554
[ 1411.317082] Call Trace:
[ 1411.319536]  bd_unlink_disk_holder+0x78/0xc0
[ 1411.323815]  dm_put_table_device+0x5a/0xf0 [dm_mod]
[ 1411.328697]  dm_put_device+0x83/0xe0 [dm_mod]
[ 1411.333063]  ? dm_put_path_selector+0x30/0x40 [dm_multipath]
[ 1411.338721]  free_priority_group+0x8b/0xc0 [dm_multipath]
[ 1411.344121]  free_multipath+0x6a/0xa0 [dm_multipath]
[ 1411.349088]  ? table_load+0x2d0/0x2d0 [dm_mod]
[ 1411.353545]  dm_table_destroy+0x62/0x140 [dm_mod]
[ 1411.358257]  ? table_load+0x2d0/0x2d0 [dm_mod]
[ 1411.362703]  dev_suspend+0xe6/0x290 [dm_mod]
[ 1411.366976]  ctl_ioctl+0x1af/0x420 [dm_mod]
[ 1411.371162]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
[ 1411.375350]  __x64_sys_ioctl+0x84/0xc0
[ 1411.379102]  do_syscall_64+0x3a/0x80
[ 1411.382683]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1411.387731] RIP: 0033:0x7f9e550aa567

Trace that finally crashed was:
[ 1413.924355] general protection fault, probably for non-canonical address=
 0xdead000000000122: 0000 [#1] SMP PTI
[ 1413.924356] CPU: 0 PID: 23394 Comm: dmsetup Tainted: G        W         =
5.14.0-rc4.snitm+ #196
[ 1413.924357] Hardware name: Supermicro SYS-1029P-WTR/X11DDW-L, BIOS 2.0a =
12/06/2017
[ 1413.924358] RIP: 0010:string_nocheck+0x12/0x70
[ 1413.924358] Code: 00 00 4c 89 e2 be 20 00 00 00 48 89 ef e8 e6 a4 00 00 =
4c 01 e3 eb 81 90 49 89 f2 48 89 ce 48 89 f8 48 c1 fe 30 66 85 f6 74 4f <44=
> 0f b6 0a 45 84 c9 74 46 83 ee 01 41 b8 01 00 00 00 48 8d 7c 37
[ 1413.924359] RSP: 0018:ffffb6c3a1a6f9d0 EFLAGS: 00010086
[ 1413.924360] RAX: ffffb6c3a1a6faf2 RBX: ffffb6c3a1a6fae0 RCX: ffff0a00fff=
fff04
[ 1413.924361] RDX: dead000000000122 RSI: ffffffffffffffff RDI: ffffb6c3a1a=
6faf2
[ 1413.924361] RBP: dead000000000122 R08: 0000000000000009 R09: 00000000000=
00000
[ 1413.924362] R10: ffffb6c3a1a6fae0 R11: ffffb6c3a1a6f988 R12: ffff0a00fff=
fff04
[ 1413.924362] R13: ffffffff84f37876 R14: 0000000000000008 R15: ffffffff84f=
37876
[ 1413.924362] FS:  00007f967061f840(0000) GS:ffff963d5fe00000(0000) knlGS:=
0000000000000000
[ 1413.924363] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1413.924363] CR2: 0000000002bfc000 CR3: 00000001e22c0002 CR4: 00000000007=
706f0
[ 1413.924363] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1413.924364] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 1413.924364] PKRU: 55555554
[ 1413.924364] Call Trace:
[ 1413.924364]  string+0x40/0x50
[ 1413.924364]  vsnprintf+0x339/0x520
[ 1413.924365]  vprintk_store+0xad/0x440
[ 1413.924365]  ? __irq_work_queue_local+0x48/0x50
[ 1413.924365]  ? irq_work_queue+0x16/0x20
[ 1413.924366]  ? wake_up_klogd.part.31+0x30/0x40
[ 1413.924366]  ? vprintk_emit+0x11a/0x240
[ 1413.924366]  vprintk_emit+0xf7/0x240
[ 1413.924367]  __warn_printk+0x6b/0x87
[ 1413.924367]  ? kernfs_put+0xd0/0x190
[ 1413.924367]  kernfs_find_ns+0x9f/0xc0
[ 1413.924368]  kernfs_remove_by_name_ns+0x31/0x90
[ 1413.924368]  bd_unlink_disk_holder+0x78/0xc0
[ 1413.924369]  dm_put_table_device+0x5a/0xf0 [dm_mod]
[ 1413.924369]  dm_put_device+0x83/0xe0 [dm_mod]
[ 1413.924369]  ? dm_put_path_selector+0x30/0x40 [dm_multipath]
[ 1413.924369]  free_priority_group+0x8b/0xc0 [dm_multipath]
[ 1413.924370]  free_multipath+0x6a/0xa0 [dm_multipath]
[ 1413.924370]  ? table_load+0x2d0/0x2d0 [dm_mod]
[ 1413.924370]  dm_table_destroy+0x62/0x140 [dm_mod]
[ 1413.924370]  ? table_load+0x2d0/0x2d0 [dm_mod]
[ 1413.924371]  dev_suspend+0xe6/0x290 [dm_mod]
[ 1413.924371]  ctl_ioctl+0x1af/0x420 [dm_mod]
[ 1413.924371]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
[ 1413.924372]  __x64_sys_ioctl+0x84/0xc0
[ 1413.924372]  do_syscall_64+0x3a/0x80
[ 1413.924373]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1413.924373] RIP: 0033:0x7f966fee8567

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

