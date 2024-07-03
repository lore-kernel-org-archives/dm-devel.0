Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC34E1891B9
	for <dm-devel@lists.linux.dev>; Wed,  3 Jul 2024 22:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720044819; cv=none; b=Jd1ldkn22q8gfgaO6yiNipcIaM5h/Zhg25QoXD+EDg+k3nMYUztgRhl2ppLjrQELiIa3/gZBIj00+S+nFkgygDsalUqatUIenc75AItjlQ5wbqNPMkJHs/gZ6eHTcIWDKO/ufvSTFe7zH6n5mE0HyXvRWPXqipo7342QFqsDSnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720044819; c=relaxed/simple;
	bh=ehekv+van3nRJCTuJtA1+hKGWoiXnY9V0pv1P76Qd0A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnKJ6hJoKAlVeq8fuVatb5fvsI/AM58nmIf0ENiochaEizahndLRGWMwPXH5pEmcZlt/WyDDRYkuEgL2wThgG2J6VWOOeLgjJ4p/hMMaJx1rEv4oTG2yzp5ufKmqH3SYc0LvOIwRLZUbo+uxOudR5Ji7Ko4RLFWUrfS0s08JSuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6/f18yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6/f18yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB729C4AF0A;
	Wed,  3 Jul 2024 22:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720044819;
	bh=ehekv+van3nRJCTuJtA1+hKGWoiXnY9V0pv1P76Qd0A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=O6/f18yfwQ/oo6T0GIJI46BpDsyFHHm53T0pXNORkAKwLZpTjAeCmikPptqyGr+fJ
	 qvotXpjk6Sohs64oLiEIPjmAXFaKvyLvwnT8hCItrs/jMMSIA1seFS2gHNQd5SLVFM
	 U3zGofdJ77E87r8K6sZ7GLoV3TR+UcXAycoKguNKJ/Q7FwaTNnLX0fsxD13qK3qhvA
	 e6LtqgDXHvzU9ZhulAMWwfTkxtiB+s6Hv43CnM0SxPeOJd5PyCNTRep7x1u+RTDGGO
	 CqtXFLbgWIzotMJhk7s+wW1oETPd61YG+JY2Nr4sczQoW9HvmU+ppjZo4JcW1xl+Rf
	 03JxYDlhYorYg==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm: Remove max_write_zeroes_granularity
Date: Thu,  4 Jul 2024 07:13:35 +0900
Message-ID: <20240703221336.503507-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703221336.503507-1-dlemoal@kernel.org>
References: <20240703221336.503507-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The max_write_zeroes_granularity boolean of struct dm_target is used in
__process_abnormal_io() but never set by any target. Remove this field
and the dead code using it.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm.c               | 2 --
 include/linux/device-mapper.h | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3763b2ce557b..a63efa2a46ae 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1664,8 +1664,6 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
 	case REQ_OP_WRITE_ZEROES:
 		num_bios = ti->num_write_zeroes_bios;
 		max_sectors = limits->max_write_zeroes_sectors;
-		if (ti->max_write_zeroes_granularity)
-			max_granularity = max_sectors;
 		break;
 	default:
 		break;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 3611b230d0aa..5b7e96653ec6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -369,12 +369,6 @@ struct dm_target {
 	 */
 	bool max_secure_erase_granularity:1;
 
-	/*
-	 * Set if this target requires that write_zeroes be split on
-	 * 'max_write_zeroes_sectors' boundaries.
-	 */
-	bool max_write_zeroes_granularity:1;
-
 	/*
 	 * Set if we need to limit the number of in-flight bios when swapping.
 	 */
-- 
2.45.2

