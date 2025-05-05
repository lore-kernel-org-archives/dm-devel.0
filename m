Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BEF33AAD0;
	Mon,  5 May 2025 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484639; cv=none; b=WmWgVC5jDq8oQ+2ueFElj1nXrdyPmPI5HyqAWLJwS2yLzDBZRE/r4pclW3/8XNhgvQg2IaArOrsSRAu0ea4w4mOvYnTR42YxAvXGXv++TNaFqon36txjiHnOw2b58pXF84Bi+X5UhV5H5MbWSyQ7ckXWOPFfZsnvAJp+U7OLdFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484639; c=relaxed/simple;
	bh=Mjb8rk2MK7bk19gwmLLpd4yD2Rf26+jGn7hGtS+Vrqg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ksU1XIIdXI9wri1tgsUOn5TxbhQLYCofBrKuRiVhBpVYqnGpsfs3Gj2U/IzZLM2vB8chPIkq0/6La0urMSO5jOfC6yNOSk3fOBnnEtTUNliBOKHlILxRTbDvXd2i5Pxy+Ac2VOHQUODMCTW6dI1Lftz8kNWfEY1QReKnYMQPSI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pd0vmsVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pd0vmsVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393AEC4CEE4;
	Mon,  5 May 2025 22:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484639;
	bh=Mjb8rk2MK7bk19gwmLLpd4yD2Rf26+jGn7hGtS+Vrqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pd0vmsVAT0COZcJMdQqnqsuQ6A1qlQCj+L0Ur20aZMDSJ3tmDQdaW3TdGIMwH4Tiu
	 gz6EOTgUpRxjXNpOs/MBWtUEOkBUPJrZzli62A7TFERNjaoNYOEwugTjuV7v756A29
	 XzO7m2b2zMEdeDtPqoHW8yWUmymmbDLynU3pZ+oFaYeto7Hbryc4/k5iRIrBA+NHLp
	 y8mYp6zEhOPL7m9umg5vhKnMZ+/keGlnt+BlH8TwMDIkESbdcPDLz7qQHkrQhQ2bT+
	 F9fm3IirsA0CVd/cUAFd7Wz5KxdYSKq7so4HDi5DhdzAbZMXh02k1gOOxSWobiP13n
	 r2w8l/mrkyXJQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chung Chung <cchung@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	linux@treblig.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.14 577/642] dm vdo indexer: prevent unterminated string warning
Date: Mon,  5 May 2025 18:13:13 -0400
Message-Id: <20250505221419.2672473-577-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index af8fab83b0f3e..61edf2b72427d 100644
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

