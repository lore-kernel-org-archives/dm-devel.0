Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F591292FB
	for <dm-devel@lists.linux.dev>; Thu,  4 Apr 2024 14:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712239595; cv=none; b=PkyoXXk4Y04z3X2ErfGHZXO79PsUip3FRXfqHfmx1UpBsRUb/v9kv9FolRE3fdLn1QH3kNFrIMKgIpR2uF2iHbGx9M9tURDFIHOhS7jjjU3pHM9tnR4S4/qxbEpN8MaI3XayvCOyOfSRzonL9e+MdOKvwfBTinu7dH2EBOj4/8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712239595; c=relaxed/simple;
	bh=EJkP4lA2rO/YyN0oqBK+/4TAYbayUUGRoNt1XZHeHr0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GFgbu44yT8lz+bGievozn8wBdOZ5+uoOmU9IVGiuMMksituRranUX0IhYd8SdZZ5XLvl/HDxFH6tSfXlORQGhLmeFpXU9DU2lppdCCXj2b08oVWmMRCxXtxyUEzeB+bfl/fMcua5MtyY76k1yzNnyw0qjonqzf9SHmbIWDZSp/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OSAX4ymi; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OSAX4ymi"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-34339f01cd2so755944f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 04 Apr 2024 07:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712239591; x=1712844391; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZQ7OyrvYK1Lihg8SsdIxeHkew/uZZIQnOe+Lu22S40w=;
        b=OSAX4ymiyiUUWnFMJSUEV4hc6dQIYs177PsE6IhPFY/oEjKaot9DL9OWEcMr7x5ex1
         N9pNoW5umYqlQgezRnhsK7eB0gy5kdGolfLCWVLodVLWln4rJr4Y8nmrK1gcQaUVLxg7
         rzafsjByZuRZCytkEvzmxeo74rzTUUPIA916xHi0ru5Ze+x5Ei9H+DzN9m+SQTWMs1CM
         0QpA2XvgvgrbDL+XRzYMqk+9UAIR8gmJRuwmSZ0eWynBrdCxYQyHzatzs/5orkJPCDw6
         J9O9iNcZhAHr8LLUjnGweCSe4RdSeQQkHdGyqNKpqoNxn/MjG9dhwF6HKWpEcidqKVUt
         rPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712239591; x=1712844391;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ7OyrvYK1Lihg8SsdIxeHkew/uZZIQnOe+Lu22S40w=;
        b=Ovo5UhUda38uYUiDL+nLXZFWeEKLuGd6VVCv0AbO/BYVsR0ZTUeTHf49gYzMS7RUwW
         t48Px3FUdUyFzJqyHey8rwENZsnL5jDr86Uumtv/e4S0Yx88IzXWD8n34/Ys9/+a6XIh
         r+glpHVMQxft0brawtNOnk5XBZvaPces7rndmEt2st3KESekcI5Mm2jBAtYy19crPjjY
         9F4iCPxd/EyWYGH8AS1CW5D2NNx2ymobeNVOjT8pP7tI3EM4RvkQSI+XyjbWPb+0t2ol
         6rqBrG4n+eC+NaOHE91q9DNtCqU5Fi8Phiqy7mCThPvi+iyGGNR7jYLfTFawxSt/6Sar
         NYeg==
X-Forwarded-Encrypted: i=1; AJvYcCWzNv+QVtMhUoBCC+MAcs7dZTZydSpnHs6EVi/gQsD1mYwoc6Wfa+ErPa7f5/9S3B/UhozOIl+jJKGvk5wBBeBh9xriXyGOL3o=
X-Gm-Message-State: AOJu0YwK4dMbFdZqv0ylx7W1dCW7zavMkG7nyvxHK+mCFZ/ZQNvSKpHV
	uL2p7wFHAIxa9uOeqGSPmM+WzT+rnvHtuvrPxFeBTJMokQ4SxW6dXYJRdgBZZl8=
X-Google-Smtp-Source: AGHT+IFc8+dV/Qb4TMWNK0gNkCmUpwaqKvOVjWSAqMZC7EW6E7o/ApHXhVH7/EaGw57/qLUyirajxA==
X-Received: by 2002:adf:db46:0:b0:343:7884:fb52 with SMTP id f6-20020adfdb46000000b003437884fb52mr2204898wrj.50.1712239591638;
        Thu, 04 Apr 2024 07:06:31 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-084-058-019-253.084.058.pools.vodafone-ip.de. [84.58.19.253])
        by smtp.gmail.com with ESMTPSA id bu30-20020a056000079e00b0034399250045sm4573789wrb.77.2024.04.04.07.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 07:06:31 -0700 (PDT)
Message-ID: <b62223c91d71c2c8e82b9ee05e490c315f74fe10.camel@suse.com>
Subject: Re: [PATCH 01/11] 11-dm-mpath.rules: don't set MPATH_DEVICE_READY=0
 for suspended devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>
Date: Thu, 04 Apr 2024 16:06:30 +0200
In-Reply-To: <ZgNDmVxgiQcnQ2o1@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
	 <20240324211301.7200-2-mwilck@suse.com>
	 <ZgNDmVxgiQcnQ2o1@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-03-26 at 17:52 -0400, Benjamin Marzinski wrote:
> On Sun, Mar 24, 2024 at 10:12:51PM +0100, Martin Wilck wrote:
> > MPATH_DEVICE_READY is an internal property, not to be consumed by
> > later rules. It means that there are no usable paths. Being
> > suspended
> > is a different, independent property of a map.
> >=20
> > Don't set MPATH_DEVICE_READY=3D0 for suspended devices.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0multipath/11-dm-mpath.rules.in | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-
> > mpath.rules.in
> > index d9585ab..3f23108 100644
> > --- a/multipath/11-dm-mpath.rules.in
> > +++ b/multipath/11-dm-mpath.rules.in
> > @@ -100,7 +100,7 @@ ENV{MPATH_DEVICE_READY}=3D=3D"0", \
> > =C2=A0# we have to postpone the activation until the next event.
> > =C2=A0ENV{MPATH_DEVICE_READY}=3D=3D"0", GOTO=3D"dont_activate"
> > =C2=A0ENV{.MPATH_DEVICE_READY_OLD}!=3D"0", GOTO=3D"dont_activate"
> > -ENV{DM_SUSPENDED}=3D=3D"1", ENV{MPATH_DEVICE_READY}=3D"0",
> > GOTO=3D"dont_activate"
> > +ENV{DM_SUSPENDED}=3D=3D"1", GOTO=3D"dont_activate"
>=20
> I need to clarify this one.=C2=A0 I thought that the point of setting
> ENV{MPATH_DEVICE_READY} to "0" here was that
> ENV{.MPATH_DEVICE_READY_OLD} must be "0" and ENV{MPATH_DEVICE_READY}
> must be "1" here, so we want to set DM_ACTIVATE. Unfortunately, the
> device is suspended, so we want to postpone the activation till the
> next
> event, like the command above this codeblock says.=C2=A0 To do that, we
> set
> ENV{MPATH_DEVICE_READY} back to "0", so that on the next event,
> ENV{.MPATH_DEVICE_READY_OLD} will be "0".
>=20
> Is that not necessary for some reason? Perhaps because we're going to
> get an actual DM generated event when we resume, so DM_ACTIVATE will
> already be set when we get the next event where DM_SUSPENDED !=3D "1".
> If that's the case we should probably change the comment over this
> block.=20

You are right. We must set  ENV{MPATH_DEVICE_READY}=3D"0" here to
remember the state until the next event is received.

Thanks for catching this.

Martin

