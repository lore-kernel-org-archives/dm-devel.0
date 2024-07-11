Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8B62F46
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 15:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720712150; cv=none; b=FN1QFW7pobQGKyRzFd/OrIEsp6qv2ye7I7KkYI7PwTNvjJA0LqQVsJ9AlP+DTTNifhyPYOYudLuyus15SHxGpkL/0yyUm/i7yxEragCIYWdf28pAVHR3EXyj7Y72h+8OhegAN4VrPaC6HkliXodkWW1CvML0MatrVkcv7sdAX0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720712150; c=relaxed/simple;
	bh=e30M/0pLB0Pb5/n/Jn92rPVgNxy4Cc/lo2lkEQf85cw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WUSvIHwTF9loPFOC9cLLt/x29vpyhsWF2aeI4PrgL+fLRT29jsHyWSBlyJY6DU8gwtnP6WsqF9v7iqJI/9QXIJ836/kOv9kn8u50g1hY4D8LYWHnSnz+bxJbE4awp8KftMyykvnlqgk4uOxgFvBvCxpJVotfV3KeTArKJSTDDvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eJ28JU2x; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eJ28JU2x"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58f9874aeb4so1442167a12.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 08:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720712146; x=1721316946; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e30M/0pLB0Pb5/n/Jn92rPVgNxy4Cc/lo2lkEQf85cw=;
        b=eJ28JU2xveL6vd/QTWgPYBZKGSXDvIGpZsUkKDpwopBJSN4uNOoIrS1f34C9OShN26
         PN7okVDSdEd38nikHUTsRrJXhYpaMGbjLn06XejQqVqIn73dk5u/k+B8ahp/DEuLNOdb
         gkntlGhr5y2qg/zJ6FEePPi1BIiu/f5kf6QO/yxQwXKPOqlkdy/KJFEd8AcuIqG7rxH5
         fL3uKm3XdgbejYAKAYW2NwkQExjJL30e5svjz/FhCIJ/UsquBxx8i7oVlEBgQNwJd9Sl
         HvQMmdvxxfEj8K/Wl5HevjfkO3WRhxsNFb6NDQhlylZnPDW57wEZKO/SIylHJsKBzkLn
         x/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720712146; x=1721316946;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e30M/0pLB0Pb5/n/Jn92rPVgNxy4Cc/lo2lkEQf85cw=;
        b=lRzjqKIw0ygEjqEM5+QKanVxK9JHh+CQ6lCcB9S1i0kwj3cW9OpXTeN7lnFqGCI17N
         8nH5WM4ZjDnxxRLg5xjpvvfIhFw0HK0+v7mWlLlWxqtxC7J4if70ZfwqqZHU2xT/xU35
         rqM1z5YbNwXBT7I3qOiEEKXruXGhT6TTDOTWC9H47Sk4iOBnMgcPbO9Zd/bo3EbVTNhR
         DAEOoKjjK6p3xNauITmYf1gqW8zdn2wTZLnq+rJIfMNiwBjokoOr/1spr6a3cHCY4N+y
         roQnWh+K80wfzXzg3yVgCaifcGY8OH1IHOZgqHpFLdMr6jkGkcE+IkmmGzzRHqM5zEZc
         Bc1g==
X-Forwarded-Encrypted: i=1; AJvYcCXV3NE4ynWIREG67xFwixml7H8kMEntxLZS5HKAl8QDx1UC/u2Ao3qS41LRHZ57ktXDRoSuBPRS0vMpj6QJiUcWP8kvRJD/V2o=
X-Gm-Message-State: AOJu0YxvrQCTSTcEak93hrkSY/PH8D29jynH1jClz6zoiq0cJnzEtpkZ
	KhKUPpxMnBLWs2aZH+ZgDY3xwtPAuTshk6RA4TxKrY7R6vwKK0CYsJxlEmHs0+zhpK/V9dxo6+X
	d
X-Google-Smtp-Source: AGHT+IEiQcvINt7eT8cOYHsuYhXZ+2dOnc3PAlUqadtPUjp8V0A3KIoK+JHI7pB5+45nYv4TVyL+WA==
X-Received: by 2002:a05:6402:2554:b0:58d:10a0:36f1 with SMTP id 4fb4d7f45d1cf-594bb580586mr6971837a12.23.1720712145998;
        Thu, 11 Jul 2024 08:35:45 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bd45a1b6sm3554276a12.60.2024.07.11.08.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jul 2024 08:35:45 -0700 (PDT)
Message-ID: <c15c7748657bc842c155cad49d68277dfc9335d4.camel@suse.com>
Subject: Re: [PATCH 42/44] llibmultipath: fix return code check for
 dm_is_suspended()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Thu, 11 Jul 2024 17:35:44 +0200
In-Reply-To: <Zo97Ud-n5oxTFl-N@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
	 <20240709213935.177028-43-mwilck@suse.com> <Zo97Ud-n5oxTFl-N@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-07-11 at 02:27 -0400, Benjamin Marzinski wrote:
> On Tue, Jul 09, 2024 at 11:39:33PM +0200, Martin Wilck wrote:
> > dm_is_suspended returns non-null if it failed to obtain the device
> > information. It's wrong to assume in this case that the device is
> > suspended.
>=20
> I'm kinda torn on this one. Sure we don't know if the device is
> suspended, and most likely if this failed, the device got removed.=C2=A0
> But
> on the other hand, it could have failed for another reason, and
> resuming
> a device that isn't suspended (or doesn't exist) causes no harm.

In theory, a resume operation might swap the live and inactive table.
But it practice, that can't happen. It's a corner case anyway.

I'll drop this one.

Martin

