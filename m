Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97AF28F3
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 19:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749669158; cv=none; b=nMHA1Q4ekatTpoPO368rgyWn2tyjfPg9ukPbsCinPo1xGfxSEmo1BHOqA+f2fcSx67nwy75to09Kmyvr/udGyMJYUD2KDkemH+Ut8mvFoMC9JijeF0AgTTlnV/RzaS8kpYPWbk8SXZ7MZI1RDC11YHVBNCKaIUr7ywV8FYS1Evc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749669158; c=relaxed/simple;
	bh=R6nQpxUC8iTAaHjMEAt3vks6hLWK+7dAzhsJBheg5Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KcPSEDeyFNL4qHk/zc94nHOaKZTLqgY29upmQ4p7/TVjGlKAJsV/SyStb4oZM+EtCBm2dhX4wi4MAAwzlC85z2K0y15gzn9zZw8APwHmxQDb7YtI124X7WEoagNdAl4YX3AIUGDss76IrIoF2zz3rYiIdoxpAeK1tHgMUtGiVwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C6B8onmd; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C6B8onmd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749669153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iBPtalwJjC6tVQF+aFrcmmJd6B5gemCqVuYgn94YSaM=;
	b=C6B8onmd1HNbmfw3IM+vKpGFBKYP3xqoX9pwKZ4RWfWSmkB1GrhFviR/ewlMqe4cGj5zPx
	FSKD/DRj2FaE3BzVynS8nQp1UeXHCW6+B1DZUKuOiraYsrFe8aCejNROvGdeqTWOMwyyTX
	98WMCPsI23C0vjOl1ovZtV0YAg7sl7A=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: 
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: [PATCH] dm-flakey: Fix corrupt_bio_byte setup checks
Date: Wed, 11 Jun 2025 15:12:20 -0400
Message-ID: <20250611191221.3011309-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix the error_reads mode - it's incompatible with corrupt_bio_byte, but
that's only enabled if corrupt_bio_byte is nonzero.

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 drivers/md/dm-flakey.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index c711db6f8f5c..cf17fd46e255 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -215,16 +215,19 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	}
 
 	if (test_bit(DROP_WRITES, &fc->flags) &&
-	    (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
+	    ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) ||
+	     fc->random_write_corrupt)) {
 		ti->error = "drop_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
 		return -EINVAL;
 
 	} else if (test_bit(ERROR_WRITES, &fc->flags) &&
-		   (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
+		   ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) ||
+		    fc->random_write_corrupt)) {
 		ti->error = "error_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
 		return -EINVAL;
 	} else if (test_bit(ERROR_READS, &fc->flags) &&
-		   (fc->corrupt_bio_rw == READ || fc->random_read_corrupt)) {
+		   ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == READ) ||
+		    fc->random_read_corrupt)) {
 		ti->error = "error_reads is incompatible with random_read_corrupt or corrupt_bio_byte with the READ flag set";
 		return -EINVAL;
 	}
-- 
2.49.0

