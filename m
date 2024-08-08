Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E15C190671
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130832; cv=none; b=jbvR+i14G3juDGhoL8V4cQGf0vi3wjeZnkudywHvFEjdGCdmN+PIWgV3TD2TUCabM6u9ndm+BPVPySht0zEtyRc/DpH94PchdihiDGEQaa22WPmeH1TelB5/i+0IVyI86GC6nlvVJsAF2wOVIAhF6NxwvN0NMwOk1qLcmnjQ85k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130832; c=relaxed/simple;
	bh=sH/eBvX8xOSfZkjw47il6wDT/Rph4dvJD9W59NUzIgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUh7tOT/BQhthAq1kuXGOY9uF7D8FfzILuO0k/kX5leHht1FONiLT4pwEPV9RNLabn+28sTL0Dnuex8phjBZCpMHpPhsLZ089fm5IUSmrkrRjTVfgD5Hnp7BFV8aKmu5TM4A8wMODv0KKlBAj1usvM/xP+6w4SaCHIXErB5x+EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eEBa3SxR; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eEBa3SxR"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52f00ad303aso1386827e87.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130828; x=1723735628; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/6BD02ZqkXxxYcu6Z7ezi5phgzZ2Stn7B2M5TNlNBw=;
        b=eEBa3SxR8+SohI/1UjQTRHoye3z0YvaTRcXLCxX0IBpmhWX6QKkkqsKgBGWu9zgb5J
         +cS14fXY9AgMGZbmdI7M6hXFJkSzX1uDsocb7V2aACxta6AG5+cXzrZlnwtkQJLfJlte
         ts4gD6RhE2P4oyYJ1NTkHNTEPWeYHiILNC97A/ZNsW3BvNPN6Xb5lU+azfJXV4W6Cpyp
         fHRhcWAKR1tk4H7E6iiN0WRWpCSffIONJ2qTsccuRYiVB/6bg568YZ7jjjEUOoTgKXQa
         Vkd5g4EdEJkqrkjhS0ANO0hCVsD2/j0A56wYlZHmK+tbPhX090yBo3MP1U5LrS1FXNiM
         XOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130828; x=1723735628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/6BD02ZqkXxxYcu6Z7ezi5phgzZ2Stn7B2M5TNlNBw=;
        b=mjcseduMVHD42trN8Z36IyASG9nnzOoAjUdtqPNnHdU/5hEu0N7FPyRfXmh8xs4UOq
         uJypJLGWYohgTvrFFxfynuLCxLrIcIRYyq8dfpOgWW0EI/lyPWudbPdcjgpP26A/ldDS
         nIgCtSqjb0JSvTI/ZvHbJ6NitweRmUOdCnr4Uoddt0BnBvS70kGVbG+VELCkdgKW71LB
         KT5HU7MCy6f4I4Z7I6DMGKbwdPpi+mxexmU2n3cSe2brtLei5j5q89fnn4xh9O4YZLUi
         L3GT0wGOEXhMgwbJRaxZYAzc8XFgLmfo6aAep1ELKcHYgt7ds/XliGIXPerlgCtQj4oU
         b15g==
X-Gm-Message-State: AOJu0Yy563WOqqREHYJP7CaltBmw1kPst+j83TzS810qEMKRgBZAs0pH
	bzHHaT69LZOKtf66fo9x14gPqdCsB7hjvd0ZC0BsAfP7Wpg0S8dyCvza1fGfjjE=
X-Google-Smtp-Source: AGHT+IGy1r1G9vUR4t3HZaNfRtkYMhOm+JAhsWmvc+N8FCcvV+sojBL77+ERo1xyv2Yg22fofxPOAQ==
X-Received: by 2002:a05:6512:3a84:b0:52e:9694:3f98 with SMTP id 2adb3069b0e04-530e5844a89mr1501925e87.27.1723130828126;
        Thu, 08 Aug 2024 08:27:08 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9d4e371sm753619966b.109.2024.08.08.08.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:07 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 33/41] libmpathpersist: rename functions with double leading underscore
Date: Thu,  8 Aug 2024 17:26:12 +0200
Message-ID: <20240808152620.93965-34-mwilck@suse.com>
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

Also remove some superfluous "extern" qualifiers in mpath_persist.h.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/libmpathpersist.version |  6 ++--
 libmpathpersist/mpath_persist.c         | 22 +++++++-------
 libmpathpersist/mpath_persist.h         | 39 ++++++++++++-------------
 mpathpersist/main.c                     |  6 ++--
 4 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index a8c6aae..f467d99 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -10,7 +10,7 @@
  *
  * See libmultipath.version for general policy about version numbers.
  */
-LIBMPATHPERSIST_2.1.0 {
+LIBMPATHPERSIST_3.0.0 {
 global:
 	/* public API as defined in mpath_persist.h */
 	libmpathpersist_exit;
@@ -19,10 +19,10 @@ global:
 	mpath_lib_init;
 	mpath_mx_alloc_len;
 	mpath_persistent_reserve_free_vecs;
-	__mpath_persistent_reserve_in;
+	mpath_persistent_reserve_in__;
 	mpath_persistent_reserve_in;
 	mpath_persistent_reserve_init_vecs;
-	__mpath_persistent_reserve_out;
+	mpath_persistent_reserve_out__;
 	mpath_persistent_reserve_out;
 local: *;
 };
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 6cfcdde..ace91d7 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -74,7 +74,7 @@ int libmpathpersist_exit(void)
 static vector curmp;
 static vector pathvec;
 
-static void __mpath_persistent_reserve_free_vecs(vector curmp, vector pathvec)
+static void mpath_persistent_reserve_free_vecs__(vector curmp, vector pathvec)
 {
 	free_multipathvec(curmp, KEEP_PATHS);
 	free_pathvec(pathvec, FREE_PATHS);
@@ -82,11 +82,11 @@ static void __mpath_persistent_reserve_free_vecs(vector curmp, vector pathvec)
 
 void mpath_persistent_reserve_free_vecs(void)
 {
-	__mpath_persistent_reserve_free_vecs(curmp, pathvec);
+	mpath_persistent_reserve_free_vecs__(curmp, pathvec);
 	curmp = pathvec = NULL;
 }
 
-static int __mpath_persistent_reserve_init_vecs(vector *curmp_p,
+static int mpath_persistent_reserve_init_vecs__(vector *curmp_p,
 						vector *pathvec_p, int verbose)
 {
 	libmp_verbosity = verbose;
@@ -110,17 +110,17 @@ static int __mpath_persistent_reserve_init_vecs(vector *curmp_p,
 	return MPATH_PR_SUCCESS;
 
 err:
-	__mpath_persistent_reserve_free_vecs(*curmp_p, *pathvec_p);
+	mpath_persistent_reserve_free_vecs__(*curmp_p, *pathvec_p);
 	*curmp_p = *pathvec_p = NULL;
 	return MPATH_PR_DMMP_ERROR;
 }
 
 int mpath_persistent_reserve_init_vecs(int verbose)
 {
-	return __mpath_persistent_reserve_init_vecs(&curmp, &pathvec, verbose);
+	return mpath_persistent_reserve_init_vecs__(&curmp, &pathvec, verbose);
 }
 
-int __mpath_persistent_reserve_in (int fd, int rq_servact,
+int mpath_persistent_reserve_in__(int fd, int rq_servact,
 	struct prin_resp *resp, int noisy)
 {
 	return do_mpath_persistent_reserve_in(curmp, pathvec, fd, rq_servact,
@@ -128,7 +128,7 @@ int __mpath_persistent_reserve_in (int fd, int rq_servact,
 }
 
 
-int __mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
+int mpath_persistent_reserve_out__( int fd, int rq_servact, int rq_scope,
 	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
 {
 	return do_mpath_persistent_reserve_out(curmp, pathvec, fd, rq_servact,
@@ -140,14 +140,14 @@ int mpath_persistent_reserve_in (int fd, int rq_servact,
 	struct prin_resp *resp, int noisy, int verbose)
 {
 	vector curmp = NULL, pathvec;
-	int ret = __mpath_persistent_reserve_init_vecs(&curmp, &pathvec,
+	int ret = mpath_persistent_reserve_init_vecs__(&curmp, &pathvec,
 						       verbose);
 
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 	ret = do_mpath_persistent_reserve_in(curmp, pathvec, fd, rq_servact,
 					     resp, noisy);
-	__mpath_persistent_reserve_free_vecs(curmp, pathvec);
+	mpath_persistent_reserve_free_vecs__(curmp, pathvec);
 	return ret;
 }
 
@@ -155,13 +155,13 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)
 {
 	vector curmp = NULL, pathvec;
-	int ret = __mpath_persistent_reserve_init_vecs(&curmp, &pathvec,
+	int ret = mpath_persistent_reserve_init_vecs__(&curmp, &pathvec,
 						       verbose);
 
 	if (ret != MPATH_PR_SUCCESS)
 		return ret;
 	ret = do_mpath_persistent_reserve_out(curmp, pathvec, fd, rq_servact,
 					      rq_scope, rq_type, paramp, noisy);
-	__mpath_persistent_reserve_free_vecs(curmp, pathvec);
+	mpath_persistent_reserve_free_vecs__(curmp, pathvec);
 	return ret;
 }
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 9c88e15..d94205f 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -3,7 +3,6 @@
 #ifndef MPATH_PERSIST_H_INCLUDED
 #define MPATH_PERSIST_H_INCLUDED
 
-
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -81,12 +80,8 @@ extern "C" {
 #define MPATH_WWUI_DEVICE_NAME		0x00	/* World wide unique initiator device name */
 #define MPATH_WWUI_PORT_IDENTIFIER	0x40	/* World wide unique initiator port identifier	*/
 
-
-
 extern unsigned int mpath_mx_alloc_len;
 
-
-
 struct prin_readdescr
 {
 	uint32_t prgeneration;
@@ -183,7 +178,7 @@ struct prout_param_descriptor {		/* PROUT parameter descriptor */
  *
  * RETURNS: 0->Success, 1->Failed.
  */
-extern int libmpathpersist_init (void);
+int libmpathpersist_init(void);
 
 /*
  * DESCRIPTION :
@@ -197,7 +192,7 @@ extern int libmpathpersist_init (void);
  *
  * RETURNS: struct config ->Success, NULL->Failed.
  */
-extern struct config * mpath_lib_init (void);
+struct config *mpath_lib_init(void);
 
 
 /*
@@ -209,7 +204,7 @@ extern struct config * mpath_lib_init (void);
  *
  * RETURNS: 0->Success, 1->Failed.
  */
-extern int mpath_lib_exit (struct config *conf);
+int mpath_lib_exit(struct config *conf);
 
 /*
  * DESCRIPTION :
@@ -221,7 +216,7 @@ extern int mpath_lib_exit (struct config *conf);
  *
  * RETURNS: 0->Success, 1->Failed.
  */
-extern int libmpathpersist_exit (void);
+int libmpathpersist_exit(void);
 
 
 /*
@@ -241,8 +236,8 @@ extern int libmpathpersist_exit (void);
  *       above in RETURN_STATUS.
  *
  */
-extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp,
-		int noisy, int verbose);
+int mpath_persistent_reserve_in(int fd, int rq_servact, struct prin_resp *resp,
+				int noisy, int verbose);
 
 /*
  * DESCRIPTION :
@@ -254,8 +249,8 @@ extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp
  * RESTRICTIONS:
  * This function uses static internal variables, and is not thread-safe.
  */
-extern int __mpath_persistent_reserve_in(int fd, int rq_servact,
-		struct prin_resp *resp, int noisy);
+int mpath_persistent_reserve_in__(int fd, int rq_servact,
+				  struct prin_resp *resp, int noisy);
 
 /*
  * DESCRIPTION :
@@ -279,9 +274,10 @@ extern int __mpath_persistent_reserve_in(int fd, int rq_servact,
  * RETURNS: MPATH_PR_SUCCESS if PR command successful else returns any of the status specified
  *       above in RETURN_STATUS.
  */
-extern int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
-		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy,
-		int verbose);
+int mpath_persistent_reserve_out(int fd, int rq_servact, int rq_scope,
+				 unsigned int rq_type,
+				 struct prout_param_descriptor *paramp,
+				 int noisy, int verbose);
 /*
  * DESCRIPTION :
  * This function is like mpath_persistent_reserve_out(), except that it
@@ -292,15 +288,16 @@ extern int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
  * RESTRICTIONS:
  * This function uses static internal variables, and is not thread-safe.
  */
-extern int __mpath_persistent_reserve_out( int fd, int rq_servact, int rq_scope,
-		unsigned int rq_type, struct prout_param_descriptor *paramp,
-		int noisy);
+int mpath_persistent_reserve_out__(int fd, int rq_servact, int rq_scope,
+				   unsigned int rq_type,
+				   struct prout_param_descriptor *paramp,
+				   int noisy);
 
 /*
  * DESCRIPTION :
  * This function allocates data structures and performs basic initialization and
- * device discovery for later calls of __mpath_persistent_reserve_in() or
- * __mpath_persistent_reserve_out().
+ * device discovery for later calls of mpath_persistent_reserve_in__() or
+ * mpath_persistent_reserve_out__().
  * @verbose: Set verbosity level. Input argument. value:0 to 3. 0->disabled, 3->Max verbose
  *
  * RESTRICTIONS:
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index b661790..efb46b9 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -505,7 +505,7 @@ static int handle_args(int argc, char * argv[], int nline)
 			goto out_fd;
 		}
 
-		ret = __mpath_persistent_reserve_in (fd, prin_sa, resp, noisy);
+		ret = mpath_persistent_reserve_in__(fd, prin_sa, resp, noisy);
 		if (ret != MPATH_PR_SUCCESS )
 		{
 			fprintf (stderr, "Persistent Reserve IN command failed\n");
@@ -575,8 +575,8 @@ static int handle_args(int argc, char * argv[], int nline)
 		}
 
 		/* PROUT commands other than 'register and move' */
-		ret = __mpath_persistent_reserve_out (fd, prout_sa, 0, prout_type,
-				paramp, noisy);
+		ret = mpath_persistent_reserve_out__(fd, prout_sa, 0, prout_type,
+						     paramp, noisy);
 		free_prout_param_descriptor(paramp);
 	}
 
-- 
2.46.0

