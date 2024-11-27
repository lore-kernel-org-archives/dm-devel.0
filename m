Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1AC2010E1
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748685; cv=none; b=OFgRyyJqza7YF0syFMx4nniAPH/x+dPJPIj8z1AT+zdzLBPbb4yyBg/FspY/yYZKfh3+OZfrlsSUKNoFnJjv0RzRdIBHWX3zKZkGFJMol8iOqOWU2M/cqVIUtome8lE3br1ARWSdxnKeL9QR5nxElix5nLtbEZqsV3jVZkVkxf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748685; c=relaxed/simple;
	bh=aiRk9WAnkvI77xBxBQSNpsETn7u8gXA5eOC25/MZPtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8k9/pHMMnBzPx9IFeTL9Ro6sUBhpweeA9i/cJN4ZnwrQVSL7ZzdBzXd4BSfE/9ZZG9Di81VNh4E5G06Gsb9i1MBRZ8n3lBAYq7S6JKckwFP/9EjgJQDrtm+qAVZx84W/Qm9XacGiD/29Tkdm8vROPdN2lQvtaJ9b03FHkxATqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d/GkDQ2T; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d/GkDQ2T"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38231e9d518so180235f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748679; x=1733353479; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jrCEG6zpuSFIe5D2YdmWR1SuNildF1xSQO8Os0+jZoA=;
        b=d/GkDQ2T0TGqA/fw6zuj4nNBY20V/f1LZKJ1Kx6nFtrg3WIJIj2uxe+5wEKeoXepam
         mhHgW8k9ThCpy0tFMjfARInZWv/lqvFn5+nb5BTePIjIYdf4/mHKsGGCUqFYP1NFgQYC
         WehH6crrU7stATSCUxJUAjkjJFPeDzl51lXALRl9N/KuYpqmNby/Kix+yAI5RzPtIcOE
         eHwx0eG/VF/d+n+Ktdz6Qek/haM7Hx2kTtr4LWvF0BeVaKNZAqic889KgvRo+JyHtw8u
         UDGdER7OZ/JpSJlqAr/HZQG3Q8Ap4Bydv0r5c11Dorn0i/u54PqZ5ISEofx/naDLSAdo
         J6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748679; x=1733353479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jrCEG6zpuSFIe5D2YdmWR1SuNildF1xSQO8Os0+jZoA=;
        b=R7yOzOXwp9eOdCZwvv1hX6+zzHKiF0xFmcnDwUXlGEdp3VoJf0+m74K/HyORAXNnxe
         CXK4WbKaaQubkFZD6NSK8mzKpta+CWxNN2CvSUNG4WK1pb9eBKB4i1l+94gmQAqmwvnh
         3R8PqleZT8faWiBx3IQ3lE4XKIus9IdQcrmsDs+cjrCmycM2BdKjP5aR4G3KHhRbU8Bq
         1JFSGPMleKDt1HjAEOhhWKlwfZ6VOSWDD9ArRi4Xs8fzmLiD2U2QL6EgBPYS2mFZQFGH
         vMldIWPzZIrPQ9jGN2iV4dcpeUECgyQDB4kP3w2Xlt1nJnwbyzMYfCNqOp9NR8ZpUVkv
         +Fow==
X-Gm-Message-State: AOJu0YwzYOZ3Cwmh66LnvdJse/bLO5LkmiEUi1v/9WAmd2QfB56+HAk5
	atiyeMjWpXgtMdcxhgSKNNr+Zr8IOkak6jOKGgqaihMfYQzQ0GynhkW3fRarJJOGnuLflhRRLkh
	U
X-Gm-Gg: ASbGnctRe4b+MZjpcoU+yI99y8ac9+GPE2vk4YA6bjzu9E04r8slQbmTJ/FUPav5yvT
	+WvdwOL9mBmW/GrodJSBQajlA7nwiDQSunRb7t1/jrbOauvTGomWka8HFhb+RjrjOBlWKKYT4mt
	QXs4YOLzocGsZIcZwz1aroGB8tlmt2tUog5X5Z0P2nA/g3yfH72aiuzTR4sfid9royq1JtuJybE
	XoaQXpxhilpfRi98kwjBNRE2RLROqBWqnE4JX5cewVmhbH0sxyqkjQPjrmVsENeuncdZWwaEKv8
	HWoYml6mJIqCCHyyGzxhc968tj0dtDvg1zU/
X-Google-Smtp-Source: AGHT+IEqM0lAeZ1YvJn+sckr/2hvQJNWJv4b2xidRXFlt9lffB81NHZ/43pI9cAWk3p6DxOSE09abg==
X-Received: by 2002:a05:6000:18a2:b0:382:4485:2dae with SMTP id ffacd0b85a97d-385c6ebefd8mr4521771f8f.25.1732748679371;
        Wed, 27 Nov 2024 15:04:39 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ccd3a71bsm74875f8f.55.2024.11.27.15.04.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:39 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 2/8] libmpathutil: change STATIC_BITFIELD to BITFIELD
Date: Thu, 28 Nov 2024 00:04:24 +0100
Message-ID: <20241127230430.139639-3-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241127230430.139639-1-mwilck@suse.com>
References: <20241127230430.139639-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A non-dynamically allocated bitfield doesn't have to have static
scope, it can also be a local variable on the stack. Change the macro such
that it can also be used for the latter case.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/util.h      | 8 ++++----
 libmultipath/discovery.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index b1772e3..df7f91e 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -91,15 +91,15 @@ struct bitfield {
 	bitfield_t bits[];
 };
 
-#define STATIC_BITFIELD(name, length)					\
-	static struct {							\
+#define BITFIELD(name, length)					\
+	struct {							\
 		unsigned int len;					\
 		bitfield_t bits[((length) - 1) / bits_per_slot + 1];	\
-	} __static__ ## name = {					\
+	} __storage_for__ ## name = {					\
 		.len = (length),					\
 		.bits = { 0, },						\
 	}; \
-	struct bitfield *name = (struct bitfield *)& __static__ ## name
+	struct bitfield *name = (struct bitfield *)& __storage_for__ ## name
 
 struct bitfield *alloc_bitfield(unsigned int maxbit);
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b585156..2be1f5a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -875,7 +875,7 @@ sysfs_set_nexus_loss_tmo(struct path *pp)
 static void
 scsi_tmo_error_msg(struct path *pp)
 {
-	STATIC_BITFIELD(bf, LAST_BUS_PROTOCOL_ID + 1);
+	static BITFIELD(bf, LAST_BUS_PROTOCOL_ID + 1);
 	STRBUF_ON_STACK(proto_buf);
 	unsigned int proto_id = bus_protocol_id(pp);
 
-- 
2.47.0

