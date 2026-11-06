Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793986619;
	b=q1eK0XGyOORaf2xcORAslCWVJzfSAVwYw2qnLe0foaeUH28+moABVZuq6Y4TRY7mAbuw
	 7EiQhy6Ul6JSDo1KJgKOaB9r9kqs5qi7m8FGhNWdIvjtgLLGA4hiM1MwuFQYBYXBPBKog
	 YtDwyyOrTeKpaFscRix/Oo3PLKKfGyrVQCZXC9prXWhyVN/m22VBntiZ/yTYcBLfnKDVP
	 pZmv6Xk1Yp0Mr2peXN22mCS5/VrByBoPcG4sR3OG8HX/oqG3YqEcf+YlyW8S12zY1ikBR
	 ZHDQJfgZFvOF93DriC6SfTREJyOk4liB2aJO2oGbjg9PNnYZnFdmCKxdX2NJbZWZHiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793986619;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=QnOiMFd+pvqMJgwwMSVd4uppblv1+ofBFY1OzlXmQ7I=;
	b=KJtHi0J8LI2lnExQj3sr2Gsac/Oii8C694Pg0j01eynIhRl5KiLjINygcfXQb2DAjsb9
	 ZoigUj5s3R8EK5zE091kS7SKVULrvlRyyHi6IyfXZO6YQN3dUrZg+qG2SgVXgJLxp6pEc
	 GZVW6BrXLjPq8aVfo4jEkP2aPqJq1f7IXC38dWSA/k5IO4WvS2q1zcU4IdR+SD+NoeeUh
	 N2M3Wh/+B5IWgU/vCI9TVtIGn7/2CpPoPOzQRqTiQKV2U2QqDKZPI/+gbN/+6xY5HudY1
	 j1PYA/P+vPmpnNRnSwKjnp8KbcJSjvcGLhJlxHLpCswG6Bqt8aRIGYwCJVUp5GPBUiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=O1cVkE96;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12700606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 17:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12700606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=O1cVkE96
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a208d93758so9450975e9.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Nov 2026 09:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793986617; x=1794591417; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QnOiMFd+pvqMJgwwMSVd4uppblv1+ofBFY1OzlXmQ7I=;
        b=O1cVkE96K1uoxl9JVAHCVQEfGunnKVWE88W7cxZwnVx2VgtodJPSStyDx55oITPlbx
         6H3M8dBH9tJBbFPoYbn4egwbie1jKouDGtRA7kiG0vVwnZsdX49kydmejXOxN10xtZaF
         zixjV8bVg9f8uCMH1GuuTa0pv/1unJjkHiZ5ROWCrVF4UZx4gFRd/iFYJOiK8b+iUUXw
         Td9Z7PE6YYMveG8MZ7VPhwJYH2izdM8QbVQCEUtC3+xJ1Kn7HYqDt3XuOSAh6/pAbSWt
         9gb7qQQmBvQWKeSao0Y7iFoJ6EflrlTmM0k3KA4p7Um864Nqb/UxPmKtfKrjmfD0mzuw
         VsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793986617; x=1794591417;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QnOiMFd+pvqMJgwwMSVd4uppblv1+ofBFY1OzlXmQ7I=;
        b=K/VgHTUBKpNxe2Sa8csHUTLn2A0A6cs3pTs3WqxiAm9h9pZNRGJ09DucBIQxo89OZT
         bLHgnwQW0bS5kBfo7xZyxcKAIvTF+5swJp5dqfbFv2wpRBN9HAM5FlNilX/6U08U+EoY
         gzqYk3S61f1FFU/iT68wTjSrO75TKpM9xVtTWqGF447lxGSf9roTTwOJds720PInC+72
         s7hlnI3GhogWwO38etKAy4n+NjDd1an8P5NUGZGUH7iB4Bqzj/7ei/fa5OIBzX/cwpQ+
         XadQiu4BrPaeV8qvZ5jufDKSc6ZojWNxRqHHQx4e2vP7ncAUOPtCJLoK03b5H0vBm35j
         39SA==
X-Gm-Message-State: APuU4Z8a43l2GI9I5WzB/Q3Js+yF9IRBw7KbQj8P6rCTqkf7m0edTk/c
	pBrTRXOFfYfhRq+BKlldAY6+953d993d5+jcfF+NO0hM42scBC5ZpMz3CZowb5IpJ7A=
X-Gm-Gg: AYBFou3sGWEXjXpaeGO5Yhht6xMhuDLMLj3nlZh+RBZkn3/qj9Av3yxnXWGWyTG4rVa
	aROEcaOIBIzBGTex5K+lWxVcQFMq68KysKP/zsHZH8deamK/R3DZpw/DcDPKw0PJLjjbTNZTj5t
	++cA3PGBck6usD6W7hhIlgw1OiqhRv9+RI0ap4gBjNVlvE+zjpAZIYhGK6AmkYshXcmqu9r2Kti
	ILIJpTcWc+JjBYIdYAqGc3Il91FW2n4FmY+A2f7aI+xLiRU+Hf4k2gclubFxyMvwdfrhFKwjFMz
	JnxC54o0aM/h3bt0Nf5gQTetnt5gYZQQjeRNs5rkVVIiuSPzsDkeD8CYydLm3moAEZ9VbedWtaT
	mCnknkh/pWpnEsVBJvl/FVzVYYhXS7mTpUJ/GPz4EkF9xuWjfR89WhiZ6GmSjpyaD14W2Q0qRSQ
	rYJ1px/asJYnvG8REFrJsv429/iVIe3qdN7J6Jec6WV8xyUH8I8glro5QCpK5io/Ev21l87WYne
	Hh0Gvj++C0T8wE47dY371vfOFox7Vc0mprtGKMj4QESkbJUFXElqjS7YvWBRWwCHm+sM09cAwcK
	QNUtg3wGsohnHMFD0lJ503GBVwpDVyytDv8SxQVlCdv2MwDA3xAs7eHOpXYO3hglWwe8AMc8B4E
	/ool8keA/NDxZWqrC8Q==
X-Received: by 2002:a05:600c:c8a:b0:4a1:f377:5c75 with SMTP id 5b1f17b1804b1-4b6e0454dbfmr55892195e9.33.1793986617202;
        Fri, 06 Nov 2026 09:36:57 -0800 (PST)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4b6e1b5d7desm84477835e9.8.2026.11.06.09.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 09:36:55 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: dm-devel@lists.linux.dev, Brian Bunker <brian@purestorage.com>
Cc: bmarzins@redhat.com, christophe.varoqui@opensvc.com
In-Reply-To: <20261103003150.78513-1-brian@purestorage.com>
References: <20261103003150.78513-1-brian@purestorage.com>
Subject: Re: [PATCH v6 0/1] multipathd: don't leave maps read-only after
 write protect is cleared
Message-Id: <179398658699.90251.2450838326814469026.b4-ty@b4>
Date: Fri, 06 Nov 2026 18:36:26 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=679; i=mwilck@suse.com;
 h=from:subject:message-id; bh=PWvcP/EdOTHP7bTnRaEhblK8gh3+pYSSXQeufYf/22c=;
 b=owEBCQL2/ZANAwAIAaFOxj0gAPzbAcsmYgBq7hAj35U7lhPJTwJON06rwRs41nj6wFRZJYwRg
 y+3abKZ+5SJAc8EAAEIADkWIQT9/H021zOM2230IgahTsY9IAD82wUCau4QIxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQoU7GPSAA/NurUAv9HE148pyFcKnbGg5H5GBwQKVw92gRcHn
 FoTfFMBEPytyfJfiBdQIDsU/2jFlGHAPq/+c6IZfmY4M+tGSXWjcd5mcqFP6wAaJsOuDnb0hMi8
 h6MR59CfYCxrxlMFdYlAxZPvaguX9I6TtBsGWC9RXnUgp2i/jtivjAZ05TlsyFNuFWQA3xk0Pwm
 J2Vz136ak2rLRtc8CnSFnHTlWu/jP54fCJ1C1d9WpvZkgOwoaIz3ZUjC2Wx6TL2bL+YaKc6zH95
 O9ISO/bnOZ3/UjyALqp2TFgk1lZvJ3rIT5HVOTbFDsuKwKrTTQ8KswfWSwZcxjWoOh0bdiqVaz/
 4wAlK3cfq+StjZ0eC7kp8x0Iy1eg1oA+QpvIj89punzsb6CF7vcu7kr5ahvpytuQ9xJNEtmXiT/
 gAfgQHY5utcj0cq/pDeFiaCOiqBKVFUWiKItAwDUGZg/LAHPOMWW2Bg3xhydUWMnJgKZbTu14FO
 ymE6y3pE9//pNP2YBOG2F0glHHocs00
X-Developer-Key: i=mwilck@suse.com; a=openpgp;
 fpr=750EAD4B2EDEB1A545D4F5F467C586E685569754


On Mon, 02 Nov 2026 16:31:49 -0800, Brian Bunker wrote:
> multipathd: don't leave maps read-only after write protect is cleared
> 
> This is v6. It follows Ben's review of v5: needs_ro_update() no longer
> takes an ro value and no longer tries to avoid reading the paths' ro
> state from sysfs. It recomputes force_readonly from all of the map's
> paths on every call, which removes the special cases v5 needed. The
> changes are listed at the end.
> 
> [...]

Applied, thanks!

[1/1] multipathd: don't leave maps read-only after write protect is cleared
      commit: 64418813475cbf3cd4131cb9da55655181dc238e

Best regards,
-- 
Martin Wilck <mwilck@suse.com>

