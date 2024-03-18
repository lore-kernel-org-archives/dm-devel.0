Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0E32030B
	for <dm-devel@lists.linux.dev>; Mon, 18 Mar 2024 20:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710794253; cv=none; b=opFuIHpo7/+n4VtnZi3A5DCGQbd6hsgtXVtuFk9WmWgyOXr9HcsJbXXLd+0APrM8wpy9kshaMzsNzhzfFvnHbXZ6Gc7OiMT0JOKSdPpI4WosYO/6GTY8MbOxQEPNTKt0bUsSjZul2K63K2/oFZ/Std+3jfkQA4VnRf+7WQWedCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710794253; c=relaxed/simple;
	bh=VqUdaK9/7+tpHdN2FO3ZgGi4B31q9n8BjGi0tpzECok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UAjTfzMOtgZjGEbDaGDl4RUP+Dphv2YAEW7F0ghXbBqwr+wtQXvPDPju3rnzy0HIwqRXXMBXmU9d6L15d1KCx7HEyu/5Yuj/0w+tx8ZPl2D4c1V5qDnNmL0uZbFG4A9OckrPGWV5Hy622fpugsGVMFLDmUHryRlQ51CMzIVp65Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=icPyJZhl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="icPyJZhl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710794250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqUdaK9/7+tpHdN2FO3ZgGi4B31q9n8BjGi0tpzECok=;
	b=icPyJZhlvxQlbGaxCO+BAoM/xd2LvLcnGRRHtKZYQDfr2O3Gif/AVPvMdgYVp8FdKyZhTc
	rSb+zAkQKRTE1oWEg4HhGWHCwhNOuEBoMj08785ZKkKZ7cdPvFFZOc8wn+Fb69hTr6ij1O
	Dj1ANWfbIbYX549am3V8MxQ6lKoQT7w=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616--19RtA-zPcKeb8btjvWlPA-1; Mon, 18 Mar 2024 16:37:28 -0400
X-MC-Unique: -19RtA-zPcKeb8btjvWlPA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1dde11645b4so30758055ad.0
        for <dm-devel@lists.linux.dev>; Mon, 18 Mar 2024 13:37:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710794247; x=1711399047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VqUdaK9/7+tpHdN2FO3ZgGi4B31q9n8BjGi0tpzECok=;
        b=aMT9mt3npsLGf9wLqwJzVviu1uPhUB0oWfIDss7Kx6F/WymN74owwP5TJ3p6wi0JxT
         e2ht3UIw+pqCLExZwwm1SiBOG8c6alfsU02sN215z9gNiAi+EBV80PBbzMCAoip5W0Yg
         W2Nfj8lpfkK4pzyelpr7h120i2AbkRE9qc/wJnnYPXLxLUGBrklz9C6z9cUbP36ZrX/R
         ugUYs8x4cQGI3vYoh4eZUqi+ng3f8eRL0q41n70ME5tf/O+Ee1tJ9zj+/hZnWrIIKckG
         h8SmcKp1KgD6BU3w4GMmJAFjuwv8rxqJFp1zfFBuWlZGsip/do6fot9+fHVYApVsK3/6
         s8UA==
X-Forwarded-Encrypted: i=1; AJvYcCVsZhBj57Q3YEbRm8RmaCWIQ4AZwGpYPKdtDfPe8+2c2/Rej/+4o8+frVl5XB4fSbOoRNoCFgW41oEnXLnkP41wlKz53YW6Pv4=
X-Gm-Message-State: AOJu0YxvPDq/5RuQNixLOa2M8fVZ4yv3vhDJy8tacpvFOofC6kPaY225
	GkDoI4PvUPFAT40vnwZPFxk4j/CYngtv/4ncCHEuopC5YF5vg9m5CHvup/YJ/5G/QxWSOPGBpO8
	i6iFazDF+DzMlVefoUwArRPYt/5/KnzcHkz5hqwJiD6mANyokvlPxpbDCh543L3j0yw9lSY8Wek
	6iyBFpv5ZDUM9jeMCu2u9bsLu2HERE2Nk=
X-Received: by 2002:a17:903:2285:b0:1de:de7d:d3a6 with SMTP id b5-20020a170903228500b001dede7dd3a6mr950728plh.30.1710794247648;
        Mon, 18 Mar 2024 13:37:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUpJT89xQZSz/cFtms6kcfogrMTsC4m5Y7X5MeMjfbSKTJ5CS05UfZSjgpqv3UDTtTeSBtK4dXFOToCokSiKQ=
X-Received: by 2002:a17:903:2285:b0:1de:de7d:d3a6 with SMTP id
 b5-20020a170903228500b001dede7dd3a6mr950715plh.30.1710794247359; Mon, 18 Mar
 2024 13:37:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231026214136.1067410-1-msakai@redhat.com> <20231026214136.1067410-3-msakai@redhat.com>
 <ea57f231-f78e-4a55-bf85-c5d50e17237e@roeck-us.net>
In-Reply-To: <ea57f231-f78e-4a55-bf85-c5d50e17237e@roeck-us.net>
From: Kenneth Raeburn <raeburn@redhat.com>
Date: Mon, 18 Mar 2024 16:37:15 -0400
Message-ID: <CAK1Ur38jAmWo35HTNrDDAaN5Awiie9wRiPDMVrNUg6+ZM8mJ7A@mail.gmail.com>
Subject: Re: [PATCH v4 02/39] dm vdo: add the MurmurHash3 fast hashing algorithm
To: Guenter Roeck <linux@roeck-us.net>
Cc: Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev, 
	linux-block@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(resend because of accidental HTML lossage)

On Thu, Mar 14, 2024 at 7:38=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> =
wrote:
> On sparc64, with gcc 11.4, the above code results in:
>
> ERROR: modpost: "__bswapdi2" [drivers/md/dm-vdo/dm-vdo.ko] undefined!
>
> Guenter

Thanks for catching that. I don't think our team has any sparc
machines readily available for testing.
This is an artifact of our having imported user-mode code to use in
the kernel. We should probably be using le64_to_cpup and friends, as
we do elsewhere, so it doesn't try to pull in libgcc support routines.

Ken

