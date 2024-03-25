Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C94473167
	for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 22:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404811; cv=none; b=NxGNo7K3HXRymOVg+hi5XQM8weeYpTiDtAjPTgJMflC0NSYYqV32c7YbRzpODrFJyHSw7dbJK3ll7+aUhdjraIXn3DoBS7PNqke9sVS/cdCeE2/qFr4hN/mELnO5rvHZ695h8ZgKu4My2E3qdP9OPTopT0S2OxC55OMRhjM+YQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404811; c=relaxed/simple;
	bh=hN55zRuf1wTWfhOuZ1Hsv78yTqllTTJ254BBca/qaQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cG9XUdwnJupOtS/dlKlg+jwgrSekMBFcvavfscmNtDIkxN1+TPUf7/9zaNHsNzp721m2lMH1AekgtgTA7GjxqP30HbCHz0UA83dZaqsfHKmfqjm2RjP5wQ1b0+gmvqp9XFGyoHZh3cryyVmYaVsGQ1AOcGAY3hGtC7dR00fsbNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e0000cdf99so37974615ad.0
        for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 15:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711404809; x=1712009609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zuN0euwq54EZtcjYVhfgSHBS8X1ggoE7zpwJRA9IdAU=;
        b=KF11ZmZXGbbzGycXWBm8H+Setzm7esgwO5S48GlD8pvKR0Yb8+i7PW5JgPHjzQsKq1
         DSyOBHX/MRMpKd4rlpD1qsZtx25uEjurgCarKpgzVVBfRa4XhJBDEni65xH7ZlZtYyp4
         Sa8sHEqTo1MIY7DQrmKqnGrYWh4rF7LrM/G6423bplkhHX5ccVg+C8pLFsLvtumdcFb8
         Gbsy1i1xnvPcY+LH3JMFCxwADlDAO+dxrtkkUxNwcJDEXMtARdv4rglkt21UkBKJM8Fy
         /yoeseZrsQLF9M3nsmlybEO3dx4KEBKtRWpAcMlyrM1jK9DTCcgvoIhc0Xh+UBFb8/wP
         BcFA==
X-Forwarded-Encrypted: i=1; AJvYcCWYzx7n9UIg7pkO5kBtFQy6DwSXdzb2e8KqWs9jkz3TlArzuUR2pITsaTO7sprWA0+7qyqqFy1+2H3N++jC9R94SQFuJXA5AMs=
X-Gm-Message-State: AOJu0YzWR4floHuPSV5U9X+NcOWndKWZZONj5PCnsgEzXwb7HVc6VQJE
	eIGciHY4kf8fpvW6U8/zVSdyUPvEYO9IcT3yfPsWSZgMLCOsqcvf
X-Google-Smtp-Source: AGHT+IH7D3A3vhycoJD9zsFoky6aAGhFXt3gON+zXNbmmnkac3mGgGxBCi5GcVNm1aUF9F0QqwqVXQ==
X-Received: by 2002:a17:902:c3cd:b0:1df:f624:a542 with SMTP id j13-20020a170902c3cd00b001dff624a542mr8579974plj.16.1711404809365;
        Mon, 25 Mar 2024 15:13:29 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:8411:262:e41e:a4dd:81c6? ([2620:0:1000:8411:262:e41e:a4dd:81c6])
        by smtp.gmail.com with ESMTPSA id s23-20020a170902a51700b001e0310bb84fsm5229183plq.289.2024.03.25.15.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 15:13:28 -0700 (PDT)
Message-ID: <df2e08d0-102e-4754-ad91-e50fa643d744@acm.org>
Date: Mon, 25 Mar 2024 15:13:27 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/28] block: mq-deadline: Remove support for zone
 write locking
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-23-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> With the block layer generic plugging of write operations for zoned
> block devices, mq-deadline, or any other scheduler, can only ever
> see at most one write operation per zone at any time. There is thus no
> sequentiality requirements for these writes and thus no need to tightly
> control the dispatching of write requests using zone write locking.
> 
> Remove all the code that implement this control in the mq-deadline
> scheduler and remove advertizing support for the
> ELEVATOR_F_ZBD_SEQ_WRITE elevator feature.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
