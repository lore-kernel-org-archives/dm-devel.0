Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B236426D1C
	for <dm-devel@lists.linux.dev>; Mon, 18 May 2026 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108588; cv=none; b=LN1N0jX2IeLsxeVepqsStAQU56zdU4t0RO3Zcpsh8bf9oTD/YulxXBNz0VuBVLvr6O/wTimjPhP5W8phmwrnTtd8ynmyVvC4gOLnc1Xhp5qoI9xyUemskmCv+tLJut1rUHpfpR2fOW9t1tJGvWvmocavuzfxPUA4zR6eAYVlma4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108588; c=relaxed/simple;
	bh=VX8+7teOpuLOnW4ObAqFfBxsvvas9Rw3iPUKhD4heaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aLpVXQ+K94eQ7FIvdZTAV7RK0T/lINNU8Os6vDhPnYDmN3YiJHO5rwlW/awDJLch7PBca/RGlp9jexCIk4/Kcpg6Fxo32HhDrNxt6ypBGRd3Mz5kNld3Pa37gO4ar/dsqfuYDu3bHez2ggWQVFglaRORhs7c/Kvh0ZQ6Olall10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bVAX/Vg2; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVAX/Vg2"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45e6a4d0be0so803000f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 18 May 2026 05:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779108583; x=1779713383; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bLINeqKl/XpuS1gQDX5t3BFzlGZzG1IUU9h1YDvpHyU=;
        b=bVAX/Vg2OjoqQ0UYFSizymgtuy2Etb8CKCrvfksFKh4W6gvbS0A2wLjBQB/qJXsaYP
         MqH/t5CRhk1iVjQFL4GsAtC1xXYnJLTxIWJRXosYuUgjYRcm6KxZrWmvZSvEHdC2sbNO
         4CTEB8nzFvsvTThdmQbpbQB0ePbvDUJpGHthlStWjyVQ8ElItqwNMoJF8DeTiT+/pjZ6
         2LACcboTI0A15EKzxeKu7Ombd4q+jzZw4bQf35jVR+rKnSgNS1D0JyS8bFIGR5BLkWeG
         ae7YKF7ZTFtgrZWYIHS6o/zSLbsjnHYs4HVrFgahP5i1IOpHvJe0k/tupZE2lPK2aCq9
         P0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779108583; x=1779713383;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLINeqKl/XpuS1gQDX5t3BFzlGZzG1IUU9h1YDvpHyU=;
        b=nFa7yHAYLJa5PRN7SSzf4oJ63RvyPsglSEJwUtDusxLmPSGAd+uqxhY84wvS53sTLQ
         70MSJEHIZySUMMqUzjZ90sj/rgzgjDKZ+J0oNGIhIvAol6XbcGJ9w79BZooHJr0kNC4+
         3UFCaNC+6VCLSTnaVqaDFouHtxPMydXlZaVRWmXcoQ6kLyXP7tve/gdr7GTtpvywxoEM
         RrpElRBBvYARQS34davlfvCewwWKhdcw4u1FWWDEWZ94SQ2xjvXOpOy6o8bHYd96la+w
         A48Biibw3UXnQglLAA4xCPvXvYTTadKpY7Ec7iUlgUkqVBVbKNIheuOcROGAHgelVEe7
         xeLg==
X-Forwarded-Encrypted: i=1; AFNElJ+i7ai5LyxnEdkZAxHCQcHQVb5QytN1OYfQKw/m3phPPeAHmbsW9HqLPFKP26/aH605aTxNBsIucg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyfil6E+d1LYvMsaOqERG9TvG+ty5QTJyQB1N/sAg+A/l9U+1o+
	VjXhYGPfOAHuLz/rEBNR4M5rWbwbhS0niAF0P3TIdm9GV1gLO9RLmKlD
X-Gm-Gg: Acq92OF5E5S1dPGO7+6lpBkFutFk6ADFMYlfH9j86rk3CjSDR9Cpj805HTLBIED/PFF
	uip2RwtWTOWazv+omVOgMt6X+gvVxvBAv7YW8Fz6rlzI0UtOxI9DvTeriNcHMjyxkLIEBTlp8PL
	nu3KLwvNFZLmWWAbVcIBtmoGVrg5kaVNF60vnAGUl+F3uMFnYxSb6+wQm57gl0xWISMDnqpM8xQ
	djaxnImfy91I423KT7WnXAPggc79p8yXHdNU2sNyNI7de+b1VgsGY8evI28Yvk0oQgfQpoxzVqn
	hERPjVLuhqMeZ1Sd5tmpl7YKYcjsoL8wbG5ImF0deVPRE1eHaJEOqiJ9CBYsME1d5uwTCvybGdt
	zdZ7lAqGJyv3yxWrLzynEv2JN/TDbSmmKO2rMQG5WQpTCgaW6ZYyGacVZp+l14/NIhAcSNhHwzM
	1d18w7sIBDlRi7CuQg/ONrncKWoqzx5RU10wygeJs=
X-Received: by 2002:a05:6000:290e:b0:43d:7b90:fa23 with SMTP id ffacd0b85a97d-45e5c6019bdmr23079609f8f.29.1779108583125;
        Mon, 18 May 2026 05:49:43 -0700 (PDT)
Received: from [192.168.1.220] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a19c2dsm38266667f8f.21.2026.05.18.05.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 05:49:42 -0700 (PDT)
Message-ID: <98f9f0e3-964d-414c-a329-254c141c8d48@gmail.com>
Date: Mon, 18 May 2026 14:49:42 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com>
 <20260516115045.3958326-2-linlin.zhang@oss.qualcomm.com>
 <3b57685a-09b4-473a-8810-bbb46769ab42@gmail.com>
 <2712f864-0f68-4428-9ba5-55fbf35de6e8@oss.qualcomm.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <2712f864-0f68-4428-9ba5-55fbf35de6e8@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/18/26 10:11 AM, Linlin Zhang wrote:

...
>> IOW the mapping will look like this (1 is number of optional parameters):
>>
>>     <cipher> <key> <iv_offset> <device path> <offset> 1 hw-wrapped
>> or
>>     <cipher> <key> <iv_offset> <device path> <offset> 1 keytype=hw-wrapped
> 
> 
> Thanks for your suggestion!
> 
> I agree that keeping "hw-wrapped" or "keytype=raw|hw-wrapped" as an optional
> argument helps preserve compatibility when switching from "crypt" to
> "inlinecrypt"

Just use semicolon as separator as Mikulas suggested.
(I mixed that up, we always use semicolan as separator.)

> My concern is that, in practice, this optional argument may effectively become
> mandatory for certain configurations. For instance, "hw-wrapped" or
> "keytype=raw|hw-wrapped" must be set for a wrapped key. This slightly blurs the
> original intent of "optional arguments", which are typically expected to be
> truly optional for correct operation.

It no longer works this way, it is normal that in some scenarios "optional" arguments
are required. For example sector_size - once you use non-default, you have to specify
it always.

IOW no problem with that.

Milan

