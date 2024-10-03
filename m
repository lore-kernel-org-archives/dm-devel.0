Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F58E4437C;
	Thu,  3 Oct 2024 01:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918182; cv=none; b=KuNZD8RufjKc8haoZ5nj64sWJDpSc0JIKxpK15ecXrI1Wf1gfLSxdReRRU3F14EoW7WpvobfdNPc4HZSQkxacGyqdVGoELQ95p2OsPQTB3aCc/ISNVV4GAsGexRtH+qM1Ecstc060mV8/qzcIX3KIS7gS/3zs2iYokzxZisSMus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918182; c=relaxed/simple;
	bh=O4wWmZOmnQDTIfnLRfHJgK8ZZRDyEqiBvAdnnVSOIGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCmbbjb38cEMtRB9p5F0mIBcS/bJ8SKDwhNBaj7QkKEXjO6vvSBuLRYZwAy69IaubhZDvhtg1/LiqtZ9QD/PAtBZPNlUSKHVgso0aKnfYJOgLTsw6vAjZ8pTsXiAOSFZ1bDgomdA2HF95FdGwzt/C3kLCMQL+waTks1QLacaI+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Pi1PpPM1; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Pi1PpPM1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=3EfSajfBqzhPSYPG8IWTbiTKuq4G6Jjw1zAYEzHhRaA=; b=Pi1PpPM13tT6rRms
	+7ZGRvhuo4Hj5xfN2K4pqiNs5eMfleMJQ0jnqppUGnX6ZpaSwr+2KreOnsDLsPVpSB2AwGxc1WO9t
	G5X8VGY2pTxCGJs6flRcySbO6wLGbjb8qEe/RVPP/HpEiSDnOibemZRUz8WkJaXTYog4MZ5wZ7afQ
	HCO7o0kjv1KkJzIBR/NBUqquCfT4S3xL6chOQRLwr32hxZKaqKDs5zWZd11fgcf2m2rpC7nZ9ShFG
	mz4bRUFsSmbjzn64MxRzH8QQV89LKMoP2WsJIxNvsdTNdjGcpj/c8aFTB6hwLBovMfMTB3iBUxt6G
	sCK6WUaLtuVY/x3J8A==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARs-008Zju-2W;
	Thu, 03 Oct 2024 01:16:08 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 1/9] dm cache: Remove unused btracker_nr_writebacks_queued
Date: Thu,  3 Oct 2024 02:15:46 +0100
Message-ID: <20241003011554.266654-2-linux@treblig.org>
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

btracker_nr_writebacks_queued() has been unused since commit
2e63309507c8 ("dm cache policy smq: don't do any writebacks unless IDLE")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-cache-background-tracker.c | 6 ------
 drivers/md/dm-cache-background-tracker.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/md/dm-cache-background-tracker.c b/drivers/md/dm-cache-background-tracker.c
index 9c5308298cf1..504299bb7310 100644
--- a/drivers/md/dm-cache-background-tracker.c
+++ b/drivers/md/dm-cache-background-tracker.c
@@ -156,12 +156,6 @@ static void update_stats(struct background_tracker *b, struct policy_work *w, in
 	}
 }
 
-unsigned int btracker_nr_writebacks_queued(struct background_tracker *b)
-{
-	return atomic_read(&b->pending_writebacks);
-}
-EXPORT_SYMBOL_GPL(btracker_nr_writebacks_queued);
-
 unsigned int btracker_nr_demotions_queued(struct background_tracker *b)
 {
 	return atomic_read(&b->pending_demotes);
diff --git a/drivers/md/dm-cache-background-tracker.h b/drivers/md/dm-cache-background-tracker.h
index 5b8f5c667b81..7e66ad58efa6 100644
--- a/drivers/md/dm-cache-background-tracker.h
+++ b/drivers/md/dm-cache-background-tracker.h
@@ -42,7 +42,6 @@ struct background_tracker *btracker_create(unsigned int max_work);
  */
 void btracker_destroy(struct background_tracker *b);
 
-unsigned int btracker_nr_writebacks_queued(struct background_tracker *b);
 unsigned int btracker_nr_demotions_queued(struct background_tracker *b);
 
 /*
-- 
2.46.2

