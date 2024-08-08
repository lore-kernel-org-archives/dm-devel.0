Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAE1190063
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130823; cv=none; b=H5FbtiS5ywWbtzJff8UEIedU6bWyL0GY68TT1WoKheuuRDqRfM/D9/8q6C+I1XX9AHJifJAlPRSVe6kFmEFi964WDKmdpPldnMvmv0ZTQMD0Eba2sKgF3TaAoQe65Y86tzfMamUcj6QTArkOHJO4quCOnhWV1nlrNaMtmaeDSF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130823; c=relaxed/simple;
	bh=fXTIyXhsS6z6yT0MRAp5NN/+iSCq2WjnB+u6qhpcoog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSwBI0VuNqRMJlGMbqt3xT+ZpjfIbHmQ+E3MGMuLnTse+X3p0UbogrJ9vb4YtZsyfDEndxJ7ySxoMpCPY4PUDS5l1MdlnN3AgcrU+eTTsxPrAWBcxvk5TaqyXEYFtO3T2MfiaxOwqWLTtyF+hoy5F9Tstfqo8ulV8iXXy+OjVIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O7uhhQyh; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O7uhhQyh"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a6135eso1652061a12.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130820; x=1723735620; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pyjbdEnUBdpI5/ZGj494ZmZAu7mldzv4y5T1N8U8l4E=;
        b=O7uhhQyhHPMupbEh0OEywMsqQ2Y03syBEiItXhdbPFSf3++Om70w66WEFSlAq0+BRK
         eBCueLDp4XUVpqQuZhOnWUCQcFoqnZUToGlJW4aj86TxZlrpLztRTXKq+uxDQMSKFNDB
         +oH5SIXujJWQa8WBfboG8gUXlF4cV2V37P2hrwfzBdNtY8jGm+LIMMEmDASEgTmAoB4u
         EgSDdMspgA/9ah5vucOfKEcssehzUgJ2Sa0AbU9MDSHRPfLjhGBTFBSxeNPG5JqiTwlB
         wazVaSe2mWEOUYvSfCbmKVL+aipf+QbbhwWZ1xRn2HXuusnAJtJBwVDFyGmGBVR0+8X/
         EeCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130820; x=1723735620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pyjbdEnUBdpI5/ZGj494ZmZAu7mldzv4y5T1N8U8l4E=;
        b=CCVSvPSYtpyN+Fa5vNXObKn1MrMWeh8pD3O0jPQBLoX/NmFT+iJ6gLnxMDkWvYChBA
         jFVFr9L+AoxKwisZE0cQKzdI6TuB+Bdxh2Jkv4keiFAbeHX3Sai2762Sc7g54Y8GDyvp
         FUCPHzBy5gGXZnrSSWxBiAPxCZ6Z8t3e/N70lj07AhDHWze3EBvAtzW7PiEZJ+Qm6270
         pJ2X5F4hmbDg0+mkVyzAcluAJH1mu8bawF0blCATvBIPhmGHWrmh/g51wYqORXS0fdb2
         VCfp8v6XlOz54yub7QxShE6QitNAzKhcxWqsUg+qUE6gVuExeWYO0oK5idHZbF3NvfEH
         4+mQ==
X-Gm-Message-State: AOJu0YwJxkCCyP7xFaLjFWIvVM0wca6lnsLIS5MpYUgBJ8/VZdj4pZ9X
	wsYSdVj7MoKST+I9zHzy5RqFrNzCckekyullqv9EmgDN4U+cQ4xnWeL2WIRf4c2qgp5Kw4LQBxE
	T2WI=
X-Google-Smtp-Source: AGHT+IH0mC2Z04ZjFxobbY+9LQJvAZIFNsPiw+bAmwcVMbhJLMCGoiAosxirxOTZu4TqC4SMGLCxnA==
X-Received: by 2002:a05:6402:3547:b0:582:7394:a83d with SMTP id 4fb4d7f45d1cf-5bbb3d0bb2bmr1900448a12.12.1723130819767;
        Thu, 08 Aug 2024 08:26:59 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2d3518dsm767942a12.78.2024.08.08.08.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 26/41] libmultipath: rename _dm_flush_map() to dm_flush_map__()
Date: Thu,  8 Aug 2024 17:26:05 +0200
Message-ID: <20240808152620.93965-27-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c          | 4 ++--
 libmultipath/devmapper.h          | 8 ++++----
 libmultipath/libmultipath.version | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0a4b586..c497c22 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -965,7 +965,7 @@ int mpath_in_use(const char *name)
 	return 0;
 }
 
-int _dm_flush_map (const char *mapname, int flags, int retries)
+int dm_flush_map__ (const char *mapname, int flags, int retries)
 {
 	int r;
 	int queue_if_no_path = 0;
@@ -1050,7 +1050,7 @@ dm_flush_map_nopaths(const char *mapname, int deferred_remove DR_UNUSED__)
 		   deferred_remove == DEFERRED_REMOVE_IN_PROGRESS) ?
 		  DMFL_DEFERRED : 0);
 #endif
-	return _dm_flush_map(mapname, flags, 0);
+	return dm_flush_map__(mapname, flags, 0);
 }
 
 int dm_flush_maps(int retries)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index d9c08fd..ba05e0a 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -161,11 +161,11 @@ enum {
 	DMFL_NO_FLUSH  = 1 << 3,
 };
 
-int _dm_flush_map (const char *mapname, int flags, int retries);
-#define dm_flush_map(mapname) _dm_flush_map(mapname, DMFL_NEED_SYNC, 0)
-#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, DMFL_NONE, 0)
+int dm_flush_map__ (const char *mapname, int flags, int retries);
+#define dm_flush_map(mapname) dm_flush_map__(mapname, DMFL_NEED_SYNC, 0)
+#define dm_flush_map_nosync(mapname) dm_flush_map__(mapname, DMFL_NONE, 0)
 #define dm_suspend_and_flush_map(mapname, retries) \
-	_dm_flush_map(mapname, DMFL_NEED_SYNC|DMFL_SUSPEND, retries)
+	dm_flush_map__(mapname, DMFL_NEED_SYNC|DMFL_SUSPEND, retries)
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 int dm_cancel_deferred_remove(struct multipath *mpp);
 int dm_flush_maps (int retries);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index e6c6daf..f92f759 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -75,7 +75,7 @@ global:
 	dm_enablegroup;
 	dm_fail_path;
 	dm_find_map_by_wwid;
-	_dm_flush_map;
+	dm_flush_map__;
 	dm_flush_map_nopaths;
 	dm_flush_maps;
 	dm_geteventnr;
-- 
2.46.0

