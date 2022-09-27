Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 864FBC54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664294965;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M8RmXiczHTAqNyCsoeXv67wfiI+tl+ZdHaOB0y3srxA=;
	b=SC5Ryayw3YWyBNmhZOqCXixhVwwtglv72DJVyQwRW4FRhlMY6rq8F14u8KA12XojvRUpl4
	IAIfUwx4YakMjhcfxVPnD5Y5C/K+oMHe+fLSU2g/D27z0SuyLLY6bQ8dxfoe4/0fWshsSD
	+i3b+fO9A5lwg8l3ShP22XnAFtpqw8Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-u5OsQY3_MxmHaA0r_sXwLg-1; Tue, 27 Sep 2022 12:09:22 -0400
X-MC-Unique: u5OsQY3_MxmHaA0r_sXwLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7789299E76C;
	Tue, 27 Sep 2022 16:09:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 59255140EBF3;
	Tue, 27 Sep 2022 16:09:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 218A819465B1;
	Tue, 27 Sep 2022 16:09:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6BFD51946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 16:09:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B452492B05; Tue, 27 Sep 2022 16:09:19 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36ECB492B04;
 Tue, 27 Sep 2022 16:09:19 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28RG9J9g005322; Tue, 27 Sep 2022 12:09:19 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28RG9JgO005318; Tue, 27 Sep 2022 12:09:19 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 27 Sep 2022 12:09:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <YzGYFBv0pdt+DQg+@kroah.com>
Message-ID: <alpine.LRH.2.02.2209271206240.5208@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209260418360.16612@file01.intranet.prod.int.rdu2.redhat.com>
 <YzGYFBv0pdt+DQg+@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] kernfs: fix a crash when two processes
 delete the same directory
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
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, Christoph Lameter <cl@linux.com>,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 26 Sep 2022, Greg Kroah-Hartman wrote:

> Can you see if 4abc99652812 ("kernfs: fix use-after-free in
> __kernfs_remove") in linux-next fixes this for you or not?  It seems to
> be the same issue, as was also reported at:
> 	https://lore.kernel.org/r/7f489b14-2fdc-3d91-c87e-6a802bd8592d@I-love.SAKURA.ne.jp
> 
> thanks,
> 
> greg k-h

I'm running the test with the patch 4abc99652812 for 3 hours, no crash, so 
it's probably ok.

Tested-by: Mikulas Patocka <mpatocka@redhat.com>

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

