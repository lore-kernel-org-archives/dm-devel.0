Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33490C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638194746;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=adYYkoLkOINuwdtQz7F01NU2hZuhJfJc26xU8lFVOe8=;
	b=IgMljK7uXPIw/Nt/Tcu0Ha+0+9CyMW12ZaabxF9j9R5vy7COmYCdXD2hZ5MJrU0V9gkJTG
	zH3xdYZvvmv/RM21DFSqmKQR7otqXFMFGI9vxCbjt3+n9H3pHLm6a7fg4ZCJT9nsOqq0Yi
	NZUTdgWf0+88fRtpdnP91f6c+BjjbUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-309-Y-7Xshl5Pq-VkHy48dzs-w-1; Mon, 29 Nov 2021 09:05:43 -0500
X-MC-Unique: Y-7Xshl5Pq-VkHy48dzs-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BA8C801B30;
	Mon, 29 Nov 2021 14:05:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F86F5D9DE;
	Mon, 29 Nov 2021 14:05:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 884374BB7B;
	Mon, 29 Nov 2021 14:04:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATE4vNb031262 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 09:04:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7B08E7E643; Mon, 29 Nov 2021 14:04:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB2547E642;
	Mon, 29 Nov 2021 14:04:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 1ATE4OfY010173; Mon, 29 Nov 2021 09:04:24 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 1ATE4OHg010169; Mon, 29 Nov 2021 09:04:24 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Mon, 29 Nov 2021 09:04:24 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Akilesh Kailash <akailash@google.com>,
	Kelvin Zhang <zhangkelvin@google.com>, Tianjie Xu <xunchang@google.com>
In-Reply-To: <CABSDvDL5gi9KQ3+x1+0vonSFX-OZdd6NeD-XO-d_nvwXtbRMqA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2111290858100.9550@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvDL23UZ8KMrjK+qm0Lw0bfDaWh2TruZ2kLgGXqidgOt0jQ@mail.gmail.com>
	<20211124003831.GB63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<20211124010239.GC63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<CABSDvDL5gi9KQ3+x1+0vonSFX-OZdd6NeD-XO-d_nvwXtbRMqA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
	dm-devel@redhat.com, David Anderson <dvander@google.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] announcing the dm-update target
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 23 Nov 2021, Akilesh Kailash wrote:

> With OTA, it is challenging to have one general COW format - for instance
> what is good for the Android ecosystem may not be useful for the
> enterprise world.
> For ex: Most of the space savings in Android comes from COPY operation i.e
> for an incremental OTA, we would have metadata which states:
> 
> COPY BLOCK X -> BLOCK Y
> 
> There is no compression involved with these operations. Compression is only
> when a block is "replaced". All these are too specific to the Android ecosystem.

Why does Android OTA need the COPY operation? If a file is not changed by 
the update, the file could be placed at the same location and no update of 
the file is needed. If a file is changed, it is improbable that the new 
file will contain permutation of blocks of the old file, so I don't see 
how COPY will help here.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

