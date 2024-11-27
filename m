Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF93A202F71
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 23:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748688; cv=none; b=Eu+9ivzcKjGss5H6OF+ZsGB69f+XWQoZFgygzN/omR6TbdsS+vJNbPXA0IqHt2asd21hVEssUVR6/SRXHSvxHioeFBtbT5xlU5+GcF2lXeVs+0qaMQatdmt0eBIT9r5pTsLvNb7priklFU5QFHbP1ftYKjgWVdf8oHtmh7B3nxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748688; c=relaxed/simple;
	bh=TMDpgORyke9Sv8Ex33BThZ7ajMzGcbaE455+JYd8c2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7f8aYB+w0w5Se27yh62u6sbkmDhX4XwXhpQfCbitiK8VsXfHCZRDO614tLgfyrkbN8T1CnoUvHTouILe3G7JFVO/4+bT7shnsJKiKN3ebR1Me6mZexN8EMiTAM1B/NmRWF7UUhHqcyNtP5tFYEANh4uLw5B17SDKdQoZv0pkjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d+G5nh8f; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d+G5nh8f"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434a10588f3so1038755e9.1
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 15:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732748685; x=1733353485; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8OUi9V7BDIpsKIx1PKxdGGvddi4yTsFEoPCDgiOeKU=;
        b=d+G5nh8fR0Zvek5cCIdNtPc7GPxBSHTMvQ51vIXsttQJ56ZMLiQpD2x04XDad3B3hH
         50f3GbQYGOPqh9yfIvvO6n2tmwEXSOf9iOAL4YVkkmIusxo511s2hTRh+77NBcGvltBd
         Yp54rguBKJFfc2xZId/R85fT4pT7u1hnL1BITkjn/nIOKu1+4zx9n5VsCekx/8evqaUU
         E3dAF2FO/KHqnIkprmjqfleZ3ztbsvzZJ9DRvtT6Wdk2KISoyBzR4gaz8pKlNKaDeYV/
         V/VEITAW+6aWH5hFkX0GtLtGw6Qdpgd6ayCEQR6IRxZ5gdNwCsB0lERXYCBOSib1xUeM
         ewog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732748685; x=1733353485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k8OUi9V7BDIpsKIx1PKxdGGvddi4yTsFEoPCDgiOeKU=;
        b=W/LFuj8HST0N8290ujEEEwgqXJ7QcB8hQyx8Rn7GNsHjiBNswhJxPFrmqW/uwFONFm
         f9HtHaoxhuCui7pOcABscfU9sY0+QHekB6uw8noUffr26pI/l8uIFBYVHZspJfabrldR
         ryBkysCmq/U8KnYEFwtmV38lph3+XZJGi2MAZxE9Npitc8UnWIeKZAdnlULIfOu4whzY
         lW4nLxstxlLx/XwRVzY+OrURT0ZuJ7/TLIAkH35f1kHISADsRZxosmlsSUxJtWQMYiyd
         62Ta2v1QDN1HlwepZcH31YM5vE19cBB4zwmOg5NevUGdhA/0BrjzJOPiBfNxJwN/y6EN
         /EuQ==
X-Gm-Message-State: AOJu0Yy0zBmkFp93MCexJ2dCU/17S+zVL/REbrUBYzkKp+Nk0SM0YHcw
	s5Cwo5SqLXR3AEH1KTmCaDvhzSbd0wzTDdy6zQEIVvxRsVN/jJw60E/4kKd7SSY=
X-Gm-Gg: ASbGnctyh/085jCAws9bScL4uJ2Pn1qRVOMLe8CqJyET+fE6zY/rPTbEaJJ1sT7IGm3
	KiWZ5n6d23sj6ykLUDCgPmMMdgF+mT7zJDvh24V54M8xOuinVrrVZqzl9oQl+0v23dikFScaTnr
	LzeRsmM+vsjaoAoRfGrlGXphQU4TQwY305veiJ+luKok4seRfjHV+HkPVzBcu566p2OQBteMQPC
	BpPL9Jlip+BpzM+yUn45wLJPK1+R7zaFTMZzay0Tbp1iz5g+x8YWM1XavccTc+nJaOZ5+ROgA7c
	0mIK6nQ7jatLrAqIVsBCY9IUaUKh1m100KmK
X-Google-Smtp-Source: AGHT+IHNmk2W3fFVOwguqgMCnkIEmeBMJ0w8FKpj4KeyHZywiKnHjUCzN5mJyOrsNN4UgDr4bg4yHQ==
X-Received: by 2002:a5d:64c2:0:b0:382:41ad:d8dc with SMTP id ffacd0b85a97d-385c6edd452mr4271897f8f.36.1732748684913;
        Wed, 27 Nov 2024 15:04:44 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385ccd36d1asm79129f8f.27.2024.11.27.15.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 15:04:44 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 7/8] multipathd: trigger uevents upon map removal in coalesce_maps()
Date: Thu, 28 Nov 2024 00:04:29 +0100
Message-ID: <20241127230430.139639-8-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241127230430.139639-1-mwilck@suse.com>
References: <20241127230430.139639-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... if a map has been flushed. In this case, we know that the
the paths haven't been multipathed by coalesce_paths() because of the current
configuration (failure to create the map can't be the reason if the map
exists in coalesce_maps()). Make sure udev sees the paths which have
been released from the map as non-multipath.

Note that this is the only case where maps are flushed where it is correct
to trigger paths uevents. In other cases, e.g. after a "remove map" CLI
command, the configuration is unchanged and if we triggered an uevent,
the map would be re-created by multipathd when the uevent arrived.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fcab1ed..9ed27da 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -794,8 +794,10 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 				vector_del_slot(ompv, i);
 				i--;
 			}
-			else
+			else {
 				condlog(2, "%s devmap removed", ompp->alias);
+				trigger_paths_udev_change(ompp, false);
+			}
 		} else if (reassign_maps) {
 			condlog(3, "%s: Reassign existing device-mapper"
 				" devices", ompp->alias);
-- 
2.47.0

