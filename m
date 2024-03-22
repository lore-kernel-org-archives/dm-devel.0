Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C2460DF5;
	Fri, 22 Mar 2024 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711130466; cv=none; b=uQfyVablu96l+SABSCqHbyTdF6xpTZTsdkLRgk6JUwGs8UTcQ5nNmGiHcrOwnKezlJvjHh5d7dFmSUvJLEyF9CM8uveKLKhu4VvPGG09DzRZR47kfXGZouvwx70DWTqyLrpzqNxt9mYuDdDAPjQrH5KydR4EvgfUXt/pkiGmmV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711130466; c=relaxed/simple;
	bh=Mr23P3eA4yeJbHY28kHT5NxDCkF0UwA4sUrvEFwDpzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KNeDJrZqpTTm33ZCkLsiXdZweOk+l3ug65esYZWdYMVTN8Oe/9q3aR3suPBrODXCounLm/gnmic7h7+0ixEeTCBsTz6KIv34ZZ9nTvyH1lHD362jOJ7ytDha7vfUArbrDCZzp1TO2ACD2f2eY6z80/ToeUlAd/OI5hq3nARCl0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlqvmUg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlqvmUg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D505C433C7;
	Fri, 22 Mar 2024 18:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711130466;
	bh=Mr23P3eA4yeJbHY28kHT5NxDCkF0UwA4sUrvEFwDpzs=;
	h=From:To:Cc:Subject:Date:From;
	b=HlqvmUg4EhJoSQsn17og/noPFW4hiApgGi4o8kBAahPITIxCmXzeACcRvA+Ikl6r2
	 m8KnqFvRDaB0kG8ewC5zecVqDugxwiGIuhZtofb2GgZACAAJwq8k8wqiMFKJgpJTxa
	 OLSg/blN+CGnhRVs95vjOiAWPjtbWq953Oer0xUXqULmU+65wJuoQGClpjt3A+zwtN
	 oaOao6IFdh93aPEm9B+RrPh92s5r8J+KZEdu1WFaWajrxOXQ7wO/mnqfM8Adr28Svn
	 ww9A5RicAr2iYSrJ2xnZ9p+nZvcOavNC0w/fY7anU3nv2PzofCt5GA6JE449pwWuxu
	 84ZcUo77opPFQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	ming.lei@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm raid: fix false positive for requeue needed during reshape" has been added to the 6.8-stable tree
Date: Fri, 22 Mar 2024 13:09:45 -0400
Message-ID: <20240322170946.52144-1-sashal@kernel.org>
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

to the 6.8-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-raid-fix-false-positive-for-requeue-needed-during.patch
and it can be found in the queue-6.8 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 43fb8b0d11a9824e4179eb1966a821cd276cecd8
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
