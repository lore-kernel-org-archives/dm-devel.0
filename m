Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA7E189F26
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561220; cv=none; b=qGX/qKB5CFrCsegN6oLz6bpGErmKlbZiaUwRXmht5K8vVQeFuuF7FGVtg36vdc9wBJ+T3uh1uNgmcGqUIOl5FgnpGdk99s0pJxJXBrS/7ERaKmM0IZoTgcPRthFoTOOBoFwMOc2dK5ah9BhGKTljtyBUq9tUNFgXM3tJy2WEflQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561220; c=relaxed/simple;
	bh=nugWuk5VuYepvFKO0zplsauI7TKbAwOjwdQvZvalDBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmpWQO3kCIRSqJUaB7tlAooE4pTC+1t3IE7NZn5wWH99/0j3iFMCE/iyvLGZu26tnHES3MTFwfLmHg/VJoTHmDwvt8OPM60zrBm8pR4PF6gB8ZZ4dOFXrrzPdQGIA/okFhw3IWCKVaFYvwFPNZ1CF/E9GDrFQ6iOHiR/WpL5jRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SfZNUMbi; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SfZNUMbi"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-58b447c5112so6520455a12.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561217; x=1721166017; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpQRE48wwBbkPekHhrqnPawvVWrQMwljIKB3f4zFGVY=;
        b=SfZNUMbit/BCmv7VICrGGtG18NS0rhQ2UDjFQa5UepqVdrmBwVk6YnUzTdONflBWOk
         EVTO0aX7F4WCkhzg2f3FqvPctPdvF62Tf5GIc/1M++lf2HFbUT+RGJMIW1IMG23G6U/t
         DMG1xFdaEmgcY8hnQBl0D1e96vXQOPHyHgVPIVC/V4m9p1VMmSHA0dBE8+Q78m/25/jI
         TMRNPZ18Df2GMTiBol3jMDf20Lt2AhB77x1241JFE1I1yD1dxmH45uHh2MS72RkXcv4A
         4ijrHAPHFkq5iqsWjYV8v/mIkG6wlsYbwwB5NJoVnc20rwvv9GXd4FYCyJnJc6E3CCJf
         OKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561217; x=1721166017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mpQRE48wwBbkPekHhrqnPawvVWrQMwljIKB3f4zFGVY=;
        b=E4qpLK+EN9tcJhjvfBMFN7QAtkv0zy2lPsbqMoybRjJSBXhxTl8or7XNXXXdNuWiVN
         NlLa/sRigIumzSZFVD1JNTMg+cijARIHF1plxUUX0VjCQCStMtXGjmoYYmyMCPjXe+0h
         vfKiiGzrotCnoUDZA5eEU/xOLhkLc3Qrg9nIzBuzNSOL/RVLM2Un2hbU7BhFIksmorAK
         tLDN0H/DvWveDjsdYeXXWqY2xyP+JrqeEzJNckp/BiwqSYCQzFUkWFCSuyy6i1Y3kD40
         HEVHWjBRVv7vnwbpEMA4hzZAXZtplmi8LnNia7Jjm4lkBDIj9lc51FIygukDQoveP9AV
         g7yg==
X-Gm-Message-State: AOJu0Ywzf01YdGsCVRxkJQNMi/pBzatFgh16jpVWRTJacbLPfYCe/nn1
	Lih6GrFj9AoGtKP2HTEIvlb8rAUBqETEKNH9wB55YPzH9hkD7XGsCg09ksAVi4A=
X-Google-Smtp-Source: AGHT+IGYWXvNFP40VLcvd/JNvR1xR416KnYQ99wG4P8CbT6vJ6NsomC0FK73HV9WPGYsjhpq4y8TNQ==
X-Received: by 2002:a05:6402:35cc:b0:57d:788:aaa3 with SMTP id 4fb4d7f45d1cf-594ba98f585mr3001606a12.8.1720561216978;
        Tue, 09 Jul 2024 14:40:16 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594b8d6cdffsm1497547a12.0.2024.07.09.14.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:40:16 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 31/44] libmultipath: add is_mpath_uuid() helper
Date: Tue,  9 Jul 2024 23:39:22 +0200
Message-ID: <20240709213935.177028-32-mwilck@suse.com>
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

Export it, as it will be used by multipathd and libmpathpersist.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c          | 13 +++++++++----
 libmultipath/devmapper.h          |  2 ++
 libmultipath/libmultipath.version |  1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 806ffb8..5f6c0c8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -829,6 +829,11 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 	}
 }
 
+bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
+{
+	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
+}
+
 /**
  * dm_get_wwid(): return WWID for a multipath map
  * @returns:
@@ -845,7 +850,7 @@ int dm_get_wwid(const char *name, char *uuid, int uuid_len)
 	if (rc != DMP_OK)
 		return rc;
 
-	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
+	if (is_mpath_uuid(tmp))
 		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
 	else {
 		uuid[0] = '\0';
@@ -970,7 +975,7 @@ int dm_is_mpath(const char *name)
 			       (mapid_t) { .str = name },
 			       (mapinfo_t) { .uuid = uuid, .tgt_type = TGT_MPATH });
 
-	if (rc != DMP_OK || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+	if (rc != DMP_OK || !is_mpath_uuid(uuid))
 		return DM_IS_MPATH_NO;
 	else
 		return DM_IS_MPATH_YES;
@@ -1065,7 +1070,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 				  .uuid = uuid,
 				  .tgt_type = TGT_MPATH,
 				  .target = &params }) != DMP_OK
-	    || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+	    || !is_mpath_uuid(uuid))
 		return DM_FLUSH_OK; /* nothing to do */
 
 	/* if the device currently has no partitions, do not
@@ -1309,7 +1314,7 @@ struct multipath *dm_get_multipath(const char *name)
 			  }) != DMP_OK)
 		return NULL;
 
-	if (strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+	if (!is_mpath_uuid(uuid))
 		return NULL;
 
 	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index db5c5fd..a2b2837 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -131,6 +131,8 @@ enum {
 	DM_IS_MPATH_YES,
 	DM_IS_MPATH_ERR,
 };
+
+bool is_mpath_uuid(const char uuid[DM_UUID_LEN]);
 int dm_is_mpath(const char *name);
 
 enum {
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 7d3ff63..5b8f9e0 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -127,6 +127,7 @@ global:
 	init_foreign;
 	init_prio;
 	io_err_stat_handle_pathfail;
+	is_mpath_uuid;
 	is_path_valid;
 	libmp_dm_task_create;
 	libmp_get_version;
-- 
2.45.2

