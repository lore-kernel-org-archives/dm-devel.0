Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7762133A010;
	Fri,  6 Feb 2026 05:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354115; cv=none; b=NdaV5GGWIF9gptTGRjUtEXyaXeGnCoaXJjsmIxk4ThM2t4kXzNBbAeWsmOTYTgqwTqraXfND8fqXYGODGMp+SWV11ewV8wwZ39jPjeknVPZKOgxPvXdwi5dFCf/HtqBFri2lC4Wsbz/PpSzyzy8yuyqF8hqyYKFl+UOEFcudOKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354115; c=relaxed/simple;
	bh=0OIDTxwWeNBq0cYgnVu7ObvDTWCwxCqc2kk3dLvqHMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip8XvdmpjLYFjYdHhX2DH6Yu3BuTfsAhnoWxwuSrtdgipxt3NRswWTMsUr1n0rARHaM53/5T3fkmKOdszfwdA28C/VIBNa9EpkVN9IUYUzZomREOO6SdD9Dn+1CUifDB+MapLIGN+JtbDZh/2qKVSi73pTaVYlfMEWLgN87mA98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3bVDuxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3bVDuxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5248C2BC86;
	Fri,  6 Feb 2026 05:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354115;
	bh=0OIDTxwWeNBq0cYgnVu7ObvDTWCwxCqc2kk3dLvqHMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3bVDuxtDrhc9oo6PruKrovP7oUwjWE7HQX6gOVmtRiv+jq+LIJz/6pfjZqKmnNZW
	 UyX/9PrOvTjgDNqNZxNGmAMBHSbFry4bNOdFPVhtfsGRVutAzJQNdTz0Hx4lTjGW6j
	 UMZJk0HuVq00BrE+S4kaKvAkMXia4NvNYIVU5pjZ7r9k6D4q7CqSMSXmDK8u1LaeS0
	 rMmSHbQsVb+EjrT7OejZS44+cVpagIvAyfKHplGsQCRM3T7x9oJsSfPfkgjEJPgzio
	 GyNIXnidx7wXGPZYKt89r22qk37pMVow+zvJQCDZDAdJ3YX3I3SkyOcyCCwhrq5c6g
	 q8upBFR3ju4eQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Shubhankar Mishra <shubhankarm@google.com>,
	stable@vger.kernel.org
Subject: [PATCH 03/22] dm-verity-fec: fix corrected block count stat
Date: Thu,  5 Feb 2026 20:59:22 -0800
Message-ID: <20260206045942.52965-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_verity_fec::corrected seems to have been intended to count the number
of corrected blocks.  However, it actually counted the number of calls
to fec_decode_bufs() that corrected at least one error.  That's not the
same thing.  For example, in low-memory situations correcting a single
block can require many calls to fec_decode_bufs().

Fix it to count corrected blocks instead.

Fixes: ae97648e14f7 ("dm verity fec: Expose corrected block count via status")
Cc: Shubhankar Mishra <shubhankarm@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 9f06bd66bae31..d4a9367a2fee6 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -161,15 +161,13 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	dm_bufio_release(buf);
 
 	if (r < 0 && neras)
 		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
 			    v->data_dev->name, (unsigned long long)rsb, r);
-	else if (r > 0) {
+	else if (r > 0)
 		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
 			     v->data_dev->name, (unsigned long long)rsb, r);
-		atomic64_inc(&v->fec->corrected);
-	}
 
 	return r;
 }
 
 /*
@@ -437,10 +435,11 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		if (r < 0)
 			goto done;
 	}
 
 	memcpy(dest, fio->output, 1 << v->data_dev_block_bits);
+	atomic64_inc(&v->fec->corrected);
 
 done:
 	fio->level--;
 	return r;
 }
-- 
2.52.0

