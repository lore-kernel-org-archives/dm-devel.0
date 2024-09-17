Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D359E158D6A
	for <dm-devel@lists.linux.dev>; Tue, 17 Sep 2024 10:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726568007; cv=none; b=d9bRGHmM/ISC6GrN4uW03bZICk8emHRD2/Elsq9z1t+JeceKAjsK335hGpbAQ3YH2m4klTMZFrlw38jPs1XcxBhlJ8lGmPHUsGRzLoUVn6274/3mxZhKVG1jBaPVm8Z8cmc2To1l0O0BaUDgRigwKfZ30GRNhB3jV8ZUAkWaFEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726568007; c=relaxed/simple;
	bh=gSYdeUi/YBVEjCvgiBCBlPyuDslw/HMK1yqSVOAfYTg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TaAZ/xmbrxCMRq8CLqX7J5SXj1WImykDi0D5DU4vajMR3XqDRdmBoCIfI0GmITM3fxwwfKnTdWnw890bL0Ey9/MpumjcRIpSxd30deFkjxTBrdVaHaVDJCSuCWDlBUFK4cDsv+Vxyg5ERskEqX98WhunrpUByhhFUu1fxoto2BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EGoMAS9o; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EGoMAS9o"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c26311c6f0so7594829a12.3
        for <dm-devel@lists.linux.dev>; Tue, 17 Sep 2024 03:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726568004; x=1727172804; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gSYdeUi/YBVEjCvgiBCBlPyuDslw/HMK1yqSVOAfYTg=;
        b=EGoMAS9oougSJ3+VF+K80qq/4StzKBtvcYf8TiE+tOjsTRrDJhTVaUyOeGYfzG90nY
         J9DeV3hK5swCXxDcXS6gWcjX7ze275Fwe2/wgYm6w0sHmjEoA8iD2l/tS/hm4zifpW1U
         7uKREgwmh21CMJzSnpg/FRm42uLZgvqcACeGANvZrcqHTFSCIlKhuJQSBQJ2pOuAXh09
         czFjI/Yt6SxRvQ28IzHQ6qP6OXCgfombXz3FIPQJnvYJwuR+sDjQIfUYN2IC1NRZVuev
         fx4xE99RCMTYMLvGBsnsI61CSQGHcBxjFiq3V9l7nwspw4NVQCIqhHWf2cz7V05W4eBe
         cSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726568004; x=1727172804;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gSYdeUi/YBVEjCvgiBCBlPyuDslw/HMK1yqSVOAfYTg=;
        b=w33Vqc2zfF0ydqa9acoAdAAtOMQQcRjYAIAIu+sFXiEK6iYfl42c8BXOyThz4za/Ms
         yvC+1S39JJIdqgzJ4GljIE7IOW8S/IGdly2+PnbC2uUlOgD/cTUBafhic3FNDzWIYzv3
         L3b/Xazir7oRzG9S/Gd5uSSa992Hm81EVs/hETp+6z+icWwPR+c9NVLlN8fmSI7Pe6mo
         6QLWX4B12gcj7uyYEmpKvBdw2nYW/KXjVskU+BPzj31qf0b4kZIUc08zj+iRKM7pEBxt
         P9ZHJplZZLKW7Rine1yimbfWVjnqrCH9aeFkL+ae7TR5SxlWzS7GVqOp/HZ6hGx4m2CD
         9sGA==
X-Forwarded-Encrypted: i=1; AJvYcCWVyipgKvURXOx95KsMhKvB8jcgSaBMYEyoDaeq4w0y8QgOmAlOLFmJuBnbj7neNeOEVYjf/7vljg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyZ4sQoUT+CPxKFejne9RSrE1hoe6nh7REym8MSOyqBb0p/3kYk
	k++HI1aP9HrbjC8oBddTaXSfSlV7MayiQrPXQ5kOCKld3FMS8ciO9HwqszeDd2c=
X-Google-Smtp-Source: AGHT+IHvpXh4I42WWOweyiKhCi2fhLDbzrIQfwou2zko8cSyEkQrXQ5But8CvEF8ckxrIsDnIkKg8A==
X-Received: by 2002:a17:906:f5a9:b0:a86:7924:11bd with SMTP id a640c23a62f3a-a90296178c9mr2027090366b.41.1726568003787;
        Tue, 17 Sep 2024 03:13:23 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610f44fasm424348566b.79.2024.09.17.03.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2024 03:13:23 -0700 (PDT)
Message-ID: <0434b3eabc805b0dd54a8d2ac2e537cc43116801.camel@suse.com>
Subject: Re: [PATCH v2 00/22] Yet Another path checker refactor
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 17 Sep 2024 12:13:22 +0200
In-Reply-To: <ZuifCU3K3sYojQQC@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
	 <c8ac1916a0595aa74fa8c63cd62648d89802a38c.camel@suse.com>
	 <ZuifCU3K3sYojQQC@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-09-16 at 17:11 -0400, Benjamin Marzinski wrote:
>=20
> I'm not sure what this is and I've been entirely unable to reproduce
> it
> using Fedora 40 and clang 18.1.8 (the current f40 version of clang).
> It
> seems pretty obvious that I has nothing to do with my patchset. It
> looks like it's related to the renaming open() issues. Given the
>=20
> "%s() has remaining non-returned values."
>=20
> and
>=20
> "__wrap___open64_2: '%s' parameter still has values that haven't been
> checked."
>=20
> messages, I'm guessing something other than __open64_2() was called.
> But
> like I said, I can't reproduce this.

OK, I'll double check. I don't recall seeing this before your patch
set, but that can have multiple reasons.

Martin

