Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574591;
	b=yxSZP7tle+yN4jnERz8dKKasBAQRj/vDRLSr6JFBhvs8IoibrhIcwBt6oKBt6BRRpq/u
	 JHmd7DK1iz50ScG2Z3iuE3RBgnBZN2qN7RP8Pkdhn4TLqCOM9Lwmq4RsqXsCKpQDmzD7f
	 BfNA5Ie/xW/j7sJb50glGZOqPAT5M1++0LnSuAEN3siledWE8XPM90idZvyf3fKkfRXLh
	 EvUaoqqalrAM59EIsSmbtCZgcyBEtWJFLSaepCM21Ea6HEjfsqt5gBr/V5i/r/5FbEljW
	 e+2m+6s8DyTbuChI9RKU7rWZuxvys5brdCBXdyJe4MxLqFboy15f3oFnHRGlb41rPxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=2YAIW+94v1CeaJAD+I2+zO/RasBOMQhf8oxD2d4cZrY=;
	b=vI7k1u2utWGwaiNGtbLHwUYbtmIYd7rvPpNiFe+R3faPyToPS9HrGjyirYgXBbCQehCj
	 F+YFOabU4bDZcM3qd6a77233EDsp7mt/HNEAWHk5x8MyH/jw5GZJIv4z7Td4Yp6jGi96y
	 6GV73OZn+OPNYiTDn9QH6H88rWW6MHWRoD+n32wsfuF71cJXmpsrx9ZBFnaZsBT9rTjdr
	 mdnavHsF4tMHi1Ziu8WfMSs0jeakn9aIN+mc7qPlk++3OUU8mi9gCaAzTD3EtTqCdjdN6
	 n4xoyp3WiTsU1Kf+9Cc8jUDt1qtbafPNGTxPDeSULlLvW7eWxFONLh4XCeO1R5GMGSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=crYsDKma;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E70606A327
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7E70606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=crYsDKma
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a56e05568aso2973975e9.1
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574589; x=1795179389; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2YAIW+94v1CeaJAD+I2+zO/RasBOMQhf8oxD2d4cZrY=;
        b=crYsDKmary5C//QB5WCMpMd0bYkiNUc0UW0tBRWmeu5lcSGPqoDg0qZxWMlRNDzA5Z
         Wfy4F8qZP1w8XD/HVNJx9ahGEfn8oKhSPwdfTZa48GZkbew1SEowjMYVIZ449gaZel3q
         saMnckM67HH/LjP9yhn9SLgbIxRQPBkTnM8Gr8JsFPTqu/EEjmM9YkIFLIBORo7U1ZB/
         0BxQx37pUA5CVKdhjmr0w+Z94t9uZeHWJCwJkNcXqxjVqBGlci7Cv4lN9D+FB3b34pEz
         69SDfuZCRVjFeOl55l5TRwgOfI3lWxYRbSCjHkyeBKOIWHz2XDJDaliWRUzNIl7LBf6U
         pSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574589; x=1795179389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2YAIW+94v1CeaJAD+I2+zO/RasBOMQhf8oxD2d4cZrY=;
        b=RCYIEvX/PRqaa3sKCEQETlf4XRieZ6GV//SHw/oscCxb5XA7zgsT4e+pegWT0SKDwW
         gEJ2uwzVyt+2qSIBtdU4kO9FzuNB7wCOtoS0jvoO1duk6016eaTZUQbmSlbqcIJOTWix
         hPwYnRiDcwGc1kZK0ztNvqB+xuQ/dH58pFOPvo1MDsefAHCGYl6rUkVqSJrtELHbKZWp
         9q+i2Vf4KiOPLOwUi1Fa73aII7NthmOt1IpWM9c1b4uXmUFKwvyUxr1TuQiYogBq3rN7
         lxPWPxF8L4UpYHvA1gt/9Dpba/1ofiwlE3siHTjES1mnb4lS/qKEDekehRDRH+KHJsOO
         tXtA==
X-Forwarded-Encrypted: i=1; AL+hErGKaNm3XYvRgDLqy2sIom4p8t7iVHe2RTJLTJUNm2NetGxQcQL6CqyWy31A8sIPsQjpV0JDQXZUbg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/X1+OLLqJA/iUzQLfJg+s2XHclGe2YsW54UZsKLskiziACKQIG
	egX/cQyAww+I0o4Z1psFODvcM37w2YiEX6W2e8gmeawK6SzKjQyIFtc=
X-Gm-Gg: AYBFou2bg90Z+MGVOmkQodCzqtO1Yn+T1TxTCRTt2K1BeGuxKAp0zVDbDk1bhW3Oigw
	MnHI1MkQKY4Ri+VM+X/RpX/0Iw/SO28fb6wVrjt8YE0eO15cvQ/iqAF+XzynFfUQe2AZ6zY3U5R
	7cL/UfyDPwToGx2/XqDVk8WIc4HL+GcU1CMsy1Tk4+P15n3c24nk2QxiDxxWKAz58e0piWbgtlN
	tqAkyFcb6KpmnyNIzZSyclggK5tocnVfSpDHC4LY8RNUlJowSafLAMnKyF6pkduJl8F7LnDICA/
	8TQuleMqvbzqOs2SXnoU/OijPdJjxlFwI7fd3iNqxZT1XY0BrpEF93mv4kmKz1kzrtd6ePW/elC
	W+5FyARHZ5hy1BdVLDAMs6vzmuURDe4gE5Yy73HWso9AnYT61/wcKUzRfJCV8FacawPO+sCtOLj
	/+xPxCRoIFkeOuAwyqBHEU2SEsDJ6fcWtc9M6Ih6gdCM08qXHFPJHLDfRLbwawiqa6IUE6vWQZ1
	/TlN02YD2t6dg/8SIifLWCMzUZH/P37TBXJ15oXnPlL2Ip1fESJ1jVidlB+OIZSw4M2kJTFaiN3
	uhM8K5Jds27jtYgfUlWodCPuZBC8h8kBQIJKclah67gmgF5tCC/HV5LIz4QHhs/EHQ==
X-Received: by 2002:a05:600d:8642:10b0:4a1:715d:1913 with SMTP id 5b1f17b1804b1-4bb55a4b85cmr40468975e9.1.1794574589310;
        Fri, 13 Nov 2026 04:56:29 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5b4a3fcdsm24574235e9.0.2026.11.13.04.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:28 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 10/13] multipath-tools: hwtable: add Dell PowerFlex NVMe (formerly iScaleIO/VxFlex OS)
Date: Fri, 13 Nov 2026 13:55:42 +0100
Message-ID: <20261113125549.504780-11-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

NVMe/TCP is supported since 4.0

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 89ff8a9d..ea21bc44 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -419,6 +419,12 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
 	},
+	{
+		// PowerFlex NVMe
+		.vendor        = "NVME",
+		.product       = "powerflex",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	/*
 	 * Fujitsu
 	 */
-- 
2.56.1

