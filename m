Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336353218BE
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 11:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757418444; cv=none; b=ZeWS5Mxx7EwC490g+v+zUcdst1VsxQIGKdwgRo67xxYIZ+u8JO3rgKxQ88Zg6TfsGhzMLp3Sdg+nQUiCS4sMf8taK67yLMtY/5bfXXRLcZWPNF49BgfFJeE5+CpRnpCKPjSlvSZ3bbFNKF5LMLewF9+83KpwtA4QPFfQ1g8f1V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757418444; c=relaxed/simple;
	bh=AK81ttMRJkjVgQAQfhffdHNnm0Wxng4pupXNCYzY+pU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAZUEo0Wi50e2WMB6k9TWkQNFBX2dcYG5eVJ/GJffrCQQCmih8B/0o/jKd3nC7wdsxJMkdshPUmAy8SkjE9IB9o3Xlc0bhdKqATDksVZqBTjkmfcFVYUt+QjC9p8htbyANVmQtU6ylgDXjnCYp/zNULoHjr5qKk2TKr/JTfyiIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bKB2Bt18; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKB2Bt18"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55f7cd8ec2cso6871886e87.2
        for <dm-devel@lists.linux.dev>; Tue, 09 Sep 2025 04:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757418440; x=1758023240; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s/sj0gwdntylgPmORPk0KCu95OOgGMaW8TiolxV4Afc=;
        b=bKB2Bt18VddLgevAarEbcK98CTw3Csc8sG4tpqjlv6HJ3LXZMnbp58ijmsDka2imw9
         LSq6hQm0J5fpPLqrlAMcOOJscPx0qLhzaRTXbBEBRsx07LnmIQjqEkdBqiZhu4/mHSVv
         l35d00tntEYCgIO4ZypJFkiaTa5Gn50Ytx5KmhZv+b3+64ogcgNcHCWr+R093s7qAEhw
         0E3+C8z8H7rfi+b+GQWNR/T6C8Bp2Hjp0bqgPLcCkjy985mCwZ9RdnocTQccKtXONBxk
         gofGV0lReZCA/S0wvnKi8LI3wYfUAVjXe9XsCg2Bmb3JTxhAWU3cL0U1AASirodzqB8v
         S6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757418440; x=1758023240;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/sj0gwdntylgPmORPk0KCu95OOgGMaW8TiolxV4Afc=;
        b=w34Ecuh+KlYgiFFQ7YhZU+gJ0lp36dBZIbWJs54drxIkvWQwywG9T/gVs/oqZA2gF6
         1fIJMdIn0CEJV6eLFVxyIW7FeKPJp+w5cXDGYDZnfbeaTe6jO/9ZqlRQSmFd2m0FunBW
         YkEXRrWPJLntapemg0wd8OIFkJ1eL82TFG2hcy337A0NwqGTWOBeJCLOPSjMPARMk9Hc
         KGDH6gmBI45kkVQQKOC/4fYz+Efuv/7o+MqT2gVpZDF9dMNHQFw91lS7yzysaCla6AY2
         L+lTUlfgtkLObyz4+BYGnzUs8Y5qFD4UFco1cceHe9avOwTt87QXCmnOhoY0q5OrZ5+U
         CjiQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9MyfP1p2D4ZmQGWRhADnHrUV85x0CmXA4aJs2T7vPHi3gGtDgRFcj5mEMtQiN27nkUUPwBhP1dA==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywh2hDht0cuS+7iLigRgbQmC4pTk6xptbdnaSwTgE3UZG2SYxKh
	0fsvdfb8wTIjO8PQsLEjT8q4PRD6sXCntS5Y0B5XXGM1k7dBia7QyuF77yvrpFLF
X-Gm-Gg: ASbGncvG15nOy9saRWO9cEZUEzetlCeiTo+W0o9Y8+bGbCWw708Aa/vzhIA4xS9x8Zb
	ZZx2QCCJlFtaZCK5tDMUBgy3ykKuAVtROPQpFyGkFM6sJ8Ruvx5dmfvjUAT46MVLgdMgDrw1nno
	gPK7ytGX0ZOzBDQ7YVkojXYA/J/HCrG4AjGagYg5YhQE0MzKAYx1P8NoxwLjevYqhLDlRUzRSVr
	GG35LPbMHItIBfM9gH2/kxhYOVC9IvcyBOXd85OGYFBG444on/UIevZaW2m3wx+z7fUinVJyIdc
	4d/i3L/gAHo9kwaH2hzf6n8jHE9ojdKufFGohWXdPbwS2oqZMuB06ekbQpftDDisMO2zT4we7xP
	qs75rFJH4fmw59q/eEZE9oMd81RO0
X-Google-Smtp-Source: AGHT+IEFU1vIIjZuXcg52uYPdAMiK2YxWCTGZtXOCPKb3QoPLzNmYdqrswfp/AQgBMJZvEhPSurXRQ==
X-Received: by 2002:a05:6402:270e:b0:629:949c:a667 with SMTP id 4fb4d7f45d1cf-629949cb089mr4633741a12.31.1757418428278;
        Tue, 09 Sep 2025 04:47:08 -0700 (PDT)
Received: from [192.168.1.236] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62bfe9a01b1sm1195390a12.5.2025.09.09.04.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 04:47:07 -0700 (PDT)
Message-ID: <3184e0b1-571f-4cf7-94ef-acca41c12b02@gmail.com>
Date: Tue, 9 Sep 2025 13:47:07 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] dm-integrity: asynchronous hash support
To: Ingo Franzki <ifranzki@linux.ibm.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>,
 dengler@linux.ibm.com, linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
 agk@redhat.com, snitzer@kernel.org
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/25 1:18 PM, Ingo Franzki wrote:
>> Please, revert my patches and run the same test on a clean 6.17.0-rc5 just
>> to verify that the patches do not introduce the bug.
> 
> With your patches reverted the combined mode fails the same way as with your patches.
> So they did not introduce the bug.

Please report it as cryptsetup issue with a reproducer so we can later check it.

Thanks.
Milan

