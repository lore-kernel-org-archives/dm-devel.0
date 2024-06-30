Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5F313F43C
	for <dm-devel@lists.linux.dev>; Sun, 30 Jun 2024 14:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719758151; cv=none; b=TzivGI1EU9yLV6DW3fm7VpMkzRZAAbHX7kj0uDG78/Aeg9p+yalcWRGyg18CkhFU84bzTTtlivRJsEg4O4ZZzNKGxEhlcKbBHbi1qp3ULd1YttVyB9+YeJoLcPTL9WEfuV1JeukhUIihNgABHe5XOBg9ZBV0o9a0AFppfA13D7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719758151; c=relaxed/simple;
	bh=/IGJK9dpZ4v6FNXHecjBqRmRpuc91N38EG5z1/3g5Ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iKq8+mPSj2K8EEmIXs0NrkBLDN7DpD5RXDHpPYXcTotXM32Tr9tkNvpfq+DW5+18iqFU6V73yaeLUW2vObMWY0HUm6Gu8annXAj+6BXOZY32b9kyJraMxuAIeBkrKYYTPZRz2bHqdjCQghK+a7TTAYtMMZgePERcg/wekFDFRG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HtmQBuqF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HtmQBuqF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719758148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5hsNfpAVbuZ2ikv3amxzC/RjWyhA87CBLOPSXHDl79U=;
	b=HtmQBuqFXk3YwafA7VBaMniz3nJOD40xLh9CcIoCbBnLGkmLMe3NGrpWWNieXlss9EYDt8
	hzu1c8atzDyt+NkoZ+wA7m6GuWFoN1o8XX5Wx4RmFrFAKEovGPwZCW/SCehfR0XCear4Xi
	+2hGft6JXmVUX1g8fqkalr7UB3LQMl8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-YT2UjL4XMkq9MryX-Nly0g-1; Sun,
 30 Jun 2024 10:35:44 -0400
X-MC-Unique: YT2UjL4XMkq9MryX-Nly0g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89F0119560AE;
	Sun, 30 Jun 2024 14:35:43 +0000 (UTC)
Received: from [10.22.32.51] (unknown [10.22.32.51])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5A1641956089;
	Sun, 30 Jun 2024 14:35:40 +0000 (UTC)
Message-ID: <4bad11b8-b257-44de-87a5-cf428eaa9a64@redhat.com>
Date: Sun, 30 Jun 2024 10:35:40 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm-crypt performance regression due to workqueue changes
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Mike Snitzer <snitzer@kernel.org>, Laurence Oberman <loberman@redhat.com>,
 Jonathan Brassow <jbrassow@redhat.com>, Ming Lei <minlei@redhat.com>,
 Ondrej Kozina <okozina@redhat.com>, Milan Broz <gmazyland@gmail.com>,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
References: <32fd8274-d5f-3eca-f5d2-1a9117fd8edb@redhat.com>
 <a699a394-d36a-4f42-bd49-9a5a573fd58f@redhat.com>
 <e5e5b436-17a6-aafe-2f61-eb659fa35ae2@redhat.com>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <e5e5b436-17a6-aafe-2f61-eb659fa35ae2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On 6/30/24 05:49, Mikulas Patocka wrote:
>
> On Sat, 29 Jun 2024, Waiman Long wrote:
>
>> On 6/29/24 14:15, Mikulas Patocka wrote:
>>> Hi
>>>
>>> I report that the patch 63c5484e74952f60f5810256bd69814d167b8d22
>>> ("workqueue: Add multiple affinity scopes and interface to select them")
>>> is causing massive dm-crypt slowdown in virtual machines.
>>>
>>> Steps to reproduce:
>>> * Install a system in a virtual machine with 16 virtual CPUs
>>> * Create a scratch file with "dd if=/dev/zero of=Scratch.img bs=1M
>>>     count=2048 oflag=direct" - the file should be on a fast NVMe drive
>>> * Attach the scratch file to the virtual machine as /dev/vdb; cache mode
>>>     should be 'none'
>>> * cryptsetup --force-password luksFormat /dev/vdb
>>> * cryptsetup luksOpen /dev/vdb cr
>>> * fio --direct=1 --bsrange=128k-128k --runtime=40 --numjobs=1
>>>     --ioengine=libaio --iodepth=8 --group_reporting=1
>>>     --filename=/dev/mapper/cr --name=job --rw=read
>>>
>>> With 6.5, we get 3600MiB/s; with 6.6 we get 1400MiB/s.
>>>
>>> The reason is that virt-manager by default sets up a topology where we
>>> have 16 sockets, 1 core per socket, 1 thread per core. And that workqueue
>>> patch avoids moving work items across sockets, so it processes all
>>> encryption work only on one virtual CPU.
>>>
>>> The performance degradation may be fixed with "echo 'system'
>>>> /sys/module/workqueue/parameters/default_affinity_scope" - but it is
>>> regression anyway, as many users don't know about this option.
>>>
>>> How should we fix it? There are several options:
>>> 1. revert back to 'numa' affinity
>>> 2. revert to 'numa' affinity only if we are in a virtual machine
>>> 3. hack dm-crypt to set the 'numa' affinity for the affected workqueues
>>> 4. any other solution?
>> Another alternative  is to go back to the old "numa" default if the kernel is
>> running under a hypervisor since the cpu configuration information is likely
>> to be incorrect anyway. The current default of "cache" will remain if not
>> under a hypervisor.
>>
>> Cheers,
>> Longman
> Yes. How could we detect that we run under a hypervisor portably? There's
> a flag X86_FEATURE_HYPERVISOR, but it's x86-only.

Right, that will be for x86 only. There is also a kernel boot command 
line parameter "workqueue.default_affinity_scope=" that one can use to 
set the default. It will be a bit easier to use than changing sysfs 
parameter at run time.

Cheers,
Longman

