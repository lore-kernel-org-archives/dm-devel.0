Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 513F2C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 12 May 2022 15:48:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-qPUiGCz3OtyAJjrLmfGa5Q-1; Thu, 12 May 2022 11:48:33 -0400
X-MC-Unique: qPUiGCz3OtyAJjrLmfGa5Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D217185A79C;
	Thu, 12 May 2022 15:48:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6C1D12166B25;
	Thu, 12 May 2022 15:48:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 474CD194F4BF;
	Thu, 12 May 2022 15:48:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6551F1947058
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 May 2022 15:48:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 25550400DFBB; Thu, 12 May 2022 15:48:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2165740CF8F4
 for <dm-devel@redhat.com>; Thu, 12 May 2022 15:48:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00871384F80F
 for <dm-devel@redhat.com>; Thu, 12 May 2022 15:48:27 +0000 (UTC)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com
 [209.85.219.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-739JE8TRNpStLlkrV3xqHw-2; Thu, 12 May 2022 11:48:25 -0400
X-MC-Unique: 739JE8TRNpStLlkrV3xqHw-2
Received: by mail-yb1-f172.google.com with SMTP id m190so10534459ybf.4
 for <dm-devel@redhat.com>; Thu, 12 May 2022 08:48:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to;
 bh=4JnR+NDCXQKHPUQeHzhP75nx+AwAIysvkBJTfvZ5VKo=;
 b=zP9qQIQaNcsf2RYvsZY/dzSmRU8i4gXPnWiydyK4RMtZgNvlE3diMwzH8y2xDPtfgw
 yiNZNYDcKhv0y2cRPnsOVpNuZNv0vq6PyBnKhc84vpH5cmxQsv7Bmk1x0wbLfgwPIS5m
 ZnFTpykmrpGEhDZ5md3bNGtrwtM+YEdsGwu87Kbmz3hu3qkzB/g1wLKAIF/vWe2BTi9q
 Mfw195+KM1BnvZkobjnOBKlJzQLSEGyXaJltIEPuMis8JF9hM2rWbVP/ZZzhCm8S4XD4
 CfkGxgLok7acDBd/dswR4vNYAvUI8L4HMEb8gMvuSD+/vrfAw47ncdayjpNUKIt7L9Kv
 sxrQ==
X-Gm-Message-State: AOAM533Pp2FYT7l5yz1gDNOed/Ega7sk/R9dbTEhXYLT9YUHXMz72Dqk
 GM53afNtztoAaPQvyKezWUtDR5gsv/+rMKTJ44W91PJl
X-Google-Smtp-Source: ABdhPJzfCcLgE9SXKBKGqMAPKP5sdRODOE08hsrgwU58FLkidSHsvml3KM2pnhlHUw5l387RX7417jJ2e6VoJ7owspc=
X-Received: by 2002:a25:3613:0:b0:64b:2f8f:1fd0 with SMTP id
 d19-20020a253613000000b0064b2f8f1fd0mr510409yba.48.1652370504580; Thu, 12 May
 2022 08:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6h+hdxNSVq3kN7WSWLd3-Ta9Pt0+WCzrV_b7W9fe06C7BmWw@mail.gmail.com>
 <CAH6h+he=JtHG94DK7AVY5mytJBwRBUDChtM=j0W-pFAW9Wnrmg@mail.gmail.com>
In-Reply-To: <CAH6h+he=JtHG94DK7AVY5mytJBwRBUDChtM=j0W-pFAW9Wnrmg@mail.gmail.com>
From: Marc Smith <msmith626@gmail.com>
Date: Thu, 12 May 2022 11:48:13 -0400
Message-ID: <CAH6h+hdyowFr8GEjZS=+VL6M8hAvbL4e-MOycYGzR8XRwWtCjw@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] kernel BUG at drivers/md/dm-bufio.c:1155!
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 4, 2022 at 1:50 PM Marc Smith <msmith626@gmail.com> wrote:
>
> On Mon, May 2, 2022 at 2:03 PM Marc Smith <msmith626@gmail.com> wrote:
> >
> > Hi,
> >
> > I'm using Linux 5.4.190 (kernel.org) with 'lvmcache' (LVM2 version
> > 2.03.14). I use dm-cache (in write-back mode) and dm-writecache, both
> > via lvmcache for several logical volumes. I was recently performing
> > power-loss tests, and noticed one of the dm-cache (in write-back mode)
> > LV's is encountering a problem when I attempt to activate that volume
> > group:
> > [root@fusion-dvt3a ~]# vgchange -ay 10072a_1_default
> > Segmentation fault
> > [root@fusion-dvt3a ~]#
> >
> > Then in the kernel log I see this:
> > ...
> > [ 4528.074501] device-mapper: cache: Origin device (dm-30) discard
> > unsupported: Disabling discard passdown.
> > [ 4528.074716] device-mapper: array: array_block_check failed: blocknr
> > 16818504669106333287 != wanted 10
> > [ 4528.074717] device-mapper: block manager: array validator check
> > failed for block 10
> > [ 4528.074717] device-mapper: array: get_ablock failed
> > [ 4528.074718] device-mapper: cache metadata: dm_array_cursor_next for
> > mapping failed
> > [ 4528.074727] ------------[ cut here ]------------
> > [ 4528.074728] kernel BUG at drivers/md/dm-bufio.c:1155!
> > [ 4528.074732] invalid opcode: 0000 [#1] SMP NOPTI
> > [ 4528.074757] CPU: 9 PID: 53811 Comm: vgchange Kdump: loaded Tainted:
> > P           OE     5.4.190-esos.prod #1
> > [ 4528.074797] Hardware name: Quantum H2012/H12SSW-NT, BIOS
> > T20201009143356 10/09/2020
> > [ 4528.074833] RIP: 0010:dm_bufio_release+0x19/0x75
> > [ 4528.074855] Code: fb ff ff 48 89 ef be 01 00 00 00 5d e9 e3 fe ff
> > ff 41 54 55 4c 8b 67 78 48 89 fd 4c 89 e7 e8 5b cb 26 00 8b 45 50 85
> > c0 75 02 <0f> 0b ff c8 89 45 50 75 48 31 c9 ba 01 00 00 00 be 03 00 00
> > 00 49
> > [ 4528.074928] RSP: 0018:ffffc90009f73b78 EFLAGS: 00010246
> > [ 4528.074952] RAX: 0000000000000000 RBX: ffff88871f1fd340 RCX: 0000000000000007
> > [ 4528.074982] RDX: ffff888826ed1600 RSI: ffffc90009f73b58 RDI: ffff88880da7e800
> > [ 4528.075012] RBP: ffff8887482a0150 R08: 0000000000000001 R09: 0000000000037100
> > [ 4528.075042] R10: 0000000000000000 R11: 0000000000000068 R12: ffff88880da7e800
> > [ 4528.075073] R13: ffff88871f1fd478 R14: ffff88871f1fd340 R15: 00000000000001fc
> > [ 4528.075103] FS:  00007f48fab9b2c0(0000) GS:ffff88882b040000(0000)
> > knlGS:0000000000000000
> > [ 4528.075137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 4528.075161] CR2: 00007fae36386288 CR3: 0000000721d20000 CR4: 0000000000340ee0
> > [ 4528.075191] Call Trace:
> > [ 4528.075207]  dm_array_cursor_end+0x1c/0x27
> > [ 4528.075255]  dm_cache_load_mappings+0x2d0/0x322
> > [ 4528.075304]  ? clear_discard+0x34/0x34
> > [ 4528.075348]  cache_preresume+0x108/0x1e3
> > [ 4528.075395]  dm_table_resume_targets+0x38/0xa9
> > [ 4528.075443]  __dm_resume+0x33/0x45
> > [ 4528.075486]  dm_resume+0x8c/0xb1
> > [ 4528.075529]  dev_suspend+0x173/0x1d8
> > [ 4528.075573]  ctl_ioctl+0x2a6/0x39d
> > [ 4528.075617]  ? retrieve_status+0x19e/0x19e
> > [ 4528.075663]  dm_ctl_ioctl+0x5/0x8
> > [ 4528.075708]  vfs_ioctl+0x19/0x26
> > [ 4528.075751]  do_vfs_ioctl+0x52a/0x554
> > [ 4528.075797]  ? ksys_semctl.constprop.0+0xfe/0x15e
> > [ 4528.075847]  ? rcu_is_watching+0x5/0x9
> > [ 4528.075891]  ksys_ioctl+0x37/0x56
> > [ 4528.075935]  __x64_sys_ioctl+0x11/0x14
> > [ 4528.075980]  do_syscall_64+0x52/0x60
> > [ 4528.076027]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [ 4528.076077] RIP: 0033:0x7f48fac5f617
> > [ 4528.076121] Code: c0 78 ed 4c 89 e0 5a 5b 41 5c c3 48 8b 05 71 88
> > 0b 00 64 c7 00 26 00 00 00 48 83 c8 ff c3 0f 1f 44 00 00 b8 10 00 00
> > 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 49 88 0b 00 f7 d8 64 89
> > 01 48
> > [ 4528.076276] RSP: 002b:00007ffe25fa3298 EFLAGS: 00000206 ORIG_RAX:
> > 0000000000000010
> > [ 4528.076362] RAX: ffffffffffffffda RBX: 0000556c551c3391 RCX: 00007f48fac5f617
> > [ 4528.076419] RDX: 0000556c564ff2c0 RSI: 00000000c138fd06 RDI: 0000000000000003
> > [ 4528.076475] RBP: 0000556c564f3d30 R08: 0000556c552b7a5b R09: 00007ffe25fa30f8
> > [ 4528.076532] R10: 0000556c552beb30 R11: 0000000000000206 R12: 0000556c564ff2f0
> > [ 4528.076589] R13: 0000556c564ff2c0 R14: 0000556c564ff370 R15: 0000000000000001
> > [ 4528.076646] Modules linked in: dm_cache_smq pci_stub nvmet_rdma(O)
> > bcache celerity16fc_cfg(O) nvmet_fc(O) nvmet(O) qla2xxx(O) nvme_fc(O)
> > nvme_fabrics(O) bonding ntb_transport ntb_hw_switchtec(O)
> > cls_switchtec(O) qede qed bna rdmavt(O) ib_umad(O) rdma_ucm(O)
> > ib_srp(O) rdma_cm(O) iw_cm(O) ib_cm(O) iw_cxgb4(O) iw_cxgb3(O)
> > ib_qib(O) mlx5_ib(O) mlx5_core(O) mlxdevm(O) pci_hyperv_intf mlxfw(O)
> > ib_uverbs(O) ib_core(O) auxiliary(O) mlx4_ib(O) ib_mthca(O)
> > bnxt_en(OE) nvme(O) nvme_core(O) mlx_compat(O) [last unloaded: scst]
> > [ 4528.077476] ---[ end trace 97c700627c684afd ]---
> > [ 4528.083087] RIP: 0010:dm_bufio_release+0x19/0x75
> > [ 4528.083189] Code: fb ff ff 48 89 ef be 01 00 00 00 5d e9 e3 fe ff
> > ff 41 54 55 4c 8b 67 78 48 89 fd 4c 89 e7 e8 5b cb 26 00 8b 45 50 85
> > c0 75 02 <0f> 0b ff c8 89 45 50 75 48 31 c9 ba 01 00 00 00 be 03 00 00
> > 00 49
> > [ 4528.083397] RSP: 0018:ffffc90009f73b78 EFLAGS: 00010246
> > [ 4528.083499] RAX: 0000000000000000 RBX: ffff88871f1fd340 RCX: 0000000000000007
> > [ 4528.083608] RDX: ffff888826ed1600 RSI: ffffc90009f73b58 RDI: ffff88880da7e800
> > [ 4528.083717] RBP: ffff8887482a0150 R08: 0000000000000001 R09: 0000000000037100
> > [ 4528.083827] R10: 0000000000000000 R11: 0000000000000068 R12: ffff88880da7e800
> > [ 4528.083936] R13: ffff88871f1fd478 R14: ffff88871f1fd340 R15: 00000000000001fc
> > [ 4528.084051] FS:  00007f48fab9b2c0(0000) GS:ffff88882b040000(0000)
> > knlGS:0000000000000000
> > [ 4528.084194] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 4528.084298] CR2: 00007fae36386288 CR3: 0000000721d20000 CR4: 0000000000340ee0
> > ...
> >
> > The "blocknr" value of "16818504669106333287" caught my eye, as that
> > number seems way out of bounds for the origin/cache devices in this
> > setup (the cache LV size in this case is 256 MiB, and the origin
> > device is less than 500 GiB).
> >
> > At first I suspected cache device corruption, so I used the PV data
> > offset + PE segment sizes and offset to extract an image of the cache
> > LV into a separate file so I can examine it with the cache_* user land
> > tools, and this is what I see:
> > [root@fusion-dvt3a ~]# cache_dump /mnt/data/md122_C02_cvol.img
> > <superblock uuid="" block_size="128" nr_cache_blocks="3968"
> > policy="mq" hint_width="4">
> >   <mappings>
> >     <mapping cache_block="0" origin_block="7325368" dirty="false"/>
> >     <mapping cache_block="1" origin_block="7325369" dirty="false"/>
> >     <mapping cache_block="2" origin_block="7325370" dirty="false"/>
> >     <mapping cache_block="3" origin_block="7325371" dirty="false"/>
> >     <mapping cache_block="4" origin_block="7325372" dirty="false"/>
> >     <mapping cache_block="5" origin_block="7325373" dirty="false"/>
> >     <mapping cache_block="6" origin_block="7325374" dirty="false"/>
> >     <mapping cache_block="7" origin_block="7325375" dirty="false"/>
> >     <mapping cache_block="8" origin_block="0" dirty="false"/>
> >     <mapping cache_block="9" origin_block="7325351" dirty="false"/>
> >     <mapping cache_block="10" origin_block="1" dirty="false"/>
> >     <mapping cache_block="11" origin_block="2" dirty="false"/>
> >     <mapping cache_block="12" origin_block="4" dirty="false"/>
> >     <mapping cache_block="13" origin_block="8" dirty="false"/>
> >     <mapping cache_block="14" origin_block="16" dirty="false"/>
> >     <mapping cache_block="15" origin_block="32" dirty="false"/>
> >     <mapping cache_block="16" origin_block="64" dirty="false"/>
> >     <mapping cache_block="17" origin_block="3" dirty="false"/>
> >     <mapping cache_block="18" origin_block="5" dirty="false"/>
> >     <mapping cache_block="19" origin_block="6" dirty="false"/>
> >     <mapping cache_block="20" origin_block="7" dirty="false"/>
> >     <mapping cache_block="21" origin_block="9" dirty="false"/>
> >     <mapping cache_block="22" origin_block="10" dirty="false"/>
> >     <mapping cache_block="23" origin_block="11" dirty="false"/>
> >     <mapping cache_block="24" origin_block="12" dirty="false"/>
> >     <mapping cache_block="25" origin_block="13" dirty="false"/>
> >     <mapping cache_block="26" origin_block="14" dirty="false"/>
> >     <mapping cache_block="27" origin_block="15" dirty="false"/>
> >     <mapping cache_block="28" origin_block="7322946" dirty="false"/>
> >     <mapping cache_block="29" origin_block="7324340" dirty="false"/>
> >     <mapping cache_block="30" origin_block="7324341" dirty="false"/>
> >     <mapping cache_block="31" origin_block="7324342" dirty="false"/>
> >     <mapping cache_block="32" origin_block="7324343" dirty="false"/>
> >     <mapping cache_block="33" origin_block="7324344" dirty="false"/>
> >     <mapping cache_block="34" origin_block="7324345" dirty="false"/>
> >     <mapping cache_block="35" origin_block="7324346" dirty="false"/>
> >     <mapping cache_block="36" origin_block="7324347" dirty="false"/>
> >   </mappings>
> >   <hints>
> >     <hint cache_block="0" data="PwAAAA=="/>
> >     <hint cache_block="1" data="PwAAAA=="/>
> >     <hint cache_block="2" data="PwAAAA=="/>
> >     <hint cache_block="3" data="PwAAAA=="/>
> >     <hint cache_block="4" data="PwAAAA=="/>
> >     <hint cache_block="5" data="PwAAAA=="/>
> >     <hint cache_block="6" data="PwAAAA=="/>
> >     <hint cache_block="7" data="PwAAAA=="/>
> >     <hint cache_block="8" data="PwAAAA=="/>
> >     <hint cache_block="9" data="PwAAAA=="/>
> >     <hint cache_block="10" data="PwAAAA=="/>
> >     <hint cache_block="11" data="PwAAAA=="/>
> >     <hint cache_block="12" data="PwAAAA=="/>
> >     <hint cache_block="13" data="PwAAAA=="/>
> >     <hint cache_block="14" data="PwAAAA=="/>
> >     <hint cache_block="15" data="PwAAAA=="/>
> >     <hint cache_block="16" data="PwAAAA=="/>
> >     <hint cache_block="17" data="PwAAAA=="/>
> >     <hint cache_block="18" data="PwAAAA=="/>
> >     <hint cache_block="19" data="PwAAAA=="/>
> >     <hint cache_block="20" data="PwAAAA=="/>
> >     <hint cache_block="21" data="AAAAAA=="/>
> >     <hint cache_block="22" data="AAAAAA=="/>
> >     <hint cache_block="23" data="AAAAAA=="/>
> >     <hint cache_block="24" data="AAAAAA=="/>
> >     <hint cache_block="25" data="AAAAAA=="/>
> >     <hint cache_block="26" data="AAAAAA=="/>
> >     <hint cache_block="27" data="AAAAAA=="/>
> >     <hint cache_block="28" data="AAAAAA=="/>
> >     <hint cache_block="29" data="AAAAAA=="/>
> >     <hint cache_block="30" data="AAAAAA=="/>
> >     <hint cache_block="31" data="AAAAAA=="/>
> >     <hint cache_block="32" data="AAAAAA=="/>
> >     <hint cache_block="33" data="AAAAAA=="/>
> >     <hint cache_block="34" data="AAAAAA=="/>
> >     <hint cache_block="35" data="AAAAAA=="/>
> >     <hint cache_block="36" data="AAAAAA=="/>
> >   </hints>
> > </superblock>
> > [root@fusion-dvt3a ~]# cache_check /mnt/data/md122_C02_cvol.img
> > examining superblock
> > examining mapping array
> > examining hint array
> > examining discard bitset
> > [root@fusion-dvt3a ~]# echo $?
> > 0
> > [root@fusion-dvt3a ~]#
> >
> > Nothing seems out of the ordinary to me, and 'cache_check' doesn't
> > report any errors/problems with the metadata.
> >
> > So I then used a "debug" Linux Kernel (same 5.4.190 code) that
> > contains additional debugging features (full preemption, lock
> > debugging, etc.). It also has the
> > CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING feature enabled, which I suspect
> > might be related to the persistent-data stuff used by dm-cache. And
> > when I boot this kernel that has the additional debug features, I do
> > NOT hit the BUG_ON() in dm_bufio_release() and everything works
> > properly -- the VG/LV's activate just fine and are usable, no kernel
> > errors / call traces logged.
> >
> > I switched back and fourth between these two kernels several times,
> > just to make sure it wasn't a fluke. And indeed, I am unable to hit
> > this problem with the "debug" kernel.
> >
> > Based on the experiment between the two kernel configs and the user
> > land tools not reporting an error, it sounds like my cache metadata is
> > sound, but hitting some other issue that I don't understand yet.
> >
> > Wondering if anyone has any tips / guidance on additional debugging I
> > can do? I plan to circle back and take my original kernel config and
> > enable CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING to see if that has any
> > effect.
>
> I enabled these two additional kernel config options and re-tested:
> CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING=y
> CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
>
> And then when activating the VG, the 'lvm' (vgchange) tool still seg
> faults, but the kernel log and call trace is a bit different with
> these options enabled:
> ...
> [ 7134.908886] device-mapper: cache: Origin device (dm-30) discard
> unsupported: Disabling discard passdown.
> [ 7134.909088] device-mapper: array: array_block_check failed: blocknr
> 16818504669106333287 != wanted 10
> [ 7134.909090] device-mapper: block manager: array validator check
> failed for block 10
> [ 7134.909090] device-mapper: array: get_ablock failed
> [ 7134.909091] device-mapper: cache metadata: dm_array_cursor_next for
> mapping failed
> [ 7134.909102] ------------[ cut here ]------------
> [ 7134.909102] kernel BUG at drivers/md/persistent-data/dm-block-manager.c:246!
> [ 7134.909107] invalid opcode: 0000 [#1] SMP NOPTI
> [ 7134.909133] CPU: 13 PID: 75361 Comm: vgchange Kdump: loaded
> Tainted: P           OE     5.4.190-esos.prod #1
> [ 7134.909175] Hardware name: Quantum H2012/H12SSW-NT, BIOS
> T20201009143356 10/09/2020
> [ 7134.909214] RIP: 0010:bl_up_read+0xf/0x43
> [ 7134.909233] Code: 48 83 f8 04 75 f0 e8 69 fc ff ff 89 c0 48 c7 44
> c2 18 00 00 00 00 e9 e1 fb ff ff 55 48 89 fd e8 ab ff 25 00 83 7d 04
> 00 7f 02 <0f> 0b 48 89 ef 65 48 8b 34 25 40 ad 01 00 e8 b1 ff ff ff 48
> 8b 45
> [ 7134.909311] RSP: 0018:ffffc90009f1bb68 EFLAGS: 00010246
> [ 7134.909335] RAX: 0000000000000000 RBX: ffff88878e2e6b40 RCX: 0000000000000007
> [ 7134.909366] RDX: 0000000000000001 RSI: ffffc90009f1bb54 RDI: ffff888748f49858
> [ 7134.909397] RBP: ffff888748f49858 R08: 0000000000000001 R09: 0000000000036d00
> [ 7134.909428] R10: 0000000000000000 R11: 0000000000000068 R12: ffff888748f49858
> [ 7134.909459] R13: ffff88878e2e6c78 R14: ffff88878e2e6b40 R15: 00000000000001fc
> [ 7134.909491] FS:  00007fdfa39b72c0(0000) GS:ffff88882b140000(0000)
> knlGS:0000000000000000
> [ 7134.909526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7134.909552] CR2: 0000559be7639038 CR3: 00000007a5a72000 CR4: 0000000000340ee0
> [ 7134.909583] Call Trace:
> [ 7134.909597]  dm_bm_unlock+0x2f/0x3a
> [ 7134.909642]  dm_array_cursor_end+0x1c/0x27
> [ 7134.909690]  dm_cache_load_mappings+0x2d0/0x322
> [ 7134.909739]  ? clear_discard+0x34/0x34
> [ 7134.909784]  cache_preresume+0x108/0x1e3
> [ 7134.909831]  dm_table_resume_targets+0x38/0xa9
> [ 7134.909880]  __dm_resume+0x33/0x45
> [ 7134.909923]  dm_resume+0x8c/0xb1
> [ 7134.909967]  dev_suspend+0x173/0x1d8
> [ 7134.910011]  ctl_ioctl+0x2a6/0x39d
> [ 7134.910055]  ? retrieve_status+0x19e/0x19e
> [ 7134.910103]  dm_ctl_ioctl+0x5/0x8
> [ 7134.910148]  vfs_ioctl+0x19/0x26
> [ 7134.910191]  do_vfs_ioctl+0x52a/0x554
> [ 7134.910237]  ? ksys_semctl.constprop.0+0xfe/0x15e
> [ 7134.910287]  ? rcu_is_watching+0x5/0x9
> [ 7134.910333]  ksys_ioctl+0x37/0x56
> [ 7134.910376]  __x64_sys_ioctl+0x11/0x14
> [ 7134.910423]  do_syscall_64+0x52/0x60
> [ 7134.910469]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 7134.910520] RIP: 0033:0x7fdfa3a7b617
> [ 7134.910564] Code: c0 78 ed 4c 89 e0 5a 5b 41 5c c3 48 8b 05 71 88
> 0b 00 64 c7 00 26 00 00 00 48 83 c8 ff c3 0f 1f 44 00 00 b8 10 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 49 88 0b 00 f7 d8 64 89
> 01 48
> [ 7134.910722] RSP: 002b:00007fffcfccb488 EFLAGS: 00000206 ORIG_RAX:
> 0000000000000010
> [ 7134.910810] RAX: ffffffffffffffda RBX: 0000559be5dae391 RCX: 00007fdfa3a7b617
> [ 7134.910868] RDX: 0000559be76589c0 RSI: 00000000c138fd06 RDI: 0000000000000003
> [ 7134.910925] RBP: 0000559be764c830 R08: 0000559be5ea2a5b R09: 00007fffcfccb2e8
> [ 7134.910983] R10: 0000559be5ea9b30 R11: 0000000000000206 R12: 0000559be76589f0
> [ 7134.911041] R13: 0000559be76589c0 R14: 0000559be7658a70 R15: 0000000000000001
> [ 7134.911100] Modules linked in: dm_cache_smq pci_stub nvmet_rdma(O)
> bcache celerity16fc_cfg(O) nvmet_fc(O) nvmet(O) qla2xxx(O) nvme_fc(O)
> nvme_fabrics(O) bonding ntb_transport ntb_hw_switchtec(O)
> cls_switchtec(O) qede qed bna rdmavt(O) ib_umad(O) rdma_ucm(O)
> ib_srp(O) rdma_cm(O) iw_cm(O) ib_cm(O) iw_cxgb4(O) iw_cxgb3(O)
> ib_qib(O) mlx5_ib(O) mlx5_core(O) mlxdevm(O) pci_hyperv_intf mlxfw(O)
> ib_uverbs(O) ib_core(O) auxiliary(O) mlx4_ib(O) ib_mthca(O)
> bnxt_en(OE) nvme(O) nvme_core(O) mlx_compat(O) [last unloaded: scst]
> [ 7134.911937] ---[ end trace bf6823c5ee51ae83 ]---
> [ 7134.917732] RIP: 0010:bl_up_read+0xf/0x43
> [ 7134.917831] Code: 48 83 f8 04 75 f0 e8 69 fc ff ff 89 c0 48 c7 44
> c2 18 00 00 00 00 e9 e1 fb ff ff 55 48 89 fd e8 ab ff 25 00 83 7d 04
> 00 7f 02 <0f> 0b 48 89 ef 65 48 8b 34 25 40 ad 01 00 e8 b1 ff ff ff 48
> 8b 45
> [ 7134.918042] RSP: 0018:ffffc90009f1bb68 EFLAGS: 00010246
> [ 7134.918145] RAX: 0000000000000000 RBX: ffff88878e2e6b40 RCX: 0000000000000007
> [ 7134.918255] RDX: 0000000000000001 RSI: ffffc90009f1bb54 RDI: ffff888748f49858
> [ 7134.918365] RBP: ffff888748f49858 R08: 0000000000000001 R09: 0000000000036d00
> [ 7134.918475] R10: 0000000000000000 R11: 0000000000000068 R12: ffff888748f49858
> [ 7134.918585] R13: ffff88878e2e6c78 R14: ffff88878e2e6b40 R15: 00000000000001fc
> [ 7134.918699] FS:  00007fdfa39b72c0(0000) GS:ffff88882b140000(0000)
> knlGS:0000000000000000
> [ 7134.918843] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 7134.918950] CR2: 0000559be7639038 CR3: 00000007a5a72000 CR4: 0000000000340ee0
> ...
>
>

Okay, I played a bit with print_hex_dump() to examine the
dm_buffer->data regions while this occurs, and I can see quite a few
blocks read do not contain the correct value (block "10" in my case
above is just the first that fails the array_block_check() validator).
I believe hitting the BUG_ON() statements is simply a consequence of
the validator check failing, but I still need to sort that out.

At least for this scenario, even when examining the buffer contents in
bio_complete() the data is wrong (verified incorrect by reading real
data from the underlying block device using 'dd' and 'od' to compare).
The incorrect data doesn't seem to match any other pattern on the
block device so I assume it's just junk.

And I suspect using my debug kernel config makes it work simply due to
timing and nothing else. I have many more machines using dm-cache, and
this is the only one where I've encountered this issue. And oddly
enough, I can reproduce it _every_ time on this box, so for a possible
timing/race condition, that feels a bit off.

I've found that the corrupted dm_buffer->data values occur when using
dm_bufio_prefetch() (invoked via dm_bm_prefetch() in
dm-block-manager.c). If I comment out the dm_bufio_prefetch() call in
dm_bm_prefetch() (no pre-fetching of dm-cache metadata) then I am
unable to reproduce the problem!

The root cause is still not clear to me, and unfortunately I'm losing
access to the hardware where this issue occurs very soon. I looked
through DM-related commits in linux-next and nothing really sounds
applicable (at least to me).


Thanks,

Marc

> --Marc
>
>
> >
> >
> > Thanks for your time.
> >
> > --Marc

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

