Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5688B1BC41
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721059640; cv=none; b=uabz2wsKeAuBXWQJzlrNr1ag9Wem11+XKNpbp0a8+0YYQVeNiLrro0/pmoyFElPyXSzDCPu5hBk5j6VYifoNj6EP/r01PxKXPAguxHQp8hXSll/jF2YwHPqGkWoCymBHuYcoZLkwOgXaZosfXIjOFkbEJMC9zDdGJANd435K258=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721059640; c=relaxed/simple;
	bh=PpYKIASvwyk5YtGFij/7OmekfeHDHVWM6q8SOYjf600=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n5ioM3XaS6o4dh4BkitK1UtC8n6puzrSxAEk10aHncNB3mLAX6t4mviDejZEHSbGCMngXRM+TBmp/1ca7u1C4zbQZOns+Dq+PsBYH2Xh/LquF/NE8//p/L50kCJ65MhqX/InskD9oQNUVfD828AUxAG5/rJ6JCiKRmXasrkZ040=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HMU7LMtl; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HMU7LMtl"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52ea2ce7abaso7609795e87.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 09:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721059636; x=1721664436; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yGVOEZh85ZvJpRwJnS8rOhD7zGxol4RPByzJhovuwvk=;
        b=HMU7LMtltF92PFFqVKs0IJoxH3ZF0Ua7TKbI0CLNCTOv6MDyN5xKFLfEzWR9MwZCJ1
         HL6zaXn84nsyQ5ngQF0a8JdvPrrvi0NoZHFBdMLjffOfdIgeKU6XCmRJRmEh7fimMd/v
         tLnxFiJjcdi7cdPJ5lGw8lu7xj4x26By1hXI3yv+BvDUo9KYvF0T2YAhfONxKXweqM8i
         343Hepr0HBDDVqmv3E+yQQ3TxBnG9PSYYCL0u3R4Mb9262Pi2UUKXFS9el3E+QQWGaGN
         y2KULDjcHsfx/9TlB0P/5SzUr7YWPj2Nx5Xrgd2eLTo+YqNA3PEZGk+tKb9ri4v1hyio
         Udxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721059636; x=1721664436;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGVOEZh85ZvJpRwJnS8rOhD7zGxol4RPByzJhovuwvk=;
        b=eGpewpg8SwZjMFPqZUUIpinFM+Vm/DINW3lNPRr6A5LIUi12mFAOt431dqWo4aO06M
         ZYhlRRxQ3QxxPqe4TM3QxKUSzMhAVAfh7e94pWfzVAaMi9pd2Mw3DbDzpYoWPeEGItqu
         Vp1j/6r5wMTwx8diKt+aIU7y0PtBndCn/4EmgsFtqNnC4C6cWF60/WF/16nhz5fjd96P
         AdW0Miz3ZyjUlcGraBbCzjbhWfDqwkPoNuziK4wVlOsEq0AJs0Wn5QYXzffbKZCDUHdu
         JCdaaATwtY+AYkYefU95VGqdE0v98m/Mt7cpqoyYdjIL9nksbxmWr19Ph6qALRvc2hL8
         NP2Q==
X-Gm-Message-State: AOJu0YyDYcq72cOeg6kmTO83j2A0/zsdu4Db5IPSaH3ZPvzLifyhsFJ9
	IBwyVWqtlFPvFEG6TC7cLYLUUmUv787hHVJ2bmhj+TnMe4Apd7ZJDFY8AJiTnVQ=
X-Google-Smtp-Source: AGHT+IHCfCCbqJee3Q1SsfVKEcBLFvMfvtA6sgkCic4p4hN7V6v4y9ichRwNc5OlRJjLkcVS12pe2Q==
X-Received: by 2002:a19:6b19:0:b0:52e:9f43:c13f with SMTP id 2adb3069b0e04-52eb9990cecmr11259855e87.7.1721059636138;
        Mon, 15 Jul 2024 09:07:16 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f2d7489sm126765735e9.44.2024.07.15.09.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 09:07:15 -0700 (PDT)
Message-ID: <cf858fbc5265e367b85dcd74aff74d771a42f2c9.camel@suse.com>
Subject: Re: [PATCH 04/22] multipathd: refactor path state getting code into
 a helper
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 18:07:15 +0200
In-Reply-To: <5c5bc1755a4a1767ef431dfee9eae30811c945e8.camel@suse.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-5-bmarzins@redhat.com>
	 <5c5bc1755a4a1767ef431dfee9eae30811c945e8.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-07-15 at 17:19 +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > =C2=A0		return 1;
>=20
> Nit: Remove braces here?

Ok, you did this later on.

Reviewed-by: Martin Wilck <mwilck@suse.com>

