Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B258C001DF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Aug 2023 20:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691095287;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wKMpnR3Sb9Va5Y/P8/by4nkKMQ4Jt0QHRC40Pru3zsA=;
	b=Z/SnILpM0ZkBIsMGgoBpr7qT7aUKxNt19RBxfJtsB0cFa+LIbqXBeZxyQ5dczqBSkxY6TB
	4MDsTYKY5KxeMVFPToHoL0i9dIG91ta1oL+fctH3AkxMnzrEOJYCPBaAy2690BNdIDsEE8
	ZxKgDFzZ5T+xSD0dFPPQH0OvlGlvAKE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-YM1cJ662M6Sdzhp-cq5GNA-1; Thu, 03 Aug 2023 16:41:25 -0400
X-MC-Unique: YM1cJ662M6Sdzhp-cq5GNA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 563A210504AB;
	Thu,  3 Aug 2023 20:41:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F20F5492B03;
	Thu,  3 Aug 2023 20:41:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D5051946A78;
	Thu,  3 Aug 2023 20:41:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C88541946A45
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Aug 2023 20:41:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 471EA4021CE; Thu,  3 Aug 2023 20:41:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CD43477F63;
 Thu,  3 Aug 2023 20:41:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 373Kf9kF006281;
 Thu, 3 Aug 2023 15:41:10 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 373Kf91m006280;
 Thu, 3 Aug 2023 15:41:09 -0500
Date: Thu, 3 Aug 2023 15:41:09 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <20230803204109.GW7412@octiron.msp.redhat.com>
References: <20230707121952.9603-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230707121952.9603-1-xose.vazquez@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH RFC] multipath-tools: treat
 disable_changed_wwids like other deprecated keywords
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 07, 2023 at 02:19:51PM +0200, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/dict.c | 27 ++++++---------------------
>  1 file changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 6b3e04a3..f81c84aa 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -278,11 +278,6 @@ static int print_str(struct strbuf *buff, const char *ptr)
>  	return ret == -EINVAL ? 0 : ret;
>  }
>  
> -static int print_ignored(struct strbuf *buff)
> -{
> -	return append_strbuf_quoted(buff, "ignored");
> -}
> -
>  static int print_yes_no(struct strbuf *buff, long v)
>  {
>  	return append_strbuf_quoted(buff, v == YN_NO ? "no" : "yes");
> @@ -548,7 +543,6 @@ declare_def_snprint(verbosity, print_int)
>  declare_def_handler(reassign_maps, set_yes_no)
>  declare_def_snprint(reassign_maps, print_yes_no)
>  
> -declare_deprecated_handler(multipath_dir)
>  
>  static int def_partition_delim_handler(struct config *conf, vector strvec,
>  				       const char *file, int line_nr)
> @@ -918,17 +912,6 @@ declare_hw_handler(skip_kpartx, set_yes_no_undef)
>  declare_hw_snprint(skip_kpartx, print_yes_no_undef)
>  declare_mp_handler(skip_kpartx, set_yes_no_undef)
>  declare_mp_snprint(skip_kpartx, print_yes_no_undef)
> -static int def_disable_changed_wwids_handler(struct config *conf, vector strvec,
> -					     const char *file, int line_nr)
> -{
> -	return 0;
> -}
> -static int snprint_def_disable_changed_wwids(struct config *conf,
> -					     struct strbuf *buff,
> -					     const void *data)
> -{
> -	return print_ignored(buff);
> -}
>  
>  declare_def_range_handler(remove_retries, 0, INT_MAX)
>  declare_def_snprint(remove_retries, print_int)
> @@ -950,9 +933,6 @@ declare_def_handler(enable_foreign, set_str)
>  declare_def_snprint_defstr(enable_foreign, print_str,
>  			   DEFAULT_ENABLE_FOREIGN)
>  
> -declare_deprecated_handler(config_dir)
> -declare_deprecated_handler(pg_timeout)
> -
>  #define declare_def_attr_handler(option, function)			\
>  static int								\
>  def_ ## option ## _handler (struct config *conf, vector strvec,		\
> @@ -2076,7 +2056,12 @@ snprint_deprecated (struct config *conf, struct strbuf *buff, const void * data)
>  	return 0;
>  }
>  
> +// Deprecated keywords
> +declare_deprecated_handler(config_dir)
> +declare_deprecated_handler(disable_changed_wwids)
>  declare_deprecated_handler(getuid_callout)
> +declare_deprecated_handler(multipath_dir)
> +declare_deprecated_handler(pg_timeout)
>  
>  /*
>   * If you add or remove a keyword also update multipath/multipath.conf.5
> @@ -2151,7 +2136,7 @@ init_keywords(vector keywords)
>  	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
>  	install_keyword("missing_uev_wait_timeout", &def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
>  	install_keyword("skip_kpartx", &def_skip_kpartx_handler, &snprint_def_skip_kpartx);
> -	install_keyword("disable_changed_wwids", &def_disable_changed_wwids_handler, &snprint_def_disable_changed_wwids);
> +	install_keyword("disable_changed_wwids", &deprecated_disable_changed_wwids_handler, &snprint_deprecated);
>  	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
>  	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
>  	install_keyword("ghost_delay", &def_ghost_delay_handler, &snprint_def_ghost_delay);
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

