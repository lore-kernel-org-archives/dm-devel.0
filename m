Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B37A18FDD2
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130813; cv=none; b=nAHGZhSVrLY+0yIGBf0fZul7AYiDkXAspnB7ySS4qs7EUC4AOFb1ofElDmUAxQpKFkjT4k2jTowKVNl/EyCmYEJbrRWH6m7APJTYgAZNtBpH1iR0r8gzCkgJ5xi6nxn0vB4nHwXOPOPwEiiSDR2k57aNfAjEw+sV1OmkEQq7ijw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130813; c=relaxed/simple;
	bh=ZGIC2vwdsAKD3LK+rVf/UFpikWuKUI6/SFIXkX62DiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKN12lr+ERuDGhNwYQdCwSYa/f6axjtvDpBLyFUkqGIotLP3cNd6iA6rIgLseBMpebeGqBZTjhmnD547vzaPADRLy3HWgB5UTK0/jMZFpG/zSMqgJ2cO3jk3+xHZRt3nIR/lzJxCn1gUV0pHGlIyur2V/cOSwkTrhpv5jpWc0h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DbONJxe8; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DbONJxe8"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52efdf02d13so2116321e87.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130809; x=1723735609; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6YS2D2F9Pdcdo+1QmDkzHTo31YPudmWuRyCmu8HhRVU=;
        b=DbONJxe8n5SEukV+LdG8/9PECfgcbpzbYRE/+lmDm1J/90txbHJr2+b5KSpnRcIXUW
         QDEeXQXIowT0xviqql48RKa9seo5GPBDtb7FeUiLrBj2etID6R55uzM4UyZ47E/xPuo/
         ndPiPycFolbwCGG6K25kE+y8rEHAFvo7VogwboGOur6Z2jCeikxPgl8/L0tacVqksxbQ
         WEAhykvs92I/PPUIEny2s+Awf8qtY2JZJfCDjeNuvyCGB/0hBpuNrVy6pAt+00iWocf9
         +KzWicVXrP9DNMtcJd2L1GXQT32k/xwUMLx66mbjbGANHFw17rlU9BgXfLvQLD5fAXVP
         PDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130809; x=1723735609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6YS2D2F9Pdcdo+1QmDkzHTo31YPudmWuRyCmu8HhRVU=;
        b=Bx3MwLavJcWW8plhh1Iisge0aB+7T3bcUFd7NjUT340UkAqV8YveskksGiWcArC//+
         96s8vlqYa0RtOpO3SO6lVrY+pP93YQMPjuMAsKUsxjy/cWZQYvJWms0hA6DOJqNuTHw9
         mMpmmha7IaJNSrM9wYuBCZkA1aqTzhf+EcuL7JpCH7TH3GvUryXjVwMF52lWktRi4QPQ
         WRM/DptSdquhevH3r9De35lD6suy26TVgitcVp8HwieI6LyvLciIOiMgWDm7jun8buoa
         Bz43P3KMgtDsfaVWoiY1pWKGfLkxBP8r/vy7KnU7wZ3NWVVSKn/fFYv7fw6QBjdiWHQS
         gihw==
X-Gm-Message-State: AOJu0Yytakuqf4k12vVr12G/qYjmRzY6aaDV9fsO8noCrpFUbV3A/Z7c
	mqY7eiKQ9kMKwhIsLhC6dWVFvEJkabjK81EQcjJtKaH3All2xAbqNlhaa438Ur0=
X-Google-Smtp-Source: AGHT+IE8w8t50ZhuVnk4q/q2rI+06Ywh7098DTUsMMjcIZdUP2AoIm76oSA06Q5rdpxl7sepTMNSDw==
X-Received: by 2002:a05:6512:318d:b0:52e:d0f8:2d43 with SMTP id 2adb3069b0e04-530e58207d0mr1774045e87.17.1723130809070;
        Thu, 08 Aug 2024 08:26:49 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9ec8879sm754726866b.211.2024.08.08.08.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:48 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 15/41] libmultipath: checkers.h: fix __CHECKER_FIRST_MSG in comment
Date: Thu,  8 Aug 2024 17:25:54 +0200
Message-ID: <20240808152620.93965-16-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 51ceea0..102351f 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -194,7 +194,7 @@ void *libcheck_thread(struct checker_context *ctx);
  * message IDs.
  * Message IDs available to checkers start at CHECKER_FIRST_MSG.
  * The msgtable array is 0-based, i.e. msgtable[0] is the message
- * for msgid == __CHECKER_FIRST_MSG.
+ * for msgid == CHECKER_FIRST_MSG.
  * The table ends with a NULL element.
  */
 extern const char *libcheck_msgtable[];
-- 
2.46.0

