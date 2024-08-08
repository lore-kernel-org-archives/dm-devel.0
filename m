Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2396818FDB4
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130810; cv=none; b=pyKDcTQZ1LFLXGcNEjrEnRgHTR9H/TqcRAX4cYgQhF/KYm5P8teNsR2eoMCz8RAqHlI7HRmQERMn+CkQQ29wKUW8gB/a9izU6J9/37gzojk1PHJ5L28E+S8NKBAXW/vObzeOQ77Okpwd15dtYls83x71zjQvHOMxlDxFI62SXAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130810; c=relaxed/simple;
	bh=SzngsXWTmHhqfRFfJojGpKimSb0ISsm0uhZnp2uu558=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTXWWZWXWjOdRzct/SEubDLXu9kawBZYmhz79LYbSWLtNJqPCrX09jIDv08sJvoHAMZ5N2onQzed7KsO3KJ3P1tT5eaU0pGmYrGrdicAtZB9WJPMdJG52W8x/heKkKJ0qIiWdrZxEaKTZ4TZRTH7YQOEdwSucjeGadjzTZJLZys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z6O2czYx; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z6O2czYx"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5b9d48d1456so1759234a12.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130806; x=1723735606; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUdAiEP++X+MqJhCvUrNj8MBB4UYPLrwY5dzAMf4WZE=;
        b=Z6O2czYxxydRec2rhlX6sl0fGbKfQpNIIy9xp1cFzCxQ56ZAVDgRmRN0FeSCvx5HZJ
         Sx0fyu/J1EIhsRhVnNzR8y/La1Q2bAQrt/UkDBMnUrRH4ME6CefJbkFAq/XOesdhZ4mj
         iyfZ0qQZ1nm1gG07BEdZ+NGgEU4cdL5hZjTgk8A2gAt6A424uz7RUN3gA9HvGAqqTUZX
         ni+u8u5SFVzw0TwAAfFC0FNtytfuGKxIrxpUfuufBna2eUtw+0zkwGBETO3cxPDwFhl4
         fJidNhJ5xhNyvDi2EeH/1fqfl193mBMs7JgjmAz4P6G9JVK5bUyfxubvnbuab3v8c61Y
         7jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130806; x=1723735606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUdAiEP++X+MqJhCvUrNj8MBB4UYPLrwY5dzAMf4WZE=;
        b=n2jdB06aILMw7o5mU/7f8Vk13jTZr+1QOhAjSmKOq3ySYYR/XKh2g5hRgx6ELN6vhm
         2BzlZjmj96ri9pbHvJ4CD+89dyNgEdolj1yhNw+apprMCwT2u8EJl110G4YB98d7D57b
         pIuhJZI56/MgcOKmEiDCrnReFgfSul89f9RauzqdUx4FfrlU3U1HI+eLAw9620dWtF1a
         wkh0UbsRvgc9EViH3jcen6lNrQU3Tiup0xMc3ohCUshiDEVC3XbMgGzJN7ReVfMNc/YG
         dQaOVAniijiHfsthCrDGFnFuRT0+dqYw/khUkFJ0w1zJDA4XGBYeLVIGJZKMRj3L9bFg
         UiaA==
X-Gm-Message-State: AOJu0YzDPts2TiC3bjnv5fX7KZR6R7AqW5LFwCbFtsMy+1DML2OPYtLf
	97R0dlQKvORKrBqFsJUZ558bYJevP8VpqlqoMnvOAZCX6fQDAYnPuRnCqBpCMNqYYxDp3cgDw+3
	GM/0=
X-Google-Smtp-Source: AGHT+IHEfaGcMPM8K76do0akTpwzlC8K03UXYboM1Y9OzE6stzxaqXoCfjpBavEO9T7VLCQs6+z4KQ==
X-Received: by 2002:a05:6402:2809:b0:5bb:8fc3:eb7d with SMTP id 4fb4d7f45d1cf-5bbb3d3ef3emr2015454a12.16.1723130806177;
        Thu, 08 Aug 2024 08:26:46 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2bf90c5sm733109a12.2.2024.08.08.08.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:45 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 12/41] libmpathutil: rename _log_bitfield_overflow()
Date: Thu,  8 Aug 2024 17:25:51 +0200
Message-ID: <20240808152620.93965-13-mwilck@suse.com>
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
 libmpathutil/libmpathutil.version | 2 +-
 libmpathutil/util.c               | 2 +-
 libmpathutil/util.h               | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 270dcd8..2dcaa35 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -81,7 +81,7 @@ global:
 	install_sublevel_end;
 	is_quote;
 	keyword_alloc;
-	_log_bitfield_overflow;
+	log_bitfield_overflow__;
 	libmp_basename;
 	libmp_strlcat;
 	libmp_strlcpy;
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 136aa59..1255974 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -354,7 +354,7 @@ struct bitfield *alloc_bitfield(unsigned int maxbit)
 	return bf;
 }
 
-void _log_bitfield_overflow(const char *f, unsigned int bit, unsigned int len)
+void log_bitfield_overflow__(const char *f, unsigned int bit, unsigned int len)
 {
 	condlog(0, "%s: bitfield overflow: %u >= %u", f, bit, len);
 }
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index 110b2f6..b1772e3 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -103,9 +103,9 @@ struct bitfield {
 
 struct bitfield *alloc_bitfield(unsigned int maxbit);
 
-void _log_bitfield_overflow(const char *f, unsigned int bit, unsigned int len);
+void log_bitfield_overflow__(const char *f, unsigned int bit, unsigned int len);
 #define log_bitfield_overflow(bit, len) \
-	_log_bitfield_overflow(__func__, bit, len)
+	log_bitfield_overflow__(__func__, bit, len)
 
 static inline bool is_bit_set_in_bitfield(unsigned int bit,
 				       const struct bitfield *bf)
-- 
2.46.0

