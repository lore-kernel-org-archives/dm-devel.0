Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F63154F87
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 16:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712939782; cv=none; b=JQaD88pqZtF6X4QfTEPf3SfVu4qu4u9jo22uMzg3AHM/GrwdvxliiJvWgE1OIHT2GeYsGKVqxy25aBIbVfalOJ6Njl2tsFtuueUxVTQztD5pMri/7tNNIOOfVhYpPc47Ej4N5g1G6nhJ7H4RKcbe+/QoFy1Qlb66fnqQAYA48sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712939782; c=relaxed/simple;
	bh=pV+qfifJObP+aPYIbUaaUteBoTwPDTYHvGDo7S2e+KY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ThXyToqPzf+G6aa4prlvKWRyYGhx+sSmvKppy5Eou2VTBkjX6w+95qwq1164LDVFQxi6S4DTTzczDyaE9rQ3W0PjX+oE3HnhglkP2rdo4eIY1Up+lT/TXbY4ulks865+n1+nerEcEr/XUoPANerQ4D89ebhq3soiSIyfXIjCwHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZSya8JQO; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZSya8JQO"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-418031b6110so4320945e9.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 09:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712939779; x=1713544579; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C3nXXg7g3ouvFUrV/3Ztry3cybMaMNlXebxWHPEdXNs=;
        b=ZSya8JQOjGfSgbakwKYSIqhYHPLFcpFsvEwmKwM5H8C0nlm1pro/Oc+WOvkEcQKYqd
         gzEglXhIuV9rokh+IVY3e44CSVbAM+hy1+lt3WumtErijTulT3nkY1UCnMxAWuykEknh
         1ilIG1TnpygVB0mPT/+YYjvcRp+5cmOHyyGT2i/kMS0hQW1UkUPBnxPvBssFbMWyE7fr
         miPMrkPXihJRz2pb2/05k71bOknursBfMOQosbcwHkfmms6MNTSHn9U0jiFmArSRomoi
         ebe7BRvKtaFikWnCyuzavYfbizDauBY2+cRh50v0Q05yda+F1jQZkk7ISLIhxV2Lt45c
         5Fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712939779; x=1713544579;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C3nXXg7g3ouvFUrV/3Ztry3cybMaMNlXebxWHPEdXNs=;
        b=AB04lJRX9Wj4R5hYm93kVjyrjEXHM7u1/yOVVx8PfwgUiiJ8hRnEopyClU5lKTMj+W
         VWhAvF+zn/y1oiBgyL8+oc4id42JyzaOTnshEyhxfCrUANV0vDocTuux44LolaEO7aZ4
         +NGZOU+ryDHwQbcI6n/fYyg8gn7GHZ660W6fnIwqsFlNBpu6BtL3t+jKQYkLxaZretfe
         NthMHRwN0aufp5moF1s3NDumvejt/t7p/VxPTmuoccaEhZPFYDwraiJ2urlPJCjwTxXf
         Z01Akrtew+owwhH3DuiL28sOmU7coPo62TLx6+sicAU7n5ejv23X3LQfbgpqeJ7h6wFE
         /ZWg==
X-Forwarded-Encrypted: i=1; AJvYcCX0BcCKO6W822fuOcLJyU/uOcNs7vvky5fm+FsTD0DD7cjf2HMTtwHykogx5cAjUkSSPoW6SWmRQQoNnlOsxW8270l1YsJ9tTc=
X-Gm-Message-State: AOJu0YwB5refnPU6R4M7e/r5Wf/CAHQrYzOaY7FETQzerM0JM2cmOWD5
	awHs7T4zz/+u9t2/oIFoitoFvEB4D41fEoq1+00XgVeSdMVvW/5YoPBuSJGrInMiMSkD+5B9onj
	2
X-Google-Smtp-Source: AGHT+IENsG8hvNFnGtSXRtSIxR42H0bufVu9TkzDw7l8tlpRVCDgROU84O9tGeGY8UkcwUgRqhu4yA==
X-Received: by 2002:a5d:5985:0:b0:346:cd6f:3fd9 with SMTP id n5-20020a5d5985000000b00346cd6f3fd9mr2669613wri.10.1712939778716;
        Fri, 12 Apr 2024 09:36:18 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id h5-20020adff4c5000000b003437a76565asm4612485wrp.25.2024.04.12.09.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 09:36:18 -0700 (PDT)
Message-ID: <cf177ec478e9e3d304b3f933c6cbd11c815839b0.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath-tools tests: fix CI failures on arm/v7
 with glibc 2.37
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Fri, 12 Apr 2024 18:36:16 +0200
In-Reply-To: <ZhlUYv6aygFNgH4W@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240412093258.20037-1-mwilck@suse.com>
	 <20240412093258.20037-2-mwilck@suse.com>
	 <ZhlUYv6aygFNgH4W@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-04-12 at 11:33 -0400, Benjamin Marzinski wrote:
> On Fri, Apr 12, 2024 at 11:32:57AM +0200, Martin Wilck wrote:
> > =C2=A0
> > -int __real_io_getevents(io_context_t ctx, long min_nr, long nr,
> > +int REAL_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
> > =C2=A0			struct io_event *events, struct timespec
> > *timeout);
>=20
> Maybe I'm missing something here, but I don't see where you define
> REAL_IO_GETEVENTS. Also, WRAP_IO_GETEVENTS calls
> __real_io_getevents()
> not REAL_IO_GETEVENTS(). The same thing happens with REAL_IOCTL (it's
> not defined and __read_ioctl is called in directio.c and test-lib.c).
> REAL_FCNTL works how I'd expect.

Sigh :-(

Obviously, the CI doesn't run the DIO_TEST_DEV case for arm/v7.
Thanks for spotting this.

Martin

