Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB5E1BC082
	for <dm-devel@lists.linux.dev>; Wed, 14 Aug 2024 17:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723657699; cv=none; b=OKaUAflDt18C6ILjoiC7qO6bbbzHQol8lNWnxI4UBeSEjNyIVFBfeFuRNjR8jpQ72yvRd3I1Do4XR5hy96G+aMggJh8iNYKAyYgfLyZWB0IpynvXqLf4e/UkKeApW5NCe2b02svGKkHu4pAfHrBm/7T82I/b+5xgdC2H/h/nSD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723657699; c=relaxed/simple;
	bh=I0q+hPjJFQPFw/7xMpBPGRI9GSR/XnF04oBYiCm3Esk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AfHZdt0/4/tgtmjRufV1rGXg/VvSMn1/UL1p8ypOnurCMPGaVEVKd03rI4CCbLW2eWArCPD7gBMT/r8mPNy7d+cse8NEbCHDipvfuZj8qJWikoacOIFgQhgTNHvwnDnW+q9UbScHx4nWpUyIE48esETLxoPNdkOt8sMQcJtxdSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JgG3qJNh; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JgG3qJNh"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7093b53f315so29434a34.2
        for <dm-devel@lists.linux.dev>; Wed, 14 Aug 2024 10:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723657697; x=1724262497; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EqbPHwcB9FwXLops87ZQEDiiS6X0e1o/bVoiwi0c1Sw=;
        b=JgG3qJNhYEuaPGiVUOr6s6UXGiTaXYDDzKSgKzPTYC1145eWOKltKexhI5zxq4PLT2
         jECI+s67C4azWCQAFcV8S0bB9Hk7IKkLQN++ZzFLcE7oNMkrGKo6m8cRgw6QRyMTAohQ
         R7EAksCng18iW3CttA8eUKN1mG1jUcK6pQla+WkBb26tCzarvkAuh8OT3mWapcWiqnYR
         0tmwJMlWBgIHN+mZ1EsGw/6sYccC+CcVViVy1qisp5NKzX/P1XESueNrfkdfra6M6ckh
         mFJ3d/XW6FOgEx+CO7p9n9m84K0TFSfwBortG3LfJC9cGdS4WMSvnQd4inkO8erjQQor
         HlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723657697; x=1724262497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EqbPHwcB9FwXLops87ZQEDiiS6X0e1o/bVoiwi0c1Sw=;
        b=mcAe7nFHhel/clYBep84Lssd8gHm1VqRJsosJcZaZyjq4mKYrr/PS3npw1KX/TtOsj
         G4xGiNt4I7EZZFCjyJlsMr9ss0ahpZ3edbztK97dZLWfjas6dKGENDOCrC5XBVUxLOYz
         tKDUGGwBrPZLc3v2eOOb0grxxjad6GVqFPnjzByWhtTq7Av0l3gIwPJDjvU1o6Y383vl
         pgVo4RRwHdN3cgRPMACtNVs7+FhPzqoX8j4ZfinLdmO9d1yhNgEYLnSLho6UAzEK/M8c
         phBMXBsQYGutx9JD/w/vjQ0iVE9OG8iH1nq5YWTz95U4DEwcHKyImdMSb7+8YZfbV3S9
         xxrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSbY2GeaJcvXzwqYNPkqhh5csJo7/kM4QlnaiFz6zDZJKv0q2QRn3u3zkg6koq/bU6Ic4dqj9DS1ZQUFjCWxRwFy/HOG6P7uM=
X-Gm-Message-State: AOJu0YxIXwqETAAIzswz1V3ux9dUY+FDkhp/0Rqpr+7fcDcjrDCrq8I+
	f4a7L2xgJpi9IsfVGr+9GdsRD/k6t0W1GJiLLswNs0Ei2xzO8Cjw
X-Google-Smtp-Source: AGHT+IEsrGqlWyV74T1sPq3DeKe4yW2wn02CrmPPea5WlxKLT+tDXQw4H/H07Ae7kpr58ShOEK8hMg==
X-Received: by 2002:a05:6830:43a9:b0:703:6aa3:d091 with SMTP id 46e09a7af769-70c9d955a21mr4813776a34.2.1723657696732;
        Wed, 14 Aug 2024 10:48:16 -0700 (PDT)
Received: from localhost.localdomain (183.252.23.34.bc.googleusercontent.com. [34.23.252.183])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-70c7b89c058sm2295637a34.79.2024.08.14.10.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 10:48:16 -0700 (PDT)
From: Eslam Khafagy <eslam.medhat1993@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Cc: Eslam Khafagy <eslam.medhat1993@gmail.com>,
	dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: dm-crypt: fix Unexpected indentation error.
Date: Wed, 14 Aug 2024 17:48:12 +0000
Message-Id: <20240814174812.3695813-1-eslam.medhat1993@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240810211557.42874-1-eslam.medhat1993@gmail.com>
References: <20240810211557.42874-1-eslam.medhat1993@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix indentation error at Documentation/admin-guide/device-mapper/
dm-crypt.rst when compiling the documentation.

As per sphinx documentation: Nested lists must be separated
from the parent list items by blank lines

to reproduce:
	just run "make htmldocs"
observed error:
	Documentation/admin-guide/device-mapper/dm-crypt.rst:167: ERROR:
	Unexpected indentation.

Signed-off-by: Eslam Khafagy <eslam.medhat1993@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-crypt.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
index e625830d335e..dc6ded632b22 100644
--- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
@@ -164,6 +164,7 @@ iv_large_sectors
 Module parameters::
 max_read_size
 max_write_size
+   
    Maximum size of read or write requests. When a request larger than this size
    is received, dm-crypt will split the request. The splitting improves
    concurrency (the split requests could be encrypted in parallel by multiple
-- 
2.25.1

