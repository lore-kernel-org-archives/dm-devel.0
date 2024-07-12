Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE861DFE1
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804549; cv=none; b=NjHb7lhYw389uJqUIV109UHFE66XlFhX8odAmn5l716hcSbimIEX04NFO0HXZBMjNyihJwDuz4ix+BiRNOuy+NkQKHBwZMk62WdpeZJRm8TK0R4r0Y4HuIB+AQoSJTGMHa3LusXuPWFF6aflFcHdPJWPOzRrJcn3KYmWfk+f1Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804549; c=relaxed/simple;
	bh=ttassK2Ik6roh/vZD4oEg0h2kSKboyhvr0hmX5lygjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcQUgGSe2qj1rc9NkAImjAehtTIqgRzsMEBhnVKv0IgOghjx6rAviiZ1Hi2J3A1QpSqtOMyav7D/2ed9ufMOM52PcwEOZeh9FRMPBRz0sgNUrmG+FNPUbqln9gcIYNOo8XgBOQ7dhDGP9LEN2i6x+DtHjEvF2QFDgNiqfzPxTcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RqgirPye; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RqgirPye"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52e97e5a84bso3267006e87.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804546; x=1721409346; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4MXeOB02twXZFP13SYTKhlUqfQR1lX7YEE2GnAaoof0=;
        b=RqgirPyejGQt/e7K9wEEhag+DVainegRYBA0QVz5KOqhBEKALbTreHt6Vfo5QuWYbw
         PIm+G8mykkrlezQquHeRt2TVue4JGSwHqh0fs9UQSxVqY56XVU7rNzaKHGIe8VZi/rhm
         NEbOiVW9dp+kNYLEHcrwhvKaGpOq0G80RinLJ74/XrhQPxijhCMgQTMpCYi5pdeKpFY0
         ha3XMv3g1kwttVXOkJV7IDXbI0Qg6gafqmhcXGnZZMdcJ4B/1V8fZSkw8yrQX3Utbyv5
         ptThRU1RzRg2wbnuo0CmNh16RVMvTzFOsKE4oTxNWBDymKksZ4jg/Dv0aIi1te7ayKq0
         EUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804546; x=1721409346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MXeOB02twXZFP13SYTKhlUqfQR1lX7YEE2GnAaoof0=;
        b=tsKkLB2PhSPNFmoQ1nzmGuddZWTeynyvr5eGHyV6vYDNdj64YRYuDyJqjSjN9WpsI/
         /GsQwlGXAqMIamSX1nP1+0awhoylgbQVPOnpyqOU/Po6LsfZFU+i0/xG25I60QqIfijf
         7TK3UfPM6PWNSuFaXJnfe3ysEYTK3hbXby/WqJJt037Z5H085k6uz2QP6ZMXE0rTc8LP
         1qI5idYsaW+7WtmHthmEez2hlxAe5lnZAgZPsJYu4DDXytXdYJZH1sT3ECt/utbg9ZNa
         QDZloBGIGIyjA4NAhwmJ+tVd2TsUQXVBqJPtaowvLVDHkNByXR3cy5yRwENbkTtbV2he
         blxw==
X-Gm-Message-State: AOJu0YxMwWtzydyroMJFOMgPtLBKWpx1Zf4HUbVbfteipo1rXeraewvA
	c2Sg4dzjWFzkZnnBUAom2OE+HAtYjDFE+ugoCFsa3SwelP6vcit7szCHb2cS1ks=
X-Google-Smtp-Source: AGHT+IHDJTbqdnuLM+4lAKFmBpawkWqPn0uz46Xol6dfOy5TwuzQbwoxSlEztN37KbROjlStm5VG6Q==
X-Received: by 2002:a05:6512:1247:b0:52e:716a:1898 with SMTP id 2adb3069b0e04-52eb99d5ff5mr10616130e87.58.1720804545406;
        Fri, 12 Jul 2024 10:15:45 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6dc520sm362473366b.51.2024.07.12.10.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:45 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 15/49] libmultipath: add cleanup helpers for struct multipath
Date: Fri, 12 Jul 2024 19:14:23 +0200
Message-ID: <20240712171458.77611-16-mwilck@suse.com>
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

Export cleanup_multipath_and_paths(), which will be used by multipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version |  1 +
 libmultipath/structs.c            | 12 ++++++++++++
 libmultipath/structs.h            |  2 ++
 3 files changed, 15 insertions(+)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index eb51174..f58cb1d 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -66,6 +66,7 @@ global:
 	check_foreign;
 	cleanup_bindings;
 	cleanup_lock;
+	cleanup_multipath_and_paths;
 	coalesce_paths;
 	count_active_paths;
 	delete_all_foreign;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index be3125e..1583e00 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -329,6 +329,18 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 	free(mpp);
 }
 
+void cleanup_multipath(struct multipath **pmpp)
+{
+	if (*pmpp)
+		free_multipath(*pmpp, KEEP_PATHS);
+}
+
+void cleanup_multipath_and_paths(struct multipath **pmpp)
+{
+	if (*pmpp)
+		free_multipath(*pmpp, FREE_PATHS);
+}
+
 void
 drop_multipath (vector mpvec, char * wwid, enum free_path_mode free_paths)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index dbaf4d4..3b91e39 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -544,6 +544,8 @@ void free_pathvec (vector vec, enum free_path_mode free_paths);
 void free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths);
 void free_pgvec (vector pgvec, enum free_path_mode free_paths);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
+void cleanup_multipath(struct multipath **pmpp);
+void cleanup_multipath_and_paths(struct multipath **pmpp);
 void free_multipath_attributes (struct multipath *);
 void drop_multipath (vector mpvec, char * wwid, enum free_path_mode free_paths);
 void free_multipathvec (vector mpvec, enum free_path_mode free_paths);
-- 
2.45.2

