Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113305F540
	for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 08:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708937290; cv=none; b=J2zox9v1CvI80sHEtBePKILiRCeSc+NPjAcY6I0NUo4YUi3h2M8bKNy/vqOYIX3reKPXr/c/XexVg1vHEBl/82hpLqM86LVSCHV3Ro9Dp2afhIwHzYS9MCb5GN8lgCEERITPGrlypYm5mFLK3ozmOcwFquXmmBU7gvevT52T2Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708937290; c=relaxed/simple;
	bh=b+AFtU65+Jqde/aSOUkjfFwLLT8TYBdxvpCg0K8KsRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LxXLdCEDgO/H+1a9LJN+BsERnPdN+xOE09QAyZUEXthlgyz2EuXe1q+xFjR61g4vG3WVqfAQNfkBAUX5JOxeOOrlK8TdtJMBSwAJJrpW1dEf6+TfSqehq/d9xdc2Rrwp5KsQhI4P8/b3vKkfNzrs4KJIYZ71c+8VxtJGh3N029s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGmwS4xb; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGmwS4xb"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a3e5d82ad86so384940966b.2
        for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 00:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708937287; x=1709542087; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=b+AFtU65+Jqde/aSOUkjfFwLLT8TYBdxvpCg0K8KsRk=;
        b=XGmwS4xb6zlP79h4YmMk/N0PxxIYfpdat+RqSHR6I37lQH458jl4B5XI5DAxLAiBk3
         wIJ/xZ5WePv18Ou/Fd+Ee3t3yCDVXaEwiVMqDP+4JJsdMQzbySzxN2VpuTfed2OZT45C
         XhwUGdX5S0NlHCVMUEJZTkUJ9wGTJmW4SQ58mR2NaS267mR4S4b8OvFmhB4cgLnNcR3/
         S9Po8adKk6E0axr4GuzhtY6AxFW164I1fGe0EPaCCSTYidB1C7Z0+24JcEtLIR4HxIh8
         MD7pE/YTNcN8nN8YJBZK9tzo5qbYYwOIhyEaj+YSCzmeg4sAUsHfH0LLbrhWooI1l9Y7
         r3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708937287; x=1709542087;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+AFtU65+Jqde/aSOUkjfFwLLT8TYBdxvpCg0K8KsRk=;
        b=CR8WYvGmrkl2MVeuKUx9BnZN2ywuQtYSCvieU3g/1MVi2+AkDlcW9V74KIAo+xOdk6
         Af4/alGyX9EA0Oa4fPe7+qXNaD8GkscmXHbmdMVWJtjMweQNzR0LmrBkJVK/Vt1Orq2X
         DqcBSNTNOWn1LYBGz2NYp9ZRQiygcdvvN8OQnVwGU10VwBHJy0Wk+lEzo7YJXExTSdiK
         jtcDgAz0sFYSekTd2M4GNyJzgEnJctLoX5brwwyI7b7HghMbDJCI4UKbdD0I19/Rd0Sb
         Z8pGwbXo0hR3T3+pv3WTXhTg4oru5ITKeNdG3TLOWsolLiWhZotgnuoTulre2MU0HBu3
         xyMw==
X-Forwarded-Encrypted: i=1; AJvYcCXT5D+7hyIUR9sWW1TRSuzF5J4ybgpFaplZ0+QoScb+Fk2PEP0mElsFaglFLOeyT0BO5o6w0eW9s3qS7wNfzmhNDMkrRTXMAY4=
X-Gm-Message-State: AOJu0Yz0g5A4D10TTex37bZf4HUBFAIbL4WCSLedhpSMe6Hh9jwYeft7
	IBRJjclYPgcJSgdg8ByjbWkCNQV4Eu3qbYejm7nHdihKLgxCaYVk
X-Google-Smtp-Source: AGHT+IGcDEV/RkM4wbXJ8uHIz3UxH0XnxntHvFl6I6peJPGrYRSEItcnUliN5ydfKQ+ymSV77vGd7g==
X-Received: by 2002:a17:907:9950:b0:a3e:bd4e:c87e with SMTP id kl16-20020a170907995000b00a3ebd4ec87emr4135330ejc.36.1708937287216;
        Mon, 26 Feb 2024 00:48:07 -0800 (PST)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id ov5-20020a170906fc0500b00a3ee5c19ee5sm2199408ejb.109.2024.02.26.00.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 00:48:06 -0800 (PST)
Message-ID: <48f94af1-3969-4021-84f7-5822bd92b38e@gmail.com>
Date: Mon, 26 Feb 2024 09:48:05 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFQ] dm-integrity: Add a lazy commit mode for journal
To: =?UTF-8?Q?Wei=C3=9F=2C_Simone?= <Simone.Weiss@elektrobit.com>,
 "mpatocka@redhat.com" <mpatocka@redhat.com>
Cc: "song@kernel.org" <song@kernel.org>,
 "Tomerius, Kai" <Kai.Tomerius@elektrobit.com>,
 "simone.p.weiss@posteo.net" <simone.p.weiss@posteo.net>,
 "agk@redhat.com" <agk@redhat.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "yukuai3@huawei.com" <yukuai3@huawei.com>,
 "lukas.bulwahn@gmail.com" <lukas.bulwahn@gmail.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>
References: <20240209192542.449367-1-simone.weiss@elektrobit.com>
 <8a485b9-6dbb-78c-9a84-ed3ba65d9cb3@redhat.com>
 <3e5a2087667333bb88135a6b6f9620201989605f.camel@elektrobit.com>
 <9788e2a-8a61-3c76-e11e-a3f23b4d90c8@redhat.com>
 <a0ff2007f08b7a55e3aa58f1cac2b9314559f598.camel@elektrobit.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <a0ff2007f08b7a55e3aa58f1cac2b9314559f598.camel@elektrobit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/26/24 7:47 AM, Weiß, Simone wrote:
...
> I can do it this way for sure as well. Another point still in my mind is the
> superblock: I would like to get rid of the build time switch and carry
> information about lazy commits enabled in the superblock. As there is J, B, D
> and R as mode already, a new mode L or such could be added. I will work on this
> and also take a look at stuff like dmsetup to check if something would be needed
> there. If there are further points for now on anyone's mind, please tell.

Just FYI: I do not think you need to add anything to dmsetup, but integritysetup
(part of the cryptsetup project) needs to understand new metadata and dm-integrity
table options.

And I guess it needs to add a new option to use the new mode.

Perhaps it is best to create an issue for cryptsetup to discuss it, but it will not
be merged until the kernel code is on the way to mainline.

Milan

