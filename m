Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 092A2C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Mar 2022 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647461796;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IxNWdhDGpky9gQLyIGisttMzGm5piL5ZHpFKQdPVeLw=;
	b=ED268/rzKbeXQGSt7gAWhx5vz+/KcMfR/EioPyMRGGt2NweS6h3bxED4IMlQcYLiUPCYQn
	YULQ5ZRlPr4s6U40HO6wT0Qdzrqw4UL/OUmY68pjlhFnmeo0D57YL54ksGteeci9+5O9U1
	xJS3CgtFIcgRLcvudt4la+lkhOtwIt8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-eyaB2z-hNGaUHmIPQ7PdYQ-1; Wed, 16 Mar 2022 16:16:32 -0400
X-MC-Unique: eyaB2z-hNGaUHmIPQ7PdYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7BF680B710;
	Wed, 16 Mar 2022 20:16:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C4993215688A;
	Wed, 16 Mar 2022 20:16:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7993E1949763;
	Wed, 16 Mar 2022 20:16:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4EA3F1949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 20:16:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 212141427AFC; Wed, 16 Mar 2022 20:16:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FE0C1427AFB;
 Wed, 16 Mar 2022 20:16:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22GKGRvW019073;
 Wed, 16 Mar 2022 15:16:27 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22GKGQba019070;
 Wed, 16 Mar 2022 15:16:26 -0500
Date: Wed, 16 Mar 2022 15:16:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220316201626.GJ24684@octiron.msp.redhat.com>
References: <20220314213036.12074-1-mwilck@suse.com>
 <20220314213036.12074-6-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220314213036.12074-6-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 5/5] multipathd: remove volatile qualifier
 from running_state
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 14, 2022 at 10:30:36PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> running_state is only accessed while holding the config_lock, the
> volatile qualifier is superfluous.
> 
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 2424db7..b47a457 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -127,7 +127,7 @@ static int poll_dmevents = 0;
>  static int poll_dmevents = 1;
>  #endif
>  /* Don't access this variable without holding config_lock */
> -static volatile enum daemon_status running_state = DAEMON_INIT;
> +static enum daemon_status running_state = DAEMON_INIT;
>  /* Don't access this variable without holding config_lock */
>  static bool __delayed_reconfig;
>  pid_t daemon_pid;
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

