Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A59187861
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561225; cv=none; b=o32dQZyzQxSxBn3mpk/9Z3wl9U6qkSBTu3nlo8U3x8N/uaqqdSQouh0mEYfyRRoxSjDWadPTlArI0h1Hrx9xmAI7AAp5L143m8RWmvJ5Xl9C+0wDImvbfJyn2q+VRgE32fqoj3jB4GPynBrrcZPefVYB/fFE5EW1fei9ky76vV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561225; c=relaxed/simple;
	bh=MWMYJ49C2Q/ulDy4AaxxWGAurftkYwlK0Xd6T2NMPss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5vhPScgpntQuT4v2Ffx5tLYsfE+/djLvW8Hep7IqG6C5QDLv6nnuGpNthUw6OdWuEE8kA8zIQjlyQ9k+forHpnxUuhmb8erYHg3hyDhRVjVdO17bmVGM/sFWM2FBZNtt9Q9zkxIgNrX/kwa9xrZte2UffWNMEz+xAZqS3FGqO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DBmwpRaH; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DBmwpRaH"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52ea929ea56so7476852e87.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561222; x=1721166022; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TO3D2bjCG9vI03I/bfu4nLcFhibp64XqmtGTgP1TuB8=;
        b=DBmwpRaH04oc8u2yMLTozdTJ+kishhmp4ymaF1xUHQh079CjC2n5zbFmcTee4L91KK
         N5zNTUpEWkw24LtGhJsL5KRHv7A/urtSFUTBvCy/gEuzu4CTtZqo9majuCHUTyvtrMrF
         7LSdzbLkNICTa2ZzlAsYNcLdk5mep4mZhSl3+EfAzSaPpHfFkBOG/cDdmN7xdPD6R5sD
         01Sb1crI3id3gx0DsWAfoUZgMd2xbiKaJV6nGsCeywFufuC/+cZUFP3KrD1bZQZ882KA
         OvJ6839CS2mX2Qm7NNGhRrd782IyQdYhB5LFMxADl1gZbVe30mJc/wv+anVjRJXk9LlF
         a6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561222; x=1721166022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TO3D2bjCG9vI03I/bfu4nLcFhibp64XqmtGTgP1TuB8=;
        b=NwC1/mAzcHKQYjgrW01hBT//jA39PfGheFXNIzZMAvB61083+DWf/W7JfDAtz/mI+H
         Nqz5wxDNXndIe0ywwNdeJnXoEwsIHYIP+5CRgmODJwFtF1XNI1qB4VAOD4Dei7WRtseb
         /YB1XgvLxx89uOTTPQOCdwQth/fgI43xn/Eu2nluv8V3FcJdSzDV+SaRI+tJVpmNTXl5
         C6HrremNgCleTeylc0xBSUKs3oRCbfMZya7RE0FlzA5XlZ6YAkfH0tPK8NzCqSVPMiRD
         XJIX5zzd26hKAzDZtNMcuOCix5LlloV0DY3l1WrHxbpI6h5lLmHevnEvJTjJZZOpZoDD
         0riw==
X-Gm-Message-State: AOJu0YxqK4Rn8fIPvXuJUsLQcmGvby8NN11e4cKHvNWOBo2k6jNzdRp8
	FTzLWfNSh4zgR5/SRDZ/6bHpstmX/5bwmcufzWiQjMxi0aIMYbDvakrHnSkAUpA=
X-Google-Smtp-Source: AGHT+IH9VP36EEIqw7oa5IfPJLWKK5u/9/UexM/jFqq19DHojXOK7t2SI+NeSCFQh7ulhUz7joguyg==
X-Received: by 2002:a05:6512:3091:b0:52c:e119:7f1 with SMTP id 2adb3069b0e04-52eb99d2776mr2980413e87.51.1720561221678;
        Tue, 09 Jul 2024 14:40:21 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff24esm107725166b.131.2024.07.09.14.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:21 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 36/44] libmultipath: update mpp->dmi in update_multipath_table()
Date: Tue,  9 Jul 2024 23:39:27 +0200
Message-ID: <20240709213935.177028-37-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This comes almost for free now.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 770e498..fb3aa79 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -495,6 +495,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 			  (mapinfo_t) {
 				  .target = &params,
 				  .status = &status,
+				  .dmi = &mpp->dmi,
 				  .tgt_type = TGT_MPATH
 			  });
 
-- 
2.45.2

