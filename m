Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2367421C160
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155291; cv=none; b=DqFulqtdT6Bhe+kGBx3BmSywxZS4cxAA53/CDz7KNOlxxYpEsFIUdibtfLZkactKXoCpHrykSI1nXp30pn/DY6LRiRIQb8in8bQ2bS9qs/lBE2547xogRwj1zapVmPHKnmZ9pvCvqAK2OhFz6Qx7aj+5L1N3k0FqfXp6PIv09go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155291; c=relaxed/simple;
	bh=ifquT188nODiA0QjQFKPtApUtDAUjwiF8DtgLlA4zhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1+qmAa2GHFSQulBPXJsN+QneYOT1wleK+UyT0wI1vDyRwf+niqMnAzUrxdBc/PZwL+Ihu2/cT4ZT/FGzigUAOSCj1L9X1inRzjsrz3V0tvxZl+k2ZtVkMMYH2u1MdB1i+AOaVWHfkyWopH2rmXqVZbc1NmE5x5gO8fvULxPRAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QWcb8pVt; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QWcb8pVt"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7eff205947so243331966b.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155287; x=1766760087; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqgha7a+aJ8JZp+8467hqZ1cZk5cbXyeVwLYJxKD2gs=;
        b=QWcb8pVtrK/qOdhWhrGSILpF84+YmANtsuLNmWhkigt+wDvPjJIWs1EnkRdiffLONe
         heD9RktGufQfyAnzgo/nUtVNv+H/Wpxc8yu85ahriaBqxUegfUY6/Cl+G6ZURymEvS9d
         d99q7vo723/FLDv07IIfnaF9wtZU6MbUaSfahKIW3hKWo09yVl67NuWc/+GBttamMVpX
         qxTlJ8aRlgPl8PU9YG9WaXbT0QBRuzWaoTdtojuUZ2iUdhTQa06giGKOcpukqaVCsNMw
         MemNgbzKPjPsI40VXS0Wqzvv0kjvI1XgzpUjmPOpbdrz70ofAYoBR1l/Z6ZuMw1o1GRk
         Nrqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155287; x=1766760087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sqgha7a+aJ8JZp+8467hqZ1cZk5cbXyeVwLYJxKD2gs=;
        b=YHczKE8CnHwcnVEXEa9iPGRG7SxEpyXBQk4jzJZZbbwp/FUib+nCzVrOIqHgW4uGZH
         AomY+f3dbohNIJrwx84FBfVFVsAXCWAgFdhs44lBY/y6BUtKsPkEHRlXNRtJUd4JO0FI
         tjm1RkQ22QlBcTz8Qo4lYC50oz0MpiM2z7tnbn488V0eETr0Q3hoiUgkW99IWnNJSdax
         d+AAhsIi/8XZ0VswWa6lBXoHIYuzmwtWoEuuugLDlsvtsMGKXuX1FX4eUVdSlgbm6JKs
         Y8DfJvrCnuY7b0Z2TFTJQCMooA3TFBQ1qayf8O6HeWvV505DS7yZTdb55osLN8J84aJq
         XtLw==
X-Gm-Message-State: AOJu0Yzap9VkSE85OrpUQACGHz3mNYBf+9oWwGoyF04vSUOhgwaFnZLb
	3S6BEgEBdn+eftfnuOv4kZ6Skf4mDeqFm/owdtqJj7te4nfM+c3Z4B67M90h34aXlDw=
X-Gm-Gg: AY/fxX75jd+P5YM3wJFKm8wwThtWhnotaDmTq/uY0GVuHKS8GFrLgAwKr35N9dR+lhu
	Qe8D6oawzLtbxKlM+Gs1edUX9eczUb3n7FnijxUcTRUAvtrPb8IC1wrWXDKBfM2B1I2wnzxHJQM
	qilnZTstg+Z+jfsJTklHHGJB3Lr7FG115RlogkAix4J7aJ14asMEOrswAnLRqwqer9GSx0NZGCn
	AnEa6A/RcnVpQJU/z26cAQ5Zu6JEpqKDxmWwzRSao7BXrIiIpeECdbpZz5PISnjX+oLqjH0cnHk
	WUgKuHAiwee4kofDFMedjsYB1+aaDTJEpEFovRQoB5mD+ogMyaELqAeTfbY1AMro9HMuXe/LJ8k
	CqWJt6ep3dvCScpVBy3YF0uy7QAG0T1UQv9q2QDjl4x4gyY1yOnwZVy88CJiV8sXGohkIghgrsC
	NBpyWp/5ehPG2U8fdRHykCgkhRmRu8pvw63IjwfkGOMBHQyd6IC5NoFYbE5+GjX6GMCwYacZK/s
	A==
X-Google-Smtp-Source: AGHT+IHe689lb2QZIXgVrUL9amdO6WlXI8NRCQkASvb0t22unzNU4c2GIb333LiIZSXhYpWFUImNzg==
X-Received: by 2002:a17:907:6d23:b0:b72:77c7:d8ad with SMTP id a640c23a62f3a-b8037058bbbmr302719666b.35.1766155287262;
        Fri, 19 Dec 2025 06:41:27 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b80377f2f18sm249604466b.0.2025.12.19.06.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:26 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 09/26] multipathd: free orphaned paths in checker_finished()
Date: Fri, 19 Dec 2025 15:40:51 +0100
Message-ID: <20251219144108.237928-10-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As we now don't free orphaned paths which are in INIT_REMOVED or
INIT_PARTIAL state in orphan_paths() directly any more, do it from the
checker loop to be sure we don't carry them around forever.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6c29d5e..c03546b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3083,12 +3083,30 @@ static void enable_pathgroups(struct multipath *mpp)
 	}
 }
 
+static void free_orphan_paths(vector pathvec)
+{
+	struct path *pp;
+	int i;
+
+	vector_foreach_slot (pathvec, pp, i) {
+		if (!pp->mpp && (pp->initialized == INIT_REMOVED ||
+				 pp->initialized == INIT_PARTIAL)) {
+			condlog(2, "%s: freeing orphan %s in %s state",
+				__func__, pp->dev,
+				pp->initialized == INIT_REMOVED ? "removed" : "partial");
+			vector_del_slot(pathvec, i--);
+			free_path(pp);
+		}
+	}
+}
+
 static void checker_finished(struct vectors *vecs, unsigned int ticks)
 {
 	struct multipath *mpp;
 	bool uev_timed_out = false;
 	int i;
 
+	free_orphan_paths(vecs->pathvec);
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		bool inconsistent, prio_reload, failback_reload;
 		bool uev_wait_reload, ghost_reload;
-- 
2.52.0

