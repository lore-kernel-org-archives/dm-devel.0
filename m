Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794220097;
	b=r5D/tANm/QjsjDebMSszoHptBIQdzZ5hTCS4blpeln0F6yWRs+IXeo02gX3EyP6Qs6Id
	 cQlGiZWRNBOvt7qdJQgo5RsxDBT8n3u0/x+7ug5nHrs5SaC/ivE3OU35x/++SRBFJKJSn
	 t8Sop52UJDke0/CMy17riRvNjBvRL5UUvvzPpHBc4BVIZ6/asenMMRLKq/oI+3xjcaS8v
	 yRcEXYz+8bav/mtm2PMgN26zomTmra6Vb9smAFRjO6hD0VKpHnQ/EZW4pqyEZOHhtMPDf
	 pSM8K6wYpIkGkw9Gjmk0wxSugKlabqBDNRO1rJE/f8kQRTXOo1ggvRUcnwidfPo6C4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794220097;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=YzoKSfiC/AhSKapcw2wsRzx1iaRFXs2ZfT9x8CFQDSQ=;
	b=zlwtrSDUyju3oOIRFuU6Jmb28QnS/kMAPs7SiR7C4gfiodiEkGaGpMUy51cIi2V6N8UI
	 DDYvbhIdBD83ZRNd9zRy5/2F6k9zfG0Q02cp08104q+p2vq4dZcS2KteLB1HNuiy5Kh5C
	 VPGsCzKSRBkm1N31W7piyjlKlIm0zDecJFwhP99RqyLFKez79WnarhRp/5lRibBH96D6M
	 LTTN8AJ2jw3S2LU6l0tv6HdUBSdty9I1e0x6zf+6SjndGw3doYpOFb00v9XiHtW4GC9sO
	 ycHH0uPynZ+FEmbvp6nrOGntl/nSjc7gdpLhLv8wNKroCa71zPyMifbWx5FTKHjjhOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HTlLZIDP;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E871E606A321
	for <dm-devel@lists.linux.dev>; Mon,  9 Nov 2026 10:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E871E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HTlLZIDP
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-49083b985d2so29879f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 02:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794220095; x=1794824895; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YzoKSfiC/AhSKapcw2wsRzx1iaRFXs2ZfT9x8CFQDSQ=;
        b=HTlLZIDPhoqyxbQcbmMZuWorsLZdB+BSqpNyf/soXGJXOUVgOo2ep0CLkVN7sdragd
         XxhEgGhw7W9LeHC5foP7D0ViTgeKYdF+94GeL4RApKeN0awi4b7iPYIrMoOxWfA34KdY
         Ck0qP5jGq9OPMpW5sWC+PSdgZyVmLu9vy24SATAN8up/S/ShVMRujIwIV8/WvS8yMtXR
         PguJSdIa9gyMGVbdc5kCp0xMhWz7hefGrLPQEA4a9uE04BoARkRd9rfYIAkC8X6+71Oj
         c/lveP8BHsQe1IAoFZoG+LaAT0PjW5QB8mnb4qWxTXrAENvz7pMuGw23TxEOL9xS9ArR
         HOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794220095; x=1794824895;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YzoKSfiC/AhSKapcw2wsRzx1iaRFXs2ZfT9x8CFQDSQ=;
        b=Op82+oyDAaLpheg1D1eGAEWd0no05QO0tXpaqJT3gddaEpKMXVfkwtyAgSsIDOEsrk
         Yyoo7a2F6wiaQ824a+bgbqHTRddeRyBaAKb2vfVimeYRXE5y048jV1V4x2rCvSHD+8wG
         Df1JyiCkCGo6kKjYNxbIvlZYqlJL4SY2B/p8r+M5+PKdD32XqQsj+EsqzOCFkjDP9CUz
         aKb8j+dub/pr4JktX5scdlJgGFPsgS83dydaHuHxadip4sFyQljsN8JiZ8LBFBfmG7oc
         3P/kHV22YHQxTLiGc1TO2L6KOap7DioRczFM52PHPnui2jTBNjHW4jHcaqMQfsDfzo+l
         JAuA==
X-Forwarded-Encrypted: i=1; AL+hErEQwbFER+ETxdd7G3NGsNsPzG2rBFgPRGXVfpPsWDnQlzm1iFaMm3Wk+EFqTbboCUIu6wQjPJ0bag==@lists.linux.dev
X-Gm-Message-State: APuU4Z9sQ3YEniVnI2mDnlZsB8sIiGGR6NZGSsMpvFkeoUTlw+yO5LsJ
	Y2G75KmOQ83Pk8G9ajPFUimxYH2+fSXWwbgYPNLvWHls1X7z59mINe8=
X-Gm-Gg: AYBFou3MX/lXvQQahd9qJllTYVYqFp9ek0HPR8vKYrwHck72NjLYjLZ7zsgsb4AQ9pg
	u6xBXS/DlUbxB2ykJBIT4VDTl7Wijpqa3sCmmbnuIRZmORFPOn1qg0+E0l0+kgMCPpXf3XCDyTg
	xHoSsnoX7fpjR3pfP923yZT0m2kRA0F1y09YPiGNT6ILyD/xRO2lZzXbjxpoysDPz/AKbgMuVjk
	ZSA+LeSoCCdmqR67XcYQGivx1OnsnxR+QM/4RUjriPNU6kdA1Z0np2gt14ls8qoLhORgbFSbol1
	pd6GVooUr6VpPKwebp+/q2KGWlVaikRWd+NddTVOfCcwWWzg1FD5iU1zZOHAGZzMMfcG2IVGrxA
	zBrP4Y/8Iewf2s/q0dEIQzNghxXphQbQyBRz5/iuGE8UhZah0s2sYYS05n+VuOgXGPju3Ft5Hl3
	Yzgb+yrdfAzQOVrA4SRPmpglGFIze+u27zJWs+F+vWwRJXW43nonaJmsbjDHErucgOjZKs3neZv
	nUaiUbnjc7p4OweKieStOrvxRFDdWvgiz4akZQiFVTg5yGqqv/yGtVn2wqbtzl1qKUEJIinAEkj
	KmngfT28Nyc9G+VKRcyFNpT92LGnGEVWtBuD5PZ/CGER68nbML+fIjgOyCauAJif
X-Received: by 2002:a05:6000:230e:b0:493:9233:ce65 with SMTP id ffacd0b85a97d-4957c6e3a22mr7285786f8f.0.1794220095238;
        Mon, 09 Nov 2026 02:28:15 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597d09e20sm9165541f8f.54.2026.11.09.02.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 02:28:14 -0800 (PST)
Message-ID: <d3e9eaa7-fff4-405d-a7cc-d5daab77ae16@gmail.com>
Date: Mon, 9 Nov 2026 11:28:13 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH] nvme-cli: nvmf-autoconnect: Consolidate vendor-specific
 NVMe-oF udev rules into a single file
To: Martin Wilck <mwilck@suse.com>
Cc: John Garry <john.garry@linux.dev>, Nilay Shroff <nilay@linux.ibm.com>,
 Guixin Liu <kanie@linux.alibaba.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 Martin George <marting@netapp.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 Zou Ming <zouming.zouming@huawei.com>, Li Xiaokeng <lixiaokeng@huawei.com>,
 Randy Jennings <randyj@purestorage.com>, Jyoti Rani <jrani@purestorage.com>,
 Brian Bunker <brian@purestorage.com>, Uday Shankar
 <ushankar@purestorage.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Marco Patalano <mpatalan@redhat.com>,
 "Ewan D. Milne" <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Daniel Wagner <wagi@monom.org>,
 Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 BLOCK-ML <linux-block@vger.kernel.org>,
 NVME-ML <linux-nvme@lists.infradead.org>,
 SCSI-ML <linux-scsi@vger.kernel.org>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20261109000834.513230-1-xose.vazquez@gmail.com>
 <f2b862d6106122031d3ad93ea3bd1a7964508de7.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <f2b862d6106122031d3ad93ea3bd1a7964508de7.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 11:09 AM, Martin Wilck wrote:

> On Mon, 2026-11-09 at 01:08 +0100, Xose Vazquez Perez wrote:
>> Cc: John Garry <john.garry@linux.dev>
>> Cc: Nilay Shroff <nilay@linux.ibm.com>
>> Cc: Guixin Liu <kanie@linux.alibaba.com>
>> Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
>> Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
>> Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
>> Cc: Martin George <marting@netapp.com>
>> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
>> Cc: Zou Ming <zouming.zouming@huawei.com>
>> Cc: Li Xiaokeng <lixiaokeng@huawei.com>
>> Cc: Randy Jennings <randyj@purestorage.com>
>> Cc: Jyoti Rani <jrani@purestorage.com>
>> Cc: Brian Bunker <brian@purestorage.com>
>> Cc: Uday Shankar <ushankar@purestorage.com>
>> Cc: Chaitanya Kulkarni <kch@nvidia.com>
>> Cc: Sagi Grimberg <sagi@grimberg.me>
>> Cc: Keith Busch <kbusch@kernel.org>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Marco Patalano <mpatalan@redhat.com>
>> Cc: Ewan D. Milne <emilne@redhat.com>
>> Cc: John Meneghini <jmeneghi@redhat.com>
>> Cc: Daniel Wagner <dwagner@suse.de>
>> Cc: Daniel Wagner <wagi@monom.org>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: BLOCK-ML <linux-block@vger.kernel.org>
>> Cc: NVME-ML <linux-nvme@lists.infradead.org>
>> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
>> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

> Generally a good idea, but I think nvme-cli has a GitHub based
> development workflow these days.

While GitHub is an option, web-based interfaces tend to limit patch
visibility and broad review reach across subsystems. Mailing lists
remain far more versatile for cross-project visibility and discussion.

> I'm not a fan of repeated lengthy match expressions in udev rules.
> Can we improve the readability by using GOTOs and LABELS?

Using GOTOs and LABELS cleans up the duplicated model match expressions nicely.
However, the scope of this patch is intentionally kept to a pure consolidation.
