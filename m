Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D144A10940;
	Thu,  3 Oct 2024 01:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918179; cv=none; b=qy6tz309rkMrly4fSTMDsaVpeZ4jkX27gdweBFGegy9vE6A9mcmuSfXRm/HmWfpW11Etje/B4n6aLY/Ee0tNLiLMZ/DNxpHZuqYqd4GjOklxNl++GfHTmgv7IuACMoW6oVvvhwgJiDUcEaPPlVBRVvJ/aZA6WLhVr/3Y5j224pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918179; c=relaxed/simple;
	bh=qYM7kw7E6NnGTdVJpMSnkfoBcFLwnnbnKBFmv331Qzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RR1it4yXrFRmb9OBuiRVHjLGoYF+Kd6bG/+E/3e8spe/QtRoUxD9k8qbLNxSlu4+Mnf6ic3j5f4li3bU3MiREztnZIInaHLCcbUI4LmEGKjTjeF8qI60NoKB6z70Wn+3Pj7RLXt3DtkUYdREpHm+eo050vjjBdIxEnyr4Qc/J0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ZPT7KupU; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ZPT7KupU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=GM9PtILR3a+Jl7Go3vn6KDGhUKYvUmZxnnhAKHmPXaQ=; b=ZPT7KupU3hTz5tCE
	RiCmYIO3rmPD9kcQWHrMbwKdmOsnehNDb6+frm1cqbWR+w3am//FB8pX39sUcDrHrFYndOn0/alHG
	KgPtMYFjBYiXMPjxel1BAmvR4v2/8I+SSN1N+KQYIJWhDkGF9A6WhnDg1c8l6kz/8OHJJoB49deDy
	Ie5ikZNtVkO+1Kr4LUEAgAAjI1ZiHwOc7wXWRkDFPcMAifXmiIjAtyC5OOsVTaAhNEZkVRRYxIDhC
	HXDJUn+fqRRWNS0L+6+cj92i2Vuxmyuj9fCWd3dN+XuUmst8zPpSUwF628mG7k8LvwT+K5NRZQRRV
	av4mmr1l/in/uh9ZFw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARw-008Zju-31;
	Thu, 03 Oct 2024 01:16:13 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 8/9] dm vdo: Remove unused functions
Date: Thu,  3 Oct 2024 02:15:53 +0100
Message-ID: <20241003011554.266654-9-linux@treblig.org>
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

get_data_vio_pool_active_discards()
get_data_vio_pool_discard_limit()
get_data_vio_pool_maximum_discards()
set_data_vio_pool_discard_limit()

are all unused since commit
a9da0fb6d8c6 ("dm vdo: remove all sysfs interfaces")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-vdo/data-vio.c | 29 -----------------------------
 drivers/md/dm-vdo/data-vio.h |  5 -----
 2 files changed, 34 deletions(-)

diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 0d502f6a86ad..2b489e37538e 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -1074,35 +1074,6 @@ void dump_data_vio_pool(struct data_vio_pool *pool, bool dump_vios)
 	spin_unlock(&pool->lock);
 }
 
-data_vio_count_t get_data_vio_pool_active_discards(struct data_vio_pool *pool)
-{
-	return READ_ONCE(pool->discard_limiter.busy);
-}
-
-data_vio_count_t get_data_vio_pool_discard_limit(struct data_vio_pool *pool)
-{
-	return READ_ONCE(pool->discard_limiter.limit);
-}
-
-data_vio_count_t get_data_vio_pool_maximum_discards(struct data_vio_pool *pool)
-{
-	return READ_ONCE(pool->discard_limiter.max_busy);
-}
-
-int set_data_vio_pool_discard_limit(struct data_vio_pool *pool, data_vio_count_t limit)
-{
-	if (get_data_vio_pool_request_limit(pool) < limit) {
-		// The discard limit may not be higher than the data_vio limit.
-		return -EINVAL;
-	}
-
-	spin_lock(&pool->lock);
-	pool->discard_limiter.limit = limit;
-	spin_unlock(&pool->lock);
-
-	return VDO_SUCCESS;
-}
-
 data_vio_count_t get_data_vio_pool_active_requests(struct data_vio_pool *pool)
 {
 	return READ_ONCE(pool->limiter.busy);
diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
index 25926b6cd98b..067b983bb291 100644
--- a/drivers/md/dm-vdo/data-vio.h
+++ b/drivers/md/dm-vdo/data-vio.h
@@ -336,11 +336,6 @@ void drain_data_vio_pool(struct data_vio_pool *pool, struct vdo_completion *comp
 void resume_data_vio_pool(struct data_vio_pool *pool, struct vdo_completion *completion);
 
 void dump_data_vio_pool(struct data_vio_pool *pool, bool dump_vios);
-data_vio_count_t get_data_vio_pool_active_discards(struct data_vio_pool *pool);
-data_vio_count_t get_data_vio_pool_discard_limit(struct data_vio_pool *pool);
-data_vio_count_t get_data_vio_pool_maximum_discards(struct data_vio_pool *pool);
-int __must_check set_data_vio_pool_discard_limit(struct data_vio_pool *pool,
-						 data_vio_count_t limit);
 data_vio_count_t get_data_vio_pool_active_requests(struct data_vio_pool *pool);
 data_vio_count_t get_data_vio_pool_request_limit(struct data_vio_pool *pool);
 data_vio_count_t get_data_vio_pool_maximum_requests(struct data_vio_pool *pool);
-- 
2.46.2

