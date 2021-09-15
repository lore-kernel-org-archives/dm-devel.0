Return-Path: <SRS0=IV6L=OF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE200C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 23:53:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7720261101
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 23:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7720261101
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631749997;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TFCogD5zasMFV+yEzaplkC0dBCPxNujclHhctMiSuEM=;
	b=GcDUveF66uFjv0r+qRhQ2+wjgsbFX7oEOjIOqYMGSNyMfvX4/odF5dsDa665ijf1a8KOtO
	4GTsQnDom5pA0rJmBkn3aR3ovzDdawYGp3SwzPF5ysL/oi+JG17ZZLBEaSm5VhVRzclFnZ
	waAI0bjmCN0IEIe4anRbP9hfkzeMTX0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-ICTLr6eDMNWPbF3GR5-7fA-1; Wed, 15 Sep 2021 19:53:16 -0400
X-MC-Unique: ICTLr6eDMNWPbF3GR5-7fA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C63CF1006AA0;
	Wed, 15 Sep 2021 23:53:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 852A85D9D3;
	Wed, 15 Sep 2021 23:53:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB82A4E58E;
	Wed, 15 Sep 2021 23:53:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18FNr8VU014808 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 19:53:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 64BF34180; Wed, 15 Sep 2021 23:53:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40D2160583;
	Wed, 15 Sep 2021 23:53:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18FNr282006671; 
	Wed, 15 Sep 2021 18:53:02 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18FNr1YF006670;
	Wed, 15 Sep 2021 18:53:01 -0500
Date: Wed, 15 Sep 2021 18:53:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210915235301.GV3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-11-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-11-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 10/35] multipathd: add prototype for
	cli_handler functions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:40:55PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Use a typedef instead of spelling out the function type everywhere.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/cli.c |  6 +++---
>  multipathd/cli.h | 10 ++++++----
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index 4d6c37c..5213813 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -65,7 +65,7 @@ out:
>  }
>  
>  int
> -add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *))
> +add_handler (uint64_t fp, cli_handler *fn)
>  {
>  	struct handler * h;
>  
> @@ -100,7 +100,7 @@ find_handler (uint64_t fp)
>  }
>  
>  int
> -set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *))
> +set_handler_callback (uint64_t fp, cli_handler *fn)
>  {
>  	struct handler * h = find_handler(fp);
>  
> @@ -112,7 +112,7 @@ set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *))
>  }
>  
>  int
> -set_unlocked_handler_callback (uint64_t fp,int (*fn)(void *, char **, int *, void *))
> +set_unlocked_handler_callback (uint64_t fp, cli_handler *fn)
>  {
>  	struct handler * h = find_handler(fp);
>  
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index 1e8948a..3dac1b4 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -124,16 +124,18 @@ struct key {
>  	int has_param;
>  };
>  
> +typedef int (cli_handler)(void *keywords, char **reply, int *len, void *data);
> +
>  struct handler {
>  	uint64_t fingerprint;
>  	int locked;
> -	int (*fn)(void *, char **, int *, void *);
> +	cli_handler *fn;
>  };
>  
>  int alloc_handlers (void);
> -int add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *));
> -int set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
> -int set_unlocked_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
> +int add_handler (uint64_t fp, cli_handler *fn);
> +int set_handler_callback (uint64_t fp, cli_handler *fn);
> +int set_unlocked_handler_callback (uint64_t fp, cli_handler *fn);
>  int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
>  int load_keys (void);
>  char * get_keyparam (vector v, uint64_t code);
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

