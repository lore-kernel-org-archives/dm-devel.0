Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 846A72DF84
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168125; cv=none; b=QiqNhLZSlmWa4Yir1YtACN2P/9VTguX1oGNvjtXCgQrfJ4+6g/JpEBcStiWmuyvwPtOijV+vVj7L9KzBQHmjSLBb2xnEAIgxdzqGBk+0t5JnXA8VV2Gwx4TrviA1vyp/nz8NMJ6GTj8TWIwucCHu49/dc971qn7xB/7lMm9jj5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168125; c=relaxed/simple;
	bh=nLFXtzeBcjiMKyMP6dpEwHa6q1zR5t7lNC5xVrWtFS8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=u/iufUKPoh/cegA0YBrjh2y1m45mDwlxcHP6ajrMsatN5uNFl+mORQthdzzgcqe+e8wjzes5wmh4gRApoSBjPpHbqiXHF+OTOcp2jLlPzduOOVC9a6/lnBPf3Iyanzsz9AoCuvlk5aImZUgsmYwl+PzFN6ue8elLRcP30oHX84g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=akULg1jo; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="akULg1jo"
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 1564520B74D7; Wed, 28 Feb 2024 16:55:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1564520B74D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709168119;
	bh=XBFNFhZO2C2cRsijb6fK7ukrFdTouoAgBmyOuq/elfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akULg1jo9HtuVSFYgZ5rHE30PjIwlaYO8eGr0+bgCMSgRzruoP0iDYZkNCxbB1/3W
	 DAGe4s+Ugn5lUI1avwC6PBE/UyWsljIXqa5zo/+Y8UtoCKpTqdkn1b8KKXCHz9zxBj
	 267R6svgGCoUuVJERRazmMIXQZZFdBEkp6nWYNpE=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v13 12/20] dm verity: set DM_TARGET_SINGLETON feature flag
Date: Wed, 28 Feb 2024 16:54:54 -0800
Message-Id: <1709168102-7677-13-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The device-mapper has a flag to mark targets as singleton, which is a
required flag for immutable targets. Without this flag, multiple
dm-verity targets can be added to a mapped device, which has no
practical use cases. Also from dm_table_get_immutable_target(),
it documented that "Immutable target is implicitly a singleton".

This patch adds the missing flag, restricting only one
dm-verity target per mapped device.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v10:
  + Not present

v11:
  + Introduced

v12:
  + No changes

v13:
  + No changes
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 1b591bfa90d5..a99ef30e45ca 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1559,7 +1559,7 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
 
 static struct target_type verity_target = {
 	.name		= "verity",
-	.features	= DM_TARGET_IMMUTABLE,
+	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
 	.version	= {1, 10, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
-- 
2.43.1

