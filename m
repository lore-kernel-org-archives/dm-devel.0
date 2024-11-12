Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA167202F82
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731423757; cv=none; b=T6AteRNYYWraLFH8l5tBkyKmhBlPn01k0v7F/K6vgH6SR1gZN0qiUpgnrVqnep9iF4RtpvfESJ/TwapUH+SxiihCS83V2rsOsYwqFJ8jwm5fZ1iGMQpwIpoPi1aql49IShRSSiKxRQyVhGZgKvSadNC2wruH0iDU0PBhQU68Sl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731423757; c=relaxed/simple;
	bh=Aw4TAQDNERCvmqA104IpBo1CfRN86k0jqEIe6hqlbkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRksdS9VpdmY8mXHgqLF6YmnaXk2Hsct5NwtNZZuPkVwjbyikKbj/p2y0n34tNuEZp1T24nuMViRm4VbR84D3fCwqMuE60IC++785T1JOyGb0tB+89QkiRXGtdHhcdt5cKqeKZPypUlTDBRMUoRQ5PXYO9DEOZgVSZX4HxaL4v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GTu6EIoA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GTu6EIoA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-431548bd1b4so49347095e9.3
        for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 07:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731423753; x=1732028553; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7D3W5VxO1slniB2q9G87wm2gIQMzUlOVKrRB20+rX0=;
        b=GTu6EIoAIWhK52AwaZWJUyDirbps9DCGwxiO09p+26qeol6xkrbuK7evXiZB3l2eg8
         yvqYI7uF6avhQnTxNCnusgkyrLN7ODYAPORn9ZLVaDOOY9/neMnncZvqHqyvbwdnXEfa
         izMoh7V9BZc5fFAl11WDUERe01tBGP4wXGfG7mCZ54X8OEakLNYHcZaAPMpR4ctdJaNF
         uIH6RG/cYZwREa50kI9dId/YswrSylr73fBc0CM4dqHkGR7XoQuisXOxTaMOmYy/5R0R
         ZGEURRbU5cxn9ZzO/lwyZQnUn95262mqNZQswzp2IWEeVi1qH3oeobj7y7RcqU83h2Lh
         dpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731423753; x=1732028553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c7D3W5VxO1slniB2q9G87wm2gIQMzUlOVKrRB20+rX0=;
        b=IwropwYXK84cMCX3JVtdaMu26+v6MllKwMlrMMmdyG5I2KM/x/+npg2kWnBMfPdww9
         h4rSdQNPxbxnRezf8cAfau+PbSgKXNzQPm7LpvhaIWljuErIXphIB97YRltYAWadXvtN
         ME1tvsCWq3iod8ULzBLTXPwgT1UnBHdDzVCKOyP+XYfoseJPDsWruyVwszmnjs39BLsv
         xYNMv1hUlGbTYKHeEtyYdIMztaNd/BIBsGobfN6Cm6ON6c2U9C3JLj6Ff3IsYgYYU/rv
         ud68AY+r0u6aPmDkaFcm47NID3j/55HULHTpGcWap+Wg59TkVM3kZmXs4kEhens+GmEk
         AmwA==
X-Gm-Message-State: AOJu0YzLiRY39SdDAfDQjQWSXMW0qWDhLPpDZkkZpuqXyQQTOyMO5YPD
	8ELDwBuxVlyQf9H3NBiGkDXFXBNJABmuhvuKTpxAhaLJX9vobe59nhHFjopJbYU=
X-Google-Smtp-Source: AGHT+IELj8Qo2y52l/8gscNlClElphxLpv6OwVEs4/3vmhxxNaJcoG36AuITCa3IGPGJE2oB8ALoyw==
X-Received: by 2002:a05:600c:1909:b0:431:4a5a:f09a with SMTP id 5b1f17b1804b1-432b7518cbemr139861685e9.24.1731423752542;
        Tue, 12 Nov 2024 07:02:32 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-432cf1216d6sm14867735e9.0.2024.11.12.07.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 07:02:32 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/12] libmultipath: dm_get_maps(): don't bail out for single-map failures
Date: Tue, 12 Nov 2024 16:02:04 +0100
Message-ID: <20241112150215.90182-2-mwilck@suse.com>
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

dm_get_maps() traverses the entire list of dm maps. We shouldn't
give up just because probing a single map failed.

Based on an earlier patch from Benjamin Marzinski <bmarzins@redhat.com>

Fixes: bf3a4ad ("libmultipath: simplify dm_get_maps()")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c497c22..52bfe9c 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1262,10 +1262,8 @@ int dm_get_maps(vector mp)
 			}
 			vector_set_slot(mp, mpp);
 			break;
-		case DMP_NO_MATCH:
-			break;
 		default:
-			return 1;
+			break;
 		}
 		next = names->next;
 		names = (void *) names + next;
-- 
2.47.0

