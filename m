Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43BC1DAC4A
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 16:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466396; cv=none; b=nupt/az00c3Y6+aAbNyQqh4btNa8D1Y4Sykt9EzzMzEVRq8kj5SuXhAKTLAPICDUQRbr10IcgvFNc4BeU7rRNqjtsVWU6oJAuVaphvugsaQF6U1gLFCQuMK462C7EyF22T1FpNyrkwsbU14YcIS9XkWcoSIgazD0l5YfIHBhayc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466396; c=relaxed/simple;
	bh=mg/hyM2OrzvDarMrKyKxh0eVKPfI4Us2w6EiBm398ns=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aW1nk0rSkoPqLXl267JsMovBMIZH9T3hIrKJdiwxZ1gzR89yVkP7QdvWH7B2Zm0c4vydrWgW5sDqDu/NuYAK+IN8vPP+d390pLjZOwAuOM1gWFXyiQRp8JEmmaCGuWUhW83+WnLoJmRqc74UCj3wXdRqKZ7Em7ktD9tqu6NSCOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PxHisYu9; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PxHisYu9"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a86a37208b2so817802066b.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 09:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725466393; x=1726071193; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mg/hyM2OrzvDarMrKyKxh0eVKPfI4Us2w6EiBm398ns=;
        b=PxHisYu9ZoSP8XYZoDB/iLw0mXd7HDQoaorATXARBQ3x1vu7PR6wARsEju3ebnBaJv
         N57WjVX+oPZwvwOU13bakeEw5SZFQEt2m4Ttn/kMopYWoyBoIIgVxLjP5b22ovmf4fkH
         sbaYWkk0SY+kIobi1cdErMdQIgC7SblkKnveTQxI92KwzjqyhOY0bQhrdAVz/sx3UUxD
         cwofAKW1voD1UPNnEBfdnjkmt/t//FgderRXX9X7+TukvgFSS7bYrDwOdGXXAjiPDYXY
         7efjvisb+L87OFuDj+GWvEvRphp9/1BuJ0U0R4FeojsBMQ/O2zQeStJnB89OP5dRf/H9
         duzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725466393; x=1726071193;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mg/hyM2OrzvDarMrKyKxh0eVKPfI4Us2w6EiBm398ns=;
        b=JLmhF/z+w/yz5k6ZZLnFYTvD2r4jYwB/+piaTxTkw9hVapW+ah08yDPafMRTvjMVtG
         DGMPmJEw8BEyBIoGezNqYl0eU9J3OE8RhA05F7vfCRe9bkwInqzppG3KAqvxULCVv4NK
         wswnD8kOmVEdWc1dzV6ItONqoJEcwwxKhxR0gFKprrLYmYlrYAl3CJ5ZRgLU8dtPHzkt
         Vvxt/ctTZ2Gjpht+LNBsPH5KO0YyoQWs4Qqp4Pl70kbpdoXAWf1LNHF75R9xXGl9cm7e
         U1AskZPhEOiQZXSMflnBxMrXFnYllQ8GsZsUNOo4QIlmyM1nW5TaqUU7Vm9hTtH3hnhA
         Cygg==
X-Gm-Message-State: AOJu0YzYeHbNaFK/S88fOJWwRvMuRN7vef1nR6YKODR8/p5z/Xl2xAw3
	dlM3C5HxWbZT/NUAzgnkhWEU2cl9W1h0t51ytofBQaUj3H2rANaI+0X0IoBAeC8=
X-Google-Smtp-Source: AGHT+IGg/HB7xslt9FZENL5+Cx2lyBdokQGgHrNQex+J5I+AcDB1S6dg2wEGAwSyY7pUp33uRS1oeQ==
X-Received: by 2002:a17:907:9486:b0:a86:b042:585a with SMTP id a640c23a62f3a-a897fad5108mr1699427466b.57.1725466393252;
        Wed, 04 Sep 2024 09:13:13 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623a9234sm8966866b.156.2024.09.04.09.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 09:13:13 -0700 (PDT)
Message-ID: <ca3b1c5ef62e1c2d2528e5bd997ef23c1bb5a4f6.camel@suse.com>
Subject: Re: [PATCH 01/15] libmultipath: store checker_check() result in
 checker struct
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 18:13:12 +0200
In-Reply-To: <20240828221757.4060548-2-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> checker_check() is now a void function that stores the path state in
> the checker struct. It can be retrieved later using
> checker_get_state().
> Right now, this is called immediately after checker_check(), but in
> the future, it can be deferred to another time.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

