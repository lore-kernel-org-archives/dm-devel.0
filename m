Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEF010957
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760099862; cv=none; b=cG2wRYJZldrwqTpicvxxkYVziKG62cZs15+b0iejG73P3EkPdxi3resLHtbaaMzH/rhqELxHsyt2ObXWYrsfZ2VVyAmGkVxfh9lqDAfXM83wKHk9lGv36AzTywgG3Uz5O9WyAqwwdOBOrEVhOy7Yx2JaghLV6PzTsBuV1+NcfWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760099862; c=relaxed/simple;
	bh=TfBIy/SKVb0Z6jQhZa4s/xhG7OTbNdDw42tVx25P37A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozd3ocluT14woPv2+DHwwR6z7De8Z99/8Q+cRHy606zIdxmu2F1Rc1VxnzkuBZXPOFf5GN/NT+Czhk2Gaz6c0Fx4dzYwzKKJ+gwczjTDQ3Zmvpt9h5BpIRqhq1zSoCqrSLopCykZTIn6I1rvos5hyvbl98Db09L93wmkA4tTntE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YBtyhGMX; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YBtyhGMX"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e34c691a8so3767685e9.0
        for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 05:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760099859; x=1760704659; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=isgputJ+zMtcTIZfVwH0ybuoh0/xjkHg3Gxs9bs71Pk=;
        b=YBtyhGMXfL7ONgCO8O2W9fyo87GM4UhjIdoaOLDGvapkhebZoDQj0o8fjdXblP9yVD
         ZNe68ZtMcbR+t0Tp+IdwWIl4rZYgQ0Bj1xoPkQSNOx0aBO7VITzPsUKSBF+/+r+I6ED2
         blk2zpQ0RkJRevy00kubRF4Wg41VCGDyw4cyGdtPZR19Vi7TedButKNG+81eOXV1D19e
         oaYHT++QO8Uxp0FbDtf42DbHmohArfRSi9cJOqwjpci9rPjKL/D5vCdRJiz12zR3KSSq
         Gufki85oPt8KSuwOMgjBmH0NgWQuc2yiRbIVAAnKBdEd5l0EdbNc8iQg7F/IQtTYoKdy
         9Ijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760099859; x=1760704659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=isgputJ+zMtcTIZfVwH0ybuoh0/xjkHg3Gxs9bs71Pk=;
        b=OX/pA7xx4czY5Fu+jhD3pJ8e5D5U7Cb1yAIRNF5ySD+Hhs7GHJijvl8Bq0xPnnn3y3
         BDwQqn8RWo4fSM3AlwGaK600GBsxd7cTxicFPnS4sge5yY5mtqChEl2fLAjnualiIe0I
         ZJOd61fngfMlGgl0KeLPMcz83IaMqfh+W1FZMMnhJy5c0UGMb/de9VLZudYBg7ycekI9
         9u2qEz39sMfVHsvLiH7tZyX5IjbRFj911jDK0xpLOemhn5Dqt2h3flQpaMD9QQBjxDCc
         1IpjPAReMStESlP1bxX8o5h7Ji30UnMtI5wQTnSh1afWmFC8RGaDAaHm2Y47A31nvFOl
         DuHw==
X-Forwarded-Encrypted: i=1; AJvYcCWLsEqlLTMlwZnhiUF0I/xe2YGnasQYkG+Cu574iatJ5oEeDkn14wqBAzPIk3+/wXf+THW4uYutGg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw3xWIK7nN1JshjyXPZ8tVuKXm8VGUpNoaDF8E6r3TBD5ajxG+
	NJ/W51tuyfgRkiunCHvRhQeNfGG9+zI5nfc4CRI6T4bpQM6aQEMvSEE=
X-Gm-Gg: ASbGncvXramKo0VdiZqUudnbEzDAzaPIfYN4EB9PRO7OQAYStdTvnyddNFEAHbUmkTE
	IK8lzj/LkyRNzo7oKBKUhob5oc9cOjcgEB/0skZRFvmSZ/LDTAzDPRNPM7MnhZj0GJpk+LikmM/
	v5G8Vnr27rb9joLUH6T7iso5ZgGpyzFeS1MNxIC6ZIlq36eEBHbVz40Pp7XQ7Ft+p7GVc2mf8iq
	F4SVFN6ikkl27gOOAQoCcE0FFIP/7BprMA8WR6nUIlt9zY1fxrY1ks9A1lvylaDfJo3B+a8z4qC
	4fBu/913OvWM0KrcJ8dWYh9TDn/SuQHvTreUgmZHCP6Y5XX0EljZPV2KzDQfoQD4I3tjfLtXvWK
	CpNKAaHPF2c887uHxMfD5DZMqrxtZS9RNgtliYcrjoQaLAMJaAJnzvLZvXrxy5zqZQ4Jc7hIhMp
	QFTXS+gLngaA==
X-Google-Smtp-Source: AGHT+IE4L0EuP2Z2Hs4kriKTMqwEoWcgOkmqQdc1/TOCWZW59lj33u4eElOtKp5N80VcHCSNG5UaAQ==
X-Received: by 2002:a05:600c:310c:b0:46e:301c:d187 with SMTP id 5b1f17b1804b1-46fa9b1060amr47383945e9.5.1760099858697;
        Fri, 10 Oct 2025 05:37:38 -0700 (PDT)
Received: from localhost (120.red-80-39-141.dynamicip.rima-tde.net. [80.39.141.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e8309sm3981029f8f.50.2025.10.10.05.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 05:37:38 -0700 (PDT)
Message-ID: <a2923472-331c-43ea-9ba2-f7208b9869c9@gmail.com>
Date: Fri, 10 Oct 2025 14:37:37 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] multipath-tools: fix mandoc errors in man pages
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
 <0580f369a7102ae07aaa2c23fd4bd9165cbafd35.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <0580f369a7102ae07aaa2c23fd4bd9165cbafd35.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 1:20 PM, Martin Wilck wrote:

> I believe our man pages have more serious issues; for example, we use
> so deep indentation in multipath.conf.5 that the page is hardly
> readable on narrow terminals.

I do not think so:

export LC_ALL=en_US.UTF-8 MANROFFSEQ="" MANWIDTH=80
man ./multipath/multipath.conf.5.in

It is displayed correctly, except for these three lines:

sed -n 430p  ./multipath/multipath.conf.5.in
Regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR

sed -n 432p  ./multipath/multipath.conf.5.in
"%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*

sed -n 2043p  ./multipath/multipath.conf.5.in
uuid.fedcba98-3579-4567-8765-123456789abc [nvme]:nvme4n9 NVME,Some NVMe controller,FFFFFFFF


groff only shows warnings, with "-man -Tutf8", for the first ones:
groff -man -Tutf8 -z ./multipath/multipath.conf.5.in
troff:./multipath/multipath.conf.5.in:430: warning [p 5, 10.5i]: cannot adjust line
troff:./multipath/multipath.conf.5.in:432: warning [p 5, 11.3i]: cannot break line
