Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A331891B9
	for <dm-devel@lists.linux.dev>; Wed,  3 Jul 2024 22:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720044820; cv=none; b=rOR1MeO5i44U+6r4abIAIijrkTjzQilY4mE50NJuPZPaYbCZISYUSwr09w6h1hGSRDPccLZQ9pFUlnvW0F9KmQ9fw9ejkLjsWo6G9rOTYLIs92etctoFHL21VGfiZb0ZYdbUdvAUipXYmsTbjttXCPqTghY10haEIuWyk7xxtWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720044820; c=relaxed/simple;
	bh=5NJtNNgyHGNLTd36BlygEHLyvmxn3zLSiLs0nKSxf7w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYsSQgpZfcoDVcN/isMPSM49nO8skkK9KWGDyxx8qHZ1+C18CiRIdeRCunhAv+xH66XazqfBdplDzvzlWzhRul5GK1zhqm8wIjwBbIIQ6Mbm5jZhP3mBTg5vVGatpRNZEy95Mtffe2lszFyxdT8WenfoTCLD1hC41vAWdkBOVLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhAjYol2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhAjYol2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E32C2BD10;
	Wed,  3 Jul 2024 22:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720044820;
	bh=5NJtNNgyHGNLTd36BlygEHLyvmxn3zLSiLs0nKSxf7w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FhAjYol2KrSYgumUKF93PvviCLY37wNuurbTUoyBYcl0NDCwcf5tFR+WoMP6J876K
	 Oz9UIa6lOUO4gZMYWxTh11M3MVhU9uur+UJ7gBGGN01NvlAJTIB1nHUQTasWl38jZt
	 hBPx2FLBBr4apoQbBWWJQgL6fWb1PjV7/tycgHGPR1hLTxCdBe3OEfOq4sPBsnk//+
	 g6lX47iYo4GHvlwaHiu4sRkwkGNTqJ95j9xpGelAssd+iXN3/6fNHG8cZtmQbUHBR8
	 Oaffc/LBMunQXZT1bDadCaFqq4D0t+y/rCC4H0vY+N/X0wC5we06q+Xm0LWDgIj1wV
	 c6mXs30SXo1Ow==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm: Remove max_secure_erase_granularity
Date: Thu,  4 Jul 2024 07:13:36 +0900
Message-ID: <20240703221336.503507-3-dlemoal@kernel.org>
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

The max_secure_erase_granularity boolean of struct dm_target is used in
__process_abnormal_io() but never set by any target. Remove this field
and the dead code using it.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm.c               | 2 --
 include/linux/device-mapper.h | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a63efa2a46ae..2abf2b6865ea 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1658,8 +1658,6 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
 	case REQ_OP_SECURE_ERASE:
 		num_bios = ti->num_secure_erase_bios;
 		max_sectors = limits->max_secure_erase_sectors;
-		if (ti->max_secure_erase_granularity)
-			max_granularity = max_sectors;
 		break;
 	case REQ_OP_WRITE_ZEROES:
 		num_bios = ti->num_write_zeroes_bios;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 5b7e96653ec6..4ba2e73993bd 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -363,12 +363,6 @@ struct dm_target {
 	 */
 	bool max_discard_granularity:1;
 
-	/*
-	 * Set if this target requires that secure_erases be split on
-	 * 'max_secure_erase_sectors' boundaries.
-	 */
-	bool max_secure_erase_granularity:1;
-
 	/*
 	 * Set if we need to limit the number of in-flight bios when swapping.
 	 */
-- 
2.45.2

