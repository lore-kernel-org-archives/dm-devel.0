Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D52C176AAE
	for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 22:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732313037; cv=none; b=B5VsU0MT4nJDMlixj7Dx+8pVW6PqVThOZHUvgfTBBTOIyD9iUbq/rcZkZjhfDFNj0EG0bgjRqyNre0z7tj8E5zlANOeAxozI1w008Hnc2ZPyC6aUpIK2wY0pD6WSpAXqqvruQHLGjE3RfRn16mMvWtHLuGUiQI6dlYsjD62NHnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732313037; c=relaxed/simple;
	bh=7q4nB8kPTl6NItjJUNAt/aOtOrrl6xYYy+URcQr7DUg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kVhVJ4JomY8oQP5UAACWPvttO5tGGecioV/adYe/QaZUz06dgKbR1Ct4Vl/E/1CiPcrBVSvBc4B+Fv0jmhirUtXSEp2nOjxWAOxcEuLUxurfE+ga2e36k1QseK090qnvfwWvCCOaoTlg1EMQ8Nu+QTZCyowzmqOakXWp1rkbdqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SQYkjgU1; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SQYkjgU1"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-382433611d0so2068317f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 22 Nov 2024 14:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732313033; x=1732917833; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7q4nB8kPTl6NItjJUNAt/aOtOrrl6xYYy+URcQr7DUg=;
        b=SQYkjgU1FDseTxmkhB2KmFlG9GwGhFVcD9FagqMPRhAMvWp53iFlaBuua1id12pJi4
         nN+tBKpu0ogxOzdCHy8ttE28OmeHcYF6xXEPkEqBTCA/hjpTBiWhkCNPH8S5vn1gomtI
         jB6RAScKIambUZgIAexiu2Gi/97j1tWJqkMUmU5zTVoDzFqEWFGaQP3wDtKfEtguYHJ0
         g4PTUHFCke5mGg1bR+CVrGHC9dkE40IAXTaMO/CY3JrKY5Wg2bzXwLBKPjNi3rcxpWDm
         jp14aJynu6EvnEgZYpCqqUYraEtrCkXYSWtVRN+xBkhjY4/22S7Wi5Z6S7sRct4Q8EDR
         2aoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732313033; x=1732917833;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7q4nB8kPTl6NItjJUNAt/aOtOrrl6xYYy+URcQr7DUg=;
        b=Hb6VFEWSOG2gabrU0dmTEKEh0gO/StIlCHNZCgE1KwxGE81ZgnHyTXSTxx5a9+7cpX
         R84EAjEgps7HHPgf9tUt3C9UuRsM3789VthK/2mH6dMhUEaa8ossVAwhfTyBFDUUjjP7
         gJIQaNKbNgl8hKX1Z3jy31TjetLl7JwTsHs+wmiKGuiJau6WmGOJ9QaEIidsxDUMu8q0
         k2kfjQaecqois9ZzL2tDohN02MZ0e2eoamopcbqC30kVSQpsaxyFUrkJVTKcmSU1k96Q
         xyxiXlQVqQRnW/vk1qATilgwIgQgkl61G9dJ2w42wetxVM09E/5PL92fRa23dL3xcKfg
         MO7A==
X-Gm-Message-State: AOJu0YxIPXT9u09JxFoxN1Aa56chbuCTKGQOk1SkIkXVqCtC6wXh8GMU
	1SqW/gM3c6ysfU8qpm/X6eGYg4IQMXIk+GxNvEK8a/XiA1q7BuWZCkzEORubETQ=
X-Gm-Gg: ASbGncvkEa8fPAYbuCxcuLJtLngXCfsEmqoRA0S557ZH61B8mpJb2BVJIQaAJ8hQBvA
	hl9eRansS9BCoxycdPQWtg4PU/CaoLOcs/mR1TAXbmA7Ywn3gKJ+DsqipBQq58N7FvzAmkkB+2S
	0nhYcXaTiNI8ZGfYYCEFVAXbkL/nB4NomAK5FeGEjctCy2UiiCWYKYi+O8FMikPrES/a6CrrP51
	bAdN9ShfcYi/zdPPW68JGRxcMdpSKwXg0NX6rQnWhKNF0LBpxQc26Oto33tGpvBi12Di4+rCf8p
	ggmWYNC3zd4wwfkQB7uWPtD5XegnKrnqKhQnxA/JAyJPU+v1DqZGLE80mA57RSrN6a+KHQ4drtM
	XqwY8RQ==
X-Google-Smtp-Source: AGHT+IHbGkj1Rsgv0/sMIPUMEMlm+VJhHwoPHqOUGKPy/YuQ5WWuof4VjL/cI01vfwEG4AU3i8S3Fg==
X-Received: by 2002:a05:6000:2d06:b0:382:4fee:c263 with SMTP id ffacd0b85a97d-38260b5385emr3499622f8f.20.1732313032688;
        Fri, 22 Nov 2024 14:03:52 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fbc3defsm3565798f8f.70.2024.11.22.14.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 14:03:52 -0800 (PST)
Message-ID: <52a2933ce3c24a0db5d5ae696f4ee7671cb0b57c.camel@suse.com>
Subject: Re: [PATCH v2 08/13] libmultipath: factor out code to check if a
 device is a parition
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Fri, 22 Nov 2024 23:03:51 +0100
In-Reply-To: <20241122211133.718861-9-bmarzins@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
	 <20241122211133.718861-9-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-22 at 16:11 -0500, Benjamin Marzinski wrote:
> Move the code to check if a device is a valid parition of a multipath

Nit: "parition" (subject line too).
