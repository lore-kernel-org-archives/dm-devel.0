Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BF82003A7
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423766; cv=none; b=BQ+RXOWfkCLMomTR/PhTiA1SPpTMfZM+42gaePxwZpUMCHswgkeOkqtanl7bqutVOPhCExVNDwbOoyZSBUGTLSLPkr5sgEZDa9jObJYwAeYCL/GOr3zoM7wseluZdbYt4Ce+HwYeCBmTuF6YqPzTTVenYciJVE4SA8VdmEwWYag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423766; c=relaxed/simple;
	bh=QN4djqOIaCXyVvLZx1U47B+oGKm4CeJafdG6QJXiRZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVy/rG3sS8db4+UNmUUQxI01DBaUcr56RSBg9QCvrjIh5zdETAlhvd+PiomeOkxd0EdvImEle/C+wHbJqIu3BUEmCm8yiWeMINhXLrdGpp1juGwZ7rmSlIc15bNXWjDKLPSzgwUrRdiPDsfZzk0AlkDKxBdmiSejVLmH70tZKIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AVNSAzT0; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AVNSAzT0"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-431616c23b5so33666295e9.0
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423763; x=1732028563; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXW4YhCLxpagPir0hckrMBtdWXrJTQz9l1K9NrwAtek=;
        b=AVNSAzT0LWIaVdqtqBEH+wSbmueCaIveHR4mQY5U86BKfmTIUrkojzieaoZk2Z6UFK
         JeoCwIdY78ojPgR2iX/QGeazmHthZn8ecsK5feB+4LDYooToXa5/FhPaIb32L9W8Qquh
         Bcp4yyIJ4Bv5MCj4yQjZ1G3vYNmbE5VEAInRBld3Ry/hJkOeWUqgwiD4MTSrHPryEYTC
         esYwRB2s4jVgq+O28JJjuq/n6vGbXEYsDGUUmNpJlEyouN2n3zKyf8mCUbwYg+/KQVdS
         PjtJpztSVyR96URpn42wR4VDpbsLcQqXxTJyG1kygvHgB3Kbw8m39+ksgFMkByMA1rTS
         8WIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423763; x=1732028563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXW4YhCLxpagPir0hckrMBtdWXrJTQz9l1K9NrwAtek=;
        b=xSiH5K1irYgfDc+oevPZPV2OTzaQXbp5z/8GvGHSOwmMbh5XJrcObmNhSSZCjADL2D
         CiRsSlhI+r691e/PUjbRR5zML8JibG/xF+k+LSW3EEfe5L2907qFCCjCsd6OY99PsjcL
         HFOHo4DlAVircPoF+ApQ3g1+DQBduisNBOblsNjL4iIYBE+v83m9CxW3pjbE+AfHps8h
         swyJLj/nDe5Cjq6+QOBG4tt/c37E8iUfZNzpM5yWifYfgWp//WbCxdCLd1K46FD5D1fr
         zaYeBCyMYXgFh+kVkM2iVag/HRzAXPvrtpacAtnbAbd5DVQHZLL8X3OtFFQF2yAxvDDJ
         nthQ==
X-Gm-Message-State: AOJu0YyOtjPHWvEZ5cPLh/P6aTtJ6JP3ZpS9Llq82etMtjEoKQssuYf4
	6rw/afbJ53a1vgJiZr6oKV/6y9bPozonZgap1eBk5JzIcML4h0wpaF1QXQo7vT4=
X-Google-Smtp-Source: AGHT+IGrtbxMBv7lMGbgvoQHbhzvsgnjmyK7S2/eHKM6JchfbH67I9/zyN/MiAxoTAkhuY8mNg8uzw==
X-Received: by 2002:a05:600c:3ba9:b0:431:47e7:9f45 with SMTP id 5b1f17b1804b1-432b686ec45mr153159255e9.11.1731423761934;
        Tue, 12 Nov 2024 07:02:41 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-381ed97fe6csm15495908f8f.31.2024.11.12.07.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:41 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/12] libmultipath: check map UUID in do_foreach_partmaps
Date: Tue, 12 Nov 2024 16:02:11 +0100
Message-ID: <20241112150215.90182-9-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't try to remove any non-standard partition mappings.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 03dae16..3ab231e 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1349,7 +1349,7 @@ do_foreach_partmaps (const char *mapname,
 		    /*
 		     * if there is only a single "linear" target
 		     */
-		    libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY,
+		    libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_PART_ONLY | MAPINFO_CHECK_UUID,
 				  (mapid_t) { .str = names->name },
 				  (mapinfo_t) {
 					  .uuid = part_uuid,
-- 
2.47.0

