Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59794C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638383828;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gF4m5YqNBESsLcazIpHMx+QKMhau6DDcLcDR+LyvQIc=;
	b=QkV1EM0HA6YSTqJClQbn1THYCDzpYMWZEe85vLvEwziQPRPf3nstmYCI3Se0a3uKFPdTcO
	jgHIblJHZXHATvgd8H3L4OaDJ7CkDQ3tTFncpsVJpK6ImzzrMPN7spJc6/pGE/0Ei0aE4/
	zSkE86evO0VJLpWkQ5hCIHFU3TfGjhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-514-xTSVeme6OBmkj8gH36MZeg-1; Wed, 01 Dec 2021 13:37:06 -0500
X-MC-Unique: xTSVeme6OBmkj8gH36MZeg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 910D364083;
	Wed,  1 Dec 2021 18:37:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3ED905F4E1;
	Wed,  1 Dec 2021 18:37:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 986C34BB7C;
	Wed,  1 Dec 2021 18:37:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1Ib0H2026612 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 13:37:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8B9EE6060F; Wed,  1 Dec 2021 18:37:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B6B860843;
	Wed,  1 Dec 2021 18:36:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1B1IasF0006127; 
	Wed, 1 Dec 2021 12:36:54 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1B1IasAD006126;
	Wed, 1 Dec 2021 12:36:54 -0600
Date: Wed, 1 Dec 2021 12:36:53 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211201183653.GQ19591@octiron.msp.redhat.com>
References: <20211201123650.16240-1-mwilck@suse.com>
	<20211201123650.16240-8-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211201123650.16240-8-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 07/21] libmultipath: use strbuf in
	parse_vpd_pg83()
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

On Wed, Dec 01, 2021 at 01:36:36PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> By using the strbuf API, the code gets more readable, as we need
> less output size checks.
> 
> While at it, avoid a possible crash by passing a NULL pointer
> to memchr().
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 111 +++++++++++++++++----------------------
>  1 file changed, 48 insertions(+), 63 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 977aed9..7d939ae 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1121,6 +1121,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
>  	size_t len, vpd_len, i;
>  	int vpd_type, prio = -1;
>  	int err = -ENODATA;
> +	STRBUF_ON_STACK(buf);
>  
>  	/* Need space at least for one digit */
>  	if (out_len <= 1)
> @@ -1239,92 +1240,76 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
>  	if (vpd_type == 0x2 || vpd_type == 0x3) {
>  		size_t i;
>  
> -		len = sprintf(out, "%d", vpd_type);
> -		if (2 * vpd_len >= out_len - len) {
> -			condlog(1, "%s: WWID overflow, type %d, %zu/%zu bytes required",
> -				__func__, vpd_type,
> -				2 * vpd_len + len + 1, out_len);
> -			vpd_len = (out_len - len - 1) / 2;
> -		}
> +		if ((err = print_strbuf(&buf, "%d", vpd_type)) < 0)
> +			return err;
>  		for (i = 0; i < vpd_len; i++)
> -			len += sprintf(out + len,
> -				       "%02x", vpd[i]);
> +			if ((err = print_strbuf(&buf, "%02x", vpd[i])) < 0)
> +				return err;
>  	} else if (vpd_type == 0x8) {
> +		char type;
> +
>  		if (!memcmp("eui.", vpd, 4))
> -			out[0] =  '2';
> +			type =  '2';
>  		else if (!memcmp("naa.", vpd, 4))
> -			out[0] = '3';
> +			type = '3';
>  		else
> -			out[0] = '8';
> +			type = '8';
> +		if ((err = fill_strbuf(&buf, type, 1)) < 0)
> +			return err;
>  
>  		vpd += 4;
>  		len = vpd_len - 4;
> -		while (len > 2 && vpd[len - 2] == '\0')
> -			--len;
> -		if (len > out_len - 1) {
> -			condlog(1, "%s: WWID overflow, type 8/%c, %zu/%zu bytes required",
> -				__func__, out[0], len + 1, out_len);
> -			len = out_len - 1;
> +		if ((err = __append_strbuf_str(&buf, (const char *)vpd, len)) < 0)
> +			return err;
> +
> +		/* The input is 0-padded, make sure the length is correct */
> +		truncate_strbuf(&buf, strlen(get_strbuf_str(&buf)));
> +		len = get_strbuf_len(&buf);
> +		if (type != '8') {
> +			char *buffer = __get_strbuf_buf(&buf);
> +
> +			for (i = 0; i < len; ++i)
> +				buffer[i] = tolower(buffer[i]);
>  		}
>  
> -		if (out[0] == '8')
> -			for (i = 0; i < len; ++i)
> -				out[1 + i] = vpd[i];
> -		else
> -			for (i = 0; i < len; ++i)
> -				out[1 + i] = tolower(vpd[i]);
> -
> -		/* designator should be 0-terminated, but let's make sure */
> -		out[len] = '\0';
> -
>  	} else if (vpd_type == 0x1) {
>  		const unsigned char *p;
>  		size_t p_len;
>  
> -		out[0] = '1';
> -		len = 1;
> -		while ((p = memchr(vpd, ' ', vpd_len))) {
> +		if ((err = fill_strbuf(&buf, '1', 1)) < 0)
> +			return err;
> +		while (vpd && (p = memchr(vpd, ' ', vpd_len))) {
>  			p_len = p - vpd;
> -			if (len + p_len > out_len - 1) {
> -				condlog(1, "%s: WWID overflow, type 1, %zu/%zu bytes required",
> -					__func__, len + p_len, out_len);
> -				p_len = out_len - len - 1;
> -			}
> -			memcpy(out + len, vpd, p_len);
> -			len += p_len;
> -			if (len >= out_len - 1) {
> -				out[len] = '\0';
> -				break;
> -			}
> -			out[len] = '_';
> -			len ++;
> -			if (len >= out_len - 1) {
> -				out[len] = '\0';
> -				break;
> -			}
> +			if ((err = __append_strbuf_str(&buf, (const char *)vpd,
> +						       p_len)) < 0)
> +				return err;
>  			vpd = p;
>  			vpd_len -= p_len;
> -			while (vpd && *vpd == ' ') {
> +			while (vpd && vpd_len > 0 && *vpd == ' ') {
>  				vpd++;
>  				vpd_len --;
>  			}
> +			if (vpd_len > 0 && (err = fill_strbuf(&buf, '_', 1)) < 0)
> +				return err;
>  		}
> -		p_len = vpd_len;
> -		if (p_len > 0 && len < out_len - 1) {
> -			if (len + p_len > out_len - 1) {
> -				condlog(1, "%s: WWID overflow, type 1, %zu/%zu bytes required",
> -					__func__, len + p_len + 1, out_len);
> -				p_len = out_len - len - 1;
> -			}
> -			memcpy(out + len, vpd, p_len);
> -			len += p_len;
> -			out[len] = '\0';
> -		}
> -		if (len > 1 && out[len - 1] == '_') {
> -			out[len - 1] = '\0';
> -			len--;
> +		if (vpd_len > 0) {
> +			if ((err = __append_strbuf_str(&buf, (const char *)vpd,
> +						       vpd_len)) < 0)
> +				return err;
>  		}
>  	}
> +
> +	len = get_strbuf_len(&buf);
> +	if (len >= out_len) {
> +		condlog(1, "%s: WWID overflow, type %d, %zu/%zu bytes required",
> +			__func__, vpd_type, len, out_len);
> +		if (vpd_type == 2 || vpd_type == 3)
> +			/* designator must have an even number of characters */
> +			len = 2 * (out_len / 2) - 1;
> +		else
> +			len = out_len - 1;
> +	}
> +	strlcpy(out, get_strbuf_str(&buf), len + 1);
>  	return len;
>  }
>  
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

