Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDDE1C9DE1
	for <dm-devel@lists.linux.dev>; Wed,  7 Aug 2024 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723021289; cv=none; b=MOm9R0Fjc30J1f/zlQuuIU4VyfyxKlWJjYjUou5FFSk5mQmEr0ZnRKMXVYG+95dbGaIRArQKp+Lp7QViH0uNT6Iu5FkOYOkTufm8nXi6eXEFVaUIvGwDP3VYnV9W/W8Li7ATa8+7xUl1ke3JiHKLQivH/jEzB3nkuU4uf1/oEzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723021289; c=relaxed/simple;
	bh=SlX8DXsZ+LVAASbH3Cqud1npEMh02BJvpmBSpjguCLs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n4dVj9rvW0D0OwQ0mOMxDG30kCTTO7SDIbh90178eCBNM9p5pyTKAAMyGesCzefAsKKeRPM3Sit9YKEPv2BUyIn2V3fvD9Em1bkNhYtt4yFPXyKeYNMCZUgK8B+sNQZheoIa3ZdjqECR3PQHhq8Mz19CaW+Y5a+KhGD9SW1ijVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HcM6hNst; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HcM6hNst"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fc52394c92so17131855ad.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Aug 2024 02:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723021287; x=1723626087; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vZyYZcWScXx3hCzshTooGI4mg6we9/4Iww+0qQQ3pQ0=;
        b=HcM6hNstFGi3Wb5dNyR9v3TjcOHHuU1fPNkT/nUzLzT4uwxCMccNxPzJPaubyRX5Ld
         rtXVoULPCF8rSuAlOnPwhaW+xteKW8THHsi5nTknjPqJ/pw533TWEgu28Qb4bsmAOCJN
         aP1LDRj5CCuCoJYnLDVP+OhSJZpjig/4lwA+SL33jwvbpH0XvJ1f66pkQdFbVWOlCXZu
         9FXen32ltK0MwT+ujL9qjp9pf/Kl/7bHRw8P1jIDp5gAW7fwgKma6ZgFtb8cwuYteikt
         tD2Rrrd+JukDKu0mkYu5e/EaoVjZ6BkSNnF9aYbLC95vjMuI6QdqkK/+oU16GwH+MoE+
         RKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723021287; x=1723626087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZyYZcWScXx3hCzshTooGI4mg6we9/4Iww+0qQQ3pQ0=;
        b=tCCnCFlIepSoacV33AXfPVfXx0WXa7oIIXr9bHqj9JHo2smBO660OUFNBxNbrfFYiI
         fiQIf2GvO0Q6IC76fUpx58AghyUsjw10xsIDcmKSJRO3lrQjwu+4I3rDyItcyVtMIkOM
         isBuE04sNXKgAasHdfyVtfW1LrHbp5FqnMgMEITqXH180TAEw6lKlosdfSqGDa1RmWwh
         aORe6nrVMY9lrj9ndg3ahVs8Xu0qAoW2OQNsVOn98H3ir+XXbzSSjimBK3jb6hajaNUm
         yEN4/nA0bbcuNztGGEyux4MVBX9vpFTKRV98lCe3HqdxNF6e1Ab559ZZKFqO0RGWEzL3
         z0Dg==
X-Forwarded-Encrypted: i=1; AJvYcCXpM6FNpwzZqPbzUYzHGYkun3Ot0EHSPRHrR0moftvlRMYS1cFsVIWzRkEtG7fpnCSVYtMM0OCvvNJbmn/ctW8uwZ7OhDt1mfo=
X-Gm-Message-State: AOJu0YwkC4wzhumCcCRnRTJC2JXlLYu/zzu1DaG4i/KD5wxLP7gpEVIm
	w/YnWMl94jqVuM7lKWc91cEG8g+/tBTLvvZCv7PNC2UD+awNrG3M
X-Google-Smtp-Source: AGHT+IGS0K1I+nQ+fdK7tmFOM7XFjxcXffIfoQoZ1ulc1qDVT/0KTpNDWEz9eunY8iwx/PemP6mjFQ==
X-Received: by 2002:a17:903:1251:b0:1fb:9b91:d7c9 with SMTP id d9443c01a7336-1ff5722d9aemr255334385ad.4.1723021286963;
        Wed, 07 Aug 2024 02:01:26 -0700 (PDT)
Received: from localhost.localdomain (c-76-133-147-99.hsd1.ca.comcast.net. [76.133.147.99])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-20077167703sm29747145ad.86.2024.08.07.02.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 02:01:26 -0700 (PDT)
From: Daniel Yang <danielyangkang@gmail.com>
To: skhan@linuxfoundation.org
Cc: danielyangkang@gmail.com,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: dm-crypt.rst warning + error fix
Date: Wed,  7 Aug 2024 02:01:21 -0700
Message-Id: <20240807090121.61064-1-danielyangkang@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
---
 .../admin-guide/device-mapper/dm-crypt.rst        | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
index e625830d335..552c9155165 100644
--- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
@@ -162,13 +162,14 @@ iv_large_sectors
 
 
 Module parameters::
-max_read_size
-max_write_size
-   Maximum size of read or write requests. When a request larger than this size
-   is received, dm-crypt will split the request. The splitting improves
-   concurrency (the split requests could be encrypted in parallel by multiple
-   cores), but it also causes overhead. The user should tune these parameters to
-   fit the actual workload.
+
+   max_read_size
+   max_write_size
+      Maximum size of read or write requests. When a request larger than this size
+      is received, dm-crypt will split the request. The splitting improves
+      concurrency (the split requests could be encrypted in parallel by multiple
+      cores), but it also causes overhead. The user should tune these parameters to
+      fit the actual workload.
 
 
 Example scripts
-- 
2.39.2

