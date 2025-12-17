Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6FC30F93D
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006490; cv=none; b=mPeHrJawxEOrPh/rDcvrzDKu12qscr+I4for7EMC6jeZ2cvjFNJ8vR8lkiXdzoS1/+uJwNku17QbG44OTkWx78cEqZQpJ1cdEtWnFK7V7YLa+C48VOuGZDb6LLbCk+fNuu/53l97e5gO2y02lLh2/0oDxp+Or5iabt8rKNdKSyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006490; c=relaxed/simple;
	bh=sIylNHbBT6XVq2r6xbBddVkSR4ZGIh3L4+X8x7oK6og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g80ZY6EgqzQA7gi+yQmPqkdjmA/Vxtt5BNcTliLNq2YTEm9zJy30lzh2Px8t8CpVHGGzh/Ib2QELsGrPYbsIBYoFpub+7ak+4wfKXywO/NDPRJl96PeAKIbnoSj7928rACPbqrCObPKU9H75pf4rM3W4yHjNM2bh4+2swcYdPKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V5tZ4T8o; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V5tZ4T8o"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so11690401a12.2
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006486; x=1766611286; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tNY06eDeazig9l+Zspa3EUzx6BHxCjx0NPjbkaSktwg=;
        b=V5tZ4T8oiVbUEZTbAcKwwczAHsTi0nxAK7Py73+VeMEKxrPNU/X1QdngWNkiWdeJg5
         q+6na1YlQ9icpxeGjgWiwdpGwXlt9z3W5THVXKhBdvtaK8qTBNmFDkhWKjlAtyppN2Uj
         5NTgqbWp0rqwI9JfDz7Ah4vnAwWOcidELUoJ1dqsXtZ9hb4qby8EV+McRkdhsawmFVPQ
         XzqGUP21xV6WSMxAY9/PTV2/2wKHcWEgi2Rx3Sl/3FMRA72qjPgIYrTMkfs7d3GGUoNb
         1TxD0FNEa1WP6fJxLiL60ItbaLBzMPai/vcGN/y7LzgOLj5rVL6sDkLxDzBEdJyuyhga
         I7Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006486; x=1766611286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tNY06eDeazig9l+Zspa3EUzx6BHxCjx0NPjbkaSktwg=;
        b=IH/r5J/kgOrXFGPiczXxoyqRIHeFA+xHiRvVknQf+N+FeuORE8+kKRZDqPYPnF0LDX
         9AvMES4z3AQwm+OxWyf+uELwSWLV8/o8+SrPWo2f7EfsmFKUFLeTAlwn7OBxW0anB/9k
         dWJZcdT6TC+CK4J2P8iU9/uVuxrMzCbmNH/acknHfoRS7ikkl98690DQhOE7H2BRjMGv
         MTedpprCtRjPcKHbdlVqJ1+sDGHwfkeo7FRi9UU+xs+xnB+jBMa4pVY9N4RKzFeSK3GA
         e1Oo/gejU3PPgo6wyGknLTdR7l3NNgoTgt2ADxYgIeW5IFMHzrW3j0wH4qPERWfyh+Gb
         51KQ==
X-Gm-Message-State: AOJu0Yx/mgVFL3LLa0aV2YeGK32DCkH5S5jqBCppL9pCYLngCmwCbQzD
	opy5LbY2Df8g/cLFoOd4Abfbz8AmUQIiuaem/3AiV0ERB5ThN4MG5LZCGK19nwKAZIk=
X-Gm-Gg: AY/fxX5yZWuH5gR5qWtkMR3CVc08NcpTRc+nJKl6uV9tEtzTmBsfjxSiooJ02T+MTGb
	TUF3onpotr+xIN14WA/jHfQcQmxluVquSxBJKpzXNKYZuYF2imvoyVQVlxLmMC1pCy9vLB9QgwW
	LPjr6uzB8PDuTEktgpkri1gfDPlsS9ntLqgFzzKzQ9dk3EIGGWtIR0iSfmjrghbUlnaiNyEDBwU
	kD3gpmtPL8htIIYgCSB/O/9i6wCODAR38XQQ/XvBX1OriBsHPMBINk8QcNL7zkNM0Fs7FJdjtXt
	Yc0pgCRdJtt0e3I91bjDHTVYz/7qi0KMr+UI7B+/f38dYGvGdVhyCOmUmBt19qIHjMsx3Ar70Am
	BVy0ecBIEIq0kitMddvFwyvid6fTc260ZeXBMDRJkw+CijQ12mxl616bcxlD2gPKCLFMM7y5jr1
	Aal7UYl7cLcoQlLUkQati/5qt08BXx21/wN35M9nxkUWydzBsY883z07Skuv7VvwA3iPHO2s00o
	w==
X-Google-Smtp-Source: AGHT+IFLKNVfdj9Q8mE+GnW8h4CbkpFc5Ky5jabFa7dA1/xAaE7mbiBqkJfI52eVST1OqImPPPs7hQ==
X-Received: by 2002:a05:6402:5242:b0:649:5d3b:db3a with SMTP id 4fb4d7f45d1cf-6499b1568c6mr18244850a12.8.1766006486209;
        Wed, 17 Dec 2025 13:21:26 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b58884fadsm510933a12.25.2025.12.17.13.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:25 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/21] libmpathutil: constify find_slot()
Date: Wed, 17 Dec 2025 22:20:57 +0100
Message-ID: <20251217212113.234959-6-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/vector.c | 3 +--
 libmpathutil/vector.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index 3d54ed9..3e9f941 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -81,8 +81,7 @@ vector_insert_slot(vector v, int slot, void *value)
 	return v->slot[slot];
 }
 
-int
-find_slot(vector v, void * addr)
+int find_slot(vector v, const void *addr)
 {
 	int i;
 
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index 0701277..7b2c559 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -74,7 +74,7 @@ extern void free_strvec(vector strvec);
 extern void vector_set_slot(vector v, void *value);
 extern void vector_del_slot(vector v, int slot);
 extern void *vector_insert_slot(vector v, int slot, void *value);
-int find_slot(vector v, void * addr);
+int find_slot(vector v, const void *addr);
 int vector_find_or_add_slot(vector v, void *value);
 extern void vector_dump(vector v);
 extern void dump_strvec(vector strvec);
-- 
2.52.0

