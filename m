Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794743624;
	b=061nZ7R9vNq/a7hDGiTh3RzdwV84cPQ3xeLYp6cLniAZ4lbMU6959mUyFje08RbY09Uw
	 M+zglg8v0LZOTErz85iZVi/H39lq0eKTrxhvDCjnyodaL/VtVueqJxwjHxpT9qSqC01xd
	 pURHMf8cfgoFdxAw6yt/CwNKFCy8Nw/TVyTc7FSw/xUqjRIznVZruw9POK+fcndHnzOxs
	 gHCZX/OdeNGqprY6+3otOedRPJ5Y5toKd+eUGLp4Q5WI3DcI5SEsu0z5D9fgUsmtQ0U7c
	 agyjsINL1igZ5AdHV6Okbia9Ovo6DyhdnW4Ip27j8vvxWIbaM/jUu2pUP18k75eM/0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794743624;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YGMB3+NAm4faRx3w9bRJYMM7s3usV8RgkqrWV3C0ORE=;
	b=apBDBOvLp3CWc1xJCtZ8avSeVBLsRFe8258EN1EgOQFzR5aMq2wpINv2PYDCvn2NAso2
	 jy6+gGaUU4BSmOgwwLq0lea3WrNm3dvqyiS+CsY8xVaMl4+QgjT31t0flSpuH8gMGOKvl
	 BegtIeLaFJrFGDiUB0Wg1aC9vJqZh7gZZoZ4rionwCHfteJ8nvtFFYDJIHAvVdxrVYPaS
	 Le0Ukgm4sJpNXxsnA4BQRJFBbpuh4qFxmQuFWPQ15T1vk9J6iZNR8QCwjkwY2rdCeFXpW
	 jeM2hxGGvwuXUVmNZD23MtIZMpxPD5INO/PUvPFyvQ5qwaTWQC8PRwGIQQ6JlIA0xhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=wpJiP0GN;
	arc=none smtp.remote-ip=111.22.67.135
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C4E606A31F
	for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 11:53:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18C4E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=wpJiP0GN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=wpJiP0GN3jLBmlTcUZD3LD5SCO1hflf7q7lFMOnYS42wHZ3ijoTwGMmhh//zxt7DloaaZuB/6llgY
	 ht4pQcV+wsNj4RJ9MP5nePL87VbM3OSS49VXV2rmK1TGSB/qMH9mYZuJdea2X/j7UqA/PAqZER8WMa
	 dQfOk3DBxSbpvF5c=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76af99d3b693-f721d;
	Sun, 15 Nov 2026 19:53:32 +0800 (CST)
X-RM-TRANSID:2ee76af99d3b693-f721d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86af99d39d8a-63c14;
	Sun, 15 Nov 2026 19:53:32 +0800 (CST)
X-RM-TRANSID:2ee86af99d39d8a-63c14
From: Aibing Chen <chenaibing@cmss.chinamobile.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dm-integrity: initialize free_sectors when the superblock changes on resume
Date: Sun, 15 Nov 2026 19:53:29 +0800
Message-ID: <20261115115329.1174-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
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

fc79aeb86a2c ("dm-integrity: validate the superblock on resume") made
dm_integrity_resume() jump to skip_writes when the on-disk superblock was
modified while the device was suspended.  That path skips
replay_journal(), so the journal accounting variables stay
zero-initialized: free_sectors is 0 while journal_sections and
journal_section_entries are nonzero.

A later suspend or flush queues integrity_commit(), which calls
pad_uncommitted() in journal mode.  Its invariant

  journal_sections * journal_section_entries ==
  (n_uncommitted_sections + n_committed_sections) *
  journal_section_entries + free_sectors

no longer holds because the right-hand side evaluates to 0, and WARN_ON
fires.

Restore free_sectors on that error path, as replay_journal() does for the
normal resume.  The section counters are already zero and nothing will be
committed, since the device is marked failed.

Reported-by: syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=94dac3c75477e184f0b0
Fixes: fc79aeb86a2c ("dm-integrity: validate the superblock on resume")
Cc: stable@vger.kernel.org
Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>
---
 drivers/md/dm-integrity.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 802b37761..6ab305b60 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3915,6 +3915,13 @@ static void dm_integrity_resume(struct dm_target *ti)
 		memcpy(ic->sb, ic->sb_copy, sizeof(struct superblock));
 		DMERR("The superblock was changed while the device was suspended");
 		dm_integrity_io_error(ic, "superblock check", -EINVAL);
+		/*
+		 * replay_journal() is skipped below, so the journal accounting stays
+		 * zero-initialized and pad_uncommitted() would trigger its WARN_ON.
+		 * Restore the free sector count; the section counters are already zero
+		 * and nothing is committed because the device is marked failed.
+		 */
+		ic->free_sectors = ic->journal_entries;
 		goto skip_writes;
 	}
 


