Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE2D1CD31
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 16:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721060642; cv=none; b=TZschezQjRD9uuwWrELdaiQSuvzJ1OxqcEoG2J9OvaXgQoSCpi2o7Pvldg7RArNxtQKVKm4xyzkO79KbH026Oln+j7H3NRXIdzfsdD5VoSHhkiZZxDfYRisM+L2578qa/JIKNXUeF7/FrEu9LBGLrofYXl8caAU6rTKnlLCXK7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721060642; c=relaxed/simple;
	bh=MxWyHH1D65dpYnnSuNWOBAr0aK+a1kk85nWH5MjIgHE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pXqYyUOBgKE4C6ZrPRIGmfvqUqU5+wnsrpqWcm1hC7qn/9doCg7C+egczMCNhbyzH6tHKC9Fa3caDXjCZkARIYclfmBpyI6oQxkgoJKuJYBvFX0kS2U1Gzy4gW5XGnpIcJaPWOHm4Aov8PIBmDhE4shgNR2yzG3zEhBR+6r9ibE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z8Ffh5So; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z8Ffh5So"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52e98087e32so5340275e87.2
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 09:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721060638; x=1721665438; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MxWyHH1D65dpYnnSuNWOBAr0aK+a1kk85nWH5MjIgHE=;
        b=Z8Ffh5SoF4zkNpGQyDoVlje5zepgK1oiu4ulAT4UglTYpu6BZd4nFMz2HGwMfZVnjK
         WBgkiDIVIyk1Fu0RWRd1qW+Ko9JbcREv+rszqj7UqF63xqVPLBIrbs/w+mCMtiFPC4b7
         0lXAXZB/YTXaZGnFpEbmc9gMaf3eCJkyQsiNPCLOypdYqfW613ms8n/L5U7AJgwtSRPJ
         B7A/j69yrD8egXfMDMzoQWcJ5shdfLrTN49heBZzDEOJREIpeBOBqolmvsdvXoQ46Yqx
         Qri7MmzhBfTRKnftqLLs2hfGMvHGPHaKEkyAhXu1VQNBSrdgC+SkrhN7nN/HB1OFE6O4
         pfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721060638; x=1721665438;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MxWyHH1D65dpYnnSuNWOBAr0aK+a1kk85nWH5MjIgHE=;
        b=tMbfaWKACbj1XVvHZ5ezsPKSA8hbPuQRxk9GBbkUhKN2zYeTx/+f4Jm4z88euGN+wM
         Mma64OtZmY6+HEv7sXOXXMBkz37XzWPwaJrM2n+opPciST+vMjHhoOqnvj1lYwg0/iaR
         UEeyTUEraQL4kpWWwGSvg3BYemTJmg84pzfPQUM4+gGJa+5N/9By0oa0OK4YmgE75TtY
         NlrwcYH45WXtu3j9MCM52zBUOVGsD5HnVVGi88qPSqZXKTCJcRB1VQZuP5BpvDy0yaIs
         YqIlr5c0mPYPbkg/jHUerUqm9CKL4kxLQhwHDEjTrNMfPjRvZz7lvD/N8jeZxPiBIUcS
         V0Dg==
X-Gm-Message-State: AOJu0Yy7YiRBDlwzBSN4lPXNKOUPvM0BAh3LY7m/SOUK53L78JqeFL6Y
	z8KROnG0tggQ3P+maTBgO20XjuLKvOpXzQcgwkIrIVIGyvfIodQ/XC+nDmfqEyrm2PzwNOTCTVp
	4
X-Google-Smtp-Source: AGHT+IHPYo+DiWRE4NFlMJW1X//lyLMQ5MPxihvwnNdU70iSCwc4uf0fa/II92Wf4U2ci91cVBFixw==
X-Received: by 2002:a05:6512:3b2c:b0:52e:95fc:3937 with SMTP id 2adb3069b0e04-52ede1a4184mr21356e87.15.1721060637846;
        Mon, 15 Jul 2024 09:23:57 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f23988esm129282945e9.1.2024.07.15.09.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 09:23:57 -0700 (PDT)
Message-ID: <cff01b26b3b064b81281689fdcc9e9d4b3f66fc5.camel@suse.com>
Subject: Re: [PATCH 11/22] multipathd: reorder path state checks
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 18:23:56 +0200
In-Reply-To: <20240713060506.2015463-12-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-12-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> Reorder the path state checks in check_path(), so that it first does
> all the checks which can result in returning with the path unchecked
> or
> removed from the multipath device.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This will move the code in question to after the call to
update_multipath_strings().

But that logic is modified in the next patch anyway, so

Reviewed-by: Martin Wilck <mwilck@suse.com>

