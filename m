Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174C0C4332F
	for <dm-devel@archiver.kernel.org>; Wed,  9 Nov 2022 00:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667954948;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QTOWZgcSFAWFPj3fboisKJsCvtxmI7VWOW6V6yDW++A=;
	b=D/jQxqxWF4eBaCK8mzUwD7DuyNREPcqyaZQzpGmswrS7k1dP9AjgSwqM8d1xG5LOJDcnCD
	/nuq0vxDvd6N9wIjiE90E2V+JBsJWHgBQCjlIG2UZKdy+O25I7jXG/Xy59qVT8pwhexPNX
	aqLlhC2Iu2Z+qQHbWb+p66D995/oMYo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-FqojmR2INcytvfl9gExozQ-1; Tue, 08 Nov 2022 19:49:05 -0500
X-MC-Unique: FqojmR2INcytvfl9gExozQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DACF299E75E;
	Wed,  9 Nov 2022 00:49:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 272661415117;
	Wed,  9 Nov 2022 00:49:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9D067194658F;
	Wed,  9 Nov 2022 00:48:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 588981946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Nov 2022 00:48:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38125111F3C7; Wed,  9 Nov 2022 00:48:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B434112132E;
 Wed,  9 Nov 2022 00:48:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2A90mp9I002846;
 Tue, 8 Nov 2022 18:48:51 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2A90mpTt002845;
 Tue, 8 Nov 2022 18:48:51 -0600
Date: Tue, 8 Nov 2022 18:48:50 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <20221109004850.GM19568@octiron.msp.redhat.com>
References: <20221104231234.111216-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20221104231234.111216-1-xose.vazquez@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] multipath-tools: fix c&p error in
 install_keyword for deprecated pg_timeout
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Nov 05, 2022 at 12:12:34AM +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/dict.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 6fc77315..97f43387 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -2103,7 +2103,7 @@ init_keywords(vector keywords)
>  	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
>  	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_minio);
>  	install_keyword("rr_min_io_rq", &hw_minio_rq_handler, &snprint_hw_minio_rq);
> -	install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated);
> +	install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_deprecated);
>  	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
>  	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
>  	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
> @@ -2192,7 +2192,7 @@ init_keywords(vector keywords)
>  	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
>  	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_minio);
>  	install_keyword("rr_min_io_rq", &mp_minio_rq_handler, &snprint_mp_minio_rq);
> -	install_keyword("pg_timeout", &deprecated_handler, &snprint_deprecated);
> +	install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_deprecated);
>  	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler, &snprint_mp_flush_on_last_del);
>  	install_keyword("features", &mp_features_handler, &snprint_mp_features);
>  	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
> -- 
> 2.38.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

