Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F42FC27C40
	for <dm-devel@archiver.kernel.org>; Thu, 24 Aug 2023 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692887931;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/p1WRNfYMKWqHumh9nTFaF7x8DJx+2sarGyu6ARMQKk=;
	b=PAUBsDF7Y/zXHubDeBg4IUDlsKn0YlafOnKHaJysZXmddUcAKYFWk4E2lzIABGi+bnL2dr
	1ajWdyVsY8duOPDic/mDDVihxbztxph90Y8JIAIMKzw8zwX9VtS32ZV08KjJDL1vDESTcc
	QR56AJ2GZDHQwlgplWIW4+qfzntQOgA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-mESwmlKoMNKdE37B5TA3KA-1; Thu, 24 Aug 2023 10:38:47 -0400
X-MC-Unique: mESwmlKoMNKdE37B5TA3KA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 285228D40A0;
	Thu, 24 Aug 2023 14:38:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1336E1121314;
	Thu, 24 Aug 2023 14:38:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2956619465A0;
	Thu, 24 Aug 2023 14:37:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3561D1946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Aug 2023 14:37:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24040140E962; Thu, 24 Aug 2023 14:37:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B4DF140E963;
 Thu, 24 Aug 2023 14:37:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 37OEbVOL016522;
 Thu, 24 Aug 2023 09:37:31 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 37OEbUWE016521;
 Thu, 24 Aug 2023 09:37:30 -0500
Date: Thu, 24 Aug 2023 09:37:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Message-ID: <20230824143730.GG7412@octiron.msp.redhat.com>
References: <1690571155-8283-1-git-send-email-bmarzins@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1690571155-8283-1-git-send-email-bmarzins@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [RFC PATCH 0/4] Make prio timeouts work like checkers
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 28, 2023 at 02:05:51PM -0500, Benjamin Marzinski wrote:

Ping. Perhaps this patchset got overlooked.

-Ben

> This patchset changes how prioritizers set their timeouts, to make them
> match how the checker functions work, and also cleans up some minor
> timeout issues. I did this to make out timeouts consistent, but if
> someone has a good reason to object to that, I don't feel
> strongly that it's necessary, and I can resend just the bugfixes.
> 
> Benjamin Marzinski (4):
>   libmultipath: don't bother to reset default timeout value
>   libmultipath: make prioritizer timeouts work like checker timeouts
>   libmultipath: fix timeouts for detect_alua()
>   libmultipath: fix timeouts for path_latency prioritizer
> 
>  libmultipath/discovery.c                 | 13 +++++++------
>  libmultipath/prio.c                      | 14 +++++++++-----
>  libmultipath/prio.h                      |  3 +--
>  libmultipath/prioritizers/alua.c         |  2 +-
>  libmultipath/prioritizers/alua_rtpg.c    |  5 ++---
>  libmultipath/prioritizers/emc.c          |  5 +++--
>  libmultipath/prioritizers/hds.c          |  4 ++--
>  libmultipath/prioritizers/hp_sw.c        |  4 ++--
>  libmultipath/prioritizers/ontap.c        |  7 +++----
>  libmultipath/prioritizers/path_latency.c |  5 +++--
>  libmultipath/prioritizers/rdac.c         |  4 ++--
>  11 files changed, 35 insertions(+), 31 deletions(-)
> 
> -- 
> 2.17.2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

