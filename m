Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1664D171644
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804577; cv=none; b=mp1pqJ6mDeKrNTbVNmhyZkE4HLwpSSdY3nansZg48ldO9arVLt+O3JTfuClesSkC2QE85ZTm2jORYH40g6UhDUVJ4uHkRcM46AW4ADxMV3oETx86hJbCijjnd1CmhsHhDGUestAB2K8EEHlRUwma7vQwohprzAm8lvDrj7L/qiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804577; c=relaxed/simple;
	bh=bv2XiB53844utqamUEmtJ6ZlUTjE1ZLSB3RHagXCOEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiKqZkmaLvPXucl3/yqdckQUClckKrYMZaH8T/apMVrWUfyUz16jXlyY2q1gsh0AWMHnMy3GQs6wBIti7Gi1A+vkpdFEkDaL7tLrO6bcnI86KGM5boNV1APOYUGXnJKolSxzkCFRcKpE02zWRqxA5afTjGEyQ4GGZXPu8oLtMYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ew4LDbke; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ew4LDbke"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52e97e5a84bso3267622e87.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804573; x=1721409373; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQdLiGWmsHk+StvFm4Bmikh4b/IlgqNFJrtjTUzaBFU=;
        b=Ew4LDbkeLQ09LMRYMMTJMCrrCcSJL8WJxhocn7Tw9XOoeb+tQ8sao0hTRN3KI+R58L
         fXMVUn6K2bn36i000+OJb0ts4E5Q8IU6iqpRvpT4IHw9rgMdgIhCm7pDcpsluaIiIwkC
         IU4Jrc0hAeJ4R4tWYOFcdOL09RFdv46TPdvIeaZS1nJ7qQzzSszatApiYJ2cQFoTh8Dw
         lHIccSkZh0r60RGG44sgXlzKXzZZRCSwT9iJwEeNwRdL3YmkVfF4SXxxNmqnvEPjy8fU
         V6job5n7zd0zPAw5OnIrxG3iMZDvA7Zl3QyOl8NmyRg+YN+/v2oEddPX0xW+5NDdNXxH
         l9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804573; x=1721409373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQdLiGWmsHk+StvFm4Bmikh4b/IlgqNFJrtjTUzaBFU=;
        b=Q9gkhgYGNWW4+9PHd9B1qclUTeJg0CKCrApGgSizqr5+2nmtW8SlTXGkeOjxP65+qE
         voAApQm0Z2Q4Ie+BUg+9zbtwLFFWnDh244Jbul5GrNWIRlxxe82BjB6UccOoAsVOTJcK
         JO4GbqJ8y9K4E3ZRIwGdgZ9n5kSO8ZZKJ2G6fbGG4n0hAd+qT+E8PpgrzPSuBMdYQ0Dp
         Tm1f/Wt/WrR8IrpgusZBqHR2lHF7NKxvgq1+ekhVHOX3oCh7KotpU/7KwF2AY4sS7Ly7
         Be2L1rDYIeLzdpcdzZRJqGyrzfUAxiE03uPz7PwtJCi2pOBgp4UDcYxUAIrBkACztwnn
         CJdg==
X-Gm-Message-State: AOJu0YyBBtsxYrGgPCT7D/bb3PyArrpXi8AJ3/gix6B4J4VJsK3Il8vf
	A3h1Ztnsx+fLx29oDbYG6GWLgGkX5QbeI+JAMqoGGg/Wh6CPrTBv1orFncB1Iiw=
X-Google-Smtp-Source: AGHT+IEN9pK3mYfv4RqwnLoH4HrkwIqe/3RTlTTIRSkwfEuMkFUndOCzn52zprYJR/MDAtTFrxlOaw==
X-Received: by 2002:ac2:442e:0:b0:52c:e17c:cd7b with SMTP id 2adb3069b0e04-52eb999c2cfmr8693666e87.22.1720804573154;
        Fri, 12 Jul 2024 10:16:13 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a87208asm360998566b.210.2024.07.12.10.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:13 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 40/49] libmultipath: split off update_multipath_table__()
Date: Fri, 12 Jul 2024 19:14:48 +0200
Message-ID: <20240712171458.77611-41-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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
index 295dac8..731b1bc 100644
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
@@ -506,18 +524,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 	} else if (size != mpp->size)
 		condlog(0, "%s: size changed from %llu to %llu", mpp->alias, size, mpp->size);
 
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

