Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC6204088
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748684; cv=none; b=Gz+n+r+lUGMDS4wF7J1qoB537dbxspd2bhR1kFnWi0TUjlUUu+0vBionYaSxC8bpyONxo6faIpBW8IWdxwnQrpL6PtV3yv2s/4wUrd4MavqU3hewnxg5KYhIzakBEvG8XNO8FdwuMzL9OGLar6QDlIR2ixwcObrEaIJe2fdn76g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748684; c=relaxed/simple;
	bh=sUIxznycnwi1m4nI8M0HKXt9hyXo6YgNy8VyZ3WmGIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mV/DQcuM7vFKTW93K51eYttYFenlQ1Ha1foOsq4mpcJu5pw43QoCcXl9Wa1N4GrPwmcOKpmJxmHJoWxnMiXfamBZimnBvOemWdfCyLhcoJ2pC6lI28uAMGoZwB05sS8vF7wkFzxY9M1i6W4OLOryNLtCAdc8MOMv0rNpHIhmNiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UuS0HAtR; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UuS0HAtR"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434a752140eso1535535e9.3
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748680; x=1733353480; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uv2uUZ0sjLsGvtiky7aXyhDgrUtNOPpcenjftxXZL28=;
        b=UuS0HAtRzGIavHoej0vGuGZrUS1UF/F8TL38+hpcQp0OsPNkDuDySNskTByGVLDyat
         EBOFfNd1+vXbP7/2e7H5yzubHhqhXvxT0wnN0YkfiG2iypOw0ix4DSGfqtK9O4SUY7eB
         O9Xg2bZj1PdeuZJsgxO/u3WGVtyGrcnUAjJxT6rHcmnpq2TT/Az8kNCdeHKJ8LsoO+e0
         W0nb0wT6AWz03ydYdttQwUrbIqvkvvIfjkmtcovbQicke71tJUQzm2/QMDLPakVfFa9v
         dZSPshZ4LtC8T9eGqkHsfYnLkMNBhbDJdGE05gkJ4/XxsxmJDH/9qqn9on+LDoN4puMF
         MNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748680; x=1733353480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uv2uUZ0sjLsGvtiky7aXyhDgrUtNOPpcenjftxXZL28=;
        b=cMAS21OoXfEjQ2gpSZ3yXEQtLkjBdR2cSgyvuLBqUpd3QKdprb/Bpw5DA07lzK/KJS
         2me+a9CnMoT+8OnMfZOCvOIRa3lMEE5bhDn8Ywxqme4fd57G+jSh2KT1PSw4TTDLkHiT
         6PJpSV3rQVoyYnpiga/YB6h55SmZHon6jQEfjr89rU7O469xxRUxM1vl7OHb0BRb7IfV
         +Kr1hqtHWRPn5jWzxuITywpyw+KJGFIW+6q5GNSyWatRhQKtem3JUSsmrRg8cusxdN76
         2ji2WF4kf9AQyzF66d9pCTmtwYkgZOBg032YNn7/YbEthCsTrIDKGNGbYhxD+Pn4TtMc
         ZQOg==
X-Gm-Message-State: AOJu0Yx3owAsh1z0FcAp/3EIt3hCA6xfzaCk2ohtPPlPRdkmS2bgeoxG
	7fb6G37jrUFEOn9fEPnmTxOGFDbY2an9Nr2PN5Pi2rpVI0atmq207oWKEJJk8e7xx6BgGst2JbV
	w
X-Gm-Gg: ASbGncv+LzgJFYdRuu0V3sGCTahRBZ+bhEZZCU1QESviSQ2+BZoeQUpoEnyxLveVRjx
	JS0bRwn1t5X/PfOzmj9EgiwrCqEaQ5oLHkPVnqFp/1x2B9OBJhE74pxsJmu1ZebOKNCviDXhgXW
	Zhu4Pu5lBoYTsb4KBapxLPuCQodhhvu17fBaz8NLdCzP77BMmSR1eh+A20Az3A3Uv4HoC0tbV2k
	ACwtC662tlf2/d0JMMvVGkYiKRHiXq+6l42NMSN5CpKQPxde+nPulqPa/IViFf8uacdSeXmVS9v
	+1OnATPX+j7/tz1qWLA+XcTJD08J9hhjdFDA
X-Google-Smtp-Source: AGHT+IHSGYTh4cW+yfJMl/X4qcOCBSClQPRkXKueBQUcqVIzMEXD0O6CAfe324LWQ+qQZvoG476dOQ==
X-Received: by 2002:a5d:59af:0:b0:382:5088:9372 with SMTP id ffacd0b85a97d-385c6ed7667mr3899103f8f.43.1732748680380;
        Wed, 27 Nov 2024 15:04:40 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ccd36a02sm76993f8f.37.2024.11.27.15.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:40 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 3/8] libmpathutil: add cleanup_bitfield()
Date: Thu, 28 Nov 2024 00:04:25 +0100
Message-ID: <20241127230430.139639-4-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/libmpathutil.version | 1 +
 libmpathutil/util.c               | 5 +++++
 libmpathutil/util.h               | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index fb92f72..14aa083 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -51,6 +51,7 @@ global:
 	append_strbuf_str__;
 	append_strbuf_quoted;
 	basenamecpy;
+	cleanup_bitfield;
 	cleanup_charp;
 	cleanup_fclose;
 	cleanup_fd_ptr;
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 1255974..38e984f 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -337,6 +337,11 @@ void cleanup_fclose(void *p)
 		fclose(p);
 }
 
+void cleanup_bitfield(struct bitfield **p)
+{
+	free(*p);
+}
+
 struct bitfield *alloc_bitfield(unsigned int maxbit)
 {
 	unsigned int n;
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index df7f91e..3799fd4 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -146,5 +146,5 @@ static inline void clear_bit_in_bitfield(unsigned int bit, struct bitfield *bf)
 void cleanup_charp(char **p);
 void cleanup_ucharp(unsigned char **p);
 void cleanup_udev_device(struct udev_device **udd);
-
+void cleanup_bitfield(struct bitfield **p);
 #endif /* UTIL_H_INCLUDED */
-- 
2.47.0

