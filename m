Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B639013FFF
	for <dm-devel@lists.linux.dev>; Fri, 26 Jan 2024 10:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706264978; cv=none; b=WVMDFnYTxz6dZSRQ824PECdUHofxnmTHosirFuktWKych9pFZhXs6Qa0t18KInUbUWPRqK2p6Qv6sQ+7L2/uGbTv1Tb8JLsrTAK8UDOpyk7PELdbkiuwafe1jlMdczIh50EH1dw8SeuK1/AG6F73mqM6cOeCfI4LCC+ZmlUTl3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706264978; c=relaxed/simple;
	bh=kHbs2sXHOEle8XXVyH+2aGcMmkid+9VRHmF7NB1eMLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dK6lEf/HcnSWK5IlTlMrK8TixbeffSux9h9z+i81mv8o+dbp7fwvGPhMnrmrbWToFmJzjHAGagJVPwV6ohAwdnN3gpMMLjYw8kH4KKvqKx8s3A2hR26SqGqPvtpF9stwpvwFA7mU14nF5YQ2CFQ3OqHcX9zBjsXLmY3yZbmhWpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BtvyLsy5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BtvyLsy5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706264975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9UWZ7/84YH3KBx/D9SUjpm1tFQZfr5i37U38dsc6EZU=;
	b=BtvyLsy5EHnHVlc9t69tPocHbm8e5rNsDaTiJv1NKtSTpzct71MEetwSPKp1pMNdpAK3oQ
	CSNdHWl5gyv54t44GpORqf9vAjd2mALxKJTKXTEeVyZo9UnjXhaB9OpU8B+GZvyWiAlKgm
	iRocmBuHSj8w22rehc3ITmHTxJbDa/0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-8iBNiK2aMeSMp0Vo6UruXQ-1; Fri,
 26 Jan 2024 05:29:31 -0500
X-MC-Unique: 8iBNiK2aMeSMp0Vo6UruXQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3078380670C;
	Fri, 26 Jan 2024 10:29:30 +0000 (UTC)
Received: from [10.43.17.38] (unknown [10.43.17.38])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31384492BC6;
	Fri, 26 Jan 2024 10:29:28 +0000 (UTC)
Message-ID: <86a989b0-53ee-4915-8ff4-aafa3ad18d16@redhat.com>
Date: Fri, 26 Jan 2024 11:29:26 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] md: test for MD_RECOVERY_DONE in stop_sync_thread
To: Yu Kuai <yukuai1@huaweicloud.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Song Liu <song@kernel.org>, David Jeffery <djeffery@redhat.com>,
 Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com>
 <CAPhsuW483DSEvgoT0c-Mo1gdpVKRRLkTxu+kuxYG6k-zew+FFA@mail.gmail.com>
 <82e9b11f-e28-683-782d-aa5b8c62ff1a@redhat.com>
 <CAPhsuW4YLVLhv2ii0UjiQOmiqR3mk6u8r94-SVZjMs6LVp+WaQ@mail.gmail.com>
 <56ff3ba-9a60-1930-a2a1-c2562ece1ec1@redhat.com>
 <Za8k8GityCXjSVJ-@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
 <08748e1b-e947-44d3-34dc-7dc0f9db1c04@huaweicloud.com>
 <166bea43-1d1e-3938-3af1-491e61d5bcf6@huaweicloud.com>
Content-Language: en-US, cs
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <166bea43-1d1e-3938-3af1-491e61d5bcf6@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Dne 26. 01. 24 v 10:37 Yu Kuai napsal(a):
> Hi,
>
> 在 2024/01/26 17:17, Yu Kuai 写道:
>> Hi,
>>
>> 在 2024/01/23 10:31, Benjamin Marzinski 写道:
>>> On Mon, Jan 22, 2024 at 05:34:54PM +0100, Mikulas Patocka wrote:
>>>
>>> This test always hangs for me as well. You can try this for a reproducer
>>>
>>> Create a F39 Cloud image VM on a host machine (tweaking the root-ssh-key
>>> if necessary):
>>
>> Just borrow this thread for a question, it takes a long time to run the
>> whole test suite, can I just run the tests related to dm-raid?
>>
>> For example:
>>
>> ls test/shell | grep raid
>
> This is not enough, like integrity-caching.sh doesn't include 'raid' in
> the name. How about following script, total 99 tests are found:
>
> for t in `ls test/shell`; do
>         if cat test/shell/$t | grep raid &> /dev/null; then
>                 make check T=$t $t
>         fi
> done
> this should hang. From the host machine, run


make check_local T=raid


will do the same thing.  With S=   you could even select list of tests you 
want to skip.

Regards


Zdenek


