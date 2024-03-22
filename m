Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CBD78686;
	Fri, 22 Mar 2024 19:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711135967; cv=none; b=ffVlrbco0eL+JVn0ZSwG4+w8pqQGa3WvqRtwinByabnFkSI1Rm011+JgNMqeD+bbTJkMYDxKWj5WSgjS2V+TLQ0MFV0Xj+cn8FdDzDam4U7+7ezeMWgfX5q1u3rUuY0hcp1rdiuXSyYP4qktF/6xlniZRuZiCTI7VGjdm18evQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711135967; c=relaxed/simple;
	bh=gSjByIIaqCkPycWnxZtky0Ms7mcpUnu5MkYRUwv8uzY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oDSTtM6mcZ+nyVBecgHHfh2/4V+fv+UlmSfqJoGCkt/YeGBnN1Y94NVfBHqWW2+noymHJvUJVtXjj+oDy+gdFkjECvflT9nRVepi7+scBNwkp+kVaUo7WBisUaAOFPpSUfdD70aQc9akPW3f7lvK0VVO2UCn5jdBhn7+yWRXnPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pLpBcmiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pLpBcmiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A878C433C7;
	Fri, 22 Mar 2024 19:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711135967;
	bh=gSjByIIaqCkPycWnxZtky0Ms7mcpUnu5MkYRUwv8uzY=;
	h=From:To:Cc:Subject:Date:From;
	b=pLpBcmiEFFvmJLV8pvue4A/oNTxdYXEbeJCDfhd2ANcjUAY1oKAWLhfUyRgGLtx3r
	 jWIpuqsrtJRL8dCwAx30Sau+qVKGE70JEYqjqbjmmUeM/E0uHxr8LTo/OdlX3xiDQc
	 QyuOmU8O2hGnvKcLXM1LASD7HgiRR64WN/3js96C6XHyVD8/b6xDQMuEN3QPRbFyC+
	 5CLODjmdxA3dtTuZIw4+5kNLndIrKmphEHaaXcOJ/DztxbWlvW/ar4plbOdTHqpgXC
	 ahQ8KfSav5nXgP7ZZXq7APe9m3vM1ipm0nnMVcaJNzsn5uRre0a2438Kx+0muxBitp
	 jqierfllYeMhA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ming.lei@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm raid: fix false positive for requeue needed during reshape" has been added to the 5.10-stable tree
Date: Fri, 22 Mar 2024 14:41:26 -0400
Message-ID: <20240322184126.138645-1-sashal@kernel.org>
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

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-false-positive-for-requeue-needed-during.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit dbf878e1f52c60c02bba794bbf721bb96dcb53e4
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
index 140bdf2a6ee11..e523ecdf947f4 100644
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
