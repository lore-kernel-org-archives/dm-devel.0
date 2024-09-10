Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB30208A5
	for <dm-devel@lists.linux.dev>; Tue, 10 Sep 2024 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725994827; cv=none; b=SFeP1Qw/GoGmWSVsKd/+q0Bdh5+J5DvJY6c0chjoH1t8lsGZZp2+tRODsMc7jqLKuLO9MUe4908/zf52tXyt9WI3llju0ClUksONnR/GzpohRS1HZPexO1nBP1HoATA3j6jbRmKIlm3iBmXqBRKFsCZfLK5VCni+hffs88p2d70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725994827; c=relaxed/simple;
	bh=rXwh8adBmEqeRoWXzHBrhOlauS4D7DmG7T6yoTl13rA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=mpLzCt+Mq1vGmu0BqVStpd9ciKBkpGEXXmvxXSE5iH1EmvJHthMhhMGvJNkyGyew76gg+15kFnJS/GSOxraRpP+rHEJv5OD8WM+kWJGk6hia+FQ10y9aRxewt9A6bgHddtPQapljsxbdZiD7JmuUNrbAqKyA/T7+htgHKwcK78I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7oTGaXY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7oTGaXY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725994821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=nB+gBK1HAxe8Q3JXrsuyMaclkazCTRkgYOH/ARc5BVk=;
	b=A7oTGaXYvbZx+VHERmqS2vbyrdpEjKGmkcURYYLSonWHpRPnI5g22u/Tc5B+eMLu6mxucv
	30pCzncKdUldg7dBcZmjvxNyXvKuEk8+cUuG1C11qVm0DK/7HjV2WfH7KKbljlfAuGzW7Q
	VV5hAuTlbUaFIpMTf4LrYPwGweGOMxs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-CjHMySDAOPK2IqDpHcd0-w-1; Tue,
 10 Sep 2024 15:00:18 -0400
X-MC-Unique: CjHMySDAOPK2IqDpHcd0-w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0160A1956048;
	Tue, 10 Sep 2024 19:00:17 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1A2019560AB;
	Tue, 10 Sep 2024 19:00:14 +0000 (UTC)
Date: Tue, 10 Sep 2024 21:00:10 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Zhang Yi <yi.zhang@huawei.com>
cc: zkabelac@redhat.com, Mike Snitzer <snitzer@redhat.com>, 
    dm-devel@lists.linux.dev
Subject: livelock caused by "dm: requeue IO if mapping table not yet
 available"
Message-ID: <45c0226e-d28c-974b-17ab-e161dd784306@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

The commit fa247089de9936a46e290d4724cb5f0b845600f5 ("dm: requeue IO if 
mapping table not yet available") causes a regression. It can be 
reproduced with this script (Zdenek hit it in his testing):

# dmsetup create --notable test
# truncate -s 1MiB testdata
# losetup /dev/loop0 testdata
# dmsetup load test --table '0 2048 linear /dev/loop0 0'
# dd if=/dev/zero of=/dev/dm-0 bs=16k count=1 conv=fdatasync

When you run the script, there will be a workqueue process looping and 
consuming 100% CPU. When you suspend and resume the device "test", the 
loop ends.


The reason for the bug is this - dm_submit_bio sees that map is NULL, so 
it offloads the bio using the function queue_io.

queue_io adds the bio to md->deferred and kicks the workqueue with 
"queue_work(md->wq, &md->work);"

dm_wq_work sees that test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags) is 
false, so it pops the bio from md->deferred and submits it with 
submit_bio_noacct.

submit_bio_noacct goes back to dm_submit_bio and we have a loop.


The commit fa247089de9936a46e290d4724cb5f0b845600f5 says that it fixes 
some race condition, however I don't quite know what the race condition 
is. Did the race condition really happen in your testing? What 
configuration did you use when you hit this race? Or do you just think 
that this is racy without hitting it?

Note that when you load a dm table for the first time, the nodes /dev/dm-0 
and /sys/block/dm-0 are created. When you suspend and resume the device, 
the node /dev/mapper/test is created. When udev does its work, the nodes 
in /dev/disk/*/ are created.

In order to hit this race condition, you must have some program that opens 
/dev/dm-0 early, without synchronizing with lvm or udev. Do you have a 
program that does it?

Also note, that when /dev/dm-0 is created, it has size 0, so that all 
reads and writes to it are automatically rejected by the upper layers. The 
only accepted bio is flush, which causes this livelock. So (from 
userspace) you can't do anything meaningful with the device at this point.

Mikulas

