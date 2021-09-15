Return-Path: <SRS0=IV6L=OF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E10C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 22:16:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1372B608FB
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 22:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1372B608FB
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631744193;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cCM895rynzNYiGU+p05H33m5DVmvi4GrruhBi8FW5ew=;
	b=ffPodySbiSy1PatS/SDzJlrMA5oTf2nyQmXMLPD3pge0qUPY78JMmr0BALIRBFQ4j29P3H
	WGPW918JpYSwXcCs2qNtexd3xG6RwMMAwUzDUwPBC7lH7A/kk7wumrLR45Nfgh6Q+LELUX
	QfGYf7zE91N4ctmdbu96b7aPskKWOc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-zOXbYN_jNWSuvkYX3MgECg-1; Wed, 15 Sep 2021 18:16:31 -0400
X-MC-Unique: zOXbYN_jNWSuvkYX3MgECg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9466F802937;
	Wed, 15 Sep 2021 22:16:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7686A3AC0;
	Wed, 15 Sep 2021 22:16:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4BEEB4EA2A;
	Wed, 15 Sep 2021 22:16:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18FMEcCb008608 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 18:14:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8EFC95D9F4; Wed, 15 Sep 2021 22:14:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F08705D9CA;
	Wed, 15 Sep 2021 22:14:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18FMEXn0006361; 
	Wed, 15 Sep 2021 17:14:33 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18FMEWGs006360;
	Wed, 15 Sep 2021 17:14:32 -0500
Date: Wed, 15 Sep 2021 17:14:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210915221432.GP3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-5-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-5-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 04/35] libmultipath: print: add
	__snprint_config()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:40:49PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> exactly like snprint_config(), but takes a struct strbuf * as argument.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/libmultipath.version |  5 +++++
>  libmultipath/print.c              | 34 +++++++++++++++++++++----------
>  libmultipath/print.h              |  2 ++
>  3 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 2107c51..b2feee2 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -297,3 +297,8 @@ LIBMULTIPATH_9.2.0 {
>  global:
>  	set_wakeup_fn;
>  } LIBMULTIPATH_9.1.0;
> +
> +LIBMULTIPATH_9.3.0 {
> +global:
> +	__snprint_config;
> +} LIBMULTIPATH_9.2.0;
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 2fb9f4e..d2ef010 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -1756,24 +1756,36 @@ static int snprint_blacklist_except(const struct config *conf,
>  	return get_strbuf_len(buff) - initial_len;
>  }
>  
> +int __snprint_config(const struct config *conf, struct strbuf *buff,
> +		     const struct _vector *hwtable, const struct _vector *mpvec)
> +{
> +	int rc;
> +
> +	if ((rc = snprint_defaults(conf, buff)) < 0 ||
> +	    (rc = snprint_blacklist(conf, buff)) < 0 ||
> +	    (rc = snprint_blacklist_except(conf, buff)) < 0 ||
> +	    (rc = snprint_hwtable(conf, buff,
> +				  hwtable ? hwtable : conf->hwtable)) < 0 ||
> +	    (rc = snprint_overrides(conf, buff, conf->overrides)) < 0)
> +		return rc;
> +
> +	if (VECTOR_SIZE(conf->mptable) > 0 ||
> +	    (mpvec != NULL && VECTOR_SIZE(mpvec) > 0))
> +		if ((rc = snprint_mptable(conf, buff, mpvec)) < 0)
> +			return rc;
> +
> +	return 0;
> +}
> +
>  char *snprint_config(const struct config *conf, int *len,
>  		     const struct _vector *hwtable, const struct _vector *mpvec)
>  {
>  	STRBUF_ON_STACK(buff);
>  	char *reply;
> -	int rc;
> +	int rc = __snprint_config(conf, &buff, hwtable, mpvec);
>  
> -	if ((rc = snprint_defaults(conf, &buff)) < 0 ||
> -	    (rc = snprint_blacklist(conf, &buff)) < 0 ||
> -	    (rc = snprint_blacklist_except(conf, &buff)) < 0 ||
> -	    (rc = snprint_hwtable(conf, &buff,
> -				  hwtable ? hwtable : conf->hwtable)) < 0 ||
> -	    (rc = snprint_overrides(conf, &buff, conf->overrides)) < 0)
> +	if (rc < 0)
>  		return NULL;
> -	if (VECTOR_SIZE(conf->mptable) > 0 ||
> -	    (mpvec != NULL && VECTOR_SIZE(mpvec) > 0))
> -		if ((rc = snprint_mptable(conf, &buff, mpvec)) < 0)
> -			return NULL;
>  
>  	if (len)
>  		*len = get_strbuf_len(&buff);
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index c6674a5..b149275 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -54,6 +54,8 @@ int _snprint_multipath_topology (const struct gen_multipath *, struct strbuf *,
>  #define snprint_multipath_topology(buf, mpp, v) \
>  	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, v)
>  int snprint_multipath_topology_json(struct strbuf *, const struct vectors *vecs);
> +int __snprint_config(const struct config *conf, struct strbuf *buff,
> +		     const struct _vector *hwtable, const struct _vector *mpvec);
>  char *snprint_config(const struct config *conf, int *len,
>  		     const struct _vector *hwtable,
>  		     const struct _vector *mpvec);
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

