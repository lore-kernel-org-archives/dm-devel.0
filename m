Received: from smtp.smtpout.orange.fr (smtp-70.smtpout.orange.fr [80.12.242.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAD518A92F
	for <dm-devel@lists.linux.dev>; Sat, 20 Jun 2026 19:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781983991; cv=none; b=slnzOIkOZQ0Rms7JbJyc2IxjDlR3XhaMwj7nlPqPPWwbflMejNFw9VidtKVmlIAAn7SmNbi4Ga47kEi4zF7gJrOGxQ8YchDLerLMVKeqf+mdteXfJcFWmrJPHJ9PUohaqO/nffYczV5MIOlak0FFtF7AMHjVtKtfB9/0zVHe4Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781983991; c=relaxed/simple;
	bh=wzgvTOJfuaj5S9B9flSBzpAtRCfBo/HRym41UEdWWaE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cZaYR9tAvS81JvCKZXCbb6vNqACdN56/daW5Dk4clvTetDibjeIWmQvogfH6KBaq/Ntqz8YgwjCfYJyYrGs/mNYEZJ45XkKDTmHigevRBBxsrajy/VcouCG0MzFtK6XTFtppldocRhezAPYEwPE9rC7roxnqCUYj9Kgc3x95Emo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=nNUSMIUF; arc=none smtp.client-ip=80.12.242.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="nNUSMIUF"
Received: from fedora.home ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPSA
	id b1RCwPqLOPooTb1RDwwtW5; Sat, 20 Jun 2026 21:33:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1781983988;
	bh=otIVsKHQILgMiNi6xzRj+CP8TEISa+XW8sPwAjZtq+Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=nNUSMIUFpcIJx1oaAamMX5HlPRTBlvz0BOBT8qcpXVX3QntjCfqIvrfMbKj/L8ckf
	 RRaWzlMauq7PO8yNwq7fqd2Kmgs1PwvpFfvIPWtRzyQob9nXT9StDJKASFOg3cRJbX
	 wlewdd4bPWwbOJPsqQTKDlBBTXkI9BXc172UoQCZcuolgMLtg7Bzp2vZjkdKsnIhhz
	 Pvqwf2Lgo+aep8jOYXmz5Nv6u5KVbXunXxuFF4Yw+tMmS9GCzBo7ksa7yHxrya0ro8
	 ZxzN5SzfpjH25TplQhdrfY2eo60LZPEw07KkAET6j7Jhz6p7f87B5466I17RfB+7O8
	 BBReYd9vlZHZg==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 20 Jun 2026 21:33:08 +0200
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
	Eric Biggers <ebiggers@google.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	dm-devel@lists.linux.dev
Subject: [PATCH] dm-inlinecrypt: Fix an error handling path in inlinecrypt_ctr()
Date: Sat, 20 Jun 2026 21:33:03 +0200
Message-ID: <2b6e6b71e66fbe90c75791669a9e16a36b48f7f6.1781983971.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All error handling paths, except but this one, branch to the 'bad' label in
the error handling path.

If not done, there is a memory leak and some sensitive data may be kept
around.

So, fix this error path and also do the needed clean-up.

Fixes: e7f57d2c47e2 ("dm-inlinecrypt: add target for inline block device encryption")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested only
---
 drivers/md/dm-inlinecrypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index be1b4aa8f28b..bb4ded4757d1 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -347,7 +347,8 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	err = get_key_size(&argv[1]);
 	if (err < 0) {
 		ti->error = "Cannot parse key size";
-		return -EINVAL;
+		err = -EINVAL;
+		goto bad;
 	}
 	ctx->key_size = err;
 
-- 
2.54.0

