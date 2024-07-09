Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B36189F46
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561227; cv=none; b=fjzCUlq3WgHBbvZYfjcM1VfOvh2rzQ+pwC4NcMfXv3OGeWoksoFgvnhVYh6pvPE/MMlFBqtZxcNJTtOXdZICPdrS8AuwqXiGapZzkfs1VLgdPuXf4nBL+OOq4m7sue/Z8GvOw1LIC9q/qkn2qrpyoscHzOAEtKN4RqSRt7IBs5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561227; c=relaxed/simple;
	bh=mTYQ+8YiaxorU55+pZYprsoyhthFcahbVUQKEqr9T8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2J3J3khVwYfOzWe3ThzyWPPQF5Ey8qoB9ccJowtic9lsXres6PZX4CMDzWFBdevcLyYTOz/bxmye4mxCtP4ydGFTQn7t35cD7mCBIn2AFTEzlTe1Xl+F+5uUVVF6VMq/4pyYxQ6m2nCggDxqSRO3m1pLWpSP85oB8JdA7JO3bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UQqAGERu; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UQqAGERu"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a77c9c5d68bso551839966b.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561224; x=1721166024; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5RPfust5WVd3fbSEt4Bek4eEB+z5Zpc1MlgvTLyqxGc=;
        b=UQqAGERuj+goLv2HLm6f2tcxhOED8NTZrW8heGqFIBuOCJUwmQXWKwrO2RxnS5i0W6
         JbiBAbbE1pVplPeD6GrhV/JjO8OmT2SHJctK6EZaI1vfNkMsnUqF9x6iCEHuKzp3REtP
         Ur0DkTeBOkqPXkZKs92a14Rb3L3NpWdmQRkW6A57et/o0Q+AQbf34WAxW4KGoI27CAJ4
         UreG5nydKRA+wfjaoLsF0JNz1usalrnrErpIxJbhag9Q8/yAAdW/dKmNMk7JuI1aKTfg
         YC7irdc6X0p6BuYokAKi9cIVB/QW84rFckRpew2zHwGzg5xSzwhVQ/nbOoMH+IVIasFL
         E+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561224; x=1721166024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5RPfust5WVd3fbSEt4Bek4eEB+z5Zpc1MlgvTLyqxGc=;
        b=h8UkWOzJMYo/wOm+QkMPhT6k6kOTxuyMe4mKZJe3aLOoc087i2oOGW6Ra5kFtQpZ6a
         VNF6EnSwjYOLUktc9QZ/8HXlL44daIknoLf5up565YhRt2urzvCcJ9dNCkpw/Be76AnT
         Fk09o/YzWB4yiDczJlyTLApXWwSQ39owvPwCW3bc/8RRkIsT2WAp6jM4cOceh+fsJtOx
         sMvxHSYrAJytYgP0qjNAgaLIlD1AuBRIy0A3joEUlG8awdCWJ979mk/j5kLapKknWGs7
         xIfIikkOyvfwWjrZsHI+3c/jgqgQwN/uiaielMCxPeBFCi0ys3BhXIC6GbwxROkwrrNH
         pPmg==
X-Gm-Message-State: AOJu0Yxtr4nqtLE0qZZisnMSqqBR72LpvQeQl66jUYqB3XqAHJu3qz46
	Pi2gufKlVh/77+WEgodRuRUMYMqUhr1DccTNA3yKe2suhPHdlmr/mfKCoiv7JqQ=
X-Google-Smtp-Source: AGHT+IFYZoO5jUjTwMk7AI4wl2X9Q9rw6GjITMV1KAo7Ol4Crz0eXGIk9R0Ws7JcRmqarIR/ZfzqlA==
X-Received: by 2002:a17:906:b20f:b0:a6f:1443:1e24 with SMTP id a640c23a62f3a-a780b70176cmr237116366b.34.1720561223466;
        Tue, 09 Jul 2024 14:40:23 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bcc21sm109112466b.16.2024.07.09.14.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:23 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 38/44] libmultipath: split off update_multipath_table__()
Date: Tue,  9 Jul 2024 23:39:29 +0200
Message-ID: <20240709213935.177028-39-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split off the part of the function that does the disassembly
from the part calling libmp_mapinfo(). This makes it possible
to call the function from a context where the map info is already
available.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version |  1 +
 libmultipath/structs_vec.c        | 31 +++++++++++++++++++------------
 libmultipath/structs_vec.h        |  2 ++
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 5b8f9e0..54b5a23 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -206,6 +206,7 @@ global:
 	uninit_config;
 	update_mpp_paths;
 	update_multipath_strings;
+	update_multipath_table__;
 	update_multipath_table;
 	update_queue_mode_add_path;
 	update_queue_mode_del_path;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index fb3aa79..fb74923 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -480,6 +480,24 @@ done:
 		condlog(2, "%s: no hwe found", mpp->alias);
 }
 
+int
+update_multipath_table__ (struct multipath *mpp, vector pathvec, int flags,
+			  const char *params, const char *status)
+{
+	if (disassemble_map(pathvec, params, mpp)) {
+		condlog(2, "%s: cannot disassemble map", mpp->alias);
+		return DMP_ERR;
+	}
+
+	if (disassemble_status(status, mpp))
+		condlog(2, "%s: cannot disassemble status", mpp->alias);
+
+	/* FIXME: we should deal with the return value here */
+	update_pathvec_from_dm(pathvec, mpp, flags);
+
+	return DMP_OK;
+}
+
 int
 update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 {
@@ -504,18 +522,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 		return r;
 	}
 
-	if (disassemble_map(pathvec, params, mpp)) {
-		condlog(2, "%s: cannot disassemble map", mpp->alias);
-		return DMP_ERR;
-	}
-
-	if (disassemble_status(status, mpp))
-		condlog(2, "%s: cannot disassemble status", mpp->alias);
-
-	/* FIXME: we should deal with the return value here */
-	update_pathvec_from_dm(pathvec, mpp, flags);
-
-	return DMP_OK;
+	return update_multipath_table__(mpp, pathvec, flags, params, status);
 }
 
 static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index dbc4305..01f5dc4 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -33,6 +33,8 @@ struct multipath * add_map_with_path (struct vectors * vecs,
 				      const struct multipath *current_mpp);
 void update_queue_mode_del_path(struct multipath *mpp);
 void update_queue_mode_add_path(struct multipath *mpp);
+int update_multipath_table__ (struct multipath *mpp, vector pathvec, int flags,
+			      const char *params, const char *status);
 int update_multipath_table (struct multipath *mpp, vector pathvec, int flags);
 int update_multipath_status (struct multipath *mpp);
 vector get_used_hwes(const struct _vector *pathvec);
-- 
2.45.2

