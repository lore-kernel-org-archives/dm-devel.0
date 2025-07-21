Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760EA2E2672;
	Mon, 21 Jul 2025 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118246; cv=none; b=X1shHHkMxppnrcNZFrK6gGwFS5RDmvbIZyVIm3fITQiEFcwYbLjfzr0tGsNdYKA5Pv6RUdADKiMKNCTj+pYRfW//rripYaOR31JyBOs3Bye7xMiGImgDzx7jVCGscvTKQ/QdTYxkWYy3WaEaoq1q/fPFvpTETrKoPGCgnDAftlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118246; c=relaxed/simple;
	bh=ajAayTWum01cgcXuAcNqZFG294/mQHZzth/s8hlinvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cn8fCxD8J5cpbw4si+noYNn1ZuQss6qpd12WMiy6yw6IfPoQ5Derfv571Gg6FwhRVuOEbUeleoaWnuqidHDSKviPDnK+EQaUSaApkntFOZkcoM+B/2/ANSZ3iabRow2x+9We4cuK1ojGtAfYvm6l07m3hD4Xxs/pxvhcEzob5EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rppkkcnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rppkkcnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D70C4AF09;
	Mon, 21 Jul 2025 17:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118246;
	bh=ajAayTWum01cgcXuAcNqZFG294/mQHZzth/s8hlinvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rppkkcnOPNDV9LnIDX4stZKZAO67AuJdSyf9AAgg5j+VxrGLkaqYz+HubFtudo0ST
	 oSvi2hyI03p+cCc1sGWDh8OkvTEF8kCbT2BuSJ/qtU+s4es8aCl9C78zFh2sBIBi8X
	 FsPXAyN7X1xPm2acLm8bf1KwQFA9ZvQhXe9LEK0tr0YAbVby8tkxQ6MVLcgTQtn/db
	 gmQ4Mx7XJvBarzee5TNiRLCrH7bGDJUXLl5Vcx2bfdJ4tCusFAzBDsgk9OWrl0rLPU
	 kU8IV5U3/k1/NXXX7YhyaDxyba6/5eWXoQXqAcC1P5S72qWFNxbQlA5789XSc7Z2vh
	 Zy5U59hM6fLjQ==
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
Subject: [PATCH v4 10/11] md/md-bitmap: make method bitmap_ops->daemon_work optional
Date: Tue, 22 Jul 2025 01:15:56 +0800
Message-ID: <20250721171557.34587-11-yukuai@kernel.org>
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

daemon_work() will be called by daemon thread, on the one hand, daemon
thread doesn't have strict wake-up time; on the other hand, too much
work are put to daemon thread, like handle sync IO, handle failed
or specail normal IO, handle recovery, and so on. Hence daemon thread
may be too busy to clear dirty bits in time.

Make bitmap_ops->daemon_work() optional and following patches will use
separate async work to clear dirty bits for the new bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ab4799e2a0bd..fcb0dfcf1e84 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9887,7 +9887,7 @@ static void unregister_sync_thread(struct mddev *mddev)
  */
 void md_check_recovery(struct mddev *mddev)
 {
-	if (md_bitmap_enabled(mddev, false))
+	if (md_bitmap_enabled(mddev, false) && mddev->bitmap_ops->daemon_work)
 		mddev->bitmap_ops->daemon_work(mddev);
 
 	if (signal_pending(current)) {
-- 
2.43.0

