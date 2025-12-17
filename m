Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B51819E82A
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765993299; cv=none; b=e0ir1kJ767o/LxTTPIVkL4Pm1N9jU0sxfIgrsi1tjkMwLxJzEPdUMsPB/DpaPUCNiziook45FLcKoZD0u7g6KedaPjgUujWV/Xo5cRru6BAMWdIWAsyaDBSPCjNNTPLbVuhUYoRQDmCl9UQ/m9EtO1+oB151aH/2rmytAb7NTLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765993299; c=relaxed/simple;
	bh=SOW5kCSR2lCiMBasjXBaIxtfeHVUnjwHLKr7qpk9MF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoDg5TFt4gPe75uveA3GVxwPZRcqdlwek9tliM7AATP3wzCX94JK+mpiCzYSEnngHZjUEkSUIqMDpQxC5ehxBIhEy9tuhKt/1wbZIwXQChNQQbZMBHXnS+MTcBts1hYALoQKEMdwcSjm9WsJl2dbozz8IS4d5PS37lYb1PAnkcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3qrU/H6; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3qrU/H6"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29e0753e5d8so225ad.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 09:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765993298; x=1766598098; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ko2Pxs6NnyLM5kIutMq/1i8LefkDqSqGJgTXywJ7sM=;
        b=V3qrU/H6HT0xW/FnSlgh8JOIBs36ZxG7UdchDg2Mu4CApfS01aaOdAzkEb75MnPS8T
         pvzmFwK+Bnb5kP0EYX8ZSJ1tHDoVzwzsP/kwtNaEIo2uxjsPBPIAwjrjD7Kk3p+JxUUI
         xaFkEp+O0hRXhEYqhEYQ/1CSYel3KJ3skUkTqhXOdMt6onB5QIhSPOG4nrlErY5Jzn8L
         Pj0E+VvUAnpD8kD+ew2J/J0wOKDxPdaLYsRB7fepy6Vo9Mds0+zGXLPbA6zKn7T9QZD0
         Tgjc+LzEiZR17dJobKi8lbO9lhJlsoC2VcOuzln+145FXeZVRSVz6ufztf8c2ivwpTtb
         3gBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765993298; x=1766598098;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ko2Pxs6NnyLM5kIutMq/1i8LefkDqSqGJgTXywJ7sM=;
        b=QyEVc8AdhIbW+i6tyZ7RofX7vywB0NHu2YGof0EOyQpLfFEo5QzpwqmbWU78AA1NCF
         kszY/1gBTiGgGUkhwRiOOVRG8bOBmO5g/5ucHZ4whrltX7xKRDy22gAwDc510FYpU/y5
         dMIyrb7xkzKZQWDainldsntR49ZZRWk7UkWfZsAKop1uRUeFnD9CGrGe1Yc2gyLNnsSV
         ZGAjnotCEBL5SdTsR34XKdWDwF8z1gBho9jY5nAlWetG96kUSkrHElO8NJrhgYvCTze9
         xd18z1Mo9fhWrRygAUyrwxlafEKwT8/I9m/ScEc2rtDfrfcyoS8JeV5dInnFBdBdCWZd
         ZEyw==
X-Gm-Message-State: AOJu0Yw54rSV0614XKIVHLBRHfq9RkL+ku07WDeFOLIq7QEbPnGQxfOV
	EIyy9iHJOmmVtbRiigAIq6JZKcT0MGWNpJx7Cizp/N7zHEdNYrIkOb/nqlPy31xsZQ==
X-Gm-Gg: AY/fxX61GcDpU2jweMC6VqWUmunhskMR8eF7Yzj9VziPBpTkw2nX2s7fARoHYQ4Vif4
	Gp/BfmSg2K4e4u+y1RaxdDzfUAS3WQ701gt0U42CSbXE3Acda1Xfi9SJ7Imsu6KSA3h5Qza6XBf
	hvOG27iobdlcmQTTJSumgYztI+2n2urcgmeuJlhJgrUs3TrmOfe9C0qvNTy80rStPN3iaC+3YTz
	AemXG0AjxRV+S9vj0zEzZbYUHQV1qXcnF1rINvJ8SeiFheYXDJe91xIuGDwXjAuQaCdNE2cADM0
	2ZgJ5zWfHE7xf6X9ZxvlldnpZKJVqOC30z59D9pGjh57E4plhrCk8Mi2mGbWcnWkGCkKXmVqxse
	VdnWTuPKKP+euXZO66EdP1kBkQFFwlazFZFQViyodhkb7v2La4TDxuxeAnjN/E3Q1BgAJJoYKgm
	qKNudr28fA0WB/wYFH0auxTRfpztod4YstJ1PGGwpGaw+KxIGG8lLl42k=
X-Google-Smtp-Source: AGHT+IEd9G3ekrYqrJmnTQi97R/B7tko5ds/29G+nYWwbWP9z9Fmaib0nqToJib/Ijloiriilk958Q==
X-Received: by 2002:a17:903:1c8:b0:2a1:3cda:8e99 with SMTP id d9443c01a7336-2a2061026dfmr2822485ad.21.1765993297126;
        Wed, 17 Dec 2025 09:41:37 -0800 (PST)
Received: from google.com (99.181.125.34.bc.googleusercontent.com. [34.125.181.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fe11856f78sm83292b3a.11.2025.12.17.09.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 09:41:36 -0800 (PST)
Date: Wed, 17 Dec 2025 17:41:31 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eran Messeri <eranm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] dm-verity: move dm_verity_fec_io to mempool
Message-ID: <20251217174131.GA2944334@google.com>
References: <20251216230614.51779-1-ebiggers@kernel.org>
 <20251216230614.51779-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216230614.51779-2-ebiggers@kernel.org>

On Tue, Dec 16, 2025 at 03:06:08PM -0800, Eric Biggers wrote:
> Currently, struct dm_verity_fec_io is allocated in the front padding of
> struct bio using dm_target::per_io_data_size.  Unfortunately, struct
> dm_verity_fec_io is very large: 3096 bytes when CONFIG_64BIT=y &&
> PAGE_SIZE == 4096, or 9240 bytes when CONFIG_64BIT=y && PAGE_SIZE ==
> 16384.  This makes the bio size very large.
> 
> Moreover, most of dm_verity_fec_io gets iterated over up to three times,
> even on I/O requests that don't require any error correction:
> 
> 1. To zero the memory on allocation, if init_on_alloc=1.  (This happens
>    when the bio is allocated, not in dm-verity itself.)
> 
> 2. To zero the buffers array in verity_fec_init_io().
> 
> 3. To free the buffers in verity_fec_finish_io().
> 
> Fix all of these inefficiencies by moving dm_verity_fec_io to a mempool.
> Replace the embedded dm_verity_fec_io with a pointer
> dm_verity_io::fec_io.  verity_fec_init_io() initializes it to NULL,
> verity_fec_decode() allocates it on the first call, and
> verity_fec_finish_io() cleans it up.  The normal case is that the
> pointer simply stays NULL, so the overhead becomes negligible.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
