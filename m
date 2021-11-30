Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED9CC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 01:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638235481;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nbbSne+rLkRZYl51WyN5IyQVWbQglORz953UGIEl3Do=;
	b=hdFSMSjlz/O8Wogo/nnj97UHOaYtA/BdAarkRMcV+CEGfZpJ9qqoR5/V2qU02vqn3yYD1v
	ncWs5xjtPN/7w/kfDWHpJCcJkF1ZCCNuaTCdXsrWRrMoAhy32J3oByGpKQ3KR7qnY1Gaiu
	CdIAptumBAmYmusDvqzi744yjSwAfQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-sbaKXRlXM02Aq5eVzVB4Hg-1; Mon, 29 Nov 2021 20:24:38 -0500
X-MC-Unique: sbaKXRlXM02Aq5eVzVB4Hg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF6041006AA0;
	Tue, 30 Nov 2021 01:24:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2827D5D9C0;
	Tue, 30 Nov 2021 01:24:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 940B81809C89;
	Tue, 30 Nov 2021 01:24:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AU1NaZN026755 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 20:23:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5B65C5C25A; Tue, 30 Nov 2021 01:23:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 532995FC22;
	Tue, 30 Nov 2021 01:23:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AU1NTQJ023970; 
	Mon, 29 Nov 2021 19:23:29 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AU1NSOR023969;
	Mon, 29 Nov 2021 19:23:28 -0600
Date: Mon, 29 Nov 2021 19:23:28 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211130012328.GI19591@octiron.msp.redhat.com>
References: <20211118231338.22358-1-mwilck@suse.com>
	<20211118231338.22358-9-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211118231338.22358-9-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 08/21] libmultipath (coverity): fix tainted
 values in alua_rtpg.c
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

On Fri, Nov 19, 2021 at 12:13:25AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Coverity needs tainted values limited by constant expressions.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/prioritizers/alua_rtpg.c | 13 ++++++------
>  libmultipath/prioritizers/alua_spc3.h | 30 ++++++++++++++++++++++-----
>  2 files changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
> index 420a2e3..3f9c0e7 100644
> --- a/libmultipath/prioritizers/alua_rtpg.c
> +++ b/libmultipath/prioritizers/alua_rtpg.c
> @@ -27,7 +27,6 @@
>  #include "../structs.h"
>  #include "../prio.h"
>  #include "../discovery.h"
> -#include "../unaligned.h"
>  #include "../debug.h"
>  #include "alua_rtpg.h"
>  
> @@ -252,12 +251,12 @@ int
>  get_target_port_group(const struct path * pp, unsigned int timeout)
>  {
>  	unsigned char		*buf;
> -	struct vpd83_data *	vpd83;
> -	struct vpd83_dscr *	dscr;
> +	const struct vpd83_data *	vpd83;
> +	const struct vpd83_dscr *	dscr;
>  	int			rc;
>  	int			buflen, scsi_buflen;
>  
> -	buflen = 4096;
> +	buflen = VPD_BUFLEN;
>  	buf = (unsigned char *)malloc(buflen);
>  	if (!buf) {
>  		PRINT_DEBUG("malloc failed: could not allocate"
> @@ -298,13 +297,13 @@ get_target_port_group(const struct path * pp, unsigned int timeout)
>  	rc = -RTPG_NO_TPG_IDENTIFIER;
>  	FOR_EACH_VPD83_DSCR(vpd83, dscr) {
>  		if (vpd83_dscr_istype(dscr, IDTYPE_TARGET_PORT_GROUP)) {
> -			struct vpd83_tpg_dscr *p;
> +			const struct vpd83_tpg_dscr *p;
>  			if (rc != -RTPG_NO_TPG_IDENTIFIER) {
>  				PRINT_DEBUG("get_target_port_group: more "
>  					    "than one TPG identifier found!");
>  				continue;
>  			}
> -			p  = (struct vpd83_tpg_dscr *)dscr->data;
> +			p  = (const struct vpd83_tpg_dscr *)dscr->data;
>  			rc = get_unaligned_be16(p->tpg);
>  		}
>  	}
> @@ -377,7 +376,7 @@ get_asymmetric_access_state(const struct path *pp, unsigned int tpg,
>  	uint64_t		scsi_buflen;
>  	int fd = pp->fd;
>  
> -	buflen = 4096;
> +	buflen = VPD_BUFLEN;
>  	buf = (unsigned char *)malloc(buflen);
>  	if (!buf) {
>  		PRINT_DEBUG ("malloc failed: could not allocate"
> diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
> index 7ba2cf4..611d67e 100644
> --- a/libmultipath/prioritizers/alua_spc3.h
> +++ b/libmultipath/prioritizers/alua_spc3.h
> @@ -14,6 +14,7 @@
>   */
>  #ifndef __SPC3_H__
>  #define __SPC3_H__
> +#include "../unaligned.h"
>  
>  /*=============================================================================
>   * Definitions to support the standard inquiry command as defined in SPC-3.
> @@ -177,7 +178,7 @@ struct vpd83_dscr {
>  } __attribute__((packed));
>  
>  static inline int
> -vpd83_dscr_istype(struct vpd83_dscr *d, unsigned char type)
> +vpd83_dscr_istype(const struct vpd83_dscr *d, unsigned char type)
>  {
>  	return ((d->b1 & 7) == type);
>  }
> @@ -190,6 +191,26 @@ struct vpd83_data {
>  	struct vpd83_dscr	data[0];
>  } __attribute__((packed));
>  
> +#define VPD_BUFLEN 4096
> +
> +static inline unsigned int vpd83_length(const struct vpd83_data *p)
> +{
> +	uint16_t len = get_unaligned_be16(p->length);
> +
> +	return len <= VPD_BUFLEN ? len : VPD_BUFLEN;

Isn't p->length the length of the page data after the header?  So
you either need to add 4 to len, or use (VPD_BUFLEN - 4)

> +}
> +
> +static inline const struct vpd83_dscr *
> +vpd83_next_dscr(const struct vpd83_dscr *d, const struct vpd83_data *p)
> +{
> +	uint16_t pg_len = vpd83_length(p);
> +	ptrdiff_t offs = ((const char *)d - (const char *)p) + d->length + 4;
> +
> +	offs = offs < 0 ? 0 : offs > pg_len ? pg_len : offs;
> +	return (const struct vpd83_dscr *)((const char *)p + offs);
> +}
> +
> +
>  /*-----------------------------------------------------------------------------
>   * This macro should be used to walk through all identification descriptors
>   * defined in the code page 0x83.
> @@ -200,10 +221,9 @@ struct vpd83_data {
>  #define FOR_EACH_VPD83_DSCR(p, d) \
>  		for( \
>  			d = p->data; \
> -			(((char *) d) - ((char *) p)) < \
> -			get_unaligned_be16(p->length); \
> -			d = (struct vpd83_dscr *) \
> -				((char *) d + d->length + 4) \
> +			(((const char *) d) - ((const char *) p)) \

Unless you are adding 4 in vpd83_length(), shouldn't this be:

			(((const char *) d) - ((const char *) p->data)) \

> +				< (ptrdiff_t)vpd83_length(p);	  \
> +			d = vpd83_next_dscr(d, p) \
>  		)
>  
>  /*=============================================================================
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

