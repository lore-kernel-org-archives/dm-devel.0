Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42302038D6
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423762; cv=none; b=grkYJarnGd+GHUMr/oFOB2EaIsl+OwYJM3C3FcPXwCPSHeFjrPMXEBTZocNtIfS3WnviOVxX0xjpIUwVsXStegiWRXLryg02b+Uwd7QVDO5KBO7UpIpFMVSsONBph8pHBA9zW4QWMHivubC6Mp6BvPWJBuDG+t/cfm0m0EO+jVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423762; c=relaxed/simple;
	bh=gy8rx06hlELDWsNWF1BV4zSFyw2JKnUFKgUtELQKW3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGiC7HYjleOSZOGMt89gAAdUp5qH6BLoiuf9gpEEgHgoV1lEepL6pF4jwLhJfQkiDRJhWJqg80aO+j10nW4Oha9KzlA9wXhJogAKEFESzHIIij2lgTPDYaYqO9FHZg1POBxez/HEdPmLG8YIEt3Zghq8YC7u3jSPHR0WoZDldCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Py9V2mXo; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Py9V2mXo"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53d8c08cfc4so3167480e87.3
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423759; x=1732028559; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwOpU+9TAGmH+CHuX+QM5KopibTesgkhxmGrqFO+Fas=;
        b=Py9V2mXok/Uk+nCPjYz/+WAd7L6e6lx3Oo0hYQ1a3k9/d3W54n5smqxhBKOLPeRGQ9
         aIwvVZ7JUfmwLIzqxkMuerC9JEeZJmN+tYmQYooDJUz9UsKR2KXaoN1cP1cEctohIm6a
         17euz5sy63drLbxMmVaGWd0Q6KSA+9NpjxMGFuUZnpq9UocaKdKvFcT4A2R3HNB3Wuet
         saV5T9M8UVsNoLDzRqgKOCecS+d7H/GTX2MmuR/Qg3k1+mhgboOa2owek1zZpd2KqDxb
         XZLH9v9cLXzNqkNPaJjxcG2bY5DeTrqHeokP4uLbb9Vbk5acitH4UsP8pBv9fN82A+yS
         KTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423759; x=1732028559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwOpU+9TAGmH+CHuX+QM5KopibTesgkhxmGrqFO+Fas=;
        b=blhJw7+bxNtlS9WrDEsGSkBm5BMxoHETA/jUkZBwfmduKQ1xn5z2zzz9MtQwWFmGsf
         aaa1QCP3dZO7Sz+zcBcQANLe+RgeFEW3dqIUMT8nIQiHsWn4c1XomwYOqITXGIkHbHLf
         7uT2odINg8jCrL3djSl6kFzVNOnQSjMsS2IPKcvycYstiWVA8FSQATd7xJyhkUpUObuu
         TAZJEuVUIdOBmRk96Q61TOmAhd1G1OJJaBJmPla2fkxCb5QHRV8uyg0aRGBvwjpNFydA
         FmZ+ansQ+RNkXZ8Zoy64FiE12gnLwGUAZZS5sMGUrJeZ/umb4FfLOgEyCKpeG06bk5lZ
         oakg==
X-Gm-Message-State: AOJu0YwGtHF1grwkDKaVE9i/CKXrqcNGu0JwKXTzoIhcpNk76XYZYGGE
	kvxse6vZyd8QdnSCWPwhpQUYASeUdQ8CQWuyOXvve0yMpH8KSL9aKFW+RYQ4qnc=
X-Google-Smtp-Source: AGHT+IExvO8sI1uMkn0aQ+50+o0wJJqFvSESiWWJIHNhLZcVPZdwXB3oPP5TwOqznvKkgu1A3Zo5EQ==
X-Received: by 2002:a05:6512:ba0:b0:539:e436:f1cd with SMTP id 2adb3069b0e04-53d862d38c5mr8297419e87.16.1731423757680;
        Tue, 12 Nov 2024 07:02:37 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432b05e5bddsm216349515e9.38.2024.11.12.07.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:37 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/12] multipathd: print an error when failing to connect to multipathd
Date: Tue, 12 Nov 2024 16:02:08 +0100
Message-ID: <20241112150215.90182-6-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Marzinski <bmarzins@redhat.com>

Issuing multipathd commands when the daemon wasn't running didn't
print anything.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxclnt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 16133a8..55d253a 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -52,8 +52,10 @@ int uxclnt(char * inbuf, unsigned int timeout)
 	if (!inbuf)
 		return 1;
 	fd = mpath_connect();
-	if (fd == -1)
+	if (fd == -1) {
+		fprintf(stderr, "ERROR: failed to connect to multipathd\n");
 		return 1;
+	}
 
 	ret = process_req(fd, inbuf, timeout);
 
-- 
2.47.0

