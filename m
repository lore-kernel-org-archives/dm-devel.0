Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4F71F2C2D
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957995; cv=none; b=cSeGXi/3dtchUScdHX8VALxUzii+TbBL0Vl9tU8ZQ5LdjQEFNHX4ge4KTJD08TEyisxV+w66cBlCuKIq+gbNguyQXTWbv3oT5U+1K82koRTd+9IiUt/tNM+0f3kluCmYhhDGefK2qHfep+jQs2xF6DH587q6+IMX/wfdoOexzH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957995; c=relaxed/simple;
	bh=FqH7RhHO1ysS3vRBGCKk3Esil8e1d/CskAUMw0iOEuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azrsvCvqOQAlVqGAy9/8dtjwFpvxYWMtDk0sW/CZZj9wq5COQlqD67ugFy1TPuQmFtF5wBRhiwYVhIkwRxAjDG37l/58ZN69ICUsVhku2dLVbKsMdpedEXuqD9+0PLwzqD4zjGbii+drPlziiO+WyI3XdqnzOIRw7Z5bsIx/Z3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WP/4g16z; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WP/4g16z"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa69077b93fso551836466b.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957992; x=1734562792; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z71ggcio+yANbmtayn9X2IcKXpqPVVdYZoTwhqO/0Xs=;
        b=WP/4g16zy7IJ2534FHS0sU5e4TOhkNaT+b33zIeSiadBmrob78XedryfZKOSDmU+pg
         gBopq2ZIscCEqcw4SJ/JaANGVYSKRC6BP2w1ga1CnR4tUYNJoSxmv9jRTG7IbFJhs2tc
         PaNCOKA2hbZ6+1FN8yYSijYGmUk01z+UYnggtfcuE9l1wPLlR1K56NkRQGXVAK4hKWHf
         3C8ozz9Rwhr+xzCM+lyJsI9b7MWspcJzH8+pLqjehO0vfwmDHnFey0IebvDfZeGdv7+j
         X2HPpsWt9TDyXfBtcFZNqU2YveoQu+4N0o/U3QkxLxalcP9M+bXhaUY6Y+iv80thcfns
         lOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957992; x=1734562792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z71ggcio+yANbmtayn9X2IcKXpqPVVdYZoTwhqO/0Xs=;
        b=jQYGbos1Jpc0rwMj6XrX2MN6unrZv/6VpL7a+zm/V8yl9PqnhblUq4oZiol3bFYFnh
         1QyoG37fi8f4nhCDJZP7XJXIzncUr6pwc8hMSoB5NnU3bXe3+ikxyS/luHxVf3TwGvqG
         28T7d3rIr1gYkHfl6GDfww5FWIrvQ1kUcbG5hLpveAWLeL4eU6cZzYyZeguS71JgEYIp
         JDnAmeXLMz6fGF5eKrxQyBMPFpV/4poePs2/w/fegzhtqv9t4DpA1APdkURAcCX7QvAx
         KJj3IrxygOos8mOV5OVk8O85c+xmcT/fjaoVty05hitmddXQNsO4SB0X2cFP1li4gSJC
         Oj+w==
X-Gm-Message-State: AOJu0Yx5/Vf0GmFqsGIrfQ7gAoXlfs8IEejkA+8vQosAayyY9aE6uZ9g
	Jahgglfnc8JImbEuAs4DFEhJcp349iPPu0S+YDpQIt/PMjMKBuXVqVFVPSccYco=
X-Gm-Gg: ASbGncst7PbihrfI/GpswsGCmYfiL0BEXXaFLyzwcchlEKJXWXPivA2fySfLJ0Ib7CA
	JOkjmOnHdCXCLtMtYG5in8/YaXmq2ixYw3ia/eAS7i6gDBVTw0DpWMDtJOpVisOoOuG08juwpgR
	esEHxWiFScr7IkfrqHm4yYj39dr0Vnfi1VGU1pG/gwcNKh94MaOvE2TdeKi46lVmR6RbT93rcBn
	P4B0Nc1jLYBLdWAbcSdt19Qs01HNrnMhJR5tGb2KPIcI+e7ilSttApLMwu6W0dTavoG9O1Aa1E5
	D0zBsVh6V1N9hpFyNE98Cl6xm9xncaUh624069Kx
X-Google-Smtp-Source: AGHT+IEGcg3O1I1yRAmh4WZ47IEV4RrMFoO9beoyxI/gRai/aTPu1hHR4ucUxfbLycgkjorzxeCLgA==
X-Received: by 2002:a17:906:2921:b0:aa6:727a:2af8 with SMTP id a640c23a62f3a-aa6c1cefcdamr132166366b.37.1733957991799;
        Wed, 11 Dec 2024 14:59:51 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa695c3ac07sm442890466b.66.2024.12.11.14.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:51 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/14] multipathd: only call reload_and_sync_map() when ghost delay expires
Date: Wed, 11 Dec 2024 23:59:07 +0100
Message-ID: <20241211225909.298770-13-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
References: <20241211225909.298770-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While we're waiting for active paths to appear when ghost delay is
enabled, we do add new paths to multipathd's internal mpp data structure
as they are discovered (unlike missing uevent case, where we orphan
the paths instead). When the ghost_delay timer expires, it should be
sufficient to call the more light-weight reload_and_sync_map() instead
of update_map().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 71d5363..8d8b237 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2948,13 +2948,13 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 		failback_reload = deferred_failback_tick(mpp);
 		uev_wait_reload = missing_uev_wait_tick(mpp, &uev_timed_out);
 		ghost_reload = ghost_delay_tick(mpp);
-		if (uev_wait_reload || ghost_reload) {
+		if (uev_wait_reload) {
 			if (update_map(mpp, vecs, 0)) {
 				/* multipath device deleted */
 				i--;
 				continue;
 			}
-		} else if (prio_reload || failback_reload || inconsistent)
+		} else if (prio_reload || failback_reload || ghost_reload || inconsistent)
 			if (reload_and_sync_map(mpp, vecs) == 2) {
 				/* multipath device deleted */
 				i--;
-- 
2.47.0

