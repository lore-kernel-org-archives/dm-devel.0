Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD756E073;
	Fri, 16 Oct 2026 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171653; cv=none; b=LxVyi3CRuphvOxz3m4QcxAzvdj2Kqcg7Y9udkT+PKqcJIp3cqKcEQpwLXedaeRzMPxIlt8yg/sq7Mj1vvbkmXOvuOIZNHwnGaZyNlB7QXLLPXdj80qWHRoTXxeMxX9v4hRJPPIjHYCNgYwAP1kZ5v1Y9mjjJaYgTQXUUjQkAxHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171653; c=relaxed/simple;
	bh=0bVLw2NlMwIXl/qUwJk1mVc/TXqx5vPzatksNECCQnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HlN8NAZP8u8VopJZ01JobYQdmHk4CxQiYcXXwIiavvDT4WPom1U3B4E/2eVIZ5rijcYok6qzYOg2XRokFu2tjl7yycM5wEcHbYGs6j7H+yAeKZIMO3hpPHOTnR5xMf0Nc3f1QgTpEVWgLWu1Fr6/k4m/po7J65UcNy041D9SHTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZP4CVY4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZP4CVY4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2B01F000C5;
	Fri, 16 Oct 2026 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792171652;
	bh=pi8Cn45PdGkTyqelHstA04Amxh+UDW+TlHaeXpZ9Alc=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=ZP4CVY4asAwratprnznEeDyKaLzFCY2s/5EZlBH1BowkTMzrax1im/WICiemtdhiG
	 X7c8X6BRpwzobJkSNIMHfP4+RsmCQjkgLc+1ETLCYeoXcg62XPWZE9+4wrqX/SPrCH
	 /7PZHcTmKetkEV0jHY6VmQHViMTZVCd+SHozH+ePRrRlxV0phra6c4JxROgj3Lh472
	 FUcvz+CNXX6zcdSRsiGXsWGnjsygEEodd5gF/kgeA5q6j4pOKnwjc+BGEUVC13zOeF
	 IjB8IgWCiwUt56MCSi/QwzQdONAYRBylW+yYB1Y56lpFYvrhtvxMNAuFlU6ThGB+L0
	 6AJGLS2SnH+iw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-stripe: fix a possible integer overflow" has been added to the 6.6-stable tree
Date: Fri, 16 Oct 2026 13:27:30 -0400
Message-ID: <20261016172730.4009758-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
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

    dm-stripe: fix a possible integer overflow

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-stripe-fix-a-possible-integer-overflow.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit d42a776bd6f8527f17229a60714fb411d98f764f
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Mon Aug 11 13:17:32 2025 +0200

    dm-stripe: fix a possible integer overflow
    
    [ Upstream commit 1071d560afb4c245c2076494226df47db5a35708 ]
    
    There's a possible integer overflow in stripe_io_hints if we have too
    large chunk size. Test if the overflow happened, and if it did, don't set
    limits->io_min and limits->io_opt;
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Reviewed-by: John Garry <john.g.garry@oracle.com>
    Suggested-by: Dongsheng Yang <dongsheng.yang@linux.dev>
    Cc: stable@vger.kernel.org
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index aad50e9fe9958..11d8ff3c45635 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -456,11 +456,15 @@ static void stripe_io_hints(struct dm_target *ti,
 			    struct queue_limits *limits)
 {
 	struct stripe_c *sc = ti->private;
-	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
+	unsigned int io_min, io_opt;
 
 	limits->chunk_sectors = sc->chunk_size;
-	limits->io_min = chunk_size;
-	limits->io_opt = chunk_size * sc->stripes;
+
+	if (!check_shl_overflow(sc->chunk_size, SECTOR_SHIFT, &io_min) &&
+	    !check_mul_overflow(io_min, sc->stripes, &io_opt)) {
+		limits->io_min = io_min;
+		limits->io_opt = io_opt;
+	}
 }
 
 static struct target_type stripe_target = {
