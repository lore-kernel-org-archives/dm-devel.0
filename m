Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99E2C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 18:04:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-__kSwNRQNmGR6twqYX2ZGQ-1; Mon, 02 May 2022 14:04:08 -0400
X-MC-Unique: __kSwNRQNmGR6twqYX2ZGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA4711C07389;
	Mon,  2 May 2022 18:04:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B3491121314;
	Mon,  2 May 2022 18:04:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4AC2C194704C;
	Mon,  2 May 2022 18:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2864E1947042
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 18:04:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 01D62550871; Mon,  2 May 2022 18:04:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1BBC550868
 for <dm-devel@redhat.com>; Mon,  2 May 2022 18:04:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5F4329ABA01
 for <dm-devel@redhat.com>; Mon,  2 May 2022 18:04:03 +0000 (UTC)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com
 [209.85.128.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-7mmS6OyyP_W9rnImxDZMTw-1; Mon, 02 May 2022 14:04:02 -0400
X-MC-Unique: 7mmS6OyyP_W9rnImxDZMTw-1
Received: by mail-yw1-f180.google.com with SMTP id
 00721157ae682-2ec42eae76bso156410077b3.10
 for <dm-devel@redhat.com>; Mon, 02 May 2022 11:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=O0MlhjoQyANhLcEuXPcGLmMBfHrFLNiD+6Kt8aWPjoM=;
 b=dRD0V/C/LLJOO7FC2a4ubGvU9JO0XpooAc0eYzH1ZNJl47OLaTc63eFemPaQ6RTPaJ
 2zlC7u6QZMGkPmLa7DFvlCzv308PssfAU20KtRuhB3K50sxvbH4UFPCCncp9cWIM8IPI
 jf3QkWzqSW+O42ngWgXGxgn0uZkOoVKYMy+9WwH4ftjRlpxFkqXK1kyu1IAyOjbrDmRF
 D5j7SAVT2SwO0A4pbigxolimnhf0AkUPDeGFsxJa8FQ65jBUL+Rz6WuyExo+xLCrKBmJ
 sh1ZN15Wh7zUIe8jJZU+fCULchsDGoUzN3Vmg8nx8DhfODPefe2QfvNP+mCJCwdJsr9m
 yn2g==
X-Gm-Message-State: AOAM5312Xk2nC520P0juPANXczhCnw6H1rpY3KU+KCh05ILsNGKhxgjF
 QaI3oIl+Yg9ms3j++gdnouq4L/1s3Eekk5Ys7Mn6w38hKnk=
X-Google-Smtp-Source: ABdhPJx/8uXQSNx5gSdvwzF0c4Nv4K79TAzEuFjOQAkrvab8uIKdWspGWzVyNr9bGEx87P4EYgDrFTKSasF0QhNQ9Cc=
X-Received: by 2002:a81:200b:0:b0:2f8:5866:9eb0 with SMTP id
 g11-20020a81200b000000b002f858669eb0mr12242937ywg.269.1651514641331; Mon, 02
 May 2022 11:04:01 -0700 (PDT)
MIME-Version: 1.0
From: Marc Smith <msmith626@gmail.com>
Date: Mon, 2 May 2022 14:03:50 -0400
Message-ID: <CAH6h+hdxNSVq3kN7WSWLd3-Ta9Pt0+WCzrV_b7W9fe06C7BmWw@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] kernel BUG at drivers/md/dm-bufio.c:1155!
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I'm using Linux 5.4.190 (kernel.org) with 'lvmcache' (LVM2 version
2.03.14). I use dm-cache (in write-back mode) and dm-writecache, both
via lvmcache for several logical volumes. I was recently performing
power-loss tests, and noticed one of the dm-cache (in write-back mode)
LV's is encountering a problem when I attempt to activate that volume
group:
[root@fusion-dvt3a ~]# vgchange -ay 10072a_1_default
Segmentation fault
[root@fusion-dvt3a ~]#

Then in the kernel log I see this:
...
[ 4528.074501] device-mapper: cache: Origin device (dm-30) discard
unsupported: Disabling discard passdown.
[ 4528.074716] device-mapper: array: array_block_check failed: blocknr
16818504669106333287 != wanted 10
[ 4528.074717] device-mapper: block manager: array validator check
failed for block 10
[ 4528.074717] device-mapper: array: get_ablock failed
[ 4528.074718] device-mapper: cache metadata: dm_array_cursor_next for
mapping failed
[ 4528.074727] ------------[ cut here ]------------
[ 4528.074728] kernel BUG at drivers/md/dm-bufio.c:1155!
[ 4528.074732] invalid opcode: 0000 [#1] SMP NOPTI
[ 4528.074757] CPU: 9 PID: 53811 Comm: vgchange Kdump: loaded Tainted:
P           OE     5.4.190-esos.prod #1
[ 4528.074797] Hardware name: Quantum H2012/H12SSW-NT, BIOS
T20201009143356 10/09/2020
[ 4528.074833] RIP: 0010:dm_bufio_release+0x19/0x75
[ 4528.074855] Code: fb ff ff 48 89 ef be 01 00 00 00 5d e9 e3 fe ff
ff 41 54 55 4c 8b 67 78 48 89 fd 4c 89 e7 e8 5b cb 26 00 8b 45 50 85
c0 75 02 <0f> 0b ff c8 89 45 50 75 48 31 c9 ba 01 00 00 00 be 03 00 00
00 49
[ 4528.074928] RSP: 0018:ffffc90009f73b78 EFLAGS: 00010246
[ 4528.074952] RAX: 0000000000000000 RBX: ffff88871f1fd340 RCX: 0000000000000007
[ 4528.074982] RDX: ffff888826ed1600 RSI: ffffc90009f73b58 RDI: ffff88880da7e800
[ 4528.075012] RBP: ffff8887482a0150 R08: 0000000000000001 R09: 0000000000037100
[ 4528.075042] R10: 0000000000000000 R11: 0000000000000068 R12: ffff88880da7e800
[ 4528.075073] R13: ffff88871f1fd478 R14: ffff88871f1fd340 R15: 00000000000001fc
[ 4528.075103] FS:  00007f48fab9b2c0(0000) GS:ffff88882b040000(0000)
knlGS:0000000000000000
[ 4528.075137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4528.075161] CR2: 00007fae36386288 CR3: 0000000721d20000 CR4: 0000000000340ee0
[ 4528.075191] Call Trace:
[ 4528.075207]  dm_array_cursor_end+0x1c/0x27
[ 4528.075255]  dm_cache_load_mappings+0x2d0/0x322
[ 4528.075304]  ? clear_discard+0x34/0x34
[ 4528.075348]  cache_preresume+0x108/0x1e3
[ 4528.075395]  dm_table_resume_targets+0x38/0xa9
[ 4528.075443]  __dm_resume+0x33/0x45
[ 4528.075486]  dm_resume+0x8c/0xb1
[ 4528.075529]  dev_suspend+0x173/0x1d8
[ 4528.075573]  ctl_ioctl+0x2a6/0x39d
[ 4528.075617]  ? retrieve_status+0x19e/0x19e
[ 4528.075663]  dm_ctl_ioctl+0x5/0x8
[ 4528.075708]  vfs_ioctl+0x19/0x26
[ 4528.075751]  do_vfs_ioctl+0x52a/0x554
[ 4528.075797]  ? ksys_semctl.constprop.0+0xfe/0x15e
[ 4528.075847]  ? rcu_is_watching+0x5/0x9
[ 4528.075891]  ksys_ioctl+0x37/0x56
[ 4528.075935]  __x64_sys_ioctl+0x11/0x14
[ 4528.075980]  do_syscall_64+0x52/0x60
[ 4528.076027]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 4528.076077] RIP: 0033:0x7f48fac5f617
[ 4528.076121] Code: c0 78 ed 4c 89 e0 5a 5b 41 5c c3 48 8b 05 71 88
0b 00 64 c7 00 26 00 00 00 48 83 c8 ff c3 0f 1f 44 00 00 b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 49 88 0b 00 f7 d8 64 89
01 48
[ 4528.076276] RSP: 002b:00007ffe25fa3298 EFLAGS: 00000206 ORIG_RAX:
0000000000000010
[ 4528.076362] RAX: ffffffffffffffda RBX: 0000556c551c3391 RCX: 00007f48fac5f617
[ 4528.076419] RDX: 0000556c564ff2c0 RSI: 00000000c138fd06 RDI: 0000000000000003
[ 4528.076475] RBP: 0000556c564f3d30 R08: 0000556c552b7a5b R09: 00007ffe25fa30f8
[ 4528.076532] R10: 0000556c552beb30 R11: 0000000000000206 R12: 0000556c564ff2f0
[ 4528.076589] R13: 0000556c564ff2c0 R14: 0000556c564ff370 R15: 0000000000000001
[ 4528.076646] Modules linked in: dm_cache_smq pci_stub nvmet_rdma(O)
bcache celerity16fc_cfg(O) nvmet_fc(O) nvmet(O) qla2xxx(O) nvme_fc(O)
nvme_fabrics(O) bonding ntb_transport ntb_hw_switchtec(O)
cls_switchtec(O) qede qed bna rdmavt(O) ib_umad(O) rdma_ucm(O)
ib_srp(O) rdma_cm(O) iw_cm(O) ib_cm(O) iw_cxgb4(O) iw_cxgb3(O)
ib_qib(O) mlx5_ib(O) mlx5_core(O) mlxdevm(O) pci_hyperv_intf mlxfw(O)
ib_uverbs(O) ib_core(O) auxiliary(O) mlx4_ib(O) ib_mthca(O)
bnxt_en(OE) nvme(O) nvme_core(O) mlx_compat(O) [last unloaded: scst]
[ 4528.077476] ---[ end trace 97c700627c684afd ]---
[ 4528.083087] RIP: 0010:dm_bufio_release+0x19/0x75
[ 4528.083189] Code: fb ff ff 48 89 ef be 01 00 00 00 5d e9 e3 fe ff
ff 41 54 55 4c 8b 67 78 48 89 fd 4c 89 e7 e8 5b cb 26 00 8b 45 50 85
c0 75 02 <0f> 0b ff c8 89 45 50 75 48 31 c9 ba 01 00 00 00 be 03 00 00
00 49
[ 4528.083397] RSP: 0018:ffffc90009f73b78 EFLAGS: 00010246
[ 4528.083499] RAX: 0000000000000000 RBX: ffff88871f1fd340 RCX: 0000000000000007
[ 4528.083608] RDX: ffff888826ed1600 RSI: ffffc90009f73b58 RDI: ffff88880da7e800
[ 4528.083717] RBP: ffff8887482a0150 R08: 0000000000000001 R09: 0000000000037100
[ 4528.083827] R10: 0000000000000000 R11: 0000000000000068 R12: ffff88880da7e800
[ 4528.083936] R13: ffff88871f1fd478 R14: ffff88871f1fd340 R15: 00000000000001fc
[ 4528.084051] FS:  00007f48fab9b2c0(0000) GS:ffff88882b040000(0000)
knlGS:0000000000000000
[ 4528.084194] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4528.084298] CR2: 00007fae36386288 CR3: 0000000721d20000 CR4: 0000000000340ee0
...

The "blocknr" value of "16818504669106333287" caught my eye, as that
number seems way out of bounds for the origin/cache devices in this
setup (the cache LV size in this case is 256 MiB, and the origin
device is less than 500 GiB).

At first I suspected cache device corruption, so I used the PV data
offset + PE segment sizes and offset to extract an image of the cache
LV into a separate file so I can examine it with the cache_* user land
tools, and this is what I see:
[root@fusion-dvt3a ~]# cache_dump /mnt/data/md122_C02_cvol.img
<superblock uuid="" block_size="128" nr_cache_blocks="3968"
policy="mq" hint_width="4">
  <mappings>
    <mapping cache_block="0" origin_block="7325368" dirty="false"/>
    <mapping cache_block="1" origin_block="7325369" dirty="false"/>
    <mapping cache_block="2" origin_block="7325370" dirty="false"/>
    <mapping cache_block="3" origin_block="7325371" dirty="false"/>
    <mapping cache_block="4" origin_block="7325372" dirty="false"/>
    <mapping cache_block="5" origin_block="7325373" dirty="false"/>
    <mapping cache_block="6" origin_block="7325374" dirty="false"/>
    <mapping cache_block="7" origin_block="7325375" dirty="false"/>
    <mapping cache_block="8" origin_block="0" dirty="false"/>
    <mapping cache_block="9" origin_block="7325351" dirty="false"/>
    <mapping cache_block="10" origin_block="1" dirty="false"/>
    <mapping cache_block="11" origin_block="2" dirty="false"/>
    <mapping cache_block="12" origin_block="4" dirty="false"/>
    <mapping cache_block="13" origin_block="8" dirty="false"/>
    <mapping cache_block="14" origin_block="16" dirty="false"/>
    <mapping cache_block="15" origin_block="32" dirty="false"/>
    <mapping cache_block="16" origin_block="64" dirty="false"/>
    <mapping cache_block="17" origin_block="3" dirty="false"/>
    <mapping cache_block="18" origin_block="5" dirty="false"/>
    <mapping cache_block="19" origin_block="6" dirty="false"/>
    <mapping cache_block="20" origin_block="7" dirty="false"/>
    <mapping cache_block="21" origin_block="9" dirty="false"/>
    <mapping cache_block="22" origin_block="10" dirty="false"/>
    <mapping cache_block="23" origin_block="11" dirty="false"/>
    <mapping cache_block="24" origin_block="12" dirty="false"/>
    <mapping cache_block="25" origin_block="13" dirty="false"/>
    <mapping cache_block="26" origin_block="14" dirty="false"/>
    <mapping cache_block="27" origin_block="15" dirty="false"/>
    <mapping cache_block="28" origin_block="7322946" dirty="false"/>
    <mapping cache_block="29" origin_block="7324340" dirty="false"/>
    <mapping cache_block="30" origin_block="7324341" dirty="false"/>
    <mapping cache_block="31" origin_block="7324342" dirty="false"/>
    <mapping cache_block="32" origin_block="7324343" dirty="false"/>
    <mapping cache_block="33" origin_block="7324344" dirty="false"/>
    <mapping cache_block="34" origin_block="7324345" dirty="false"/>
    <mapping cache_block="35" origin_block="7324346" dirty="false"/>
    <mapping cache_block="36" origin_block="7324347" dirty="false"/>
  </mappings>
  <hints>
    <hint cache_block="0" data="PwAAAA=="/>
    <hint cache_block="1" data="PwAAAA=="/>
    <hint cache_block="2" data="PwAAAA=="/>
    <hint cache_block="3" data="PwAAAA=="/>
    <hint cache_block="4" data="PwAAAA=="/>
    <hint cache_block="5" data="PwAAAA=="/>
    <hint cache_block="6" data="PwAAAA=="/>
    <hint cache_block="7" data="PwAAAA=="/>
    <hint cache_block="8" data="PwAAAA=="/>
    <hint cache_block="9" data="PwAAAA=="/>
    <hint cache_block="10" data="PwAAAA=="/>
    <hint cache_block="11" data="PwAAAA=="/>
    <hint cache_block="12" data="PwAAAA=="/>
    <hint cache_block="13" data="PwAAAA=="/>
    <hint cache_block="14" data="PwAAAA=="/>
    <hint cache_block="15" data="PwAAAA=="/>
    <hint cache_block="16" data="PwAAAA=="/>
    <hint cache_block="17" data="PwAAAA=="/>
    <hint cache_block="18" data="PwAAAA=="/>
    <hint cache_block="19" data="PwAAAA=="/>
    <hint cache_block="20" data="PwAAAA=="/>
    <hint cache_block="21" data="AAAAAA=="/>
    <hint cache_block="22" data="AAAAAA=="/>
    <hint cache_block="23" data="AAAAAA=="/>
    <hint cache_block="24" data="AAAAAA=="/>
    <hint cache_block="25" data="AAAAAA=="/>
    <hint cache_block="26" data="AAAAAA=="/>
    <hint cache_block="27" data="AAAAAA=="/>
    <hint cache_block="28" data="AAAAAA=="/>
    <hint cache_block="29" data="AAAAAA=="/>
    <hint cache_block="30" data="AAAAAA=="/>
    <hint cache_block="31" data="AAAAAA=="/>
    <hint cache_block="32" data="AAAAAA=="/>
    <hint cache_block="33" data="AAAAAA=="/>
    <hint cache_block="34" data="AAAAAA=="/>
    <hint cache_block="35" data="AAAAAA=="/>
    <hint cache_block="36" data="AAAAAA=="/>
  </hints>
</superblock>
[root@fusion-dvt3a ~]# cache_check /mnt/data/md122_C02_cvol.img
examining superblock
examining mapping array
examining hint array
examining discard bitset
[root@fusion-dvt3a ~]# echo $?
0
[root@fusion-dvt3a ~]#

Nothing seems out of the ordinary to me, and 'cache_check' doesn't
report any errors/problems with the metadata.

So I then used a "debug" Linux Kernel (same 5.4.190 code) that
contains additional debugging features (full preemption, lock
debugging, etc.). It also has the
CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING feature enabled, which I suspect
might be related to the persistent-data stuff used by dm-cache. And
when I boot this kernel that has the additional debug features, I do
NOT hit the BUG_ON() in dm_bufio_release() and everything works
properly -- the VG/LV's activate just fine and are usable, no kernel
errors / call traces logged.

I switched back and fourth between these two kernels several times,
just to make sure it wasn't a fluke. And indeed, I am unable to hit
this problem with the "debug" kernel.

Based on the experiment between the two kernel configs and the user
land tools not reporting an error, it sounds like my cache metadata is
sound, but hitting some other issue that I don't understand yet.

Wondering if anyone has any tips / guidance on additional debugging I
can do? I plan to circle back and take my original kernel config and
enable CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING to see if that has any
effect.


Thanks for your time.

--Marc

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

