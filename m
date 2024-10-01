Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95E63209
	for <dm-devel@lists.linux.dev>; Tue,  1 Oct 2024 10:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727778147; cv=none; b=KmM4mE8dhrhuQWy5igOVzn8KyImT9DU8HORYesnbuNJtq0r1NjjdzQ41WoI5XDxwf4obORI0cjJS9NRXVSspT+YqGY8UpBCssYslAztFxT4lvy+APlFZDqP0qkwViPfqwMwXIsREGq1p5/XiHpfVJHpg45DJMZiarJ3j5h5uMvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727778147; c=relaxed/simple;
	bh=8No/6AdEgLxdNPYPYzyV5vNRzEc+5kgkw+JfmdoeaRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVF7895mcJYGaw5VKoA46VEXlltIpxYztIKdj57MSwoqlw+IeRl21mk3MObs/StpfOTzddnx76vdf1NN4nkNIM5O1qcT1mUWCxtla3s3BhYHQY23xFf2h0GL8qbD06/Q6NHBWw2fJG4SkXTKteQasgo5T+7ieujS9QB6kD9g3wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E2EuzJxl; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E2EuzJxl"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8d4979b843so772855266b.3
        for <dm-devel@lists.linux.dev>; Tue, 01 Oct 2024 03:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727778144; x=1728382944; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6fdbRXZbFrtD1ZusQ233c57TTviJ/92WEfPKlbQoZis=;
        b=E2EuzJxl1RxWD5xWhuY1g07l4iH9sYEJZkRggnvEKpDL970/fhLlDG1TWMZBR1I+3U
         xX2HUVNMW9yEHmnEyzG6NE/W22/Uf/59hCDwRlRY8DhYKMt8iyd5crwXBbm9ZEJcmXBL
         i8G74gRmvqGntfYQXHw5vEy0c47uva3syREQgzCohMBDwGUPAXacx/Ox/NgJLVccTYZj
         cLoQIGeLDUUwKqu2eEXnKz2b55KxQjHE1cfyEClgZ5e2FHaNp6bR2IbYEbjphWQea8ng
         dtWBMOUQH9uQ02gNLIK2HByJoAM1u5VnPqCX8isMIChDIN67F6rbMPvIX6cYTjkvwFvj
         GUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727778144; x=1728382944;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fdbRXZbFrtD1ZusQ233c57TTviJ/92WEfPKlbQoZis=;
        b=MX3Yzw0807ptiukmkTMbHqqyE5hdQuFhAzVYNJKgKNTt+mPyEkXtQK7EZ+Dw95afFW
         XrvoBQP0BEx9o9f73N0X6P3u0Fzi2kfFUwFRgUzzjzjlk0Yte6lzhrMXmZWmVRK8Nuoe
         8NPQbwEa8fzZDhXgPIFjST2xu0q0G78vYfgAIMGutT2F1MdPcq/UI62Rz76of8QNevWz
         ckL8FC7aUuqY4T3hH1d+zG1Ah3C7d2PD078EC43MeU0c23RoBWlE8jnNYARw6acbaZZ9
         wS0hXnMmKA3oPsV6+TdNrJc2TucwccOjh5f0XCCjIE9z381xfRk11FMVXbclV6f8E2E4
         lKew==
X-Forwarded-Encrypted: i=1; AJvYcCVcgs+x2Z6O+5MgqFIvBY/jfMAP9Gw725XvcfN2zk49qmNwV739kCUcIBmq3Sy6FVeD35DKOILHgQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzVcsPuKiBOfSs5HRcV23CovM+eoSXMpgRMoVJg7BhEJlJCiB+7
	ZttaBNXKYrUlnH4tGBltw0FTkrZVAWNHCpypfSZcQZ7Z9SQQvf2c
X-Google-Smtp-Source: AGHT+IH9lp2adBws/qqNTsOUrOWPNc0phDMjj6gjw4kcCPecF2cCWDZpJWjc7JKV6g68NjRgPo1BrQ==
X-Received: by 2002:a17:907:9347:b0:a86:ad3c:6d2d with SMTP id a640c23a62f3a-a93c4c284c4mr1391008266b.61.1727778143851;
        Tue, 01 Oct 2024 03:22:23 -0700 (PDT)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93e49542afsm462060266b.205.2024.10.01.03.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2024 03:22:23 -0700 (PDT)
Message-ID: <f304df74-f292-41c0-a3a8-3d9db480a731@gmail.com>
Date: Tue, 1 Oct 2024 12:22:22 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Mikulas Patocka <mpatocka@redhat.com>, Will Drewry <wad@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
 Maxim Suhanov <dfirblog@gmail.com>, Akilesh Kailash <akailash@google.com>,
 Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
 Mike Snitzer <snitzer@kernel.org>, security@kernel.org,
 dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
 <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
 <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com>
 <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com>
 <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com>
 <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com>
 <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
 <1229c48a-a225-e426-7f39-465146754975@redhat.com>
 <CABCJKudUHS_vzW1G08_24JxLbSmZwKUUUtaWkFSjv6gFz6+GXw@mail.gmail.com>
 <4c6ef1cd-9eab-c8d2-a641-50a7d6994632@redhat.com>
 <CAAFS_9H2EnYwRxx+j-f9TkXKdgCN7-Lgm5p0Q-RZggJaSt2g9g@mail.gmail.com>
 <c1e91fc3-41f6-9eec-1f9f-45d89b2ec241@redhat.com>
 <CAAFS_9HyeD795N4RFKWYcP5VCFBCxmoXgGg9UbGy80Bxz7j1mg@mail.gmail.com>
 <CABCJKuedOj+E15YLZrC4nePx4g4YLO-3dzc3tyyx1S1_6HysJg@mail.gmail.com>
 <CAAFS_9FuSb7PZwQ2itUh_H7ZdhvAEiiX7fhxJ4kmmv9JCaHmkA@mail.gmail.com>
 <dfc65621-bb43-1ab7-82a7-3ab15fb9f95f@redhat.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <dfc65621-bb43-1ab7-82a7-3ab15fb9f95f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/24 11:11 AM, Mikulas Patocka wrote:
...
> 
> If I add that 'reboot-on-eio' flag, should it also restart the kernel with
> kernel_restart("dm-verity device corrupted")? Or, should it use a
> different string?

If we are already here revisiting it, maybe think if there are more errors that
should be catch (anything from crypto API?).
The name then should be different (no hardcoded "eio").

Also, isn't better to use just one flag and create something like
   restart_on_corruption_and_error
   panic_on_corruption_and_error
(that includes on_corruption AND additional error).

This will save us some flag combination checking in userspace :-)
(As I think restart on error without restart on corruption makes no sense.)

Milan

