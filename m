Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C073A7BB1F
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 16:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707497731; cv=none; b=NSJgGtTb91xTOig808RhAaOE7OG7TQdbbXBBbHL4H+8gLw8IZMdOJeiUFNCk2smiE2BKycVmqH74lgiCbS4zxo76D47UpncKcT6zF2KKJ7EjXPNO46ElmlKntTsq1WFZV/uLGh5KCESyrsOJmV2qOhbm0Xt3J/NrCp8XaQDxbtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707497731; c=relaxed/simple;
	bh=fwzURjxFbzGZIw4dknM4g9VoHn4RkQW/v7GQ9teO0zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJh5EqCrrckLG8NK9tOxz/yYZze6HjcLDFYFdDZ7GX8QxhSLnvui7kOiJRUZM14OoK1qzxYS6oll1/1k5/T9vbZh0/oRXOpKdAiEAy32VP4WepjcSQFFqr8+Ycd3WuOiKE635J3/uvm/L1TFJw6WnnTK1vWSkr2ZEwLaEBfHGWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q5ehqAgw; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q5ehqAgw"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-33b4b121e28so513195f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Feb 2024 08:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1707497727; x=1708102527; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahhAHgV8/qnedlLprsRgwv7yIEBhybb7qNVa4QZ49XA=;
        b=Q5ehqAgw7YgYRn4/hkep438hAkChQ19h0tBQiOAPXv1QGsUh4A/td/vd9gIDulDPFH
         20NOgNRSsL6P+TKgJbngdCATtJZ/S7x2HEqowjw9qj3zwg1V7w+5MDhxJRRwyICf1mZ8
         zNuzpP32VBjvuUjtfzZy1QfiNdADHdkF/NDUoZbL1nGnqxuGLJHis85Le+bwn7ezny41
         EGARDFqhILLJ44sgwu99OoltM7PaRjK9518sXnBP6GgiRsoAOb22u/dWnMFvNpraBu2i
         by1RNvASOclbvMleMTh6AO4fBepKapuuwe1KvOKeuJZbe43LxvuvM54r5MQyv3rAQMQC
         O0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707497727; x=1708102527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahhAHgV8/qnedlLprsRgwv7yIEBhybb7qNVa4QZ49XA=;
        b=QNmaKwCe8YjwsXM6bR7kGeVOmNj9cP7v4rUkxaJQpTqq9DtNJt3QwLu3Yxmtkqo8u0
         4O1EangoMEBCOx65dyW33Q8bEON3XLq1GTeq8BQSxuIlTwLMdgqcjbAdImU0Tfl8vav0
         TctPMDk6W8bETiq0JVCjJu4IDda/m8ib2hVcEFsSoXQNVZTq3bhgS5Zy8sBF9nQunMZQ
         FviWurgf8vseRx+A0Vh+ALDD8Fb9JcQqT2f0//prDXqB+nF8pozHLl+oBUpwCGhPimWZ
         QV8ltz7D1YMN0Qk7JpdOcvKpjKBDQyMvI3sO9VoKckP/jhQWWbpvuur1VDDWOuGbfGKr
         gqCA==
X-Gm-Message-State: AOJu0YzdDAghzeKFM6BueNz/cgBHQFxuT+9cYtU3Jhf0EL4ZgktPH91L
	r73nhUMPAimpB/evBE/Ia5rNmEEsTJ2p7Q8wg/+udcFtY6X8BxgNDiLVihPEwTQ=
X-Google-Smtp-Source: AGHT+IF/qxyZuozmX5MCZBtD7G7Ss97VrOm7ebcbna9t+1hUdnd8fFMQ1788TxcrKVup6kArDCuc+w==
X-Received: by 2002:a5d:6550:0:b0:33b:4acb:9999 with SMTP id z16-20020a5d6550000000b0033b4acb9999mr1399208wrv.44.1707497726972;
        Fri, 09 Feb 2024 08:55:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVWBlJKmLXs55l9qo9Lm5eOcgnNnD0vMYN6N9D1xrAfUjUupC7t1aIM/7xazJ+dGBFh5V2pNKny5PuMkHMWjecMf1JXmM2zijvND04Gg0rGiEqcTdJH2dPdJgueQ5oE43TwVD6WC1seFZbSH4AypUc6AvpHSBCr3cp/SPvTc+ZVW+XTPmNVBu+m
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id ba1-20020a0560001c0100b0033b45bdb2a1sm2337464wrb.4.2024.02.09.08.55.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 08:55:26 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-lvm@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH 2/6] 11-dm-mpath.rules: don't import properties that are already set
Date: Fri,  9 Feb 2024 17:55:09 +0100
Message-ID: <20240209165513.7661-3-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240209165513.7661-1-mwilck@suse.com>
References: <20240209165513.7661-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DM_UDEV_DISABLE_OTHER_RULES_FLAG is handled by 10-dm.rules, which imports
it from db if necessary. There is no need to do this again here.

DM_NOSCAN may be already set from previous rules, e.g. if the device is
suspended. Make sure we don't overwrite it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index e7be12d..05c4294 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -7,7 +7,13 @@ IMPORT{db}="MPATH_DEVICE_READY"
 
 # If this uevent didn't come from dm, don't try to update the
 # device state
-ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
+ENV{DM_COOKIE}=="?*", GOTO="check_ready"
+ENV{DM_ACTION}=="PATH_*", GOTO="check_ready"
+
+ENV{DM_NOSCAN}!="?*", IMPORT{db}="DM_NOSCAN"
+GOTO="scan_import"
+
+LABEL="check_ready"
 
 ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 
-- 
2.43.0

