Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E60F1A268
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 03:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783740679; cv=none; b=GAreT99O92lcAGZQbRzzX1vd1UjwQbYCmyvp84Ki/Z3nupMvUYmjJeSXlIaG30TNNVdAy6Qq2B7Frs64US6wDBdVogbM1SshDircqpRn5hGMhWnREN8sqicfwa3OquN3jkNm0YFfN2sNcu5qNnvLjVrR6KlUYtaGLQ275p7zITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783740679; c=relaxed/simple;
	bh=C74YAWP7pIq5hI/gSWUOVkLateu898yAm3D7cu+4X94=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=slYNbzehzbO/9W96mMW2QutqCS4otv53WlsTP3yAwaYit7nWlx9nzAxgfXIkCsw4rZbB4GUgQCB6a+YxwIEaX0mk6yeWn+0ubVK0qX67c24fSkLPDasDFLTD08/awV+Juyu12zShmbwzMznqrB1aqRlTOpOQTHnQKzoDm1pdVM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OZpGiqeq; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OZpGiqeq"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ce7d2adef4so19799835ad.3
        for <dm-devel@lists.linux.dev>; Fri, 10 Jul 2026 20:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783740678; x=1784345478; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IjrTbg245U7vZfHIc+G7umBSDdgC6RQE0y6pgGMTLho=;
        b=OZpGiqeqAuftfLstyREim+rSD3/UMQbzoPTwKq4cN5TlKNNSlkjckvXVFXvQsCZNkm
         ldB8u7JBSw02r88wyPPJFTzCik891zOmArOQcmn91jLaheawTOm3BB4iXF7BwLsxW8jL
         516rgu0XkGqoTTBDYKrrzbbD3ZLwmrEXCdPXy+1SSIbEajX7TUOaWxUWIhBreEBUUKUl
         eAQfArxsBU59Y6I/CCzvX/jqdCjdF0aR9Se13mwtZEtTKIVW42c++Mchrh2XSdps0d/+
         ywpMDtDUaR9hX8+VxZD2rtjuzlf7ra2GRRIlT+7tBf0KAo8IclhgTjqUQ2IyaqoQHdM0
         xNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783740678; x=1784345478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IjrTbg245U7vZfHIc+G7umBSDdgC6RQE0y6pgGMTLho=;
        b=iyczXgPFTmnh631V3GEIMsXKkgRwgGlm07WhoSkIi7R1PKYygeG4XEswtBfTeJ/Vzv
         YJQZA9IrAuX6BydAZIQKqej/yzO6MQd+J7ZbpUk9YKaNZ8XzqsphcBRwCuosI7CZDdvM
         RwY9xT3YCdFtRriR0kR+EdRrzb9Z0pyk82YpaAbH+9Ao8xKm9M4WHA9NDZ4GrckExfaV
         4sud7sW4P7Yw+XBhb7sAWW8b6Kg+MFWTzNq5E5bWw3h677pdpitHnbiBl8gahRz24QM8
         QWr4NOq/9p7gvJlwakoAYZggFiwQFEooxI1ZrKzz6uqZm7lLmw61WOnWwkD+5GsD0i51
         skIw==
X-Gm-Message-State: AOJu0YzGFFsAlZOc20P2goRXnhOuEa1sKb8Tzj/k3jHkkA141Z0Bg0ah
	d065u+3Vz0Gu6oaZ9oYwZUiDONMQcFEd5DgIWApDGwLRus12Qw6rGkH0yZno5s94+mH8Rg==
X-Gm-Gg: AfdE7ckaFnpHEPKrMqEdKm4C4/dBA8ZDm6lq9X56OX1iYbOwqXqURJ6j6KMpSZLek7+
	h4f00cDeeH+E7yX/7OmUumY26f31hQJvMHdwNcoUFihKv6L9oa7DWbmLrob6oZNciObY9Dvh/w/
	1nUpBDG56x5JsHKA2gWqfUHKfE98UiOkZ3qMvp+Uouybu4j+qDdh3y0t2cgk6oT6Wibt5DbRk5e
	MOd35yUwasqBPxVopF1Kqq2PM0XFRGHWe5n8oT8EzFSLTXX/Y+lquX166f6bAoxsxlX7k/wpgYB
	XTjTz94JpNDt+4rm6ZnOPYUv5FjsbmpcNydFOEvYKEs+vqnaaeJoxjIQzWOxdrKU6TWztfud+hU
	hLI+BGVpVOZQU7DuybyTPE1mHCx+/eeoV7q192cDjDN553sf5K6gOhMGDWu20xrrNOWOLA6ZvMl
	kPFGmJeqweDgHc0w/yT/pj
X-Received: by 2002:a17:902:d985:b0:2ca:329:3d96 with SMTP id d9443c01a7336-2ce9e59a083mr17384705ad.3.1783740677744;
        Fri, 10 Jul 2026 20:31:17 -0700 (PDT)
Received: from CykdeMBP ([113.84.0.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf7858sm68533905ad.23.2026.07.10.20.31.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 10 Jul 2026 20:31:17 -0700 (PDT)
From: Cykang <cykang4830@gmail.com>
To: dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Cykang <cykang4830@gmail.com>
Subject: [PATCH] libmpathpersist: fix self-preemption when key has no active reservation
Date: Sat, 11 Jul 2026 11:31:07 +0800
Message-ID: <20260711033107.2318-1-cykang4830@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the SCSI-3 Persistent Reservations specification, when a
self-preemption is performed with a key that does not currently hold
an active reservation, the operation should be treated as an unregister
and should not fail.

The current code in do_mpath_persistent_reserve_out() does not check
whether the preempting key has a reservation before invoking the
self-preemption path. It unconditionally calls preempt_self() and
re-registers the key on the local paths, even when the key has no
reservation. This violates the SCSI-3 PR spec and can lead to
incorrect reservation states.

This patch moves the self-preemption check inside the conditional
block so that it only executes when the key matches, but does not
bypass the general preemption path for keys without a reservation.
With this change, the code will fall through to the common PR_OUT
handling (e.g., MPATH_PROUT_RES_SA or CLEAR_SA) when the key is not
reserved, allowing the storage target to properly process the
operation as an unregister.

Signed-off-by: Cykang <cykang4830@gmail.com>
---
 libmpathpersist/mpath_persist_int.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 3091c5c2..2ee7fe68 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -960,14 +960,15 @@ int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 				ret = preempt_all(mpp, rq_servact, rq_scope,
 						  rq_type, noisy);
 				break;
+			}
+					/* if we are preempting ourself */
+			if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
+				ret = preempt_self(mpp, rq_servact, rq_scope, rq_type,
+						noisy, PREE_WORK_NONE);
+				break;
 			}
 		}
-		/* if we are preempting ourself */
-		if (memcmp(paramp->sa_key, paramp->key, 8) == 0) {
-			ret = preempt_self(mpp, rq_servact, rq_scope, rq_type,
-					   noisy, PREE_WORK_NONE);
-			break;
-		}
+
 		/* fallthrough */
 	case MPATH_PROUT_RES_SA:
 	case MPATH_PROUT_CLEAR_SA: {
-- 
2.50.1 (Apple Git-155)

