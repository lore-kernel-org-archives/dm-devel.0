Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25115C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 00:47:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AA12561B31
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 00:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AA12561B31
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637196463;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8QBQFMMzVqd6Crcc1mPI+VMLrbdaktWxFB8rs/n3zu8=;
	b=Xevx6gyX0f8nO4yn4g+4H/TLGgcPZC12OzfcRKI4WxVFV3LaZFhfoL0pAiNqtv2jWplIga
	EbgEwYChSY7jRIMwIy0Mfr+30uWdNsiCRe7GDIUuYKF+SJKseY7hB1tfiKlS1SHrGU1TXM
	p5dn8SKC/rwI38fEESVanRzb33W/kUg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-gDF5KuAfNZ2XkK4tUUPstw-1; Wed, 17 Nov 2021 19:47:40 -0500
X-MC-Unique: gDF5KuAfNZ2XkK4tUUPstw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B653EBBEE0;
	Thu, 18 Nov 2021 00:47:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A68360657;
	Thu, 18 Nov 2021 00:47:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AEF934E58F;
	Thu, 18 Nov 2021 00:47:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AI0lVbr010160 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 19:47:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3D06F5C1BB; Thu, 18 Nov 2021 00:47:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7195E5C232;
	Thu, 18 Nov 2021 00:47:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AI0lHsj006134; 
	Wed, 17 Nov 2021 18:47:17 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AI0lGR7006133;
	Wed, 17 Nov 2021 18:47:16 -0600
Date: Wed, 17 Nov 2021 18:47:16 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <20211118004716.GF19591@octiron.msp.redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
	<483a6cc1-10f1-a702-2e44-42ab7cb8e3cd@huawei.com>
MIME-Version: 1.0
In-Reply-To: <483a6cc1-10f1-a702-2e44-42ab7cb8e3cd@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH 4/5] Match FREE and MALLOC/STRDUP/REALLOC
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 16, 2021 at 10:00:53PM +0800, lixiaokeng wrote:
> In _DEBUG_ mode, MALLOC/STRDUP/REALLOC and FREE will record
> the memory usage. Match them.

This looks fine, but personally, I'd rather just have all the DEBUG
memory code removed. If people want to check memory usage, there's
always valgrind.

-Ben

> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>  kpartx/dasd.c                        | 5 +++--
>  kpartx/kpartx.c                      | 7 ++++---
>  libmultipath/blacklist.c             | 6 +++---
>  libmultipath/checkers/emc_clariion.c | 2 +-
>  libmultipath/config.c                | 4 ++--
>  libmultipath/configure.c             | 4 ++--
>  libmultipath/dmparser.c              | 2 +-
>  libmultipath/parser.c                | 2 +-
>  libmultipath/structs.c               | 2 +-
>  multipathd/main.c                    | 2 +-
>  10 files changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/kpartx/dasd.c b/kpartx/dasd.c
> index f0398645..14744048 100644
> --- a/kpartx/dasd.c
> +++ b/kpartx/dasd.c
> @@ -40,6 +40,7 @@
>  #include "kpartx.h"
>  #include "byteorder.h"
>  #include "dasd.h"
> +#include "memory.h"
> 
>  unsigned long long sectors512(unsigned long long sectors, int blocksize)
>  {
> @@ -100,10 +101,10 @@ read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
>  		 * Get the first target and operate on that instead.
>  		 */
>  		if (!(dev = dm_get_first_dep(devname))) {
> -			free(devname);
> +			FREE(devname);
>  			return -1;
>  		}
> -		free(devname);
> +		FREE(devname);
> 
>  		if ((unsigned int)major(dev) != 94) {
>  			/* Not a DASD */
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 7bc64543..5e59063d 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -39,6 +39,7 @@
>  #include "lopart.h"
>  #include "kpartx.h"
>  #include "version.h"
> +#include "memory.h"
> 
>  #define SIZE(a) (sizeof(a)/sizeof((a)[0]))
> 
> @@ -177,7 +178,7 @@ get_hotplug_device(void)
> 
>  	/* Dirname + mapname + \0 */
>  	if (!(device = (char *)malloc(sizeof(char) * (off + len + 1)))) {
> -		free(mapname);
> +		FREE(mapname);
>  		return NULL;
>  	}
> 
> @@ -187,10 +188,10 @@ get_hotplug_device(void)
> 
>  	if (strlen(device) != (off + len)) {
>  		free(device);
> -		free(mapname);
> +		FREE(mapname);
>  		return NULL;
>  	}
> -	free(mapname);
> +	FREE(mapname);
>  	return device;
>  }
> 
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 4e315c97..573df152 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -39,7 +39,7 @@ int store_ble(vector blist, const char *str, int origin)
>  	if (!str)
>  		return 0;
> 
> -	strdup_str = strdup(str);
> +	strdup_str = STRDUP(str);
>  	if (!strdup_str)
>  		return 1;
> 
> @@ -134,8 +134,8 @@ out1:
>  		ble->vendor = NULL;
>  	}
>  out:
> -	free(vendor_str);
> -	free(product_str);
> +	FREE(vendor_str);
> +	FREE(product_str);
>  	return 1;
>  }
> 
> diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
> index 5cd63aca..b3f0aded 100644
> --- a/libmultipath/checkers/emc_clariion.c
> +++ b/libmultipath/checkers/emc_clariion.c
> @@ -128,7 +128,7 @@ int libcheck_mp_init (struct checker * c)
> 
>  void libcheck_free (struct checker * c)
>  {
> -	free(c->context);
> +	FREE(c->context);
>  }
> 
>  int libcheck_check (struct checker * c)
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 30046a17..667b500b 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -1051,10 +1051,10 @@ int parse_uid_attrs(char *uid_attrs, struct config *conf)
>  		if (!tmp) {
>  			condlog(2, "invalid record in uid_attrs: %s",
>  				uid_attr_record);
> -			free(uid_attr_record);
> +			FREE(uid_attr_record);
>  			ret = 1;
>  		} else if (!vector_alloc_slot(attrs)) {
> -			free(uid_attr_record);
> +			FREE(uid_attr_record);
>  			ret = 1;
>  		} else
>  			vector_set_slot(attrs, uid_attr_record);
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 7edb355b..9545854b 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -738,8 +738,8 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
>  		condlog(1, "%s: can't use alias \"%s\" used by %s, falling back to WWID",
>  			mpp->wwid, mpp->alias, cmpp_by_name->wwid);
>  		/* We can do this because wwid wasn't found */
> -		free(mpp->alias);
> -		mpp->alias = strdup(mpp->wwid);
> +		FREE(mpp->alias);
> +		mpp->alias = STRDUP(mpp->wwid);
>  		mpp->action = ACT_CREATE;
>  		condlog(3, "%s: set ACT_CREATE (map does not exist, name changed)",
>  			mpp->alias);
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 4ba7f339..96beeb6d 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -30,7 +30,7 @@ merge_words(char **dst, const char *word)
>  	*dst = REALLOC(*dst, len);
> 
>  	if (!*dst) {
> -		free(p);
> +		FREE(p);
>  		return 1;
>  	}
> 
> diff --git a/libmultipath/parser.c b/libmultipath/parser.c
> index 68262d0e..f0047c4d 100644
> --- a/libmultipath/parser.c
> +++ b/libmultipath/parser.c
> @@ -364,7 +364,7 @@ set_value(vector strvec)
>  	for (i = 2; i < VECTOR_SIZE(strvec); i++) {
>  		str = VECTOR_SLOT(strvec, i);
>  		if (!str) {
> -			free(alloc);
> +			FREE(alloc);
>  			condlog(0, "parse error for option '%s'",
>  				(char *)VECTOR_SLOT(strvec, 0));
>  			return NULL;
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 6e5a1038..e8cacb4b 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -106,7 +106,7 @@ alloc_path (void)
>  		dm_path_to_gen(pp)->ops = &dm_gen_path_ops;
>  		pp->hwe = vector_alloc();
>  		if (pp->hwe == NULL) {
> -			free(pp);
> +			FREE(pp);
>  			return NULL;
>  		}
>  	}
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1defeaf1..82ab3ed1 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3555,7 +3555,7 @@ void *  mpath_pr_event_handler_fn (void * pathp )
>  		goto out;
>  	}
> 
> -	param = (struct prout_param_descriptor *)MALLOC(sizeof(struct prout_param_descriptor));
> +	param = (struct prout_param_descriptor *)calloc(1, sizeof(struct prout_param_descriptor));
>  	if (!param)
>  		goto out;
> 
> -- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

