Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B3B1F4199
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 02:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745721953; cv=none; b=T66xBFgYcb6EsogPBo3Vu3WGm12pdHZQkHI4JXq2LyQYfeukXQ+Q/bIzI4GiZPwRWhje8ef3p8J6uY7raJ63dJ2VOsoJLfXE3QjthAtcj5kfJjzBKrw0MMXziUjE18qJUDZXwmIhoEEjVb17jVK97WA4VWIiQmkU7d6KoFqScl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745721953; c=relaxed/simple;
	bh=9HyWmovfxbdO9WlvHm/CrZCGdDuQYBCiz0YIKAxiQIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BT9p98iSci8IrccvQL8s4C8a4fQ8m921ARP9Qsk4VAPoQoum52XdbOkCn+OshtH4R6K37wy9EDUFt8limvf7YxtaJa7nEIOEhpkC09miHbJrcE7q93btQG2hbkaqYMsE2e1Qec9L4xPpHYyfbOkUi8opRTNq7IKXKJcE0NH2+W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bv3qL5dl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bv3qL5dl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745721950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5lOD5wJKRJSGzLBcfg1idl+BdURTBGXU653f/FvKAjA=;
	b=Bv3qL5dlqFp4Ayz0xoBMi2VRHFPpgNKP7J/3Him+lF24KycqSfU8R7zOg/WoK0+Fbzqn41
	wL9oBWObdSHfQ9ehYnBlSzWY5ywxVPd607FiA2KgskXs2L9b3ebm8ozkYul4rYJJzDhI0S
	uEI9HBcc+BZ3obtxVaynX9B6rEuM2dQ=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-zKUrRT5qM26DaPjPKPBzJQ-1; Sat, 26 Apr 2025 22:45:47 -0400
X-MC-Unique: zKUrRT5qM26DaPjPKPBzJQ-1
X-Mimecast-MFC-AGG-ID: zKUrRT5qM26DaPjPKPBzJQ_1745721946
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-549948b27a7so1865320e87.3
        for <dm-devel@lists.linux.dev>; Sat, 26 Apr 2025 19:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745721946; x=1746326746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lOD5wJKRJSGzLBcfg1idl+BdURTBGXU653f/FvKAjA=;
        b=QJDwXrm1/m7yJiotWJ9krCHVjC8HGLdbQi/Qd2hyS24iJN4WLj9mPX02Ru2vxTnovp
         ZSuwFOeyHwLjrpmqNusaLFWt7oQlL0oUl8VPrB5dUMCOFK0GATmLdH05r08zpBQX0sTD
         lAaUIeqP5TXj/aoNU8TF8uZV8QLVK3W12x6XrrODUEyJHVbuW4qiCv92HE/ejr+gHOXA
         EAg5darjXi828mTA6gyIejujddLB/snT53oNao71YqNyPPKzn1hQGSAS1VJGMgGgpQZN
         /FN5MXe4vH+WuyS5fdWrR5VyXRD6R4J9Rjjf71+opv0fks1vnoaNcfB41P/V5MOGV41h
         QU/A==
X-Forwarded-Encrypted: i=1; AJvYcCXuiH8VqUeWDeRv3qNzgcGe4Mj1XbmzXwS6GHRw1BcweSa6L/fLkpNM4LRy/2779H4m/YqVH6AFhg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxAWpbN7nW9tE2qTJaHmcq+EPOiwXSDT2l7ZyTvgZ7wOIyQ3KEd
	PORGbezUMg8onOeEByUPnJ8vN3lCdZmu9XniYQGmLFsqTtkgUqHme8Jcn51Kpu3M1BIkOY0qlE+
	e8H+tiThHU2IJI3fqFkw3fVhwveGDU61rT9gnlMnUBCmHKd/jnHxIfMhnL+JAtM27Y4Zon+b7Et
	18SZNx2lzxK3KMaKduwSEoJsf8Dk0XCvM=
X-Gm-Gg: ASbGncu5Jzg0LejCcj+jWqdQo7PM1U7e9arbHjCVtUOWeljhFjxI+kwbdmjT1vpUBEh
	8iNClicobHudagCAjgD2ok+SEgYPYVbKml3gFh1WzE7VzDuY57gEByA/vWyQXX6bkiSt47Q==
X-Received: by 2002:a2e:bc13:0:b0:30c:1441:9e84 with SMTP id 38308e7fff4ca-3190614e2efmr19465691fa.13.1745721946228;
        Sat, 26 Apr 2025 19:45:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGS0Yc4bGIbl2/v9OhZ9z0uTs3mIqptakH90A1Qqw9fP/ktQZ1u60ZhGAtb0KMTfZsMAlADrGR3uW4Ef7E40xE=
X-Received: by 2002:a2e:bc13:0:b0:30c:1441:9e84 with SMTP id
 38308e7fff4ca-3190614e2efmr19465581fa.13.1745721945851; Sat, 26 Apr 2025
 19:45:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
 <20250418010941.667138-5-yukuai1@huaweicloud.com> <CALTww29aehPQcbcy0j+V69r+RVgzNPwNhpAQ-7wWMdD-VPfNgQ@mail.gmail.com>
 <f14eac30-ab65-85b2-3e65-de6d50ea15e2@huaweicloud.com>
In-Reply-To: <f14eac30-ab65-85b2-3e65-de6d50ea15e2@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 27 Apr 2025 10:45:34 +0800
X-Gm-Features: ATxdqUFJRCKVD9aqKTI3GFPq-KDsm4Enqte1rPq47L--gyfTK3VWtePr_uH3814
Message-ID: <CALTww29b1MN8Q-ayFLxnRA=+=J-jrR90nrDrrY7xs1C_2k8KXQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] md: fix is_mddev_idle()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, 
	nadav.amit@gmail.com, ubizjak@gmail.com, cl@linux.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XE6Jzc60vWQCg7lO7lUry-IkSnOb3ad1zBGB7tIlCIk_1745721946
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2025 at 9:37=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/04/22 14:35, Xiao Ni =E5=86=99=E9=81=93:
> >> +       unsigned long                   last_events;    /* IO event ti=
mestamp */
> > Can we use another name? Because mddev has events counter. This name
> > can easily be confused with that counter.
>
> Sorry for the late reply.
>
> Sure, how about, normal_IO_events?

It looks much better, thanks for this. I guess it's a typo error about
uppercase IO, right? We usually use lowercase.

Best Regards
Xiao
>
> Thanks,
> Kuai
>

