Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A883988F2
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 09:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772616881; cv=none; b=pykCUYBkyjkr0g9hgOLkfHwu2PFDilJ/An6JKT8wDyQiQrx6wo1BnAMBhNYAGeb3d4uu6yaR6vIydzUr7I9S7X5j/DRSh+pFW+9zYDu/rhtXI9i/vwHR5tFHx00YbJNAncbM7pS3NQYHvgJ0x2TV6oFK6yKGiWWXqYFirjQCXGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772616881; c=relaxed/simple;
	bh=rrM1IpBf746jD26qdFKsiRca5rihxtuLdQ+6J+VrA2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhcfTpiZiaRQ+o0AyoVnpsk0YMcjcCfm9rFiFUkYbSBGZ9+zN+EdzRPiGaDxGrm1oaz7BkpXFvl3z8L09UuTmQaFUEothp5bbhh+iIyXkeuABUtOXzYHm66BF2nLSxPM9zoe5uGL2c8elLqHH8cxT05Kf/Zkn8ty1ozDzWeQ2lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I4vVA9Pt; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4vVA9Pt"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-439a90f194bso3017409f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 01:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772616878; x=1773221678; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4YO0VXFXt084fdhDYeMeN7Bd3IkQAwJbt0ykqWBxv7I=;
        b=I4vVA9PtoVJoh3wMFLFsuWXcaEaLNdKSDLl3/oadyWq5Q6OyfzBUkeW3Hmy1ebZKVy
         XzG2BnU/+qoMvFNN+Q3IaPeBYSxeBmErY9f0vj56ODVPOpPh8vREq7p0bfN31Ikr9Moc
         AGskEd6142E5PG67GLAR4UDcsclC8I50lXkA3eWllt93jWZsVzIz9/TtyPMMmUqjawXA
         LQ9IR/O7rlCf3Pca99IWOystnIEaVWDjIdtzhm89+SdwkPgzYlGb8siYhvyel47TR0IO
         MZxIA3pKpHG1aj0DdPF8NgZLLkwjgxAJ/6CwOt8ZWxQ7C970t0upmtigCypgVd0INwIt
         3U+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772616878; x=1773221678;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YO0VXFXt084fdhDYeMeN7Bd3IkQAwJbt0ykqWBxv7I=;
        b=YqBxG6LurTgZkhzPfz0kniHMcebFf7AFhVzuaXValxhau3E2o1kzEvK6ZDWVF7LP5d
         FLDyedlG3yfihnym6OHPfOeW+sCehGIYzqCjJCZxhM9HQAciJfNo/e2uEvXbxWHyehkd
         8l3O7rKYnbJ+RlS6DbYnFXdg83W0c+yrF7p8gKbn67whl40JE403BV08rVZ/P33Sw5uX
         LLdveFX8JdO3/fGYF7bH/m62H5H4x7eHLUpLwlk+3fEIHabgpWzdz1VCNosw3ae4voXL
         FvVesxw429KgYgzlK0GbDueAPdKSIGqNL9mS/pPAnW35Ubw9r7t5F+ITZt/ODI7COlAH
         Uz+A==
X-Forwarded-Encrypted: i=1; AJvYcCXbca+IZq4j9iojYKMMrGhc8L0arJkkng3K8tKXhP7DZ2tGvIZLpeBC9IqXU0/8A0OTTpjmOQpJrA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7VVv3A6dnmJMAEYp0SeWqAYwBumgKYnTAkrBz+EDfcgjUMQAf
	E/WzB2i42F5R6bIQ5kIP6FJEOFI8PxaGZJb6ncvXGtUKTTu6gdHqwuFe
X-Gm-Gg: ATEYQzyWHknjDI2yY2ddsUn1Z7coYzbpAoOyEWhEOJHfJEOeMgA6//gwCpYl8q+rLFY
	tNi7XC4amjjku1Cos04RZ43F7LTDhW0euu5tTbWkO3lEaBeBBFkJ00tEz5o+1RGsWcwsVE7+nnp
	/ZVPhGdjXhECgxwIYwZWAPnmF/B42ldtl7myLbbOM8AuyFJJEDGTNIeVoKeOyV5jFaLrUdH9TDW
	1F0/u6YtTqEiiG+S3KjxL+cg4gXH1EGnicTpHT6bMMHFXZW29TPADPdg5Yb6SWYyca4XOEPpKdk
	nThLvmhoAbYDLbUgFlKgWwasha1xju8Ob53MHMmhqkrJh6bWb6ve8l+hkYiiAYvhg1LSWMDtzdD
	dH2y9BFc9Els3aXLWBN73MofPaADClHAebnwm8BH9kH6WoZC3ix6wTNZjtYljv7eDl16kpczJlO
	kECsa8bEovCvr8oWbHq2YFX/3awAmI
X-Received: by 2002:a05:6000:2404:b0:439:b3d2:3765 with SMTP id ffacd0b85a97d-439c7f65004mr2644866f8f.1.1772616877965;
        Wed, 04 Mar 2026 01:34:37 -0800 (PST)
Received: from [192.168.1.116] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ae0e7abasm28206857f8f.23.2026.03.04.01.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 01:34:37 -0800 (PST)
Message-ID: <32e6883d-3818-4e7c-b626-4e4f609928a2@gmail.com>
Date: Wed, 4 Mar 2026 10:34:37 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/22] dm-verity: more FEC fixes and cleanups
To: Eric Biggers <ebiggers@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, dm-devel@lists.linux.dev,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
References: <20260206045942.52965-1-ebiggers@kernel.org>
 <CABCJKufKYMPcjiviWdGR=h5HVAmavwacsSdMNPQaaXeeL+GoFw@mail.gmail.com>
 <20260303201656.GE2846@sol> <690a74be-4707-4bf8-8c71-685dd8831664@gmail.com>
 <20260304090013.GA2211@sol>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260304090013.GA2211@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 10:00 AM, Eric Biggers wrote:
> On Wed, Mar 04, 2026 at 09:25:02AM +0100, Milan Broz wrote:

> Okay, it sounds like the verity-compat-test script isn't open for
> contributions then.  Would have been nice to know earlier, but thanks
> for letting me know now.  I'll plan to start some new tests for
> kselftests.

That's not what I said, just I would prefer adding new test without
the need to completely reformatting the test.

But IMO, kernel self tests _should_ cover it. It can do a lot of
more things there and can catch regressions earlier, as we usually
catch them once it appears in Fedora rawhide (as this is in our CI).

Milan

