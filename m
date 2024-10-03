Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF6C17BBF;
	Thu,  3 Oct 2024 01:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918177; cv=none; b=B/14Kr9ghnKg8r8o0oLhjH8xtPm7zF6cmm7XNyHDelrcrHgZeJKQeZkoDb00YELFJ9N6QCOfzYyXgZs7fULgbzl3OVLj41J/4ohiZwh1Wm0B9MRczPBr6aT34djuhj5FCvnSN4DmOQr0pDlwGkhggEcK0SUOzfTbbQXye5SeUZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918177; c=relaxed/simple;
	bh=JRC906exSE9WB+qYkiBV4/PRS03ooo6xcMkMgYsjK/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCsYNRQ6bGtoRvY6dSac9nToKUSr/ZqvFJK70W01LcpczTqQ4IBxVmw9+5GbbNYygR/dI/3VLtAgRq7zHZ13Y0lmqb7zLnGz0I5Yd/rCSXwwo/0rhaY/Ww9tfAeY//DDZboVLtpkDeO4SuJzJknbKIr8O3XoG9fuy2qmwkW+/vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=TUavmXh3; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="TUavmXh3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=Xf623GrtvbUSnaBJBS1171I3r1qDM08Bu2TkB7MDTSE=; b=TUavmXh34z0zrjDs
	4cfzYhRq19BmQfINPpax0gYvN2rbI4v23Fcfl6fsfadsE5Yac5H34UOoXnTiQhM8XLnTx02ryeMdq
	ZEhtOOerz8pCdTfPTBj4wMRkvCNp4A5yvzJa7pA42wygfjDQAIHNK7RF+hzWxja7NBwU+E6tbpvPf
	4fj1yPvIR6+d1twhanLDHbO1nDw837w6T0a3HMPcW+/ztQxPMoJM6aP/uyk/3KvKjCXOLT6hO4mhT
	RIspBR6R16OadclTVpgyOw8wy7eGzJ29XtjVnJphKvKbfuF02wC/US3xT+EpMNreCNm74lkImjA00
	/HL6ewudxBFKkMIzdg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARv-008Zju-0Y;
	Thu, 03 Oct 2024 01:16:11 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 5/9] dm: Remove unused dm_set_md_type
Date: Thu,  3 Oct 2024 02:15:50 +0100
Message-ID: <20241003011554.266654-6-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241003011554.266654-1-linux@treblig.org>
References: <20241003011554.266654-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

dm_set_md_type() has been unused since commit
ba30585936b0 ("dm: move setting md->type into dm_setup_md_queue")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm.c | 6 ------
 drivers/md/dm.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ff4a6b570b76..6630e89cea4a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2515,12 +2515,6 @@ void dm_unlock_md_type(struct mapped_device *md)
 	mutex_unlock(&md->type_lock);
 }
 
-void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type)
-{
-	BUG_ON(!mutex_is_locked(&md->type_lock));
-	md->type = type;
-}
-
 enum dm_queue_mode dm_get_md_type(struct mapped_device *md)
 {
 	return md->type;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 8ad782249af8..d4062c3154db 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -76,7 +76,6 @@ bool dm_table_request_based(struct dm_table *t);
 
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
-void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
 enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
 
-- 
2.46.2

