Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4011348AE03
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995828; cv=none; b=exQ8uQBhb3jY3u2i9veyx+W1dTHefYzzgD5d2/bRpNiSj4NX2s669rx/L0710l8AX7R9lIra50Nh2x1t7Fk2lkiAGsYdcYdhYuYD7FwUFTmjN1PBUNMzgD/jJ+i0h9wOOqjcGfDgu/75PxrnRtu3moKpKhzPpGQoMECC/Ndn1CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995828; c=relaxed/simple;
	bh=53mlbPHNNyqp193SzAjzlj8sFW35H5AiefCeHsSpogs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Txu+Qj8bgXvyrknSmk6RZF5lGekqa+msgx5Aj+0VGGBh2KUFmFLZahYUVpmLZEf2P/RYVZiZ2mxdG3qR/etZPjW2VxD1me5KK+ZVoGpcm/yCD4RWI+OC88SqFbirDf9lxHmg7jJukiQw92bVIZrwbupoprtt6Edpu+ZCR/bR6wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H1yuzJVQ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H1yuzJVQ"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43d7645adbdso3301387f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995825; x=1778600625; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AndEHejqXSbzKWm4L9t9gWVYBZZydbhkVElrujyL4kg=;
        b=H1yuzJVQ1D8kwlYZQlNIcWkS+Ro3YdvyjplOmeWb1hNBBFFmpFEpcLwvv6TmsvatLo
         ArPIC3+Dyhiqa511yv6N/EFPKlBE9MC6Gist/o0hOjKV99oWTDAC9qod8MpRWpuvcX8h
         a1nurzzki7Xyh+sW7vwQ8c6Mp08RWzrWCCsG6t0GOj0Sv84xI3ooSOQNisLEyryk4xl4
         phXXTqBHR8qkZnCJ9H8+2OogrIcXKBMj/gyWq9FzIZpc9qVSTIVdAm3orMGFj88NuXhx
         b7aOa861PElcYhqEem/WGBX6F24gC2NA/T6qxZL4rVtn4v3XoUIyT1aFhi09rHDD/lZ3
         q/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995825; x=1778600625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AndEHejqXSbzKWm4L9t9gWVYBZZydbhkVElrujyL4kg=;
        b=UEB/WxlPaH4otrUMK90ecOpq34PPECL6XKp6h07yRNCVghGORpB7TXIb4jXEo5Iz8G
         X66lknzydKA1CYEzAZpWnPpJ48GfIKMdb0KgV1ef4Ya6WNDzgxw7lecH2Mt3r+duW3p5
         Jquy9QoFPLdO3o0VN/Qj7qcVtalKvb8UZY6Usc0CVZRFPH3tBlqfJGBc66q9dbdMetb7
         z0POS7DApmcbPfKg8gll9lvLP6i75adlN6tm4VSg/zlQ9LiPqNAzxoBzPc/iBFM2V4HF
         9js5mk37U+9+DMOpxEniO9pEjkBiIfK016SotSITTwaMc4I6a22vMyalGkMHDLhgOJR/
         uQrQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Ymdna72ekLK2NFl/qedWAul1eCFjK7vAtW2AXV1eV2WSKHQUkL10F78QubNNgRoUp2wFi6TGIJg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzAtrPINUEaeR47AEiC6+/7uImeQnDjy3c8Fs3JMhAuK1aKffqF
	66Xee59gQbUbn0iC+MbymgIwPfnn1KQcR+iStRF/9K+uEZW7v1V1NaXLboOAIvRVrec=
X-Gm-Gg: AeBDievgM1sLisIgV6zX3Pjn7Shpe8d0iMRlS5ElkPp17deI6heTMJszcs/nbGMFuK2
	IIp31E0npXge7oXovcIi9QXddP2+gN/4tQPLUg8wUt5VDkSfvAO2EroOthIy7Kpu/EfVdS9uQh0
	v2YuK1MyVx1ZlAqybikRMoB1Ti3eEZBv87rL1KQqekv8l+xA5ne57jRvLpxu01dfx0GdneO3Yys
	22QCyPp5kVI42xYTy/bf7YrS4KCIPvEBPiVytqnqPW8bPDXq0G9NlzrB4EEW0Qr3UhyKFkKGQOK
	7PSyqHXzKJ2ADzZwJcAl6l/5ZIwk2o9Dg5uZVUYsU/5WfH/4WP1A94foOmGPiaR+IOtshd/DNNo
	A3MtfDoTcO9z4hlulYkux9RkzoW/KK900QSJdhAdk+jgKhLM/YMFTuwk5SOXbDI5kBBWZ9uUK0o
	lphfJG/KPDEcAXdNCr10zNsmW2LbQjohao1IEVI1jjn+cIIBmIq0ygTIFCxYJiQSJi9qFmxWXGm
	ivMAk+rrPL6QhZg/O0614q7prXxCycZfXk=
X-Received: by 2002:a05:6000:4310:b0:43d:7883:87ce with SMTP id ffacd0b85a97d-450062400a8mr6749734f8f.34.1777995825095;
        Tue, 05 May 2026 08:43:45 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45054b03d4csm5767634f8f.22.2026.05.05.08.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:44 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/18] libmpathutil: runner: reduce a message loglevel
Date: Tue,  5 May 2026 17:43:15 +0200
Message-ID: <20260505154332.448054-2-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't "log runner 0x7b724a07a480 cancelled in state 'done'" at
level 3. It's a fairly normal thing to happen.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/runner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathutil/runner.c b/libmpathutil/runner.c
index da57ff0..8c6d6b9 100644
--- a/libmpathutil/runner.c
+++ b/libmpathutil/runner.c
@@ -134,7 +134,7 @@ repeat:
 		break;
 	case RUNNER_DONE:
 		st_new = RUNNER_DEAD;
-		/* fallthrough */
+		break;
 	case RUNNER_DEAD:
 		level = 3;
 		break;
-- 
2.54.0

