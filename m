Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DB1C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Mar 2022 20:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1647461680;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WfLDVISSOpYg2FVPVDtoNt9571kRC+Oux0VjOjOqwmI=;
	b=Wv4EXcO/ZXkiOQVOTigKodzlhyAGFcJAs5cAbSxmJD6X7e8pZXS6eN0QarPIiSNgfXlm5F
	GmJAzwkMIVQWSZK9/jwYOYi0gC02VIHTZkxyN/X1C3DHfU+Ec2l8zXtf9eX3wN0IbQKOa6
	9d9G2E9ri46ltatdHYuCQ0w6nVobICU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-fcPvxySXOtOnOQ0enANTDA-1; Wed, 16 Mar 2022 16:14:37 -0400
X-MC-Unique: fcPvxySXOtOnOQ0enANTDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9410D3C23FA2;
	Wed, 16 Mar 2022 20:14:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 817314047D00;
	Wed, 16 Mar 2022 20:14:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 29FFE1940345;
	Wed, 16 Mar 2022 20:14:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E45941949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 16 Mar 2022 20:14:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BCB22C23DC5; Wed, 16 Mar 2022 20:14:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ABE31C23DC3;
 Wed, 16 Mar 2022 20:14:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22GKEXBW019014;
 Wed, 16 Mar 2022 15:14:33 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22GKEVtl019011;
 Wed, 16 Mar 2022 15:14:31 -0500
Date: Wed, 16 Mar 2022 15:14:31 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220316201431.GH24684@octiron.msp.redhat.com>
References: <20220314213036.12074-1-mwilck@suse.com>
 <20220314213036.12074-2-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220314213036.12074-2-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 1/5] multipathd: child(): remove superfluous
 if condition
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 14, 2022 at 10:30:32PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> No need to test for state == DAEMON_CONFIGURE at this point, we
> know that this is the case.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f2c0b28..1c8839d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3395,6 +3395,8 @@ child (__attribute__((unused)) void *param)
>  	pthread_attr_destroy(&misc_attr);
>  
>  	while (1) {
> +		int rc = 0;
> +
>  		pthread_cleanup_push(config_cleanup, NULL);
>  		pthread_mutex_lock(&config_lock);
>  		while (running_state != DAEMON_CONFIGURE &&
> @@ -3404,23 +3406,21 @@ child (__attribute__((unused)) void *param)
>  		pthread_cleanup_pop(1);
>  		if (state == DAEMON_SHUTDOWN)
>  			break;
> -		if (state == DAEMON_CONFIGURE) {
> -			int rc = 0;
>  
> -			pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -			lock(&vecs->lock);
> -			pthread_testcancel();
> -			if (!need_to_delay_reconfig(vecs))
> -				rc = reconfigure(vecs);
> -			else
> -				enable_delayed_reconfig();
> -			lock_cleanup_pop(vecs->lock);
> -			if (!rc)
> -				post_config_state(DAEMON_IDLE);
> -			else {
> -				condlog(0, "fatal error applying configuration - aborting");
> -				exit_daemon();
> -			}
> +		/* handle DAEMON_CONFIGURE */
> +		pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +		lock(&vecs->lock);
> +		pthread_testcancel();
> +		if (!need_to_delay_reconfig(vecs))
> +			rc = reconfigure(vecs);
> +		else
> +			enable_delayed_reconfig();
> +		lock_cleanup_pop(vecs->lock);
> +		if (!rc)
> +			post_config_state(DAEMON_IDLE);
> +		else {
> +			condlog(0, "fatal error applying configuration - aborting");
> +			exit_daemon();
>  		}
>  	}
>  
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

