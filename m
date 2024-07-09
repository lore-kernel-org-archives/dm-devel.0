Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2BA185625
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561199; cv=none; b=pfaBtXmfpIJ5MmEcitRCbMUQz8rGzAZh0k8ZR3hACQ13HgkOVFsrvL1DbN5J5S/KzSOdSru4TZwWI2XfL8KZnjgR3tXgZI80HshjtQr0wopPcoMjPRa/Yr/sXBec29ZKhNREwCLYJsoEvkg/zyOOZ2QggYxrB1E9e+vQSrEPdUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561199; c=relaxed/simple;
	bh=SHqlJ5WSzP43XD6YM1YWqlBehTLA47/mfT853x+3xrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2/EAFW8qWztPhBxWkpKn2mxURMwv4mophsttiuNrgw0Pekpp8tq3ua0tSVx1KZComVJ+CQZqcgOVAddYIMPt4AwT9nIleOmQTPN0AaFUc551Jv0KsTWHiiQVByvc+0cJK7ypsaozzV89Z93Wlj0VrE1c8Gg3q0cdusdoKIgasY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JsO2Va+X; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JsO2Va+X"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-59559ea9cfdso1260812a12.0
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561196; x=1721165996; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IHooILQuod33vDj5ZAUeTvyJUCxAlLWug7TS+dkLMMg=;
        b=JsO2Va+X33dNS7C0GtSLDyjkVFOem4+KjkTnTrDmjpXe2itMYhYtDpOKSQPb5v4ezt
         zpw+T99dGQXc7Wcbl5hCbcaGhIBC7VQGdzRnp2Jwm9QiZMGvHWvx28APZZXa8glH0xVv
         O5HwAaNoT9RGc58XQb6MUS5HPz/3EcKEkJTPQt587DMMNUyEoCVGAXxiH5udxl7EtgMT
         BHVjlnHXAjBo2kEDtYg07kmjtIB4vB9kLrzvWoMpwgjtnwbZp75gYHY0NhcLCl7HXX9p
         OT0pFYdN4csDk5vALaPSiYKlNuPxlvu0GqPwbilWOISaBYcVU2Nowhq2fJ586QzsjF6Z
         gmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561196; x=1721165996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IHooILQuod33vDj5ZAUeTvyJUCxAlLWug7TS+dkLMMg=;
        b=RwFNkVSUOOhfXDM7xz2Ya/cifC0HYFCrZzF5ZUUfg8AaaG60SViUFFaDyDi0Hm56uK
         sAF97n7+GUazCjGZFIQ9hIT4duP2fAB2lNLoWiq4ZhbRGLVBBLjxav2wVyY08FBL26LY
         by0yNPBx0o03cMeTjDz7lGjkQmrYZZerz/F1yN8uU8HyI3dBBbp9Obux/2BnHm4aZfv9
         GjDZAeFPUicYs7N9dGrTwisKZeii+ZAHkje8tYjOn5/j+8VFzMkrHMsaXmg9mg0d/7+L
         b2+sse/2qoe1ojkdT8sx5SpnSSkZ9EKjhkEDHhcflHJsZ+boKM57Inud1zCIMIjwRztB
         Jhjw==
X-Gm-Message-State: AOJu0YzwS8OeM5fI1ZUn5yRGscNl0hr0N+jrnsVjWWrtZlWcKxwxBdBu
	g/AOpSMPb0nGKyfxvgc5LGhVQ/8XKnOpQQVyf9NT2X9glPSO0gMXk4DMc/YSwJM=
X-Google-Smtp-Source: AGHT+IGmEGJry+nbREPMF0MUqO9n7sn8Xlbx2gaZelwHlapgm9c2xDtOXAgyydjLhcTrSCs8Qplh4w==
X-Received: by 2002:a05:6402:274b:b0:58f:2087:7986 with SMTP id 4fb4d7f45d1cf-594bcba77cbmr2605698a12.41.1720561195645;
        Tue, 09 Jul 2024 14:39:55 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bd45a16esm1481783a12.75.2024.07.09.14.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:55 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 11/44] libmultipath: use DM_DEVICE_INFO in dm_mapname()
Date: Tue,  9 Jul 2024 23:39:02 +0200
Message-ID: <20240709213935.177028-12-mwilck@suse.com>
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

DM_DEVICE_INFO aka the kernel's DM_DEV_STATUS ioctl, is sufficient to
fetch the map name, and more lightweight than DM_DEVICE_STATUS, which maps to
the kernel's DM_TABLE_STATUS ioctl.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3ee8555..baa1ead 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1412,7 +1412,7 @@ dm_mapname(int major, int minor)
 	struct dm_task *dmt;
 	int r;
 
-	if (!(dmt = libmp_dm_task_create(DM_DEVICE_STATUS)))
+	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
 		return NULL;
 
 	if (!dm_task_set_major(dmt, major) ||
@@ -1422,7 +1422,7 @@ dm_mapname(int major, int minor)
 	dm_task_no_open_count(dmt);
 	r = libmp_dm_task_run(dmt);
 	if (!r) {
-		dm_log_error(2, DM_DEVICE_STATUS, dmt);
+		dm_log_error(2, DM_DEVICE_INFO, dmt);
 		goto bad;
 	}
 
-- 
2.45.2

