Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC34176AB1
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804542; cv=none; b=Ag1QwRjmvAnYTCBt6SSdWBOuhiQ4MdrImuIXJLIg7wtekU5zrS4wwEu0AR+QI300HUYxCLVfiqfvM7LHbhxQ3PvUUPUd3ipZDj1gWL8IyuqCcZtvR0ds3mprolwj8B8tE0DPA6gDiRbCHV6DFKkTyTA9I6XZCk8YJNQLqfiErhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804542; c=relaxed/simple;
	bh=ei/dWGDoznhqhBkkNr2rYevtzlQG+nw5zFGGdtM+4g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLDCp+JLZ2dl9GW+ZDXORAD3K0OB4bVQQmPFaz6QZW1Ep8W7VEykiFGvfkge7YHYa1c+eJofrKiKRX7OT+KBHgRVGzV39RRNTBUesLOceOIO2XFt3h6QuOLCfc0aXLHH9+kG+rLNevXAjYxcCrOWA3SjIDb8N0EVFwfj7qAiO1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T8g04mUn; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T8g04mUn"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so5869696a12.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804539; x=1721409339; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kG/sRR8mXDhOojSugaJG/UCzOcISIeIlDj/9lc7N/Co=;
        b=T8g04mUnyhEsPeUfXPJrwMeWS3w2mPyf2N9Nd4ODgeXpNhKb5OzdbsYx1oYGaQDur+
         pLiXE3ZgwvjWBaK5K8V1v7MXzTA0FZvGpVdkxuX4c627fj43Dt3hBFqXv1fKNJRKnWXX
         6cSBOAp21qGi/uWowXjrWR6pqMg5qzdQ999kel+leQ5H+vOo9gUk6Nco9T6KDbG+5bNC
         tyjNI5j0uExJQKXVs7njf+GFdnkgWsh3rE2ThEDVmkI0mFzexPDw+m1W+9k0HWupxCm1
         pxbmyQhOoMkix3/EVcIlI7EPm6WaenvxW1pFqFFZzgjmbjSWXV2lEUDoz4uHfgtWubLu
         NMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804539; x=1721409339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kG/sRR8mXDhOojSugaJG/UCzOcISIeIlDj/9lc7N/Co=;
        b=f58/cwUWCV5RGGLt6lgkZolAdqmIyPD26Zcz6m5FwAaG0pNmiG7u5ujhSMPT2qP820
         Kr+9jPHLpIAKYCBWmM1vAdQRglwW6tIrC5O9xosm7GFF2S1YIfGYun2ODoua367Jk28n
         j7QRIOaRKTldZUsDd/8982mWvhTtBWg9EytkwM4ML29nVvYbjim238pz6wqAxlhVMCpa
         x9el36/a9YY80cl4wgWKVtGetMlyRmaOdl+nToLra2a+w3qDWn5U0lDsRLn/xuCPzJb/
         JrEKndrgo/YTyZOe171tHJUooLBJglkwQssP6gGH07RBud4tVVJ/CUpitW3SD5mfiHiS
         BJNA==
X-Gm-Message-State: AOJu0Yw+RhDelBX5C91s6tO5wcKbGpvWzjTNpgWI864UxqRqRnuuT75S
	XOTS1Firw02EENuQcQwVKz0bxtP+byL00Xm/kJWUryOPTFmSSy7oYu9XEtz/T0k=
X-Google-Smtp-Source: AGHT+IFhZRHx3xsIo+wCitVMA9SqfjIIbH71r4TobmnYKMYjyX/S9eA3HJTEQAxSW9OB/keEiGuObw==
X-Received: by 2002:a50:d59e:0:b0:57d:d59:461b with SMTP id 4fb4d7f45d1cf-59960007edemr2412537a12.13.1720804538943;
        Fri, 12 Jul 2024 10:15:38 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-59a68949578sm334412a12.3.2024.07.12.10.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:38 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/49] multipath-tools: .gitignore: ignore o.wrap files for CI helpers
Date: Fri, 12 Jul 2024 19:14:17 +0200
Message-ID: <20240712171458.77611-10-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unlike the .o.wrap files for the CI tests themselves, these are
not automatically deleted by "make" as intermediate files. Ignore them.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index efdbd8a..4548cfb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -42,6 +42,8 @@ libdmmp/test/libdmmp_speed_test
 tests/*-test
 tests/*.out
 tests/*.vgr
+tests/test-lib.o.wrap
+tests/test-log.o.wrap
 libmultipath/nvme-ioctl.c
 libmultipath/nvme-ioctl.h
 libmultipath/autoconfig.h
-- 
2.45.2

