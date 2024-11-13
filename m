Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67182309AC
	for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731518748; cv=none; b=YHG2wS8C4uYgLqCDPGUpxlNtJw/5fIFd2207O6Vrshf0nAlmQRo+9EIh7ENVrZE3dW8fwkufUEie3aj0NrBqflfFsavjZnWytU7lDL7fab5p4nTLYYgWTZCDY+zJra/+/x3duBtnlSWkO0lrs8ke5Jh5zCD7kMwKvVejFCYj3pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731518748; c=relaxed/simple;
	bh=kljpfuH+OELI7QtObgIVf5oU+j6EbCllXxOOzyXVQLo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mjBKNDFZMLxH8RaX6seWpcuGE+1BYt2YfY3tVdMUSfXSBpoXhTWIaJ4No4BbACKPMFiRHpYKv4q5OVk7IsLOvk6oo8B/ijpYMUz8w46uRQThB4rfr3whRlGc7OUsY87FvxzTBz04KpI9wYjMwmZOK5PIa2o21XhRlkmp44bWuQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HseHBxyz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HseHBxyz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731518745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NYOIDZZJCVHLGmOsU2nql2vAgNoI7Oa7gTm8r6v0vfI=;
	b=HseHBxyzRA1vsAiJ+D8tLiD+HHrt9ObdYoDBOxJBfujSr0Yu+dpxs9SFUKPEZIZPPKczbS
	yJJCtC0FxChtjHyz6x4ommt25w0onGru4R9h5qEubXhxk96S1Q3Cc4K9J5VWn37Y4muD4U
	JD2Z8SoOhyP54BBCXN+nRhcU+pcMLJo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-2UTpcHnJMo-ppXgHV_WTqg-1; Wed,
 13 Nov 2024 12:25:44 -0500
X-MC-Unique: 2UTpcHnJMo-ppXgHV_WTqg-1
X-Mimecast-MFC-AGG-ID: 2UTpcHnJMo-ppXgHV_WTqg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 078CD1955F3A;
	Wed, 13 Nov 2024 17:25:43 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF0711956054;
	Wed, 13 Nov 2024 17:25:40 +0000 (UTC)
Date: Wed, 13 Nov 2024 18:25:36 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jooyung Han <jooyung@google.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    zkabelac@redhat.com, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm: make it possible to open underlying devices in
 shareable mode
In-Reply-To: <CAO-8PLbTAMO867ifaHOdSWQrErV+vfsg2udWF27PK_VKmrMFgw@mail.gmail.com>
Message-ID: <aa42a2ba-ae99-c209-1289-a2b22dd3b6e8@redhat.com>
References: <CAO-8PLb0azRAuu2yJ3=K1EwiSXASDJ8nVBttbuOUV77==Xd2ug@mail.gmail.com> <94c895e2-0a71-73b2-2692-af8bf62fb340@redhat.com> <CAO-8PLYMFd3YLvfue_an7mc-O19fixJY4ZKybvjehxcm2tRYvA@mail.gmail.com> <CAO-8PLa3Qxhy1M1C_ZDTpOyXrhQ=UQKeKoDOmy-bbShb4rV03A@mail.gmail.com>
 <dcaed20c-2132-d453-9c04-b22417ba4010@redhat.com> <CAO-8PLbTAMO867ifaHOdSWQrErV+vfsg2udWF27PK_VKmrMFgw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XyztgHlk2n-YAPu7uxHA8y3b1UamktVHGtidFISKnn8_1731518743
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 12 Nov 2024, Jooyung Han wrote:

> Thanks Mikulas for the patch!
> 
> This works like a charm. Here's how I tested: On Android, for an APEX
> file in /system partition, I create a dm-linear device with "shared"
> mode on top of the dm-verity device underlying the system partition.
> Previously, this failed with EBUSY because the dm-verity device is
> owned by the /system filesystem. But I was able to create it in a
> shared mode with your patch applied. Thanks again!
> 
> Jooyung

Hi

I discussed this patch with Alasdair Kergon <agk@redhat.com> and he said 
that it may confuse dependencies in udev, so the patch will likely not go 
in.

But there are some alternatives:

1. create a linear device that maps the dm-verity device in 1:1 
relationship. Then, mount the filesystem on this linear device. The 
filesystem will claim only this linear device, so that you can create more 
linear devices on the top of the dm-verity device.

Will there be some performance degradation due to the extra linear device? 
Could you measure it?

2. use the loop device and enable direct I/O mode (use the ioctl 
LOOP_SET_DIRECT_IO) - this should avoid double-caching and it should 
increase the performance of the loop device. Does it improve performance?

3. use two dm-verity instances over one physical device - then, you can 
mount the filesystem on one instance and create linear devices on the 
other.

4. use the dm-loop target - https://www.sourceware.org/lvm2/wiki/DMLoop 
https://patchwork.kernel.org/project/dm-devel/patch/1b84af841912065fc57cfe395d5214f4eee0f0fc.1516124587.git.heinzm@redhat.com/ 
Some times ago we had a dm-loop target that queried the filesystem for a 
layout of a file and then remapped the bios quickly according to this 
layout tree. But now it's unmaintained and not updated to the latest 
kernel. Perhaps it could be used for your purpose. I'm not sure what 
filesystme maintainers will say about it.

Mikulas

