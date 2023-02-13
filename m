Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CECBC636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 08:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676277251;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C8hv6kB8jaEHtybyEemT8GH3iHGfqwzTeehLXBkYUb8=;
	b=O5L5XZO4oUzQl7Q55A/eBWoGfnjCJl0gh0uryWLwVSO453lOVmGkF82Y6ZQEuliIuRTQ+k
	sxpVuHGkXpxmeP9xh5Hz7C1kdDV28yM+rWkDc1tQwBWpmokcLXyudc5H9GXSPiE3hEvGsk
	eE+Wys84vliPokxFAUZ+TGkhbH+YyOw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-qg8bGF10OfOdiZwag5D-fQ-1; Mon, 13 Feb 2023 03:34:05 -0500
X-MC-Unique: qg8bGF10OfOdiZwag5D-fQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 207EE857F43;
	Mon, 13 Feb 2023 08:34:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 11598492B03;
	Mon, 13 Feb 2023 08:33:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CF84E1946587;
	Mon, 13 Feb 2023 08:33:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE8E51946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 03:07:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBC67C16023; Mon, 13 Feb 2023 03:07:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5115C16022
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 03:07:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98BD0884340
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 03:07:24 +0000 (UTC)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com
 [209.85.217.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-553-XqE6HunnNwmjWXdKIVAbNQ-1; Sun, 12 Feb 2023 22:07:20 -0500
X-MC-Unique: XqE6HunnNwmjWXdKIVAbNQ-1
Received: by mail-vs1-f41.google.com with SMTP id z15so1095549vsj.12
 for <dm-devel@redhat.com>; Sun, 12 Feb 2023 19:07:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=kcHnI96zNjfQlLYDodJwKwSlXVI5y4LSVOx8M0TZ8ZU=;
 b=RbXs9IODBFOMu3mYH5qMg3SM+SqMEihgIZjHJ9GvbUoZOjfAO7PApNskF8kX4bYTx9
 TJ0rGnfKSRaS+agYp4bxFbzPpjvlfjtiU7EGEO+bhIv2+JnRhinYpBdmWLfLVxYWB/Qx
 tsBEe6v68EvZ4zWIXTOCJVWDNzKLEvR7gjsttTlO1xAK5cEkZ/WHxAIXJUTEt/N58L/I
 aD4enTo15SvaJkz4WF0wLqpHuQtIBI+A5HIlX61cHV+WXAChevDDl/KYTz3zvu+1NEIx
 uhTTsNf1rAIKXG6aC1HgCuDUBaO6sUKKhpvKvhE8PXHAyQNBqNTKwcE6t8WGI5iGYUDu
 j81g==
X-Gm-Message-State: AO0yUKU9owQPZ9hJPmqL6stL1o1D42o8RZ3WP0z7JftHCwGNXIAVALqj
 sPiJIZiCevSgFx7ptsRT7V/Sju0DJxLXSDygOfR+mW5M
X-Google-Smtp-Source: AK7set8iEjeN78Q7+12/hG2Oj6DiGKxWZmsCx8JOLarTr8A1PYmgakLmXoZmHMsilJeX5BhTiaU0vJWHNrlWguub4Xw=
X-Received: by 2002:a05:6102:a22:b0:412:317f:e15f with SMTP id
 2-20020a0561020a2200b00412317fe15fmr32440vsb.29.1676257636873; Sun, 12 Feb
 2023 19:07:16 -0800 (PST)
MIME-Version: 1.0
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Sun, 12 Feb 2023 19:07:05 -0800
Message-ID: <CACsaVZJvXpCt37nQOoe8qd1EPUpfdMM1HwHk9tVO8HdU_Azhhw@mail.gmail.com>
To: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 13 Feb 2023 08:33:57 +0000
Subject: [dm-devel] RAID4 with no striping mode request
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
Cc: Song Liu <song@kernel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

hi DM and Linux-RAID,

There have been multiple proprietary solutions (some nearly 20 years
old now) with a number of (userspace) bugs that are becoming untenable
for me as an end user. Basically how they work is a closed MD module
(typically administered through DM) that uses RAID4 for a dedicated
parity disk across multiple other disks.

As there is no striping, the maximum size of the protected data is the
size of the parity disk (so a set of 4+8+12+16 disks can be protected
by a single dedicated 16 disk).When a block is written on any disk,
the parity bit is read from the parity disk again, and updated
depending on the existing + new bit value (so writing disk + parity
disk spun up). Additionally, if enough disks are already spun up, the
parity information can be recalculated from all of the spinning disks,
resulting in a single write to the parity disk (without a read on the
parity, doubling throughput). Finally any of the data disks can be
moved around within the array without impacting parity as the layout
has not changed. I don't necessarily need all of these features, just
the ability to remove a disk and still access the data that was on
there by spinning up every other disk until the rebuild is complete is
important.

The benefit of this can be the data disks are all zoned, and you can
have a fast parity disk and still maintain excellent performance in
the array (limited only by the speed of the disk in question +
parity). Additionally, should 2 disks fail, you've either lost the
parity and data disk, or 2 data disks with the parity and other disks
not lost.

I was reading through the DM and MD code and it looks like everything
may already be there to do this, just needs (significant) stubs to be
added to support this mode (or new code). Snapraid is a friendly (and
respectable) implementation of this. Unraid and Synology SHR compete
in this space, as well as other NAS and enterprise SAN providers.

Kyle.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

