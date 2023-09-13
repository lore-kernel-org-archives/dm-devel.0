Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928AEEE0211
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 23:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694646341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TvUj4b1CbHUq37nGfeyNHlyWy8VenJyL3gjZcurolgU=;
	b=XVlb/78gKUl0UlmBHDkH4X55lE/eZUE96vR3iLG524rHqE7xYbuOaXm1jGeBh5FUmQJ2+P
	y0zoTGuSIHb7d1O4VZoS2vajTIICo/ghSM0QD+YEcLEXW9OLitQ7T19ib492Tdg/Miv/WF
	4B1Md8Ggy1ujZ1fp51uKpwC34LHKSUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-XRa54FPPOxy-2pYi-g_cbA-1; Wed, 13 Sep 2023 19:05:38 -0400
X-MC-Unique: XRa54FPPOxy-2pYi-g_cbA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9E51101A529;
	Wed, 13 Sep 2023 23:05:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49E61403CFA4;
	Wed, 13 Sep 2023 23:05:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 06DA119465B9;
	Wed, 13 Sep 2023 23:05:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE57519465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 23:05:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9DB841008807; Wed, 13 Sep 2023 23:05:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 856B61006E0B;
 Wed, 13 Sep 2023 23:05:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DN5Qkj004675;
 Wed, 13 Sep 2023 18:05:26 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DN5P2L004674;
 Wed, 13 Sep 2023 18:05:25 -0500
Date: Wed, 13 Sep 2023 18:05:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230913230525.GE7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-35-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-35-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 34/37] libmultipath: print built-in values
 for deprecated options
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:43PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> In the error messages we print when a deprecated option is encountered,
> print the compile-time value of the option.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/dict.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index f81c84a..dace343 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -314,14 +314,16 @@ def_ ## option ## _handler (struct config *conf, vector strvec,		\
>  static int deprecated_handler(struct config *conf, vector strvec, const char *file,
>  			      int line_nr);
>  
> -#define declare_deprecated_handler(option)				\
> +#define declare_deprecated_handler(option, default)				\
>  static int								\
>  deprecated_ ## option ## _handler (struct config *conf, vector strvec,	\
>  				   const char *file, int line_nr)	\
>  {									\
>  	static bool warned;						\
>  	if (!warned) {							\
> -		condlog(1, "%s line %d: ignoring deprecated option \"" #option "\"", file, line_nr); \
> +		condlog(1, "%s line %d: ignoring deprecated option \""	\
> +			#option "\", using built-in value: \"%s\"",	\
> +			file, line_nr, default);			\
>  		warned = true;						\
>  	}								\
>  	return deprecated_handler(conf, strvec, file, line_nr);		\
> @@ -2057,11 +2059,11 @@ snprint_deprecated (struct config *conf, struct strbuf *buff, const void * data)
>  }
>  
>  // Deprecated keywords
> -declare_deprecated_handler(config_dir)
> -declare_deprecated_handler(disable_changed_wwids)
> -declare_deprecated_handler(getuid_callout)
> -declare_deprecated_handler(multipath_dir)
> -declare_deprecated_handler(pg_timeout)
> +declare_deprecated_handler(config_dir, CONFIG_DIR)
> +declare_deprecated_handler(disable_changed_wwids, "yes")
> +declare_deprecated_handler(getuid_callout, "(not set)")
> +declare_deprecated_handler(multipath_dir, MULTIPATH_DIR)
> +declare_deprecated_handler(pg_timeout, "(not set)")
>  
>  /*
>   * If you add or remove a keyword also update multipath/multipath.conf.5
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

