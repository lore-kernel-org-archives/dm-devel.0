Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D0A33A9DF;
	Fri, 19 Dec 2025 19:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766172743; cv=none; b=KjrA6lVkuH8n7gJrRRc9OYVnScaKKgcBhRW5dCI9PUTY5/A5C74d30tr8n19WpEV05E4JeaOKAnjeoSeRML+qPWjdaXv+qQhMJrNBcHS3WluyGfw+ABJD1dAAH+VjWupFglY43d6hKpE+H05r0H70bHS773XD37njALurX431KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766172743; c=relaxed/simple;
	bh=AdXX+unAYpqoYbNBMazn5BVkgrnIfOitLZAS4+aSFwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQe0jYnygoijf8Wh6QfWLyLX/fltxXDw28Dao2OAnAe8coZmY5zL0QKqklIwKmDGYOv7AcUHX6oW1089Bmt+Jxqj0Xckv11nQvBToUlltsGNVSirJHZ+McwN/3av1TA0V2aosyYX2qwwhigeDSUSJH+ggNDCh3xp/G7rAvU1dKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJUFrFLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJUFrFLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F40DC4CEF1;
	Fri, 19 Dec 2025 19:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766172742;
	bh=AdXX+unAYpqoYbNBMazn5BVkgrnIfOitLZAS4+aSFwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJUFrFLrhe0x80sJh7/xhNu0X87e4ARTb8hIsciUvH3V7GLehLvU/1C/XA6Hf8rUC
	 xShscnpJpbogeQlucDwIJFXj7CR249X0R4jJclLH2o3HxbiL5Md2kZETxUiMYfTNDq
	 w/ylHC/+qQdlRMT+t3xhpGiKz8R/Ye/J0SAGINBjCCrBlgxDdSR3J59d3K5OV2blng
	 YV4vf2/+urXPgGiq6gSo3DReQUoxmCaAVFto6+Y1XoMZiR5TLOKQFpRFdKC4ozDMVu
	 6Kuo1OzmH0mQ61560cjcbvM+QhWc73B8rmawOcJ0DUK+k7SbIPTnkyPJXFyyGa87QM
	 3HDws4xVPy1og==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Eran Messeri <eranm@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 6/7] dm-verity: correctly handle dm_bufio_client_create() failure
Date: Fri, 19 Dec 2025 11:29:08 -0800
Message-ID: <20251219192909.385494-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219192909.385494-1-ebiggers@kernel.org>
References: <20251219192909.385494-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If either of the calls to dm_bufio_client_create() in verity_fec_ctr()
fails, then dm_bufio_client_destroy() is later called with an ERR_PTR()
argument.  That causes a crash.  Fix this.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index ef9970b889aa..7583607a8aa6 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -499,13 +499,13 @@ void verity_fec_dtr(struct dm_verity *v)
 	mempool_exit(&f->rs_pool);
 	mempool_exit(&f->prealloc_pool);
 	mempool_exit(&f->output_pool);
 	kmem_cache_destroy(f->cache);
 
-	if (f->data_bufio)
+	if (!IS_ERR_OR_NULL(f->data_bufio))
 		dm_bufio_client_destroy(f->data_bufio);
-	if (f->bufio)
+	if (!IS_ERR_OR_NULL(f->bufio))
 		dm_bufio_client_destroy(f->bufio);
 
 	if (f->dev)
 		dm_put_device(v->ti, f->dev);
 out:
-- 
2.52.0

