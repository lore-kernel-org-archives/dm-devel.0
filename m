Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E90C29D270
	for <dm-devel@lists.linux.dev>; Fri, 26 Sep 2025 12:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758889974; cv=none; b=GXekZVpEIQPwuF6PyPSNv/Xue5HqmnNjM9Pr1oHNvqmtnrcnS+nV/moWXpShM7tw/h9hgY21TGusyU0ZPURRHgwhIQsfc80jR1Ojr8K1cUCkJ1iya5ugiB4bd7cAEXKUd4ucAelRI+WbwpqL28wiiphAI4p3elbQRtbjE+1QG3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758889974; c=relaxed/simple;
	bh=ILwMm1oGmErz+d2QObbkDyZYoyT21zSVk48TOORt+BE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LZTmIPOARWLbvr91yD6BGEL9ffaGx0zW34tZcEfAKaUbHfUsm9vYsbJXdu0IDsjmxkvLp7uqXqdD2Lsumf+rdIdlcpoqruKr1uS7ICXEQ7fqoKEeI9puUCTyBLdDE0ANbEqYF0WInKPvgHcxQYqtIxZiKUG2bvoghb/pFx/9I3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Am/YMYIW; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Am/YMYIW"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-414f48bd785so492731f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 26 Sep 2025 05:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758889970; x=1759494770; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vqrqrNgw+b2+kTjfeg4T5C49c4JpOMVd+qasp/iSoZU=;
        b=Am/YMYIWE2vgjIUzLYopZDw+aTxsFHm1wkGPpQ8ydaHK29Pny4xpOhMUVJ1xMMbJpM
         KwCO29pGeHc8AzUfXC6Z4rQPKdOx76pySMXbWWqQS8MsDq1NGBX3oEkXXWXCjFa0OZfM
         6BxGu2F0jJxSPjhFmQ3I29Xyb/rnm6jrOQRTLPrjt77NWaxV5mTXZw4+5hYkT4RUFLYs
         8V54o54JEl7OBt2o70bdHr++pR+15FRYkYwvXgC74p1iJHenm7ySAST3WzGnE7ZaK0Av
         MsF/iD6Yq1GZW+bGjJW4bTgII1UERxgyfth5uGucJccB5TpiHaqq8eHshumyHj5x+lKD
         0rKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758889970; x=1759494770;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vqrqrNgw+b2+kTjfeg4T5C49c4JpOMVd+qasp/iSoZU=;
        b=qyLl13XavXnfuqwQm9QWMZxa3jcOHgehAPruo9o76WZge3Q21Ljw9ZChfI8VIAsuVY
         Vn/fjIm7X3WLMvoCoBePUPBDMLh0BV0QKiBQTRXkH64x2/1vVCUZ0vHSlJ44cNwh8Zha
         i8AqWPzKrBu9ZM/pweqtHhUzfGj9b0ep+GuIB23a4BAgwkxNzOk0Udnh8IU8uGrh0fDc
         6pXMgUqMyx/7MPzT4JKydUVY28/vpxiSteb7MWdsZnkZnenUdJnhfEt8lStnjrH+2pmh
         lMhNvkBnakKtXI+krrljen8A02o4v8cWKnMZ3/5Btq8SeCaAQBCzk4pNtyCgv5KsnlwS
         zGpg==
X-Forwarded-Encrypted: i=1; AJvYcCXnyuDqyOQkzLcIHg6+Ac33b8r3hLUXnsNXiL0AYNae6K4SBPUIcXRz9vI00Dw1TYdyOC5jtb3rDQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxaNybRXJkKidL72XU6U0/cyK8Wq/OYMc+6oZhUu5TxIXtFQw3L
	+Pc0g1Udu3uMNKtdzv+Iv/K93lN+oRgqqKqxyh5HSLX4lYgIbxlUTiigYxwaIhlRC0k=
X-Gm-Gg: ASbGnctHjNgvDSsJJrXPFH8qfQthDRakwwXd3JaSGsHCTnyRZ5FPEczvy7hOBwr3z4h
	DTgO0vtPjtPAKp9/FJbFCyl3L1L1PGBtI5ubSSxMZ/d9X00pd+KiJGblC69Hp2IJBkn+WWLFuc8
	rc8VycFNbft77XKV/MpUCf0GCoBQJ4vv4gFSxrX3jmqdske0wfXsExYO+0EyyNbxTtNPwLZjMbp
	Nn7FgL7fHBlttmdvYWSen684mBA+aS679gowO5jjlLulMaocvYXUMNJyAU4KY4rsBMR1jbNcU5j
	QfyhlSOC5w1yUWkQZ/TydxNYsKNWeFYCPFtDjgRMQaB1Z9pgS67J4UBNNtnDqbVSNIIaxAxM+/W
	9Uc9ub+6JkI2dM1GTvOyxy02Daap9qOixfCC9YAs0rjJOnssKH2lFJXMzElk9V57GLI4WDRM29S
	3oVy1ZRdfhkRu2sz0JCQdB47LJrxe1kdxK5bGLMJfV9ci5hyKhMV/v/b+K+PEC3IRKqZwQeFtpv
	bSCq18=
X-Google-Smtp-Source: AGHT+IFtqp3cETjUIzH6GonB8RmrVFTkHUqNkphNAjePZEuYnNfQRSQQIKXsa0chvvkxk+Pbb4nHSQ==
X-Received: by 2002:a05:6000:26c9:b0:3ee:15c6:9a6b with SMTP id ffacd0b85a97d-40e48a5697amr7147295f8f.48.1758889970133;
        Fri, 26 Sep 2025 05:32:50 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33b9e7c6sm73304095e9.1.2025.09.26.05.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 05:32:49 -0700 (PDT)
Message-ID: <87654ca4125153880c986cde4740112bf6260c63.camel@suse.com>
Subject: Re: [PATCH 3/4] libmpathpersist: use check_holding_reservation in
 mpath_prout_rel
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Fri, 26 Sep 2025 14:32:49 +0200
In-Reply-To: <aNWaMA1vw5BK-Wzz@redhat.com>
References: <20250923221252.1411687-1-bmarzins@redhat.com>
	 <20250923221252.1411687-4-bmarzins@redhat.com>
	 <bc551cc3e2bf5df5b9ed823f89259f2df3aea64b.camel@suse.com>
	 <aNWaMA1vw5BK-Wzz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-09-25 at 15:38 -0400, Benjamin Marzinski wrote:
> On Wed, Sep 24, 2025 at 08:37:36PM +0200, Martin Wilck wrote:
> > On Tue, 2025-09-23 at 18:12 -0400, Benjamin Marzinski wrote:
> > > -
> > > -	num =3D
> > > resp.prin_descriptor.prin_readresv.additional_length /
> > > 8;
> > > -	if (num =3D=3D 0){
> > > -		condlog (2, "%s: Path holding reservation is
> > > released.", mpp->wwid);
> > > -		return MPATH_PR_SUCCESS;
> > > -	}
> > > -	if (!get_be64(mpp->reservation_key) ||
> > > -	=C2=A0=C2=A0=C2=A0 memcmp(&mpp->reservation_key,
> > > resp.prin_descriptor.prin_readresv.key, 8)) {
> > > +	if (!check_holding_reservation(mpp, &res_type)) {
> >=20
> > The old code didn't call check_prhold() while
> > check_holding_reservation() does.
> >=20
> > Is it possible that get_prhold() would return a "false negative"
> > and
> > thus we'd wrongly skip releasing the reservation?
>=20
> At the point where we check this, we've already done the RELEASE and
> gotten a success, but the reservation is still held. This means that
> either an unavailable path on this device is holding it, or another
> device that is using the same key is holding it. These checks are to
> determine whether or not we PREEMPT the key to force-clear the
> reservation. What we are adding here is a requirement that multipathd
> says we are holding the reservation.=20
>=20
> I'm not sure how we would get a false negative. When multipathd first
> starts tracking a device (when it starts up, creates a new device, or
> is
> reconfigured) it assumes that there aren't multiple devices holding
> the
> same key. So if it sees that its configured key is holding the
> reservation, it assumes that this device is holding the reservation.
> It
> will only unset the holding state if it notices that the devices key
> is
> not registered, or it is told to drop the reservation. Once it is
> started the only way it will set the holding state on a device is
> when
> libmpathpersist tells it to, but that should always happen when
> libmpathpersist grabs a reservation.
>=20
> Now, this code is admittedly complex, and there are lots of corner
> cases
> that I might not have thought through which could produce a false
> negative, and it is always possible that libmpathpersist fails to
> communicate with multipathd to set prhold.=C2=A0 Also, I don't think we
> really
> need to worry much about another device holding a duplicate key when
> we
> are explicitly asked to release the reservation (that means whoever
> is
> issuing this command also thinks we own the device).

> So I'm fine with backing this change out.

That was not my intention. I just notived the change andwanted to get=20
confirmation from you that this was well thought-out. Which you have
given in your response.

>  I was on the fence about it
> myself. If I do, check_holding_reservation() and
> reservation_key_matches() will still need to be moved earlier in the
> code for the next patch. That patch also makes changes to
> check_holding_reservation(). Do you prefer moving the functions in a
> separate patch from editting them. Or are you fine with doing both in
> the same patch, as long as I call it out.

You can leave it as-is.

Regards
Martin
