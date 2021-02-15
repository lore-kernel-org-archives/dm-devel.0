Return-Path: <SRS0=FEAK=HR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BB0C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 15 Feb 2021 21:39:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7F9D564DEB
	for <dm-devel@archiver.kernel.org>; Mon, 15 Feb 2021 21:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F9D564DEB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1613425198;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qnGrZlDy7PdxSOuZi9lZ5OjVtlTLgTtCaR63Vvha3SA=;
	b=H5Bry0XVpEAzZ9jdwx9G+KtAZngiQIsfdIU3+SUkTmtXoEf6NT6JhnYqp2ZE3wsMDrsRcy
	TxshBapQM6zHAq0zAY1qheW3/NFUDTn/8yPruyqyMsJkM1d+EouLpiULz/8pGcqAKhkez0
	umWCk0nVmL/lKJrjeYQNYrFup4XUhwQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-i__fGqZ8NOaRhbHt25l8Ww-1; Mon, 15 Feb 2021 16:39:54 -0500
X-MC-Unique: i__fGqZ8NOaRhbHt25l8Ww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A1741934100;
	Mon, 15 Feb 2021 21:39:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCF9860875;
	Mon, 15 Feb 2021 21:39:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E77557DFA;
	Mon, 15 Feb 2021 21:39:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11FLdP8A003713 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Feb 2021 16:39:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3009A2BFEC; Mon, 15 Feb 2021 21:39:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA0D419CAB;
	Mon, 15 Feb 2021 21:39:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 11FLdKV9024438; 
	Mon, 15 Feb 2021 15:39:20 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 11FLdJEH024437;
	Mon, 15 Feb 2021 15:39:19 -0600
Date: Mon, 15 Feb 2021 15:39:19 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210215213919.GL15006@octiron.msp.redhat.com>
References: <20210211234650.21890-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210211234650.21890-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [dm-devel] [PATCH 1/4] multipath-tools tests: allow control of
 test verbosity
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 12, 2021 at 12:46:47AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Use common code to control verbosity during unit tests runs.
> The environment variable MPATHTEST_VERBOSITY is honored by most
> tests, except those that need to parse the log messages or have
> other special needs.
> 
> Also, get rid of the now obsolete global variables logsink and
> udev, as these are now defined in libmultipath.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

For the set.

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/README.md   |  5 +++++
>  tests/alias.c     |  2 +-
>  tests/blacklist.c |  2 +-
>  tests/devt.c      |  1 +
>  tests/directio.c  |  2 +-
>  tests/dmevents.c  |  1 +
>  tests/globals.c   | 27 +++++++++++++++++++++------
>  tests/hwtable.c   |  2 ++
>  tests/parser.c    |  1 +
>  tests/pgpolicy.c  |  1 +
>  tests/uevent.c    |  1 +
>  tests/unaligned.c |  1 +
>  tests/util.c      |  1 +
>  tests/valid.c     |  2 ++
>  tests/vpd.c       |  1 +
>  15 files changed, 41 insertions(+), 9 deletions(-)
> 
> diff --git a/tests/README.md b/tests/README.md
> index 6e7ad40..47c0f0b 100644
> --- a/tests/README.md
> +++ b/tests/README.md
> @@ -13,6 +13,11 @@ If valgrind detects a bad memory access or leak, the test will fail. The
>  output of the test run, including valgrind output, is stored as
>  `<testname>.vgr`.
>  
> +## Controlling verbosity for unit tests
> +
> +Some test programs use the environment variable `MPATHTEST_VERBOSITY` to
> +control the log level during test execution.
> +
>  ## Notes on individual tests
>  
>  ### Tests that require root permissions
> diff --git a/tests/alias.c b/tests/alias.c
> index 5e0bfea..b363718 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -736,7 +736,7 @@ static int test_allocate_binding(void)
>  int main(void)
>  {
>  	int ret = 0;
> -	libmp_verbosity = conf.verbosity;
> +	init_test_verbosity(3);
>  
>  	ret += test_format_devname();
>  	ret += test_scan_devname();
> diff --git a/tests/blacklist.c b/tests/blacklist.c
> index 0b42e25..882aa3a 100644
> --- a/tests/blacklist.c
> +++ b/tests/blacklist.c
> @@ -153,7 +153,7 @@ static int setup(void **state)
>  	    store_ble(blist_property_wwn_inv, "!ID_WWN", ORIGIN_CONFIG))
>  		return -1;
>  
> -	libmp_verbosity = conf.verbosity = 4;
> +	init_test_verbosity(4);
>  	return 0;
>  }
>  
> diff --git a/tests/devt.c b/tests/devt.c
> index fd4d74a..2b72851 100644
> --- a/tests/devt.c
> +++ b/tests/devt.c
> @@ -187,6 +187,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	init_test_verbosity(-1);
>  	ret += devt2devname_tests();
>  	return ret;
>  }
> diff --git a/tests/directio.c b/tests/directio.c
> index 9895409..9f7d388 100644
> --- a/tests/directio.c
> +++ b/tests/directio.c
> @@ -770,7 +770,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> -	conf.verbosity = 2;
> +	init_test_verbosity(2);
>  	ret += test_directio();
>  	return ret;
>  }
> diff --git a/tests/dmevents.c b/tests/dmevents.c
> index 29eaa6d..204cf1d 100644
> --- a/tests/dmevents.c
> +++ b/tests/dmevents.c
> @@ -925,6 +925,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	init_test_verbosity(-1);
>  	ret += test_dmevents();
>  	return ret;
>  }
> diff --git a/tests/globals.c b/tests/globals.c
> index fc0c07a..36319ed 100644
> --- a/tests/globals.c
> +++ b/tests/globals.c
> @@ -1,13 +1,12 @@
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include "defaults.h"
>  #include "structs.h"
>  #include "config.h"
>  #include "debug.h"
>  
> -/* Required globals */
> -struct udev *udev;
> -int logsink = LOGSINK_STDERR_WITHOUT_TIME;
> -struct config conf = {
> -	.verbosity = 4,
> -};
> +struct config conf;
>  
>  struct config *get_multipath_config(void)
>  {
> @@ -16,3 +15,19 @@ struct config *get_multipath_config(void)
>  
>  void put_multipath_config(void *arg)
>  {}
> +
> +static __attribute__((unused)) void init_test_verbosity(int test_verbosity)
> +{
> +	char *verb = getenv("MPATHTEST_VERBOSITY");
> +
> +	libmp_verbosity = test_verbosity >= 0 ? test_verbosity :
> +		DEFAULT_VERBOSITY;
> +	if (verb && *verb) {
> +		char *c;
> +		int vb;
> +
> +		vb = strtoul(verb, &c, 10);
> +		if (!*c && vb >= 0 && vb <= 5)
> +			libmp_verbosity = vb;
> +	}
> +}
> diff --git a/tests/hwtable.c b/tests/hwtable.c
> index 4dd0873..6f5766f 100644
> --- a/tests/hwtable.c
> +++ b/tests/hwtable.c
> @@ -1778,6 +1778,8 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	/* We can't use init_test_verbosity in this test */
> +	libmp_verbosity = VERBOSITY;
>  	ret += test_hwtable();
>  	return ret;
>  }
> diff --git a/tests/parser.c b/tests/parser.c
> index 5772391..cf96d81 100644
> --- a/tests/parser.c
> +++ b/tests/parser.c
> @@ -511,6 +511,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	init_test_verbosity(-1);
>  	ret += test_config_parser();
>  	return ret;
>  }
> diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
> index 3f61b12..57ad338 100644
> --- a/tests/pgpolicy.c
> +++ b/tests/pgpolicy.c
> @@ -1031,6 +1031,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	init_test_verbosity(-1);
>  	ret += test_pgpolicies();
>  	return ret;
>  }
> diff --git a/tests/uevent.c b/tests/uevent.c
> index 9ffcd2d..648ff26 100644
> --- a/tests/uevent.c
> +++ b/tests/uevent.c
> @@ -322,6 +322,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	init_test_verbosity(-1);
>  	ret += test_uevent_get_XXX();
>  	return ret;
>  }
> diff --git a/tests/unaligned.c b/tests/unaligned.c
> index 7ece1de..e43b64d 100644
> --- a/tests/unaligned.c
> +++ b/tests/unaligned.c
> @@ -91,6 +91,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	init_test_verbosity(-1);
>  	ret += test_unaligned();
>  	return ret;
>  }
> diff --git a/tests/util.c b/tests/util.c
> index c3c49b6..9affb0e 100644
> --- a/tests/util.c
> +++ b/tests/util.c
> @@ -946,6 +946,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	init_test_verbosity(-1);
>  	ret += test_basenamecpy();
>  	ret += test_bitmasks();
>  	ret += test_strlcpy();
> diff --git a/tests/valid.c b/tests/valid.c
> index 8ec803e..e7393a1 100644
> --- a/tests/valid.c
> +++ b/tests/valid.c
> @@ -554,6 +554,8 @@ int test_valid(void)
>  int main(void)
>  {
>  	int ret = 0;
> +
> +	init_test_verbosity(-1);
>  	ret += test_valid();
>  	return ret;
>  }
> diff --git a/tests/vpd.c b/tests/vpd.c
> index e2ec65e..8e730d3 100644
> --- a/tests/vpd.c
> +++ b/tests/vpd.c
> @@ -799,6 +799,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> +	init_test_verbosity(-1);
>  	ret += test_vpd();
>  	return ret;
>  }
> -- 
> 2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

