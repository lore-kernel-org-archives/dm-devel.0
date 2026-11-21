Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795267553;
	b=YycvyK/dIuwE5pj3JR05+ZT1ZM1zUiN8IFAwUlVTZQqr0G/nUZfJkdeAKQfHPioTBwVV
	 qOzcNpQ/tfFOd/+/CXtS/SAZZyeHKEjbzy3qy1DqAcKotN5AL9aJrgSGMD1mndzXTsing
	 Me2VHk+ZiL0ltOnZZvvkREr5cspumZTuoUB5RRlSEpURj0+BZuArukVEx6rYZqJJHAZAx
	 ZmwtKqn4Mv9Cs5+GSqXfx+b2anlkFW/FFMFe3MIGfZEjGNj0d35LsSspjVDbPbBz/WGzQ
	 vgTVoL9l3PCX7vSM+rDVZQKIi/O6Icnk5b7V2umbZAg/2SQDO+NAIelcUYTrYOt9T6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795267553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RzZc1ZvHcmljMIW8GIop80TWAkL0ySLaO8QbZptWPdw=;
	b=hY0V3hcIfJdRNrekodJhLavzVH+48WGTHIg2GvsoNQa6uypGsycvRvefkF0qcQErsfHf
	 7CYrHTHetnmYmTelJhNphj8o2wnbr0zNLuQU42UrSLbFZjQ5V7AZx9G8Ypzg3i5+6ZCwz
	 /VxD1QvxNQByUQLmyT50l2C5bfSoVKhXOrx1TNLP6tGeHU5uHA5EVgjh+N9krd9bHcpqC
	 abFrXY+cMYTi6HkLf0orJvcxjoIiXwBMb/Umjp9NPKtP+HRCo2gw3w5dkYcKKBXhpw5Kv
	 3YJgrMws3iMuE+AizlH9dGf1Aa/KqxLqrYwQOax3MD6nF9hW2CVnNQ3Mhe8RqYZMFFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z1frUJU5;
	arc=none smtp.remote-ip=74.125.227.138
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823DF606A32C
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 13:25:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 823DF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z1frUJU5
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2effa00323fso6950465ad.1
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 05:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795267552; x=1795872352; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RzZc1ZvHcmljMIW8GIop80TWAkL0ySLaO8QbZptWPdw=;
        b=z1frUJU5mP6U81McjHGpAIpHMiOu2NBh5KKRuQ11uSX2a9Av2y8dEFlaQE5VsOof8E
         3HIyK23dTcNtlA7slTUTfADkiWrGqMQUvTwiVrNuz9Snf63zoXxxHeOngjZWHNu3cpDO
         pT1nC+UObByyh3mweFdbipPyZN8imvwzG0dqPv+NHqg5Ncd+e2ccjZvuwDa11PN2dssm
         C2pyokdDufyOnnhdKVI0bnn+QAuyS9FKFiZ4p2o0WMw3tDyp0W0iXx5T/VK2ojyN78m0
         3YSWbCXd1eeTJQZLPbVLOTgv7m8OItJom+8MEtngsECQNTMTmVgTzQsBuItlPQbMqGri
         6dkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795267552; x=1795872352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RzZc1ZvHcmljMIW8GIop80TWAkL0ySLaO8QbZptWPdw=;
        b=p1f6zIGaUkJrEy7+wETc1QDXlhdieaEjRrRtTqUAlJAEPfCl2xrhIQuyOMWsn7ctTu
         ZM5CTNVoFAtt5J8xgoSzJVcxzRGyx3GKEN6it7XcCyiYWOpZKc7akGSpBUVMYZGkkmNA
         DfswwhxyU8u4PQ355f8cXgzyGn1v/OK3N3TXG4Si4Xdb6sNHRy17aILVPTtvsREF9eND
         +VY1uyRKSkkuA37m2NtmYUjy7AUBijO8JvQnB20AF6LYw3D4xiW3/s+phEBFr83yN8GO
         4icRhNApGsV6sLWlnPKvrF23GPxaBexL6BVv1gyO7nlkC0tstYGAvDYQdyNu3Z8UI68y
         bAsA==
X-Forwarded-Encrypted: i=1; AL+hErEzfboSCRGcOPapmNAesOEmoM4DWjZN3SODV87s9X51mcyDC2Sr3C3GSdvfMqfJ/Ibbx0SGCB39iA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9EyKU9evy9CQPd0WVYWO8itRwJXpTWXpHkY6X3+vd0D8LU0ZQv
	F+ano1jGlKfbZxZoG6hHoB1wh1T6F0abYZPnlzu08J5Ka24aV3oHQoA=
X-Gm-Gg: AZFdTZfLSxUAtMKL/0NsH4UHRsbAW7OpXEvVJ84ZlWXP13qSW6ZOYv9iXB2HnwYyLHq
	rlsH+9jqUf7Hh1oewj4xqr8RT0bUD+xfT3btzmSQJ6Yg9CC2IUpv0vVjP2mrlyeg1fDkzec3vCB
	3AGjScnsslS32IqMUQKyyyVm+rbMtVXXqr3BQt2hWTLjlTKCcxEM1wQXo4e7lX8TKXdT4IT21fd
	LxcEzTKvmWrHNn/9QCmOfMhijGLlUjzoLM4WtnlhTOpx+3njoAVLqqeyGPLt4WBqnC10D3rGk2Q
	5VltulpQKl3d02u5b/avhmwTgsS0kkZX3hPnwSRnAtO1LchsnTncQN9KnvWcbqGtErJFXdof8Vv
	IH97GKsAeKCGvpX2ZCUhhKAZDbtRJx2S/K/0dktimGGqYqYeB1EtAu4GOvgCb4N7xThQU2nNwFX
	jAuhXYsrpEaQi2lbtov0RF+TNnq+iq5OCSBYjAiQoniDE2Hw1PKChvS1/48xR+CC1EZgMZ5b0Gw
	ez+Z+FsEKud4FXbf+HiqAeb6njw7AbyGCCPYeDgjZSiMc2piR0EVLQdjUqrySErxF/0EDB4YOw8
	TYKZ5LXx2TDP7nQ3aocEHkoE7JwJCc4kOIRuEKE=
X-Received: by 2002:a17:902:c409:b0:2e8:1c7b:3b6e with SMTP id d9443c01a7336-2f03f1fe182mr61390525ad.26.1795267551719;
        Sat, 21 Nov 2026 05:25:51 -0800 (PST)
Received: from archlinux ([2405:201:ac01:5300:572c:c4c3:6927:1f87])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f105bb2sm26620525ad.45.2026.11.21.05.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 05:25:50 -0800 (PST)
From: Anvik Loitongbam <permissiontogallop@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] dm-inlinecrypt: emit key type as an optional table argument
Date: Sat, 21 Nov 2026 18:45:39 +0530
Message-ID: <20261121131539.7519-1-permissiontogallop@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inlinecrypt_status() emits ctx->key_type as a positional argument between
the key and iv_offset:

  <cipher> <key> <key_type> <iv_offset> <dev_path> <start>

but inlinecrypt_ctr() parses the base table as:

  <cipher> <key> <iv_offset> <dev_path> <start>

and keytype, is an optional feature argument parsed by
inlinecrypt_ctr_optional(). Resulting in STATUSTYPE_TABLE output for every
dm-inlinecrypt device to be not reloadable, the constructor reads
key_type as iv_offset and shifts the remaining fields.

Keep the base table in constructor order and emit a non-default key type
as keytype:hw-wrapped in the optional feature list. Raw keys remain the
default and are not emitted, preserving the existing table text for
raw-key devices.

The two dmsetup examples in the documentation acquired
the same extra positional key-type field, so removed it there as well.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260525121348.1321282-2-linlin.zhang%40oss.qualcomm.com
Fixes: f9f57971da38 ("dm-inlinecrypt: add support for hardware-wrapped keys")
Cc: stable@vger.kernel.org
Signed-off-by: Anvik Loitongbam <permissiontogallop@gmail.com>
---
Changes in v2:
- Add Reported-by/Closes tags for the Sashiko review.
- Emit the literal keytype:hw-wrapped after the non-raw check, dropping the
  unreachable raw fallback.

diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
index 8258a72f00a8..84dd2e6a1b26 100644
--- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
@@ -119,11 +119,11 @@ using dmsetup
 
 	#!/bin/sh
 	# Create a inlinecrypt device using dmsetup
-	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 0 $1 0 1 keytype:raw"
+	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 $1 0 1 keytype:raw"
 
 ::
 
 	#!/bin/sh
 	# Create a inlinecrypt device using dmsetup when encryption key is stored in keyring service
-	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 0 $1 0 1 keytype:raw"
+	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0 1 keytype:raw"
 
diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index 3479dfe5f708..c4a0501e7b9a 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -522,15 +522,18 @@ static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
 		 * the returned table.  Userspace is responsible for redacting
 		 * the key when needed.
 		 */
-		DMEMIT("%s %*phN %u %llu %s %llu", ctx->cipher_string,
-		       ctx->key.size, ctx->key.bytes,
-		       ctx->key_type, ctx->iv_offset,
+		DMEMIT("%s %*phN %llu %s %llu", ctx->cipher_string,
+		       ctx->key.size, ctx->key.bytes, ctx->iv_offset,
 		       ctx->dev->name, ctx->start);
 		num_feature_args += !!ti->num_discard_bios;
+		if (ctx->key_type != BLK_CRYPTO_KEY_TYPE_RAW)
+			num_feature_args++;
 		if (ctx->sector_size != SECTOR_SIZE)
 			num_feature_args += 2;
 		if (num_feature_args != 0) {
 			DMEMIT(" %d", num_feature_args);
+			if (ctx->key_type != BLK_CRYPTO_KEY_TYPE_RAW)
+				DMEMIT(" keytype:hw-wrapped");
 			if (ti->num_discard_bios)
 				DMEMIT(" allow_discards");
 			if (ctx->sector_size != SECTOR_SIZE) {
