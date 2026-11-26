Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795681965;
	b=yP4CLJsgdrc5iohF/mOrYTH1/BabHzgpOKcWhHkxCzGcY+q3zc/VS4CEk5fyV4DOyyWq
	 CETShSEjErI7JNHJAPy4sqaYEIJlxn5vSHVo7CtE29kca0a5CrUk+5nc6oWYrFvk0OiRI
	 aCUK2XA59o8in2V+I/uBXc+NWQqJGnUPPPyFku3Uwao1O/1KsOpnIy3WhvJKTbmj1Ouu+
	 m3kvwqHxqQWjjJw6SR9xKBgeoq0gpCGGL+KVj3HlDhAXBeVUxPMa4INEvZuzEoQNQXNpI
	 zI6mUd9gcq4P9fFVEglESuR4zCGBvgDYY4H/QClqURqttO+ePz3Q5uCIzY8tOtFb8lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795681965;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=CVPnZRSCWOQxsvGWQVXg1N1wwt11N5KB5w/geIRGCyM=;
	b=mqN8ytuH50mreJ5lSNePKG2YJrGk31tsD5C864uLpnZ3wrL3gv70eeRmoStY8cgSELIt
	 +YnA7n6pqRIXdrNCmpbvqgA7sGgPCAtGCg6+ZQ7x3/4wxd1t0V7WectdtjODy8ubWQWF3
	 kt0HSjooprkQLDpfWE8y72z/W+D1eS3KJekE7FMlvADlKtj0BRXYP/8GsP+lRh3RcroN5
	 4Bs89xow9Qp8/PjWbAkt6ZGJhpcU2737Qu3D45NXFsOK54PRErtVJ/FI1d0D6usfgIdou
	 +g+Di0hvdTyQNKJI1Il8/Xl//uEoLmh9PRq+AFzQkXBHvTxqJ4ofwV/9B5AsPfeaggA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=BxlfYtwY;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE95606A327
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 08:32:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAE95606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=BxlfYtwY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=CV
	PnZRSCWOQxsvGWQVXg1N1wwt11N5KB5w/geIRGCyM=; b=BxlfYtwYZHssk8y/r5
	wANDT8vMT4ubKdZsZ7FzjdSsiZtDoZuMmPAIOCCrn0yHWvi6qDmj0/NjR1HPwZlo
	W0rI3GdPVGJq+cK21pHrTmQ1ha5Vf2/L8YIjOp0MbZGQoC30E/W+JecPTek0mfls
	Ghihdxp8dJWuquRaRxZmk+Gcg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3_72N7gdr0m+nLA--.38709S3;
	Thu, 26 Nov 2026 16:32:15 +0800 (CST)
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
	liyouhong@kylinos.cn,
	stable@vger.kernel.org
Subject: [PATCH v7 1/2] md: use work_busy() to flush sync_work in stop_sync_thread()
Date: Thu, 26 Nov 2026 16:32:09 +0800
Message-Id: <20261126083210.210866-2-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261126083210.210866-1-dayou5941@163.com>
References: <20261126083210.210866-1-dayou5941@163.com>
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
X-CM-TRANSID:_____wD3_72N7gdr0m+nLA--.38709S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFy5Ww47Gry5WryxJw18Zrb_yoWfuwcE9F
	W5Xry7Gry7Kr1rJF1rZwn7ZrWrtrnIgw1DWF1IyFW2kryUZr1jvFs8CwnIvwnava97Ww4a
	9rWDCa4IywsxujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbApnPUUUUU==
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+Q97KmsH7o++qwAA3-

From: Li Youhong <liyouhong@kylinos.cn>

stop_sync_thread() only flushes sync_work when work_pending() is true.
Once the work is running, PENDING is cleared, so an in-flight
md_start_sync() can be missed and teardown can race with it.

Use work_busy() instead, so both queued and executing sync_work are
flushed.

Fixes: db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
Cc: stable@vger.kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..1974943bf746 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5213,7 +5213,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 	 * never happen
 	 */
 	md_wakeup_thread_directly(&mddev->sync_thread);
-	if (work_pending(&mddev->sync_work))
+	if (work_busy(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
 	wait_event(resync_wait,

