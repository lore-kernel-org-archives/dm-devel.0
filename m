Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DFF1D88D0
	for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740117886; cv=none; b=t1cXnlAGKnt5ugeQxg1WYYUeNE87QGnUMdOvotFEzrO1pbCiQU4b+DOoezPI3VpbZkpM0y87f5xxoLXENrY5j7gBkcBCAPvSF5xxdnk+4P+fUQrcrKGsJdEtAZqLxYVaohmcJMhbmFLuyOvEyyjGZ2j71CoZEorDQb+t4qqyxCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740117886; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GUbgYiW9WOOJh50tn9NixVHF86onXJygkdTy3gaxI+HnvLqZ2KjXwNBPV2y+Pt7Hmjt/RaivnW45HzUltJEagQssvuco/4RSo54heOxlQ/UGPc/K5/4RMFF7jOcAdEYtJfPEgXb4CnpI9HzfCf7AG0GHAkVEX59MHN0YIwrPYnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GCOk7q2t; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCOk7q2t"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e04f2b1685so2639445a12.0
        for <dm-devel@lists.linux.dev>; Thu, 20 Feb 2025 22:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740117882; x=1740722682; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=GCOk7q2tn6NrxNRlfbiNFvNZf3oMZO5b8xLqMNE8xqwlp1b76qS/t0QOmSj6aUoYey
         3xfEEnIh0nfQ4718lFbu8Wgh4VqR02Z2KzUEjdHbpVVANpPSBmPTb3T1wLYlnr5UEjD/
         2vHjnvR+wmMENZDh5/NNoRUq0Ds0ndKIGP5iBOKuGWkl3jFDFgdMxDsstdEJ4+4Dw1HI
         Hs8uD33QJc3HzTv1ELzvalPu0aHMtOHh/bFHedOi08rbcEw/Gv43/P6yL3ZwVmKB5hih
         C/ZxbnCX/Okl1NVAPMXpm6C3+6WM2Om3zsojLOCpirJ/TwNviDM2m0npNdNBF9kj0dXY
         zP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740117882; x=1740722682;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=P+d533+LT6Z+3fnxvoowQ4txKQYY9vIhaox13hILkwGFMw0qghya353iIB2sKpC2wD
         jgQtzSLY1pmiXF+coG2LBt5k5GXMiRgNjAmTInkUesdJxWjdNsiuwL7w49FAqxhtKvo0
         gILQGWMN8CnjBOY+n43u1r8XgZ1MfEIO5gUKga7POu1BfLgJMmcqhRRMiUTU+Bq71BlO
         DHt/hmCtJTr6MBb4SS0YnHDcFIARly4EZihxZw2soWRwKtvIOSL5Imcd5HzVTRFIWH/O
         dg0IgOGJLnDXqjxMYb6dgxcgVQw1ULfJbaxAsH03esIcvf4LOqmgyGyr1Ft/F7YK2ikn
         akeA==
X-Forwarded-Encrypted: i=1; AJvYcCWc2pUtTvHc0LtQBvcZjYqY+7LGvk/bVNsjP9aAK6au5na5tGajPw0GM6NYSLGI82vroUMolLtPFw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyZPzEuSSbeIUYarKLh88GvmTSoEkyGhDPZ/O8zFQMmmz1p5cnZ
	odWIsfkdDpsrb9C7/FnCrGSjF8x3TMqDzpkHzxMmfuUslWo0KluymsxNtgGk2HptIAgRBgN1XOk
	F8L2/FOKh01/l8alWSX4QS7EVJA==
X-Gm-Gg: ASbGnct1cPe1VngX3AU7Q0XdmFeULxpnPQXkrhgKPC0WauLwCt6uddOjK9wDJ6xl1TD
	aFOfjvykkojayFKAS/8w+5xMIQUHAeOxRwsZcQRytJbzD3sbzUPvqNzFHIXOnq0xa1h29eZFT0e
	mF4ZVfXy9LI0AXMCARHNpv48Qx
X-Google-Smtp-Source: AGHT+IHmkNdoP0lQmYkaPz1cUQ47LOF6QpXFYHPM4c/oOTSgwo+IVPASjLMMnY/UxaJjHRUbCZd1xBJU1fjX44ztcPc=
X-Received: by 2002:a05:6402:278e:b0:5dc:cf9b:b04a with SMTP id
 4fb4d7f45d1cf-5e0b70bfd22mr3676526a12.1.1740117882015; Thu, 20 Feb 2025
 22:04:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250218182207.3982214-1-hch@lst.de> <20250218182207.3982214-2-hch@lst.de>
In-Reply-To: <20250218182207.3982214-2-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 21 Feb 2025 11:34:04 +0530
X-Gm-Features: AWEUYZk1SsCUpExkqrbtzlKVvVVj5PRdn2lvkfA9m6CAF7VBeabw3D1AzdThJNk
Message-ID: <CACzX3AvYT9mdfzMTgDifLaw_ktumiia+CuNb24GWUFhFYXrtGw@mail.gmail.com>
Subject: Re: [PATCH 1/3] block: mark bounce buffering as incompatible with integrity
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
