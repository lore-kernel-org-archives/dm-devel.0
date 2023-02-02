Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B965C05027
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675349233;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OJAVUWDhP2R+cIF/JHSCJFatJDPgG2PQq9MAeJozPmE=;
	b=E2igQ2YAUE3gtygGqJilgIMedYyqh1fwdCvMqENd6aH6ZPWMAdPGMMlKCnf21wVeUJ523F
	YxDZ/omaX2FWeKh1BYbEk4uFP6GjDe5X9SQb3RGRuhrKehGnR30fnvuvmcqBndHJrlNNyH
	hpAo9+2wZ+8kCgFMnREstu2dXSi9EbA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-8EOerubYNOeabDv3ygyRQA-1; Thu, 02 Feb 2023 09:47:12 -0500
X-MC-Unique: 8EOerubYNOeabDv3ygyRQA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD16587A9E0;
	Thu,  2 Feb 2023 14:47:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BCFFA2026D4B;
	Thu,  2 Feb 2023 14:47:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8FEA8194658C;
	Thu,  2 Feb 2023 14:47:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A80B91946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 14:47:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C228112132D; Thu,  2 Feb 2023 14:47:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3917112132C;
 Thu,  2 Feb 2023 14:47:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 312EkxHs015444;
 Thu, 2 Feb 2023 08:46:59 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 312Ekxrg015443;
 Thu, 2 Feb 2023 08:46:59 -0600
Date: Thu, 2 Feb 2023 08:46:58 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230202144658.GZ17327@octiron.msp.redhat.com>
References: <20230202084220.17447-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230202084220.17447-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] libmpathpersist: fix resource leak in
 update_map_pr()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 02, 2023 at 09:42:20AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The "no available paths" case would leak the memory resp points to.
> Found by coverity.
> 
> Fixes: 50e2c16 ("multipathd: handle no active paths in update_map_pr")

Oops.
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist_int.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
> index 8b52b74..178c2f5 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -733,7 +733,7 @@ int update_map_pr(struct multipath *mpp)
>  	int noisy=0;
>  	struct prin_resp *resp;
>  	unsigned int i;
> -	int ret, isFound;
> +	int ret = MPATH_PR_OTHER, isFound;
>  
>  	if (!get_be64(mpp->reservation_key))
>  	{
> @@ -754,7 +754,7 @@ int update_map_pr(struct multipath *mpp)
>  	{
>  		condlog(0,"%s: No available paths to check pr status",
>  			mpp->alias);
> -		return MPATH_PR_OTHER;
> +		goto out;
>  	}
>  	mpp->prflag = PRFLAG_UNSET;
>  	ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp, noisy);
> @@ -762,15 +762,15 @@ int update_map_pr(struct multipath *mpp)
>  	if (ret != MPATH_PR_SUCCESS )
>  	{
>  		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
> -		free(resp);
> -		return  ret;
> +		goto out;
>  	}
>  
> +	ret = MPATH_PR_SUCCESS;
> +
>  	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
>  	{
>  		condlog(3,"%s: No key found. Device may not be registered. ", mpp->alias);
> -		free(resp);
> -		return MPATH_PR_SUCCESS;
> +		goto out;
>  	}
>  
>  	condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias,
> @@ -795,6 +795,7 @@ int update_map_pr(struct multipath *mpp)
>  		condlog(2, "%s: prflag flag set.", mpp->alias );
>  	}
>  
> +out:
>  	free(resp);
> -	return MPATH_PR_SUCCESS;
> +	return ret;
>  }
> -- 
> 2.39.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

