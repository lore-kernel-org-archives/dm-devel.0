Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B0522E
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 07:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720595192; cv=none; b=cTO0cC5iVDnYwvisMn0E96H3Iul9ryChDCT8ADhcddM2+OY1/86IONraLGeMHp1576K1NdxXARJ00h9cA1x1RGpk/gw9jSyO6WC2R8AMbDeoLeje1cX0mquH6WRo87O2pe5YOgC3CrfB6n9lde/XhV3JzUBcQcpoRPH1XdUJaas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720595192; c=relaxed/simple;
	bh=pN+7OlJjPd4p09/6OD3Hh3yAJu3JSZuXs3pzhS2ZhWQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N7W5xG0I7swBuk7a1valJJCosZ9nlH75/bMXZvaB7Mro9L65320lOL3szEMClWN9UCFsPHYF7h5A5KOxZovzj/VdB+iNxGJJS7wBpO4NscLP0/ywfCNZYW/11kPDWSorktxsI4ewWxPTzUoDiuFDGKmYwdatQvHmCskRIQTjK4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CTVw6/kB; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CTVw6/kB"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-426717a2d12so2669815e9.0
        for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 00:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720595188; x=1721199988; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pN+7OlJjPd4p09/6OD3Hh3yAJu3JSZuXs3pzhS2ZhWQ=;
        b=CTVw6/kBk+vsr9bFX6dA6biJyQsv8ZLCFQh/PYmbKoP1aSDvZtF2ml8pp662ehJUv5
         T0OpspweGbHR/DD3Q8wng1yGzN/ZGI0WAGIAEXI6/i7pJCniWeIkot8kvWERfRbNH5KK
         fFdJ/gLT4SRI5kJFPcsv78SN++wmGJ3VueX7qtNWouMiTxzllQXEFb+Zcs/rhK+qHth/
         MJ9D/io5/d9QldxCcblLQz/uF1eOA0Q48QeZg6rJFmaW48X5ZT1Z/+YVd6hucpbozLgg
         PiNbhFYuM/kbnb6WaIcKwIvxK4d22XFTg9NqDRydQu76U83cli3NaswlVx5QRI106V8w
         7d1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720595188; x=1721199988;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pN+7OlJjPd4p09/6OD3Hh3yAJu3JSZuXs3pzhS2ZhWQ=;
        b=D9rU1BwCFCpLy4AyZjActRmyiu9opvm4mL+WIKZrABzllvxtcm3gtoZtC0SAiLNtVt
         2bBsMfuFHdW5HgSN8eujFzlhtNb9DEpFzby41KnJCNXlJp8+wV2Z3Bq6/bQHJKBLLgZT
         UbMpP3TbBFxzmNQ9gbubi2nbC01a9qxvBEc9qUED0M86AREqW9jKxO2tDEwHkRhJjzRR
         YJOuLA3MtVlOxyBJdknLqaJsj1agpBt9eMNA0RUYM8dYrrUHq3UHSyaQZ6tn7nKl2q/u
         9ufRTOx8GvVZJoImNNX75A/Y6kokeCzeSXCWuxPbnXtRy5Ud0cCtRLD1/VQ2mKEhUFz9
         FDrA==
X-Gm-Message-State: AOJu0YwuR1DZYvMwA3+gHAGUnlphPIxg1GxfQbSsMnR9csJp3C9Mhtc4
	Np990zp5EHLuX6PL0L9u4VC1BS5Ki8YhDO3PQ77VQVIX6XMZm+vSR3Uc9Ern0SDd+cSZrggtyXm
	D
X-Google-Smtp-Source: AGHT+IGMDGu/joehiaxA6+F4CJd3mr5o0uwP10H0YutyYLGkxfXq7Y7XXVz89KGzinCWYXhFS/oiFA==
X-Received: by 2002:a05:600c:43d4:b0:426:63bc:f031 with SMTP id 5b1f17b1804b1-426722c5ba9mr36997305e9.1.1720595187961;
        Wed, 10 Jul 2024 00:06:27 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266f736304sm68190965e9.34.2024.07.10.00.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 00:06:27 -0700 (PDT)
Message-ID: <10eaf2a8ff3db83b29c372b4feb62ac24444c94c.camel@suse.com>
Subject: Re: [PATCH 01/44] multipath-tools CI: more fixes for arm/v7
From: Martin Wilck <martin.wilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Date: Wed, 10 Jul 2024 09:06:26 +0200
In-Reply-To: <20240709213935.177028-2-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-2-mwilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

This patch needs another fix on top, which got lost during my final
rebase for the submitted series:

diff --git a/tests/wrap64.h b/tests/wrap64.h
index 890fae8..af6cc2b 100644
--- a/tests/wrap64.h
+++ b/tests/wrap64.h
@@ -2,6 +2,8 @@
 #define _WRAP64_H 1
 #include <syscall.h>
 #include <linux/types.h>
+/* The following include is required for LIBAIO_REDIRECT */
+#include <libaio.h>
 #include "util.h"
=20


