Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574594;
	b=gyp1BDiNIpMRztfplsLuAMS+uhtGgLbvA/5qkRjCOvPQ7gYJbOQb7VSh1+7pVw1QabLD
	 bNU3VARI5VW6el7FPtCxe8eKM3t1oJ9NWtfBVKyukSQRAihYsm7q5yxoid/87KwqBHKP5
	 6wdCuywl6BbSNaoY8gnTMLA5F4HCy7y/NosJTDalHGFBxptFOEc5tb967gUa9x45uKOdV
	 U5whlKm7MJqYsup4uFku6MwnLK0Jsl32X25oydhEOKwkaaq9sdJsqqsdrIUzG8iKarRJN
	 VyPtKHBFyoUCYlc3vQgWmr6ouHdeKCYOpuAsYJ2rLSi8O4qvF7iiX4Zj2KV8Wz/6stA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574594;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=q+v45zVyTweBKlYa/QX8dfmhr40G3Xbj6VT9d8E3uHg=;
	b=U34sIaBZpt5sytnPrJWxmJVnmKR8v7XWEzorFqxSqIvvAsnTU94tpe0y594D+ofrXXL6
	 pSA2IBjFZoguSDtGoOuMZsW+RxPfvAnxKaoMdQSfvADTWxp+ooWcps/xwEksOTBp/MAuV
	 +/ehJHrhB9nnjm93Yp5OQcBW17T3b/NAozUaO+Sd61EzoCmx04Z/to/6tCmvkiYEBlUyU
	 8KdrJ6viCn5bcVj4y+d6IFSsclEBsotw/S5kNuEggD5W/cmIts4L0wZTyhUaBMYAnhfdX
	 hLX5Wn64KaWnutyWtp4/IXCjssh+D6WaGk95ddqd/25SnqoJrasIX/2bdxuXIqecHgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XSaxHYhP;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936E7606A327
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 936E7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XSaxHYhP
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a599e9110eso3306525e9.0
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574592; x=1795179392; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q+v45zVyTweBKlYa/QX8dfmhr40G3Xbj6VT9d8E3uHg=;
        b=XSaxHYhPHJmbQ+3N2jcBtSxiEJcc5X89kAZkdD1ihpJ6jF6IpPVfg8V0y8Db8ulA+E
         1kaD6P/vM/LrU4exBJJ6ImgZQBCoMisBl5s3b853Dug/AHRyfsHDw+QbkPHE6XgkoglO
         YrHnU/q4jP6WZzqYjyubTRZ8WpxvNcEsDFEN4ljF1y1KppOeuspatArBlv7QKGbTW1G4
         vZthPGiSyuJ9ZlJNPk69tIv7WydUVOiUIwKY5IT7N/qxLvES8IdlQ62UGM23sHDBNZHg
         kq77JzT7As/FY70kGJb50Dn6IRAiDa28SpSJ0oi010nMNlpY1G+mHYel+LtTOg23NyN/
         KBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574592; x=1795179392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q+v45zVyTweBKlYa/QX8dfmhr40G3Xbj6VT9d8E3uHg=;
        b=x7Y4U1eueNqzGNRHN4PMNHZvUk5T51RMivsiRdZbP4X3Vg5esuw0eyKRAUhVxZWamk
         v9b6ddL3R2MJHVJMRzpXjm3JdJYnJabyZdJMF/eKNVQbPhU2BRVolDMc7NkHzd6PrTQf
         94FD9eljVSk8gDBunQUtnkVLfnWyI5v3gqEOaGx/yz+R1D8K7bwQ7LLETs82ROiGRca+
         MTYN8n/UpksHSY61deg3fo98AvbYDO3rcSAiZ+gAUBNQGPWCmifE4NJhZPEpYY4ytPFE
         aC9ue60IuLDI+2Je1Z6NTdD1wxHE/x0L7wAs31WCTT94ucQPu38iUyVpDRiPKZVR5aWn
         kN/A==
X-Forwarded-Encrypted: i=1; AL+hErHdm2ipR8OlCNxQZc1INFwQpx/YrfGfBRsn2r+pMpVdUEhhjYeincPpMa4mlZSei/Cu943zPDPxxA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9ox7ufUCim+TvdrdAAqBH2219Ca/DMuA9GAwUmSWYyjMCcKm9r
	jQqA502+5ovL7sn6Aq0qm46/vMuUSvBEMtKtJwFGclMGGmypcKRcx5U=
X-Gm-Gg: AYBFou1/TP4j1cDIIwlRcc9b44sOw+0qfXBEToMkpOjhSVqckYeGvi44GQ2Q2BFXPF9
	L8StYaaQfBbRFFjvD5u/n7o+Ibf8uRgD9N8s6Wal+YYFx4A+LDe1jA7ckAl935UdmVcN/7D6QQp
	a6wRgXlERO51GzZ0Y0dz3fbKGYUrHfBeoozIuydKXMFlDQ4bfPnF80lwlKKSb65hBjYxH41VE6g
	gYiuTQarOFuQDYX7rT8yBpFyLCVPaUjPIPsiF/jKB/e1O95VV5rYKdk2XNcbnmeRMwPnZjIDeV2
	WRErJ+SF45L9Qb9gupVmW0beUmc36o2000BF1GQfOJThQc1wzW52kk8k/mlXwpKed60CRS90ITQ
	ULrBctT1p7Q3HmS04SObG6UTP+ug53lF6e+3EmlwmCUvb5sOpzKB7ZH4geTpOz1rL9TfU6AlO7p
	lSP+/ZVJG3NM2YqMZ5CMR47/GUmZz3jfk166JaeZaW0gKOoH6Ds2xE/WRwBeMsTfqQdaxLwfmwI
	TcMi3RlbpFqzGX/rhZYa/Hdwf6JOgiNsdos+zRzlQvIjApAWLNlA8ZHDgTFarEgJOPNQ3b3DH9Z
	ezSDsI2Cn+GX9DOKP0Om0cOWKtj3y4ZvfT4n2wqddyeIK5H8Dz5QuknoEPS9EsQlDg==
X-Received: by 2002:a05:6000:4617:b0:48a:f5c5:d067 with SMTP id ffacd0b85a97d-49c6da16d42mr5434625f8f.2.1794574591789;
        Fri, 13 Nov 2026 04:56:31 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f782396sm5322579f8f.24.2026.11.13.04.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:31 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH v2 12/13] multipath-tools: add repology table to README.md
Date: Fri, 13 Nov 2026 13:55:44 +0100
Message-ID: <20261113125549.504780-13-xose.vazquez@gmail.com>
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

Besides helping distro maintainers spot outdated packages, it gives
users a quick overview of which versions are currently shipped across
distros.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: use a compact multi-column layout, and exclude unsupported
    distros. Small enough to stay at the top.
---
 README.md | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/README.md b/README.md
index fea8ea99..cdfb2f38 100644
--- a/README.md
+++ b/README.md
@@ -5,6 +5,8 @@ multipath-tools for Linux
 
 https://github.com/opensvc/multipath-tools
 
+[![Packaging status](https://repology.org/badge/vertical-allrepos/multipath-tools.svg?exclude_unsupported=1&columns=4)](https://repology.org/project/multipath-tools)
+
 This package provides the following binaries to drive the Device Mapper multipathing driver:
 
 * multipath - Device mapper target autoconfig.
-- 
2.56.1

