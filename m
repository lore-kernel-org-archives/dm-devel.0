Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2188C28691;
	Sun,  8 Dec 2024 22:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733698706; cv=none; b=H0fojRxsaIWEze9BPL366irlLotN6+XKZHWgDRXRQU73kzuEmz7zN1jksIJ9aVvlKEp8TZm8fAPP+Zl0eruIv9wMiJLq/3UFZqyMpcZb5f9/BZw1cidKJpnEf2wZXLUI6+Yp4R4dRUGYOLVjoz7eQsTrmcEIUr02TBUTJmz35o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733698706; c=relaxed/simple;
	bh=wZBrbIYegrSFuSGYBJZyXvrCOOml4B0ujsdF5S6ivd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGKQciJOcYkQoPLHmTzrj20mI2QFGsFqLN6IBD85b7mXQQjJilS6MZgfg5tSf5YP+me3cwWXCNxbwiAgH0KUyr4bku0nM8nkk9fGX6VE0/+S+F3TJ1wrj1+0INgqmNMx8ZF1IcuRcuSr1nbaJPNTwm35h5gm+q9GOuUQt0WShqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXam0PZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXam0PZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BB3C4CED2;
	Sun,  8 Dec 2024 22:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733698705;
	bh=wZBrbIYegrSFuSGYBJZyXvrCOOml4B0ujsdF5S6ivd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXam0PZrjNXFbAQuNpxzs8XbxVDdyNfK5PpjdXP03qz9lvSWsSV15ZtYaQjfx3J40
	 WHrb+jwB8IKI/2HEiHhiqAGPjjvfBSYecKhdRKrlaCcPDGqBhHaMNXcatEmTT2RrNJ
	 Trvz2ggd/ButHFrKv3T7GPjmmNdmWkZ/OAO8DxwFHyuSYLXqZ6XHnRoGmuFv3A2rVI
	 YtYyKZyK9Pnqthawj0xXNz9HfdpJesAc0LkHHTmXqQGBQhNekFr4kZoYwcJ/Pzysjy
	 uz6VqFgTURrUXiPhnNOipiWZthE4vdUTbRX1wLhykLvt8TWMRC6qn8djC2/A4VjSpX
	 nlNlxzLPSjtQw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 2/4] block: Ignore REQ_NOWAIT for zone reset and zone finish operations
Date: Mon,  9 Dec 2024 07:57:56 +0900
Message-ID: <20241208225758.219228-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241208225758.219228-1-dlemoal@kernel.org>
References: <20241208225758.219228-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are currently any issuer of REQ_OP_ZONE_RESET and
REQ_OP_ZONE_FINISH operations that set REQ_NOWAIT. However, as we cannot
handle this flag correctly due to the potential request allocation
failure that may happen in blk_mq_submit_bio() after blk_zone_plug_bio()
has handled the zone write plug write pointer updates for the targeted
zones, modify blk_zone_wplug_handle_reset_or_finish() to warn if this
flag is set and ignore it.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7982b9494d63..ee9c67121c6c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -707,6 +707,15 @@ static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
 		return true;
 	}
 
+	/*
+	 * No-wait reset or finish BIOs do not make much sense as the callers
+	 * issue these as blocking operations in most cases. To avoid issues
+	 * the BIO execution potentially failing with BLK_STS_AGAIN, warn about
+	 * REQ_NOWAIT being set and ignore that flag.
+	 */
+	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT))
+		bio->bi_opf &= ~REQ_NOWAIT;
+
 	/*
 	 * If we have a zone write plug, set its write pointer offset to 0
 	 * (reset case) or to the zone size (finish case). This will abort all
-- 
2.47.1

