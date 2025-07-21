Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E042E1C56;
	Mon, 21 Jul 2025 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118241; cv=none; b=PBfOOJGcl30Ki2ShwC7cHj0Y/6Tac7X8YdWM69Y2ezZkzB2KENFGQ/qGqNzMQvYJ89SvrxwFYhPBjhvjy5o+BryS1kgMLM73v5t9KfgtrlxfMLOH7kJ9cFhp8+3Bqzs4nGyf9noAdotzHiX/szJlUCmQPpROMJ1vhn5/73WS7wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118241; c=relaxed/simple;
	bh=v95Zan5wYQtgaPNu8SwZncwgwlsgp7xhkg1+GyvUjuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbrkAsky7Z9QtzQ0NmOymdbKXwxN/dOSt97F22dZdwz32VpZGMa2h6wN2jQ9XBtUVglHHAGeXOOPrdoK+dLOIrmRTHzeXCKg63cflqP+z5oULLsLWLy+STGwaTAgvJsozZdjIa3xo2b5ff0mtrfDhoqY4ZYx5v6Kyc93J9uqZUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MK7AI/dL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MK7AI/dL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41417C4CEF4;
	Mon, 21 Jul 2025 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118241;
	bh=v95Zan5wYQtgaPNu8SwZncwgwlsgp7xhkg1+GyvUjuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MK7AI/dLiiQZNx+Ggr0628RoSrkiL18jG0fHgacent6pRD17hOI9y/+gJwYLhAlqJ
	 JAGU5ZorcgPr6jHk4sdFWFoLohRTm8B5z2ARYWpVtXJttcW3jBIKEkuL6TIVu/WTBZ
	 3lBX+lZeDHtY2zYHHGROrbdBoK3kcyirknKtZxnUxByjgdySApfit4JiSTcP9Sdk4V
	 Rm1rCErXGE3vbmtlaI3Vx0v531EIjl6TbteDMVaRK6vogg1mGtfdefmoeNiu1o4dPC
	 b7mvv0eKF9rSNNIYGCEJcsf7DE8GaX9UnBga2yJluiyvmSKoiwT/cpHG687MWT28I8
	 VUMxClDj6WQiQ==
From: Yu Kuai <yukuai@kernel.org>
To: corbet@lwn.net,
	agk@redhat.co,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	hch@lst.de,
	song@kernel.org,
	hare@suse.de
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v4 09/11] md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
Date: Tue, 22 Jul 2025 01:15:55 +0800
Message-ID: <20250721171557.34587-10-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
References: <20250721171557.34587-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

This flag is used by llbitmap in later patches to skip raid456 initial
recover and delay building initial xor data to first write.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 12 +++++++++++-
 drivers/md/md.h |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 71f39f9ce9ca..ab4799e2a0bd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9166,6 +9166,14 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 				start = rdev->recovery_offset;
 		rcu_read_unlock();
 
+		/*
+		 * If there are no spares, and raid456 lazy initial recover is
+		 * requested.
+		 */
+		if (test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery) &&
+		    start == MaxSector)
+			start = 0;
+
 		/* If there is a bitmap, we need to make sure all
 		 * writes that started before we added a spare
 		 * complete before we start doing a recovery.
@@ -9723,6 +9731,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	if (mddev->recovery_cp < MaxSector) {
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+		clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
 		return true;
 	}
 
@@ -9732,7 +9741,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	 * re-add.
 	 */
 	*spares = remove_and_add_spares(mddev, NULL);
-	if (*spares) {
+	if (*spares || test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery)) {
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
@@ -10055,6 +10064,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
 	/*
 	 * We call mddev->cluster_ops->update_size here because sync_size could
 	 * be changed by md_update_sb, and MD_RECOVERY_RESHAPE is cleared,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ed23215c880a..ea8dc5810f24 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -667,6 +667,8 @@ enum recovery_flags {
 	MD_RECOVERY_RESHAPE,
 	/* remote node is running resync thread */
 	MD_RESYNCING_REMOTE,
+	/* raid456 lazy initial recover */
+	MD_RECOVERY_LAZY_RECOVER,
 };
 
 enum md_ro_state {
-- 
2.43.0

