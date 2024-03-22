Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8009629E2;
	Fri, 22 Mar 2024 18:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711133502; cv=none; b=cPuSyYr0UpUVqZsy3ItrRb1Eh4nxlgLPsgbaz7lYdMu0pxTwkQ7THbwBK8nWYOKtkY/bwJBKdpMnLQkYy8HEPQlD6ONuU5WthJ/LpCUGtYWkxUIKGXQVcn+m465/Cc6reHwJbmEfvnIZW2beBFsVFGtWQe3GHeWOBB0Kr4l2iqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711133502; c=relaxed/simple;
	bh=17lIW6maFDcYEEmjTeA4LwyAZUtZxD+pOffZZBvMvQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XDHOpPHCPBygf2+PUToHPB1+0OV5w53q+IlRn/wBjXTKVvWAK23WB3aV6CKJEcmsnysbL4dD5ui/LQWneZtD6ex2mjdHI3pZ71TY8UVNlJ9XgWtBSO7tang10ehOzVkGmo4qCj8gjDF42AIxZ307MpqvQ2svh3+i+yDON9+IbEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwneSMEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwneSMEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD06C433C7;
	Fri, 22 Mar 2024 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711133502;
	bh=17lIW6maFDcYEEmjTeA4LwyAZUtZxD+pOffZZBvMvQo=;
	h=From:To:Cc:Subject:Date:From;
	b=AwneSMEuIxhltuxWOLsPz1kncYV+Q/N7n9XIWouPG2ldgGyZh2NPyC7FOpjPZ/wFF
	 2H8YzGnW7Ic/PvAlQb9NgLDgoIalU+ZeJaIErlRwS45RNXamsh+opWWzxU4Vg2VDz0
	 nuzCSnhoMHLQRMK+f4N4HlGjfalPUss0BZg0yjsrbIoTHkdOmuGb8psyw1nfdcIErk
	 HnIo/+I6oatyavDKVE4M7IDqDzLQCwFXvph5T857A4FiXVKsI9OzDyjDtA1mlhc7Tj
	 5HrcJXPcihv76+m5tZcps972vcqCcPMDzzfm3SNwNuOpIZVq4bUEgykdx0OSfQJqGu
	 RN+a1JRi62ZDg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ming.lei@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm raid: fix false positive for requeue needed during reshape" has been added to the 6.6-stable tree
Date: Fri, 22 Mar 2024 14:00:22 -0400
Message-ID: <20240322180022.99924-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-false-positive-for-requeue-needed-during.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 4022fa5efdef92d0c8a25caf98b57ef3b33231c7
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
index 5f9991765f270..3d8ee9eb59ea6 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3322,14 +3322,14 @@ static int raid_map(struct dm_target *ti, struct bio *bio)
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
