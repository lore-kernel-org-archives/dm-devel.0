Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F355953A
	for <dm-devel@lists.linux.dev>; Fri,  1 Dec 2023 07:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="heSvJ+lK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701416237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hjq7eJtl/KBWzACD4CpZouOhHH/+sfSdtiLs30TuPCQ=;
	b=heSvJ+lKpVsG4bHXqzBFZHGgz1WbdUqlPPEjdYK0XqLDQpTqKkWRrUhOMGH5bNisHEvUIW
	2+Rvv03ppE/EFWPrvrstAIWn+8MPuliQo+W6sk6QSehab5eUnlQKAoEzGUBjFEHNm1HSCE
	DFvvF+pPzvgX+tU3SU4fk1PY404rWVc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-Q_aaYdOZMn-bjB_f6R__Vg-1; Fri, 01 Dec 2023 02:37:15 -0500
X-MC-Unique: Q_aaYdOZMn-bjB_f6R__Vg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40b546fd830so13720975e9.3
        for <dm-devel@lists.linux.dev>; Thu, 30 Nov 2023 23:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701416233; x=1702021033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hjq7eJtl/KBWzACD4CpZouOhHH/+sfSdtiLs30TuPCQ=;
        b=rJ8qoCeF4EK5HW/hA74s334fsO/XiyxxX0ww7Ums9OPHumnJsh1SFXIzEVt2xak9KR
         3016S1TipvdtvqeMDJoraEmn/FakOaDXhMwXI16XGJjdMQzfTlYMMgOFYhVBspAAPPNL
         LdEk/N9tmwIjOtmgtBIwH8QjcvCkeHVLZ0e4RsQWjfaPA+LGhvrPQHLOMzH1OAOMIKT8
         9spVjFmPGJaJHX8T+4ZcCzk/Yi9FNAV5vgu5cdRyrqR6UXVQ7xb3F+ItJTAsBAZoa48v
         FIS2kGX97wwCrMYg89A+MvYSkUpe33/dL5zvt96uR4THKXY/kfFqpS5k6XOQA8410VNZ
         rBzg==
X-Gm-Message-State: AOJu0YwnPv7SiRMPZJALD7BR7PSrnbM5APqa19L3T4tAObmcqTt4o3/v
	1wTTQB9eva9WsHtkNsu5UYOdqub15y56zQG5L/ejDZo/zRViYUgew4TKH60ndxdTIa8M2zv4N4X
	Z5hu807wT5Qez3Mx0K8fqhnSSNPaqrsphJcQDQmkmSE8=
X-Received: by 2002:adf:e681:0:b0:333:2fd2:8163 with SMTP id r1-20020adfe681000000b003332fd28163mr527915wrm.128.1701416233779;
        Thu, 30 Nov 2023 23:37:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFM9qLZfWLSpEhHDbyDsbpH0fjcR3UsChJUFHx3kqfnkjOpD4jNm2In38cf4aoIyHS2okOsDtCkIGKvDaX0Boc=
X-Received: by 2002:adf:e681:0:b0:333:2fd2:8163 with SMTP id
 r1-20020adfe681000000b003332fd28163mr527909wrm.128.1701416233513; Thu, 30 Nov
 2023 23:37:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net>
 <CAJ0trDaipa_80xqVpDkJdm-SSCaN7g_O-m9-StG10P_DUxmtEA@mail.gmail.com>
 <CAJ0trDbP4BFjb0KQ+t4Lh1JdVjP9sbMiwJEOXPkGEV_R95rFoQ@mail.gmail.com>
 <12d141ed-84d2-411f-3e61-7a8d5bc7f0dc@ewheeler.net> <CAJ0trDaRQaDicO9ho8Hokj68vEopaJwM8YKwPEjzYkWBXE0dWg@mail.gmail.com>
 <cb3f4665-fcfc-c08-2dce-99c071c2a569@ewheeler.net> <bb6deb36-dd80-1649-11b6-bdcf24cb4e4@ewheeler.net>
 <7bcbab39-9ad0-4e9-d49e-5c229689915f@ewheeler.net>
In-Reply-To: <7bcbab39-9ad0-4e9-d49e-5c229689915f@ewheeler.net>
From: Joe Thornber <thornber@redhat.com>
Date: Fri, 1 Dec 2023 07:37:26 +0000
Message-ID: <CAJ0trDZMorQJ4muW_DfbaQAsgG7=LbiOM0ZEcig4=qA8SE-Zbw@mail.gmail.com>
Subject: Re: Stuck IOs with dm-integrity + md raid1 + dm-thin
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 12:40=E2=80=AFAM Eric Wheeler
<dm-devel@lists.ewheeler.net> wrote:
>
>
> Here is a reproducer using ram disks, it hangs quickly on my test VM
> with all the kernels I tested.  Here are a few example versions:
>
>  - 6.5.7 vanilla
>  - 5.14.0-362.8.1.el9_3
>  - 5.14.0-162.12.1.el9_1
>
> Watch dmesg and you'll eventually see errors like this:
>
>         device-mapper: integrity: dm-6: Checksum failed at sector 0x17d8
>         md/raid1:md9: dm-6: rescheduling sector 3912
>         md/raid1:md9: redirecting sector 3912 to other mirror: dm-6
>         raid1_read_request: 18950 callbacks suppressed
>

Excellent, thanks.
>
>

