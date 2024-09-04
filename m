Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C0B1DCB1A
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725466362; cv=none; b=vArW+jrFxrRVOKJMlFz5hBF1rOdWwMylgCwp6w5MUhGAt/XDlgxUSBCDuIWeTw0ALn58GqfQZiJ18ykiq2LhkTSKmXBEOK6+k0q3jZ0hC1iZHiRuDAVSC6jV8J2TfotpHyW2vTjBnwedD7qmbTYPz13BHlrK0E1r0qB8Mt2xAac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725466362; c=relaxed/simple;
	bh=09vl+TCKMplQKTcnZibw33oW//3VANZ7Jf/xBMZvVcs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cVJnvmIzjpMioYzwdMcy6ACFLlgiL40CTisPtVgLniaviUnZZtsjk8cQf7t/job3lcxFaEM21m0p8SFTonTHxCmjGMo7Ff9uWngx66Nmyo385by73BkX/fHKjuL8mncP3dhqC6f5d6e2UXRwj0QlYubzgfNf8ZkzngaJe7UJVTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RfPkBms0; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RfPkBms0"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a869332c2c2so166723366b.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 09:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725466359; x=1726071159; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=09vl+TCKMplQKTcnZibw33oW//3VANZ7Jf/xBMZvVcs=;
        b=RfPkBms0J9O3Ywqn7gayTY1wJTkyyil0IbOq6MgJxaZ0DraraOTyQAyhhnquq+ZXb6
         EMS3CVBkvf1f+Kj8tXlA9sMQmo7w3DcQ2u21ad/qDZvtu917BKZ3s3m5FqLMcPUzIMA9
         WErMXugXc1NPzlGv/WDWQmhUdDJw25BpUGiNPrT0ECNjvUY5ZxnmGsTbv48IgaCshy1w
         fE/swoy2jxql7DoYJudIRlPdWoyYzs1jX6BcHqumMQShZjXBdNKRse476Q+RD+IXdnaI
         /apurP0+F4JCU9Sh8gIi0dRBjoXIvCPXhmIUKEgjaqNke4g5yxBzYkB+vs82U7LE0qz9
         hXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725466359; x=1726071159;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=09vl+TCKMplQKTcnZibw33oW//3VANZ7Jf/xBMZvVcs=;
        b=XK0YodWeYPCCYc/mPfm7MWCqRl+ZQIpXnWMG6V0WanLIU8n/nMiSgaKeTAxooF6pba
         Mj8XCBXxQtzlAt2U3ky4m6NqDDaFkhY0KVIuEsCnblOuM+zj3UeJFKpU37CXNn83Dsw4
         KQbw9zCvyD+2bXOHUxi23J+b8j863vB5Ad1WIDQPyEh7J9TW0gtFh3ynD7Q2vf/r69hO
         tp29l63fsOXruEB/6IUhui0w6JxXhqI0YcGxnrGmlGuKk/Tdv/AkRyZf2oMVDuNAcrVq
         gg7GkaWk4e+LaeNKr/1+GyZ6HmH0Mo7tqv70S46YDOQnGDsOCtMFII6zEMFNK+c64bhp
         NpHg==
X-Gm-Message-State: AOJu0YwgeJphW94BqhKF4iLCo9yYThGHedHIAQXSdu00kPVRp2dNdPE5
	gYUyfcMBJVIKLMq6GK/J1ackIQAk4pElTathwHihiW4F8QIy13AVjtm6dA7Y84k=
X-Google-Smtp-Source: AGHT+IEOdwCBKRGDFDlEqunDGrTnKk+MT73S/Pn+0ssdmhkVVJq3VvhlF8ojtnV/S+NS97XaFtu3vA==
X-Received: by 2002:a17:907:3e21:b0:a77:dbf9:118f with SMTP id a640c23a62f3a-a8a42fdb993mr277172166b.13.1725466358634;
        Wed, 04 Sep 2024 09:12:38 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3cc52d989sm90355a12.3.2024.09.04.09.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 09:12:38 -0700 (PDT)
Message-ID: <534d539850c59ac55911bdd584737934cb24d060.camel@suse.com>
Subject: Re: [PATCH 05/15] multipath-tools tests: fix up directio tests
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 18:12:37 +0200
In-Reply-To: <20240828221757.4060548-6-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-6-bmarzins@redhat.com>
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
> Make the directio tests work with libcheck_pending() being separate
> from
> libcheck_check
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

There's still something wrong with this test. I'm seeing lots of CI
errors with your complete series applied.

https://github.com/openSUSE/multipath-tools/actions?query=3Dbranch%3Atip
https://github.com/openSUSE/multipath-tools/actions/runs/10704501258/job/29=
677643779

Martin

