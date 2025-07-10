Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3DEDDC1
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 06:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752130182; cv=none; b=o0Se1ftzyjJWNO+V9uatvWahdvVu4G5hrVHwK4wr0ZN1Sbt2iela0K/9WNEZnrL85HU3PkdFy9L2MA/N/vVtNmCDC6FCkyTeUpDZthh57CWwRMdQ1c+53nf2E0WS/grlai4hoOGbgx7+w1HI9xVEWpoOf3TNJU9TWffAWPd4TmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752130182; c=relaxed/simple;
	bh=ulx9d/DQxHSq8yBMGJGZdqGJWjD6S0fWVX3xk0ZLWtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hq2dRD/HE2/knbqfAxuYTu/nqavtCW15WOmSVvlQnuMAJM0H+vl7XTE2R1W5t45PEy8vdUFvceWnNO22kBrIkOnPXQg0lCNOuaknOD+si5cN/sGaDY7ol6Jmtqwr5+mdCmKeN0buaZEMIKhd24pIKRaL4lUzqg9OAkY/b09rViQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X1k21mkv; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X1k21mkv"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-234bfe37cccso6829885ad.0
        for <dm-devel@lists.linux.dev>; Wed, 09 Jul 2025 23:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752130180; x=1752734980; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=htp01S+n+HVlXHdLt7skX8tLW/BOHq74J5Zg1sPnI7E=;
        b=X1k21mkvY3CVs5WoJwTnfIjqEoS56mPNhMOA2JJTcsqpaGLbKFip1rXsoILBSYD3tc
         MmfeXLr9Gxdoirp1VL/uTxYOvcIS/nvK/Ju85qr5pOIXS7kWfTAvNTboN+/CymvvN0Lb
         z6kEFWwRz/4fAM6zmPC4ADyr29JdbSw3HCgSucCsIYQ0JTK5aVFZzM4a8baEogWmhcJ0
         b2CTT0VSYUYwz3p8qelZGSFbPbBxoMY0xI6w8KtoAmAClnTGHCXC6vQ54Um0JxNneT1K
         oPvsTNxxAp0js1rIUPpHmDOtgZ2allTrJt9dfHT42dDY12HJakkPSBPQX4Je9M8KEaxO
         A0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752130180; x=1752734980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=htp01S+n+HVlXHdLt7skX8tLW/BOHq74J5Zg1sPnI7E=;
        b=u54DFkRTQvPvJVSfIJH1whv8YYKbHbTz2l9GmwG54OO/vhJ5KQqmHKvSy42fjZFK7v
         UfRG/lWYdmmSQa8R3E31BkNFtY5r4U8uSQRd8Htg+2hy7ja1OlfIYJTqZtfikppk8Od3
         sO4ipZX1VV6bscUT6m0OJiYqy+bx52VTY9d2QXk6kKg4YtoqRLL5hiSg0vXyJjnzMPQF
         J2J/mSAj/0VOvCloZZYGS5GD0n48eRLZ41WQBy9YXQ73ZpFdGorWSqPIwO//RV+3JVnd
         2Mj1z/5tP9QEYCRd+ZtHZ1hEnmqUspt85itL4KUppO35hZE58nW8Nrt942S4P/IMJ6R5
         bhsw==
X-Gm-Message-State: AOJu0Yx14KWRxXEeHSqZVaAYV4n83Wva//2FBO1833u/taTu8kSQ5Dt9
	5jCb98PyRfOYFIXSxtKakb0C8Uz/c9yfZn4ktdcKaqdfvFKfY+5WF7AC
X-Gm-Gg: ASbGnctplwPYpdcwabBAg4E3m5QTDD0PpbeYhRcFPhzuMfEPH8CtdLD52w0GKYo057N
	d9z7BNaWxBx9TLJs6HTngEogmEFvk/n62wRD9lsV0NW6MGyfljJhpKM+0u9ACbeX3uybKImT5v8
	QtoOD/TsS4KilufOPMH1NgZaoZEKsPm5PUy3N2akdMBvuyOE2wt1UyhvFrxHv9WP6z3f2pH5I6v
	o2oodnL68Nwkxq8Rs/phfkX7ClRxxHl4PUpw4pnh0D+NiuvLsC/t8fGwyidQF7EbxnZAG3xDx2p
	dyUmKGYzXvu/wAfVz+9Ai39KorCFbAUmzFM+McHgaKKAcikzpUEUqy/lX+FwtetiZVoR
X-Google-Smtp-Source: AGHT+IG6FYSsMU+7D5SufVGwPjK3najFyZaIrgv4/68hzwkgjCm49UP5b+rx+iASgM46KJQUZtmzUg==
X-Received: by 2002:a17:903:b50:b0:234:8c64:7878 with SMTP id d9443c01a7336-23de24331b6mr36245885ad.11.1752130180057;
        Wed, 09 Jul 2025 23:49:40 -0700 (PDT)
Received: from PC.mioffice.cn ([43.224.245.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4359ddcsm10809255ad.207.2025.07.09.23.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 23:49:39 -0700 (PDT)
From: Sheng Yong <shengyong2021@gmail.com>
X-Google-Original-From: Sheng Yong <shengyong1@xiaomi.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	nhuck@google.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	shengyong2021@gmail.com,
	Sheng Yong <shengyong1@xiaomi.com>,
	Wang Shuai <wangshuai12@xiaomi.com>
Subject: [PATCH] dm-bufio: fix sched in atomic context
Date: Thu, 10 Jul 2025 14:48:55 +0800
Message-ID: <20250710064855.239572-1-shengyong1@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sheng Yong <shengyong1@xiaomi.com>

If "try_verify_in_tasklet" is set for dm-verity, DM_BUFIO_CLIENT_NO_SLEEP
is enabled for dm-bufio. However, when bufio tries to evict buffers, there
is a chance to trigger scheduling in spin_lock_bh, the following warning
is hit:

BUG: sleeping function called from invalid context at drivers/md/dm-bufio.c:2745
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 123, name: kworker/2:2
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
4 locks held by kworker/2:2/123:
 #0: ffff88800a2d1548 ((wq_completion)dm_bufio_cache){....}-{0:0}, at: process_one_work+0xe46/0x1970
 #1: ffffc90000d97d20 ((work_completion)(&dm_bufio_replacement_work)){....}-{0:0}, at: process_one_work+0x763/0x1970
 #2: ffffffff8555b528 (dm_bufio_clients_lock){....}-{3:3}, at: do_global_cleanup+0x1ce/0x710
 #3: ffff88801d5820b8 (&c->spinlock){....}-{2:2}, at: do_global_cleanup+0x2a5/0x710
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 2 UID: 0 PID: 123 Comm: kworker/2:2 Not tainted 6.16.0-rc3-g90548c634bd0 #305 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
Workqueue: dm_bufio_cache do_global_cleanup
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 __might_resched+0x360/0x4e0
 do_global_cleanup+0x2f5/0x710
 process_one_work+0x7db/0x1970
 worker_thread+0x518/0xea0
 kthread+0x359/0x690
 ret_from_fork+0xf3/0x1b0
 ret_from_fork_asm+0x1a/0x30
 </TASK>

That can be reproduced by:

  veritysetup format --data-block-size=4096 --hash-block-size=4096 /dev/vda /dev/vdb
  SIZE=$(blockdev --getsz /dev/vda)
  dmsetup create myverity -r --table "0 $SIZE verity 1 /dev/vda /dev/vdb 4096 4096 <data_blocks> 1 sha256 <root_hash> <salt> 1 try_verify_in_tasklet"
  mount /dev/dm-0 /mnt -o ro
  echo 102400 > /sys/module/dm_bufio/parameters/max_cache_size_bytes
  [read files in /mnt]

Fixes: 5721d4e5a9cd ("dm verity: Add optional "try_verify_in_tasklet" feature")
Signed-off-by: Wang Shuai <wangshuai12@xiaomi.com>
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
---
 drivers/md/dm-bufio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index ec84ba5e93e5..caf6ae9a8b52 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2742,7 +2742,9 @@ static unsigned long __evict_a_few(unsigned long nr_buffers)
 		__make_buffer_clean(b);
 		__free_buffer_wake(b);
 
+		dm_bufio_unlock(c);
 		cond_resched();
+		dm_bufio_lock(c);
 	}
 
 	dm_bufio_unlock(c);
-- 
2.43.0

