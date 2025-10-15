Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24967AD2C
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 07:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760514333; cv=none; b=eQvo2db26Dms9JSBcRDaGV32PHXBEbiwWxOY/KgVB2J3fUiuuM9KAEnCoZjPoGR+GCvE2eunJ5/6dVe3+6oEo6iQ9NgSoA0nHxIqJgcdabtjYOglcHbW0QWk+aGYEiVo4yt2Rqbciw9AzVjOLblYMzwFp3MX4rcmc9n8YcX60Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760514333; c=relaxed/simple;
	bh=nM20uv/VH196Ela8AH318ePR2Zx9QQhvXJlycMg3X6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WEnOevY7hzSY7fV0Qh6UmfY+cwBTBVZkrcgXpEMrX82T+ThzcpLaiqaCq6rL3TfDM/6ElC+hku2b5FhDgJvnWiYnOLB8+julxgXlWxIGBJg/ZdbGn8Hzpj989ASjP/zONpdWZH2s5UhLSTIUW0j2dBpNAom52kSyEcKVLj/6g1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j+bD0d3F; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j+bD0d3F"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-863fa984ef5so1057938185a.3
        for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 00:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760514331; x=1761119131; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eZ9JDtSuH57J136kYyFzp8dS4Bh1vYURNdTXyBWFh/4=;
        b=j+bD0d3FQ8hn46IvvHW6K2jj3AWan6Yio9dGezCSn1+8DHpLE6+Wku5f/HFZvS+tlc
         dbGYR0IE7XmcRNmPijbN0ZBRN8hf0whhNBcsDfTyyRGFyU31CbcbSDjpOl1kXEgPNwKu
         H1YW4h1DPHAzpQxIOmG67ie7+TxGyAEHIB1iI6gIsKmw/IFpUC5xvaE5XwVTT3fJEjG9
         rLGKItGuwDbU7CIjOTU9vyz3UmPDJoDzFfPIX1RheoIbkSLW55ZK/oHM9IcTZ07i+KR4
         QYvBMwvrISUEqweLdq/nVU1/AsEhRnk0aaop4ceMzJ4DUxjxXslO9+DkA7Ud0pPMDYBz
         tgwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760514331; x=1761119131;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eZ9JDtSuH57J136kYyFzp8dS4Bh1vYURNdTXyBWFh/4=;
        b=I2UE2n0NzIDo7/jlCo2JpB5Te/XSi3wAJKVZvOf/nYzdxzcaPghhKUSb4gloMhMnad
         QW4VLi4g8UB8HtuD214DQ6wU7HCoRlTbzKiocFl0vIF+dUG4p+baHJ4wzF51nlckEAOw
         Qm7F/knkXCsP+iaoGCXqGWKqztzK301C7TPcO0UWjb+YoEUkMUVE8kShzNeZIoXHZUgg
         ZWP6w/r8NUvrcLYMg/vQsDUVv94egK8wcWcRi7v5XDeZ8qtSIonIfqz/9em1rwT0aFXI
         KWGosoVFjFsudTxuIGoUecNSwln+3px9EF3HZpkUGyabD8if0tBOtQvlODjeE1tKXCtY
         b8RA==
X-Gm-Message-State: AOJu0Yym1v238xlvQ/iFBjIhaAcTgH44moVdYGskYSQnK8tUH5y4hNy1
	mYtZnQ3KHaw53NfOkW45kEKu3EeaOI/E6Tw6muQPE4du2enWetJ3C7dF
X-Gm-Gg: ASbGncsy+kpTlUk1eOiSoTHvIpWGfUv9dR9GtYpyXfHwztDD8HdtigwRdHiwH6Md2mL
	bVN7ixVcmh9a/C4Ye1zw/Ro+KgbFXuUWsiPEFD2Qc1Dey+Uhi5yTAK2Z1hJZ+q5OXFbTMqK1uY4
	2SwPVHbMsKBjd6+Ky8KNf/mplupQP01hhNAoH7KjlxvxeosBUbIkNjxDUNCpEYmV9YGTjvFIoWu
	rBlAu6YGuySu3Fc/tuJOuvX319BhQVY8UwE0pTYTKsGWYgdLKI4IZYVETVeLu48XaINVeNVRrF9
	kPELncImtaHpfQ7PFk7+Cf5rv3k1LLnPTgTpwlSk9JDh5ArG6o7ZCVF2mulJWx+RSonLsvRs8JB
	BpUPkMAHY1brYWUejJYB+3RKUV8DhLyV7yxV2DbyRznT72x4yJmTISmX79jzHCvwqhFlQ8uKFzJ
	ksweOtH9+rlknHAiwj4y4=
X-Google-Smtp-Source: AGHT+IGpX5yjg/qkO+2av62Yooyq3wDMAKniS1oGU4fAngXkJObrfpK+Sb1QtvUDkHNKdfEpNV5PAA==
X-Received: by 2002:a05:622a:1488:b0:4df:c240:d596 with SMTP id d75a77b69052e-4e6ead6a348mr367541101cf.73.1760514330958;
        Wed, 15 Oct 2025 00:45:30 -0700 (PDT)
Received: from kernel-internship-machine.. ([143.110.209.46])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e881c76bfesm13669971cf.10.2025.10.15.00.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 00:45:30 -0700 (PDT)
From: Vivek BalachandharTN <vivek.balachandhar@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>
Subject: [PATCH] dm: sysfs: use sysfs_emit() in dm-sysfs.c
Date: Wed, 15 Oct 2025 07:45:02 +0000
Message-Id: <20251015074502.3363528-1-vivek.balachandhar@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace sprintf()+strlen() with sysfs_emit(), the preferred helper for
sysfs show() routines. sysfs_emit() returns the number of bytes written,
guarantees NUL-termination, and clamps to PAGE_SIZE-1.

Reference: Documentation/filesystems/sysfs.rst.

No functional change intended.

Signed-off-by: Vivek BalachandharTN <vivek.balachandhar@gmail.com>
---
 drivers/md/dm-sysfs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index bfaef27ca79f..22bc70923a83 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -86,17 +86,13 @@ static ssize_t dm_attr_uuid_show(struct mapped_device *md, char *buf)
 
 static ssize_t dm_attr_suspended_show(struct mapped_device *md, char *buf)
 {
-	sprintf(buf, "%d\n", dm_suspended_md(md));
-
-	return strlen(buf);
+	return sysfs_emit(buf, "%d\n", dm_suspended_md(md));
 }
 
 static ssize_t dm_attr_use_blk_mq_show(struct mapped_device *md, char *buf)
 {
 	/* Purely for userspace compatibility */
-	sprintf(buf, "%d\n", true);
-
-	return strlen(buf);
+	return sysfs_emit(buf, "%d\n", true);
 }
 
 static DM_ATTR_RO(name);
-- 
2.34.1

