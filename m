Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602378;
	b=Ffy/MYYnghbv7/ghpa/PXNdAazos3KKsdNY3TASOdi0ti995Et1T6Xhacgv41ntlV0tI
	 zycjby5bxnvt/ykX7QQttLDh/aTnyeBkUBgPGchXsJz58zzwHiMAmh01X0Xj7f4y5IkiX
	 uxgprDtSkQMf7YmR62KzpHf1/fcAlzp00VGZKJGSGCwEMmDt8ZgzFpKFeNM6ukAHOTsfM
	 1FSj9vKhcx9P7SLx6OF2hxcXwQsTKlq7WXw+qMwNaHD6Ep92xzoO9K1dR9tYfmLzvRBgO
	 f7eQ4+w+YXShEIfnXESFIrfE/87Rg1PcvoPl76j+Q8JO7Cy2zZbRgW6qWhlbeKV456w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=7U7RJ9x8RIvrixSNkW5OczQh7ocmBzSc+FX1XZEPbN4=;
	b=YZQy7kARxoKutJn3TM9n1Wvuh5rQPL87smEYm6Scsraehp75l785Ww6pPhWUp0NahU2w
	 mO6OXn7X005bQLSXpiaTaedPMuzgRiEgf1ipLgTrLmajMWN46q0wfhNxVN2jTLqexJdBR
	 vvvy9QygSTN7HvdwbwkRC8x6YYhHd6n7yFqC27edSlC0+GUBO0i3qbytRrRdkxIM4/KRI
	 RHc17XbF0FGWIXUAsP4NJjQ24GIJsYRrOzvXun7A0RfZ8j3dDIvW9xAN4aP920xL+lonI
	 UzTocM1vdLVHRSugTvETOqtkbwdg0zvlWc9tAkVwMB0IsVn1aRXtcsI58FayvQK/Byg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0egbhFQc;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D60E606A32E
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D60E606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0egbhFQc
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4a8eed31158so464686f8f.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602375; x=1796207175; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7U7RJ9x8RIvrixSNkW5OczQh7ocmBzSc+FX1XZEPbN4=;
        b=0egbhFQcCQRmjF5LQFE2QrlyErcIcK21f8K5ZpELh5zbrO3R6l1HbOAFoyqupGxUkH
         wM9/13k9kCmDjHDoXMu7/SvNzRzjbAP/WAOvi77sG4Hz0piEJTJt6HiTLPBK3fndUvJb
         L9nmQZ0ucMpYr4ZzdHH4L4/kJepbFTs6Sio8CZA9ym4RLUrgBzgwug5wjfPUUbJv3apm
         9dGkiY150u0MygaWSmEypl5ETEjDAM7KmNO2QzoZTcZQGB5SEv+qSL4yQYf/IeFOF9uq
         zhbpYCzx6cQ86k4G7RKPW0qrQnnGs0oDEcDpuLPH5VEeZMUF3aLk/WtDRMO3SgLX797q
         Yb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602375; x=1796207175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7U7RJ9x8RIvrixSNkW5OczQh7ocmBzSc+FX1XZEPbN4=;
        b=khKHIUKjWmLWm6ABSfr4o+fv53NhHzOdQVexgrXENV4RN/4hfopiTGAF1ygLILWmrF
         qMVtntz2HT7i+P7RklttfotJ7xpbH9Fc1IHxExS74bxSuHYNXcbZAobgOl9QW2SgOxny
         GlZsabfKXlCGnLjZSAl9RrFaz6f1QpxoFaUdNmjDRZaJwehbLZEKhpNl3VIHoko+m8sn
         t8h2GdNzx8w1llbyS06VMN+s/wjo7/JwB7MFGAxH85i9G5ZRSVjLwjqe9IKgL3blff28
         VAqIYmThukRFk52tpZJRSzsKcQAQXPz2P3CDIIC/Q158l2ukd2+AArovG54jBibxiFG5
         JODw==
X-Forwarded-Encrypted: i=1; AL+hErGAR08wYoje5oS0cI217Grx70zRNGFyRxsUzxsHgTZy+igVWUNyMDIKMZKZOFFhiWfKzE3ZVpHWyA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+ILJ2eeZiHwMDT7wTcOz0osDwd2AQED/4jGF925SjmKVg86cFw
	4QjHHBKlMDqQnDkmCEKycXmzGq5WAqD5CaB4efdPcqYAVSAtvth7gYyArpgi0jA=
X-Gm-Gg: AZFdTZcgXQIW17rJ/jl2osnlH8torJUvjQ2xGDLIhsyU80okozugPxZGs11NDsXAxiP
	IGbdaEStbUKVNP/SOMAstY6Eoe8ZLvrwet5R2Z/vLRM0LoPXRzdyJxbC0W1fJMaUi6UTMXxuuZd
	/tOzCXyvBWbkM0wDWphrREHt0X9PviTupgUQpig87cfwyIw+zwLuLE+GUBr4dsf/UqI2AXHxOiL
	+63RaqSuxrdYDFOAOvx85E2yjnTrXfjPoDflLQqYi0DWmgGZW7TKp5ubDpI/YYt0odiiDRyXdm/
	tBWpv8T8DZE94CaJ40MfSjjaMKsxjLJNEylLGLvYGnbe9qH8b+2tty3viBvmqEj80Xs5dObF+1X
	jhv1tc7bEt/t3K6/v8TLQCEmdEqIq43StomSaB5g7ZI1hukPm7CRABWBeEnRxsgOBm0fg1oFlfJ
	1qydW9BUqf8RmIo6VwLyilKeTyFvOQf3HeSII4Pd/y7uPi0uI8Z4g4DBnaC+krXWeEwYdbXe+Gf
	YtYwnEH8dHETR/y1YM9OX/ZMe/oHfbiUmcuNBvvhwmbTkIv3J2MpGS0QtZ0JGD8mEXtKgGKillQ
	r/D4WRtwUA6TWL0XxmDns6XcQZUtqshC0FAIggtu1jwvbVl9zJyDyRI36tiUyZXndkDXiz40KXn
	Et54eHggjQV0=
X-Received: by 2002:a05:600c:34c8:b0:4bb:a792:80f7 with SMTP id 5b1f17b1804b1-4bba792818amr18066465e9.0.1795602375544;
        Wed, 25 Nov 2026 02:26:15 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm411928545e9.0.2026.11.25.02.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:26:15 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 5/7] multipath-tools: multipathc: print version string on startup
Date: Wed, 25 Nov 2026 11:26:02 +0100
Message-ID: <20261125102605.82009-6-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102605.82009-1-xose.vazquez@gmail.com>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipathd/multipathc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/multipathc.c b/multipathd/multipathc.c
index cb3d6f87..bec6468d 100644
--- a/multipathd/multipathc.c
+++ b/multipathd/multipathc.c
@@ -16,6 +16,7 @@
 #include "util.h"
 #include "cli.h"
 #include "debug.h"
+#include "version.h"
 
 #ifdef USE_LIBEDIT
 #include <editline/readline.h>
@@ -297,6 +298,8 @@ int main (int argc, const char * const argv[])
 	int tmo = DEFAULT_REPLY_TIMEOUT + 100;
 	char *ep;
 
+	fprintf(stderr, VERSION_STRING);
+
 	if (argc > 2) {
 		fprintf(stderr, "Usage: %s [timeout]\n", argv[0]);
 		return 1;
-- 
2.56.1

