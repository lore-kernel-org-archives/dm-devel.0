Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFDE481DD
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965070; cv=none; b=ebZjOvtZ7zEVKO5wTpNrIF7JooZQiJtCWXmDYKNRr03+TLvZIwMN+NN/YUuMPzi5x8YhHU46TPYE08gWPaxRmx6+vaYT26Bdlj1rewmw1PApnM9ZnJZ6SSITadfqdycRquVOA8uLTVlXZErM00FVr4YpYvF8igw/SReuI+GJ7CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965070; c=relaxed/simple;
	bh=8q9vsUhsZGqi+EcrkG68AgEvx++08Iv4fBlsSugiAUw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tBNdDRBQLOiUiD5HyVdAB6dHFj8zUu+xdmCJW/wzFPnWykw34IOwAeg3FCpB9dxcXxCwNVN5l8ihDiFhrI2S2xIzmOf+dXIyoVhyv5LPB2WYeFZ/3G/28SxWN8Q2eSFp7sFeVIwvb7YblCRVAjmOn/QTG6z4LCiB1u1JhlkKUqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=Lr4hk+WV; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="Lr4hk+WV"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ccd1f57b32so51557566d6.2
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780965069; x=1781569869; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kMy5BwhnyaX9NS4a1FaUOvPDZuIhtSXICwCkeGO/exs=;
        b=Lr4hk+WVxaVSyq9bU/jbvdI7/MvRHBrOIL9FyoEdgkL9Rgq3GaI3SLrYHCfw8i75tG
         Jz5fFDy/aYGuSo8GK9nSVabAbv8htskISQQeVtVzikLrIGWGF4ajU0U+TecD3FkGxFKL
         83ko639/UidGwI0KTUL0FyldIZDADI36XP9jDjDUerVbFuZvNFu74ZEmQWPfBpLKdYl+
         wvR5iJXe9ZMkP+jBzPeymeeZhGXbF7GPAIPrQ9Xv0DYZ2/LeLmYK/5l8vwaplfv8VSDm
         cI9HLmbZm/WUBa57ncj7auszetbQCfvcimsttNeOo5N8HP0+7+va5s3D8drnu0RhRobB
         d19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780965069; x=1781569869;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kMy5BwhnyaX9NS4a1FaUOvPDZuIhtSXICwCkeGO/exs=;
        b=OK2JaGG33wOsZfxW9qky70P13m2ymTcPigd2xktKZPmmDJ/PRrPvF3S8VsA6NwpZdD
         Nxz9ez6Znoj7gpnPEzW16IW0Nmu3VE7Twpp5XmpTo1RWSb1h0HjP/DfX+XlhcTdLfAq4
         jnAR/XEgIl3ggaIKcBmugA228WljFInGI9T6H7mog1u12wUG2ZJyUs425+n3BfSsa2Z7
         ufDEJpIokXA6FffBgLaklTN936AHtYymg9Q7OGqj8Co4TVkTSTwL/6b5Iy+/yRbJgTCm
         +d7eAyliCUKjF4LquIYQh8Z39OQkpTLcYmFZZYYHTd6FV/TZ5jfvnwAH3H4wpc8cWyRt
         NpnQ==
X-Forwarded-Encrypted: i=1; AFNElJ+A+IgL/uINHfVinS71CsDu1/tVA0iYPgMqXPzqYvFSshTFUP1+LDPzoN2aBtDECcFEc4aad6Ge2g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzGtbzJ/ezMCC0FbAkgMMtdbOfkFTYXpCc2VVyGml7aRMZNeHM6
	0ZBj4KJXMVCBNDWqmFSuJX78Hx43WLniRGOb4sp7SYEUnqGISMLkPmsrnjB3r9leiRc=
X-Gm-Gg: Acq92OG/uwnYgBdc+/1dQe2UoIy9y0FWW3CTHIKsYDpZquz0iogG29t9o8M5QRlkAl6
	DGTHFa+Yb8Gy9olADYckb4hMXi+GW4Qe+KqvA7ay6zh87ce1j+/ZvMwPYBaX8VjtYO8Vw+e3ssQ
	j2hUrkMZPguRyJRYU+W+VJEjP0EL3eJp/9voVTIJCsQqaOrrXPfPlZthyxqW4bV5VmZS09i5jyp
	45YApt6Pp/6lzdc1rw8vXZwJGJJXSTnWhiCxCANuOy5xeCa2hsk0YVdMRG9gysOcL/vGr+9Z03T
	Tz5K15ZHR1XHS+OkGpx+KRvORuAZMt4WwNZHNEDFbbTIR/2/wWsYZq0Gz5N4TFFGwV2kdGs1xHM
	U9lj4u01l2IiIZiNk15y36PUpFPKO7B1bt37enEk8IOVHNdWbczARnnhytsJrdB/NzOmY19+KWg
	WWlEOhvsZgFb24naK/VrbL+U5ZOSNFiPJc506pYWXnED8S28VO
X-Received: by 2002:a05:6214:246:b0:8b2:13cd:ad38 with SMTP id 6a1803df08f44-8cee5fb6e1emr211019846d6.11.1780965068591;
        Mon, 08 Jun 2026 17:31:08 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8ceccd9dfc1sm182099906d6.4.2026.06.08.17.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:31:07 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Zheng Gu <cengku@gmail.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER PCACHE TARGET),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm-pcache: reject option groups without values
Date: Tue,  9 Jun 2026 00:30:40 +0000
Message-ID: <20260609003039.1236796.0386591ecc03.dm-pcache-missing-option-value-null-deref@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pcache target parses optional arguments as name/value pairs.  A
table that advertises one optional argument and supplies only a
recognized option name, for example "cache_mode", reaches
parse_cache_opts() with argc == 1.  The parser consumes the name,
decrements argc to zero, then calls dm_shift_arg() again for the value.
dm_shift_arg() returns NULL when no arguments remain, and the following
strcmp() dereferences that NULL pointer.

Reject odd optional argument counts before parsing the name/value pairs.
This keeps valid "cache_mode writeback" and "data_crc true/false" tables
unchanged while making malformed tables fail during target construction.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-pcache/dm_pcache.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
index 81c795c0400e..ba5471885b16 100644
--- a/drivers/md/dm-pcache/dm_pcache.c
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -163,6 +163,11 @@ static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
 	if (ret)
 		return -EINVAL;
 
+	if (argc & 1) {
+		*error = "Invalid number of cache option arguments";
+		return -EINVAL;
+	}
+
 	while (argc) {
 		arg = dm_shift_arg(as);
 		argc--;
-- 
2.43.0

