Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F2F21D590
	for <dm-devel@lists.linux.dev>; Fri,  8 May 2026 02:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778207848; cv=none; b=G5VKPqI3ZlQjZJ1SSqkZS0tOjiRIog0S5j0eLznBj2OKfgeHl2U7EQjoPZrYoYk4Y6mNXQYQ+w0UQaGskA8soyujykPAxrGIF36SC5B4BZHNgKtqeGAyRpbpeEhkVC4cvg0y8Hn4tQ6giY2cTb/wbpANvu5Y18mCvsI4xvNY1iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778207848; c=relaxed/simple;
	bh=eCY9FpLFbmYQZcjaqmApKechLJqDaTc+X7WjzyTrtKk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EqqfzRfqfFUcMEwtjfAKy3HpffQ66TYv1ldIo3OI0HvAcFv/gselmOdvGG0xeggdDnpkZjwlBclc9tYcUlBtC8x/+o1za+JCBGSdsHsD8rTvLBBtssC2IWc/nVnJga6BILLjzrFWTnjCI26gJvEbI48Sgmb+UgK0SRvh1DAZsXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ch+8VH5b; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ch+8VH5b"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65c2cd216c9so1492133d50.3
        for <dm-devel@lists.linux.dev>; Thu, 07 May 2026 19:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778207846; x=1778812646; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oYsV4EGU0evRUjorMSwFGbp0KIcwFk/DNB3Xry1x+Ew=;
        b=ch+8VH5b4DrWSSlslITPy5aBr+FNKOuPjrDmB2GqMgejTaOHCWogpjzWFgOG4gsujD
         kyUQh+spopPAlr/3qKCytc3ifiCzk9165th4mIVl4N7jV8U4vAShRqGwhCoFTpi8W4lN
         19SRnXAg0siCPyRYIKEi9ulVt1Q4ZKu2rug75nomCAsE4/x4yIzY4FHUMlwy5tD7NYEY
         YSmL3ikXYmA38hawO1fmYRc/Pocv/G2SNWZsjPrZ+WIx67tDhaLh6AODczwVb1HcCmG9
         ahHUvja1Em2dfDZp0cqmPuZtTeo4y2p0V9bPwT6WgASsQXnL7Q6CDlFyik5TThHsmdYt
         VHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778207846; x=1778812646;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYsV4EGU0evRUjorMSwFGbp0KIcwFk/DNB3Xry1x+Ew=;
        b=evnG/g/Sm2umOa7mFVBI7sYr1hNbOBtA6h3j5eeiULlvAr2ma7sAO41FiGTS0FVJ26
         5ZyHY25jwqTKUwxhgWEqmeae6ce4pcHmJ9CeT6ILmkRZJFviAVEhXZmuM4ZvlNvAqDsh
         JrA3RkDbHwah+qh+GvezCVuI5jnpJa8KZSRozBBiTXpLNEB579jdgbh47h4JAVvGDfPT
         6ZB24EqBqI8Ol9SOt7QYiCmJXRHtU40RN4EcnQN8IzQumh4crdEItUJCDNYQda4PAkXC
         bucKlj9hJYFm3TzVZn+BDAM7GEZmSztR/keQJaugddvxJ+Hv0ksmmS7i6UmxTYaDbNo5
         sINw==
X-Forwarded-Encrypted: i=1; AFNElJ++2Jcp27t4z8xBrgmjI/fVjq1x7T3WOR++JFRLJJMtN/Sidv5lz3F1wc1wUHGT9nSVwVrna5B5fw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwpIsj7eAqAZiF3ZXYT8frA38FxBo+kLLa6qKkRv2y04gIp56dQ
	J+llPOXPNprE9D2GyoZGK4Nhod0m9B2SHl3wM1Vi58CNTAjgELHsqq58
X-Gm-Gg: Acq92OH6SF48Y4QscrcqlAgIcfln7yBuhueBFi9o0514nu4FuwdHy5zDnEld+AlaDI2
	wFhflE8xT53fBNaT/jVPOiDbLrpbZ2BlfJVK0B1APd121SJgzNB/d7KuIBTbGSGCsP5c2XH6RgC
	EzUNmC/njB2WjWM/9OU3+QV7VEnM/S/6NwtJ6amDwNDBjLcnX0XwTmNbQUfMSkpV8+sNRTk+akE
	DUC9rjxZ4tjoYxw0bi0YrWd213CfZAX3vomdYddmQWUHoLlV+VvhLfPzEgqdGBJD7mGGW6QmK4x
	75B5y7UtuBOEp+OciukorycY0w/+mDSG+3CUJM0iY04G++QCQ+u0aOi9JDKv9SuIxpt/lT2Uzbh
	b9MhSZSTEp9Eqi2TqOXOtrVXP9ue1O8gJshcfX9c5BFLuF+pnbL+3jY+VZNmmuqPVeJVVSdJPZ3
	zUe4kPJcYkRxowSHfhs9a3PtMUpZkJcoyhe5gws7XwenxzqPT1CVXHGc2yEiK72ik9a7jNchZRS
	KuY5s1nY+qfhTtTfKIKs0ph
X-Received: by 2002:a05:690c:c4f1:b0:7b4:f43f:1a23 with SMTP id 00721157ae682-7bdf5e98251mr118033637b3.34.1778207845701;
        Thu, 07 May 2026 19:37:25 -0700 (PDT)
Received: from tux ([2601:7c0:c37e:2360::111d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6686fbcdsm100023497b3.40.2026.05.07.19.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 19:37:25 -0700 (PDT)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>,
	Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH] dm-inlinecrypt: Fix signedness bug
Date: Thu,  7 May 2026 21:37:16 -0500
Message-ID: <20260508023716.668783-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function get_key_size() returns negative error codes and
ctx->key_size is an unsigned integer, so the check (ctx->key_size < 0)
is always impossible

Assign get_key_size() return value to err, check for error code, then
assign ctx->key_size to err.

Detected by Smatch:
drivers/md/dm-inlinecrypt.c:329 inlinecrypt_ctr()
warn: unsigned 'ctx->key_size' is never less than zero.

Fixes: 753450f716417 ("dm-inlinecrypt: add target for inline block device encryption")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 drivers/md/dm-inlinecrypt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index 6f804f5a4be6..40d48ba73e23 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -325,11 +325,13 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	/* <key> */
-	ctx->key_size = get_key_size(&argv[1]);
-	if (ctx->key_size < 0) {
+	err = get_key_size(&argv[1]);
+	if (err < 0) {
 		ti->error = "Cannot parse key size";
 		return -EINVAL;
 	}
+	ctx->key_size = err;
+
 	err = inlinecrypt_get_key(argv[1], raw_key, ctx->key_size);
 	if (err) {
 		ti->error = "Malformed key string";
-- 
2.54.0

