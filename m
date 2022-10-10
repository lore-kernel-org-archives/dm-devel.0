Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0896C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 10 Oct 2022 12:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665405314;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I0/FKwi4UNytF8cgcQ9qkZGX+HEUE8Wz7B9CLl/zDAQ=;
	b=Eiv0oA8SgOGw1nnxDT3zzKXzdfrnSeEWFTTMWUrWQ40pRYtknzBIIlZHJp210PftEldr7P
	ZAiq7iLEST30qIQmHgFjERHh+CGec7KU64i6gZJprZTZWfspdwofyl4Ws2/YGcfrXw0UZ0
	OQ1QJJs8EM4IF0z+QBvXdGRIGGZe2XM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-0rLg6fcAMEa-vOmCG58VBQ-1; Mon, 10 Oct 2022 08:35:11 -0400
X-MC-Unique: 0rLg6fcAMEa-vOmCG58VBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEAEE8582B9;
	Mon, 10 Oct 2022 12:35:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BFCE2027061;
	Mon, 10 Oct 2022 12:35:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4439319465A0;
	Mon, 10 Oct 2022 12:35:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 26E761946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Oct 2022 12:35:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D4FC4C2112; Mon, 10 Oct 2022 12:35:05 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C0502C77C2;
 Mon, 10 Oct 2022 12:35:05 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 29ACZ5rv026595; Mon, 10 Oct 2022 08:35:05 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 29ACZ5OR026591; Mon, 10 Oct 2022 08:35:05 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 10 Oct 2022 08:35:05 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
Message-ID: <alpine.LRH.2.02.2210100811400.25650@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 0/4] dm-thin: reduce lock contention when walking
 the btree
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

Here I'm sending the patches for dm-bufio and dm-thin that reduce lock 
contention when processing I/Os on already provisioned space.

The first patch introduces a new API to dm-bufio that allows to lock bufio 
and do multiple queries.

The second patch switches dm-bufio lock from mutex to rm_semaphore, so 
that we can process queries from multiple processes simultaneously.

The third patch simplifies struct ro_spine so that it holds a pointer to 
just one buffer.

The fourth patch makes dm-thin use the new dm-bufio interface when walking 
a btree.

I tested it on persistent memory (emulated with the "memmap" kernel 
argument). I set up the test with these commands:
# vgcreate vg /dev/pmem0
# lvcreate --thinpool pool -L 32GiB vg
# lvcreate -V 16GiB -n thin --thinpool pool vg
# dd if=/dev/zero of=/dev/vg/thin bs=1M oflag=direct status=progress

Then I used
# fio --ioengine=psync --iodepth=1 --rw=randrw --bs=4k --direct=1 
  --numjobs=12 --time_based --runtime=10 --group_reporting 
  --name=/dev/vg/thin

Throughput before the patches:
READ: bw=286MiB/s
WRITE: bw=286MiB/s

Throughput after the patches:
READ: bw=442MiB/s
WRITE: bw=442MiB/s

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

