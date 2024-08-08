Received: from mail-lf1-f67.google.com (mail-lf1-f67.google.com [209.85.167.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE0318FDA7
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130807; cv=none; b=fK3Xtj2gH1BIB48tQjla3ofm+gai3+wgcfxtjA7vk+/Y4EAJDc+oWWvjCVGWYazUegs3bAgjV9ZfcxkNZj6NHScluqlPMPa3fLkyfBhqqYlJcCHjrYB4rYjoFr9gPW08i4s/BxO94jk9SU1spseUZnPEFokturq98n/z8quAdDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130807; c=relaxed/simple;
	bh=yM2+5wR+3WVLxjnw7clxkHPOHar/4GrQi6Do75u6M5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cU1FwJIo8nmM7s9ThMuhLg4/2UWX3A23GQa72TcOappL8qB6B1N27RP4z5aqVV7IsDCogWNSr8/fnp1ssbEEVGKctqK++1Z3dRE5BlxLZzpKoO1LTsL+jZ2axLPkAbXPO7zbH1e+7JD9vhLwvENH0oXnJ4iwRg3xcHUa3avwwxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cs3FNqvi; arc=none smtp.client-ip=209.85.167.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cs3FNqvi"
Received: by mail-lf1-f67.google.com with SMTP id 2adb3069b0e04-530ae4ef29dso1894998e87.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130803; x=1723735603; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HQx1WRB9i3UBAol/93utIq2Iv/NseeH17cmgl+HyAM=;
        b=Cs3FNqviWH9LqTnr9CgCsMGw6qJ/0VM49yNrKEyp/aXFBIH9nXQlWiKgDcxAA33VOD
         fwywLM8JX4dSTKRZ6ImMLBRA5SQs5cAYAEeK/m876b9P+WiPsRJkDAOQ1H9sg4D9AxV0
         MR4lZ4Uq9xWKXh2XSwK/lsPeidyfelGOjlVtUurZXvwxdbcFuWiaxdhO5SksmqUvExTB
         yAPBD9aYsAxa9rugiDORFaw1GA6hYdAJTbcHDJQGJPFFmM7EYfwgeGk31qs0LRJ7Pprz
         GEUIIPLklCWpX+9/S2ZFE/N8VrnPh8uR1gH6UFj6KdgZ5yTkd3qKDmsGvPISsZcQrMkR
         bh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130803; x=1723735603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/HQx1WRB9i3UBAol/93utIq2Iv/NseeH17cmgl+HyAM=;
        b=ZiWO1BqHpRlz3cZDylLGRQSnnPd6k1/oY8HOd3f+vQsT/1yHmKczTcr1p/JHPiSiig
         vDyc5n00YAGAFjJrlxU0zONO9ae8wCV+9JlbGJ+/NUGRC0K1OMVLtPgOB9STeUKK1SOI
         6SnPb0+gSmMeb9H2yheH1dGYT32jis484oMLiUyLbSq3KVbeNrM/53Z7i+qEKJZZ6cA0
         tRomKdnsp34TdJWLh0D7ECUrFBTxKnruMxCwbI5cJHVQSoX5xuK247TnVSIhBRVvSW/v
         X3qwAWeJ93VHoA2JC61DOXOG4B5k/o1FYQfa9kzaiIkuCLgn7xEXLS67q/CGxrfJVhpn
         uxZg==
X-Gm-Message-State: AOJu0YwJ4egd8x2YF/Id3th4PuSNt1dCU5815yq3MqUzUrICrN+gLXIZ
	RWZRxDS0uAMbacftVjYuyD2SdoYuJCzmzQRPRQMj5pf4KdkVL7bKyGYKNTydyxI=
X-Google-Smtp-Source: AGHT+IHhoFeEYCiLnMq0fbuwyV13P9Dg6AJt8xKyCxtjCnZl4+wY1FBAeUcAoUogeU4WrKqNN6usrQ==
X-Received: by 2002:a05:6512:3e1d:b0:52c:deb9:904b with SMTP id 2adb3069b0e04-530e58769c5mr2320756e87.38.1723130802930;
        Thu, 08 Aug 2024 08:26:42 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9ecad25sm755491966b.221.2024.08.08.08.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:42 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 09/41] libmpathcmd: rename __mpath_connect() to mpath_connect__()
Date: Thu,  8 Aug 2024 17:25:48 +0200
Message-ID: <20240808152620.93965-10-mwilck@suse.com>
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

Identifiers starting with double underscore are forbidden, see
https://www.gnu.org/software/libc/manual/html_node/Reserved-Names.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/libmpathcmd.version |  4 ++--
 libmpathcmd/mpath_cmd.c         |  4 ++--
 libmpathcmd/mpath_cmd.h         |  2 +-
 libmultipath/valid.c            |  2 +-
 tests/valid.c                   | 12 ++++++------
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/libmpathcmd/libmpathcmd.version b/libmpathcmd/libmpathcmd.version
index f100628..a786c25 100644
--- a/libmpathcmd/libmpathcmd.version
+++ b/libmpathcmd/libmpathcmd.version
@@ -10,10 +10,10 @@
  *
  * See libmultipath.version for general policy about version numbers.
  */
-LIBMPATHCMD_1.0.0 {
+LIBMPATHCMD_2.0.0 {
 global:
-	__mpath_connect;
 	mpath_connect;
+	mpath_connect__;
 	mpath_disconnect;
 	mpath_process_cmd;
 	mpath_recv_reply;
diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index d7c3371..1fa036c 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -94,7 +94,7 @@ static size_t write_all(int fd, const void *buf, size_t len)
 /*
  * connect to a unix domain socket
  */
-int __mpath_connect(int nonblocking)
+int mpath_connect__(int nonblocking)
 {
 	int fd;
 	size_t len;
@@ -138,7 +138,7 @@ int __mpath_connect(int nonblocking)
  */
 int mpath_connect(void)
 {
-	return __mpath_connect(0);
+	return mpath_connect__(0);
 }
 
 int mpath_disconnect(int fd)
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index b58aaac..bf30c1e 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -47,7 +47,7 @@ extern "C" {
  * RETURNS:
  *	A file descriptor on success. -1 on failure (with errno set).
  */
-int __mpath_connect(int nonblocking);
+int mpath_connect__(int nonblocking);
 
 /*
  * DESCRIPTION:
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index b7e0cc9..d751780 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -315,7 +315,7 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
 	}
 
 	if (check_multipathd) {
-		fd = __mpath_connect(1);
+		fd = mpath_connect__(1);
 		if (fd < 0) {
 			if (errno != EAGAIN) {
 				condlog(3, "multipathd not running");
diff --git a/tests/valid.c b/tests/valid.c
index ecaeb46..cb56734 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -52,7 +52,7 @@ bool __wrap_sysfs_is_multipathed(struct path *pp, bool set_wwid)
 	return is_multipathed;
 }
 
-int __wrap___mpath_connect(int nonblocking)
+int __wrap_mpath_connect__(int nonblocking)
 {
 	bool connected = mock_type(bool);
 	assert_int_equal(nonblocking, 1);
@@ -223,10 +223,10 @@ static void setup_passing(char *name, char *wwid, unsigned int check_multipathd,
 	if (stage == STAGE_IS_MULTIPATHED)
 		return;
 	if (check_multipathd == CHECK_MPATHD_RUNNING)
-		will_return(__wrap___mpath_connect, true);
+		will_return(__wrap_mpath_connect__, true);
 	else if (check_multipathd == CHECK_MPATHD_EAGAIN) {
-		will_return(__wrap___mpath_connect, false);
-		will_return(__wrap___mpath_connect, EAGAIN);
+		will_return(__wrap_mpath_connect__, false);
+		will_return(__wrap_mpath_connect__, EAGAIN);
 	}
 
 	/* nothing for CHECK_MPATHD_SKIP */
@@ -332,8 +332,8 @@ static void test_check_multipathd(void **state)
 	conf.find_multipaths = FIND_MULTIPATHS_STRICT;
 	/* test failed check to see if multipathd is active */
 	will_return(__wrap_sysfs_is_multipathed, false);
-	will_return(__wrap___mpath_connect, false);
-	will_return(__wrap___mpath_connect, ECONNREFUSED);
+	will_return(__wrap_mpath_connect__, false);
+	will_return(__wrap_mpath_connect__, ECONNREFUSED);
 
 	assert_int_equal(is_path_valid(name, &conf, &pp, true),
 			 PATH_IS_NOT_VALID);
-- 
2.46.0

