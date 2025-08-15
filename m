Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6239329D28F
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 07:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755244608; cv=none; b=P/Zak5atgBCCUkYCleRZ6y3j+V5gJeGp+GvXKzsorMygAzZBpuMagrKpsw/ddHFCegsW+i9fdb5UpRTc/RajwZu/QjDG46GOTaJQKI0U5FhyQrF0Zw8bp0Ky8Y3KVyNeN3MOUocwTk3zvjDm7B/1kLUF1OHYpb6Jv9rKFbfXSBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755244608; c=relaxed/simple;
	bh=BSdi2w3mGBfqx7vQ62yyAGKSjWZXG1QSCbm15ZVydcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FqmUZR1e+0dhv7hG8W+ExJauS/TbQducVKViYfSQfnndFd07bgRpeSyHFbZdoVBX2rF9c9IEltbT8AX7QS40YIfKbjG5tIgOObSV2TLtQ+XvaTtSxYz2U8gA141u5opXn1fdgZ2UEGlP+Dky8PyLmRIvx6QSL1vFhdnVsqtat2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cx90txLE; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cx90txLE"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b4717330f9eso1214315a12.1
        for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 00:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755244606; x=1755849406; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SqBwk/eT0E+fNoZp9YX9tGh8FiPKp3ALbCTa/kbWN8=;
        b=cx90txLE1mZ3EWtGMbAPwrO6dVntcDhQgsdTQepu6gGuL3y8ZnpsSo15E+uDakEW3a
         1PaSiD2MXAV82mld2TvqfemaNmZ3t9G0Nvc4OSGQyIE2BhIzQETPhxkRaPZ1IRqPQjqX
         W+rMWIzQnOrrMEkvtwwzpYw4J0rHTajdOEhhF9SW0oCK9lk0L0cG0eFhDaeqE5MKWptV
         IC9948/enzvK3eAL9G+DQzj/Ag9lPdY1nw1CBsdDRVs+8EOIl3Pod2xFlV49Vh8HskkI
         dQCDla+M8bDJj2nLYP18PT3aeFtSzd3ZlNd42LRPYfh4gYNyrjyhnQVhfZdgosFRXv5U
         XDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755244606; x=1755849406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4SqBwk/eT0E+fNoZp9YX9tGh8FiPKp3ALbCTa/kbWN8=;
        b=CxYlZ4M6ByIAy2Fr7/DHyl7xNQzBQBiAb61TwR5+aD4sYI+7zguSkf9XMRUbZyf0m5
         9Z7sttU2zWqtxO/1A4K8//sRgHeZcVVhFvw65ehhY6TfWuZPNzjDOFhXxczveB7fKLsP
         aoJp58dwybPvJWR8lP0vDhKa+ymrh6UlqHg1mPKHk7QGXy77gR/42NHA2jRaj56npTkt
         arnJrRvulIH+otJ4wkJmQV3GBbHaQuGaKk1SVbtiZERQ9DUZW3E1EozBb1PW8y7OKEZZ
         mJ2RZfBX2P+YBr5o3ZxwlgXPANgdMe7YgC8DSBacol+UcYUrQByGLBzuhb2wLpWLzE7Z
         iSCA==
X-Forwarded-Encrypted: i=1; AJvYcCXLNLcnReMCRLkw5/DUl+S2edad7uelg0JsnVOKl0t1piLBoI8QSpPSedjAjmI1nE51IMbpcLhh+g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxvZcS+8W3Y5/4AWJtCTAWOdptcvmCKPcFHc+mZjn2TutKayhci
	UILv+1DgFUFDrnKvK0HiIYcjYzAw7YrivNhDMjFhLGqRgU4b244J6EN0
X-Gm-Gg: ASbGncu7+H0M2o9MYZSpJ5qjCnKCOCwOUWwCVK6HX0PRwfUhh4kZeLUNrlDCklmumrJ
	l+OS4dOc29ccvzEv1I8L61KRiYMtZgPfiCFkJGKySYi3VrGIMhmhpfyTyh2xNWQsLk+yACSgh0f
	ZBePtUseY3WCzrRPCSr+T/uM23BWDpPd5o+E/NqHa0/VKVxiCloW7Qzzxs7pnY36bIlx7QZ5Bx4
	BWA2KglFanYOpcPqdIiQiHS/u/X4TF3q1Bh9wVhYSWfTwS3dGepchebUzJabssgdxHKxYcI4TwK
	QG5Kl5l+0FzDtBLba5b7o8qH7t6nZiXoP+L2KRV2yikf5fID/TqkvpUp5ttHgjyrdzlsFLU43eD
	5K8dyA79jGe83XKMb6DyKLQ==
X-Google-Smtp-Source: AGHT+IF9ucjW/KtwwO3q2uYVf9EFn3Mg/zyi7hUeanmOPhSmnzBBOZt2Q3XjmVtqygSPlYAgPovRow==
X-Received: by 2002:a17:902:d488:b0:234:a139:11fb with SMTP id d9443c01a7336-2446d8b1f78mr16115555ad.27.1755244606499;
        Fri, 15 Aug 2025 00:56:46 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d54f8b9sm8483715ad.130.2025.08.15.00.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 00:56:45 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 3A2C142D95C7; Fri, 15 Aug 2025 14:56:41 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Device Mapper <dm-devel@lists.linux.dev>
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 2/3] dm-pcache: Use bullet list for data_crc constructor argument
Date: Fri, 15 Aug 2025 14:56:15 +0700
Message-ID: <20250815075622.23953-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250815075622.23953-2-bagasdotme@gmail.com>
References: <20250815075622.23953-2-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1798; i=bagasdotme@gmail.com; h=from:subject; bh=BSdi2w3mGBfqx7vQ62yyAGKSjWZXG1QSCbm15ZVydcE=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBnznq+fdHNXPKfJo/Se5TdDNSUC+2WSz+Q9dHljJ3fI2 t1r67ajHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjID0FGhs4d39cL3bu/wzi4 Rtt8jb25+P0ktTNhU/1spt44sqC+7yQjwye7tXwp126sCzNKE+rjfPnGNjSFc8K6u2rXVz/M87/ 5jgEA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Sphinx reports indentation warnings on data_crc argument description:

Documentation/admin-guide/device-mapper/dm-pcache.rst:44: ERROR: Unexpected indentation. [docutils]
Documentation/admin-guide/device-mapper/dm-pcache.rst:46: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]

Fix the warning by using proper bullet list syntax.

Fixes: 6fb8fbbaf147 ("dm-pcache: add persistent cache target in device-mapper")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250815131115.45518c74@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-pcache.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-pcache.rst b/Documentation/admin-guide/device-mapper/dm-pcache.rst
index ecd015be798243..02cea738ae131b 100644
--- a/Documentation/admin-guide/device-mapper/dm-pcache.rst
+++ b/Documentation/admin-guide/device-mapper/dm-pcache.rst
@@ -40,9 +40,10 @@ Constructor
 ``cache_mode``              Optional, Only ``writeback`` is accepted at the moment.
 
 ``data_crc``                Optional, default to ``false``
-                            ``true``  – store CRC32 for every cached entry and
-                                      verify on reads
-                            ``false`` – skip CRC (faster)
+
+                            * ``true``  – store CRC32 for every cached entry and
+                              verify on reads
+                            * ``false`` – skip CRC (faster)
 =========================  ====================================================
 
 Example
-- 
An old man doll... just what I always wanted! - Clara

