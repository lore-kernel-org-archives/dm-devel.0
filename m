Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C573038F96
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710971089; cv=none; b=V2Io8WGsu6oa5oUFwoFSxpgg0lPiYhy+9a0qElNG/qO7fKaqLVIfVUYeu7oOZpi/M13eSodz+UdUNcXDC12l37UI+CONw3ZvpUzdeFOJYh9iIlsSAswWuJEFYPPS36MnKZ3+LaCKAIcEa0fdekxr+sz+lx6Qjj658a4eA11+p+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710971089; c=relaxed/simple;
	bh=z0NFGlaV5tIEpB4HlebxDCtYtKtcVNp96Ib+g8JphIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=stEEUhkE75ZZ6rIb2FmeJ/uUjgKT9mHGd2be8Nw7WjhXio8brG+id63qlBXQ0dtBxEPzTjFju5riJYn8gD01MESvh2VmrGy7Qr3lQAWfNz7tj0C8Fi8R8sdrZj26+89abFDXs41g4LM57MABfLsnXep/8OBFp3++Nl/KJDnOM4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dsYHLFVY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dsYHLFVY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710971086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9zE1ffGdRT/wxohThmFP46bxQ8xBTgdpn15gU6MCDWs=;
	b=dsYHLFVYdDZqWrze9woTgVV9Yfs+kERUGENzltjsBL0oWDdX1X6o3Rqm7V3ev6/FFRUf1i
	rHZZbIoXnnd9WICrZIXIBaoTYfZ6bzMl19rQ8atyLMZolsY9XV7iUKPwQbpIL/nFrNZeb1
	b9Ncgg2wFoWLXhxFAO2PnGYlWPgWtss=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-2vxmfkgoPeSXViCfgVUejw-1; Wed, 20 Mar 2024 17:44:45 -0400
X-MC-Unique: 2vxmfkgoPeSXViCfgVUejw-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-69633149169so3488596d6.3
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:44:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710971084; x=1711575884;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9zE1ffGdRT/wxohThmFP46bxQ8xBTgdpn15gU6MCDWs=;
        b=UinmEMo5wa+++RErLJJFegr4zX/mNSb5q/ffW9UZCdv/zXWwWDLnv5CSFFvCxY/ShC
         QF7mVl0zWRnTm9MN89yCyUGzJKVjN9FDUodRVfSdYybKsBeJVT46wdudN0LorNB1nb6k
         O9Q62PQP1HdI+iY7hoh0L5wrtOzcP7GJo0J41yQN/StdpsnWZlzS7d3J90f8gSJQ15b4
         nkdjJajuUw5FOU+SaDnYnlf7fXhF8BwhVNjsoggt7PnO0mrtYJn4yFoB/KeDDsF6QOU4
         8mIbnQrmbYTXeAv7xcj/HLZZ5lspMo94ilYXxaddwiekYaoywxO7kRcHuP3NlVn6LoGq
         5Jmw==
X-Gm-Message-State: AOJu0YzitlGBAthe+i5KSaSbwu9Fn8xkUrX2n3pEprkxLBT2nxokauj8
	XhMvWlQUDrWF/vx3xhxk8a89sE4gKKpOvuHQyLWfPq+yXHGvfBB8U9ffb2YGR+aqO5vKZ4NgAUv
	Fz7RYP/iBl1eGUqLJWdac7Cep9OtaF9NfzMcy152Pa8Nlu0hjHKWofROU
X-Received: by 2002:a05:6214:ccf:b0:690:bde1:ab85 with SMTP id 15-20020a0562140ccf00b00690bde1ab85mr84752qvx.50.1710971084580;
        Wed, 20 Mar 2024 14:44:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0PeKTXX7ttL8y1bFVmoRX8me9F2X6p93pvAZqvMgm2b3qfA7f6gvGdNqS3e0OOGHJdfNH9w==
X-Received: by 2002:a05:6214:ccf:b0:690:bde1:ab85 with SMTP id 15-20020a0562140ccf00b00690bde1ab85mr84736qvx.50.1710971084252;
        Wed, 20 Mar 2024 14:44:44 -0700 (PDT)
Received: from [192.168.1.164] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id im6-20020a056214246600b0068fdb03a3a3sm8243841qvb.95.2024.03.20.14.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 14:44:43 -0700 (PDT)
Message-ID: <cee6169f-f635-e3fb-29a7-e68829cdf1db@redhat.com>
Date: Wed, 20 Mar 2024 17:44:43 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 02/39] dm vdo: add the MurmurHash3 fast hashing
 algorithm
To: Guenter Roeck <linux@roeck-us.net>, Kenneth Raeburn <raeburn@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
References: <20231026214136.1067410-1-msakai@redhat.com>
 <20231026214136.1067410-3-msakai@redhat.com>
 <ea57f231-f78e-4a55-bf85-c5d50e17237e@roeck-us.net>
 <CAK1Ur38jAmWo35HTNrDDAaN5Awiie9wRiPDMVrNUg6+ZM8mJ7A@mail.gmail.com>
 <28a88525-6b06-4215-9e78-2b3d8c0d8657@roeck-us.net>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <28a88525-6b06-4215-9e78-2b3d8c0d8657@roeck-us.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/18/24 16:54, Guenter Roeck wrote:
> On 3/18/24 13:37, Kenneth Raeburn wrote:
>> (resend because of accidental HTML lossage)
>>
>> On Thu, Mar 14, 2024 at 7:38 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>> On sparc64, with gcc 11.4, the above code results in:
>>>
>>> ERROR: modpost: "__bswapdi2" [drivers/md/dm-vdo/dm-vdo.ko] undefined!
>>>
>>> Guenter
>>
>> Thanks for catching that. I don't think our team has any sparc
>> machines readily available for testing.
>> This is an artifact of our having imported user-mode code to use in
>> the kernel. We should probably be using le64_to_cpup and friends, as
>> we do elsewhere, so it doesn't try to pull in libgcc support routines.
>>
> 
> I am kind of getting wary about reporting such issues. Should I drop
> building dm-vdo images for sparc ? Would it be possible to add
> "depends on BROKEN if SPARC" configuration option to indicate that
> the code isn't expected to be buildable on sparc, much less work ?
> 
> Thanks,
> Guenter
> 

Could you try out the patch I just sent to see if it fixes your build 
problem?

Matt

