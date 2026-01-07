Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07999338591
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817136; cv=none; b=iTW3b8YLHaDljH5vXD2iq9m773VtCQhi+yUQfagqzUTvQKYSi7Ki1nSHjDYmdKf8EMOAM3D6H4ivcGWDxv5+JFp9BFQ6Pl/wOVa57uADOI2KAoxA503Sci60tCgPv3HJibIH76HJB5lsUxphmIpfmoKXlhtv9LY9U6nUEmZVGM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817136; c=relaxed/simple;
	bh=LQymkYXJHfMrn8GdzasBkj2c+Evr+7/VSGZhoFNRBNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/um213F31Nu0v9ZumEGjDTMw8KJSllYGdMQitXWMnVkGetnQ7av2YnKxJt3Uhpvd8PTrdGL6wirkxjVdRFRRXUWjLdEu717TQnP7mG28cgC++6VMTvL6bOYjAQBxz3e98y4UHY826XETXnJyjqbEmImfqlR2XUSpImPFv2FXwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BaU8r7Id; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BaU8r7Id"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8427c74ef3so381029066b.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817129; x=1768421929; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2eHwJ6sVQ/tDe5eUEaqjEEpJdpQRk2BvDXFgVYL8iA=;
        b=BaU8r7IdLyPePHQOc+V01Jyq6JA9+HosrZ6GzB1hqaApAp140MR2Z/f2dTqjGzEYB3
         ofmLEn5Zrc6mqu1C5viB/v5uPPlIn3NAG1EHDXDzcfz6R1LTX8Lck+Sfqj27PVM3Ph0E
         Oaa/ey2L9aTS2zbmIRG/NidpL5o5L7ax1afGXyUkCP6n71+fFz2RzKjM6/SmrWiNNroj
         giCYyiUBx3cks5y3C+Yxa9z6hLYt5wq6A5AeJz5zfLPbV0UeqQn6nLh5Akm8TdjwzShE
         LheWPVKY7PV2HS9v8mOvy/UexogUPIl0k1Kx9O+YCxkq7xSpYkpAOtsDM0DRXQMn8J5u
         sEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817129; x=1768421929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S2eHwJ6sVQ/tDe5eUEaqjEEpJdpQRk2BvDXFgVYL8iA=;
        b=m+vxWtJpgZpUagTT4EKJY9F0DTZTtZ/RYggKfItZJcKDuIl8DDUIqm0xWCDxYBw7Z1
         lbjaq+REOu6jUVAFuVx77YXjJIfws1eYqvc+022flzTSE+H4EIkYwup/HUbD0ISdK/EK
         1ur5ZDyMDU0GLZPZoq97EStu7qiM5aGoh/byepUv2aWd/WGVhafNVDTCYoUf04/B4+Nt
         svfAz7GCoB6+W4lw/E2wiq8ZrcOJmk5tHFKo/PAZnoQY9fTmRtMxRKwofKgr3SPqpn2w
         tMvhjuMVPKPHVM/BKlAqOGYoMLfg1hAjOoIgm3AaiNy5uTC5jtTrCZc9iRM38+2s0NgT
         LsJQ==
X-Gm-Message-State: AOJu0Yxqua4LYRQBrAyllQRsk1Y1AxzPV9rk+bQHGpvsSBkR1Mk80hhG
	KtGyaqxyASQlzNX+u5Qa/EfD1G+nlS+FWSQdhbQWMBakbTX+ijUIlfZn487OW2eXrms=
X-Gm-Gg: AY/fxX43kisC4ZnM0zQx5aeTWXQjknWXPMbWE2AQl9z3W1ezVBfz+Bo7RLVc98bDud2
	doUc5aPXqVbAsuUT4WDEr/pp3tycaBlAoxp2e7e7ggD3Gdq01ryW2to4POBgTOiAa2vGoVEwDHm
	UDWdBTaMQ6+VWAI26KA/4rsBW7i1rskJLeWiVj2jGTo2175LKhkF214WuOCU0T/xGoKaXINR5XN
	pZsCofgjkVswQSSeBoVR01KM6d1RnhOHWwUDHdcr5oJNDzJ1E+XVWDR2Cw4JLmYkVve+arXMk8T
	OgYH//taOnEXWGfu+KNMBOoTOb3+FP4wZKm39msMn45FjAY1ra8+UM5IJhqzMMWqPQ/IZzD6XSW
	H3qifBTMQENN8JlOis+y6t+P26lTJO9ByE0JOyK3NY4N1Yec3IPr3WKwJou1oG4vPi4/gc7auR6
	Y1VdETv+qxH+T/NWRezii/3BDwkboU27T/D7G/vskxJTyS6wX0yynoClny5Tvm0PsONqgsEo6AR
	g==
X-Google-Smtp-Source: AGHT+IHnF9rbQa0UXHOLbiB8JzkGUf8GhTEDx+rxvCDPYB7ELn2YxN1ys7aOf8hRk0DFiJaNRF0ptg==
X-Received: by 2002:a17:907:78b:b0:b83:15cb:d4cf with SMTP id a640c23a62f3a-b84451de1d5mr319382766b.29.1767817128781;
        Wed, 07 Jan 2026 12:18:48 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a234000sm611846266b.4.2026.01.07.12.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:48 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 08/26] multipathd: free orphaned paths in checker_finished()
Date: Wed,  7 Jan 2026 21:18:08 +0100
Message-ID: <20260107201826.323977-9-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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

