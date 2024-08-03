Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2791CD24
	for <dm-devel@lists.linux.dev>; Sat,  3 Aug 2024 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722709994; cv=none; b=q3n64xIpkxxOFlxba0ZA6YM4sqpiCHJRqcN5W/pMTN6QfJsrBuJeRsN+oEWWkrdUN+yyurT/LaGG/3ol4SMnPBf3XT9jjBJDtndEOnjkcdaG+oKleCuzYokjFTGfn0U+fBkbB4TlBi5E94RZaYCMrO/jzF/HpyfcOmz/J1jAoVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722709994; c=relaxed/simple;
	bh=rATF4I0UBm/YSsPSLhag8cqUaMrh2onGP0nh98LCzWk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m8X+gYBJ5t+96f9/Q0g/CaUZNRRlit1sQh7bvGvtlAMmCM/kCe0P3XLV+4CC8klpZry6KnyDtDvj8uqZuUncUCaS4gfnVjXea3fKl9C29gasD+XWPsWef08Rt6t8hxK4Oi0LOe/P/Imy4CTC/qyKcl0c9HdhvtlHevKruLcwiGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lv+ZqXCK; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lv+ZqXCK"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ff4fa918afso21996915ad.1
        for <dm-devel@lists.linux.dev>; Sat, 03 Aug 2024 11:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722709992; x=1723314792; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X2aakKcJP9JsSPtIr8v4x+tP3WdwFQXm3AQeWrFOwVQ=;
        b=lv+ZqXCKslKNYC9Ci8WRjrkTH1TLZSqC3olyDnDBeNEb4D3/DMYqf1vt9FfNPqb5z4
         fRkVEMLtEmqsonvxyK6WTdME/fBPbFjOlhbqSDJ/y6cFjzWyNOb7BjUwn/8HoPEEmux0
         V7wSQ5Hw6Z/ccWwUlWkiZgomvw53V3HlK0LP7kc9239x6eSjeWv7yh+lTqFKD3ScEZn4
         ikrx5ihb2POJiUWBA7mTXqshK0hDlA7AL75gbmPfRWD5bhhyhOgVpI5AWIioaLYfWKQJ
         hQw91lCHKNyVPZCYpW8XxduKMQF256f1YgkqFTGum+/AjpWVfy0fh1i9ce5GKY/8K2rZ
         IB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722709992; x=1723314792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X2aakKcJP9JsSPtIr8v4x+tP3WdwFQXm3AQeWrFOwVQ=;
        b=pjV7GbLoOsZlJew8Dz9leyASfjUI245WA3qYrttdoEoozcXSlrNDSLukSb/iGOTDN1
         bXZ+iFEw6ZdBbymcH6HKloLgtXENDFv2f7NNVrdTdDJ/RlGxsEDjBdbLnSWqlERbKwon
         dLrDVDJBOU73hSDdjr/7g7BD3YF9/ClJSmUZDJR+PGJM75ht9Pfmwvqvuhx4AE4dObHV
         X0D0BA7MUaeeLBs2bHzz2N1FDTCWCU3TSdtzbLN/2FUjHlmwz6PGQQC2bZ9mklJw2Uw8
         1y7g5OscU+U4zaFOFNaRGoVgOJrdB3gPUlluEYM/+p16Yt4xheQyXhuYetmqKZS5owbL
         1QEw==
X-Forwarded-Encrypted: i=1; AJvYcCWCkvqWDxW0GJoNg0JSJWLdzcWYp1yK3fPYPAPPUtYSbdYOjA9JoLt7o26sPdBxYq+BZf/U9duojQ1pNpGqROu9ZFYFt5DVm2c=
X-Gm-Message-State: AOJu0Yy8USi2j1UYs/yKmscIwpDEUfKaP+rvGpa9r95J6qxSLBVFr9By
	bE8TzuwpWGpI2fACMe/OrfCj4PIvTGb3N9WZ1DkgnOK4DjTsKKfY
X-Google-Smtp-Source: AGHT+IHk2tCzpQmuh++pUzLvkOxxeNWPy2ZmkonA7aKva8irybQM9CH0bUHgy/A7WMxoONgpFVtJaw==
X-Received: by 2002:a17:902:ec83:b0:1fd:9590:6550 with SMTP id d9443c01a7336-1ff574dfe01mr83592485ad.64.1722709991809;
        Sat, 03 Aug 2024 11:33:11 -0700 (PDT)
Received: from localhost ([103.121.155.92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff59058d7dsm37943325ad.142.2024.08.03.11.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Aug 2024 11:33:11 -0700 (PDT)
From: Shibu Kumar <shibukumar.bit@gmail.com>
To: =agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	corbet@lwn.net
Cc: Shibu Kumar <shibukumar.bit@gmail.com>,
	dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Removal of unexpected indentation error
Date: Sun,  4 Aug 2024 00:03:03 +0530
Message-ID: <20240803183306.32425-1-shibukumar.bit@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While building kernel documention using make htmldocs command, I was getting unexpected indentation error. Single description was given for two module parameters with wrong indentation.So,I corrected the indentation of both the parameter and description and also added the description separately for both the module param.

Signed-off-by: Shibu kumar shibukumar.bit@gmail.com
---
 .../admin-guide/device-mapper/dm-crypt.rst    | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
index e625830d335e..48a48bd09372 100644
--- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
@@ -162,13 +162,19 @@ iv_large_sectors
 
 
 Module parameters::
-max_read_size
-max_write_size
-   Maximum size of read or write requests. When a request larger than this size
-   is received, dm-crypt will split the request. The splitting improves
-   concurrency (the split requests could be encrypted in parallel by multiple
-   cores), but it also causes overhead. The user should tune these parameters to
-   fit the actual workload.
+   max_read_size
+      Maximum size of read requests. When a request larger than this size
+      is received, dm-crypt will split the request. The splitting improves
+      concurrency (the split requests could be encrypted in parallel by multiple
+      cores), but it also causes overhead. The user should tune this parameters to
+      fit the actual workload.
+
+   max_write_size
+      Maximum size of write requests. When a request larger than this size
+      is received, dm-crypt will split the request. The splitting improves
+      concurrency (the split requests could be encrypted in parallel by multiple
+      cores), but it also causes overhead. The user should tune this parameters to
+      fit the actual workload.
 
 
 Example scripts
-- 
2.43.0

