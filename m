Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B8C5E3AF;
	Fri, 22 Mar 2024 19:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711135440; cv=none; b=dXBJ3cHYY+2jONnOccEMLSD84QHnjngkm/2ELBkAyTkJyumfAsoS9b7lrwbUiLIVgRmIGMdlMgGiWkXFTlmUQfBuGxaUlnBndfHKbhRBw3LzlYB8xViszArtfseJcOolOPI2qNuiTuTe2THUOX0GQTr0OI+4ozfgnIDT+aD5fRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711135440; c=relaxed/simple;
	bh=k68BpI/MEpbovSzGndHFuCvGg3ihxx+4I3gS6dx47Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mS6cnyQjQfGBBY5HEQYF2gAt+FxpTFjHwEIrHBT+gRq4G6NcdF5ti3K0dfA1fsurY1tcdOKKUu3W2RTnFA7ywuDBeD5dY+OG0S4eehN/mM8EWhObUGOzh4xbOrwIRf1gLuA+S9gUb2xOBUGNhPE4KzM00flG7W+HFhq+wnm9Tmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E61aGRoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E61aGRoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D917C433F1;
	Fri, 22 Mar 2024 19:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711135440;
	bh=k68BpI/MEpbovSzGndHFuCvGg3ihxx+4I3gS6dx47Ig=;
	h=From:To:Cc:Subject:Date:From;
	b=E61aGRoRUv0nt9ornTh0Z2cnicquXqxKnlNdjLpeoWUd6h2T5xBeNbSWEvVOHxDOR
	 sA9Q6c7oF3RgyeEXj8c5Hsk7oDIAFd6pqriWhy+FO+g2xE++sA2m3KctMbp5MV6OpZ
	 mLQmQJshyYverT1vDJfvybS04klq9hBARjbGlcMO6S2MnITiyG2Wt5wI6MKUIKBfqK
	 W1RY+e1i6gJxBfWI4ETS9lETrdLJQYgJOLBr5BnLfPMsh43qLQvemZb6q3jjIyLuR2
	 6qmAvRAZK6YM9lrNDBbFCHo/QILkBvBIMJuw5gIRc6pEhUkAS8iOJwnxzbnUrpI9ef
	 F/VK8b3b2uxCw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ming.lei@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm raid: fix false positive for requeue needed during reshape" has been added to the 5.15-stable tree
Date: Fri, 22 Mar 2024 14:32:39 -0400
Message-ID: <20240322183239.129687-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm raid: fix false positive for requeue needed during reshape

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-false-positive-for-requeue-needed-during.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit c95f5ce2313f166d6711075b8e1c8d19e32f7d9d
Author: Ming Lei <ming.lei@redhat.com>
Date:   Mon Mar 11 13:42:55 2024 -0400

    dm raid: fix false positive for requeue needed during reshape
    
    [ Upstream commit b25b8f4b8ecef0f48c05f0c3572daeabefe16526 ]
    
    An empty flush doesn't have a payload, so it should never be looked at
    when considering to possibly requeue a bio for the case when a reshape
    is in progress.
    
    Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
    Reported-by: Patrick Plenefisch <simonpatp@gmail.com>
    Signed-off-by: Ming Lei <ming.lei@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8d489933d5792..04769fb20cf7f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3329,14 +3329,14 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
 	struct mddev *mddev = &rs->md;
 
 	/*
-	 * If we're reshaping to add disk(s)), ti->len and
+	 * If we're reshaping to add disk(s), ti->len and
 	 * mddev->array_sectors will differ during the process
 	 * (ti->len > mddev->array_sectors), so we have to requeue
 	 * bios with addresses > mddev->array_sectors here or
 	 * there will occur accesses past EOD of the component
 	 * data images thus erroring the raid set.
 	 */
-	if (unlikely(bio_end_sector(bio) > mddev->array_sectors))
+	if (unlikely(bio_has_data(bio) && bio_end_sector(bio) > mddev->array_sectors))
 		return DM_MAPIO_REQUEUE;
 
 	md_handle_request(mddev, bio);
