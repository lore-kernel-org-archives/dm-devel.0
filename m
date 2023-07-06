Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13DF3EB64D9
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jul 2023 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688659605;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=34Mw6xKPzgKqIwkJ+m9z1vEqNDBKmB2AfRKoU8CePIo=;
	b=J2dnHFL2mRPnCgeo36Fvl95WBhiUK2M5axzafwufqKP+NvUwwW2ZANsgQaMG8Nh0ZUK19/
	uf9jwpS/iMSvh4ngJJvofdaBMh2pa58t0JlNVjiZiXG+HQ4DDcus9itO5uDNzgcrGnGToL
	M4N7i7F7iJ0nJUtcA1bShgdyNllpE3o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-k2zhp51AP82PrZC7TzZ7gw-1; Thu, 06 Jul 2023 12:06:43 -0400
X-MC-Unique: k2zhp51AP82PrZC7TzZ7gw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD695101A528;
	Thu,  6 Jul 2023 16:06:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BBED492C13;
	Thu,  6 Jul 2023 16:06:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5AACB194658F;
	Thu,  6 Jul 2023 16:06:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 481211946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  6 Jul 2023 16:06:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 34F0F40C6CD0; Thu,  6 Jul 2023 16:06:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 15F5540C6CCD;
 Thu,  6 Jul 2023 16:06:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 366G6ZH1014736;
 Thu, 6 Jul 2023 11:06:35 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 366G6YQD014735;
 Thu, 6 Jul 2023 11:06:34 -0500
Date: Thu, 6 Jul 2023 11:06:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230706160634.GI7412@octiron.msp.redhat.com>
References: <20230703164021.24843-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230703164021.24843-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2] libmultipath: ignore nvme devices if nvme
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jul 03, 2023 at 06:40:21PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If the nvme native multipath driver is enabled, blacklist nvme devices
> for dm-multipath by default. This is particularly useful with
> "find_multipaths greedy".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/blacklist.c | 35 ++++++++++++++++++++++++++++++++---
>  tests/Makefile           |  1 -
>  tests/blacklist.c        | 13 +++++++++++--
>  3 files changed, 43 insertions(+), 6 deletions(-)
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
> diff --git a/tests/Makefile b/tests/Makefile
> index 83edc2f..c777d07 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -48,7 +48,6 @@ hwtable-test_OBJDEPS := $(multipathdir)/discovery.o $(multipathdir)/blacklist.o
>  	$(multipathdir)/structs.o $(multipathdir)/propsel.o
>  hwtable-test_LIBDEPS := -ludev -lpthread -ldl
>  blacklist-test_TESTDEPS := test-log.o
> -blacklist-test_OBJDEPS := $(multipathdir)/blacklist.o
>  blacklist-test_LIBDEPS := -ludev
>  vpd-test_OBJDEPS :=  $(multipathdir)/discovery.o
>  vpd-test_LIBDEPS := -ludev -lpthread -ldl
> diff --git a/tests/blacklist.c b/tests/blacklist.c
> index 882aa3a..ba8dfd0 100644
> --- a/tests/blacklist.c
> +++ b/tests/blacklist.c
> @@ -24,6 +24,8 @@
>  #include "test-log.h"
>  #include "debug.h"
>  
> +#include "../libmultipath/blacklist.c"
> +
>  struct udev_device {
>  	const char *sysname;
>  	char *property_list[];
> @@ -224,8 +226,15 @@ static void test_devnode_default(void **state)
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

