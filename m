Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAAF54916
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 12:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709640370; cv=none; b=QEuu7+QxsXPen+GTmTXZvi4tUTHw5/GvtW/mdKmfuoOBM2VpgjjA9Yj73MGD4/XiqDB+0soeYaAUSR1O6tJvoVFOF0O4Vfm0uLCkYpUIy7ZDtKn68iMZqK8QnnrQX5Tc7D/wPXQAnQ4Hc0uhDg4IhQrO/1c4cU4auVg6mgc2onU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709640370; c=relaxed/simple;
	bh=q88AYD/alrtOPqwXRC5pFf8wi0MZs6r0G61o6jbCxtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnZq8JVt3IWJVWqdC2YWR93kaBAMLtaOqPRCrPSTXIzmjYPdmqI34lxDmxe7r52tRN1p05CH/BRtmr1N5J2PE5/JJY2QgCzfAwZpK/H1jT3ENMCvGxKcJHhINuiscG73G5XtC+uqCDR25xMi3v896WIC2KWIcIKoSc16sTCDCxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I68crrst; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I68crrst"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-33e383546c1so1054063f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 04:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709640366; x=1710245166; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PrPpIRlMpe62OymWcz7BCmTnufGdGNbV1lkhPbWpNUM=;
        b=I68crrstmh0uNA/GyNvFfonMJ0MVCT0yckdoozP/smFvcgFwbtlHnQTxwZcxuI/T5/
         b4woTRpF5OZjNS563kYUvmyn0yHsbBUgmro3Adob92rIpVFY39b9GrakPaQS7KY9H0b/
         qidY8otqgkpxA92G0E/A8li4rBmV+lN13Ylka0xv456V9pjXVqIAz2nRRN08XuDQi44Z
         NUlOZ0AfuJnDyziBKZh2MeztiHQpa9282kABEV8NUmn2UAGLUljwoTSpSYq+lMak0TF8
         Dg09ZrhGXNe5LX+ytSZqO6/d+jqBLVJPeq+rxFtmT0zmlVOOF8+V5Us5IiLR9eMzY40X
         3g/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709640366; x=1710245166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PrPpIRlMpe62OymWcz7BCmTnufGdGNbV1lkhPbWpNUM=;
        b=TMTYmO01F3ArNcoeQRwE93A33rbHGIdQZOVJu2TgzqGQqb3HJd3tLB0qeE7ecV1IGm
         w9gpeqRSZoC2qe/w4gRji2fVwAX78NsuZitlhPAyMT8KHOjFp7tG9GCZ9tJ3NDx+dHH9
         Z3Y7qzCCSJtsN+cpFbAI0sfruIcMklMuWFod83yT7qpsh5BwWE5aAsagsCBhbfdqi5Fz
         FMuzxGt875roLtnz4XYTsQj7M03YOg9TAYP6DUuhBtT77xS9VhM4vzVEwNDoiZrDxmS9
         htoXDPLeK8oX5e41O8ntwWHLLD9DeErpP7PsBEZ5zLukPdAt0iawyZZyiZufoc5yjwpt
         99ew==
X-Forwarded-Encrypted: i=1; AJvYcCUOlm2w5CJNWbAfJksBH4o/g8HfpGiIBSA/uSjwZz9PKBx+hhJslyLRGBWHYH+usl4Oc9Zjrc5BPrWj4avfZKVpSlkw2yxTPf4=
X-Gm-Message-State: AOJu0YzvML1NHSHHc2+AM4cMeeH0mvl0S3IElth4W0HAMAQRLhKvj7fU
	LdlpnEHEefvwtq/gTi5DU+y+U5wUsv/B73hPDrpy5rhwx9C1cuSRCLC7nqCHFrY=
X-Google-Smtp-Source: AGHT+IGTQ/kTzjprM1YKCSlk90efqzFAUHsOTxtWSGkCHHeDdihwDjv28BcmF0yEJsaieVkyIAd3QQ==
X-Received: by 2002:a05:6000:4e9:b0:33d:f3c4:6002 with SMTP id cr9-20020a05600004e900b0033df3c46002mr8703086wrb.1.1709640366347;
        Tue, 05 Mar 2024 04:06:06 -0800 (PST)
Received: from localhost ([2001:470:6d:10f7:9114:d168:fb53:9a37])
        by smtp.gmail.com with UTF8SMTPSA id n13-20020a5d4c4d000000b0033cfa00e497sm14757266wrt.64.2024.03.05.04.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 04:06:06 -0800 (PST)
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
Subject: [PATCH v2 1/7] 13-dm-disk.rules: import ID_FS_TYPE
Date: Tue,  5 Mar 2024 13:05:44 +0100
Message-ID: <20240305120550.11617-2-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240305120550.11617-1-mwilck@suse.com>
References: <20240305120550.11617-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ID_FS_TYPE is the most important udev property for most follow-up
rules. It must be imported from the udev db if blkid can't be run.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 udev/13-dm-disk.rules.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/udev/13-dm-disk.rules.in b/udev/13-dm-disk.rules.in
index dca00bc..eaad972 100644
--- a/udev/13-dm-disk.rules.in
+++ b/udev/13-dm-disk.rules.in
@@ -26,6 +26,7 @@ ENV{DM_NOSCAN}=="1", GOTO="dm_watch"
 GOTO="dm_link"
 
 LABEL="dm_import"
+IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
 IMPORT{db}="ID_FS_UUID_ENC"
 IMPORT{db}="ID_FS_LABEL_ENC"
-- 
2.43.2

