Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68100E7D0AE
	for <dm-devel@archiver.kernel.org>; Thu, 21 Sep 2023 21:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695332049;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ALZ6ivyCSJt00fvoWeptmoU3Am+FToiXcBR4kLmDtC4=;
	b=NWaLGUCwKdOKxCfvp9Q844XId5o1w9Cibf2RpWj6wG6r5oW5Z/dbMkJClYf1YjzUxicSiI
	dnKPCOmnW/ZHQUMzCz77rE0JstTDq8+/bu2QVFfsIYl4iTzLh6xXsPnLzWRzgrruIF21Cu
	ijXP8qTxZC7Y4lDkTrQS9r0/eFtLtBo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-9ugwQ7PeNcybjWkU-7xnMA-1; Thu, 21 Sep 2023 17:34:06 -0400
X-MC-Unique: 9ugwQ7PeNcybjWkU-7xnMA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1004B101A53B;
	Thu, 21 Sep 2023 21:34:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 864DF492C37;
	Thu, 21 Sep 2023 21:34:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 49D911946595;
	Thu, 21 Sep 2023 21:34:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B8D541946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Sep 2023 20:40:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 71A02C158BA; Thu, 21 Sep 2023 20:40:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A184C15BB8
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 20:40:51 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 503B1101A529
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 20:40:51 +0000 (UTC)
Received: from mail.ultracoder.org (188.227.94.15.ptspb.net [188.227.94.15])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-gngx6P36MhW4PI0zKKcjrw-1; Thu,
 21 Sep 2023 16:40:49 -0400
X-MC-Unique: gngx6P36MhW4PI0zKKcjrw-1
Message-ID: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
Date: Thu, 21 Sep 2023 23:34:02 +0300
MIME-Version: 1.0
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
From: Kirill Kirilenko <kirill@ultracoder.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Thu, 21 Sep 2023 21:33:57 +0000
Subject: [dm-devel] fstrim on raid1 LV with writemostly PV leads to system
 freeze
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ultracoder.org
Content-Language: ru-RU, en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hello.

I created two LVM physical volumes: one on NVMe device and one on SATA 
SSD. I added them to a volume group and created a logical RAID1 volume 
in it. Then I enabled 'writemostly' flag on the second (slowest) PV.
And my system started to freeze at random times with no messages in 
syslog. I was able to determine that the freezing was happening during 
execution of 'fstrim' (via systemd timer). I checked this by running 
'fstrim' manually.
If I disable the 'writemostly' flag, I experience no freezes. I can 
reproduce this behavior on vanilla 6.5.0 kernel.

My LV is 150 GB ext4 volume, and it has lots of files in it, so running 
'fstrim' takes around a minute. This may be important.

Additional information:
OS: Linux Mint 21.2
CPU: AMD Ryzen 7 5800X
NVMe: Samsung SSD 980 500GB
SATA SSD: Samsung SSD 850 EVO M.2 250GB

Best regards,
Kirill Kirilenko.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

