Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8AA278749;
	Mon,  5 May 2025 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485737; cv=none; b=pFnt8fq7MCTOXMmWVWwc8/UiLRGHFQ0OdTH5b2xj+PFp3zF3PoJ9LIreCjA6hpTIVz/G5xC0+o5H17GkT1MbGbF72dR53pDi2usOddpkRsN3qtiO9swRwhcG3cRn0uXGiETgumbZj5zl3tftQKyFh/pf09gR3CFJbd1elTn7bkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485737; c=relaxed/simple;
	bh=wFnYdOunZhmodXv3eiBhJ+0VqjL0WJ0/4/lSEKQo/eI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SxLG4tCczFjunYqpRxF8L3qd+yfHtBo9QavLaEpiWRyc0EqCgMBp7/VVnazfACaTe9RXbLlMpnBiinqMvyXD/IdEhwjvZ77we0DxUAmYfOtYUyfjyC6AqBLvSEhQUJw8YXZzbhPbJ9RssZyasXudgAYrnZMbtLCyzT/RAOXesAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYHN5xya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYHN5xya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B142AC4CEE4;
	Mon,  5 May 2025 22:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485737;
	bh=wFnYdOunZhmodXv3eiBhJ+0VqjL0WJ0/4/lSEKQo/eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYHN5xyamDqyq6P656SGbAz3f8l+VqlvsZeoSkmWTojsNJlzgYSnXdfonfdDe+VLt
	 w7KA2I5GFQMl0Ug9+eRSD++R815aHGVQaSPMASrWACmwEiOeqqgjsTplpUPGjAqjcN
	 ocdHaGCJIdpdSZdV3V2eaOFd7TNh8+ygDFMtcFD4kHFDVi84yibxtnpXbm03eILFld
	 IToxo8B/jQ1EySxOulH3+OjcA8yMm08pUhIYJjZ8jgXqx5sumgwLoOdkGrA/qFWgmC
	 ceSYhejxh6SUd95iL5WKkLe24m41FvwxTnM2rALLeBG6ihsF06R0cgiCBhY09vgMBB
	 e3Z5yv8saEiGQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chung Chung <cchung@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	linux@treblig.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 453/486] dm vdo indexer: prevent unterminated string warning
Date: Mon,  5 May 2025 18:38:49 -0400
Message-Id: <20250505223922.2682012-453-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Chung Chung <cchung@redhat.com>

[ Upstream commit f4e99b846c90163d350c69d6581ac38dd5818eb8 ]

Fix array initialization that triggers a warning:

error: initializer-string for array of ‘unsigned char’ is too long
 [-Werror=unterminated-string-initialization]

Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/indexer/index-layout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 627adc24af3b7..053b7845d1f34 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -54,7 +54,6 @@
  * Each save also has a unique nonce.
  */
 
-#define MAGIC_SIZE 32
 #define NONCE_INFO_SIZE 32
 #define MAX_SAVES 2
 
@@ -98,9 +97,11 @@ enum region_type {
 #define SUPER_VERSION_CURRENT 3
 #define SUPER_VERSION_MAXIMUM 7
 
-static const u8 LAYOUT_MAGIC[MAGIC_SIZE] = "*ALBIREO*SINGLE*FILE*LAYOUT*001*";
+static const u8 LAYOUT_MAGIC[] = "*ALBIREO*SINGLE*FILE*LAYOUT*001*";
 static const u64 REGION_MAGIC = 0x416c6252676e3031; /* 'AlbRgn01' */
 
+#define MAGIC_SIZE (sizeof(LAYOUT_MAGIC) - 1)
+
 struct region_header {
 	u64 magic;
 	u64 region_blocks;
-- 
2.39.5

