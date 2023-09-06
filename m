Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C89EE14AA
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040143;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5TUK2qiRuNX8TIZAO92tPicWJDNMjJWu1W+ASpakWdU=;
	b=V8Dz5IaQCuGmMF+SUs/ypHQGB6QgTOsHC6r+J6HvAGDXj3IbterXMoH6+DVHJyxn2fnjCr
	Tf9Q4dpctvMpSd12/fkh3NYGfiie9r47s//tp027nO8NzVgYN7WiJtMAaGdP6+4K615Spa
	7p7kqtK/HBFD9djtWFqHswpF10CD7U4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-_1BIiKP8MWSj5z3IPEiukw-1; Wed, 06 Sep 2023 18:42:20 -0400
X-MC-Unique: _1BIiKP8MWSj5z3IPEiukw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97C198001EA;
	Wed,  6 Sep 2023 22:42:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 480DD1121318;
	Wed,  6 Sep 2023 22:42:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 21793194658D;
	Wed,  6 Sep 2023 22:42:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95C7A194658D
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:42:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 768941121318; Wed,  6 Sep 2023 22:42:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BB051121314;
 Wed,  6 Sep 2023 22:42:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386Mg8jN028899;
 Wed, 6 Sep 2023 17:42:08 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386Mg7gC028898;
 Wed, 6 Sep 2023 17:42:07 -0500
Date: Wed, 6 Sep 2023 17:42:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224207.GL7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-2-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-2-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 01/21] libmultipath: sysfs_set_scsi_tmo: do
 nothing for ACT_DRY_RUN
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
Cc: dm-devel@redhat.com, Jehan Singh <jehan.singh@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:14PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> "multipath -d" might change sysfs timeouts of SCSI devices.
> Make sure it doesn't.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: Jehan Singh <jehan.singh@suse.com>
> ---
>  libmultipath/configure.c | 4 ++--
>  libmultipath/discovery.c | 3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 9513baa..029fbbd 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -1193,13 +1193,13 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
>  
>  		if (cmpp)
>  			mpp->queue_mode = cmpp->queue_mode;
> +		if (cmd == CMD_DRY_RUN && mpp->action == ACT_UNDEF)
> +			mpp->action = ACT_DRY_RUN;
>  		if (setup_map(mpp, &params, vecs)) {
>  			remove_map(mpp, vecs->pathvec, NULL);
>  			continue;
>  		}
>  
> -		if (cmd == CMD_DRY_RUN)
> -			mpp->action = ACT_DRY_RUN;
>  		if (mpp->action == ACT_UNDEF)
>  			select_action(mpp, curmp,
>  				      force_reload == FORCE_RELOAD_YES ? 1 : 0);
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index e4de48e..84ce5fe 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -857,6 +857,9 @@ sysfs_set_scsi_tmo (struct config *conf, struct multipath *mpp)
>  	bool warn_dev_loss = false;
>  	bool warn_fast_io_fail = false;
>  
> +	if (mpp->action == ACT_DRY_RUN || mpp->action == ACT_REJECT)
> +		return 0;
> +
>  	if (mpp->no_path_retry > 0) {
>  		uint64_t no_path_retry_tmo =
>  			(uint64_t)mpp->no_path_retry * conf->checkint;
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

