Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BD3432BE4
	for <dm-devel@lists.linux.dev>; Fri,  4 Sep 2026 11:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788520651; cv=none; b=FQ0KEnWbdLFPypuE1AvFQUGue9KAQyMHpvq3jKj6osqV0Yhampp7Lj46oxmv4HMsKTKd7veSNCDGJ4N9P9PFHSXeQksDVT+QKAmZrsjfJxALt5tyKCHBNZ3zdiuz8rvVAjEpfVSCb299eA143Q58WIAkFGnl1rQGXjRM2djeqgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788520651; c=relaxed/simple;
	bh=wJcQXhX2p7ArrlqvtSK6wNpa5H9F05dc8xrHIKvtv2U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ST2cQfTQYyLHuKFhB/zuKtZHDrjAXDhDAcokzB71x/Buq5GylCwHZjkIp6DYqH/p7FvM27iOzqZgHxV05MzDuScFXPu2yoUyXdMap7Wv/O3adNa7NPrKdXV4xtabnpbZAW9cylrj0Yw5dOyxH7Fpu/68b7TIJlN1sPbQs2mo9K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BkQoGmLj; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BkQoGmLj"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6b7b4b08d78so255930eaf.0
        for <dm-devel@lists.linux.dev>; Fri, 04 Sep 2026 04:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788520649; x=1789125449; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t/aNANTfjkHFW3Qz0CZuwn+uWl1/BO2PZTx/B0W7ELs=;
        b=BkQoGmLjSjooQ81ziqUYZzCMDadgYKqQOXcn9zVcb8ENY/Op2VRhlPm8kgYIc0Cl3n
         tPHP9fBUw5bBs3TzNSrd3L6JSumDJCfESq/XkvU7nsqLHV4Jx/kEI3IUyYhSnds0pf2L
         /94RdnpgaV9StaKtYRhc6tuHUBpsw4dzOaOaUOEZo5bmmfkWZ3WpKUvxw+kytjHdu5vN
         /TlxvOhIBdjFGBGvA5j8CC2gAzutAzs96GXkO8gunhh42P2aWPqabi2cWiAWm3HcvNR/
         lLYHSHkYWfWQUeZyKvSbNqypK3mHEbkN3vVOHD+25ZZPFvHPqDusnPZGk16NyzBoJRIp
         eELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788520649; x=1789125449;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t/aNANTfjkHFW3Qz0CZuwn+uWl1/BO2PZTx/B0W7ELs=;
        b=WrpIUfzTBUswvJqdCbNuZBANy+vkXFn+ZkgbdrjMsNzZ7BnJFJU90Z/lkld9v70e6m
         148s/JUXOZpadDzkf6nHILQ7xUrE+cEoTvI11AF+PDW3fdFo04TF7ZuFCagz6ciiryUi
         aCaHixVOeYtyEastQ4RszMlW6+V8btshqXBqnHIomAltIss/9deRFfv28ogvzwHFrcWh
         yJd1N/hGBKZbPeJC+LwCY23G/TZq96mq4brN5CLtbEiiTO5jFz26UTSXe2BHGs8FwT0L
         2wctL1YOeU+Z0c+UU2zczB3iCdVuz4rzZeBm/WPWDqQRkgGyvNPAOEylGtl/gjnjK2e2
         1Pbg==
X-Forwarded-Encrypted: i=1; AKwUvBwHn7O2k9qoz86DIGNc1cTk+USHRXl8qoL2vcKp3GaBYRPiD8sF97exOX+lNZLu1Ord1xuH22gh4Q==@lists.linux.dev
X-Gm-Message-State: AFuF++n2ghP0OITa+6G96PKZmp5iwq034Af/4Z/FI2p9FsH9MQ7//2Lj
	ZqaOUedmTdsiHexurkOyoGH1Agqne1KEPxEse22j1J2woDEfxDnpjGHu
X-Gm-Gg: AYBFou0NfefZjDZZlXEZ750ohWqib+CrpiLIOXGVhMx0mTayjXDvrYiAN+NMK3KL6pm
	icwh86vD48umV8Pf0KAPbZx4Z7X+S7AiE4EXsjTT1tUPNYG7Lt7HlKXp41kdGL9dxxpsWyRSxbR
	J/N1VeIqZfSfQk4Jgtptnvn6ocoSdSuANPWTYEKUa1+arzcIN2Ous9Pi2O4ydYpwM8z7ChLswPc
	iqqwosh7paSuCl8R7zPhohjTt5LIaARGVaZhNlxfhFbCtwwU6gIJQHbktDXxOoyd8HcfqJm712Y
	mVAvP+QWa3TBFqHwr77phrDCwYOHPZDKmiQMuaeAdfSemESEye9KiFLhoAYlX4Y8uXZ2XkomR41
	ynRj75nKtWQxJ/Vjtlu25VBcUzf47ZuNIu0bymXofxCCiB7o/dVBI01JvwS7LUeVbrbwULaAoKC
	4rJvYB9ZKXeHknG86tkWLKlM5+mcyUSAPxmNVELmi006dRLlsYhgVsgYSiyal4ZVyRdQR0bxvLV
	V44JDnYa+U1jAM=
X-Received: by 2002:a4a:e84a:0:b0:6b7:83c5:fdf7 with SMTP id 006d021491bc7-6b783c60350mr1319391eaf.56.1788520648768;
        Fri, 04 Sep 2026 04:17:28 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa33e96sm6297642eec.12.2026.09.04.04.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:17:28 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Matthew Sakai <msakai@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH] md: fix typos in comments
Date: Fri,  4 Sep 2026 16:47:22 +0530
Message-ID: <20260904111723.30326-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/md/dm-pcache/backing_dev.c | 2 +-
 drivers/md/dm-vdo/block-map.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-pcache/backing_dev.c
index 7165fc0364bb..23002beb192a 100644
--- a/drivers/md/dm-pcache/backing_dev.c
+++ b/drivers/md/dm-pcache/backing_dev.c
@@ -68,7 +68,7 @@ void backing_dev_stop(struct dm_pcache *pcache)
 	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
 
 	/*
-	 * There should not be any new request comming, just wait
+	 * There should not be any new request coming, just wait
 	 * inflight requests done.
 	 */
 	wait_event(backing_dev->inflight_wq,
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 5ffc360540ed..258ad5521f51 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -240,7 +240,7 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
  * assert_on_cache_thread() - Assert that a function has been called on the VDO page cache's
  *                            thread.
  * @cache: The page cache.
- * @function_name: The funtion name to report if the assertion fails.
+ * @function_name: The function name to report if the assertion fails.
  */
 static inline void assert_on_cache_thread(struct vdo_page_cache *cache,
 					  const char *function_name)
-- 
2.48.1

