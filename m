Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9489447F52
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 18:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707157129; cv=none; b=HVHnkubggjWEkowa2RchJxGXgHIfUsQiDwrnjDH2vK+De+UzDoMyFhHPDsfi3FdDE8sjCh54V9y72zXEwqnfMKtrhCIC63QcEemZzefRJI/AzYdlATE6qjRjgYak3Q0IWLStuDqIhTrUKGdD8S/hISQrVhNEIh2utVGalykNUVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707157129; c=relaxed/simple;
	bh=UbW9pb+p4NKUxQEZa6hHc+7CxIITbDL/dB4xo5xLR8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9Sxmtws5xXMIlI+VPR4m6dFRO4ZkKQRs3s9YfgepwN1kj+QmCdFZm0Y642v7Cvml+9Xm6SqXOPUF6zDQ9a/oMT23C57+vZPLqoRScUUENwcuioV31IpHLPuIN2BkGOsY89xSx6LcCTyOYxRXp6zXLCEwh87uN6J6xQnPGXSZIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d8aadc624dso35172785ad.0
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 10:18:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707157128; x=1707761928;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qp3N1ga5ugtPxim9zjENr195h2Ajx0b+DBXqYAvDBaM=;
        b=mZLh7bDniBsXxBZ0lKkOtJulhAsFGIJ2OBHtg1JJHKp9vS7IYck11SGHuO+iTHOaAj
         8iRYlaSG/4rNz9Frg+72g70xk+1xUij2mwS5WMY5vdsWO6yLbpgsP6nnetChy0qbRuYK
         ttfHfQDpIDBnlKZsX3yk715a8YHw2t3m2bi3k4YO4HoUUlOywYrHakXFk/8HQL9A7adJ
         NVHJI/uqGi+Kc4TPQ/xwXJA7EcEbnw3WuAWTjyKWtqqJ2kbSF045vTfLTbsaB+WGTEgf
         pA8jltEiCifHJPZaF24/WLEvpYviS+i8M57XRH/m2XaiULSOHwZrt0gfWbYQ5Xg4wbXD
         c9IQ==
X-Gm-Message-State: AOJu0YxVBByZv3CZLlMBULuvIWqDfqB1laUcjqJ3x9/MFLb9pLAwe3a7
	dBYHV+rbFrod7GoXloantCJMI68KHKxnaLVfDLgIAoVCKxFzlAfta5kNY/NC
X-Google-Smtp-Source: AGHT+IGl8GEKozCjvP6yuZlfvwDbt6MOzVemHnmNUbn15UHQP46qxmaWzfaPHuRpBzw2l9VWvltRMg==
X-Received: by 2002:a17:903:487:b0:1d9:af60:a7e3 with SMTP id jj7-20020a170903048700b001d9af60a7e3mr300964plb.27.1707157127732;
        Mon, 05 Feb 2024 10:18:47 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUxGIoMm5rhsniEwj3nD9//9C0izEWLs48WYS2Si2Ojdodx9VfSnebECLeltzmQ34fEIt/0e3Zecu1096/AJpbfn+WiWUbNhI8/SY8zsMDp6Obkke2+aB1a6wFsd2VPAkyucvOlfRZ3xVUNa1JbeWTrIpKNTMH9adq4RLphaOgh+3dqej3EtT0W8j4cL6l/ziTZp88WOKLm/uwwAuUA4202GrSji0yRalrdyE3wL3GCa+nfEcJVH/+3tbkeF/rHqtYq0g==
Received: from ?IPV6:2620:0:1000:8411:be2a:6ac0:4203:7316? ([2620:0:1000:8411:be2a:6ac0:4203:7316])
        by smtp.gmail.com with ESMTPSA id ja12-20020a170902efcc00b001d901c2087esm158975plb.302.2024.02.05.10.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 10:18:47 -0800 (PST)
Message-ID: <fc7ab626-58ed-49bd-b692-4875d17c6556@acm.org>
Date: Mon, 5 Feb 2024 10:18:46 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/24 23:30, Damien Le Moal wrote:
>   - Zone write plugging operates on BIOs instead of requests. Plugged
>     BIOs waiting for execution thus do not hold scheduling tags and thus
>     do not prevent other BIOs from being submitted to the device (reads
>     or writes to other zones). Depending on the workload, this can
>     significantly improve the device use and the performance.

Deep queues may introduce performance problems. In Android we had to
restrict the number of pending writes to the device queue depth because
otherwise read latency is too high (e.g. to start the camera app).

I'm not convinced that queuing zoned write bios is a better approach than
queuing zoned write requests.

Are there numbers available about the performance differences (bandwidth
and latency) between plugging zoned write bios and zoned write plugging
requests?

Thanks,

Bart.

