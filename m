Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A47C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667567380;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0Vhcw3/1Exdm3p2xmkjldwNgSo5Oe69c8tQAJWBLlxM=;
	b=GowGS0mSE62ZyFkez3hSf/g+emshEGTDldZKTMAavvcQWFFkHEFHqAPa7boFGLnC3ocKDp
	ICmotwrq6PerxVrox94Y/jQQKQ/XIbN8Vt5QyfCDwYmsC15cJKb6J4IKEZmruk+hoJpJkX
	weyYceeH2Wua1EXXQZTyx2kZEhzq0GM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447--hBpHx9uM4-cDWcBGQ0LTg-1; Fri, 04 Nov 2022 09:09:37 -0400
X-MC-Unique: -hBpHx9uM4-cDWcBGQ0LTg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCAA08027F5;
	Fri,  4 Nov 2022 13:09:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D83D040C6EE9;
	Fri,  4 Nov 2022 13:09:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB9BB1946587;
	Fri,  4 Nov 2022 13:09:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EC1171946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 13:09:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D69A6401E54; Fri,  4 Nov 2022 13:09:32 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 87E7449BB9A;
 Fri,  4 Nov 2022 13:09:32 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2A4D9WZ5019732; Fri, 4 Nov 2022 09:09:32 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2A4D9VcB019728; Fri, 4 Nov 2022 09:09:31 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Fri, 4 Nov 2022 09:09:31 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Keith Busch <kbusch@kernel.org>
In-Reply-To: <Y2Qm/yGlVbDRskkr@kbusch-mbp.dhcp.thefacebook.com>
Message-ID: <alpine.LRH.2.21.2211040908140.19553@file01.intranet.prod.int.rdu2.redhat.com>
References: <20221103152559.1909328-1-kbusch@meta.com>
 <alpine.LRH.2.21.2211031224060.10758@file01.intranet.prod.int.rdu2.redhat.com>
 <Y2Qm/yGlVbDRskkr@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 0/3] fix direct io errors on dm-crypt
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, Keith Busch <kbusch@meta.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com, stefanha@redhat.com,
 me@demsh.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Thu, 3 Nov 2022, Keith Busch wrote:

> On Thu, Nov 03, 2022 at 12:33:19PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > The patchset seems OK - but dm-integrity also has a limitation that the 
> > bio vectors must be aligned on logical block size.
> > 
> > dm-writecache and dm-verity seem to handle unaligned bioset, but you 
> > should check them anyway.
> > 
> > I'm not sure about dm-log-writes.
> 
> Yeah, dm-integrity definitly needs it too. This is easy enough to use
> the same io_hint that I added for dm-crypt.
> 
> dm-log-writes is doing some weird things with writes that I don't think
> would work with some low level drivers without the same alignment
> constraint.
> 
> The other two appear to handle this fine, but I'll run everything
> through some focused test cases to be sure.
> 
> In the meantime, do you want to see the remaining mappers fixed in a v2,
> or are you okay if they follow after this series?

I don't care if you make a separate patch or fold it into an existing 
patch.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

