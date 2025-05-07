Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F89028AAE9
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644780; cv=none; b=oypKS/QDrooYQPc+SwFUsSdH3VSP+hf+EQLDLR6GS8QWz75lxR81FIzNtSBf9AzDgWsXfgxYgRE2nK6sCPCbaQNGiP5bx8izRcEpy+JSLUz6e3HqZf/JsuoPraVYYeGGB0yUdE5bLatWp5/X/gO+YGnqLQ+X7JVplXEPCmdcLDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644780; c=relaxed/simple;
	bh=j0kg0YVgVn9A75mrqV9yqSRglSF0d3X5z5ynp8CKuko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw9QLaLVgJ91ACR3j+YqiNaVO25/qf8skzaXtGatLpHeEMykdmok+wv0sEHxi9PFnnEpXuJSqGYPeuMvRnkgNeX5m24DigWGl0qUnU5bnhnTtS5Oj9NezP/pyrIUUZ6oYL52C1e0D22z5LDYyrUsW0NhbrgErz7uPEQT7B1DUtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=b2g8+WLL; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="b2g8+WLL"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a0b9af89f2so98743f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644776; x=1747249576; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9pjwglJvv6DSvSS/Z9AgQyRjv5gc6QXN9Oz4WGQ5nQs=;
        b=b2g8+WLLs3RJQuEFX9ntj/WUrl+rR3eynEA0/BoHS8JtzDPeWJFPmuJavRvOCojMIl
         Il2ARKB9i5BgF9j4qtEZ/GgIlGSpOqTcJ8T/y5p+4zItoHJeC0LJPS40p+I8ESBcWm+G
         PDizliVBaaVvKAcP6/GhgppCIyh7Cw4bz+syu74R0FlPD6t4F+nGlMwwzBuYOCIpE5Z7
         9sCELwEQSntVK/upxfwurjsJHeXMbdPj+/v2hIPs6ZLUUYOB+OQjCruPUtZCIIBO143K
         mFa+Tzo5Wu4DsMNaxyWYA9RQyb6GxxN9k9J/iZ/qPOfpjB8D6GVnr7MRFTo92rralR/W
         3tLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644776; x=1747249576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pjwglJvv6DSvSS/Z9AgQyRjv5gc6QXN9Oz4WGQ5nQs=;
        b=QRAWmeVpAVUfqNImk+pHL8gFNJD+d5dupEu4o2yenkgnilfhxg9hAiU11qF1M06m+3
         YQ3eTsmqWMenJqQ3cDD1k26m/znHDhfFs3Q+UmmVUikSvc7qK6Utu3lTW4r9AVIkpH07
         rrcgr0vlD4FDn1jKB+yBPRvU/JbSS2eIjNzCd7Y/7zsPedTF+zhU5xxIXWrHVpC6fTcI
         xScL6nukAABG1yCIL3mNrqfw4053e7BA42kfWy5gLg9HLCmTngLY47uAiW+R9XZSNG5C
         uMh0U6U+bEwpiQIj3hi4X2UjcR+fpa7kid97U6wmQXwwRq2jRQXM7uEvhxjt44PfV2a6
         0TOw==
X-Forwarded-Encrypted: i=1; AJvYcCXCB7b34hdQANMM0ls+7cVygt+vWwfe1WIX5twF3aiLvS2y12oi0ZYe2G8ciEvS2eURDKEvb+PUIQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxZXvwzuOoeNmogM8lmSLuRqWuyEdX/b6ilKXOpHELBb+JlPAoN
	KkCEifKFiwB4Oc80/4RPM5G9XGUDNc84WecHU1U8xbXbSa2sFpOyae23ONwAbyc=
X-Gm-Gg: ASbGncudzij9RWjeoGlDW14a8zppwJQEqHDYmQLmTlThv9V2MAkdQ6RQaAujp/G3AJp
	mWusXy0j3h3tcsfNSh4vnLsxtPDscrQj/eQgu0JsnNECfvOnUA+AOxyc/bBMXES7ugZUmKlHX+4
	x3ZLLEkNgmwuuaH1dNE2uH8No5cBhRk6s5lCXyjCYTOMxuDv9wuJnrLyKSiUikDoXiI/upbH6ms
	hHWUCsTSKe0QEAXcX71Dgszc23rOeeW5XAH13v1CuqnJ3rOaF9TW/nnXoGZ2wsVD3RpI8pq+7ko
	OniOWrzoknAstN2a5wvgm6F9w9kuK4uFXivohuhgh03tbf2IL8kqiKyncRYgA/v++MqGjiNIWY/
	lPDAsp/ple0ava/e6UhHndtnR4KGm
X-Google-Smtp-Source: AGHT+IHibeeaGJ9N73IBFTHIlqE4ozxYWZ+GRzXk3bscjehdnqNJCxkLtK4rKbnot+4iQcwxjf4d9w==
X-Received: by 2002:a5d:5f45:0:b0:399:71d4:a2 with SMTP id ffacd0b85a97d-3a0b4a0504cmr3849940f8f.14.1746644775607;
        Wed, 07 May 2025 12:06:15 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a0adceddb5sm5945944f8f.2.2025.05.07.12.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:15 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 1/8] kpartx_id: fix shellcheck reported errors
Date: Wed,  7 May 2025 21:05:45 +0200
Message-ID: <20250507190552.209637-2-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507190552.209637-1-mwilck@suse.com>
References: <20250507190552.209637-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Found by Fedora's static analysis [1].

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html#def41

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx_id | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index f9211d2..ffd3424 100755
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -25,7 +25,7 @@ MAJOR=$1
 MINOR=$2
 UUID=$3
 
-if [ -z "$MAJOR" -o -z "$MINOR" ]; then
+if [ -z "$MAJOR" ] || [ -z "$MINOR" ]; then
     echo "usage: $0 major minor UUID"
     exit 1;
 fi
@@ -53,13 +53,13 @@ fi
 # Set the name of the table. We're only interested in dmraid,
 # multipath, and kpartx tables; everything else is ignored.
 if [ "$dmtbl" = "part" ] ; then
-    dmname=$($DMSETUP info  -c --noheadings -o name -u $dmuuid)
+    dmname=$($DMSETUP info  -c --noheadings -o name -u "$dmuuid")
     echo "DM_MPATH=$dmname"
     # We need the dependencies of the parent table to figure out
     # the type if the parent is a multipath table
     case "$dmuuid" in
 	mpath-*)
-	    dmdeps=$($DMSETUP deps -u $dmuuid)
+	    dmdeps=$($DMSETUP deps -u "$dmuuid")
 	    dmserial=${dmuuid#mpath-}
 	    ;;
     esac
@@ -67,7 +67,7 @@ elif [ "$dmtbl" = "mpath" ] ; then
     dmname="$dmuuid"
     dmserial="$dmuuid"
     # We need the dependencies of the table to figure out the type
-    dmdeps=$($DMSETUP deps -u $UUID)
+    dmdeps=$($DMSETUP deps -u "$UUID")
 fi
 
 [ -n "$dmpart" ] && echo "DM_PART=$dmpart"
-- 
2.49.0

