Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EE5C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:20:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 778CC23BA7
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:20:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 778CC23BA7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608333628;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=u8EbSKijn1xLJxfHZDYuCYsIuYhKXG+uiUy/lwPJbtQ=;
	b=K6cP2U91IAWpOLpt/0PDr/bUhwpF7BO0ILanLwYp6wapmpLz+0wZYTO/mwSnehXlPmFEfk
	sRT81yC4aumst5poE8wrcy8TyXx5Z0QcJfc0UnUQnknAJYtGqwWAKtR3uuN3JqxYb0Ge+9
	uBn6Bh5Z//vCDhmiX+PMBRG8w0wJzsI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-muwwWN-GN7yHDhxK8fnVOg-1; Fri, 18 Dec 2020 18:20:26 -0500
X-MC-Unique: muwwWN-GN7yHDhxK8fnVOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B39ED801817;
	Fri, 18 Dec 2020 23:20:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73F7E60CE7;
	Fri, 18 Dec 2020 23:20:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27BC41809C9F;
	Fri, 18 Dec 2020 23:20:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BINKLmX029568 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:20:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 42BDB6A050; Fri, 18 Dec 2020 23:20:21 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66DF760CE7;
	Fri, 18 Dec 2020 23:20:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BINKGjA010035; 
	Fri, 18 Dec 2020 17:20:16 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BINKFhZ010034;
	Fri, 18 Dec 2020 17:20:15 -0600
Date: Fri, 18 Dec 2020 17:20:15 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201218232015.GQ3103@octiron.msp.redhat.com>
References: <20201218222714.16209-1-mwilck@suse.com>
	<20201218222714.16209-2-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201218222714.16209-2-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 2/2] multipath-tools unit tests: fix memory
 leaks in mpathvalid tests
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

On Fri, Dec 18, 2020 at 11:27:14PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> They break "make valgrind-test".
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/mpathvalid.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tests/mpathvalid.c b/tests/mpathvalid.c
> index 5ffabb9..cfe4bae 100644
> --- a/tests/mpathvalid.c
> +++ b/tests/mpathvalid.c
> @@ -381,6 +381,7 @@ static void test_mpathvalid_is_path_good2(void **state)
>  	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
>  					    wwids, 4), MPATH_IS_VALID);
>  	assert_string_equal(wwid, TEST_WWID);
> +	free(wwid);
>  }
>  
>  static void test_mpathvalid_is_path_good3(void **state)
> @@ -395,6 +396,7 @@ static void test_mpathvalid_is_path_good3(void **state)
>  	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_SMART, &wwid,
>  					    wwids, 4), MPATH_IS_VALID);
>  	assert_string_equal(wwid, TEST_WWID);
> +	free(wwid);
>  }
>  
>  /* mabybe valid with no matching paths */
> @@ -410,6 +412,7 @@ static void test_mpathvalid_is_path_good4(void **state)
>  	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
>  					    wwids, 4), MPATH_IS_MAYBE_VALID);
>  	assert_string_equal(wwid, TEST_WWID);
> +	free(wwid);
>  }
>  
>  /* maybe valid with matching paths */
> @@ -425,6 +428,7 @@ static void test_mpathvalid_is_path_good5(void **state)
>  	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
>  					    wwids, 4), MPATH_IS_VALID);
>  	assert_string_equal(wwid, TEST_WWID);
> +	free(wwid);
>  }
>  
>  #define setup_test(name) \
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

