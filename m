Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E7A18563A
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561202; cv=none; b=uSR11WuEwantMj5Lb6pGeNLRAr3cwjv2YzkmJ2XExgnqMIULW6agI+SMkl5Ot1osotRJA7CSqU+VTsOsCTQ/NsE3S3gQKBJU3cOjDZWAMhLNgQ7q/S0rDAoR97zG4901sjfRZtZxXVG5SUpPI5jOdu8bSehFUS466ld7o1T1X30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561202; c=relaxed/simple;
	bh=sQdAw0xxdD/dYSGRmoFAhjuoeDlxRKWsgz86WfbT1jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0VlzmfBqQnzZfZZLDyBPK5DqF5j4xPGdwSUjVoUpXgGiImlBD9wWfk5LZpL+XIwsnXKRv8BaX5K6ah8o/UVl0lY00Eb/TrnArZE7bVgUJF0EdZI60VGf4eVGgmmGeFSG/sDLyt/dIn/0pQti5MXpWpCXIFBmnr+ws+3PgBgXGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZZ78TiSD; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZZ78TiSD"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a77af4cd570so348224066b.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561199; x=1721165999; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDDTtRB9z63U6xarE5NrfqAT5oi/GgcgQVpupJMU9rQ=;
        b=ZZ78TiSD+PlY/oOQzhRanpkLm4j/gSl7HI6kwAnCMNmwtmgLxNbRmZlJ2fDpUg8s0z
         RhpWVyH/pTKFwhRcWBWSoJT3wfthusqjyOwkrk56yQoPBwinREDt3Ino3sP3gL2J4hdB
         KV7BBk/UQcjwwjdpBNN3O9XPfxRBZEJwP2nR2G0Cn/8vhi4n0zvgjCnZe3xRMd+luMhc
         Q08H+dKlhTaBXey0pMC069rmidkYiFROaq2WZE/Gkz0x2S5X1Ox4H0MddOYOQe5km2E5
         gsO95p4Jndt1SX/DbIRcKNI9NCMV5zDj44c3SuH3xwr1nM3v0/tPUUOPnnJLAPZpBkTY
         uFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561199; x=1721165999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDDTtRB9z63U6xarE5NrfqAT5oi/GgcgQVpupJMU9rQ=;
        b=CkdWrgydi46LDq6CrQQ74RLNsTMhpCY5MR52MxnRxYvWjPZ2MPZk+J4Nnl9xVnJSje
         5Elx+txFVHJfMzQZt3DFb2Duqvf4Kd8SdOXbZRpRGfIaQOUI/RZSeXOF4t6WKta5A5XI
         wruxu4cjb3cBu+72VWmrgHYKf4riVVOUYuMDoK2ePxsVLRdJ5vKnpOxG3rjXaYWXZ5dO
         CTqvrN5uYsIIh/kpgCz4j8wok/e2kmmaVXNz3HL7mqx6DAmXWJjpA14HDcrYu0bOlaO6
         XdKqsHll2FOSD+HSjT8UPtRLMjUGEkq1D+4bOUdC1LJQ3HTD7GU4wxFtXEUDnl0Ri0sM
         se7w==
X-Gm-Message-State: AOJu0YzwAjQJpBkz49TDP6o31SP5qc0U7Q3WtIL6cADXyC5kxh+MkP/a
	TOkjiEeZAWd9QADhsNxUfI+hp9fe7h0pvvJWTEtYS95spoGrJhr+2HKEvQ2Utuz8Y681X1a+nhF
	V
X-Google-Smtp-Source: AGHT+IHzP4roL/jzYnOr2/rHAw55rkKZA4G/g7qVq40shUeac+6LfEwb/O8ba87nt6RSdnBg0CUSjg==
X-Received: by 2002:a05:6402:885:b0:58b:f46f:ae45 with SMTP id 4fb4d7f45d1cf-594bb773fb7mr2820728a12.23.1720561199113;
        Tue, 09 Jul 2024 14:39:59 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bd459e08sm1471859a12.69.2024.07.09.14.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 15/44] libmultipath: add cleanup helpers for struct multipath
Date: Tue,  9 Jul 2024 23:39:06 +0200
Message-ID: <20240709213935.177028-16-mwilck@suse.com>
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

Export cleanup_multipath_and_paths(), which will be used by multipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
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

