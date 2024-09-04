Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7D64EB2B;
	Wed,  4 Sep 2024 04:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422714; cv=none; b=cgZIfeOMf9+rnYD3WQeL1ZYyIswXu76NAbWBrlVtFEBvA7G/+1/OOoIFfReRmBX5OsMtD2PFGNEeSaCE+qwUIBTII4qM024wuCN8kYctibdeAcc2UVHAvEFPZJvwpoZ2SSDnNQWjpSCkKiCdHml5MYKaEnlcJi/mkT9/OcDyDqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422714; c=relaxed/simple;
	bh=gU7VljMglbdj3Lw8JJeKa4ccbDe1OwyrXenD1IfQ948=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sjiWzLGCH2CWPNA1n75RICuYXdLoJ0+5P0Nh9Sm6ZF5hKODlDup6gZ66gYg3bnHvPQ1i+aTk0plZO+j8iBDZsEuvOWOJ3vdw/h3Y7EMx2kf+a+rywhQVxSYdr9TGMBQ5xypwfNXzX9XqMiyq11+5ILjo+7wUTmFFbZ5mprqb3RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0hZ+nqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0hZ+nqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC247C4CEC2;
	Wed,  4 Sep 2024 04:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725422714;
	bh=gU7VljMglbdj3Lw8JJeKa4ccbDe1OwyrXenD1IfQ948=;
	h=From:To:Cc:Subject:Date:From;
	b=V0hZ+nqoc6SiidhET/uxPq4RnfIqqLYmRFnx74j8lPJIn6aflHuD2qVwls88i591K
	 hpDfiqOzVOgwYXXdR1MvuvO/7awQb5l+nqzWC0bZ0dX5D1JV3aw9RtyUXCdMJMR8mB
	 9XHukIpF1B5759iRC6InJFkzOmCr7XXvS80ARjJLj9jRjx/URpx2CCH+jxoP+BPCvN
	 t00i55xf/OfkUOFSOI1osyGczd6SBWwVZt3TR5HUZ7gkTc+slUIod+zeMacjGKAzlU
	 b2dfFUcutqYOx7JAa82U5ZwBHbyOwv7SJ9O4iIYeQBplkOam7KTGgfQB0YXWYQkac4
	 ql0nCN2e0SvZw==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH] dm verity: don't use WQ_MEM_RECLAIM
Date: Tue,  3 Sep 2024 21:04:44 -0700
Message-ID: <20240904040444.56070-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since dm-verity doesn't support writes, the kernel's memory reclaim code
will never wait on dm-verity work.  That makes the use of WQ_MEM_RECLAIM
in dm-verity unnecessary.  WQ_MEM_RECLAIM has been present from the
beginning of dm-verity, but I could not find a justification for it;
I suspect it was just copied from dm-crypt which does support writes.

Therefore, remove WQ_MEM_RECLAIM from dm-verity.  This eliminates the
creation of an unnecessary rescuer thread per dm-verity device.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index cf659c8feb29f..051e84ca401dc 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1488,11 +1488,11 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * Also as required for the "try_verify_in_tasklet" feature: WQ_HIGHPRI
 	 * allows verify_wq to preempt softirq since verification in BH workqueue
 	 * will fall-back to using it for error handling (or if the bufio cache
 	 * doesn't have required hashes).
 	 */
-	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+	v->verify_wq = alloc_workqueue("kverityd", WQ_HIGHPRI, 0);
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
 		goto bad;
 	}

base-commit: 88fac17500f4ea49c7bac136cf1b27e7b9980075
-- 
2.46.0

