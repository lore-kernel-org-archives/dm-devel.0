Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D4729E10F
	for <dm-devel@lists.linux.dev>; Fri, 23 Jan 2026 23:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769210545; cv=pass; b=Y7kvpihjVVnxoKcuSFygsXzIMZmYUPmvg//703ujdYFS7VJigx+zJCK/axYkDkECx28Hv8hPQiCyl0uxs8eCpcSBlEd72gtTLVeIWjVEb2zEJgiLp9bTVZQbKY6PYiAe5JvjPzAGA0+37cyjdYcvaDbQ3u5G00ndnt03uVHeNfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769210545; c=relaxed/simple;
	bh=gmjCBcOa8kehuqXYcaRDXV0aTObHbtjzt7jkizepL7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tlh/NWdDAaTea65IafHy7WgJJdTpC4Q78rhueJL5ORC1C0e26jY6cvOcCF9jcFi8nS3m+iWXN3DtxUYfvsz1zoSWlqIy5DQzUQkn6AXJg0hZkIhqWiI29/dXFO2zi09krMPic6qE5xVuu90jMKshcGT8jWZDV5jP241jEfszQ6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YzuAYMFC; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YzuAYMFC"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso1092a12.1
        for <dm-devel@lists.linux.dev>; Fri, 23 Jan 2026 15:22:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769210541; cv=none;
        d=google.com; s=arc-20240605;
        b=IzMk4MEhPySegX34AKlGDy6+FbEVj7DXdInzV+hk559knq7m+5c8kMZdFHzghY/Me1
         HeiQ0TlzavdnnIHgyuK2z7/AugZTKmc79V9n/R4XH6Ozb0im/uxQmvNE508C9FvjdwrR
         AHf/sTDuiu3m+Be/xlXG6rohee0R/2v7lTsQ0eUjPglf7LnNfO0BkoYAyuy+3QeQNLpf
         3sNxwShS2YFqSssP+Lo+lsD68HIqmJVOOLF7uiFjlFWtoQT4+BcuSuxSgc+CqKI52jOa
         k3JOAS3dQjiee/qNGYNGSc+xVkIrX09XrBYixSuHCyPzNzTVTJbvcG68ilMeJROFhMEe
         gz+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=awyVbp3yIy8FIlTKbh8bMRHc/TOuIHyYVaLcQNHXtwY=;
        fh=dTAHK+0abp6vtiCw8MzE2mrS5eqwMiO7Tz4d9qqUk/4=;
        b=HuylhJnJfc4/TC9F1rLrIacZSIpVxfeQluvdYRmufzF0BSh9Dngo5ZSZ5WrE9EvC7J
         +MufO3BTbuDFNBEFgKYej11GjQZVLf+VkimSiNcLVwCQ2nUphr8NAmYUARbaaJkA0ptv
         6M4FZ3G5rgK9Zm1hQ9ybmDKfV4TwT3oudbh78s5OWniRawOclbBm+0i07v53eNx8ZVYA
         XWTr+4xJoTm+Qo0eoF72yJnt+E/mcKAhgUMn91lOsMWH4bvFBpcS4aGUWFtgxvAxICVk
         Sn4531MPhMt255u7fBlRP36VQucU7yFsxwvF58lWY73xvACkGsrPIm4xH8eDMUXt4SqQ
         V84g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769210541; x=1769815341; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awyVbp3yIy8FIlTKbh8bMRHc/TOuIHyYVaLcQNHXtwY=;
        b=YzuAYMFCVOD/Geyrv0h4jKbhKz2BOKJBar9aS3Jj7hzldz1JB8EE3aGknQssyPA+vT
         UV2PMhK1h0b2jZNbI43SGfmE5QS7sqUxM4Xag/W8yrkDBrqxrG8Ddy2eLWQYmTfc4ten
         o7cPalGraZDjeavEzrz/3APXoSKoZOT3b7W/3K7tDM5A7P5YMLZ47NZTBMoZuiYPNcLr
         yyy5FpE+4gHySUHvr2YfjeFAylvBkxZkW8y10dI4tFlMjVuTkC/l7Al3cVbtgFFyl8Ge
         3AzurCSKzw7T0A8CBzpkBmB8O8x1U6ddX8EkY1Y3wYGzWaOnl4oo6p9ZzCeA1CbAMFQH
         tgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769210541; x=1769815341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=awyVbp3yIy8FIlTKbh8bMRHc/TOuIHyYVaLcQNHXtwY=;
        b=Tz5zaDr+0ntNqJBeH88S+R5fcK6MG3J8sQSZueODJ5OPPvsT2a2OkfrQTdUA6cnd0q
         HfiSneHRJSi9J9hWp9Vw0cZOrw65+HFishkosQyIIxdtAP9cQCPkhUOlOdGrM88EXcy+
         SC44nVH1ZIJsqYakoNG1Dl0Nw4A+FZOchdN151N//dNvHB+y+zvuYNAIZmF/8qCXeE/j
         qy3nrMplvPUS0IWzs0dcN3UBq6tb4NCci9Qo3piHBl+VdYiaUCEMaMsEPvbyp9lHVwSm
         Ot01nuDfS1FgohoFe4xl8h0Il+jwde+ItXDftY3l1km/GdTrCaLMpX3ypE1DBqHm7h8t
         4Ngg==
X-Gm-Message-State: AOJu0YwsbzUt0GweOv7CVa63SB0Zb0R8sIjUibnhpcvBRBOdL8wcFspE
	Ohj/cjPS9lt5W+CHcmifZGZUjg8O6wy8bSteHYLyyLIOwFIlr9Ickg/t83iyoy7/qPhOXAXMaBd
	n+Z2Tt3FT2wW0KCXWLZGhneQ32XV+3m7bHuKmmhEw
X-Gm-Gg: AZuq6aLOlTrFZZv5UK2vXtSo1vzcbCwThgtCqCiCueM89svb70R4Yx9uhT3WIPj4lzE
	fnra4Ndx+AEXqqc/veEkh1CrVMpndly/RYQjnov4Rrh0/CG2D2x1JxCxOdvbB6wWfnvF7lwYFns
	80VCfuSpJA69qVaZAzdUi19hSl4yKqFOPaZy6OnTCxKb43ZmME2We3zMkeyfeizVxGPQB4hVO7R
	v5m8XTsRJ7ecVQmRxtOw6q+QDJPVnqHNEBrBRyFcoerZKRIIrzYLv1ZQQpit7JF2KQE
X-Received: by 2002:a05:6402:14c1:b0:64b:4494:6417 with SMTP id
 4fb4d7f45d1cf-6585d61a7a3mr12263a12.6.1769210541091; Fri, 23 Jan 2026
 15:22:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260111202750.52992-1-ebiggers@kernel.org>
In-Reply-To: <20260111202750.52992-1-ebiggers@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 23 Jan 2026 15:21:44 -0800
X-Gm-Features: AZwV_Qjb6BDQZiyxEWFfKO47Uh-ACdS7H4LrRlPAY-cVKnLwGF9bc1Ogwhqvn1c
Message-ID: <CABCJKueV-qW59hOJTs_uQrTbqtN1O7O9-AfFCJ7Y=P9Updwqhg@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: switch to bio_advance_iter_single()
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 12:28=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> dm-verity doesn't support data blocks that span pages, and it sets
> dma_alignment accordingly.  As such, instead of using
> bio_advance_iter(), it can use the more lightweight function
> bio_advance_iter_single() to get the same result.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
