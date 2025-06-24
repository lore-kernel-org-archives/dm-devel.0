Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0627926CE15
	for <dm-devel@lists.linux.dev>; Tue, 24 Jun 2025 16:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750784374; cv=none; b=ONLto1hoxHHX5r3JCggQLmpuAF4eQ7uRJnL2CACEcRjnISsMbAoFobh/zn81/532lqVw5OHrkV5vEwJLSi9dXBvh49/2AqRl3k9Tptbf5XYgQjleZKT72gDQEczk5KdYGXedcn58mBBasgbNtvnRVjNtOqc7INEGfn+qCxFQP/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750784374; c=relaxed/simple;
	bh=YmsbocVnIlhfSaNjW9qsOsI1HiD8gvJ/Np72MfmeELU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TjZB9qYLHMPisYL9v5ngsnxcYjeyji2uy3IX6q/rFKnhbLBJ+xWCPGgEZFMMdj5ygwt3F+p/Xwn8r5K8b0IlxDb742BwowpiPTduXG20i+m2nzAfKETScCqJOXS/LspUljdajrZhUk88keEYsDiVqoGFMvaS1smIa1o6pui2lFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e/zXbKlN; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/zXbKlN"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6088d856c6eso1353532a12.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Jun 2025 09:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750784371; x=1751389171; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qLvCI9IlKlBvbuZFtuXzcwAeH/KzwYDiyDeecJEoUqI=;
        b=e/zXbKlN2wHhTsoWV95lxQQC1xIPPkNs11YqsjJiH6K2967MkeBSYtUxXZuHp6gAPY
         oFptGiTtgcIy5HXme3CFpfLWFou7qrvckHsVmx2oifwA5tXIs63n0/YqOxk22cH4Phv4
         vwe3FXfSNOcls3cpHoExGOEHPbsjhRfaUsCQXW31wTnbkLXCt4NK6gttoqHLATteEVAu
         +tbt6p6ptS2I2Z8nurXPFGhgd9TO5fc7NZ6lEM+iOGbcbNgEU/k3t8O63jf0C3ZY+YFE
         L4AGGjUXeG7RocsXekzEzVB2ADLNgY9r1KDSDTn/2bYSxcOYp5R+K7ARZH+C+xXgD9aJ
         A0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750784371; x=1751389171;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLvCI9IlKlBvbuZFtuXzcwAeH/KzwYDiyDeecJEoUqI=;
        b=XYnzcAT4ErxCo4zuyhAdqieAzdEDe1IvkdRF3l1gidxtJMsAY9XN+Wxer9Q09yzsUX
         rcinNZwCZzFLyu/h8FYvI/uKyfV9CK1mvdJkLfN4/SX7k1A2DjN61RRGCT/3u7mWTVuN
         FUl00Zz8v/KIVx79yGiWritE6bmQYTrt7rzUk+otoNdFmC8sbOTqXWmbs7pFwieZBEXm
         seda6NvUsLY4kejCFwlzC8jYBrMUQbfCXGF3VsKXjsMSTKXb6VtpZHaRM4EfPvRlajqR
         w4CIAkNZrK3H6EOI5JJNoNMYLqdo5YxJvJ/4SHlEio2PvA/FOhFQzDqFRofBL5ZGgWVV
         qNrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/vEUebhYhbxF1alnz1V+0tHpwMrtqnsnGazrKHdA/ctPhAb1NNcPCxjPybQuz5CFjUUmsaC7JBA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzdWUzyRJx6wLgc0A3U7MvsxaPEaftMtVJeb8CEUeBmvv8QzmWl
	gzLHwE7ILip0s4T5jKJeRqT5ckwEbQSeCSdsWU8O05kidgZBaR52Pf3CUrHWSKdKpoI=
X-Gm-Gg: ASbGnctriKbn21neRMehmcBbJKAm3HbRe7a8fRxw0WI6YdcdjfFKV+XN1Ohk/z0IiiO
	XN37b+DjVa1fY+XhqdjdfUJMopgbKgi0wXm/rJlhVi/VcDML7itWbXXpBOqpeLHEaItoVMZ0KB2
	faNaghIYXbxy5CJ7lxRZ+zT2lskwzuguThPkaaCYrRiesvfpiird/Vw9JX+8t3RvvnwXK3bdsep
	6vdXehfrgq/8tux4KJleeZ3Y+ur2EVa3GET//pI3jKd9EYxGSYEg3EyFpIMWYXJpmxq5ESDHbuz
	0u6ByK8Im7k6FexGSl77j+cZNDnMzGrDdOcMp0bh8mOy9+tMS3Yr8MzIPlR/RUmWUV8d+Fb02aB
	OY6YSPwQSORM=
X-Google-Smtp-Source: AGHT+IFyMnDVOnSBJq5hxAkT+GdQQ/918SMwMPDYHC8c2sdpAF41UArKDafYENUdD33P9rYphhvQ5w==
X-Received: by 2002:a05:6402:2694:b0:601:89d4:968e with SMTP id 4fb4d7f45d1cf-60c465ae802mr270636a12.27.1750784371049;
        Tue, 24 Jun 2025 09:59:31 -0700 (PDT)
Received: from [192.168.2.22] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c2f1ae6d4sm1307156a12.22.2025.06.24.09.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 09:59:30 -0700 (PDT)
Message-ID: <20eb7dd0-5f81-45b9-bcbf-83bc4510463a@gmail.com>
Date: Tue, 24 Jun 2025 18:59:29 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-crypt: Extend state buffer size in crypt_iv_lmk_one
To: Eric Biggers <ebiggers@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>
 <aFTe3kDZXCAzcwNq@gondor.apana.org.au>
 <afeb759d-0f6d-4868-8242-01157f144662@gmail.com>
 <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com>
 <20250623182238.GA1261119@google.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20250623182238.GA1261119@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/23/25 8:22 PM, Eric Biggers wrote:
> Of course, the correct solution is to just add MD5 support to lib/crypto/ and
> use that here.  All that's needed is a single MD5 context (88 bytes), and direct
> calls to the MD5 code...

Feel free to port dm-crypt to this code once MD5 is in lib ;-)

(Use of that small context was what I tried to do initially when implementing loopaes-compatible IV in dm-crypt.)

Milan

