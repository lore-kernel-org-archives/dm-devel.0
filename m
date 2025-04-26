Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98C76FC3;
	Sat, 26 Apr 2025 06:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745648196; cv=none; b=MKN30Df6Nex8DKGznWIwz1V9JsrNhaNJEEOp0Z9LK7wZct3sBixM+3tBKvmZ1rJXxFypn4hlpT6NEaZhSt9aV6SQUkXAFDyp4oR1eGFzhI4KhhYVWqazNnGPzAcf5mVsSe65fjngGc9QyNLh0z5K892FX5dy6Yf3Vnvbm+gCjdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745648196; c=relaxed/simple;
	bh=g1amRiEi0rCq459NzFvEeN+2l2KIeSBh+7TMm0FVGqc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Zo1vokcXCPqYx+I2cPy0QFgg9ooDrZ0INLBCCOZM2DC/MES1oC86Kth7BZ3UiX6LAo3JhUs3fLCOWz8KUFAXvnLK4p/pNu7JO+gWDrQKvK9UvrkRrPJJ7hbWn2dbK4x5os9nomNkDdXIkEdDer7aRaJyrXYr7D7MsIic4xFJv90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TT4tRDQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TT4tRDQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CBDC4CEE2;
	Sat, 26 Apr 2025 06:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745648194;
	bh=g1amRiEi0rCq459NzFvEeN+2l2KIeSBh+7TMm0FVGqc=;
	h=From:To:Cc:Subject:Date:From;
	b=TT4tRDQRPaFHHwyPh+79foeWmTvStxiMseZeIUxpeBepiqHaUJm/Xtol/mLcqVUpp
	 AXh2QX96v6ujmWKdvhVnHg2p3bnMKZ6et33RCZsrKM3mKi9ADs/LItQE3x0kq1jGZ7
	 rNZnnQuo0ojm1LnycClFAt/y8x69jC1eG0aQMBjwmWrg7gDigFc28Cz4X+6HOBL2tD
	 OpgVl1fIjosATKpPWv9RIiC/3vVcOUej9I6Q06i1E1+hvvGz56QdLxZNS4NMmVCp3x
	 r6OiiuJYq5qo98jhdcOOPMCcPs9l0WeIF+WUVZlpl1UpzkP2ksedMNnM5Vnmukij54
	 WWvzy5rpBRKQg==
From: Kees Cook <kees@kernel.org>
To: Alasdair Kergon <agk@redhat.com>
Cc: Kees Cook <kees@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] dm-crypt: Adjust crypt_alloc_tfms_aead() allocation type
Date: Fri, 25 Apr 2025 23:16:30 -0700
Message-Id: <20250426061629.work.266-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1315; i=kees@kernel.org; h=from:subject:message-id; bh=g1amRiEi0rCq459NzFvEeN+2l2KIeSBh+7TMm0FVGqc=; b=owGbwMvMwCVmps19z/KJym7G02pJDBk8VbbVFlPkq47Hzdi24ba98tY7Vm9P9Z3LdVvf+eriT 4GDb3+97ShlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZjIy/2MDAcM+yyPJPkZFLic nKwYvVa3rcQ07NWigJO5SevfHdxxrpThf8jMF487Rdyeruw9u//+p6jPktPWT7XQeZB+9Ln01wn ZjAwA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct crypto_skcipher **" but the returned type
will be "struct crypto_aead **". These are the same allocation size
(pointer size), but the types don't match. Adjust the allocation type
to match the assignment.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: <dm-devel@lists.linux.dev>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9dfdb63220d7..8134f56a471b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2383,7 +2383,7 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 {
 	int err;
 
-	cc->cipher_tfm.tfms = kmalloc(sizeof(struct crypto_aead *), GFP_KERNEL);
+	cc->cipher_tfm.tfms = kmalloc(sizeof(*cc->cipher_tfm.tfms), GFP_KERNEL);
 	if (!cc->cipher_tfm.tfms)
 		return -ENOMEM;
 
-- 
2.34.1

