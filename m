Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CAC1CF5C6
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644781; cv=none; b=oKaXqTQ0J0hewTTjdB0gVrOE+e3V5x2t5vCOyylAjB3vskLGwnQOVgnCC7zhaVhg+tkd+EniRcNDaS2s4I8vdoPMKC8pftiU8falAJemJXgaSiGrhNVVb9gkUGaoa4gRwGw3F206WnYAioBn3Hg9Iqf2UpmiASqcfc0g2NSb5d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644781; c=relaxed/simple;
	bh=ioezH84bHQOSgX9XbArqxt37rOI8EcC/8m1TQb/B5Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdjSS/ffiS5HKrLIBL0SHzkc0WCTcIGc+Z3WptJPD4Ilf72a8azpuKSXbe4fpPecQ+OGo69HLdGXNga1/0aJj1SEuW6TRFyYLRB4h0P9HQGOGtyy1nx7Xolrt2qqm2z3BPt3Q8w+WH4oYLHsRGZNJlj1vkJHxso4DRPMSuJ2V6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HP6/tab+; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HP6/tab+"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso1374145e9.3
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644777; x=1747249577; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGKpx1QVjG4ZBKeH16YkTHrIQAj51erMxnrqa02Ozf0=;
        b=HP6/tab+d/NQJd2fM2XenXSPgRUj3xdVsj8xiOd25s2nN0h2io9akQaXNGXd8yNtij
         0UGXb93vTZqIsOhuccJXEHR0GWl+HmpCxgzN4VyfrYllOiH4pvogw3UpgetJVgiE1uB6
         EMGhtZE+myKSDaXBDHKfFD0sGSEk3NKBsvJQdqUgVXS1H7e8lF4971p82ipPlQTmZdlS
         1Aqmtlly/aIdYwYBIFhvxXmhkGR4ZdGmBZDzg6E7feJ1ueZzHl2ZnudOsTWoinKmAqWs
         +MXkGGiMu0WkZ+rLvqEqywea477jAQEY7E5snMY5R/7AyNzehnL2P+qd1YaE4kGTRS5K
         D+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644777; x=1747249577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wGKpx1QVjG4ZBKeH16YkTHrIQAj51erMxnrqa02Ozf0=;
        b=np071eA0Ge9Zn6gFw2xD6hiRXFsUkm0lO6w8NmeWtJiPwe0WE8p9Zy8sLK+k6OJSGb
         Tmg9c6sGNWymCIEbPHx8YtMa5aWSu6v0DrfFWuICAiYBNx9kMmzyh+jjvub7Cex0vfMT
         VdWje2jj92vhvza+ij6z3nNraMWmjZAcjCl2tpNC3qVVsAQyNRPHnQHIm0RwE/gsO+vh
         7QtAGw7SRUiQk5LqQ/yyANSRais7XM4GrXYvMFtfbZHleApenT3r+1qtiku3XJYXe8cT
         8OfZgEsX9uNEJ2swFXHmQCUm5NmA6afFbczssNAGd4Lp0Qi62UVwTltrSbW7SXzaVc63
         7WsA==
X-Forwarded-Encrypted: i=1; AJvYcCWGGSa/xlpDh5eZ0E4XrLDqCnTrmAN/vJXK5v8pmY0BwMNVjYL2ughUGsQKed6pcF0Gv0Wxu/IQZg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxbSTO3r51N4rpBh0zLGfW2qT8iRWtOtk+7xNhV89r5D3nODzfI
	b7A9ImoH4qJlCid5pX/vYxkGmF+6eVSqIhS+gFOznl8/apWB1lqO6N3PwjMtw5c=
X-Gm-Gg: ASbGncvTXi5jLAamgEUFGwXFruw5PYGRnNiE71hMj1phFmjzbr3gj35VGPO94nwaAhM
	Z5UFlTYjULh9qjE7OOlH7SX1xr/uh7iIXkFqageROkTlyaloy7G86gpg3xcFuvRQC5ZU7YJ6Qi0
	QkpZM24FxwLECJXhQnCT5ZR3KtW3+MEDy1Y9x/7M2q4ZPoxOWj9SCdmLSFkqkZ3KucGD2qQkr5F
	KvbaPfynMShuhGw2mwnG9G6njupitzTKe/hXgpARsQg09cw9vQ2bSYwUDaT1xtvz4naoN3C22uw
	NXOamUNriylSNUZWyPHT5eerRFQS6BV1Tx+mw1Z9Zi9cLIr8bIauMMjeEdRAEG/S8PG3O4q+8XL
	+Dl35m5p+stDBtlVbJTqzvkYlGxNC
X-Google-Smtp-Source: AGHT+IF96cbJ1810Ak+qTqSt4cJeITvzyDVcdh20/lRQLtjovBCP64MBTeWLszKefGmUVoN9kgbWJQ==
X-Received: by 2002:a05:600c:6297:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-441d44c261fmr36446015e9.8.1746644777063;
        Wed, 07 May 2025 12:06:17 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-442cd3aeb6esm10386595e9.25.2025.05.07.12.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:16 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 2/8] kpartx: fix file descriptor leak
Date: Wed,  7 May 2025 21:05:46 +0200
Message-ID: <20250507190552.209637-3-mwilck@suse.com>
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

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html#def43

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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

