Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DE4129EC8
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LwSzLTPy"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3365d38dce2so2020315f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 06:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1702909230; x=1703514030; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BFJuTgWOrpQsVYT+34Qc4UFWRFCTO2KPKKtBLQezqWQ=;
        b=LwSzLTPyLUDyE9mPJNm/54GMecH2MArhqkBnvEi5caVilPw57J2j68Ma6MsyZcfErv
         LblPM29Hkk2pNNCyX4B7+mrsdFCSRkwYXUBvTnpby3MXt2ONn0tmLjaVulDwhR3McDTR
         Y4IjEinw5m2LgCq9eWA+xp4yqCgvucPm299OsPq6Z24Y33p9zn1Nlhkh/xgLs6DIiO+a
         iuEC4KArUA/Cyf9O8VB72hqctCK1jMVzpOE1dC7LwlLcmDSa4p0c+22VGSNjjWkuIj8U
         Oezs/MNB5ufGlYWydUMmus3PmpuZS8EAETI4haheLOfu346sPiH7bPnoPKlZ01DAp3Zq
         +k2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702909230; x=1703514030;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BFJuTgWOrpQsVYT+34Qc4UFWRFCTO2KPKKtBLQezqWQ=;
        b=T6VPfaljcyWCwIJwzLUjxChgG0GRyE6FIPUrV4t3+OGhwRXpIfYG1XjpQQVuIEWD4q
         guiDaCXHSnxPz9bngMDQA7GvXQ/49/mwz9u2lNUTBmxqQfAW0XSV8yAj8hf+4zeCSVVF
         MciM95RxzGvpquItYH7XPnMQTadjPPlzMlL1b1AUlI6wlUxUU/935xLj8xQR1qud+/gr
         6iN4Uag379TAcTXtNdLL1MBjqGFcyfbXbnsTkc8gjveMkdTVWkBFIDv96Xh81IqJE1+J
         3UILdCmUpnlCDIcbca50hnsz3GP4hRaIzyaNPzfWR+nWfr/W2+jZFrmWEucNwUacA6nf
         wx8Q==
X-Gm-Message-State: AOJu0Yz3cnA4kkWc/xglPu4KOnmUPbaXZ7gX6Ss2bp4enUwPtsSQoW3E
	Tvb/CRZT+sGXfkdonSLS+WNnrg==
X-Google-Smtp-Source: AGHT+IEMuflt5ssRahBy+EUGYbgMQenaMG8SbtUUsIEGGXtaOsPphiigB0nKwOjRLZOCV6Xp9JQ8iA==
X-Received: by 2002:a05:6000:1813:b0:336:6913:3e1 with SMTP id m19-20020a056000181300b00336691303e1mr456351wrh.109.1702909230042;
        Mon, 18 Dec 2023 06:20:30 -0800 (PST)
Received: from apollon.fritz.box (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id a14-20020adff7ce000000b00336445e8a4fsm13329665wrq.3.2023.12.18.06.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 06:20:29 -0800 (PST)
Message-ID: <82320384fc7ebfeb55fb1a34c420245f8e520467.camel@suse.com>
Subject: Re: [PATCH 12/16] multipathd: make cli_handlers check for paths by
 dev and devt
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
	development <dm-devel@lists.linux.dev>
Date: Mon, 18 Dec 2023 15:20:28 +0100
In-Reply-To: <ZX0YXyw919T1UAmY@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
	 <20231212235320.440336-13-bmarzins@redhat.com>
	 <9777471825fdc0c864a758694925be284a735190.camel@suse.com>
	 <ZX0YXyw919T1UAmY@bmarzins-01.fast.rdu2.eng.redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2023-12-15 at 22:24 -0500, Benjamin Marzinski wrote:
> On Thu, Dec 14, 2023 at 06:17:18PM +0100, Martin Wilck wrote:
> > On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> > > Some of the client handlers checked for paths by both dev and
> > > devt,
> > > but
> > > not all. Also, many of the client handlers don't print anything
> > > if
> > > they
> > > failed to find a path. Make all the client handlers which work on
> > > path
> > > devices use a new function, find_path_by_str(), which will try
> > > both
> > > methods to find a path, and can print out an error message if
> > > none is
> > > found.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =C2=A0multipathd/cli_handlers.c | 40 ++++++++++++++++++++------------=
-
> > > ----
> > > --
> > > =C2=A01 file changed, 21 insertions(+), 19 deletions(-)
> > >=20
> > > diff --git a/multipathd/cli_handlers.c
> > > b/multipathd/cli_handlers.c
> > > index 063a771f..7f550030 100644
> > > --- a/multipathd/cli_handlers.c
> > > +++ b/multipathd/cli_handlers.c
> > > @@ -33,6 +33,20 @@
> > > =C2=A0#include "cli_handlers.h"
> > > =C2=A0#include "devmapper.h"
> > > =C2=A0
> > > +static struct path *
> > > +find_path_by_str(const struct _vector *pathvec, const char *str,
> > > +		=C2=A0 const char *action_str)
> > > +{
> > > +	struct path *pp;
> > > +
> > > +	if (!(pp =3D find_path_by_dev(pathvec, str)))
> > > +		pp =3D find_path_by_devt(pathvec, str);
> >=20
> > I wonder if devt should be tried first. It doesn't make a real
> > difference because no real-world devices will have major:minor
> > names,
> > and the callers in the old code did it the other way around, too;
> > but
> > it would feel more correct to me.
>=20
> I'm fine with switching the order. Also, I assume you'd like the log
> level to be set to 2, right?

Yes.

Regards
Martin


