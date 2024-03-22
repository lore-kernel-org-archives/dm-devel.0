Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D9C76EE1;
	Fri, 22 Mar 2024 19:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711134705; cv=none; b=c3Tc9/B+SYQbVopGXiT0kfnzdxKv06WWikEb78caloiCyvAf9q21FqiiijUECpCgrwaYmOkytYCB2CYSVoAbQqA1WULWMbMLPN10S6DRzUSLKBi5ZieQfEdvDK1M9El65CQNdV9oARpL7Tm4Hf52q+5N5bS2ANxlJRBuTh5gi8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711134705; c=relaxed/simple;
	bh=vBgvw8beLPr/ftKpZihjW/a2Z1Eic5AisNpNj37ErH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H28lhK5u5ThSuQ1lBd6W7sJSTsXZbtkXNLlzHngcCwgsps1G2hzztQFRWv2gSOeIjGvO168kTWRyr+K9aflglDt3xIhwQoQ+GM/ZQXXdbL7tcyvdzpSIrUXtHmQCkb6lTLtyJVnR4N0kh2OdHdnmwvRMyDXC6qPc+5VA3q27AE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hslosb72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hslosb72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC05C433C7;
	Fri, 22 Mar 2024 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711134704;
	bh=vBgvw8beLPr/ftKpZihjW/a2Z1Eic5AisNpNj37ErH4=;
	h=From:To:Cc:Subject:Date:From;
	b=hslosb72whrbn+NMIbQwV3ZW7n5P9CwYBj+uESwQqwPk9hioJGcXQFJMyAq0o2d0B
	 5scepJZ9jb2cbqmtSbwiWRpoi0LeBqP6zCBtKiVUoN4hmHBuHjhL7Z2CW37d0DL2pz
	 S2PZ6TqjsCmjHqLZlN2Ip8j3h5IIENtV40ASXlxn+UdpnGU45GKMqfmscQMjUPvP0e
	 WDGt5sb7Yy4n2C4VYsQHfD7ArTR7DlAkU/iestmlwqUAB7fXQIh59bNHCffRK1Mk7c
	 kHi71wkT3+NhqHnxe4itvjFg1rnfAJvdBD/eN9TSNr/r53fYAoBNEhzon9gLfjPUKU
	 0Pa9KSrVUW1cg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ming.lei@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm raid: fix false positive for requeue needed during reshape" has been added to the 6.1-stable tree
Date: Fri, 22 Mar 2024 14:20:24 -0400
Message-ID: <20240322182024.116968-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-false-positive-for-requeue-needed-during.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2bb9735b4fca22d4897cbbff886a144a0ae3be4e
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
index 4b7528dc2fd08..7fbce214e00f5 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3325,14 +3325,14 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
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
