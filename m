Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0292D3220
	for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 20:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776977111; cv=none; b=BdP44pwK4RgFPywiO14y9yFGkNZq0juLb6g0hAwJmMn3n9mZMPL50ThxVhtcYSUyYcirk1wsY6j3tHLKsApIwUjCepRCttOOPRol93Ewn5IpCXt9GOoPaXMWv2fpVUWAKgdFIxF3xLsTlDkPGhi+bq9q1fMICHJTKTMQr4zuL8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776977111; c=relaxed/simple;
	bh=JyqMXizAB+v/hPjQOQID/SJal9OflrjPeQYaaKB/Fgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiHLzVrY/amqheM8VyUceOde+mpHIT7jdHOMCtOpxi/rP76Xh/0m7j9B2b6+/uAjz93vyj275gUhMJGlf7J1iVDgWF1oaGEvlxuoshqhaeYx2cZ7/loeKFYzRrn2HJ2yUpOeOqWpksuXdP1iO5e8LRyKKkQHZnGOtgNGci6Eo90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MQpF/Vuq; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MQpF/Vuq"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43cfd832155so5200401f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 23 Apr 2026 13:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776977109; x=1777581909; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErBMdNOI5q6pF7H4GnCuS2gHvedIOCLwRuWXzha6c3M=;
        b=MQpF/Vuq0Wjn7OmG1mc4N4N8T6uUaBJtdsJIz/fJEGOZhDG8wSG4HowXqpvuMNxA6G
         taXt7Kk7ezJocr9+SpSB06D8vXIEIW/HYlx2H1tDXQiuRw0Nx55spvFApt2/4bZu1yIF
         xr0Amu7AVv21Io1vieJ5kbiNGu6Ma2asNCFJ2HqLSV9Nfb1WHI1C3jllnl7GFIvJdcp8
         ZipS1/fCfXszBIQolT2/JXcs9j3YdBIB0Rxk9EA+Huf9WPeA1eeBO8jv5PoudycC9QOn
         JJRQwDufr0qY1oV+IA2z7FeegE5PdXjHOGNC2gjlm5/R0aMXLeX5kC6j0AGCHzCcYJ/F
         zJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776977109; x=1777581909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ErBMdNOI5q6pF7H4GnCuS2gHvedIOCLwRuWXzha6c3M=;
        b=HOx+pMvYcNa9YkNSojXn7G5y2z68V/56ay/rO98GYFTNl/BeuyfDCFh1DzwbwYPK4L
         4P+22/OyU3D7D/gRQ+5Rg6ecMHw5+8iamfyKkEdfuhL/qxmjCfvU5f47/6NRExkLuDsv
         0abxc5ugX0ylwsVbZDcA7DHI33k3ZGKCoJyajMneLUpVzN95LCm5oiMmC8ZBgut/8G0C
         NAbbQ6G+tjinCD6mPXaRy4qPBWZ7qCT0JX8gdFkSrVR561dzEbnBlfkKoAfTihn6g/wE
         G6MZGDqWvVYrGxR6N6r7UjXstOQBd+QiKfohDTuHuN2ABMM1CibXdL9BJzvzQ+Y8a4wf
         ofIw==
X-Forwarded-Encrypted: i=1; AFNElJ9skuFDeJkh6f85PwW+3prHDVwC2h7Tr94mNMyAhKIVukXo/8G9m/8gG80lOMhNnjSKS6GaveA7Jw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywx+w5in0wgnL6YAecTq9ODc24uQoNndW5MHdN2NqNSJcrmkEDD
	CePX/RM7vGmeofgCMKlxa/3wJmtrIBwKQ6qNFDxVncFSeZX2zWl9CbhqnM8OV3wx/AQ=
X-Gm-Gg: AeBDievKnh57KYJebcX5RDNDaEbmmLA0zsw3Ek8l2fLj6jQCUofgVbjlfBFEFn5jEom
	zWtI3iX8trRPX5Emq70kbLC6zwuaKenpjauZ9NXDdHvlCqjdKNLNpVJDjHxUaXbftRxd5Re0nyU
	FD3m5uVfxC+H1485EDPfmyLP3QcgTRhYaA0m8eQ1uY55FHg5OSCich4YgYMf7Sc5xjNwx6s6nzO
	D/znyjLyc28f4V+vEM0ex9da4S9zywvyACioRw9OQUxdn2limf4Mbc4GJmxEpvCHyzAZnfyQ9le
	zc+1A5+Xj7AFxBzO93AgXtzr5QDkK0T3G4Q6O873KrX22qrPyjj75AsHIDiw5k0Qe+StI0gqxc6
	duQfsA20rFZJOJJCmhCRODNlWRlwEyKeTYxbDW0v116qzuvUiANL73kvAeTQcXFunmOK6u8kAaB
	CUC3XI1w5jSGJppSC6x0YaYU97lxzpRRMTa9SgGjYVm3s/x93NnrD+kBjYocRC68AeCOqkSJkzo
	rs1THdyfBo7wOL9ERkLSJ9r
X-Received: by 2002:a05:6000:4313:b0:441:3144:efc5 with SMTP id ffacd0b85a97d-4413144f0c0mr2036228f8f.42.1776977108784;
        Thu, 23 Apr 2026 13:45:08 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43fe4e46898sm58851243f8f.27.2026.04.23.13.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 13:45:08 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 5/5] libmultipath: tur checker: improve tur_deep_sleep() test
Date: Thu, 23 Apr 2026 22:44:46 +0200
Message-ID: <20260423204446.472642-6-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423204446.472642-1-mwilck@suse.com>
References: <20260423204446.472642-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tur_deep_sleep() test serves to test the behavior of the tur checker
when checkers time out and cannot be cancelled.

Up to now the checker timed out on every TUR_SLEEP_INTERVALth
invocation. That made it impossible to test the MAX_TIMEOUTS logic, which
requires multiple consecutive timeouts. To fix it, invert the logic, so
that the checker just succeeds on every TUR_SLEEP_INTERVALth call.

Also, decrease loglevel of the messages from tur_deep_sleep().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 0a312c7..6791172 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -214,15 +214,15 @@ static void tur_deep_sleep(const struct tur_data *tdata)
 	int oldstate;
 
 	if (tdata->devt != makedev(TUR_TEST_MAJOR, TUR_TEST_MINOR) ||
-	    ++sleep_cnt % TUR_SLEEP_INTERVAL != 0)
+	    ++sleep_cnt % TUR_SLEEP_INTERVAL == 0)
 		return;
 
-	condlog(1, "tur thread going to sleep for %ld seconds", ts.tv_sec);
+	condlog(3, "tur thread going to sleep for %ld seconds", ts.tv_sec);
 	if (pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate) != 0)
 		condlog(0, "pthread_setcancelstate: %m");
 	if (nanosleep(&ts, NULL) != 0)
 		condlog(0, "nanosleep: %m");
-	condlog(1, "tur zombie thread woke up");
+	condlog(3, "tur zombie thread woke up");
 	if (pthread_setcancelstate(oldstate, NULL) != 0)
 		condlog(0, "pthread_setcancelstate (2): %m");
 	pthread_testcancel();
-- 
2.53.0

