Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4BA27FB2A
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983974; cv=none; b=lqHi2k/V46nyfIHLCarWwX7EgkaQoTVPqFFkxuSYeSzoFciYtbLwhVMtBLSGx3Tp/OEJQvM6qHI+tP1/+KMPzstPMa1T+JoKDQDgfyTcJOmucmAF9nm17NcezkU2m/wAWmI4kpZIaOWAR+pCMOICv6Q/PeszCUJ96H0Gd1WJ+4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983974; c=relaxed/simple;
	bh=G8IugEbeLHwFv2r/6Kc+026VL7m7LE3+2lkqjJostKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2BiSJ2weSIwWDV79o0JYmiyKwdhoqODIsKpFWoI1GHa3HRLEKwlTHFVWHitZ4cd31dzuGeypKJTkavH/XOhjnENPuAozfHwyjm6OQ1950fvReGGoCKnwqw/KZGUtI6GKjgA+Z4cYS38B3H2nvJ5LrSpghFKol/nZH2jaDKjTfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KMkgNe7r; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KMkgNe7r"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42fed090e5fso2567857f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983971; x=1768588771; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iL2aI6XpuLSdb+BQOf9QgFNhyy0noJKO7Cg0Jw0u18A=;
        b=KMkgNe7rQRpD9UgKL1v5K/pF6h5meQnw0T8HZcUdcpSRYlnA5MmeGZda8p/ATGN42M
         6OiPSDB+cYQBFBDmVzUnC4szPXZ0H1RF6pO4Z8zoDvl11Gv6lx3ksiTIphOnrrMwWPZI
         Eyszkesm3T2q9h/FvEYO+lCb4jCu0rO/Rjlik5YPleqRU8PPo2ixMIE/JklymHm/MzbG
         awFrqLcL2UDzUUSlp0A6ros0ISsWQkCSUG4osF/diyLPWd4O7IIq6T2RD7bOszMBMjRF
         Ov26+DAip0fd3HWrmC60Gx5Up1hR8VCu0OrO6+kaqh0jZ1VOBaniSfP//xkLQl/aV+oX
         piRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983971; x=1768588771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iL2aI6XpuLSdb+BQOf9QgFNhyy0noJKO7Cg0Jw0u18A=;
        b=Sl9ocxOgO8hDjRrZseLIWzGd9+EO0UtxP5bnKlzRcAquUOUyuCVUZhxJ3xMtqemyX/
         J+XP5jJ8sdFyzCiAY3nTfj2k96e02TX1cmLjGIxCQ4Ynxy2k4Q0Zj2UbM8Hiqp46QGrz
         ysQ4+vQp49KFZ1rKYw5zQpq0H6LbBlhx9wi1Mrv3LoAvnzXWzkbUHk0yDlPphH5tOtPo
         vheAoHPeRIpJ2ZIGuAW6epP4RTp7IBWhMw7lVuInMNON7EfQNQcSG2gEI0zuWOVq6zv+
         25Q0lqOiNeWWMy3/4cuC82WRQTAPdTCG0Yi3J5oc8xewI2hxodHFvjPT2Z8g5Ks5PXz8
         qwHw==
X-Forwarded-Encrypted: i=1; AJvYcCUe8cGgwLgP9lpgxn24pw+9T+WLL3wTgKIj9vqq8rTOPkXeNjZr8d2Lvn9bJ7g90gnEJmhJcJ3m3w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyt4Z7gSk0Gf+nANmukDtwRqpQJwmQ6W5E12jhxm8SDzD0TJs5G
	oqdwFE5ixc++/FzwiZGD61vHU1SOteosWOT0wnQvrwDwXlcVjTe0XSlGOCTPOapVhF0=
X-Gm-Gg: AY/fxX6Y9Vv3uyg+HXAafUuoH8O0Q7Wl9oreRd6DOIx+7+0kSrmwnmWR/XRD6d5R3PE
	Iw0EOcG82s2RIKCYHoPD3s2ATNWOYCpz7A18OMZq879MWycb0YIQ2QD0+yn6UJdrsb3cGM84F9f
	gyuHBgmbShsWksLH7w/X7KAxyUY9pgSqQciQu4KYdOrwtjcAB05bLOU2NtIdC1EHs5871LbyAX+
	H1os78GhhiRqU+UKn2uYSkz/Yb+OM1VtICEPm+q+beuIIFPHHIWG1DptuymmmBQhPM/WKylaWXP
	4KvIGUqTH0R2zEr+oEHE3NgtI+7MhwmEacm18mGWbgN1sJbH4ruoX6aLJbGra4JMyaIeQcaGo7Q
	FQHqYqOgmRPEZ7+utH7IeDwHPd67EA3x7SexCqpYFJUl/VNsLzmVwqXFliyBve5rKpp8PeP/QRD
	r3DSsvPe1+nvp3BocLcy329u9S+D44N/KDuDdsZKwrtTkzoSDvpxIIGq7Vh6SQZaNG4WBBv/Ldi
	PDo9qcVL6wz
X-Google-Smtp-Source: AGHT+IFXGR70D2Ct8+zi0qEDpL98Uro+ESZHNs/jDcS4uURq4Ih+YUrN5fKJ+16OWLbt0k6IFEidjA==
X-Received: by 2002:a05:6000:1843:b0:432:b951:e9ff with SMTP id ffacd0b85a97d-432c376158amr14330271f8f.53.1767983971230;
        Fri, 09 Jan 2026 10:39:31 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432bd0e19bfsm23405052f8f.18.2026.01.09.10.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:30 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 3/9] libmultipath: nullify pp->mpp before calling free_path()
Date: Fri,  9 Jan 2026 19:39:01 +0100
Message-ID: <20260109183907.201250-4-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a preparation for the next patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8d4fc69..7185038 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -181,6 +181,7 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 					condlog(2, "%s: discarding non-existing path %s",
 						mpp->alias, pp->dev_t);
 					vector_del_slot(pgp->paths, j--);
+					pp->mpp = NULL;
 					free_path(pp);
 					must_reload = true;
 					continue;
@@ -201,6 +202,7 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 						condlog(1, "%s: error %d in pathinfo, discarding path",
 							pp->dev, rc);
 						vector_del_slot(pgp->paths, j--);
+						pp->mpp = NULL;
 						free_path(pp);
 						must_reload = true;
 						continue;
@@ -605,6 +607,7 @@ static void check_removed_paths(const struct multipath *mpp, vector pathvec)
 				pp->initialized == INIT_REMOVED ?
 				"removed" : "partial");
 			vector_del_slot(pathvec, i--);
+			pp->mpp = NULL;
 			free_path(pp);
 		}
 	}
-- 
2.52.0

