Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2805F477
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 22:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709332854; cv=none; b=cNfvtNqoDzs8s5uZJxougm+/+wVQFa+CAP6MYyrGD187ZQ2kO+uKdmg8IAo0/QJ3HNmLRUdTR26wbk1YVCIQ0bqcemuAjGA44iwMlS94DszAR8jZrpn8UnlLotIeRvUu+3rFBEdZ9DGw82vmRQwB7ox3M4P+H7U8U6Lr5eDJSBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709332854; c=relaxed/simple;
	bh=ZV6E4CLPDk2EukFXwIpi27sxbLWDB5ZXkhqBEryg4JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAf7SPf1M0b1Js4+rzDmcgzw2pM8ALCxs/2xUPDqNoGc31v73ZkmmwMjyv4FnLi5W29ZFJJvb5SHkOOKHmJAzAUiGi+6c96Mio/o+94N456Fn9TmG+iync4YXNSlEKGPy2swPr47sVGAYaqBVEz5lQ7F0MZuxA+Cx+94iinYeqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CR5W44Xx; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CR5W44Xx"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-55a5e7fa471so4239777a12.1
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 14:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709332851; x=1709937651; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjX7L1hpwAL+jfR+2gxXb8+BTyRmg8ixtQJ2jnxejR8=;
        b=CR5W44XxvM0NCwP9iNDfORY38fRxlF9lRcQCgpatyBfb11qLB7NbUYJXnMZiuL3e3i
         RiVFHUuIb1RbbI50K0mwmWLa6C224v4vgrQbcxt5naJcVnSsKgcIcoC/RU8kl+6Hm7TJ
         FVRVhXv4WLWij6/pM/Z4BqrDos+FSoQHlbY59vAQlTo50q+abXC3AdJZS80IwxCYO+ez
         bDGe7O6rz3AvgURrZwFAdRnTFBuKHUDlula+v0b4Kzvlbo46NbRLgsQRFfDkq6ozUzng
         uEh3OSBCvPAXPEUYPrwQNb2e8MyiBSsWwp1A03Jitxm8IQt6JqjIafIGrx9/6f+oVf5g
         nVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709332851; x=1709937651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PjX7L1hpwAL+jfR+2gxXb8+BTyRmg8ixtQJ2jnxejR8=;
        b=QUNxgJn6RP1Shn5Vpke8rxUXjVsCM28aRPPyZjaZIrcGywQMFY6IgPV/XrmSpesxns
         ZeJvLKRzgZy1Uyfo9++7dGk6SzbOeEKATXheVxAkHBD3FypHcejiCXM0tq3bSZM7JhBJ
         HP9mUmV7IafN+kdIWCTCVBgpEmpLFMOLrO9tFxno2ReL/IgHPow3Dul4HiFU3dwUJnEs
         rcN3a+7/1+rtXd0gghcWbwbqj+n7bdgeMIRj1AvhxSOZMw0xuoLSbIYggCRN/l8lev8n
         7wurDhlev69Blalnmigj8PVow0+N603C9UnF8yVZFP2JaJ9EdtZHTNZB9n6D0XND624B
         g8cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpulokylke7xDBwzxzTO8IvozyGnSUEg5RblkJB7a/UfXFqa5+AbvTbekHmVQL7hm81nwIZEa89WT2/2qPqNVvDzzn3Bpeads=
X-Gm-Message-State: AOJu0YyIFbux7X8zXX3U04LJGcDpvOEgSWhl4zDpsy0b9fGbl2P+aCH5
	6PvzUfvnz0urpQtO+YdjBIxKyTIf8nJ+z5uQA/nJ7XGz2fyIY4seou8IH1dwRME=
X-Google-Smtp-Source: AGHT+IEH16G+DS2mezlyjORY2/CQlH9B6Xr0t4pBsiXlXvWvgl+di7wDEXeL0l6Mnj2RV49Z+lmBWQ==
X-Received: by 2002:a17:906:a2cf:b0:a3f:33b2:5ce2 with SMTP id by15-20020a170906a2cf00b00a3f33b25ce2mr2347365ejb.35.1709332850860;
        Fri, 01 Mar 2024 14:40:50 -0800 (PST)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id mf18-20020a170906cb9200b00a44729f4e31sm1282637ejb.26.2024.03.01.14.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 14:40:50 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Peter Rajnoha <prajnoha@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Teigland <teigland@redhat.com>
Cc: linux-lvm@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [RFC PATCH 7/7] 10-dm.rules: bump DM_UDEV_RULES_VSN to 3
Date: Fri,  1 Mar 2024 23:40:11 +0100
Message-ID: <20240301224011.11117-8-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240301224011.11117-1-mwilck@suse.com>
References: <20240301224011.11117-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bump the rules version in order to indicate that upper level rules
should consume DM_UDEV_DISABLE_OTHER_RULES_FLAG rather than DM_NOSCAN
and DM_SUSPENDED.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev/10-dm.rules.in | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/udev/10-dm.rules.in b/udev/10-dm.rules.in
index d30f663..21bbcb0 100644
--- a/udev/10-dm.rules.in
+++ b/udev/10-dm.rules.in
@@ -136,7 +136,9 @@ LABEL="dm_suspended_set"
 # possible future changes.
 # VSN 1 - original rules
 # VSN 2 - add support for synthesized events
-ENV{DM_UDEV_RULES_VSN}="2"
+# VSN 3 - use DM_UDEV_DISABLE_OTHER_RULES_FLAG as the only "API"
+#         to be consumed by non-dm rules.
+ENV{DM_UDEV_RULES_VSN}="3"
 
 ENV{DM_UDEV_DISABLE_DM_RULES_FLAG}!="1", ENV{DM_NAME}=="?*", SYMLINK+="(DM_DIR)/$env{DM_NAME}"
 
-- 
2.43.2

