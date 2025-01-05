Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7D7A29
	for <dm-devel@lists.linux.dev>; Sun,  5 Jan 2025 20:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736110451; cv=none; b=NG8kHM70oxS60upFPLMIut0mnVWpRelD+tJDKF6HIfiT1vsUfu/yf32kD6X0/hyaztrOCfiLn+6+OwptgLW6sw1p5ORrhctO685WsUIskEdgJncCi6JDAuRApd11PkAAaQ+W0IZ7PtBvoi9Be96r9AEWBWwiYov6iElySZxRcfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736110451; c=relaxed/simple;
	bh=gkCPVwthd0rXE/crmBf9WZzkX8CCIIcc7MS8YeAvfiI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fbwDauf5yrbUGjj1DGYYdWYbc1e4cX4EKFMUc23kBB2MYNpZRZBk7GCUrVoRiR6hXoC87COQKv4GTmG/XJAM/5xc7MqVoJwVx78IzaFPa7PQ9PXI5aBb3vucxQKzSoqkT9IXkaK6nGD6IkrWg0p3v+pKZXDR5IO87LUNzEqDjpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S7Wz0AOD; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S7Wz0AOD"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3e6274015so24532665a12.0
        for <dm-devel@lists.linux.dev>; Sun, 05 Jan 2025 12:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736110448; x=1736715248; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YzQgJ5yOTiy2g9pht2qzz0PODwie6lH1EyHoiKlLxqo=;
        b=S7Wz0AODnDFBcXTp8epxaru2C29PNLm5RNCD4ACF4q9C92ovXb71iUIFfRYJrilwxg
         1GbCsGGOOZjj85hdK2NXRUMnMGSB+IUm+83rEV15lU/x/RjT0SoQoACekGk32bzCTBZP
         RSnxD2Pmt+0Ol78kvq1oljs+xj0U4slmhyXe9/B+grakmbb2GeR4BpvkJ/ptihnwsDHQ
         7lnwyeS06k3Mdp9upwGapi2jA3kUUXyEGDFqvNsADqw9W8sKPDJvFWLhXskPZw6fwqXm
         tk8I1McQK0HRXOG0K1iByn2b1R15jQ1e0UPBL+xrgeKnEFnAtxTaLOePUFnHg96hGAvn
         F+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736110448; x=1736715248;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzQgJ5yOTiy2g9pht2qzz0PODwie6lH1EyHoiKlLxqo=;
        b=OZyxi0EUvwLkk9yGszPVer0shZgzuby7MRDZF+dOPN809tsrOTS+lEqIYWIvTwpdki
         Fw26BPbKk8Byc7KXvKfSMvN1CwO6XR5lnS9ikxoPiRmzr6Wu3EUP2XqVsHTPTzsZ9k7z
         AV2qYDCC8aAvcoITXRdaDNlNQ8L9YKhzTCBGYwLKmH39BcPHyCXxbHgSsVnBqL7GD9iU
         2L6N0UFHEMnVU+l49jlynDEnKKr5H/b/WHa+ir8N9/7pDzliVso/P4a83HkM1DoZGXAt
         k2CDaAbCbm4c9Lr6aTbTByYGFyXkWRO5pzrHvIcANSXY+UriLUXBFf40kMeAl5fKpw2A
         Ecnw==
X-Forwarded-Encrypted: i=1; AJvYcCXqvs6nj//im+cBL6xux9F5mEh9pjFK3RPphkHg1SI9Ov2ra9tNYOTm91jqFEPAvqZY+7WkU8rPVg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzXHuvM1oyaAEpkH0VJEJBqT56MXA7DbexoRA/Cb8uPnsYI4UYL
	DW77ElVUuigUhi4unPcpkbEoZRlgVsMS/Epownt+eyhYaSOZfvzkmbEaWA==
X-Gm-Gg: ASbGncs9I2S1YmHMk2FXhy2PMsVNCEqF1JHy1mKeylCDBegcUtXqA4TCyKqzOC1k33y
	Gr2JCDEpEtosDenOT+8HoQg1y+sxN47JF5JIkJ7SCVKKGaeO2/J2EvG0g/tJbY29AX1MrVY9xsd
	ZfMSgTSeEc/Ix6JmuG+U6BTmz0aHLypS7SFeWBfAwSaaUz4YarpFjezKmW+bdcW59/BK9Y6VSnl
	i2znDDn64BeSJ3vaEaWlrCv7C4J6tqgF2T50dDQpEPmmOq3tXBztD5iZhM92ZPibiELiewNraD3
	YfFAjg==
X-Google-Smtp-Source: AGHT+IGaTUuCSLv6QhKKMsuaz/EyNtMrBzSEqlbrqhXOyD2wjrb20aNzynsC82kMXdlOiL3V6Z3wQg==
X-Received: by 2002:a05:6402:274a:b0:5d3:e9fd:9a15 with SMTP id 4fb4d7f45d1cf-5d81de2dc8emr48086589a12.32.1736110448027;
        Sun, 05 Jan 2025 12:54:08 -0800 (PST)
Received: from [192.168.2.22] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679efc9sm22088974a12.47.2025.01.05.12.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2025 12:54:07 -0800 (PST)
Message-ID: <4351b4fa-2558-4b73-8604-81a4b1eef9dc@gmail.com>
Date: Sun, 5 Jan 2025 21:54:06 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [discussion] proposal to bypass zero data for dm-crypt
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, Yu Kuai <yukuai1@huaweicloud.com>,
 lkml <linux-kernel@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <73152f2b-2a3e-37a7-4578-9a4ae7ec903f@huaweicloud.com>
 <3181bbd4-40df-eecf-c9b2-45b09018b8af@redhat.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <3181bbd4-40df-eecf-c9b2-45b09018b8af@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/3/25 5:25 PM, Mikulas Patocka wrote:
> Milan, what do you think about this from a cryptographic point of view?
> Does it make sense to add an option that would detect zero data and skip
> decryption in this case?

It is a very dangerous thing.

Disk encryption is a length-preserving encryption, so it cannot prevent
decryption of modified ciphertext. However, such ciphertext modification
(without key knowledge) will cause a pseudorandom plaintext output
(IOW attacker cannot easily flip bits or whole sectors by ciphertext
modification).

If you allow the zeroed sector to transform to valid plaintext directly,
the attacker can wipe arbitrary plaintext sector. It can lead to fatal
issues (for example, wiping filesystem metadata bitmaps on some known
location).

Stack FDE (dm-crypt) below the filesystem or other storage layer
(like thin provision) that supports sparse data, and you will get
the expected behavior without such tricks.

Milan


> 
> Mikulas
> 
> On Sat, 21 Dec 2024, Yu Kuai wrote:
> 
>> Background
>>
>> We provide virtual machines for customers to use, which include an important
>> feature: in the initial state, the disks in the virtual machine do not occupy
>> actual storage space, and the data read by users is all zeros until the user
>> writes data for the first time. This can save a large amount of storage.
>>
>> Problem
>>
>> However, after introducing dm-crypt, this feature has failed. Because we
>> expect the data read by users in the initial state to be zero, we have to
>> write all zeros from dm-crypt.
>>
>> Hence we'd like to propose to bypass zero data for dm-crypt, for
>> example:
>>
>> before:
>> zero data -> encrypted zero data
>> decrypted zero data -> zero data
>> others
>>
>> after:
>> zero data -> zero data
>> decrypted zero data -> encrypted zero data
>> others(doesn't change)
>>
>> We'd like to hear from the community for suggestions first, before we
>> start. :)
>>
>> Thanks,
>> Kuai
>>
> 

