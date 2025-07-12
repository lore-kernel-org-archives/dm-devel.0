Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C317A22A808
	for <dm-devel@lists.linux.dev>; Sat, 12 Jul 2025 22:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358296; cv=none; b=HWwuvLaF7SBKftETD0iEmzyujMgq0sfmawEZYWi4vzeQMz4Q8uWFOeMYXkqbQr9IjPTwA9v1xk6Y43M0Rt3gvaGvsqpOU7tLL8Edt2JhSnjInUJmNbb0zIyIubeHd749hGhQctJ0cqIAwre9gMNY/Z5aW7OyXmuQu3dibTzW8i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358296; c=relaxed/simple;
	bh=Ae8NoXwXSlJEHjBfj9+SvAwqq53ABo/o138ibg61o/8=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:
	 In-Reply-To:Content-Type; b=RxocBS8lxMz/9+RArsNL70z8mEyRBbT0IHXFljGRllsLWJmHnTkqJTJXtKxww/Vm2F7+0sSdKPMLjpHDG0pML92XtPfwAFIAgW/fT9igSI8B8jvmf45t5xhOQBiYbMhYt9h9SEHn8IHAzZxmt3XnO+diqnt/GDtDk0D1ITkzpBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X9Tfw0it; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X9Tfw0it"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-456077f0e6eso478765e9.1
        for <dm-devel@lists.linux.dev>; Sat, 12 Jul 2025 15:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752358293; x=1752963093; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIEQX44X/NeDZwLNKmN4YY266j4thbPs2H0dkeS01cM=;
        b=X9Tfw0itYG+dK1k8da6X3WPvRg033dvWsSSTL23Wx9d7y08LEaJ1foCgDvc+2lhpib
         5MAzg+iIuagg2rk3T3tYPAJgorCZmQdMLQpxks9buZiwXdlAlTCFvOiSpFHLJVNqp11O
         UvAzLIxicezdfbkIGUE2iJgHc/LTTmVoldlmEYnuGhMQPcrBnRmxsdxrqFck/3GRA784
         84YGnoIzQz7qQKFA9xdSpRd32cokUsIN+un8hAJhu+pbCykflhFuBp0wSzsO5er6B/LI
         CMngv0qO98tQnOV4jIcR+XOFx48Yn36JscOqfq4VGb0awPymIKjWoy1NSzYlVAPGIyWL
         1uBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752358293; x=1752963093;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rIEQX44X/NeDZwLNKmN4YY266j4thbPs2H0dkeS01cM=;
        b=A3wwJXfhOOz7bUfTZftcAWc8QAIywihT2KqlK5t00KOvgFfcRc9hU8rzYDjNyCB4jd
         Wo9zD3pHLw0qByeMhMVAY1SYTk4mWVf4URAdzKSTzWX3j4ZqHu0bpmwVgTRruRfzeRr2
         1jxjk8wOovn27GMigv0g/z/5MBjTUmP8iPOSG2F01q6RISGWooVdy1c9tQXYvoHUsUDl
         v68rmIKg1EHv28vux5zMyhgpqlgqhFcFLoC++KUb5HtR4g54fJ5PrvD6JESkINZOYeEx
         YxkQlkNp1wwsMm3okcZTLB1UB3a5bfuGxsMDhjvl7QW7VUqaZhO+U4HQus4RO/cYKkyr
         ZANQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhPtZbk772nY+3DBR+kDf52VCARCbbaDa+m4ns6Wr002U76QNX7itVC81VwEJkMuIR5jYed+ZBQQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwbjnacqH8OaigQ9Vk6ekcaPZZyY8HCEcQ41RYkRsR5fB+NkWh3
	W5OD7PU5YeLHqVzMBydVUe+gGB/P2J8COu6LYqUXyQd4MEJ+5WaJwpo=
X-Gm-Gg: ASbGncvguN5b/qM/471DvtCCT1MbKquUC8r0ICwbRV/OBF0ra8Mgieb3zXg1trX41tb
	mms9X/wMM85Fl9xj5796Sjoeycq8wYpFEH2+uHiqgimmDLyLZfa3SpnwLxcz/H95NAeBLgBoJdy
	RYeHO1SJ5sO4uf6yJ7oKgn2S7RlHB/8a7BVe/lXd4u6wA5mjYS+KLYWt+Dmin08IhYaD1BGREsG
	U5wx0Vyy/DjlEz/z81Z7ni/oMbadgeCnifD1D4SLw9dm4vLqjZU8xlyuaabq+p0uQ7sSMoYGbSE
	IT0P/0zBuyzSR2ccqhU2tOwfPuJ4Hjy8L0YJMZagT+IuXtaVAkrmWjMt/fMJhj5g+licj8CMsJo
	R8ss0S+xwtsBVHOc4v+ry6BKP3mpVrluewtRF3Jfv7lv3zCNP8Ya32e9AEfv+ymkh7sLBYfJb
X-Google-Smtp-Source: AGHT+IH6BHzG3H2KccIJu8rf1vckh5EEY0odAEa8FuernOJ/eh7pAdASrImw9HeMXjAV1lg5R54kSA==
X-Received: by 2002:a05:600c:4f52:b0:43d:fa58:81d2 with SMTP id 5b1f17b1804b1-454f4286ee1mr26157335e9.9.1752358292709;
        Sat, 12 Jul 2025 15:11:32 -0700 (PDT)
Received: from localhost (182.red-80-39-24.staticip.rima-tde.net. [80.39.24.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d5032e9esm125825635e9.3.2025.07.12.15.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 15:11:32 -0700 (PDT)
Message-ID: <76bde3f1-0f06-46fc-8e0a-729e6629024c@gmail.com>
Date: Sun, 13 Jul 2025 00:11:30 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: fix default blacklist of s390 devices
Cc: Stefan Haberland <sth@linux.ibm.com>, Nigel Hislop
 <hislop_nigel@emc.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 S390-ML <linux-s390@vger.kernel.org>, DM-DEVEL-ML
 <dm-devel@lists.linux.dev>, Nigel Hislop <hislop_nigel@dell.com>
References: <20250712201454.215404-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20250712201454.215404-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/25 10:14 PM, Xose Vazquez Perez wrote:

>   libmultipath/hwtable.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 081d119c..4ca4245c 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -687,7 +687,7 @@ static struct hwentry default_hw[] = {
>   		/* PAV DASD FBA */
>   		.vendor        = "IBM",
>   		.product       = "S/390 DASD FBA",
> -		.bl_product    = "S/390",
> +		.bl_product    = "S/390 DASD FBA",
>   		.uid_attribute = "ID_UID",
>   		.no_path_retry = NO_PATH_RETRY_QUEUE,
>   		.pgpolicy      = MULTIBUS,

Is PAV really supported on FBA devices ???
And other than 3390 and 3380(3390 model 2/3 in track-compatibility mode) ECKD types ?

Source, z/vm docs: https://www.vm.ibm.com/storman/pav/pav2.html#2001

Thanks.
