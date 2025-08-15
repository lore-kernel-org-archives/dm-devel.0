Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1202A1B87C0
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 08:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755245001; cv=none; b=jLHj68FA6KFt40m+/Y8Bg0C4Zs+eycmv/7Oa+UK4MphySjkR7WgPwHSgyb0xQbMPI/ydpwTh7lco6mkW7fY8nzNHkCqH17fwstJET8fQ9Bw0onFpwW1zzGJ38IVRKu5ZA4jMwcof2Tj5KYyqW7a2u1uRtxxgW+k3J8kLFVZKaxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755245001; c=relaxed/simple;
	bh=qyzLs/0CDjVeqzhntZR/bU1gU8V1Hv1zEYSr2oMjvt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r/IzBWg09gJAtkSP4NZpu7n3l60s0Iptblkwz09xmmDURJrkvkxQNqZUSMpG7P5FpmVWwk7QHlTIdDlJ/UCo22XBUAoiVKOYxYCsJ+2xlHFcScPwJv1WGZ2xYLAU/6LO4sZptVgeLJkMcrXUfitzH6LOGBn9x8O6WZqm+o7roVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T4KacIMU; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T4KacIMU"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b471740e488so1643788a12.1
        for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 01:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755244998; x=1755849798; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sxpExqIp6ahjSppu7+evxPdtuZCZlQ03AYV1e06qBjk=;
        b=T4KacIMUCz4Hcfn9utFOvDUoG3cull7BxyyarCz9yBVnpHy1xiOY+gKNUBouXOwt8q
         kp8/w8JDMcKN4zxu51VOhGmcLUxyEK5S1KGEOoROI844Ai3qoZPTExMYxbije+YDZ/gU
         XNqhKkc26+tw2490eWBwUmCt53dutDwGsG4kVYkc5nHlxECYLuzEYDEIC2s7KSAeYCwd
         95HFrTj7r0eh9724WSt9MuXJQe8RIoba6XBxEhUJNfEag0BYwqvtHMuZHpJ4PoJJJqnK
         iJ8zFEgrCyeZ22ZlG72rJsAhnmUKtEL+IrrMPiOmQLb/hZqgnEut3J1TfsM0B7D55OS7
         ss0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755244998; x=1755849798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sxpExqIp6ahjSppu7+evxPdtuZCZlQ03AYV1e06qBjk=;
        b=NNFxl9o+23xyFatIyd0vyD1DSGCqtMN5iou6N1A+x45Yv7WeZF6DsIyYo3zrvfxY7+
         vkim3IEPDmwwyMgpe7l94pOOm3a2VI6iF9S6ElL4dqqBS5kFxpZOJdu69+79NWaSFws3
         xqhYtdXn2OFb12Q7sPhsN70Fc6l8BhEivqMm1ae8MQ1GZX1jhU5A73AoufPb2FFNTlDb
         YIWCIr/1nRCwO/VaHPPHrh3zAN/BJi4txTDb7OG68e6AjE/SWUD3Z5/MLEnuP2TZYse/
         9nSrayYFh/grKbx/Og78kP+rAM69TTHNkajFLD4Bi8hzffD8UY+dYK4iypoRUxya0Jjt
         jRDg==
X-Forwarded-Encrypted: i=1; AJvYcCVdoaqd04yfaHnB0JsRyYhp8172iG0k3tRjpUtrgv3aDuJp0fRTVGJfuymQf9/HIzWaErjmjNnT0Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxA7/y7X2na+/DIxhN3qX9aQ+9bU2Kwqh5GQiDAVdouT8FBeGND
	3rwNcejZjjSbd1Y7kicxWZizMcm62o0P7rvG9DHbWctjYqOS4rwKpSG7
X-Gm-Gg: ASbGncscegi9i9sGYKckNISHSuO2HKl/upKjH8FKOlFvoynnKapwqvwJE6LjwXk/5cD
	DEf6YkrqzETNd3Zp0TyOR2F3T6LF9QqRRHaULcBBoOtTkAUq8Bokv7GypKkrHq0DoweOgTbD53Z
	FaksyrbmEMAQBfENYRE1D8742d8VkGMz9gZYxQ/JCgHtDzaNNqQc2IcdpGcyG+9Ts5AMfBuvlic
	aAzDCnyzrLDAWIBLsSBTE1n9mxafKwuJ6fnG0tDR9WUYDoHL5JfPopVcyIMwueI1WWTiULOv9xV
	jzuu69sTJpj3XmQJGvrreOyMVbLfCGEbUnGESevGtgSVWH/Q8M9MQax9bVAFFLoPWNgZbb7g48j
	yP45vLQyepyS0+C9rwPQTgA==
X-Google-Smtp-Source: AGHT+IEC/iECvqFVBZ/+AEQhSpvCcYT2CGj6Zpm39HK2GsyEvn3tILjlf0yUe0BJhhZakucB/H8rvQ==
X-Received: by 2002:a17:903:3bc6:b0:220:c164:6ee1 with SMTP id d9443c01a7336-2446d8f17c0mr18321535ad.32.1755244998248;
        Fri, 15 Aug 2025 01:03:18 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d517e18sm8527155ad.74.2025.08.15.01.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 01:03:17 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 706E34278709; Fri, 15 Aug 2025 15:03:15 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Device Mapper <dm-devel@lists.linux.dev>
Cc: Matthew Sakai <msakai@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"J. corwin Coburn" <corwin@hurlbutnet.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH] dm-vdo: Promote dm-vdo title to title heading
Date: Fri, 15 Aug 2025 15:03:13 +0700
Message-ID: <20250815080313.25132-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=928; i=bagasdotme@gmail.com; h=from:subject; bh=qyzLs/0CDjVeqzhntZR/bU1gU8V1Hv1zEYSr2oMjvt0=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBnzXnza/uOJzUa/EyW7WcQu8z+U6Pm63lXgk2Tzwt9ny tZsXnN3TUcpC4MYF4OsmCLLpES+ptO7jEQutK91hJnDygQyhIGLUwAmcvkaI8NHmbJjLYekOLQ7 jh13FWDjkr0Z8lLsvegilqs/BIoPnp7J8IdbYLev7du93m5NmU+KW415//w5U5z8c16379H603d FD7EAAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

dm-vdo docs currently has no explicit title heading but instead there
are multiple section headings as top-level heading. As such, these
sections are rendered as titles and inflates number of entries in the
toctree index.

Promote the first section heading ("dm-vdo") to title heading.

Fixes: 04bf7ac646ab ("dm: add documentation for dm-vdo target")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/device-mapper/vdo.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
index a14e6d3e787c91..8a67b320a97b58 100644
--- a/Documentation/admin-guide/device-mapper/vdo.rst
+++ b/Documentation/admin-guide/device-mapper/vdo.rst
@@ -1,5 +1,6 @@
 .. SPDX-License-Identifier: GPL-2.0-only
 
+======
 dm-vdo
 ======
 
-- 
An old man doll... just what I always wanted! - Clara

