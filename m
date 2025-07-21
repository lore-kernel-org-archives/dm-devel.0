Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CAD2E4247;
	Mon, 21 Jul 2025 17:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118214; cv=none; b=g+ZWFksau7VyWp3kYHnWeJJfaS0QRMEDcNTGQT3Aoa1HOr7gC6AYian/7qvn0vPX0rMfZizc8PFMgM+yvVL3TWfMRjLXOo8RfQgDJ7hiog+r+k9qkLVrC3+807b/p7X3yEfIcLlvhC78c30ZulR4OgGFXe1UFRrRhwwGScf8BP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118214; c=relaxed/simple;
	bh=bldMJTlCsnXoowEEa4KU487uxcc+Jw3sbPNMts+Ydjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDuEtRSz/2iO5/IMRBhybF7CPz4dm29xW1EmiR7cEq/1tT9yWRrHl6rSNf1zFFu6Zsf9YnHqE78V/cc9kJYWaFS50c6lucws/v1jtKwvfFhkHjlhxEXHZdU3CEJP+axJ+cm6f2Ix6X2iilfPonz20UeFto7vdAFCCfQr5xNDL/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IlnhgqLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IlnhgqLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBFCC4CEF9;
	Mon, 21 Jul 2025 17:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753118214;
	bh=bldMJTlCsnXoowEEa4KU487uxcc+Jw3sbPNMts+Ydjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlnhgqLatgHUb+IQs6bqZcJizj/P7jEf6V8xlAxWuxUx51jY7sYS0qWLM+hvDKxHO
	 qTv00oUk/a6LOsR7XuZcyz2t0oKkYmbNnpRZ58yypq+qclfTbsz+C52SbjuqsArwoi
	 eiLEJ4KxpdHzHfelDCjPlH3PFzERlvXavKu3DzEWSkRXXwLsgkpWoesYpyAJMspbQ4
	 XSrcNbfI0zaEUR02uuBbugR6G7Hht3bKkGvyVzIdFdcCQrni66tkPdipRc0LprNDAf
	 jK/f0WP+ibIgIa3ydPLRK4GYxNtEZivF6K28eXw/jweMTFX/JHpyOOvMJgqP1SUfRA
	 UOvxvzoONUJtQ==
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
Subject: [PATCH v4 04/11] md: add a new mddev field 'bitmap_id'
Date: Tue, 22 Jul 2025 01:15:50 +0800
Message-ID: <20250721171557.34587-5-yukuai@kernel.org>
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

Prepare to store the bitmap id selected by user, also refactor
mddev_set_bitmap_ops a bit in case the value is invalid.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 37 +++++++++++++++++++++++++++++++------
 drivers/md/md.h |  2 ++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index efb38b9cfbd0..c0499bd8a2aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -669,13 +669,33 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
-static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
+static bool mddev_set_bitmap_ops(struct mddev *mddev)
 {
+	struct md_submodule_head *head;
+
+	if (mddev->bitmap_id == ID_BITMAP_NONE)
+		return true;
+
 	xa_lock(&md_submodule);
-	mddev->bitmap_ops = xa_load(&md_submodule, id);
+	head = xa_load(&md_submodule, mddev->bitmap_id);
+
+	if (!head) {
+		pr_warn("md: can't find bitmap id %d\n", mddev->bitmap_id);
+		goto err;
+	}
+
+	if (head->type != MD_BITMAP) {
+		pr_warn("md: invalid bitmap id %d\n", mddev->bitmap_id);
+		goto err;
+	}
+
+	mddev->bitmap_ops = (void *)head;
 	xa_unlock(&md_submodule);
-	if (!mddev->bitmap_ops)
-		pr_warn_once("md: can't find bitmap id %d\n", id);
+	return true;
+
+err:
+	xa_unlock(&md_submodule);
+	return false;
 }
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
@@ -685,8 +705,13 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
 
 int mddev_init(struct mddev *mddev)
 {
-	/* TODO: support more versions */
-	mddev_set_bitmap_ops(mddev, ID_BITMAP);
+	if (!IS_ENABLED(CONFIG_MD_BITMAP)) {
+		mddev->bitmap_id = ID_BITMAP_NONE;
+	} else {
+		mddev->bitmap_id = ID_BITMAP;
+		if (!mddev_set_bitmap_ops(mddev))
+			return -EINVAL;
+	}
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8452aaa2295d..ed23215c880a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -40,6 +40,7 @@ enum md_submodule_id {
 	ID_CLUSTER,
 	ID_BITMAP,
 	ID_LLBITMAP,	/* TODO */
+	ID_BITMAP_NONE,
 };
 
 struct md_submodule_head {
@@ -565,6 +566,7 @@ struct mddev {
 	struct percpu_ref		writes_pending;
 	int				sync_checkers;	/* # of threads checking writes_pending */
 
+	enum md_submodule_id		bitmap_id;
 	void				*bitmap; /* the bitmap for the device */
 	struct bitmap_operations	*bitmap_ops;
 	struct {
-- 
2.43.0

