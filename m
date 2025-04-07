Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6402022ACEE
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 10:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744022055; cv=none; b=OYZmL7a9UGOCsuFn614RC++rD6GWtchjNQo5avcZUtq6PXGJyuXaHTv+yxdHGZGC7sP6u8euuiAoxryI8gxuFfjSOKT0ccDXqrOAU27GkfHHRXnbEMWnqfKk44wFSssxl9CIc7RK3E4Ntl5gj2D1Z/lcySU7Tr0nuxjv9356MlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744022055; c=relaxed/simple;
	bh=jJ8bfPSoeE0Afmz4sruvURiZugEA+UoJZ6+tHuehBvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PKhXvifBFC+q3G10sWlbBKcNPNUYl5+4N94KL3oQt8Ocxkrz4GHkV1mZoyMPu25ps5HFeOWE96dSEppMg7jWfGNHXk53ql44JI7XVcUS6s2934A7MUSIKX+o4GYA7//e3QGjph1nOJJgzFINppBaJTGcUyr+C/Be1/AREbK5gJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Pe/1w6en; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Pe/1w6en"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-399749152b4so2198143f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 07 Apr 2025 03:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744022050; x=1744626850; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eYYhlKUaWYEiqDkMR0HjbqmukgVckRQVx03Ufd/2Sj8=;
        b=Pe/1w6enF6R6VHIRFCSLGNxIV6kUGPQONecrCDtpjISFVwNkAqjaLKhVXbpwvw3PdW
         CGdYIgUCs1p7zDr4gqnG4L8bdtjH7fvbFxSV1BhNxtle6C4f97Um3e52gd/NCOgYI3w/
         VUDHm9ToOgn+l15IF9xLHfz2lPT6CbMAcLxONitpMNnbQERj1275VbBVBSvzfpXa7xT8
         SHs5k0AR0cmvGCKsfGz6y7/d44qdS4dzLXBLAbS48tFGVxcC0IKFCPc1rvDL747KmG+n
         aeEuET44LBcrZbzFEh+pugL+SXCNPSpeVejbuMb5RjnkW2CMVStAnGHMMJmp4T/YBfNs
         RPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744022051; x=1744626851;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eYYhlKUaWYEiqDkMR0HjbqmukgVckRQVx03Ufd/2Sj8=;
        b=ducIS+ygVTrgLHbx34nMNJWmDHnetDlTWYoOuBbkmvwfF9t+zoR7XtP8jEBgnMzqZy
         H4YV/MuaCKlk6n6HAjggqpULkELoIvWw7Z/+cQL9wNtMtSYu5lr6wZ0fqADPC6QfLqxm
         ITQghvVuHtaiCFPGmfBTfxDqCiCwzZT9is/mvKqAMYKITfczkcpouamOcSg2un3/v+Kg
         yfqaVWpYrE1sD2IYEbqsKmK75t1aD2TFfen5Dy70PeMHPZa1ZfX4pjnbCun333v7XuSO
         ipQzrWPYXxnULLKEr0G8MPqqMOaU/rC/zkXjQCF6lMwZtTL1zNalk7IuokVxMFaWphK4
         MEkQ==
X-Gm-Message-State: AOJu0YznPGNzthKtJ71YU/k7mgb+sqojsO5mjnCS+OJjjc1ku1zTMHVs
	/23kcM7H7A8gr7zRVrWm+tVDT2imXr3lDu6Ab0/BDEN8HN6+px7WL5qGkMv2ai8=
X-Gm-Gg: ASbGnctBPgAbKtlfOR0TzC2+1fyrwHQK5TnSTADsdnDrE6HqP1lzE/iHDKtjkVNVUk5
	JDhmtcfiQjmfiJ1MMG/bQxr0j8LUZeqWohIVS0aCK1s6JZBMW33mKUt1X8HoyEgZiMHQCB++z5I
	AjAlyDNIX2n/p9XgeHYWTkrB2B5BZp2tXiSURqS41j9VLWyhj/5zIbibJ+C9e4TEgfxKmolljVc
	OFVn6QTmdm3EgNHKUy/f3LUq1pTU0pgKynkTL9sjHJYs+JaEwGsX28UT71wRYhFW2caSaG2+/ui
	1/6S8ZhSXcEBfYYh8Sgmv59qg28RYDbZWioA/ep7qqTQV5qdLhqkyjlTlZKLwEzxZ+AmD/k+DH3
	22gucyucAOeigYZ5YcliEsAt8f37HldIG
X-Google-Smtp-Source: AGHT+IF7be/VDeiYMKN3I9hhkoJqjKfezp04YvXAEy2vpQ3GyvG/MSBVw8Hh5JYbJoTrhDDxKgnyvg==
X-Received: by 2002:a5d:59a9:0:b0:391:300f:749e with SMTP id ffacd0b85a97d-39cb35b2592mr10671537f8f.11.1744022050359;
        Mon, 07 Apr 2025 03:34:10 -0700 (PDT)
Received: from localhost (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-39c301a79bfsm11948812f8f.36.2025.04.07.03.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 03:34:10 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yoann Congal <yoann.congal@smile.fr>,
	Sofiane HAMAM <sofiane.hamam@smile.fr>,
	Kelefa Sane <kelefa.sane@smile.fr>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libdmmp: update time stamp of man pages
Date: Mon,  7 Apr 2025 12:33:46 +0200
Message-ID: <20250407103346.55121-1-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The man pages should have the same timestamp as the last change
in libdmmp.h, which was 216de53 ("multipath-tools: use common convention
for "header file included" macros") in August 2024.

Together with the previous patch, this should ensure that the man pages
will get the correct time stamp in the future.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libdmmp/docs/man/dmmp_context_free.3             | 2 +-
 libdmmp/docs/man/dmmp_context_log_func_set.3     | 2 +-
 libdmmp/docs/man/dmmp_context_log_priority_get.3 | 2 +-
 libdmmp/docs/man/dmmp_context_log_priority_set.3 | 2 +-
 libdmmp/docs/man/dmmp_context_new.3              | 2 +-
 libdmmp/docs/man/dmmp_context_timeout_get.3      | 2 +-
 libdmmp/docs/man/dmmp_context_timeout_set.3      | 2 +-
 libdmmp/docs/man/dmmp_context_userdata_get.3     | 2 +-
 libdmmp/docs/man/dmmp_context_userdata_set.3     | 2 +-
 libdmmp/docs/man/dmmp_flush_mpath.3              | 2 +-
 libdmmp/docs/man/dmmp_last_error_msg.3           | 2 +-
 libdmmp/docs/man/dmmp_log_priority_str.3         | 2 +-
 libdmmp/docs/man/dmmp_mpath_array_free.3         | 2 +-
 libdmmp/docs/man/dmmp_mpath_array_get.3          | 2 +-
 libdmmp/docs/man/dmmp_mpath_kdev_name_get.3      | 2 +-
 libdmmp/docs/man/dmmp_mpath_name_get.3           | 2 +-
 libdmmp/docs/man/dmmp_mpath_wwid_get.3           | 2 +-
 libdmmp/docs/man/dmmp_path_array_get.3           | 2 +-
 libdmmp/docs/man/dmmp_path_blk_name_get.3        | 2 +-
 libdmmp/docs/man/dmmp_path_group_array_get.3     | 2 +-
 libdmmp/docs/man/dmmp_path_group_id_get.3        | 2 +-
 libdmmp/docs/man/dmmp_path_group_priority_get.3  | 2 +-
 libdmmp/docs/man/dmmp_path_group_selector_get.3  | 2 +-
 libdmmp/docs/man/dmmp_path_group_status_get.3    | 2 +-
 libdmmp/docs/man/dmmp_path_group_status_str.3    | 2 +-
 libdmmp/docs/man/dmmp_path_status_get.3          | 2 +-
 libdmmp/docs/man/dmmp_path_status_str.3          | 2 +-
 libdmmp/docs/man/dmmp_reconfig.3                 | 2 +-
 libdmmp/docs/man/dmmp_strerror.3                 | 2 +-
 29 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/libdmmp/docs/man/dmmp_context_free.3 b/libdmmp/docs/man/dmmp_context_free.3
index 7c109e1..2a9bbb1 100644
--- a/libdmmp/docs/man/dmmp_context_free.3
+++ b/libdmmp/docs/man/dmmp_context_free.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_free" 3 "dmmp_context_free" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_free" 3 "dmmp_context_free" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_free \- Release the memory of struct dmmp_context.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_log_func_set.3 b/libdmmp/docs/man/dmmp_context_log_func_set.3
index be311ec..f593eb5 100644
--- a/libdmmp/docs/man/dmmp_context_log_func_set.3
+++ b/libdmmp/docs/man/dmmp_context_log_func_set.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_log_func_set" 3 "dmmp_context_log_func_set" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_log_func_set \- Set log handler function.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_log_priority_get.3 b/libdmmp/docs/man/dmmp_context_log_priority_get.3
index be38301..6f7c320 100644
--- a/libdmmp/docs/man/dmmp_context_log_priority_get.3
+++ b/libdmmp/docs/man/dmmp_context_log_priority_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_log_priority_get" 3 "dmmp_context_log_priority_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_log_priority_get \- Get log priority.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_log_priority_set.3 b/libdmmp/docs/man/dmmp_context_log_priority_set.3
index 79e4d2e..c1ff371 100644
--- a/libdmmp/docs/man/dmmp_context_log_priority_set.3
+++ b/libdmmp/docs/man/dmmp_context_log_priority_set.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_log_priority_set" 3 "dmmp_context_log_priority_set" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_log_priority_set \- Set log priority.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_new.3 b/libdmmp/docs/man/dmmp_context_new.3
index 12505f9..487ccde 100644
--- a/libdmmp/docs/man/dmmp_context_new.3
+++ b/libdmmp/docs/man/dmmp_context_new.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_new" 3 "dmmp_context_new" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_new" 3 "dmmp_context_new" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_new \- Create struct dmmp_context.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_timeout_get.3 b/libdmmp/docs/man/dmmp_context_timeout_get.3
index 2ed825d..b738fb9 100644
--- a/libdmmp/docs/man/dmmp_context_timeout_get.3
+++ b/libdmmp/docs/man/dmmp_context_timeout_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_timeout_get" 3 "dmmp_context_timeout_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_timeout_get \- Get IPC timeout.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_timeout_set.3 b/libdmmp/docs/man/dmmp_context_timeout_set.3
index 16bc9d9..af84be9 100644
--- a/libdmmp/docs/man/dmmp_context_timeout_set.3
+++ b/libdmmp/docs/man/dmmp_context_timeout_set.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_timeout_set" 3 "dmmp_context_timeout_set" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_timeout_set \- Set IPC timeout.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_userdata_get.3 b/libdmmp/docs/man/dmmp_context_userdata_get.3
index eff446c..23e1da4 100644
--- a/libdmmp/docs/man/dmmp_context_userdata_get.3
+++ b/libdmmp/docs/man/dmmp_context_userdata_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_userdata_get" 3 "dmmp_context_userdata_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_userdata_get \- Get user data pointer.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_context_userdata_set.3 b/libdmmp/docs/man/dmmp_context_userdata_set.3
index d7be869..8a4a765 100644
--- a/libdmmp/docs/man/dmmp_context_userdata_set.3
+++ b/libdmmp/docs/man/dmmp_context_userdata_set.3
@@ -1,4 +1,4 @@
-.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_context_userdata_set" 3 "dmmp_context_userdata_set" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_context_userdata_set \- Set user data pointer.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_flush_mpath.3 b/libdmmp/docs/man/dmmp_flush_mpath.3
index 359607e..e5690ed 100644
--- a/libdmmp/docs/man/dmmp_flush_mpath.3
+++ b/libdmmp/docs/man/dmmp_flush_mpath.3
@@ -1,4 +1,4 @@
-.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_flush_mpath" 3 "dmmp_flush_mpath" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_flush_mpath \- Flush specified multipath device map if unused.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_last_error_msg.3 b/libdmmp/docs/man/dmmp_last_error_msg.3
index 378c55a..548e1a7 100644
--- a/libdmmp/docs/man/dmmp_last_error_msg.3
+++ b/libdmmp/docs/man/dmmp_last_error_msg.3
@@ -1,4 +1,4 @@
-.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_last_error_msg" 3 "dmmp_last_error_msg" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_last_error_msg \- Retrieves the last error message.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_log_priority_str.3 b/libdmmp/docs/man/dmmp_log_priority_str.3
index b276160..cf31556 100644
--- a/libdmmp/docs/man/dmmp_log_priority_str.3
+++ b/libdmmp/docs/man/dmmp_log_priority_str.3
@@ -1,4 +1,4 @@
-.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_log_priority_str" 3 "dmmp_log_priority_str" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_log_priority_str \- Convert log priority to string.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_array_free.3 b/libdmmp/docs/man/dmmp_mpath_array_free.3
index 0514a66..8d2090e 100644
--- a/libdmmp/docs/man/dmmp_mpath_array_free.3
+++ b/libdmmp/docs/man/dmmp_mpath_array_free.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_array_free" 3 "dmmp_mpath_array_free" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_array_free \- Free 'struct dmmp_mpath' pointer array.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_array_get.3 b/libdmmp/docs/man/dmmp_mpath_array_get.3
index 8b0e5b5..4191571 100644
--- a/libdmmp/docs/man/dmmp_mpath_array_get.3
+++ b/libdmmp/docs/man/dmmp_mpath_array_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_array_get" 3 "dmmp_mpath_array_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_array_get \- Query all existing multipath devices.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3 b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
index ddead55..261bea6 100644
--- a/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
+++ b/libdmmp/docs/man/dmmp_mpath_kdev_name_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_kdev_name_get" 3 "dmmp_mpath_kdev_name_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_kdev_name_get \- Retrieve kernel DEVNAME of certain mpath.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_name_get.3 b/libdmmp/docs/man/dmmp_mpath_name_get.3
index 2b0027e..894d318 100644
--- a/libdmmp/docs/man/dmmp_mpath_name_get.3
+++ b/libdmmp/docs/man/dmmp_mpath_name_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_name_get" 3 "dmmp_mpath_name_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_name_get \- Retrieve name(alias) of certain mpath.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_mpath_wwid_get.3 b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
index b8e9e7d..e6afcb1 100644
--- a/libdmmp/docs/man/dmmp_mpath_wwid_get.3
+++ b/libdmmp/docs/man/dmmp_mpath_wwid_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_mpath_wwid_get" 3 "dmmp_mpath_wwid_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_mpath_wwid_get \- Retrieve WWID of certain mpath.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_array_get.3 b/libdmmp/docs/man/dmmp_path_array_get.3
index 21f486b..de29c9d 100644
--- a/libdmmp/docs/man/dmmp_path_array_get.3
+++ b/libdmmp/docs/man/dmmp_path_array_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_array_get" 3 "dmmp_path_array_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_array_get \- Retrieve path pointer array.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_blk_name_get.3 b/libdmmp/docs/man/dmmp_path_blk_name_get.3
index 5938f0e..167e81c 100644
--- a/libdmmp/docs/man/dmmp_path_blk_name_get.3
+++ b/libdmmp/docs/man/dmmp_path_blk_name_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_blk_name_get" 3 "dmmp_path_blk_name_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_blk_name_get \- Retrieve block name.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_array_get.3 b/libdmmp/docs/man/dmmp_path_group_array_get.3
index ca3187c..b9b663f 100644
--- a/libdmmp/docs/man/dmmp_path_group_array_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_array_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_array_get" 3 "dmmp_path_group_array_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_array_get \- Retrieve path groups pointer array.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_id_get.3 b/libdmmp/docs/man/dmmp_path_group_id_get.3
index a84f31f..67ba5c0 100644
--- a/libdmmp/docs/man/dmmp_path_group_id_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_id_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_id_get" 3 "dmmp_path_group_id_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_id_get \- Retrieve path group ID.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_priority_get.3 b/libdmmp/docs/man/dmmp_path_group_priority_get.3
index 1cda8af..09cbea9 100644
--- a/libdmmp/docs/man/dmmp_path_group_priority_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_priority_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_priority_get" 3 "dmmp_path_group_priority_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_priority_get \- Retrieve path group priority.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_selector_get.3 b/libdmmp/docs/man/dmmp_path_group_selector_get.3
index f55477b..dc73fa8 100644
--- a/libdmmp/docs/man/dmmp_path_group_selector_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_selector_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_selector_get" 3 "dmmp_path_group_selector_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_selector_get \- Retrieve path group selector.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_status_get.3 b/libdmmp/docs/man/dmmp_path_group_status_get.3
index 53e68b8..a7662b6 100644
--- a/libdmmp/docs/man/dmmp_path_group_status_get.3
+++ b/libdmmp/docs/man/dmmp_path_group_status_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_status_get" 3 "dmmp_path_group_status_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_status_get \- Retrieve path group status.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_group_status_str.3 b/libdmmp/docs/man/dmmp_path_group_status_str.3
index 98f877a..160c8a7 100644
--- a/libdmmp/docs/man/dmmp_path_group_status_str.3
+++ b/libdmmp/docs/man/dmmp_path_group_status_str.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_group_status_str" 3 "dmmp_path_group_status_str" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_group_status_str \- Convert path group status to string.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_status_get.3 b/libdmmp/docs/man/dmmp_path_status_get.3
index baa4437..92e6433 100644
--- a/libdmmp/docs/man/dmmp_path_status_get.3
+++ b/libdmmp/docs/man/dmmp_path_status_get.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_status_get" 3 "dmmp_path_status_get" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_status_get \- Retrieve the path status.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_path_status_str.3 b/libdmmp/docs/man/dmmp_path_status_str.3
index 425e472..456cf24 100644
--- a/libdmmp/docs/man/dmmp_path_status_str.3
+++ b/libdmmp/docs/man/dmmp_path_status_str.3
@@ -1,4 +1,4 @@
-.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_path_status_str" 3 "dmmp_path_status_str" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_path_status_str \- Convert path status to string.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_reconfig.3 b/libdmmp/docs/man/dmmp_reconfig.3
index 36bd504..413a3e6 100644
--- a/libdmmp/docs/man/dmmp_reconfig.3
+++ b/libdmmp/docs/man/dmmp_reconfig.3
@@ -1,4 +1,4 @@
-.TH "dmmp_reconfig" 3 "dmmp_reconfig" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_reconfig" 3 "dmmp_reconfig" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_reconfig \- Instruct multipathd daemon to do reconfiguration.
 .SH SYNOPSIS
diff --git a/libdmmp/docs/man/dmmp_strerror.3 b/libdmmp/docs/man/dmmp_strerror.3
index 3acd9c9..202941c 100644
--- a/libdmmp/docs/man/dmmp_strerror.3
+++ b/libdmmp/docs/man/dmmp_strerror.3
@@ -1,4 +1,4 @@
-.TH "dmmp_strerror" 3 "dmmp_strerror" "March 2018" "Device Mapper Multipath API - libdmmp Manual" 
+.TH "dmmp_strerror" 3 "dmmp_strerror" "August 2024" "Device Mapper Multipath API - libdmmp Manual" 
 .SH NAME
 dmmp_strerror \- Convert error code to string.
 .SH SYNOPSIS
-- 
2.49.0

