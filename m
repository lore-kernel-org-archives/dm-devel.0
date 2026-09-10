Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1850B41D228
	for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 08:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027884; cv=none; b=Qe93onhxBGyEJIzLEFGmU6/1iEbKGFmV86s3auJzSgdH2fT5rmotctsRFD0ZOP3MHnJJQ7V6cIsFzuOFKmUVMXukOnGHF62XGwRE2X+zUybD2DSQH8yAj9WcHbK6/WV7vwOyadioLptvMHbcjdCFHj9EACot4w4fqQ7sVhCu9Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027884; c=relaxed/simple;
	bh=gne6jQ1eDgyN6cYZe+ZWpX+VwTcHT+2IRfoXziUB8N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXkyuEcVGuDmFryZiJgbPLaWvHGaDaKeu5XKNcTBzichyLV+qJ7VQAKdPCvF41hYlb3GUvO55wllObs/nLvqTVE590R5KAmBiSOPwda+eCcV1FZNqenJOUC9asyHoIHfBxvZ7y8N4aPaSSB1Zq7NN/l5RPmM3o/TQ7eSzJjb/Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=MQbhyWHC; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="MQbhyWHC"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1331ce1bso1756945e9.3
        for <dm-devel@lists.linux.dev>; Thu, 10 Sep 2026 01:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027879; x=1789632679; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OA45OxGe2lbIuXbjnmED/p8Au3ms9csyQD/sDFCo9UY=;
        b=MQbhyWHCfgII44DGqqsxk4wtDp5+NFHU1NKWnZ37YWe1HhdUdbJARxREfB8Ik2LiJQ
         WcG4bS3tOcPC921duDHzrpu9K19Bk4hnlD5f60DjttsJMRiTp3DmtzIz6Cc5MT2McAEQ
         7Om7OeaIGF4pVgXCy9BznwAck/pXjJEfzEc889jcvhRFkoXdUnUQfAx4AgbyCbMABfHh
         7DZ5D1jJuttr1DMPqMl3YNlPiSe1oXtKjFFhVBLz7VovS+xRFKxuqdMpucstTJsl9qfW
         JfyZwMQ+42Zy88XGQBQXrOPlyVPIQ5ZdAuQEfykGoX1854CYyFesJRXM7Y/YlWTS6osx
         6vgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027879; x=1789632679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OA45OxGe2lbIuXbjnmED/p8Au3ms9csyQD/sDFCo9UY=;
        b=LZG57vr5eN/WliSLyNJWQO1vAD5R9GfZ13oO4Kt8LbshXW4Yf/nAHhpE7UhqHjMFLL
         8DVfCeXpjUJ1PHDZ/huQT5Oe1pcttokrQXvh1Ec8TJNmBr9nJFChWDWvniNX38qUi6yy
         7ukslSZciC67XOH4ahHEt3yHNZa08he04ptFxZs14EWUXQPVsPKjIbmLXa7juE/Credi
         +lCYa8lmQprkuGueq4HrY2dbIF7GAw04s9JvZYYloxqKJOHNQUfSaX9UGe/NzzzNnkjG
         cGerh9Z62KNiGBxPX98nNIOVez6XaacjaJ9IMuG4YZh7U0UX/X2WrOLh54DQ5eKUBXXj
         HIew==
X-Forwarded-Encrypted: i=1; AKwUvByoBIe/iWSWs3zOx3yzXKH4p9kjArYga9gtB+uqJBWa+DQGxCfp+6qL4NazJ7+B7Rkz+3iIl8GDnA==@lists.linux.dev
X-Gm-Message-State: AFuF++mvjx+bg6TddogBotm5AFDlRLFnBc0WEkO+6dS3FyfymWqN1Yo7
	YpXfnkuvxj58A/gCukviuzHYzyVG6tf6Uau8vyAs1josJLzXBaDJ0iBRtQWz3dDkYrc=
X-Gm-Gg: AYBFou1buxg0EDBIkOdOD6ceegIiMRdcmFs75aBg+P4zqxQRrH1zv6tDZry4mLn1seV
	7UoPbsnXapjES+IP6LciHFtu7yqV3xYP9sw2F2ssWKYXVPNqzh90HNAyreJ/45rrgYJ9yjFNEeZ
	Mv3sYOukKSdgG9hsSEpOjwhc19pIPSGn7sffqI9DuYX9wRw6u48kdlOMbT9DCwSlx2jgVPxB4mm
	e+2uoUhUvcql6QmEGNCMh1GgsXUp9bZCOppPhlTlA+rZ8OI1WfTUtCgFMOaL07WgAi8Qp7IGY+E
	njrcMUxIjrU+sUgNqBHByHT4JKxolvT5YukSvWBL9DJGY4n+bu0Y6SLpRS3JMEc954wrCgEnnXA
	X2ToLazYVhjwrTo4hE39A5vLx6zAZZ/rskEoP3I5+ue9KZYqzEmFy1oUODF0ko61zUh+wBGa6hM
	1kkEQ9gKDq9RRvC/fQEc5hPd2Mne9O8H9pWdqA94QI4dhdjmsN7t97ZMxZqjiisIaVXXBIxJRMj
	mvGljjjTwtuyX7rzqqQJ3O7ZEAduOwiUaP8fheKZx6s
X-Received: by 2002:a05:600c:c494:b0:49b:916a:e553 with SMTP id 5b1f17b1804b1-49d010c2a57mr296627915e9.0.1789027879077;
        Thu, 10 Sep 2026 01:11:19 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:18 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 2/8] md: don't wait for q->limits_lock in check_sb_changes()
Date: Thu, 10 Sep 2026 10:11:07 +0200
Message-ID: <20260910081114.1605746-3-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

check_sb_changes() activates a spare another node added, reached from
md_reload_sb() -> process_metadata_update() with reconfig_mutex held.
Stacking the device's limits there waits for q->limits_lock under that
mutex, which deadlocks: the lock's holder waits for the queue to drain,
and that I/O can be waiting for a superblock update needing
reconfig_mutex.

The device is already a member, so its limits are stacked.  Add it with
MDDEV_STACK_SKIP and leave them alone.

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 28fc903ffeea..e60dc2c7eb90 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10885,7 +10885,14 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 					rdev2->saved_raid_disk = -1;
 				else
 					rdev2->saved_raid_disk = role;
-				ret = remove_and_add_spares(mddev, rdev2, NULL);
+				/*
+				 * reconfig_mutex is held, so q->limits_lock
+				 * cannot be taken here.  The device is
+				 * already a member, its limits are stacked,
+				 * so add it without touching them.
+				 */
+				ret = remove_and_add_spares(mddev, rdev2,
+							    MDDEV_STACK_SKIP);
 				pr_info("Activated spare: %pg\n",
 					rdev2->bdev);
 				/* wakeup mddev->thread here, so array could
-- 
2.43.0

