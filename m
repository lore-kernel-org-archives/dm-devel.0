Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E83171A5
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379625; cv=none; b=XVIkmfq2WSLMPp7ogXlUk+oxEvz+vU9xqPsBNphd3BnNfues2JPjOTqQIeO/ozrmCVNRl6mrt75uM1d6fq122qKuyxqG40IjGphRHpcCgX3kAd2N22FZpWYBCuy8skr6X7X8gcJnpbvJK86hIyHTBVHaTg+PAIomJ3gYA6V3thg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379625; c=relaxed/simple;
	bh=GEVoW9l0QWlS9CJZmo8jucAAKc3FzD0818F6EK1zmv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JL4IrG488eNp73jQQFUkGaJaxCg4kJXDOeYg2SjiBoamN+EbtvjmCxSlz95emA10dRkm3S/jiBpj7FNwPI8P9CwXdrazoMVBHkVU1WxRFsn/E3KehPbcUy1891JA2n5O6AwngmcnxzhQ198NPC/IG5YUWqzznd0ChecDGjW/gUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BBBDYuk3; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BBBDYuk3"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a52223e004dso669207066b.2
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379621; x=1713984421; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6X1ban8PiuleLsxaXXPlo+IWgAWCA3j5fink/sWFBp0=;
        b=BBBDYuk3iqinidaExc/xPEllXsdzCuRpMk994Hin7QINDHAiCyF0X6ujHn6PRFpQOp
         9xHMTN7i9XfUChsjcxVBj9QUZ3yT98JhHbZYoVZV53tp2UjRDCFp0y6emBmF2Ua3Ygmb
         FaUWqrJ7VQdAS6b5QlmyppO+TMdk+o3kWN0Xo5SF/MQGCLjs5OO99qhOTnNyGemS1Tlp
         CetMCgDK3BOXPuRDKxueehStrNAq5b/kTHIJzu+JxSoockpq89gCQ3+Bjnm65SPJB09k
         XlptugpVzqzJw6OAGlumVV97XzS3bi+s7yW2KxvNWOiOroUb2scbN2/yBZ6fNrrgEO/s
         wGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379621; x=1713984421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6X1ban8PiuleLsxaXXPlo+IWgAWCA3j5fink/sWFBp0=;
        b=kPpckB0iy1XgAx9h838Bcfb4wlINwCDddzcpTXYPzcT+CUugKeYlaRcsFGPPgbw6pX
         ucEUZLqUTVVp5UbkgSnEm2wHgRD+OR5pb//61/C1d6py7Tt/i3R5kJy4JSsGQdui+0Ua
         P7UDSkWJ/q8uI6G1ynYgv0jYNxJQ6UpC73Vj2Oj/Zm+W5Nf7OG67xOwqqJRh84204uid
         HJ+WrlsMba3YEk5YXeQvkTAuNLqQi7tXNXGA06hQ8QjvZiYpqBJRLRTN9Z5G/litg3EA
         ekR0WCq40SjE2eW0PgegxF5Bz5d01EWmgWPHXUX9rdwBGTVsEAU5seQt0ewkVbtbM+hL
         38VA==
X-Gm-Message-State: AOJu0YxtCcA7oHhasc8vmIvRNTFdVKCS0Z5LboWRUKEU6UiUSizurAC0
	N9NqWpiAyk+mKBlOd0NEFNrdb4rjirhmk5DKzqsFCe4evZIQigIWDr0JVSyHjww=
X-Google-Smtp-Source: AGHT+IHBHVm5IRSD8ytHxNIYgn+rxz6t4sx2bPLbIIx7y06OqjwI6/JFLg/3cee+9OhU/u0LtW0x2A==
X-Received: by 2002:a17:906:b094:b0:a52:6eb7:7654 with SMTP id x20-20020a170906b09400b00a526eb77654mr234371ejy.46.1713379621748;
        Wed, 17 Apr 2024 11:47:01 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id x13-20020a170906b08d00b00a51d073da7esm8369083ejy.82.2024.04.17.11.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:47:01 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 7/8] libmultipath: add wildcard %k for printing max_sectors_kb
Date: Wed, 17 Apr 2024 20:46:43 +0200
Message-ID: <20240417184644.6193-8-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 360308d..efd5a16 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -32,6 +32,7 @@
 #include "util.h"
 #include "foreign.h"
 #include "strbuf.h"
+#include "sysfs.h"
 
 #define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
 #define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
@@ -431,6 +432,27 @@ snprint_multipath_vpd_data(struct strbuf *buff,
 	return append_strbuf_str(buff, "[undef]");
 }
 
+static void cleanup_udev_device(struct udev_device **udd)
+{
+	if (*udd)
+		udev_device_unref(*udd);
+}
+
+static int
+snprint_multipath_max_sectors_kb(struct strbuf *buff, const struct multipath *mpp)
+{
+	char buf[11];
+	int max_sectors_kb;
+	struct udev_device *udd __attribute__((cleanup(cleanup_udev_device)))
+		= get_udev_for_mpp(mpp);
+
+	if (!udd ||
+	    sysfs_attr_get_value(udd, "queue/max_sectors_kb", buf, sizeof(buf)) <= 0 ||
+	    sscanf(buf, "%d\n", &max_sectors_kb) != 1)
+		return print_strbuf(buff, "n/a");
+	return print_strbuf(buff, "%d", max_sectors_kb);
+}
+
 /*
  * path info printing functions
  */
@@ -790,6 +812,20 @@ snprint_alua_tpg(struct strbuf *buff, const struct path * pp)
 	return print_strbuf(buff, "0x%04x", pp->tpg_id);
 }
 
+static int
+snprint_path_max_sectors_kb(struct strbuf *buff, const struct path *pp)
+{
+	char buf[11];
+	int max_sectors_kb;
+
+	if (!pp->udev ||
+	    sysfs_attr_get_value(pp->udev, "queue/max_sectors_kb", 
+				 buf, sizeof(buf)) <= 0 ||
+	    sscanf(buf, "%d\n", &max_sectors_kb) != 1)
+		return print_strbuf(buff, "n/a");
+	return print_strbuf(buff, "%d", max_sectors_kb);
+}
+
 static const struct multipath_data mpd[] = {
 	{'n', "name",          snprint_name},
 	{'w', "uuid",          snprint_multipath_uuid},
@@ -815,6 +851,7 @@ static const struct multipath_data mpd[] = {
 	{'e', "rev",           snprint_multipath_rev},
 	{'G', "foreign",       snprint_multipath_foreign},
 	{'g', "vpd page data", snprint_multipath_vpd_data},
+	{'k', "max_sectors_kb",snprint_multipath_max_sectors_kb},
 };
 
 static const struct path_data pd[] = {
@@ -845,6 +882,7 @@ static const struct path_data pd[] = {
 	{'I', "init_st",       snprint_initialized},
 	{'L', "LUN hex",       snprint_path_lunhex},
 	{'A', "TPG",           snprint_alua_tpg},
+	{'k', "max_sectors_kb",snprint_path_max_sectors_kb},
 };
 
 static const struct pathgroup_data pgd[] = {
-- 
2.44.0

