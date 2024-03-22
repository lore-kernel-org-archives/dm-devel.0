Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7E165BDA;
	Fri, 22 Mar 2024 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711131967; cv=none; b=NXvvCVGjI35Xb7VrrVHN729O/In5+JU64VVPmWsDuRyeBpJ3fSoIW1M52nHXt4Ii7fwBEV+IXef9Lg42hq8bGeUXMu/9whzGHTshMcz5xfBQEp6+liHzqZfGKj2DHVHCsUoyIR8+xklq04uFYfEfZRr6xk0D8bUTR8yYUMbR3/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711131967; c=relaxed/simple;
	bh=+anMoiYaSWRSv2L+o96ueu/YmLOGdDH9Ds3kNchZWSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sZVrOqlBYG0ZxNe+1dZ8SWXIwNtDbp4f1ujP+HoZiJPQ21SVyEFYsyEgPCgCKq8y7t14QmPhbeeoH+m/O+IRKgD+bo9RBQ0eN5VV8YVPwHPbXTygZ0eIcDtx97pu3mLP1EDYmdonCyMAKtairsXWnUAUZkAwTlfyPG3WROZTl00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZk2IqaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZk2IqaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3741C433F1;
	Fri, 22 Mar 2024 18:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711131967;
	bh=+anMoiYaSWRSv2L+o96ueu/YmLOGdDH9Ds3kNchZWSg=;
	h=From:To:Cc:Subject:Date:From;
	b=cZk2IqaWJwyunfLkdw1jE/qKPKxp8ONDz+0COoRhavbnCSdZ20tFcmDbd5+S41e1j
	 ZYaucD8QD5EQiI7PyRRJpINisWimUzartXg8tqmRKqhTMzfnaOYVIlBI//wSK+ylnI
	 bX8LMnvekqZJG4WgArbCSc0DqpbjIhvWmivBzj8sLuBrSci+SiuivrfTI3y5wsdXc/
	 ghnFQTS6A28KTXg7D9sdew7i2SY4TdZ3S6kxPYIbWFjMS59StiYa9OglwdozyhqGxh
	 7nT9NjHFI2MpWLsGemuQAZMhXvd5gGUtqY1iwGumzXUSJjhVsOlpGuS9yg95xzM+Ky
	 hxW1mOyUGogag==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ming.lei@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm raid: fix false positive for requeue needed during reshape" has been added to the 6.7-stable tree
Date: Fri, 22 Mar 2024 13:34:47 -0400
Message-ID: <20240322173447.77867-1-sashal@kernel.org>
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

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-false-positive-for-requeue-needed-during.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 23e25e3ffcdd59a5a002589ecbab43183c26a954
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
index eb009d6bb03a1..13eb47b997f94 100644
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
