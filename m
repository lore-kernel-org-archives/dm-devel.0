Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C2B3C1FF7
	for <dm-devel@lists.linux.dev>; Tue, 20 Jan 2026 12:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768910714; cv=none; b=tR2tN1AOM6OHR3RqisI1UVS8NgYB4dJra4Vsj1NHdGSQizLXdjZTcWjVl57JaciMTfGd3bnWJgU8Wjw2FaixYOm1N6yZ1sKbuLWyd+u8YmFUjsX80qlCcSDPvDmNXvrT5JbZhv9oAjNI/m+2kaC4qo6LHMTGviKxi8Rqp55jjNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768910714; c=relaxed/simple;
	bh=2F6wdAU5LMBvMqaNiFWf8jLWCyTaxgUHBEiPPWtt/jI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UTbtbaqCUYr8qM3nVLGzaTz1u2sYBWtCjF5nKsqhqVFCsbHkuOqHFR3hrNgcS4qrhslMzjz60R0CC+n++Nuw81BzH2wmfStVc8DbokRSpHQutfHXAmUr/+3DTrmfP8SJ9hBh1K6CVZ0WX/6EGs3nED48J2SEVFhi+MxGOZieUKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NtV17Tkn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NtV17Tkn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768910711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RImXYqyygqEKX5vqKcHBs7t5U3AmKl8mmZ8VAPIzHMw=;
	b=NtV17Tknyd32AR9CWcMEPLk1wMpiTI/I3KK+xZlxGsCx1WQptXf/AsFSV8WwzGiw5inb0s
	aX+TI3r7TFFAX1+j/9mQ76lHAF4hq1VW1T6qalwFT4xPtGwW6WdqMSi9Y786QvqCk4YVhr
	v1QWPBcg9FB7iv5R5sDPCzOaW0W5AE8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-JlKvogukNbmak9OaiX-_tg-1; Tue, 20 Jan 2026 07:05:10 -0500
X-MC-Unique: JlKvogukNbmak9OaiX-_tg-1
X-Mimecast-MFC-AGG-ID: JlKvogukNbmak9OaiX-_tg_1768910708
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fcb6b2ebso4319496f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 20 Jan 2026 04:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768910708; x=1769515508;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RImXYqyygqEKX5vqKcHBs7t5U3AmKl8mmZ8VAPIzHMw=;
        b=lSaEzLDon5BYVvsnRUfzKPms1p5wROA0I083xQRDSrHydn5uk27QrGF6bS5oWxYFjZ
         nSo3CyXnIS/VATE4x/Rd8dAIXMLbndnOr5WhUAaqEkK7zREduSZxfOOK6duOe1tH5OMU
         OAQE7E3F2DnaQrkLdFK5MQDcheYl68Aahxo/wRqhvg9xyyJNeZyul/fewLG0DneZNgW1
         65/RmyJ7x0Ql+0kzl1fDQHmpx7i0fKs+G7/28fLhikFKUCgIbh7krtd2UVQwnkr35Ddr
         S5qVA/mGxHLEkNJgeHO1/n+JbQr9ckJwBRlxZv0yAP1ZG/4uJsWtO3r4m3A9tSr+Vl/m
         MvFg==
X-Gm-Message-State: AOJu0YzxignKRclIYuINnE0rPU6A7NJX9Wh3z3+xE224q3sME4mWaPGB
	zRJhgZynvDZx1OJSr0WR5DqwzrqMEWdWUCuj6buZ0sw21zaad74fW+BdYToJMTzSqzkRJuAtn2L
	rlJTINTfHuVbV7dWGwfR5cKxpTZCmlrcvy+ggVLSZ5mSbzopuautbUp4wW+0=
X-Gm-Gg: AZuq6aIlM6siAiC5dxoZ/U8HFAjDvO2k7vZgGQldOiHkGyjCXD8CyUBdBbAq8QtIBkb
	Q09BUAmbqQnFHJcnmt3oSvq9cb3PaRI4ZK6ucafsrwiLwWaGndVA+sJypwlfWp4bEjl8K1QGTLv
	cChoE/kMaXwDyrS3k3VnW7PUwTpB9LtBnqHkkhPnCSx0bqWRMkUmIwgV/nXgBt7AqpPGXReczJa
	/SPCLQuoMDoGFpywfdyk5JHOuE7E6+VAYQF4bbKqoDHTH7dG8EC3LzWeoMK1s+ElgutMARn/7MM
	APD2WCuvMIMMaGsL9wSXdCycoVl3oRp3PeW6KUoJ7UOl33DBN9Acjqp0dXr8R7stqgqhdLrLRlM
	=
X-Received: by 2002:a05:6000:2f82:b0:435:8f88:7226 with SMTP id ffacd0b85a97d-4358f8873ccmr2767123f8f.40.1768910707790;
        Tue, 20 Jan 2026 04:05:07 -0800 (PST)
X-Received: by 2002:a05:6000:2f82:b0:435:8f88:7226 with SMTP id ffacd0b85a97d-4358f8873ccmr2767080f8f.40.1768910707414;
        Tue, 20 Jan 2026 04:05:07 -0800 (PST)
Received: from [10.43.17.192] ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996dadbsm28954880f8f.21.2026.01.20.04.05.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 04:05:06 -0800 (PST)
Message-ID: <f71a1b56-c446-4c0d-b873-a0bcfe14e2dc@redhat.com>
Date: Tue, 20 Jan 2026 13:05:05 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-integrity: fix recalculation in bitmap mode
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <951dcc10-c271-a257-84d5-81362e81e2b4@redhat.com>
From: Ondrej Kozina <okozina@redhat.com>
Autocrypt: addr=okozina@redhat.com; keydata=
 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
In-Reply-To: <951dcc10-c271-a257-84d5-81362e81e2b4@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8oc4_4ytIOLanDOZqPW4ZrWSyNbNjReGko3HWBG6TmI_1768910708
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 19/01/2026 15:06, Mikulas Patocka wrote:
> There's a logic quirk in the handling of suspend in the bitmap mode:
> 

I've run cryptsetup upstream testsuite and also the custom test 
triggering the I/O error after dm-integrity grow on the patch.

You may add

Tested-By: Ondrej Kozina <okozina@redhat.com>

O.

