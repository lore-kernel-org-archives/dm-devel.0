Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA4FF9EC
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 15:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721057820; cv=none; b=qtOztHFTGiDGhgPo3rN1rVMX3kB8PI2Z4l/T+P/5woc2Tyazv80kA/qpyfy1+KbPnbtU9DYZPOD6bIh298HDOIslSWFGQZvVNEc0Byavm+UAN3+PBHAM6T2ETEflPzWgTCCX+5WPYcyXc+41aAqz7l8InFa3tnvi7Ls9Stz+dLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721057820; c=relaxed/simple;
	bh=/NGUAOdX4UWSWOsL4WdsgccLRNCHooIY7R39ZLpEvvs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g54B0u59jbAB78Gqf0Ty3kMrpM+xmb+0J2dn4OQOiYqsO4ps/t8TSdQ5ub0ATfC0lU+WZCKqnvojoCaRWDDNh1hpH3A0KMdQ/+kOEjFeU+2dmgL9+PIa2dnGkClONWF3t1W5ckHlYTN/EVXXAif5H22Uhk3bkpWzbCIxIovuYTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RE7pMo/R; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RE7pMo/R"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-59589a9be92so6118776a12.2
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 08:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721057817; x=1721662617; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/NGUAOdX4UWSWOsL4WdsgccLRNCHooIY7R39ZLpEvvs=;
        b=RE7pMo/R+vGff0ewCf60e5i830VvY4wT2vDF0eLn9S3V+jhwVNI1dohLaUOZbF2EjQ
         qedq/VluQCeg2lAd65CygiPxL9tQUifuPKb0ZtoewzzDMhJlg1Zknjpjq7N25soxauJD
         gjyW4RuoxkXIHL7eZ2u+FXJd2AsqBB4DIs1hKxHgBsGvfNqaIjlAV2fOTzXLfYH2gzER
         yv2NmHbajt02gBjsQS8A7BGN/kzkdeH35KvIcB217kLWyi15NSNczViji5COS/m/RYF7
         g6MN8TTbY50iwraNaVNdT61PTNi11D5XBsIAE/1qID4iTpzEMy+QV3UCT0QgskmQGbAr
         Mb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721057817; x=1721662617;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/NGUAOdX4UWSWOsL4WdsgccLRNCHooIY7R39ZLpEvvs=;
        b=QP/r4z5I2ZkAZKtX/hnlMpe9bVv7w2T7FVeLgwgIk+f8vPA34X2L3JkKSQvjZ+YCOR
         Dm+QHThPLv6H/NA/BRgMN+mdLcnNC3r7tV0BzxIoIt6gkfEOGnSQCBFj3h3iisSxjHLj
         P0Jj7Gi7STh+z1jlZJywqF/wPOwEDHPkz+0HMUiqVoEDGTaUJWSnydBeha24jBs/CPnr
         uXVA5oZnkJXJ0x+2slxsaeFNSSaef5IJzMF8s6RXTcft6h3vPOJ22Nw9fPG/P1tQLH6V
         yjWF+M/NcrR63ZiotU8wO/eplT+w0FqKWLdzlpl+jtctXcewf7YYgOhYOTAwxstX3r9f
         J16A==
X-Gm-Message-State: AOJu0YzcEp4IlsbQJjhlHQy/fLPRZ35K/PI43yt+w9UqRgie8XfYb7HV
	vAzGzmhIfnBoRLthi1sNe5dh8gFxy+x8z/LkSJ/IdRXizFkwlZQRmD6LfhrdkjpwIRJNq6kWd2y
	Y
X-Google-Smtp-Source: AGHT+IF8eEu7oaKQMWyI7+/oJqX/xdhihry8NLUJpvqpIkQfSSq2cUuJEY7gnQzpHIzsGH0qUJJQvQ==
X-Received: by 2002:a17:906:88f:b0:a75:fb2:8bb2 with SMTP id a640c23a62f3a-a79e693adb5mr8131566b.13.1721057816418;
        Mon, 15 Jul 2024 08:36:56 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5b37f8sm219839666b.46.2024.07.15.08.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 08:36:56 -0700 (PDT)
Message-ID: <33d9dff6f222a2831efdf34bab9d90c76351475a.camel@suse.com>
Subject: Re: [PATCH 05/22] multipathd: handle uninitialized paths in new
 function
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 17:36:54 +0200
In-Reply-To: <1eb0cdfbfd0f6cef110fa01802fa07c946011bc4.camel@suse.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-6-bmarzins@redhat.com>
	 <1eb0cdfbfd0f6cef110fa01802fa07c946011bc4.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-07-15 at 17:34 +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > Pull the code to handle uninitialized paths out of check_path() and
> > into
> > a new function called handle_uninitialized_paths(). This should
> > cause
> > no functional changes.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =C2=A0multipathd/main.c | 171 ++++++++++++++++++++++++++++-------------=
-
> > --
> > --
> > =C2=A01 file changed, 105 insertions(+), 66 deletions(-)
>=20
> !pp->mpp always holds if this function is called, so we can skip this
> part of the test.
>=20

Just realized that you did this in patch 7.

LGTM, then, but if you resubmit, I suggest you just squash these two.

Martin

