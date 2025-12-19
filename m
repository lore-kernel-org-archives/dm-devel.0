Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB13337B8C
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155286; cv=none; b=aAWDsl1+liXvdgmrhSevsHAhWkVVuuR9ORJ8rDg074IEJH8UGFkdAdRfVCVjgLyLxqIb2yjeumo/NwrQucphztH+tCL3XjzHi/UL9by7itFA61Lw+JIbz+gjhfHshhWtwQQnmfzphvr5Sw9Gr92jrZTNBLbgoWUvizjum8vUmV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155286; c=relaxed/simple;
	bh=cK/dsyH4SRhb/SuC10WB+JfsF0DNQLIeouRCOBha5Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUL/xota11nIzE8Y7sX9qMjbwv0a/4JjbLtbdDDgoZ4zN/ulo8uOZTBsQDWLbVYxQb1OXijhr6DtOBh/jrDx+sfymswsAfK9zTZ2VZwwU5AxM4sQfZShIEPj5CipNUrfOpoRqcXC/qw1FBIg5Y6okpaIzYs0m/WZH2c8Dswn3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DHN24Euq; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DHN24Euq"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b73a9592fb8so378061766b.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155282; x=1766760082; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AS1iZqKKl+ME404igVLAE2ld8gi32hSg5HhfHyes6GI=;
        b=DHN24EuqB4hNz9QHysUUXEjjAzOjIeuLYLyxM0HnfDRK6p+UjweudCPlXKXCJAa29+
         VkMiEU8+pMIH2giE9XMsPmEUhS0x2as8vu2vVfStMXnR24Kd1vdzXEmagq11kGbEdJNx
         BaEHP7b/r4QMxgvMPo4/fEl2MhAskFXTqvUh1w7or3yrNjevNIxQRFRYUeazvv47Vqtc
         dbINjvH1+9HDTRXWdoP8PJp7z6PeZERxv1DTDK13EzZeKEpOBMPhKg8/5iY9AV/lMBEs
         KryTKvrgPyZjg7SJj1KH732I9mFkRw6RnzwP9WuYhZMoWyVbnwIayTzrjU0tgYcfz3/p
         t55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155282; x=1766760082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AS1iZqKKl+ME404igVLAE2ld8gi32hSg5HhfHyes6GI=;
        b=NJjoZ+V9JUTbx5cPPhLmFd6XdzZVbFnfqmEpPfTV+zadvrkdQUIsd7KfwEQ9W/7YOk
         aVP/Jw91HMW1BdTjV9i0DPR8nRwTbQ9qyk+rJtxN/2v5klLyJm12uxeHr197ocLAuM5T
         zEtEgvZ3uAIsJfFwIjDkgyCWRjv69q+11s6biuJNui83sAEw8o+qJiWLQEpFype0S8G5
         n8V7EH2MgFYKPifwR3GPiNYHQ2MVH0KeIRV7xzZhj9rataA/EQKAx0M1Lc3LnT0dxV/c
         JXQorcWb61vkZC5eCqXsbvzEyWzGTMA8tubM0dOjfF3yUIqChGNjrGhdgjmis1OcyXJW
         H+jA==
X-Gm-Message-State: AOJu0YxBiRd8AXfOAybKyfJXmkmbbunOSeSoUoowsCK0A1Sn3NSIrdc4
	+w5g77bYbwjWMLx0I14Q+yJTd09v5BegNAMWlY3a6tnX854oJaHiEWdMN/j93RBWBfI=
X-Gm-Gg: AY/fxX7W1i41YS+I/q0hiIWbI9C1Gr8/nHTBhky4541yZ2TrGrbbsg5UTad/CkwDem+
	xc5lyRX5TBupWM6mPkL3uvIf1vx9/id/FNZNe6Ajwzq59oUkINgHYM+yL/5k3dLT0oDWLzlMX2w
	rQk1QRaf/oUtj3IhTkP3oW8vyFwR/PN4svyYInjlXtVXhui3R2e7dxNvLCWjE9Q2HbKWzdehRVH
	AxMcCG+hQx8G1n9Um3ik1U7yiYgz49xpy0PUG0jXzwVnQbrOTaCy5kyZxLZpkEw7xxOKbP5c7L3
	BqOTQmU21d2xUaDDQiINZNL87EHUMqj7tESbskkPCVcbrxUf/oZSWQtEQwoLVy8yUJni4iNUbiQ
	+VyNxW7JNbIpVg1kqr7E6uDoAjayN9n+HSDMNwOMpyly3UTGw5wUSezyYWMHJqiPd2rlQ/YM5x1
	4clu3HHczINoxkT5xn0dOAQmTRp2JZ7f46l0pLB2Ue/S81/wd97Vv899XIJcO0ZKD/UETEKdw1p
	g==
X-Google-Smtp-Source: AGHT+IF3ueIY+ws8sBVSQvgPAn9yNejwZHMdUAayfaBrNGSLpfhTLhHi5ovyJsFp1F/mC5XnFFfD2g==
X-Received: by 2002:a17:907:9449:b0:b07:e258:4629 with SMTP id a640c23a62f3a-b802058eda2mr763916966b.16.1766155282307;
        Fri, 19 Dec 2025 06:41:22 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037f18575sm240731366b.54.2025.12.19.06.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:21 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/26] libmultipath: export orphan_paths()
Date: Fri, 19 Dec 2025 15:40:47 +0100
Message-ID: <20251219144108.237928-6-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function will be called from multipathd in a follow-up patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 1 +
 libmultipath/structs_vec.c        | 2 +-
 libmultipath/structs_vec.h        | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 30b282f..19e4f39 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -145,6 +145,7 @@ global:
 	mpath_in_use;
 	need_io_err_check;
 	orphan_path;
+	orphan_paths;
 	parse_prkey_flags;
 	pathcount;
 	path_discovery;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7bceeb6..0717888 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -377,7 +377,7 @@ void orphan_path(struct path *pp, const char *reason)
 	uninitialize_path(pp);
 }
 
-static void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
+void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 {
 	int i;
 	struct path * pp;
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 1eedfc8..5f8fd63 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -16,6 +16,7 @@ void set_no_path_retry(struct multipath *mpp);
 int adopt_paths (vector pathvec, struct multipath *mpp,
 		 const struct multipath *current_mpp);
 void orphan_path (struct path * pp, const char *reason);
+void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason);
 void set_path_removed(struct path *pp);
 
 int verify_paths(struct multipath *mpp);
-- 
2.52.0

