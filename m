Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F9C26ED35;
	Sun,  1 Mar 2026 01:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329232; cv=none; b=FTju5EOguWJ6chMs0vVDN552mfQg9QiUKjBqogY0HyTuvV5eIS/a8UZbyoUAqE5kMQ3kDcq4VEPq5JZ8/QDlqijPa/cKY/We9lH7GV1KEa91Nrr9pG48QRm6myIA01FzfeFt5sTKZ8ubau49zj2dFjVzOowzYW59VyW9gHP3W9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329232; c=relaxed/simple;
	bh=s4zIdeQAv6XNCvs+x1+JAKAniCoq9K+GWQLBOZIZL3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L0R0/VeTD5PR0FcnhhxH5fQbslQQffPgQnRtaUy5WEti6pgOQU8JVF0gZ0b6ufYSwtIgvkryFWHrLt4Ho8UnwXu/Pi6QSr7fGLkB3IKWln0+PcYTn6Y89M35ZvB9QRjaotQHGrMYqo/CrjGZK2RIxt8sumRATpuMZDelkvMoZeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKWfRDUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKWfRDUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802DFC19424;
	Sun,  1 Mar 2026 01:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329232;
	bh=s4zIdeQAv6XNCvs+x1+JAKAniCoq9K+GWQLBOZIZL3s=;
	h=From:To:Cc:Subject:Date:From;
	b=RKWfRDUckSZQm45TYpkfg0cg8gxA4OkOgOqZArfe129YjIskLKbuHP5nfOo1zyTN3
	 bjEMq6K+qAUUVRLW6zAxvHzDW2QNFXJbH8R2UG9eoA5+AyQyvJC5pDH8H3rGRko45Q
	 Zs2ojVnqeJHaE70Mm9my9ui8iNZcCc8kA9WgO+mhDp+t8i/Ro4hbwBl3gdGdpwFBTi
	 KlIFwmRmZvBqtki3FG9JNFty5Vq5x5hIuxNluzKPT9He5W6+SHS3QAqOfdv/1sfJrR
	 2vjUYcd8O+c401Oe0NkrAReV+y4rdzE/KXF3WT9x2LyJUuaAd1L01ywBFwUbGQ+eFU
	 Nf9usOdZ1BDYw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	ebiggers@kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-verity: correctly handle dm_bufio_client_create() failure" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:40:30 -0500
Message-ID: <20260301014030.1701744-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 119f4f04186fa4f33ee6bd39af145cdaff1ff17f Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@kernel.org>
Date: Fri, 19 Dec 2025 11:29:08 -0800
Subject: [PATCH] dm-verity: correctly handle dm_bufio_client_create() failure

If either of the calls to dm_bufio_client_create() in verity_fec_ctr()
fails, then dm_bufio_client_destroy() is later called with an ERR_PTR()
argument.  That causes a crash.  Fix this.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-verity-fec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index ef9970b889aaf..7583607a8aa62 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -501,9 +501,9 @@ void verity_fec_dtr(struct dm_verity *v)
 	mempool_exit(&f->output_pool);
 	kmem_cache_destroy(f->cache);
 
-	if (f->data_bufio)
+	if (!IS_ERR_OR_NULL(f->data_bufio))
 		dm_bufio_client_destroy(f->data_bufio);
-	if (f->bufio)
+	if (!IS_ERR_OR_NULL(f->bufio))
 		dm_bufio_client_destroy(f->bufio);
 
 	if (f->dev)
-- 
2.51.0




