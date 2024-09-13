Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1242B186E2C
	for <dm-devel@lists.linux.dev>; Fri, 13 Sep 2024 09:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726219829; cv=none; b=Ygzfvun8A1SwZrXHOkdtate0e/9Mb866OVY/39FgAGI6jp+GiOpdN4Ma8vsSuxd5Sd3ST+u6JRljl7Vkkg1/b8VNjj/7unhYBg2x65xZaFC+Je6V+vUGJv18k/kmMNsjYEEsY5QHJiaSH7sD7W0OmQFUJnFA5z2pWAoxeNQwigE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726219829; c=relaxed/simple;
	bh=hMNncqe8omxV0xqcheFIHEto5rfDShz9/lW8iytYfm0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tcLKqDOKrJsVvcUBVIEWtF19XX46EayPi56sToFh5AvtY99z2drpHUFGeoXbIS9MRGYQ9f9JulKXk4lhK5c4fNVn/fdBjKYGSafOJQ9ygCTFaYHsklwsZxVRIGLfEJAFb37ibehclegAJlb3MvznUT1leCZvcRVltv54S9ua2A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UHodcLf1; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UHodcLf1"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a8d2daa2262so70970866b.1
        for <dm-devel@lists.linux.dev>; Fri, 13 Sep 2024 02:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726219825; x=1726824625; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hMNncqe8omxV0xqcheFIHEto5rfDShz9/lW8iytYfm0=;
        b=UHodcLf10zty1I4urRjDChPSOm+O4M8OzIKlJzyMUoR4bVRWRpGVoZ3Gq3/EAHcmAu
         QxB9GKwp6V9fkSeOlqZhuA3bw4/MAj3mHj12oKwxjoVwta7quife0r3VPcDUosC5CFEc
         aCvXLGOrrpZg5X7NNAh2AMsuUfpNpuwESmPORmWE5m/hAuEPgzjsCSlCyLyXrsXel6uI
         n56Qbn+AXB1ohonUrqt+YccM4+z8iazyEDuVTSzMYNz20RVDRFb3QlPT5s9M6cyBkL7e
         P95GphfY7jmiNJzr05TDPK74Nbt1g2kkyPBlt/GJHefxZEgALXFb5wbuIj3waz3/w2G9
         y3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726219825; x=1726824625;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hMNncqe8omxV0xqcheFIHEto5rfDShz9/lW8iytYfm0=;
        b=FKGAPEChIvQ48wzbuE8ATB5wEub/0wsrd99sEX20IyD58akxloFpA4y3YO1fk5pznf
         f3ybSxHbXRi9eeBcwQqmvrNj3enybYtl1Y1TNq7Bag+pu5GN48HN/ZPKe1Jx5jMuRlj8
         fODFRo34waoHhip40uJf6rWcxXSdzDm5mPfyh1zgh2E2YW07M+SaduZ3aorVmBp8HNNg
         IUXGQTnlOYiJHZIs3pO6MDwgYx0MFXUAXVcbsGSAeNJ4LpTx4cXnzjCo8qmZ6PSFjnfc
         jrIPMcJLAsnP+QDKHYG546Xjn+rK+asy3k0acDEggdHPHo0BhvClPerBV4btGgSYDmfK
         m1xA==
X-Gm-Message-State: AOJu0YztyJvn8cYReiCmSIC19odMjZzbp6N6Zp4Dz/5GRZdBoe/uy3sF
	thBAsK87Lc37GGZ8MrfQq1MZyWWR/300aT8IMfOX5Rm9fF1/AEWcWY/UsEblr15sRkKLV1e6qqE
	P
X-Google-Smtp-Source: AGHT+IGDxcre+OJckNypYXlILlOyVQgpA2hln9W9lSSPaejsjvkciqTiaVr12AilN5MNmKOXN6DRnQ==
X-Received: by 2002:a17:907:a08a:b0:a86:9041:a42a with SMTP id a640c23a62f3a-a904815403amr169247766b.62.1726219824633;
        Fri, 13 Sep 2024 02:30:24 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25835d31sm855074366b.10.2024.09.13.02.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2024 02:30:24 -0700 (PDT)
Message-ID: <c8ac1916a0595aa74fa8c63cd62648d89802a38c.camel@suse.com>
Subject: Re: [PATCH v2 00/22] Yet Another path checker refactor
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 13 Sep 2024 11:30:23 +0200
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> This patchset cleans up some of the ugly code from my last refactor,
> and
> speeds up multipathd path checking, by refactoring how paths are
> checked.
>=20

I haven't started reviewing this yet, but I'm seeing a CI problem with
the sysfs test, only with clang 18 on Fedora 40:
https://github.com/openSUSE/multipath-tools/actions/runs/10845899189

Martin

