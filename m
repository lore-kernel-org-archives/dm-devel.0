Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76407C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:47:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1972A60F43
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1972A60F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627573672;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iMIK2CTSSNr5WrttFzJRNJojXS8IovgOmhAfkJlT690=;
	b=E1BlxxNVp+SvoRZilXZU3cTljxfgxkkOEM6mQAiLMCpIXFTOM1LWadL7IDCGTzh4gNAnDh
	KVN+f2tjQkFoUTTCAx/9KsFi74EWxvuu4iMMBfaZZamrDV7pjhuPXKaRoScM80tTbttVC9
	xin7QpHwwuGV9yjFjyzORxjZPNs6U4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-xrS6vd0tNFasrRfFT8H4Nw-1; Thu, 29 Jul 2021 11:47:50 -0400
X-MC-Unique: xrS6vd0tNFasrRfFT8H4Nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A888193F561;
	Thu, 29 Jul 2021 15:47:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AD355D9DD;
	Thu, 29 Jul 2021 15:47:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC0BE4BB7C;
	Thu, 29 Jul 2021 15:47:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TFk9ij007673 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 11:46:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 470A25D6B1; Thu, 29 Jul 2021 15:46:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58FD55D6A1;
	Thu, 29 Jul 2021 15:46:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 16TFk3mB017570; 
	Thu, 29 Jul 2021 10:46:03 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 16TFk3kP017569;
	Thu, 29 Jul 2021 10:46:03 -0500
Date: Thu, 29 Jul 2021 10:46:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210729154602.GQ3087@octiron.msp.redhat.com>
References: <20210715105223.30463-1-mwilck@suse.com>
	<20210715105223.30463-10-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210715105223.30463-10-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 9/9] multipathd: use strbuf in cli.c
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

On Thu, Jul 15, 2021 at 12:52:23PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Here, too, strbuf can be used to simplify code.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/cli.c | 94 ++++++++++++++++++------------------------------
>  1 file changed, 34 insertions(+), 60 deletions(-)
> 
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index bdc9fb1..4d6c37c 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -16,6 +16,7 @@
>  #include "mpath_cmd.h"
>  #include "cli.h"
>  #include "debug.h"
> +#include "strbuf.h"
>  
>  static vector keys;
>  static vector handlers;
> @@ -354,107 +355,80 @@ alloc_handlers (void)
>  }
>  
>  static int
> -genhelp_sprint_aliases (char * reply, int maxlen, vector keys,
> +genhelp_sprint_aliases (struct strbuf *reply, vector keys,
>  			struct key * refkw)
>  {
> -	int i, len = 0;
> +	int i;
>  	struct key * kw;
> +	size_t initial_len = get_strbuf_len(reply);
>  
>  	vector_foreach_slot (keys, kw, i) {
> -		if (kw->code == refkw->code && kw != refkw) {
> -			len += snprintf(reply + len, maxlen - len,
> -					"|%s", kw->str);
> -			if (len >= maxlen)
> -				return len;
> -		}
> +		if (kw->code == refkw->code && kw != refkw &&
> +		    print_strbuf(reply, "|%s", kw->str) < 0)
> +			return -1;
>  	}
>  
> -	return len;
> +	return get_strbuf_len(reply) - initial_len;
>  }
>  
>  static int
> -do_genhelp(char *reply, int maxlen, const char *cmd, int error) {
> -	int len = 0;
> +do_genhelp(struct strbuf *reply, const char *cmd, int error) {
>  	int i, j;
>  	uint64_t fp;
>  	struct handler * h;
>  	struct key * kw;
> +	int rc = 0;
> +	size_t initial_len = get_strbuf_len(reply);
>  
>  	switch(error) {
>  	case ENOMEM:
> -		len += snprintf(reply + len, maxlen - len,
> -				"%s: Not enough memory\n", cmd);
> +		rc = print_strbuf(reply, "%s: Not enough memory\n", cmd);
>  		break;
>  	case EAGAIN:
> -		len += snprintf(reply + len, maxlen - len,
> -				"%s: not found\n", cmd);
> +		rc = print_strbuf(reply, "%s: not found\n", cmd);
>  		break;
>  	case EINVAL:
> -		len += snprintf(reply + len, maxlen - len,
> -				"%s: Missing argument\n", cmd);
> +		rc = print_strbuf(reply, "%s: Missing argument\n", cmd);
>  		break;
>  	}
> -	if (len >= maxlen)
> -		goto out;
> -	len += snprintf(reply + len, maxlen - len, VERSION_STRING);
> -	if (len >= maxlen)
> -		goto out;
> -	len += snprintf(reply + len, maxlen - len, "CLI commands reference:\n");
> -	if (len >= maxlen)
> -		goto out;
> +	if (rc < 0)
> +		return -1;
> +
> +	if (print_strbuf(reply, VERSION_STRING) < 0 ||
> +	    append_strbuf_str(reply, "CLI commands reference:\n") < 0)
> +		return -1;
>  
>  	vector_foreach_slot (handlers, h, i) {
>  		fp = h->fingerprint;
>  		vector_foreach_slot (keys, kw, j) {
>  			if ((kw->code & fp)) {
>  				fp -= kw->code;
> -				len += snprintf(reply + len , maxlen - len,
> -						" %s", kw->str);
> -				if (len >= maxlen)
> -					goto out;
> -				len += genhelp_sprint_aliases(reply + len,
> -							      maxlen - len,
> -							      keys, kw);
> -				if (len >= maxlen)
> -					goto out;
> +				if (print_strbuf(reply, " %s", kw->str) < 0 ||
> +				    genhelp_sprint_aliases(reply, keys, kw) < 0)
> +					return -1;
>  
>  				if (kw->has_param) {
> -					len += snprintf(reply + len,
> -							maxlen - len,
> -							" $%s", kw->str);
> -					if (len >= maxlen)
> -						goto out;
> +					if (print_strbuf(reply, " $%s",
> +							 kw->str) < 0)
> +						return -1;
>  				}
>  			}
>  		}
> -		len += snprintf(reply + len, maxlen - len, "\n");
> -		if (len >= maxlen)
> -			goto out;
> +		if (append_strbuf_str(reply, "\n") < 0)
> +			return -1;
>  	}
> -out:
> -	return len;
> +	return get_strbuf_len(reply) - initial_len;
>  }
>  
>  
>  static char *
>  genhelp_handler (const char *cmd, int error)
>  {
> -	char * reply;
> -	char * p = NULL;
> -	int maxlen = INITIAL_REPLY_LEN;
> -	int again = 1;
> -
> -	reply = MALLOC(maxlen);
> -
> -	while (again) {
> -		if (!reply)
> -			return NULL;
> -		p = reply;
> -		p += do_genhelp(reply, maxlen, cmd, error);
> -		again = ((p - reply) >= maxlen);
> -		REALLOC_REPLY(reply, again, maxlen);
> -	}
> -	return reply;
> +	STRBUF_ON_STACK(reply);
> +
> +	if (do_genhelp(&reply, cmd, error) == -1)
> +		condlog(0, "genhelp_handler: out of memory");
> +	return steal_strbuf_str(&reply);
>  }
>  
>  int
> -- 
> 2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

