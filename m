Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D32B5EB64DA
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jun 2023 22:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688163471;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XyeWwwFiraOeNYlMSL4R6DpZ3aQxSsp2amyJM2VXlTM=;
	b=O5BZLw+jW+o3x1rfskT+6rp2cXPyMePg8iXUQxVBpUuP0vhQ5LCCN1YlAIcC/fQyst4wuu
	Op4PLso6E0wZ9WraH+txp+cP/bDrf2tv7+NtDKa54GnlKwy06W4nwY1QsLdXJw7kfIDm2E
	OtOZahNAKgcAF7F9G/CWM5rMxtxfrn4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-97-mjvTOG8pPYK9fpUho0HIVA-1; Fri, 30 Jun 2023 18:17:50 -0400
X-MC-Unique: mjvTOG8pPYK9fpUho0HIVA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D270B1044594;
	Fri, 30 Jun 2023 22:17:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2B61848FB01;
	Fri, 30 Jun 2023 22:17:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EF59D19465B6;
	Fri, 30 Jun 2023 22:17:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B6DA19465B3
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Jun 2023 22:16:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79D771121315; Fri, 30 Jun 2023 22:16:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DA961121314;
 Fri, 30 Jun 2023 22:16:57 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 35UMGrJb009883;
 Fri, 30 Jun 2023 17:16:53 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 35UMGrS3009882;
 Fri, 30 Jun 2023 17:16:53 -0500
Date: Fri, 30 Jun 2023 17:16:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230630221652.GF7412@octiron.msp.redhat.com>
References: <20230630181407.14302-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230630181407.14302-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] libmultipath: ignore nvme devices if nvme
 native multipath is enabled
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 30, 2023 at 08:14:07PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If the nvme native multipath driver is enabled, blacklist nvme devices
> for dm-multipath by default. This is particularly useful with
> "find_multipaths greedy".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

This looks good. I have two small questions below.

> ---
>  libmultipath/blacklist.c | 35 ++++++++++++++++++++++++++++++++---
>  tests/blacklist.c        | 30 ++++++++++++++++++++++++++++--
>  2 files changed, 60 insertions(+), 5 deletions(-)
> 
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index 8d15d2e..75100b2 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -2,6 +2,8 @@
>   * Copyright (c) 2004, 2005 Christophe Varoqui
>   */
>  #include <stdio.h>
> +#include <unistd.h>
> +#include <fcntl.h>
>  #include <libudev.h>
>  
>  #include "checkers.h"
> @@ -191,6 +193,27 @@ find_blacklist_device (const struct _vector *blist, const char *vendor,
>  	return 0;
>  }
>  
> +/*
> + * Test if nvme native multipath is enabled. If the sysfs file can't
> + * be accessed, multipath is either disabled at compile time, or no
> + * nvme driver is loaded at all. Thus treat errors as "no".
> + */
> +static bool nvme_multipath_enabled(void)
> +{
> +	static const char fn[] = "/sys/module/nvme_core/parameters/multipath";

Is there some benefit that I don't understand to using "static const",
instead of just "const"?  Obviously, the amount of memory necessary to
keep storing this string outside of the function is very small, but I
don't see why we need to at all.

> +	int fd, len;
> +	char buf[2];
> +
> +	fd = open(fn, O_RDONLY);
> +	if (fd == -1)
> +		return false;
> +
> +	len = read(fd, buf, sizeof(buf));
> +	close(fd);
> +
> +	return (len >= 1 && buf[0] == 'Y');
> +}
> +
>  int
>  setup_default_blist (struct config * conf)
>  {
> @@ -198,9 +221,15 @@ setup_default_blist (struct config * conf)
>  	struct hwentry *hwe;
>  	int i;
>  
> -	if (store_ble(conf->blist_devnode, "!^(sd[a-z]|dasd[a-z]|nvme[0-9])", ORIGIN_DEFAULT))
> -		return 1;
> -
> +	if (nvme_multipath_enabled()) {
> +		if (store_ble(conf->blist_devnode, "!^(sd[a-z]|dasd[a-z])",
> +			      ORIGIN_DEFAULT))
> +			return 1;
> +	} else {
> +		if (store_ble(conf->blist_devnode, "!^(sd[a-z]|dasd[a-z]|nvme[0-9])",
> +			      ORIGIN_DEFAULT))
> +			return 1;
> +	}
>  	if (store_ble(conf->elist_property, "(SCSI_IDENT_|ID_WWN)", ORIGIN_DEFAULT))
>  		return 1;
>  
> diff --git a/tests/blacklist.c b/tests/blacklist.c
> index 882aa3a..65002eb 100644
> --- a/tests/blacklist.c
> +++ b/tests/blacklist.c
> @@ -17,6 +17,8 @@
>   */
>  #include <stdarg.h>
>  #include <stddef.h>
> +#include <unistd.h>
> +#include <fcntl.h>
>  #include <setjmp.h>
>  #include <cmocka.h>
>  #include "globals.c"
> @@ -220,12 +222,36 @@ static void test_devnode_missing(void **state)
>  			 MATCH_NOTHING);
>  }

Perhaps we should just use #include "../libmultipath/blacklist.c" like
we do for tests where we need get at a file's private
variables/functions ("../libmultipath/alias.c" in alias.c for instance).

-Ben

> +/* copy of the same function in libmultipath/blacklist.c */
> +static bool nvme_multipath_enabled(void)
> +{
> +	static const char fn[] = "/sys/module/nvme_core/parameters/multipath";
> +	int fd, len;
> +	char buf[2];
> +
> +	fd = open(fn, O_RDONLY);
> +	if (fd == -1)
> +		return false;
> +
> +	len = read(fd, buf, sizeof(buf));
> +	close(fd);
> +
> +	return (len >= 1 && buf[0] == 'Y');
> +}
> +
>  static void test_devnode_default(void **state)
>  {
>  	assert_int_equal(filter_devnode(blist_devnode_default, NULL, "sdaa"),
>  			 MATCH_NOTHING);
> -	assert_int_equal(filter_devnode(blist_devnode_default, NULL, "nvme0n1"),
> -			 MATCH_NOTHING);
> +	if (nvme_multipath_enabled()) {
> +		expect_condlog(3, "nvme0n1: device node name blacklisted\n");
> +		assert_int_equal(filter_devnode(blist_devnode_default, NULL,
> +						"nvme0n1"),
> +				 MATCH_DEVNODE_BLIST);
> +	} else
> +		assert_int_equal(filter_devnode(blist_devnode_default, NULL,
> +						"nvme0n1"),
> +				 MATCH_NOTHING);
>  	assert_int_equal(filter_devnode(blist_devnode_default, NULL, "dasda"),
>  			 MATCH_NOTHING);
>  	expect_condlog(3, "hda: device node name blacklisted\n");
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

