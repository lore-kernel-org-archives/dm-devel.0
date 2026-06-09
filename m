Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED971386C9
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965327; cv=none; b=qY/9gHQHJ7QoVo5LMvyMc5e54QVvl7SIPghgjmUMOjtL+7cifaHOFqD9D4Ye86asqpBSkg3UrDFButQmfs8IpRCHM+KTHNfNmvyfCk3/3FJX8nkoxuNLgqcZ+aXAhj5DKVxGIf2sIq5cVPgVobAsyA9ns89SSVMVLKnzmAkb7fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965327; c=relaxed/simple;
	bh=xhk+5EqZyNsRhHnXWI9IuqZ/E91s1jfjHNcL1iJhaMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mCKZ0j8PhWGlPVszweGe6FksjRjT2SU+23i/572B+4BXdBygMZvGzRzjBDUHBqVtntAro642chX1Skx40+nKSFq0PCisD/wRW9IxbJeHYkgpGfodo3HNYoWImE8wSrmXo4FPCuI2P4ss6ChEwZev+dV01VXWjOVrImXsFY39BK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=GtPkOCMM; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="GtPkOCMM"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ccda0ac4fcso50545146d6.2
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780965324; x=1781570124; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9qipJX5pXgVkuc3t+riiPMsFZFvp+nAnooommCiTyQ8=;
        b=GtPkOCMMYj4XkMdxfvTZjkLz+xUDZ51I8qSkRd4jGiXoGgU9QCnWUCuKLQYXyRgkFl
         +v9/jsnaBRtDS2F1vUgkIpL3lKaLpjPMDFbyiiX7PUGZB6z3T9HdIuOZr5yx8wRdVeZz
         ePWekspwwlZYU07ppMEt0bgcm/y+ylSzqdVqtdze2N5IxH3aIYGu2N8JL2CxNOpeknT0
         fdkFXpX7PvAMqrNzhVujCWaobD+QxgmnJAUmntSqjfttEG4BIAeNM6XhheKG01ScXece
         LX+IvKfapy8P2Y46SBn5P0Y5n2AjspZnh1FjyOnmiBPRElHRX01AKaA60z8s3pb+uY4A
         CBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780965324; x=1781570124;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qipJX5pXgVkuc3t+riiPMsFZFvp+nAnooommCiTyQ8=;
        b=dR9DXctJ+xoq3lsxzSQaX5J6hgcCBBZvFbVG/2LK9ZEciuIzhQdXnIW4fNxy7kdbPN
         Q8yxprqQSvxm/XMi+7gXVinyDKlZmcVsWqulhTjDtul9jg6yuC+Ld1SGvj51rvtcAqAB
         Ym6lZYxqsmUekm6Cve99mIO4xER/tuHn36wItgdFUqcjDVywScd8XNCos9dpFziYPD6a
         Sl/nXj6rHKaRk9l3Tw6J+KSd1kZAbFjVGPaPUte5QyPQwFgwPM140m3isfyRtTPs8dyo
         0io+nNIXj0GhBH38emZoJ9O8FRMAQlAzIpJRQf2YmZL2RvfZglBCAkNcV9xGBdiX2o1Z
         KkGg==
X-Forwarded-Encrypted: i=1; AFNElJ8f7FmwfnC4DsVyaSloM7gOUa6z1qIpQ8qv8PMli8BswNqnvasuKNknhDUQIRTXtDmGsqA3Owuolw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywp3B/D+1fKrcvfEMUxLlNfH3fRZPeeE05FDU1m1c5fcaH1JMQ6
	/ELwtysDjFp58JFyMj4bzvgjbDDMkWcOEEww+y02J0eVZR8OWki7bRulh698/vw4Wto=
X-Gm-Gg: Acq92OFSsYQowhnd7iyAj0MpHOf5he12YiEHF80ZiOEGyD/e4+9bBWb0s6b9YIe244D
	z1wGKWVcBFExbc+4B4moBCkO3Xj2p/D6wBBKiSV6S9OqdeC0oi383houtG8Zz9dhglzvqtIerym
	L/TuynbqrpmsxJ4kid4+eSIIDU+Eo3YqZuR1ulCldz+scor+P2VOGm6uxNkg6YR9t430bS6/y+L
	E40JZ01EGFswEWsD0UpJVbcg8hJbkobiBFF8AqcG+oe/642vaOf31uvElda7Xh1JLRF48kgCRo3
	l1vxOzAo8vI2c+456SkGMapYyHoJ1qbemUaCFAJvE+aT1c1fYnxZh48hsEH9iKWrtUUfn2DSgqz
	3xKD+ZJrNKUO5wglv/Q9ftTKGU4+3P8l5UtV6m4CzNDWdbV3LoGYRrkSseyho/DXIU+o5AQCaPK
	h2nTUnuxYbCZCOk6LbZnoVR2sSgvkTi7cK1yGppg==
X-Received: by 2002:a05:6214:3d86:b0:8ce:e3b4:4735 with SMTP id 6a1803df08f44-8cf1b37858bmr6480666d6.15.1780965323716;
        Mon, 08 Jun 2026 17:35:23 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8cecd2682f8sm183022646d6.43.2026.06.08.17.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:35:22 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm unstripe: reject stripe indexes equal to the stripe count
Date: Tue,  9 Jun 2026 00:32:51 +0000
Message-ID: <20260609003250.1237334.ff865e6f1962.dm-unstripe-stripe-index-off-by-one@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-unstripe accepts a stripe index that is equal to the number of
configured stripes.  Valid indexes are zero based, so that value is one
past the last stripe.

The out-of-range value can later be used in mapping calculations and
describe a stripe that does not exist.

Reject stripe indexes greater than or equal to the configured stripe
count.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-unstripe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index bfcbe6bfa71a..b1a8ec69ccad 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -69,8 +69,8 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err;
 	}
 
-	if (uc->unstripe > uc->stripes && uc->stripes > 1) {
-		ti->error = "Please provide stripe between [0, # of stripes]";
+	if (uc->unstripe >= uc->stripes) {
+		ti->error = "Invalid stripe number";
 		goto err;
 	}
 
-- 
2.43.0

