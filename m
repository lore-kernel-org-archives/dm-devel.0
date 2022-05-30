Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E2CC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 30 May 2022 02:51:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-m6kTGWeJOCKDF6lNBeVc3w-1; Sun, 29 May 2022 22:51:45 -0400
X-MC-Unique: m6kTGWeJOCKDF6lNBeVc3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E1E8380114B;
	Mon, 30 May 2022 02:51:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C3A192166B26;
	Mon, 30 May 2022 02:51:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 82F3C1969F56;
	Mon, 30 May 2022 02:51:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5B35F1967DD9
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 May 2022 02:51:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12AA01678F; Mon, 30 May 2022 02:51:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E99A63F54
 for <dm-devel@redhat.com>; Mon, 30 May 2022 02:51:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E29FB380114A
 for <dm-devel@redhat.com>; Mon, 30 May 2022 02:51:38 +0000 (UTC)
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au
 [211.29.132.246]) by relay.mimecast.com with ESMTP id
 us-mta-581-YIUQtWWkOC622R9Q-hXI9Q-1; Sun, 29 May 2022 22:51:36 -0400
X-MC-Unique: YIUQtWWkOC622R9Q-hXI9Q-1
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au
 [49.181.2.147])
 by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id ED80E5344A1;
 Mon, 30 May 2022 12:51:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
 (envelope-from <david@fromorbit.com>)
 id 1nvVVE-000RjI-N7; Mon, 30 May 2022 12:51:32 +1000
Date: Mon, 30 May 2022 12:51:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: dm-devel@redhat.com
Message-ID: <20220530025132.GZ1098723@dread.disaster.area>
MIME-Version: 1.0
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62943136
 a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
 a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
 a=ZAX-dNdWjI7dJ8YbOg8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [BUG 5.19-rc0] dm: BIOSET_PERCPU_CACHE breaks dm-error
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
Cc: Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


fstests generic/250 dies tearing down a dm-error device like so:

[ 3287.076109] general protection fault, probably for non-canonical address 0xdead000000000122: 0000 [#1] PREEMPT SMP
[ 3287.080726] CPU: 3 PID: 1146698 Comm: dmsetup Not tainted 5.18.0-dgc+ #1260
[ 3287.083703] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[ 3287.087308] RIP: 0010:__cpuhp_state_remove_instance+0xf3/0x1a0
[ 3287.089821] Code: d8 8f 82 42 3b 1c 20 7f d9 48 89 e9 31 d2 89 de 89 7c 24 04 e8 2e fd ff ff 8b 7c 24 04 eb c3 48 8b 45 00 48 8b 557
[ 3287.097662] RSP: 0018:ffffc900037b3cb8 EFLAGS: 00010286
[ 3287.099860] RAX: dead000000000100 RBX: 0000000000000017 RCX: ffff88811157a780
[ 3287.102797] RDX: dead000000000122 RSI: 000000000000011b RDI: ffffffff827fb91d
[ 3287.105648] RBP: ffff888105c72510 R08: 0000000000000001 R09: ffffffff81859800
[ 3287.108391] R10: ffff888020d8c900 R11: ffff88813bdab6f0 R12: 0000000000000000
[ 3287.111192] R13: ffffffff82a8cab8 R14: ffff8881117eb800 R15: ffffc900037b3d90
[ 3287.113916] FS:  00007f10f28e0c40(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
[ 3287.116905] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3287.118925] CR2: 00007f10f2b0550e CR3: 000000011b634000 CR4: 00000000000006e0
[ 3287.121480] Call Trace:
[ 3287.122368]  <TASK>
[ 3287.123170]  bioset_exit+0x28/0x170
[ 3287.124495]  cleanup_mapped_device+0x32/0x130
[ 3287.125870]  __dm_destroy+0x160/0x200
[ 3287.127059]  ? table_clear+0xb0/0xb0
[ 3287.128249]  dev_remove+0xd3/0x110
[ 3287.129365]  ctl_ioctl+0x1d6/0x410
[ 3287.130394]  dm_ctl_ioctl+0xa/0x10
[ 3287.131420]  __x64_sys_ioctl+0x7f/0xb0
[ 3287.132541]  do_syscall_64+0x35/0x80
[ 3287.133568]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 3287.134996] RIP: 0033:0x7f10f2c2c397
[ 3287.136052] Code: 3c 1c e8 1c ff ff ff 85 c0 79 87 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 b8 10 008
[ 3287.141271] RSP: 002b:00007ffc165d3ca8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[ 3287.143314] RAX: ffffffffffffffda RBX: 00007f10f2d22a8e RCX: 00007f10f2c2c397
[ 3287.145224] RDX: 0000558ef56f3b50 RSI: 00000000c138fd04 RDI: 0000000000000003
[ 3287.147140] RBP: 00007ffc165d3d60 R08: 00007f10f2d72558 R09: 00007ffc165d3b10
[ 3287.149074] R10: 00007f10f2d718a2 R11: 0000000000000202 R12: 00007f10f2d718a2
[ 3287.150996] R13: 00007f10f2d718a2 R14: 00007f10f2d718a2 R15: 00007f10f2d718a2
[ 3287.152929]  </TASK>
[ 3287.153544] Modules linked in:
[ 3287.154488] ---[ end trace 0000000000000000 ]---
[ 3287.154491] RIP: 0010:__cpuhp_state_remove_instance+0xf3/0x1a0
[ 3287.154496] Code: d8 8f 82 42 3b 1c 20 7f d9 48 89 e9 31 d2 89 de 89 7c 24 04 e8 2e fd ff ff 8b 7c 24 04 eb c3 48 8b 45 00 48 8b 557
[ 3287.154498] RSP: 0018:ffffc900037b3cb8 EFLAGS: 00010286
[ 3287.154500] RAX: dead000000000100 RBX: 0000000000000017 RCX: ffff88811157a780
[ 3287.154501] RDX: dead000000000122 RSI: 000000000000011b RDI: ffffffff827fb91d
[ 3287.154503] RBP: ffff888105c72510 R08: 0000000000000001 R09: ffffffff81859800
[ 3287.154504] R10: ffff888020d8c900 R11: ffff88813bdab6f0 R12: 0000000000000000
[ 3287.154505] R13: ffffffff82a8cab8 R14: ffff8881117eb800 R15: ffffc900037b3d90
[ 3287.154507] FS:  00007f10f28e0c40(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
[ 3287.154512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3287.154513] CR2: 00007f10f2b0550e CR3: 000000011b634000 CR4: 00000000000006e0

Looks like polled bioset optimisations are the cause. Disabling the
change made in cfc97abcbe0b ("dm: conditionally enable
BIOSET_PERCPU_CACHE for dm_io bioset") as per the hack below makes
the regression go away.

-Dave.

---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a37c7b763643..c5a8862462c4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1027,7 +1027,7 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 			per_io_data_size = max(per_io_data_size, ti->per_io_data_size);
 			min_pool_size = max(min_pool_size, ti->num_flush_bios);
 		}
-		poll_supported = !!dm_table_supports_poll(t);
+		//poll_supported = !!dm_table_supports_poll(t);
 	}
 
 	t->mempools = dm_alloc_md_mempools(md, type, per_io_data_size, min_pool_size,
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

