Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4847BAF9;
	Fri, 22 Mar 2024 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711136355; cv=none; b=RvNv3rz4bfiNt7zLAlgHPQm6IZ3DQKkAuQ5BxaOA8Ei0XX5XoH7y/jYqJT0xO91D7xulcky+wGvL6S81nztcgQ/t5kyWkCe6v4rSwkunPZWGOdO1PMmEGeL2tKqGjCFhGW7KMOKpafX21qKV7O63/FHZyJdh62JCuSz+OM00fRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711136355; c=relaxed/simple;
	bh=NO7KTSORwGqZ7IWja2Qw4BCTMA5ZTfK5IOBVFZdovy4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q0Ng7CpjNfTKUD2R5JdgsfVoR5qFvgE5O1bjxtNMwPqn2GUpHKMOj0lFaqyhMIEki6uFHWrMAtasUAhK8bw4SjvhBfLY1wMn9OUlOPNbb4ewjQIt63jVR0TPcLiUQTpbwym7OXakhZ6oXSTx4t2QQN3gJu3zKYThRWOhjGcyo10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfFw3sXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfFw3sXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89262C433C7;
	Fri, 22 Mar 2024 19:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711136355;
	bh=NO7KTSORwGqZ7IWja2Qw4BCTMA5ZTfK5IOBVFZdovy4=;
	h=From:To:Cc:Subject:Date:From;
	b=tfFw3sXZGKIv0bFdCCejVvKsGK3rH+kO02hEfPYVI5+AdBByX+hxIKzacGFdWrgKT
	 G/meNMkEpR31vxZMNrXR5pIYYhgCUyIb3mUKl4/duVEQOj5+t0vUZnvrbKj0vDdq/j
	 xcLWrSjJIQE+D2JnrlMNFNrbDT/y98oic8XqraGk251BVGBe5STpvndSwq0sKBFZgQ
	 nHZpa7pfflvmosjqJ/n93ol2L9AeYNB+K7lrvkuHGGPeikW+lazjz6Gin27j44bA+P
	 fDQHABrhqh3Mcus4wxra4vpXOlD1rhDL4Qh5FE2ydkCV/xJT0CkpOpN++vL6LTVj3N
	 /d0XCZQtnsbmw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ming.lei@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm raid: fix false positive for requeue needed during reshape" has been added to the 5.4-stable tree
Date: Fri, 22 Mar 2024 14:47:55 -0400
Message-ID: <20240322184755.145269-1-sashal@kernel.org>
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

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-false-positive-for-requeue-needed-during.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit ef59ad0df33929e92c7886a2064beb24b132cfa3
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
index 9f05ae2b90191..1ccd765fad938 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3343,14 +3343,14 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
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
