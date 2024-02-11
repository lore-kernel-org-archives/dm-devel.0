Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C201F523E
	for <dm-devel@lists.linux.dev>; Sun, 11 Feb 2024 03:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707622822; cv=none; b=cRBoPKAvJMpcS0/XWChRV6ixsEzk/Kor9V7pARupNQAmNMFFqb0/8fRzVNBosB01aHGrUVG9d9xtl4/QDNx/pZdkDnwWfzb/NRRDcjUCedRDorccqLFGr3Z6tdvfWgHLWOS8ggyZDFQNekocvxUXHEZxjTCjrWcB0qaKliweJtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707622822; c=relaxed/simple;
	bh=qAofQFRNn5JOYKBu3rH93zn1we+MRS407FLoTMBaCVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QqMqkawxrdFNcVLgqBOEgR7ggj63bpaVgtdlqgLsFGMR6vlKmfPjZ8F81hcwxwPMclrYM/W7XjMzUkPKPRLQC3HwHIoNcGhm81+trJpXrbA7KPaJuVIfabh59LPx6azbZV6Z1/3I/Y0WSSYFdF3XtSpYK6aebyor1AWVHZ/RJ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-214ca209184so1442394fac.1
        for <dm-devel@lists.linux.dev>; Sat, 10 Feb 2024 19:40:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707622820; x=1708227620;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hMYgiHBEDavj7uIzhw2tvkbewX2cx77PDc9OLk7jn/k=;
        b=dWmXlt/i0alM8dGZzvCrHPhvRGk/QiUqyGd65KQpCCctKTmVe4uBpgbdQKRE1o0zTx
         MxrA9iUdWNKHrRsmFCjKaVpN9ugHewzBIr9kbC8isWqtwZIKRjfXDpQsPVtgsLNehHV/
         kK1gelc4wxpbzY9U6Nl51DOcLmeYZvHSQyrIX4uOVP4sTJCyk3+/xBsgJmNQLpsFVmfp
         aFvsTpNLRWEThlUXaHir51adxzjFNuOIz72buTzQ2ruy9EZyCIxvMbIqohB7MwPrMnS9
         LQFPz+eB20On/fp7hCUQ4eEaFVUVw0PQHKGz9/Sx3byvfef4BXKiYV2sSFinu7vLmCz6
         TWwA==
X-Forwarded-Encrypted: i=1; AJvYcCXJp/qHshAqHGrNcIwj2hamoI48vWqaAYH6szXRFmzi1/1NuEO0qJmputP9O5ivlPaJeAenPlKjJJn0A12dFIFHBavAwzc1rKY=
X-Gm-Message-State: AOJu0YyDONy5H70akKnrGBEi3+VL1P4xKdtB0iqXLs2CVrbsMbWyEVJb
	kAfQyN0uQLZmNwke7DFNyeSXpFPuQI8Zg5W7XD1c3XUtlYp/o9yf
X-Google-Smtp-Source: AGHT+IGR4P8pGKs+ctCklf4XqK/ylZuLJWQJ0EO9ZKQtD/TUh1WRmTCeAUQBhkgAkZGaHUs1ZTNcFQ==
X-Received: by 2002:a05:6870:b48a:b0:212:42f4:82f4 with SMTP id y10-20020a056870b48a00b0021242f482f4mr4817221oap.4.1707622819693;
        Sat, 10 Feb 2024 19:40:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUxEhV9yJrJ24Jyyy7aLZmf4V0fw6ZPd0WLNVjRFQC0RNX0R/GJhy4LpgeDgqciTtru6g0MOUXaR8Ga/dHnufxYziotVgVhT7uDVDgHENPtV/8lmpUDW4+3cD4WDEsmUyk0UuB2xWPtYMtgXbQ3QL3YlN6r3o9rhY8wndYroVE7atBeIlK07Bj+4Dl1c7VrlLS5wMkP2OLfTS7ttwjlsoF63B2nsTmd3egehKOvbv5hsqTrr9CRf/kV+wCluc3QOt6fclBcIcyBHCvQy3l88Vq3
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id w13-20020a17090ad60d00b00296a7ac8b5fsm4361773pju.6.2024.02.10.19.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Feb 2024 19:40:19 -0800 (PST)
Message-ID: <a1531631-dce4-49a6-a589-76fa86e88aeb@acm.org>
Date: Sat, 10 Feb 2024 19:40:17 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-26-dlemoal@kernel.org>
 <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
 <f3a2f8b8-32d2-4e42-ba78-1f668d69033f@acm.org>
 <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
 <2e246189-a450-4061-b94c-73637859d073@acm.org>
 <75240a9d-1862-4d09-9721-fd5463c5d4e5@kernel.org>
 <e2a1a020-39e3-4b02-a841-3d53bd854106@acm.org>
 <c03735f3-c036-4f78-ac0b-8f394e947d86@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c03735f3-c036-4f78-ac0b-8f394e947d86@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/9/24 16:06, Damien Le Moal wrote:
> On 2/10/24 04:36, Bart Van Assche wrote:
>> written zones is typically less than 10. Hence, tracking the partially written
> 
> That is far from guaranteed, especially with devices that have no active zone
> limits like SMR drives.

Interesting. The zoned devices I'm working with try to keep data in memory
for all zones that are neither empty nor full and hence impose an upper limit
on the number of open zones.

> But in any case, what exactly is your idea here ? Can you actually suggest
> something ? Are you suggesting that a sparse array of zone plugs be used, with
> an rb-tree or an xarray ? If that is what you are thinking, I can already tell
> you that this is the first thing I tried to do. Early versions of this work used
> a sparse xarray of zone plugs. But the problem with such approach is that it is
> a lot more complicated and there is a need for a single lock to manage that
> structure (which is really not good for performance).

Hmm ... since the xarray data structure supports RCU I think that locking the
entire xarray is only required if the zone condition changes from empty into
not empty or from neither empty nor full into full?

For the use cases I'm interested in a hash table implementation that supports
RCU-lookups probably will work better than an xarray. I think that the hash
table implementation in <linux/hashtable.h> supports RCU for lookups, insertion
and removal.

Thanks,

Bart.

