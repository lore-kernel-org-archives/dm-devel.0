Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA223D47D9
	for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165297; cv=none; b=UV8pxhhWo30qahrtiP42YMoVorFR2J9AODCkUgjzSSAFGcu5BtWNZ3oMedgjOhzEcM/NY4s2yP5ME5Rf4mwZexAelPzsAzLC787Duiwnh8P9t6OzN0JubJOxiGAJetfbsvP6u+M2N6IYbvcEEqHXblR7rqpLYcOYn1tCFGfYB08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165297; c=relaxed/simple;
	bh=SwJIA9MTxdZ8STOa+2dg+eURC0+yijgQo1QtJ+LnHiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FvMqPziqng/i4nOy+ZZTcYXOiUt5TJKP5A79fyIxesWhZ9lDxFqVL3g6cl9JDBC2C5e7o1rgMACILOPq2b+5yVbtnYk+Yrsza/6/m5+Te4xgTZhgwzs9qAdXdLxqvXh+iuTW762ZLeWl//KGhOq1eaFsEjbV6wtw663tCWv9tEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E40TXNaS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E40TXNaS"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-483487335c2so111239675e9.2
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 10:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773165293; x=1773770093; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qEnF/Lg25U18+ZKcj41EcZIOIb03fm6HJ1Ff4fvEotU=;
        b=E40TXNaSkLrEwUSbklfCKn/vkxpE9nqsz3FIbnd+ur3cuVXaLB0E9VHjvfrvve4IJV
         DKPPkWRc6Ik6WbUuZp6PGCSYt6xu2gZ6lwrZuVaJQMaay57ZUP6AhXwOuCdpVrgIeQ0o
         wVWAtlZ5gnAISkqQpXIQ/WIN8PCtc44yRqETgvYA9G6s4tPT3TcmVhuMz8KbNafs+mzd
         B7lGIpN13Fx6KlyXiOOY52hXrGN0z8rsaW6h8WsygeQjbcKeATxrKiTXCiUb1pjcCqht
         Zw7Uc1qHBrl2X+42dajyzlwCwisFBYDAdWREX3PA6I80aXHyaU5R2ARJ1Qdd4TWe5ch/
         ZEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773165293; x=1773770093;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qEnF/Lg25U18+ZKcj41EcZIOIb03fm6HJ1Ff4fvEotU=;
        b=f2Pj9yjOnUkjuL9GDA9vgj2PjUubNMtvr4OtyIw2bFnlElohaIO8ll6oGI46WterKa
         vO4lO+UibL5UkjYRyVgiTmwFAPmEfpwV2rWaG7MmyxAx/QctaxinkGVtpK2p60Rc76YC
         75yKsDYP7//7pUnhG38KIoTJBU/MeFvGIV2zDkU2zb80LSjyg3drsaGJYkJkSryzBlxh
         KW0I8EvKK9BYFIKm0+L07PJg9XT8PZamV3RlwgY5fzzl80Lt66qZb3vKFNNF3kglAYIo
         X4u5/xDC5VhotNWVVTzU7FsCRa+sLeTAwVYulAMuWxiONCtlNXOMZih7bGjwQ3tCTzxX
         w3dQ==
X-Forwarded-Encrypted: i=1; AJvYcCXppC17Dbn1TUwaZ/WensSLD51T+1iN6412hxpk1fCfhXao7cxjYYdOtNTSYr6B+Owqp+gf9VoK7A==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4Jt90NtiAL5rwnMK/yQGWlQLWqKXDCHohVN26baU3Q0KqwGV7
	wwvK9lAkPGw42EbpAQ2Ahnnb27TiSFZrxu9a0foHWeL/qDePeg6GoPhFCFUYEvkVddY=
X-Gm-Gg: ATEYQzxfpNrGxXTbyBe0Swt1yjuW03EpYzeOEJsOqg8HrzJVTAk8C+sw4x6U+Aj1QyN
	q5k0xhb7qP5KJf6aupSKtiMQc2PH6T1j9W1IP77DKTc1sg2k9hKP0zkHsDhxN4le/rJjVCmLGli
	fJijHrsqPiT3AYCijboEm3xxV9K0dducjSdyIShy3ZNgnyj4Dw7lee6WGjz/owRChgJ3lBCGHc7
	8cUyN4LjfoKpZzQUOrHO+o1iQFERut0JSJzb7K4m1GnnxE+58oqLADGfL3yThs98G3WFSO5K6lL
	25iM0/ajaw/zSh7Ab5M7gr0XP3uoNI9sxWnFj5guscNcXbgu3ixGWJys+OllRzmcdDKLUhITFRM
	+Csa4kpfjYIlXqsAWVNLhCC3gJi0P0cqtCbmWoqDRwfhrAB3gwKwj+j2cwB2n1eI+Ik2i6hme+Q
	Jdd9qEN2xcQNSErYdFqFkNBJyJ5b6H1g0nXAEgvzFYX8uEDAoFwc3mQiwLXpaL
X-Received: by 2002:a05:600c:4f07:b0:485:3171:7845 with SMTP id 5b1f17b1804b1-48531717a94mr200528055e9.4.1773165292732;
        Tue, 10 Mar 2026 10:54:52 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a16:da01:fd99:79eb:2f5d:d346? ([2001:a61:2a16:da01:fd99:79eb:2f5d:d346])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541b6f708sm126141845e9.11.2026.03.10.10.54.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 10:54:52 -0700 (PDT)
Message-ID: <6b6a822c-4e49-4e80-ba57-57704e3c1307@suse.com>
Date: Tue, 10 Mar 2026 18:54:51 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] scsi: scsi-multipath: Add basic ALUA support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
 axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
 snitzer@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-6-john.g.garry@oracle.com>
 <f46807c2-0266-4143-9caa-ff938293f7b4@suse.com>
 <3178d371-7a4c-4d07-885c-42496190f242@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <3178d371-7a4c-4d07-885c-42496190f242@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/10/26 16:52, John Garry wrote:
> On 10/03/2026 13:23, Hannes Reinecke wrote:
>>>       sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, 
>>> GFP_KERNEL);
>>>       if (sdev->scsi_mpath_dev->index < 0) {
>>>           ret = sdev->scsi_mpath_dev->index;
>>> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/ 
>>> scsi_multipath.h
>>> index 2011447f482d6..7c7ee2fb7def7 100644
>>> --- a/include/scsi/scsi_multipath.h
>>> +++ b/include/scsi/scsi_multipath.h
>>> @@ -38,6 +38,9 @@ struct scsi_mpath_device {
>>>       int            index;
>>>       atomic_t        nr_active;
>>>       struct scsi_mpath_head    *scsi_mpath_head;
>>> +    int            alua_state;
>>> +    int            alua_pref;
>>> +    int            alua_valid_states;
>>>       char            device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
>>>   };
>>
>> Is there a specific reason why this cannot be in the generic code?
> 
> Sure, it's possible....
> 
>> After all, if the device reports anything else than ALUA_STATE_OPTIMAL
>> or ALUA_STATE_ACTIVE I/O will fail, irrespective of multipath being
>> active.
>>
>> I would love to see that in the generic SCSI code, independent on this 
>> patchset. It would allow us to simplify the device handler code, too,
>> as then device handler really would only be required for explicit
>> ALUA. (And could be ignored for scsi-multipathing).
> 
> Right, so you would like to see alua_port_group management in a core 
> ALUA driver as well, right?
> 
> If yes, to repeat, it is hard to separate the DH stuff out...but I can 
> try. Examples I would need to deal with (and associated handling):
> 
> - alua_port_group members like dh_list
> - alua_dh_data memebers like init_error
> - everything in alua_queue_data
> 
While the port group handling looks nice (and there certainly is
a certain neatness to it), it kinda assumes too much about the
internal layout of the hierarchy within the target.
Technically, a target is only required to provide a device
identifier, and a group id (such that you can match with
RTPG output). However, you have no idea which of the various
device IDs are part of the same enclosure; that information
is not required to be present.
So you cannot assume that group ID A reported from device X
is the same group as group ID A reported from device Y.
The only reliable way is to check with the RTPG output, as
that contains all device identifiers for the defined group
IDs.
But: caching RTPG output is problematic (as it'll change
whenever a path state change happens), and it'll need to
contain references to the SCSI devices, introducing all
sorts of locking issues and race conditions.
So probably I would not go down that way (at least initially),
but rather read RTPG during scanning, and set the values
directly in the scsi device.

We then need to re-read that information whenever we hit
a relevant sense code, but arguably we'll need to do that
anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
