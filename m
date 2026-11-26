Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795681985;
	b=llNOR16XmRwSVqXHJexMU2eccUYhQKX/89hWUI8b/kj0v2SohSmQuZqxp6FzH1mHGypN
	 aGuwTJ/TxqEwME732Jpktes5E/3KtyevSBqKnJqFqzU+lmhfGRxLxri+bx0BpVROgk+7O
	 8DbFXUBKwj9S9jEuVSFPPMtR5pOkPEcE4mevJlUDErHxNh+CpD5LhfbP0t1gcqKRaZmXx
	 OOjJfdA3o9F4yHGSjsSiTwbva832lw2GUhOXrgLShZQ5CLGUj1C98XSE3RHWAdtW27kjy
	 +B/YgCHui32rLRdqMt3xZNk+C1MgbiIkA65f+b4FIG9kgRGXLAiK7upEH25HKbE66ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795681985;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=yFQEW7MnH3mO6LqMiEtMUpMW9Wm06bwcuYfptwoXb2M=;
	b=3FlnbLVw3pOnMqHccDUnsxxH2aN/q730BYpug/43Yq1T6Wa/AWN1Vl7MjcIC9ZnUQn9o
	 tpYUDvUJ3NhOySk/cKqMDfaCHkW/yA9izgY6Q8LjnUC6RwfrsLPiIiqbeY4wv2BG0WgjG
	 vJyVkO9E5oyWNNsA5YY/z1/+aPBDcGCd7h4ZoTSXUyNC1FS3ZYG8SwJLyPcq94SzhH8Mn
	 O33GBF8/Zo3rvHSjVulIo9B8o8FKLyfmTqb5pJsHVAEhvDY4tAN6a7XpG8IoiwhIiomY4
	 mv3CwEqQ18/1DnLaQy8AEIDsw2LEe3/sn1OyMQUASKMT9ve8hh6FnBppbwhOZGZAnMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=SfQWGKon;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD764606A31E
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 08:33:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD764606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=SfQWGKon
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=yF
	QEW7MnH3mO6LqMiEtMUpMW9Wm06bwcuYfptwoXb2M=; b=SfQWGKonm+eKHCaR4w
	rACPgbPBDtTGv22lMMzqv+Qp+UwpJOoHaVngt+fWxjhKa13LbsmbEB9vXB/y5Vlq
	GVni4p277k5+NnIGSO3ddOEcbK3xrjceltjRsgmlTZXtWI+9Iu/7Ix7AjcV+ti+A
	tzpzke9O6tlkOs4Lm3L3oOH3Y=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3_72N7gdr0m+nLA--.38709S2;
	Thu, 26 Nov 2026 16:32:13 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+a53c2918175b36cfd601@syzkaller.appspotmail.com,
	liyouhong@kylinos.cn
Subject: [PATCH v7 0/2] md: fix sync_work vs array teardown races
Date: Thu, 26 Nov 2026 16:32:08 +0800
Message-Id: <20261126083210.210866-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_72N7gdr0m+nLA--.38709S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZF15AF4xZryfJr43CFyUZFb_yoW5AFW5pr
	WYqry5Gr4Dt34xZFsrK3W0va4rAw1rX398Xr1fGw1fC3yrAr1UXFW8K3Wj9FyDuFyrA34k
	Za1UJFZaka4qvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjNtsUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+Q57KmsH7o6+kAAA3E

From: Li Youhong <liyouhong@kylinos.cn>

dm-raid tears down arrays via md_stop(), which cleared mddev->pers
without waiting for previously queued sync_work. That work could
then call remove_spares() with pers == NULL, or keep using mddev
after raid_dtr() frees it.

do_md_stop()/md_stop_writes() already call stop_sync_thread() before
teardown. md_stop() needs the same wait, plus a few related holes
around work_busy(), MD_RECOVERY_FROZEN on the read-only path, and
event_work on the raid_ctr() error path.

This series splits the previous combined fix so the work_pending ->
work_busy change can land on its own.

Li Youhong (2):
  md: use work_busy() to flush sync_work in stop_sync_thread()
  md: fix sync_work vs array teardown races

 drivers/md/dm-raid.c |  7 +++++++
 drivers/md/md.c      | 39 +++++++++++++++++++++++++++++----------
 2 files changed, 36 insertions(+), 10 deletions(-)

---
v7:
- Resend v6; the previous v6 mails were not posted as one continuous
  dependent series. Please ignore that v6 and use this one instead.
- No code change since v6.
- v6: https://lore.kernel.org/linux-raid/20261126080821.144057-1-dayou5941@163.com/

v6:
- Split into two patches per review:
  1/2: only replace work_pending() with work_busy() when flushing
       sync_work in stop_sync_thread(); Fixes: f52f5c71f3d4.
  2/2: remaining changes (md_stop wait, idle early-return gated by
       work_busy(), INTR only when RUNNING, RO FROZEN check,
       flush event_work on raid_ctr() error path).
- Keep if (work_busy()) flush_work() in 2/2; do not turn it into an
  unconditional flush (that would make 1/2 pointless).
- v5: https://lore.kernel.org/linux-raid/20261112013523.120428-1-dayou5941@163.com/

v5:
- Restore idle early-return in stop_sync_thread() gated by work_busy(),
  so locked callers keep reconfig_mutex and do not race with do_md_run().
- Flush event_work before raid_set_free() on the raid_ctr error path
  (md_stop() may drop the mutex and let md_reap queue it).
- v4: https://lore.kernel.org/linux-raid/20261111015027.4029184-1-dayou5941@163.com

v4:
- Always flush_work(&sync_work) in stop_sync_thread(); do not delay
  clearing MD_RECOVERY_RUNNING (that can drop MD_RECOVERY_NEEDED via
  md_check_recovery, and does not cover the successful sync_thread
  registration path).
- v3: https://lore.kernel.org/linux-raid/20261110063045.912703-1-dayou5941@163.com

v3:
- Honour MD_RECOVERY_FROZEN before queueing sync_work on the
  read-only md_check_recovery() path.
- (superseded) delayed MD_RECOVERY_RUNNING clear on not_running.
- v2: https://lore.kernel.org/linux-raid/20261109023055.2164333-1-dayou5941@163.com

v2:
- Drop the pers NULL check in md_start_sync().
- Call stop_sync_thread() from md_stop() before clearing pers,
  matching do_md_stop()/md_stop_writes().
- v1: https://lore.kernel.org/linux-raid/20261106083543.249267-1-dayou5941@163.com

