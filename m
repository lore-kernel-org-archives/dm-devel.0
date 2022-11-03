Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B37C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 13:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667480458;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=64jLd916dqrVMadFFBY1JnpjFoJncH8ynm+3O2Hbc+M=;
	b=Txb36M4MWs0FzlDylNf1glTD7muzG+AGGxh+MKSAQaqmxTisKLiXdLTij8Wgn6tecTYoj9
	10/3WRbKJ+I1km+ELMNEkLEK5SYHUN1Zu9jA1zEpYePQtDRXnIKjw3DIw3PoYTdWv6nzYp
	sFlCIfcxyzs3hOkIUi/2iYGRWb6hr0Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-808H8hQXN9GBLW_CSEANYg-1; Thu, 03 Nov 2022 09:00:54 -0400
X-MC-Unique: 808H8hQXN9GBLW_CSEANYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2E7D185A78F;
	Thu,  3 Nov 2022 13:00:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19DF82166B46;
	Thu,  3 Nov 2022 13:00:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D775219465A4;
	Thu,  3 Nov 2022 13:00:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F71219465A4
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 13:00:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4E8C9111CD3A; Thu,  3 Nov 2022 13:00:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A9641121325;
 Thu,  3 Nov 2022 13:00:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2A3D0ntR011491; Thu, 3 Nov 2022 09:00:49 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2A3D0nBl011487; Thu, 3 Nov 2022 09:00:49 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 3 Nov 2022 09:00:49 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Guoqing Jiang <guoqing.jiang@linux.dev>,
 Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
Message-ID: <alpine.LRH.2.21.2211030851090.10884@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="185206533-311995707-1667479929=:10884"
Content-ID: <alpine.LRH.2.21.2211030854150.10884@file01.intranet.prod.int.rdu2.redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-311995707-1667479929=:10884
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LRH.2.21.2211030854151.10884@file01.intranet.prod.int.rdu2.redhat.com>



On Thu, 3 Nov 2022, Guoqing Jiang wrote:

> Hi,
> 
> On 11/3/22 12:27 AM, Mikulas Patocka wrote:
> > Hi
> > 
> > There's a crash in the test shell/lvchange-rebuild-raid.sh when running
> > the lvm testsuite. It can be reproduced by running "make check_local
> > T=shell/lvchange-rebuild-raid.sh" in a loop.
> 
> I have problem to run the cmd (not sure what I missed), it would be better if
> the relevant cmds are extracted from the script then I can reproduce it with
> those cmds directly.

Ask Zdenek Kabelac to help you with running the testsuite. He has better 
understanding of the testsuite than me.

> BTW, is the mempool_free from endio -> dec_count -> complete_io?
> And io which caused the crash is from dm_io -> async_io / sync_io
>  -> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
> suppose the io is for mirror image.
> 
> Thanks,
> Guoqing

I presume that the bug is caused by destruction of a bio set while bio 
from that set was in progress. When the bio finishes and an attempt is 
made to free the bio, a crash happens when the code tries to free the bio 
into a destroyed mempool.

I can do more testing to validate this theory.

Mikulas
--185206533-311995707-1667479929=:10884
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--185206533-311995707-1667479929=:10884--

