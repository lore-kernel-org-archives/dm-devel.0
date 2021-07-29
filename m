Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F31CC4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 02:36:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B8C760F46
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 02:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B8C760F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627526180;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ELOAEPOuU96pR6+AgUBcrkm624qdL6DYiO9ZVMDEQEY=;
	b=RCiUels61bOsDpzHcqhcjauRV2RAClnZCJPzsGceaG6wddMf6Tgidmg1MQ4a9B8L7BPFZT
	dEegOJH/Eek8KEbcY2If5hPrh2cQHaGkk9d2/XD8M7FZyfJZaTora2K6ob8sv/6Vv8VUyk
	ze0XfxFGuDsf7I0aUHdEGhlvxqDc6KY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-M_nd7FaxOMSYRRCnSeFZ0w-1; Wed, 28 Jul 2021 22:36:16 -0400
X-MC-Unique: M_nd7FaxOMSYRRCnSeFZ0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75427107465F;
	Thu, 29 Jul 2021 02:36:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ADD560BF1;
	Thu, 29 Jul 2021 02:36:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 734D3180BAB1;
	Thu, 29 Jul 2021 02:36:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16T2a7A2014045 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Jul 2021 22:36:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 78F5B369A; Thu, 29 Jul 2021 02:36:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C977719630;
	Thu, 29 Jul 2021 02:36:03 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 16T2a2gH013255; 
	Wed, 28 Jul 2021 21:36:02 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 16T2a157013253;
	Wed, 28 Jul 2021 21:36:01 -0500
Date: Wed, 28 Jul 2021 21:36:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210729023601.GN3087@octiron.msp.redhat.com>
References: <20210715105223.30463-1-mwilck@suse.com>
	<20210715105223.30463-7-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210715105223.30463-7-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 6/9] libmultipath: print.c: fail hard if
 keywords are not found
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 15, 2021 at 12:52:20PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> A failure in find_keyword() means an internal error. Fail hard rather
> than returning an empty string.
>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/print.c | 101 +++++++++++++++----------------------------
>  1 file changed, 35 insertions(+), 66 deletions(-)
> 
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 4bf2f7c..5b86483 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -10,6 +10,7 @@
>  #include <unistd.h>
>  #include <string.h>
>  #include <errno.h>
> +#include <assert.h>
>  #include <libudev.h>
>  
>  #include "checkers.h"
> @@ -1294,14 +1295,9 @@ snprint_hwentry (const struct config *conf,
>  	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "devices");
> -
> -	if (!rootkw || !rootkw->sub)
> -		return 0;
> -
> +	assert(rootkw && rootkw->sub);
>  	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
> -
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
>  
>  	if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
>  		return rc;
> @@ -1324,8 +1320,7 @@ static int snprint_hwtable(const struct config *conf, struct strbuf *buff,
>  	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "devices");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
>  
>  	if ((rc = append_strbuf_str(buff, "devices {\n")) < 0)
>  		return rc;
> @@ -1355,8 +1350,7 @@ snprint_mpentry (const struct config *conf, struct strbuf *buff,
>  		return 0;
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "multipath");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
>  
>  	if ((rc = append_strbuf_str(buff, "\tmultipath {\n")) < 0)
>  		return rc;
> @@ -1387,8 +1381,7 @@ static int snprint_mptable(const struct config *conf, struct strbuf *buff,
>  	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "multipaths");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
>  
>  	if ((rc = append_strbuf_str(buff, "multipaths {\n")) < 0)
>  		return rc;
> @@ -1435,8 +1428,7 @@ static int snprint_overrides(const struct config *conf, struct strbuf *buff,
>  	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "overrides");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
>  
>  	if ((rc = append_strbuf_str(buff, "overrides {\n")) < 0)
>  		return rc;
> @@ -1461,8 +1453,7 @@ static int snprint_defaults(const struct config *conf, struct strbuf *buff)
>  	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "defaults");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
>  
>  	if ((rc = append_strbuf_str(buff, "defaults {\n")) < 0)
>  		return rc;
> @@ -1584,63 +1575,52 @@ static int snprint_blacklist(const struct config *conf, struct strbuf *buff)
>  	struct blentry * ble;
>  	struct blentry_device * bled;
>  	struct keyword *rootkw;
> -	struct keyword *kw;
> +	struct keyword *kw, *pkw;
>  	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "blacklist");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
>  
>  	if ((rc = append_strbuf_str(buff, "blacklist {\n")) < 0)
>  		return rc;
>  
>  	vector_foreach_slot (conf->blist_devnode, ble, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "devnode");
> -		if (!kw)
> -			return 0;
> +		assert(kw);
>  		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
>  			return rc;
>  	}
>  	vector_foreach_slot (conf->blist_wwid, ble, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "wwid");
> -		if (!kw)
> -			return 0;
> +		assert(kw);
>  		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
>  			return rc;
>  	}
>  	vector_foreach_slot (conf->blist_property, ble, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "property");
> -		if (!kw)
> -			return 0;
> +		assert(kw);
>  		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
>  			return rc;
>  	}
>  	vector_foreach_slot (conf->blist_protocol, ble, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "protocol");
> -		if (!kw)
> -			return 0;
> +		assert(kw);
>  		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
>  			return rc;
>  	}
>  
>  	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
> +	kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
> +	pkw = find_keyword(conf->keywords, rootkw->sub, "product");
> +	assert(kw && pkw);
>  
>  	vector_foreach_slot (conf->blist_device, bled, i) {
> -		if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
> -			return rc;
> -
> -		kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
> -		if (!kw)
> -			return 0;
> -		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, bled)) < 0)
> +		if ((rc = snprint_keyword(buff, "\tdevice {\n\t\t%k %v\n",
> +					  kw, bled)) < 0)
>  			return rc;
> -		kw = find_keyword(conf->keywords, rootkw->sub, "product");
> -		if (!kw)
> -			return 0;
> -		if ((rc = snprint_keyword(buff,
> -					  "\t\t%k %v\n\t}\n", kw, bled)) < 0)
> +		if ((rc = snprint_keyword(buff, "\t\t%k %v\n\t}\n",
> +					  pkw, bled)) < 0)
>  			return rc;
>  	}
>  
> @@ -1656,63 +1636,52 @@ static int snprint_blacklist_except(const struct config *conf,
>  	struct blentry * ele;
>  	struct blentry_device * eled;
>  	struct keyword *rootkw;
> -	struct keyword *kw;
> +	struct keyword *kw, *pkw;
>  	size_t initial_len = get_strbuf_len(buff);
>  
>  	rootkw = find_keyword(conf->keywords, NULL, "blacklist_exceptions");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
>  
>  	if ((rc = append_strbuf_str(buff, "blacklist_exceptions {\n")) < 0)
>  		return rc;
>  
>  	vector_foreach_slot (conf->elist_devnode, ele, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "devnode");
> -		if (!kw)
> -			return 0;
> +		assert(kw);
>  		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
>  			return rc;
>  	}
>  	vector_foreach_slot (conf->elist_wwid, ele, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "wwid");
> -		if (!kw)
> -			return 0;
> +		assert(kw);
>  		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
>  			return rc;
>  	}
>  	vector_foreach_slot (conf->elist_property, ele, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "property");
> -		if (!kw)
> -			return 0;
> +		assert(kw);
>  		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
>  			return rc;
>  	}
>  	vector_foreach_slot (conf->elist_protocol, ele, i) {
>  		kw = find_keyword(conf->keywords, rootkw->sub, "protocol");
> -		if (!kw)
> -			return 0;
> +		assert(kw);
>  		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
>  			return rc;
>  	}
>  
>  	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
> -	if (!rootkw)
> -		return 0;
> +	assert(rootkw);
> +	kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
> +	pkw = find_keyword(conf->keywords, rootkw->sub, "product");
> +	assert(kw && pkw);
>  
>  	vector_foreach_slot (conf->elist_device, eled, i) {
> -		if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
> -			return rc;
> -
> -		kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
> -		if (!kw)
> -			return 0;
> -		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, eled)) < 0)
> +		if ((rc = snprint_keyword(buff, "\tdevice {\n\t\t%k %v\n",
> +					  kw, eled)) < 0)
>  			return rc;
> -		kw = find_keyword(conf->keywords, rootkw->sub, "product");
> -		if (!kw)
> -			return 0;
>  		if ((rc = snprint_keyword(buff, "\t\t%k %v\n\t}\n",
> -					  kw, eled)) < 0)
> +					  pkw, eled)) < 0)
>  			return rc;
>  	}
>  
> -- 
> 2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

