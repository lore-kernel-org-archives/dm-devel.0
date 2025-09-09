Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25784273D67
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 08:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757408242; cv=none; b=fTkLtZ6RRf+sp1/Qi0MQE0wXuhA33WeNBgwmbmH8f2GFBeHJKRZSqNChgwbbCH823Y5eVgD2aabMEp7mPyRhfhv3ksEodnFo3SPkxa99rvxxA0Qnqozo8xqyZl2DuT1UlFyEba+SR4KsptFS+AQ5wegWOB5kVY5qMHliENXSiDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757408242; c=relaxed/simple;
	bh=p1zExWC+cbS5ibWslXGlwKdu9aaVBHE960BgoMfvNsc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XX+hGo3wMQ4WeLrgfZo4yAXB0b4WM0IuaiUXYXdnE2GubQMOGtZNTU5sk4lWSWpwyyT2jXH9DYI+YUAKXUjRKLgZls8hfTvIMr5qgDbia0qp6rKQ3aU46BDH+1OqJD2eZZhP5eg1m3K7nrlp0PUL2JUmeI3tLYE6z1pVVoB3rZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZauYbWWY; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZauYbWWY"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso34491245e9.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Sep 2025 01:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757408238; x=1758013038; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T9xYaRu81EfW9w8hcR1HSoTO3ZoNo3Jal96xP2Pgu84=;
        b=ZauYbWWYWfm5YmTFrHhUQfXWKSNORTdSGjGP/nN46pBlK+Lo54OwcN7KRCVrpVXyiY
         8kh1dyjhEz8M/UDFNpqi+CkXt5MYF+ioA4WqTMlTLLJR0eUYWGhZMfiloVVR6L/e5LWH
         U9ZIToKQZ2u3mIo+YuVFJUN2SESj6xvt14bQRl4KAjjbdhe+UfrhjZDDhMpY4Wc7mqSC
         7uq3bgljzuRydU/nST9uyRjtS/20RmnpCVfYXBL2dju+Wu5Kq9G+us/8Vrge6AwWCy6c
         SYGL1xFZYNBcv+IaBN30oUknzl+WRbjss+PF0Hm0lPeyB+SGNXZuznn0sKpFpJrdsyCR
         rCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757408238; x=1758013038;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T9xYaRu81EfW9w8hcR1HSoTO3ZoNo3Jal96xP2Pgu84=;
        b=bmhyzTiRIzXWA4K8ZxKdfD1XRCtkjx0Jjp6I61AjKvH1YkcvrVIpbHSYaYlF434jxD
         fa5Y6FMeQiWl0IbcVCDP2xZjaXSWaaturxP3fI6sUvkPMXyi/7MBx7i3FN7mpe1kEXZe
         AYl4OBd1REb+xrnxBOgkEZ75PswfqrUsmAz6cRCZWmrcndbTI5AbT23TrbQ0Pe78joQt
         RoqvVTCvRGqN8o6u0TMgI2kZ+d7sAjptc5xTfDIrYs7TdncrATYOaTOUQimw637u68iA
         PI9d4acp8iLr0yAle5IWl20mVT7EQw8Nxzr1AlU3F6eADJW3vezx9YADGn8BoIARPi/l
         Pmkg==
X-Forwarded-Encrypted: i=1; AJvYcCUrPWPcd42AnVFlaU8isItkuskcg8pYDvnrjvackrAloAcjWHi/WZYFMz9A0EMZ0EWRdHB+TJeiEA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyQLiCMLfHbVWeiUZpfxmureCp+Ntutay7QBYAg45K0yzsCkk/M
	JYk6fYTV+gbWhhQ9RnPFM1qbGP//4Cfj/t0ahX06i8eirZ78tuuq/3BCixakPwNq5D4=
X-Gm-Gg: ASbGncvMGBGq+7X5Ywjch6G5AIN//d3lGp4eXaZa2gDsK6Vld8i+VeiFxWusA9w0ru1
	jQCcZ/JmB0NHxuN/Aq3dyBOTNlAvUSj1Tkl5e9NPshT+Yrn8A67m8ecPmQPhvTDcbVl9etwGp8Q
	EptNJnuXMeodjpWXRYyiyX4n4X6tud6C6wB6G89SYPJn0x5PJZRmFQzVO80RnyJ0cGavS1oNrB9
	3AnBJIL6oFgBUXvXoO9+jOom+IXwLFoQ2cP3xOcsfn7MS+IOrGH31HV+ijJGVnMFaifJueIkoGs
	gTcNk/WhhKYaPpi6tKkKzF3OZ1oQIbse/T0jqzh9+wubMfRfYLKl8vUgPgryHBKt52d+KFHoPwr
	hbARH17rdJ+LvkeA0ER7J2GH6lxjVT6bpBZzCmQnIa8MbDjEkJlYt4uhWfqVmBOqm1iHAs3niu2
	2MfltfkTlhk4drLJFCIHgYyTvvz1Hpy1yFStXULADdCKYx9lb94d9J9H+EIg==
X-Google-Smtp-Source: AGHT+IHf9EuzSZ6szF/SphXFcHweX1RNT608Io8pC2WtAu51MQ05beHRfrbvV3SU1jeZvBpI3r+jyg==
X-Received: by 2002:a05:600c:870f:b0:45b:8453:d7e with SMTP id 5b1f17b1804b1-45de072e865mr104047525e9.6.1757408238337;
        Tue, 09 Sep 2025 01:57:18 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6? (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45deff68b43sm6678835e9.2.2025.09.09.01.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 01:57:18 -0700 (PDT)
Message-ID: <25cb91f159bbc7f831b259abec6d8a3901f2a3d3.camel@suse.com>
Subject: Re: [PATCH 1/2] libmultipath: fix missing return value check in
 snprint_devices()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>, dm-devel@lists.linux.dev
Date: Tue, 09 Sep 2025 10:57:16 +0200
In-Reply-To: <aL8hol-agJsYXaYk@redhat.com>
References: <20250905210714.167202-1-mwilck@suse.com>
	 <20250905210714.167202-2-mwilck@suse.com> <aL8hol-agJsYXaYk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-09-08 at 14:34 -0400, Benjamin Marzinski wrote:
> On Fri, Sep 05, 2025 at 11:07:13PM +0200, Martin Wilck wrote:
> > Coverity scan defect #488155.
> >=20
>=20
> Your fix looks fine, but the code I see right above it isn't. We
> should
> not be returning a positive number here if things went wrong. Looking
> at the udev_enumerate_new() code, we should be safe always trusting
> it to
> set errno correctly. So, the code should probably be
>=20
> if (!enm)
> 	return -errno;=20
>=20
> If you don't want to handle that is this commit then:

Right. I'll push another fix on top, using your suggestion.
Thanks for spotting it!

Martin
