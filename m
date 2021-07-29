Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27662C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 02:37:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 94C0C61019
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 02:37:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 94C0C61019
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627526230;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UCyYmPUiEuAdBF+st3er67giDDdYMMCoOtNpL9k9eys=;
	b=J35lvPvOPqxqkoT+IgZKPBeSx8D9w7DwKhZULttqVCOEd2w/LgyiRZF9VE8PgDHwRDUH0v
	n27g+cb0VBJVKkI/o9lAs4YYdF/G86MAfwcgW+YHUVrSG+qlHi6lq96GkXGNJw2b8WGyDx
	6kJEkJFQVhXaPV46Ed0NiicNWqYzdl8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-IIcoAZgaOwWsTLDmJyRDfw-1; Wed, 28 Jul 2021 22:37:09 -0400
X-MC-Unique: IIcoAZgaOwWsTLDmJyRDfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDCD1107ACF5;
	Thu, 29 Jul 2021 02:37:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E6055C1CF;
	Thu, 29 Jul 2021 02:37:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6084F4BB7C;
	Thu, 29 Jul 2021 02:37:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16T2b10D014149 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Jul 2021 22:37:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ACFCF1017CE5; Thu, 29 Jul 2021 02:37:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF65D10016FD;
	Thu, 29 Jul 2021 02:36:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 16T2auHZ013282; 
	Wed, 28 Jul 2021 21:36:56 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 16T2atMV013281;
	Wed, 28 Jul 2021 21:36:55 -0500
Date: Wed, 28 Jul 2021 21:36:55 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210729023655.GO3087@octiron.msp.redhat.com>
References: <20210715105223.30463-1-mwilck@suse.com>
	<20210715105223.30463-8-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210715105223.30463-8-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 7/9] libmultipath: print.h: move macros to
	print.c
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

On Thu, Jul 15, 2021 at 12:52:21PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Move all macros to print.c that aren't used in other source files.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/print.c | 66 +++++++++++++++++++++++++++++++++++++++++
>  libmultipath/print.h | 70 +-------------------------------------------
>  2 files changed, 67 insertions(+), 69 deletions(-)
> 
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 5b86483..6a5c465 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -34,6 +34,72 @@
>  #include "foreign.h"
>  #include "strbuf.h"
>  
> +#define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
> +#define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
> +#define PRINT_MAP_PROPS      "size=%S features='%f' hwhandler='%h' wp=%r"
> +#define PRINT_PG_INDENT      "policy='%s' prio=%p status=%t"
> +
> +#define PRINT_JSON_MULTIPLIER     5
> +#define PRINT_JSON_MAJOR_VERSION  0
> +#define PRINT_JSON_MINOR_VERSION  1
> +#define PRINT_JSON_START_VERSION  "   \"major_version\": %d,\n" \
> +				  "   \"minor_version\": %d,\n"
> +#define PRINT_JSON_START_ELEM     "{\n"
> +#define PRINT_JSON_START_MAP      "   \"map\":"
> +#define PRINT_JSON_START_MAPS     "\"maps\": ["
> +#define PRINT_JSON_START_PATHS    "\"paths\": ["
> +#define PRINT_JSON_START_GROUPS   "\"path_groups\": ["
> +#define PRINT_JSON_END_ELEM       "},"
> +#define PRINT_JSON_END_LAST_ELEM  "}"
> +#define PRINT_JSON_END_LAST       "}\n"
> +#define PRINT_JSON_END_ARRAY      "]\n"
> +#define PRINT_JSON_INDENT_N    3
> +#define PRINT_JSON_MAP       "{\n" \
> +			     "      \"name\" : \"%n\",\n" \
> +			     "      \"uuid\" : \"%w\",\n" \
> +			     "      \"sysfs\" : \"%d\",\n" \
> +			     "      \"failback\" : \"%F\",\n" \
> +			     "      \"queueing\" : \"%Q\",\n" \
> +			     "      \"paths\" : %N,\n" \
> +			     "      \"write_prot\" : \"%r\",\n" \
> +			     "      \"dm_st\" : \"%t\",\n" \
> +			     "      \"features\" : \"%f\",\n" \
> +			     "      \"hwhandler\" : \"%h\",\n" \
> +			     "      \"action\" : \"%A\",\n" \
> +			     "      \"path_faults\" : %0,\n" \
> +			     "      \"vend\" : \"%v\",\n" \
> +			     "      \"prod\" : \"%p\",\n" \
> +			     "      \"rev\" : \"%e\",\n" \
> +			     "      \"switch_grp\" : %1,\n" \
> +			     "      \"map_loads\" : %2,\n" \
> +			     "      \"total_q_time\" : %3,\n" \
> +			     "      \"q_timeouts\" : %4,"
> +
> +#define PRINT_JSON_GROUP     "{\n" \
> +			     "         \"selector\" : \"%s\",\n" \
> +			     "         \"pri\" : %p,\n" \
> +			     "         \"dm_st\" : \"%t\",\n" \
> +			     "         \"marginal_st\" : \"%M\","
> +
> +#define PRINT_JSON_GROUP_NUM "         \"group\" : %d,\n"
> +
> +#define PRINT_JSON_PATH      "{\n" \
> +			     "            \"dev\" : \"%d\",\n"\
> +			     "            \"dev_t\" : \"%D\",\n" \
> +			     "            \"dm_st\" : \"%t\",\n" \
> +			     "            \"dev_st\" : \"%o\",\n" \
> +			     "            \"chk_st\" : \"%T\",\n" \
> +			     "            \"checker\" : \"%c\",\n" \
> +			     "            \"pri\" : %p,\n" \
> +			     "            \"host_wwnn\" : \"%N\",\n" \
> +			     "            \"target_wwnn\" : \"%n\",\n" \
> +			     "            \"host_wwpn\" : \"%R\",\n" \
> +			     "            \"target_wwpn\" : \"%r\",\n" \
> +			     "            \"host_adapter\" : \"%a\",\n" \
> +			     "            \"marginal_st\" : \"%M\""
> +
> +#define PROGRESS_LEN  10
> +
>  #define MAX(x,y) (((x) > (y)) ? (x) : (y))
>  #define MIN(x,y) (((x) > (y)) ? (y) : (x))
>  /*
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index b922812..c6674a5 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -2,80 +2,12 @@
>  #define _PRINT_H
>  #include "dm-generic.h"
>  
> -struct strbuf;
> -
> -#define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
> -#define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
>  #define PRINT_PATH_CHECKER   "%i %d %D %p %t %T %o %C"
>  #define PRINT_MAP_STATUS     "%n %F %Q %N %t %r"
>  #define PRINT_MAP_STATS      "%n %0 %1 %2 %3 %4"
>  #define PRINT_MAP_NAMES      "%n %d %w"
> -#define PRINT_MAP_PROPS      "size=%S features='%f' hwhandler='%h' wp=%r"
> -#define PRINT_PG_INDENT      "policy='%s' prio=%p status=%t"
> -
> -#define PRINT_JSON_MULTIPLIER     5
> -#define PRINT_JSON_MAJOR_VERSION  0
> -#define PRINT_JSON_MINOR_VERSION  1
> -#define PRINT_JSON_START_VERSION  "   \"major_version\": %d,\n" \
> -				  "   \"minor_version\": %d,\n"
> -#define PRINT_JSON_START_ELEM     "{\n"
> -#define PRINT_JSON_START_MAP      "   \"map\":"
> -#define PRINT_JSON_START_MAPS     "\"maps\": ["
> -#define PRINT_JSON_START_PATHS    "\"paths\": ["
> -#define PRINT_JSON_START_GROUPS   "\"path_groups\": ["
> -#define PRINT_JSON_END_ELEM       "},"
> -#define PRINT_JSON_END_LAST_ELEM  "}"
> -#define PRINT_JSON_END_LAST       "}\n"
> -#define PRINT_JSON_END_ARRAY      "]\n"
> -#define PRINT_JSON_INDENT_N    3
> -#define PRINT_JSON_MAP       "{\n" \
> -			     "      \"name\" : \"%n\",\n" \
> -			     "      \"uuid\" : \"%w\",\n" \
> -			     "      \"sysfs\" : \"%d\",\n" \
> -			     "      \"failback\" : \"%F\",\n" \
> -			     "      \"queueing\" : \"%Q\",\n" \
> -			     "      \"paths\" : %N,\n" \
> -			     "      \"write_prot\" : \"%r\",\n" \
> -			     "      \"dm_st\" : \"%t\",\n" \
> -			     "      \"features\" : \"%f\",\n" \
> -			     "      \"hwhandler\" : \"%h\",\n" \
> -			     "      \"action\" : \"%A\",\n" \
> -			     "      \"path_faults\" : %0,\n" \
> -			     "      \"vend\" : \"%v\",\n" \
> -			     "      \"prod\" : \"%p\",\n" \
> -			     "      \"rev\" : \"%e\",\n" \
> -			     "      \"switch_grp\" : %1,\n" \
> -			     "      \"map_loads\" : %2,\n" \
> -			     "      \"total_q_time\" : %3,\n" \
> -			     "      \"q_timeouts\" : %4,"
> -
> -#define PRINT_JSON_GROUP     "{\n" \
> -			     "         \"selector\" : \"%s\",\n" \
> -			     "         \"pri\" : %p,\n" \
> -			     "         \"dm_st\" : \"%t\",\n" \
> -			     "         \"marginal_st\" : \"%M\","
>  
> -#define PRINT_JSON_GROUP_NUM "         \"group\" : %d,\n"
> -
> -#define PRINT_JSON_PATH      "{\n" \
> -			     "            \"dev\" : \"%d\",\n"\
> -			     "            \"dev_t\" : \"%D\",\n" \
> -			     "            \"dm_st\" : \"%t\",\n" \
> -			     "            \"dev_st\" : \"%o\",\n" \
> -			     "            \"chk_st\" : \"%T\",\n" \
> -			     "            \"checker\" : \"%c\",\n" \
> -			     "            \"pri\" : %p,\n" \
> -			     "            \"host_wwnn\" : \"%N\",\n" \
> -			     "            \"target_wwnn\" : \"%n\",\n" \
> -			     "            \"host_wwpn\" : \"%R\",\n" \
> -			     "            \"target_wwpn\" : \"%r\",\n" \
> -			     "            \"host_adapter\" : \"%a\",\n" \
> -			     "            \"marginal_st\" : \"%M\""
> -
> -#define MAX_LINE_LEN  80
> -#define MAX_LINES     64
> -#define MAX_FIELD_LEN 128
> -#define PROGRESS_LEN  10
> +struct strbuf;
>  
>  struct path_data {
>  	char wildcard;
> -- 
> 2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

