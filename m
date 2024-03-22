Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC107D3E1;
	Fri, 22 Mar 2024 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711136656; cv=none; b=anchEVcnrk23SiBGqpMKZ0CGhUnvEgQPXjlmpk0WB/riF3BHe+CuE1k2EOQ5+6pYNWqf76nzCKZQb6lgbUnSUtLOQaxKtQreQA2K+IgTXEP5dCsJn4l2Q+u3NT62AFJF6hSs0K0B6RToS1zLkDClwBO69WTLctDxkikcI2lfiuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711136656; c=relaxed/simple;
	bh=8u3yzWedXTHauQWj0kj7FYgNugxto4DZe3kqRoqKcl4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SnaSjUuGqge184zIylG01Q3FBWFyCmspHyKwzxYSVUWaEr0T0f4cb1pYiA99YdJtRraBQKndSV9e/g/2X+RcLxPkDXCKdo0q7INe8YIsZNmxege3OwtGfFi+ukekZRwne/TlknUVS1+EdBSx8Gg8MM5cal3ikwsIwQUj3EnPAKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9nZOv1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9nZOv1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC862C433C7;
	Fri, 22 Mar 2024 19:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711136656;
	bh=8u3yzWedXTHauQWj0kj7FYgNugxto4DZe3kqRoqKcl4=;
	h=From:To:Cc:Subject:Date:From;
	b=e9nZOv1E3Sh10K67Q8VTzy1jw7a4/JqdHvu4oNWwmjwTHoKxFuSjqH/lHsNXigsEL
	 PagvKifjWJnJ4jEr/RnNBdUn02seoUwOM/MYhZ0cXXMECBcG11zIYQl3+QXa1kSv1h
	 K3UYDTeCZfK3vy0g9po3yGskQWvOQTke6HeL1UAGOIOxMRMaA5V5Bx62ffX3vePOAZ
	 5EJ4KHo0/G6C02tZsyAIBN9AQP+uX/DmzhQpM9BYhrQurIqNDE+mxkUTlSb0hffM8h
	 4Y1cets5Y+g9X3KMz7bKDk2R+TdANpU3Ydyh6KKQyVcyVo+PW6DVtSIw3uyPjwQ57b
	 PQ169FxQKK8fw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ming.lei@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm raid: fix false positive for requeue needed during reshape" has been added to the 4.19-stable tree
Date: Fri, 22 Mar 2024 14:52:56 -0400
Message-ID: <20240322185256.150492-1-sashal@kernel.org>
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

to the 4.19-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-false-positive-for-requeue-needed-during.patch
and it can be found in the queue-4.19 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 68a5e24e3ed59d8e222cf19768e374b3c816031c
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
index 72aa5097b68ff..1759134fce824 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3348,14 +3348,14 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
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
