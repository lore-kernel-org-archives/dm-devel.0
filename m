Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232E556E073;
	Fri, 16 Oct 2026 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792171651; cv=none; b=gPZhOsSXzEi7pZ8PI7AVrlNR/LffikpaagDZTI9/UQngmH0FLQmC2SAIThPatmQJ77xa1H1Fc7BJxtSiWLma8vkKreK7TfND2U3UrIKcICYfhm6kpAVQ/BK3Az//Jh5xZe5p/W0+s0quRo+Kw0JHRtJB/HWKYEwiq96WBbgZt0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792171651; c=relaxed/simple;
	bh=rb6eY4hnUKnRWo9HTnDWBFlBa2/HrGUN4cA7tNy1Wfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IvFh7SFVl/jfbd/I80MdEvG9PidCGdsvX8N6H+6EgyJ+EoqHA/XLVeKwfrrFW7wIwB58QY3WclQaOM6jngi3L+tGzYzOc5YncuzVESv27/tLiEsWbr8R8KCmBy3za6A9cRWsFudwi0Jc587jIkt7HsAsd4M2QPEMjjoiBI0SiPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0Vswulc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0Vswulc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7456F1F000C5;
	Fri, 16 Oct 2026 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792171650;
	bh=AO7tQmHPh1xmrvRF4KFrmRg/R7ihS/mMGjljW7xswSU=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=i0VswulczsMMVqHbt4NeBhBpKRJcV/lFKWeEx2uV/6Nnvmtrwt3Ln3OpO9TGb48cz
	 L7YnGoTxj+rSXI7dgHFkCqp3nN+dCOfC0s1m6wCDu6RLQKoek/YNPe8zQdJSnCYl+T
	 S28PWquQsdiIglmUX01ejEzhMNMJCrhjEScT+WLkSeMvEVWN9rxp3A1W6BXPJp8rNl
	 K3CuFZor5S0aP9CHhqwGo3KWceMZecCnVbv+OXcVA5XtAaS9p5EJcjan0dNQrTH3hC
	 6+KdonW+7YA02yNACbXuuaHkVGAZ/X33JPxLLoqvnB+sFqo8YLLmWt8uU/ccmQwAc7
	 rSM5RcnfiSYkw==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	john.g.garry@oracle.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-stripe: limit chunk_sectors to the stripe size" has been added to the 6.6-stable tree
Date: Fri, 16 Oct 2026 13:27:28 -0400
Message-ID: <20261016172728.4009716-1-sashal@kernel.org>
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

    dm-stripe: limit chunk_sectors to the stripe size

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-stripe-limit-chunk_sectors-to-the-stripe-size.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit f1404ed6434738563ceb9363a9dd6d745b547bd1
Author: John Garry <john.g.garry@oracle.com>
Date:   Fri Jul 11 10:52:57 2025 +0000

    dm-stripe: limit chunk_sectors to the stripe size
    
    [ Upstream commit 5fb9d4341b782a80eefa0dc1664d131ac3c8885d ]
    
    Same as done for raid0, set chunk_sectors limit to appropriately set the
    atomic write size limit.
    
    Setting chunk_sectors limit in this way overrides the stacked limit
    already calculated based on the bottom device limits. This is ok, as
    when any bios are sent to the bottom devices, the block layer will still
    respect the bottom device chunk_sectors.
    
    Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
    Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: John Garry <john.g.garry@oracle.com>
    Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
    Link: https://lore.kernel.org/r/20250711105258.3135198-6-john.g.garry@oracle.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Stable-dep-of: 1071d560afb4 ("dm-stripe: fix a possible integer overflow")
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 67026e1cbc857..aad50e9fe9958 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
