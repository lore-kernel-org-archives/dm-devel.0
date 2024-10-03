Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D542617C77;
	Thu,  3 Oct 2024 01:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918178; cv=none; b=kNtmBtBFD7HK49kH5Pw3cEybzjVjGZi5fQaYaqQssOmz2OLCJ+IKlVo7vQq5FS/C0DtxNGNgCKCeeeaXT91ueg7Yowglio6iKPfDc4cFnpcllXFI98SLmx/1GRTOWgc7GKYU6ayo63AExVq+V5AaqQWStnxxgXEGyhJ0PYqwWUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918178; c=relaxed/simple;
	bh=5vYfkV/BEoRV+gZGk8qqcYOUr6IAnwQOVC6W2k3CjD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6a64yikvgCml3Z+mctOYKTYDH9cPlbQwVIsBxBPe/AmR3WoMZX/qV5XZXBaQDDgikNLXEorN4H0E4PUq+8RvNz0tjijmAdxSOwlUhtrMJeiOEZD2PdQ1yZyDmnC1SrujkvZJnAa1H78vSU5FG1mGLoOi3PB9BysGMpRP3JjT0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=VKZjdCB5; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="VKZjdCB5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=nf46B3GWSY0de6DHLWA9w92fJi3N5OrQUGfozYC/6Zg=; b=VKZjdCB5hyXyjFer
	zdG7BQmw3y16CovNJEqWcegBri9tFagJ1P4D5haEz/vSrjifHX3CroBi34VNnw2wWwqLppb5Oxr+3
	u3dMJgwWxirXnCfdYgfrXQXJU3cn+gd6TX9f7/peLRCDQODJZt0Tli8zzTjl6/H3XHWPpBDqC6UUH
	roikSU+t85W8nPfFOVk4lhJMbURpjSv1aZBZvIfKe6NkCuoQiG5Z4fmKEcHi9x7zSea9PDRwobS/1
	Q5+7NScWf7WVs0sEhvE5VMchyO13pR/Tk0E7/KMrJpNENseka8iZcL1e6DAy8sk5vaTIwHyb/v8wC
	IUzAHUVBf1UfUQSfnA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARv-008Zju-2M;
	Thu, 03 Oct 2024 01:16:11 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 6/9] dm: Remove unused dm_table_bio_based
Date: Thu,  3 Oct 2024 02:15:51 +0100
Message-ID: <20241003011554.266654-7-linux@treblig.org>
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

dm_table_bio_based() is unused since commit
29dec90a0f1d ("dm: fix bio_set allocation")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-table.c | 5 -----
 drivers/md/dm.h       | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index dbd39b9722b9..bd8b796ae683 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1033,11 +1033,6 @@ struct dm_target *dm_table_get_wildcard_target(struct dm_table *t)
 	return NULL;
 }
 
-bool dm_table_bio_based(struct dm_table *t)
-{
-	return __table_type_bio_based(dm_table_get_type(t));
-}
-
 bool dm_table_request_based(struct dm_table *t)
 {
 	return __table_type_request_based(dm_table_get_type(t));
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index d4062c3154db..a0a8ff119815 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -71,7 +71,6 @@ enum dm_queue_mode dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
-bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 
 void dm_lock_md_type(struct mapped_device *md);
-- 
2.46.2

