Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C37268FDA
	for <dm-devel@lists.linux.dev>; Mon,  5 May 2025 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462630; cv=none; b=PUCMgSYuwYQ5ujSHWZctUtHu0w61kJo+k5NpmHFVS0b6mMKLmaUpFtGxQ2Uq7ro0saaJiBKwnafZ0Hz7wnpcQpQilEepHMWC0ldutrgXGwPDJYGay7tYP3NPupzGpuqjx6lNmMfTRRxCpbgtOJkg5Yfa64LkHQwssJODh29WNaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462630; c=relaxed/simple;
	bh=eQLu34Ny5z0Mqd8L7NHWO5GzDr8ioyQZgeAvBJTkDbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB62m8TBIcydgX0UR6uSr0AYGGrbXYFFadzswrTB0waM8S5ntra+0NetiRXJUdAbNEYZN1Hji18urqMPNZ5HfP3giX4KToR8jkS3RxT6BNwatkyWuMrR0meN1aYLTBqkDe/0n6LV2PWzP69JjDz6FhLpCbFHJ7CReB8QcaTNLRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VwpGteKl; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VwpGteKl"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so39457135e9.3
        for <dm-devel@lists.linux.dev>; Mon, 05 May 2025 09:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746462626; x=1747067426; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXl1vnlkiTGkxvm/oNOoWGFnzVYmEW+8KCRcCViVRRI=;
        b=VwpGteKltwtAGNLzztxN5spY1ZW3Kif9PMbYho16lzskly/6mMJDvOAM3BY9oTkkVh
         Az9xaQAHoQVECFGzQYHpmCASv2vp9y8qXhw7Iq8TvWeA9x94fujGyxSLx/SnGYPwa2HN
         EjP1rlTl7qVfX0Q9LYbsLTsWzbT7pVLA0fQ3zmqvJcug6mBk/X3Gwr7gJAQYXtw8uME3
         R1g60honUMK1oRp+yoA5qJaq0V2olk2xg88rkUjrJj//e+upPFy/7t1/QDNoJxXghOmJ
         fcIZwV3qnkDAUIFwFCRWsxwfsHKpN+dK4Vmk6YLsIkd8SysOR3QxCtD1zbQpGfwKq9uC
         1CEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462626; x=1747067426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXl1vnlkiTGkxvm/oNOoWGFnzVYmEW+8KCRcCViVRRI=;
        b=c+UkGxyOaw+lFjBn8A5crTgA+++EJWkG3xV6nw4DHeFocvHp/d5w1X3KUnpQaIH9YZ
         bwB6OFvazYUwoWD59j8wecMuPzegX+LrDFV5yYf4mdT0CWH2jo220lK02WFiYoLCnK/W
         XWjxnjkLjrLX2zg2nG8r84KQNVutt2I0bOcSUw8nhWpSxzNDkyyNH79nYsCsnFzb0mIS
         N/aSKnYCQ7ZNShcdREe7JemWaRUoeKJY94cQUtMBCti1DgTjqBnRfTDJFrP+h4wCVIF+
         eAzddy1sZADgzebR9JXwfLvUyMsNEQSFS1hLgGP0Vk16jhn8PED1VZAipOAeY02YeyEi
         jqpg==
X-Forwarded-Encrypted: i=1; AJvYcCU0MV8W4I9h5jwvvyHG1IUyDkbYX54tX8dfCL8i4RKNVPzNQIV4iPqCgJ5o3c0cXXqz7PylhI1zCQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxJuDRB8c4ufNO0DRw/i+pM4MQHcRZ6bN6UnUe5VD67CAYXnnsF
	/RsoRELCb1xWyEGHXlkPHNv9DqMfHf8MXtsbo1g+ljPUbevtyOkMg2bsoW4oKaDwPop4aWm04sH
	P
X-Gm-Gg: ASbGncskqTa9qvzNGWgfZqtHjRFZDx/5sv4dWsuIRsSO7wtl/zYYA4xd5Gt/xqOFm4W
	heOND9U6Voy+yRGq7PLM1j+2fS53Uy9aWuoIeQA6CWYBfWH+0sywHAeE47/OwiN1gQ9/pt2S1O4
	zo8t1vof/dLuPDxWMSamNHYHM6AlOr8BE4npl7bqAv0iqASKdY+ikxPtCgO4G2FlAoeVewjyaaG
	IaaAxBzikDb8WpVZiIbbv1YilEEVh7DfmmNw70gujePnWFeG/30R82ztGpI+Fcmd6sQDovSPrFD
	IZabJc2IQUV6HVdDDeJlDGbxvONM5GLIas3v4Cpw1y5wIhUkgENxUPhBa+AbFOd09Fa9Y9e8g2u
	K/rpTG3cBHxj5fuHck3iTOTIgHKAR
X-Google-Smtp-Source: AGHT+IHYjKYYEKkrYD2bv0f37OdCpgShwU6UXDu//ESOp+Spt/kYKepC7NfabKmSo6QbaJ6rYBfBPQ==
X-Received: by 2002:a05:600d:1a:b0:43c:e70d:44f0 with SMTP id 5b1f17b1804b1-441c4a6741amr57857225e9.19.1746462626388;
        Mon, 05 May 2025 09:30:26 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-441bc264e2dsm117455445e9.12.2025.05.05.09.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 09:30:25 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 2/6] kpartx: fix file descriptor leak
Date: Mon,  5 May 2025 18:29:54 +0200
Message-ID: <20250505163007.59352-3-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505163007.59352-1-mwilck@suse.com>
References: <20250505163007.59352-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Found by Fedora's static analysis [1].

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 46cb76b..a1495e5 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -404,13 +404,6 @@ main(int argc, char **argv){
 		set_delimiter(mapname, delim);
 	}
 
-	fd = open(device, O_RDONLY | O_DIRECT);
-
-	if (fd == -1) {
-		perror(device);
-		exit(1);
-	}
-
 	/* add/remove partitions to the kernel devmapper tables */
 	int r = 0;
 
@@ -429,6 +422,13 @@ main(int argc, char **argv){
 		goto end;
 	}
 
+	fd = open(device, O_RDONLY | O_DIRECT);
+
+	if (fd == -1) {
+		perror(device);
+		exit(1);
+	}
+
 	for (i = 0; i < ptct; i++) {
 		ptp = &pts[i];
 
-- 
2.49.0

