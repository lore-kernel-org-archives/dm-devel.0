Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401F9C004D4
	for <dm-devel@archiver.kernel.org>; Wed, 18 Jan 2023 08:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674029069;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=whqdNSRrct1vay0k0OAxTdsNWIRFsh3ugH9OSZ/EfSY=;
	b=I9pNV0xTyfFM0qIw5DStytwZvJLh429zRx9jiBPspnDxvECKbQOzERrLIdUQCuzdMcjskF
	3/6tQ0ipO4mG2XyH4AHNf50zfsgZMQcEbdDBRruElQ3R7plr6WSALsLl+WNqGWfsrt4rcw
	+BTxObFPTNDrYT8rWO8YscJ3tNXBf+Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-Gy7uLCztOMayet3pMafDBw-1; Wed, 18 Jan 2023 03:04:26 -0500
X-MC-Unique: Gy7uLCztOMayet3pMafDBw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CA5E1C08797;
	Wed, 18 Jan 2023 08:04:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4E2B492C3C;
	Wed, 18 Jan 2023 08:04:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 73AE01946A45;
	Wed, 18 Jan 2023 08:04:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BC9619465B3
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 Jan 2023 04:03:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23E2F1415108; Wed, 18 Jan 2023 04:03:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C471140EBF5
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 04:03:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01928811E6E
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 04:03:30 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-6sX23Sg2MBSaaAOsAQ9hnQ-1; Tue, 17 Jan 2023 23:03:17 -0500
X-MC-Unique: 6sX23Sg2MBSaaAOsAQ9hnQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A1367B81B08;
 Wed, 18 Jan 2023 03:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4584CC433EF;
 Wed, 18 Jan 2023 03:55:10 +0000 (UTC)
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
 id D3AE15C1052; Tue, 17 Jan 2023 19:55:09 -0800 (PST)
Date: Tue, 17 Jan 2023 19:55:09 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20230118035509.GS2948950@paulmck-ThinkPad-P17-Gen-1>
References: <20230113001103.GA3374173@paulmck-ThinkPad-P17-Gen-1>
 <20230113001132.3375334-6-paulmck@kernel.org>
 <Y8cqfvrfd3pL9ToJ@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y8cqfvrfd3pL9ToJ@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 18 Jan 2023 08:04:20 +0000
Subject: Re: [dm-devel] [PATCH rcu v2 06/20] drivers/md: Remove "select SRCU"
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
Reply-To: paulmck@kernel.org
Cc: linux-raid@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
 kernel-team@meta.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, rcu@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 17, 2023 at 06:08:46PM -0500, Mike Snitzer wrote:
> On Thu, Jan 12 2023 at  7:11P -0500,
> Paul E. McKenney <paulmck@kernel.org> wrote:
> 
> > Now that the SRCU Kconfig option is unconditionally selected, there is
> > no longer any point in selecting it.  Therefore, remove the "select SRCU"
> > Kconfig statements.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Song Liu <song@kernel.org>
> > Cc: Alasdair Kergon <agk@redhat.com>
> > Cc: Mike Snitzer <snitzer@kernel.org>
> > Cc: <dm-devel@redhat.com>
> > Cc: <linux-raid@vger.kernel.org>
> > Reviewed-by: John Ogness <john.ogness@linutronix.de>
> 
> Acked-by: Mike Snitzer <snitzer@kernel.org>

Will apply on my next rebase, thank you!

							Thanx, Paul

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

