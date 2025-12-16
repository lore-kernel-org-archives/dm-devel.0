Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C76340A43;
	Tue, 16 Dec 2025 23:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926421; cv=none; b=LC88BvYxEpnR2GsuMMI5AzVx/EWkz/msfow1OAit2Z5icMHy7kO9T/pOeQ0TJaErQ+No8tqCdNUgHN7KJ0wgRDGo8VignGm1ytwN+Z9izIdw+Nxkqrpuv0g/0kkmWOlEJQUTz9INcLlHcqc7KJbd7Cs6d/LMoDJBMFOFVBNH1jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926421; c=relaxed/simple;
	bh=trE6zxe2FEt8zzo/9pQ/qzrWtmL8xbEEnJ2pQ4Ti32w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/R6eXFsIoBpk8FE9DYDenBXcG+a4Unty9UB46ZZd5HY7eiE8xqehda+3hD0oaMkrzUG9crd49yq7Uvmlu0dpjnDYlX+X95vTUT04t93Adha9UAJ2Mu9kcYVcfjCexY2uHZDjq+EuYPrPZ5k3if4fXVtnPm/c36gbR253WBchII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzT6qM8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzT6qM8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D98C16AAE;
	Tue, 16 Dec 2025 23:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926421;
	bh=trE6zxe2FEt8zzo/9pQ/qzrWtmL8xbEEnJ2pQ4Ti32w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzT6qM8rw2RJCKFYMgfCLXeZQRNcWj+/PxNpYUFgiH4DxfuqIUprwuvqDtzaAQtXR
	 874EN4AC5SApcs4aIicsRguBc+GmNFhsfWSb7EbzaiQ7oQxPvyPh+BhrXalbRnTEvd
	 hZi1g3+5DXAqUnUzpullvaHjxc4VxpManOrkdKObWq7vkkCII2MdwnUH1mZXDQ3z/c
	 IpWFM3b4vJ0icAm27ALeP7Pcxif/+7YF88Xb1zdH74zKTzz8SHXRQws+XTbeTL5qUb
	 A+F0Hm5iLBlCDxSliE92ykDfYVfaqR2dAaf7m9gjH42F1U/Vj5+YOuhZYwBRzlBQYl
	 63jszX7wkCGXQ==
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
Subject: [PATCH 6/7] dm-verity: correctly handle dm_bufio_client_create() failure
Date: Tue, 16 Dec 2025 15:06:13 -0800
Message-ID: <20251216230614.51779-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216230614.51779-1-ebiggers@kernel.org>
References: <20251216230614.51779-1-ebiggers@kernel.org>
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
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 9bf93280cf33..e8f1913f5f12 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -500,13 +500,13 @@ void verity_fec_dtr(struct dm_verity *v)
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

