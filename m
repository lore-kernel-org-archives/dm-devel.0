Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312AB16DECA
	for <dm-devel@lists.linux.dev>; Mon, 22 Jul 2024 09:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721641947; cv=none; b=rs13H6EoqRdCCC1oxDCzWlp3N0heQr1d+jG1hGT9pDHfgRosk8yBpMYCLdNniryoPmaQOTjPCq1eruQo7byoWVR4ykLuggvuY7ktd0SZYPWj2nCj99gx2558Zqv54arZqhPQndd+ms5GYxGRQCke/oI3xx4iCU3y1AgH1oatnVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721641947; c=relaxed/simple;
	bh=tCibecf2fM4vbEWbLY4L0QX6bMGnn5WR+ksW88I7YmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onos4i1FlEUGHCSpePYVc7MUCYZWW/UWy4Hlal+IALQMe7ZrYo8HxLt1mVqmx/k6PzMZfE6T5ZHhcdR8iXd9ImIbwzcJHQmIzroVb11nTrJyejVdO8jxINCMqiTExXw3O6XL0JkVjZXjmoeEf4QbI6lMXDDkhNpSQBir6xhqLdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KAMjPiMi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAMjPiMi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721641943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zK1oO1fYgGLrd485w8+L5C+qb9sKJLP0AGDq82/9/KE=;
	b=KAMjPiMi68qNaQYlTFEidxQJ+U98xEf3miU0RdipzjVz//FP5z/jxTHX8HTu2jnYdPDVK+
	APjsGW6tnNWX+ucwC0GrDYimpm0azHfRjmEQhq/IMsWY5q9sEfafoykTyk08CZZ5kqPhV8
	XnR2HgWH7qcT2kPy+xUPlHWVklJmzts=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-O_1nEsdWMXSQVAkm1foNqw-1; Mon,
 22 Jul 2024 05:52:20 -0400
X-MC-Unique: O_1nEsdWMXSQVAkm1foNqw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0242E1956048;
	Mon, 22 Jul 2024 09:52:19 +0000 (UTC)
Received: from [10.43.17.8] (unknown [10.43.17.8])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2B7CB195605A;
	Mon, 22 Jul 2024 09:52:15 +0000 (UTC)
Message-ID: <011a15cb-1f9e-456e-9374-5bca382d4e81@redhat.com>
Date: Mon, 22 Jul 2024 11:52:14 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] dm ioctl: fix erroneous EINVAL when signaled
To: Khazhy Kumykov <khazhy@chromium.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Joe Thornber <thornber@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240717185640.1026114-1-khazhy@google.com>
 <43954d4-6130-f36a-384c-9f18eda892@redhat.com>
 <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
Content-Language: en-US, cs
From: Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Dne 17. 07. 24 v 21:52 Khazhy Kumykov napsal(a):
> On Wed, Jul 17, 2024 at 12:45 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>> Hi
>>
>> I am wondering why does do_resume need to call dm_suspend at all. Does
>> anyone here remember why is this code path needed?
> In our case, we have a sequence with load_table followed by a resume,
> with no suspend first. The resume path suspends if needed, swaps
> tables, then resumes. Removing the suspend here would break existing
> userspace, I'd imagine. It seems like minimizing the suspended time
> would also be a nice benefit.


lvm2 maintainer POV

Automatic 'suspend' for resume is a kernel 'feature' that should not be 
normally used from the userspace. Userspace is supposed to call    'suspend'  
- handle error cases - eventually drop preloaded table and resume existing 
table that should work.

If userspace is using ONLY  'resume'  without calling suspend upfront - there 
are some unsolvable error cases.


So no -  'minimizing'  suspend time is NOT the main reason here. The only 
valid reason to use it is basically if you are  admin and you need to reload 
table for a device you are running from - in this case calling 'dmsetup 
suspend'  might leave your system in 'blocked' state since your rootfs will be 
'frozen/suspend' and you would have no chance to  call 'dmsetup resume'.

lvm2 app is locking itself in the RAM in this critical section so it can 
proceed with regular sequence:    'write metadata - preload DM - suspend DM  - 
commit metadata - resume DM'  which basicall all userland apps should be using.

Regards


Zdenek

