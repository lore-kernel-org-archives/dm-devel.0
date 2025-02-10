Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3204D25757
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206971; cv=none; b=g//R3eLuIoLkfkcQ456RjJeTkfirzfdF4HyPQJDxmyQvltxwTAYwT+JpLwbX4jQEX9THAk2AHS1oHHg7+c8CPIp1n3he/w52RAGA+5g8FUBz6BKoPlehqNJK7CWvaYMA6ieGmE8ktsBnlcWu1P7wOUagKIyzv7q5h+7cxxun7ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206971; c=relaxed/simple;
	bh=sHeKBwITI/MEWY5j6bjlXAApniWCuiBQN04w+CURhH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AuvNiKbcBpmeW9ZPSibgFQE65EFOxgr9WXtyYn+Od8tvGM7mj8cEKVpATf3+GOF71wpwC2ey6litqwvF2oDQrcC11ag60gbYqj6aDs520xVRjeDwPyqA8oGGN3q+B2wcF2ZOjcfy13l/uJ1AUAZgFk2cuXd43zGGU/pHF9EKL9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OE+NoiRx; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OE+NoiRx"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4361e89b6daso31840285e9.3
        for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 09:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739206968; x=1739811768; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RzpKC2iXm0ClTekoCO1qzu8dUpjE3YBEUPoPGH/E638=;
        b=OE+NoiRxH+SamfzoG0Wlvlj4Pgc41zJ4USow2N7Xyx+AlUE3oTa4NnB4GDqTsc2vOI
         Wqhd2YCBCxXqsvFkPvkFt82YST2simbXA6/iLV7dhSNyEdVLLgs76VA/vCBhu4Q2DNOt
         U+qIkrLNOQBZAy+YVgaFFc6lLESxIXWuOIKHvdGjY3dhJWC5j4BRwlvjC1E/Mhagr2e0
         Q7vlhaeFKnD4FQ/ox1jLiCUSEo/zo0K4FcyCUqU4tD0qzeOUmuBp64TcT0KJ+B+7qqMx
         Wc//JHV6hlRsnVa5qyOoFS8EiV/015PANIyAEBk9ZCJCa/DLNE1uteLkpQY9BfsRKDYq
         K/bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739206968; x=1739811768;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzpKC2iXm0ClTekoCO1qzu8dUpjE3YBEUPoPGH/E638=;
        b=cMWUcUL/07DJTd7LXjCVYwdSxUNyTfurXCPLrdj8DrGFXmvYV5wYfDdxP9Fm0cpAfa
         Vbt/OYuhoeqcsAjYWyvtV72eQfAzB8ZBG4xqkqcrKRi9DxdDzeMrfIodpshWWDuRNXY0
         VdT8XIDRSvWlrfsfwD0qgbL3arRNMjFwilYnSCpzX+C6sDJfSHsU0R8keavqruR0u7MA
         KQtx1ZZ9HWhSYz7ocFkicra1qsjpqiS0fMvTjGA7EH9QzsmbEATIuQ/wOpqrWp8AIOiF
         2h55IB76r4wmMcq09BPxIZ2RwyNSrEirpJuphT8Rmt5xArx3cdIbrgySNU8tsI+fRKRH
         Id8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSRqUa1L3em/a8Be24Cmes2xgaFzgvvFCdcXyXoYjGeOJnmCvbkKF1XoH3PjL9chenb5IuGPHWLg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwcvKvTL57InsCxtKwE8eg7NDetGB8qzOWWsrF86tZYFG8rdr82
	83I8QQSaW56XYCyIRxX9i/47GRuoDmQurUUpFLME41BlCqUf9D4N
X-Gm-Gg: ASbGncuUbBbtE/9v+p3sDp5Jeo4mPdkT03LgOKDA/3b4Qm6jr7VUXWwV2/PaGCVdnZu
	uZUvfyotSjivtOdgaNBeNRPCoYpG7XDt7t4nJAEOcMEWfgwbVO59kD5nr/g2Cw79OiexwQQdBGI
	oxCB/jeUUM9ql0VJVzCsjRJgnDW5qSCJxlHXk5eQDlZHymlaPjOg09se4MlJbNgBdQcGfDUnQZD
	3hLAhWw6NbMmuX6XJxdvwzRB4vGZdmO8XUKRnxFzUXG7l+f3iL3Dt1IEu9zVN8QZVjsL2TaRBlo
	N8reTgnGVaU5pillJqvE3Uyo81pm7+tcVCWwBuJK
X-Google-Smtp-Source: AGHT+IFiIvJd+Q0BuCQpISfzWLDL2OeDYY2P1G3F7g/SVCCTYBHlcRvmy1rrJnofni/vQpT5zk0Wug==
X-Received: by 2002:a05:600c:1c25:b0:439:41dd:c066 with SMTP id 5b1f17b1804b1-43941ddc1f0mr54759585e9.31.1739206967637;
        Mon, 10 Feb 2025 09:02:47 -0800 (PST)
Received: from [192.168.2.22] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcb22f737sm9823697f8f.24.2025.02.10.09.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 09:02:47 -0800 (PST)
Message-ID: <59961cd4-6dd6-45b1-938f-faafa45f568d@gmail.com>
Date: Mon, 10 Feb 2025 18:02:46 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
To: Mikulas Patocka <mpatocka@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Zdenek Kabelac <zkabelac@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
 <Z5CMPdUFNj0SvzpE@infradead.org>
 <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
 <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
 <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
 <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
 <00717ba6-0ce9-5ccd-d93d-ce5db89d85ff@redhat.com>
 <yq1cyfxdsmz.fsf@ca-mkp.ca.oracle.com>
 <52b66f23-d8c8-1344-6fd0-277dfa31ce84@redhat.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <52b66f23-d8c8-1344-6fd0-277dfa31ce84@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/10/25 1:54 PM, Mikulas Patocka wrote:

...

>> Can you send me the output of:
>>
>> # sg_vpd -p bl /dev/sdN
>>
>> and maybe hdparm -I too? I'd like to see if we can come up with a
>> reasonable heuristic.
>>
>> -- 
>> Martin K. Petersen	Oracle Linux Engineering
> 
> I don't have that USB-SATA bridge that reports optimal I/O size 65535
> sectors. Milan talked about it, but maybe he doesn't have it too. Some
> user reported that cryptsetup behaves badly with this particular bridge,
> so Milan wrote workaround for it in cryptsetup.

I think I have that adapter somewhere in the box (I guess it is JMicron thingy).
But the change in cryptsetup was based on several user reports (one was
https://gitlab.com/cryptsetup/cryptsetup/-/issues/585 but there is too
much confusion from my side :-)

We just added a rule to ignore bogus value and stay with a default
alignment in that case.

There are some links in the report, though:
https://linux-blog.anracom.com/2018/12/03/linux-ssd-partition-alignment-problems-with-external-usb-to-sata-controllers-i/
https://bugzilla.redhat.com/show_bug.cgi?id=1420935

It is an old story, apparently.

If I see it again, I can send report (or even fix) to linux-usb list,
as this is really related to USB storage driver (AFAIK).

The code below just simulated what the USB enclosure presented to kernel.
  
> You can simulate it with "modprobe scsi_debug dev_size_mb=32
> sector_size=512 num_tgts=1 opt_blks=65535"

Milan

