Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06A5187FE6
	for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723481107; cv=none; b=bunJ6nCMYli2W+gl2PO172OLncsjqwItKNR9T26V/AwS5T54MKamZRKSK/OsrYfEt8T103ajv6v5nmxVdZwJBorU5+ph8nfDqkjB0e77ZIBAqmVkJUNEBfPK6OnPTeLN8g3Cj5VOgk5JjpbfNSLV1Glwb5J3Zm/q8iUc7DZX6Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723481107; c=relaxed/simple;
	bh=bOtFS4H1QSDOaybIBiLi+2b2cwYCpE+Lx58H7ijJo3A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sRrqRocz6elWbVVwkRIBO2qA8KKOh21P3urN5b7EljIaXYgk5+fThxtGsz5tfgJfDf/RZiS5/vJY7IokeB/bYctyxhtwu+mqTlsE2W5On1VhnE+fLnjc8nF/vyg9PVKfEoTLElMvAR1aeecd9Lq5IAaVot5el4H+i01sGfgOynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=daARLNyP; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="daARLNyP"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5b3fff87e6bso5117035a12.0
        for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 09:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723481096; x=1724085896; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bOtFS4H1QSDOaybIBiLi+2b2cwYCpE+Lx58H7ijJo3A=;
        b=daARLNyPStUhEaKxm8+dy+K6yeK6SnMZQjnH1XOKBTyCTLMr8uL1NqWmv3GaKYw5X3
         1xjiByZHsm2GEPrUReLuI4JFeJ3CGOqbZYomjB1fu1afkrPXMlyIZX+sEQWyOvlTsD3S
         rn1kb1ZuuYKu3swluXzckGMGa/9wacqUwJR9Jo3r4rwKrxvHOWZ8N6PKpOYQOxH+GTaV
         N6s8OtzCdEdEMsS7xdGNKtwE4FggGH8z93mMAHeFnthRqC7NSzzyzVXaB25+qy76bWq8
         ug0ETMvDBtWUJrRk8jYw7Du26eQn7WWhCdywnGZXXQ0qLn1vu41/RBKCip5C4DBInqLf
         oFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723481096; x=1724085896;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bOtFS4H1QSDOaybIBiLi+2b2cwYCpE+Lx58H7ijJo3A=;
        b=GSj4Z48le6G8etw3slO86WQwUhZOppAjUENgo3IW944bQCB4ufQLs3PZ/KQaonfOWa
         tmMrLDyCpZQnQ/jop2zR5yPghpen4nCyCp5N5JG9fLsNdL2rsO5HAQ4GD8vdFgVH3gJt
         ZgAuLDK7kUzJbS0TQWkK+w3PHD3WrBJ5h9G7XM9TGf8J10CkQfY0O4BFU+w003O3rpFQ
         SCxHG6qh6MiMZOO+/OuxpGqj7YGfizicFntbGzB0EGAgfv+fpHR0cRz+NCICfCQtsUcS
         kFEG9OLdXdNGtM9lEaTAu74FMw4YZGqtpyuEjg8GpvxsLkx2JvR4FrY3jYn8FyrbCwYF
         vgUg==
X-Forwarded-Encrypted: i=1; AJvYcCWEdk6sV/F1uA/gD1AoAzfoNuppxo+zD82NNkFDftJTWWBg6kxGMrmR5IwQRvH6ZFhRHGzbBeDd8Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxFS8u4oo9DfOrZ8WzYIT7LgbF9f7if8YtCxjC+B6INkvEc099Z
	qxdDFFDtyeqibT877YNRseTHIK+cUHXbwLja1gzwCuggcHdyU9LljocCB+OVkBA=
X-Google-Smtp-Source: AGHT+IELsTps64kElf6gQpyDQSO5PeplSIn/7SCDhlMcHelN2TQAXdrxdj5jaqybKXUYxnMnTtQI2w==
X-Received: by 2002:a05:6402:350f:b0:5a7:464a:ac7 with SMTP id 4fb4d7f45d1cf-5bd44c66c34mr613660a12.28.1723481095399;
        Mon, 12 Aug 2024 09:44:55 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bd1a602115sm2206470a12.96.2024.08.12.09.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 09:44:55 -0700 (PDT)
Message-ID: <89cc73933e550cb26a380296f2f84d81cb062ba0.camel@suse.com>
Subject: Re: [PATCH 00/41] multipath-tools: comply with C library reserved
 names
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Mon, 12 Aug 2024 18:44:54 +0200
In-Reply-To: <ZrZcgEz8dHRvyXk-@redhat.com>
References: <20240808152620.93965-1-mwilck@suse.com>
	 <ZrZcgEz8dHRvyXk-@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-08-09 at 14:14 -0400, Benjamin Marzinski wrote:
>=20
> Despite some small misgivings about renaming symbols (which quite
> possibly aren't being used by anyone) in our user-facing libraries,
> libpmathpersist and libmpathcmd, for the set:

As the functions are only renamed, we could use (weak) aliases here to
still provide the old function names if some caller requires them.
Would you prefer that?

We'd still be violating the glibc standards somewhat, but the
probability for an actual symbol name clash is very low, so I guess it
would be acceptable to do this in the name of backward compatibility.

Martin

