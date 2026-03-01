Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FF19CD19;
	Sun,  1 Mar 2026 02:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330417; cv=none; b=KkqbEWjNHur63HsZNVriOlM0Muu9d/+pRKMIG5XdEh3exJwwH2sBmZl4gId1xIzg64HXoMtOT304k7LouUxosqFGuA65We7xO6KUmSBiqpoauYScRX7QY/VTN30BsZerpcOfqbN6CcCYY0zDuL71k7zqwmatqwF092IJzWOmpkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330417; c=relaxed/simple;
	bh=CAqfdvGTsAeA/zXlRzNkFlP0fHkN5zOVayou3z5MjIg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YSkAdi7/SDT/UAXQjw5PM4Tsx4mfxEWzfxFXn1k083U6Zgm8TCi47hRqR90CwqYinrcnecrZteVcC0vzouTn7zkXuXRA91TBXeoKbNMp1mDs9YUJN5TAJ609g59GGFncDGck4VK0SkGDySUAhFO1TCGO0SsuNhTRELpFtFjJTqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9ptrlGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9ptrlGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC865C19421;
	Sun,  1 Mar 2026 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330417;
	bh=CAqfdvGTsAeA/zXlRzNkFlP0fHkN5zOVayou3z5MjIg=;
	h=From:To:Cc:Subject:Date:From;
	b=l9ptrlGkPTzuw1bbM9jdZre+93IJofTc9wvwRl9r18QZ5gwclUAYmRG2dZt7VOUj9
	 O642U2kPAXE104cTujEtC0FxzBbi2rtixYfuM5iAlsshhyVOaYBGZ0rj7d4AIjXzPx
	 7yZmqm7woMe3jwjtYZXiyFcOd/G8/445hKrR9JbcPLjJiDQsQQLqzXJxBJUR341FhV
	 zf/qmB5z5D1gj2cDr+gGV3wWWbKZZ0jV40oBNtw/3ajyytY7iMJN+r5wi/KXjxldmy
	 bbcnzst2CplBIEXRkP7rp48sJtkJuIa7rdbiFBv/tuVJQZsjTfrVIGzumjJcguK26Y
	 4wQBwKp1aFyuQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	mliang@purestorage.com
Cc: Mohamed Khalfella <mkhalfella@purestorage.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm: clear cloned request bio pointer when last clone bio completes" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:00:15 -0500
Message-ID: <20260301020015.1726261-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From fb8a6c18fb9a6561f7a15b58b272442b77a242dd Mon Sep 17 00:00:00 2001
From: Michael Liang <mliang@purestorage.com>
Date: Fri, 9 Jan 2026 15:52:54 -0700
Subject: [PATCH] dm: clear cloned request bio pointer when last clone bio
 completes

Stale rq->bio values have been observed to cause double-initialization of
cloned bios in request-based device-mapper targets, leading to
use-after-free and double-free scenarios.

One such case occurs when using dm-multipath on top of a PCIe NVMe
namespace, where cloned request bios are freed during
blk_complete_request(), but rq->bio is left intact. Subsequent clone
teardown then attempts to free the same bios again via
blk_rq_unprep_clone().

The resulting double-free path looks like:

  nvme_pci_complete_batch()
    nvme_complete_batch()
      blk_mq_end_request_batch()
        blk_complete_request()        // called on a DM clone request
          bio_endio()                 // first free of all clone bios
          ...
        rq->end_io()                  // end_clone_request()
          dm_complete_request(tio->orig)
            dm_softirq_done()
              dm_done()
                dm_end_request()
                  blk_rq_unprep_clone()  // second free of clone bios

Fix this by clearing the clone request's bio pointer when the last cloned
bio completes, ensuring that later teardown paths do not attempt to free
already-released bios.

Signed-off-by: Michael Liang <mliang@purestorage.com>
Reviewed-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-rq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 5e08546696145..923252fb57aec 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -109,14 +109,21 @@ static void end_clone_bio(struct bio *clone)
 	 */
 	tio->completed += nr_bytes;
 
+	if (!is_last)
+		return;
+	/*
+	 * At this moment we know this is the last bio of the cloned request,
+	 * and all cloned bios have been released, so reset the clone request's
+	 * bio pointer to avoid double free.
+	 */
+	tio->clone->bio = NULL;
+ exit:
 	/*
 	 * Update the original request.
 	 * Do not use blk_mq_end_request() here, because it may complete
 	 * the original request before the clone, and break the ordering.
 	 */
-	if (is_last)
- exit:
-		blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
+	blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
 }
 
 static struct dm_rq_target_io *tio_from_request(struct request *rq)
-- 
2.51.0




