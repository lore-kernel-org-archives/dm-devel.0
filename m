Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85862C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 00:02:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2549261164
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 00:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2549261164
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631750569;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E5zZoaP2dyQCRABykxXHT8HxfN3iASfAhw59zsYzMpI=;
	b=PKPz7U/x4gP8yHpc9RagMnBCzZ6Iq4bGXb68E7JjvHHRmG/I0+BzTpKvb6sPBnelYXOlLD
	y2fqOASDxvcc348zkBlhU8aYp5Yhl+0AiwLrnP/ljzrjlrqM3nVwA/ESt6IHRSnhQZS2rv
	7CiVtLaJIJ9jxWfoVq7vNr+aDluo3oA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-ElF8JQ4kMV-bY_gJ06iFAg-1; Wed, 15 Sep 2021 20:02:47 -0400
X-MC-Unique: ElF8JQ4kMV-bY_gJ06iFAg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B9761808308;
	Thu, 16 Sep 2021 00:02:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 106E65C232;
	Thu, 16 Sep 2021 00:02:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE1F5180142F;
	Thu, 16 Sep 2021 00:02:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G02eWd015652 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 20:02:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D8BDF60CA0; Thu, 16 Sep 2021 00:02:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F3E060C82;
	Thu, 16 Sep 2021 00:02:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G02YFg006885; 
	Wed, 15 Sep 2021 19:02:34 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G02XYU006884;
	Wed, 15 Sep 2021 19:02:33 -0500
Date: Wed, 15 Sep 2021 19:02:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916000233.GY3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-14-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-14-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 13/35] multipathd: cli.c: use ESRCH for
 "command not found"
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:40:58PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> EAGAIN is too generic, and doesn't fit semantically either.
> ESRCH in't used anywhere else in our code.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/cli.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index 7020d2b..f8c1dbd 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -253,7 +253,7 @@ find_key (const char * str)
>   *
>   * returns:
>   * ENOMEM: not enough memory to allocate command
> - * EAGAIN: command not found
> + * ESRCH: command not found
>   * EINVAL: argument missing for command
>   */
>  static int
> @@ -288,7 +288,7 @@ get_cmdvec (char * cmd, vector *v)
>  		}
>  		kw = find_key(buff);
>  		if (!kw) {
> -			r = EAGAIN;
> +			r = ESRCH;
>  			goto out;
>  		}
>  		cmdkw = alloc_key();
> @@ -378,7 +378,7 @@ do_genhelp(struct strbuf *reply, const char *cmd, int error) {
>  	case ENOMEM:
>  		rc = print_strbuf(reply, "%s: Not enough memory\n", cmd);
>  		break;
> -	case EAGAIN:
> +	case ESRCH:
>  		rc = print_strbuf(reply, "%s: not found\n", cmd);
>  		break;
>  	case EINVAL:
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

