Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B809FC43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 15:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654788187;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=trrdw0KMKNX1Vh27PMeDuRCutVFTyelnhjgTns7kxdY=;
	b=bpLyBvpdXVrYRRW0tyHLVSaa2yhFrhVVNqbVTTNIZvoWvO/xjo5X16RsXMig20vhfjppwD
	bnnBoDoDWgboUKRg4z8cC2hvbvTDFQd2yU4es/PEnzZJUepHVLFXu0naRpXEQEW5RllhLw
	AIOkhysNxivUHGzHC8q1Rr6arF9e6Lk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-rhv5cEiaN3yfBcTXSQgtig-1; Thu, 09 Jun 2022 11:23:04 -0400
X-MC-Unique: rhv5cEiaN3yfBcTXSQgtig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B0853C01D9B;
	Thu,  9 Jun 2022 15:23:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29B88C28119;
	Thu,  9 Jun 2022 15:23:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CFF7E194705E;
	Thu,  9 Jun 2022 15:23:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 929221947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 15:23:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 604C51121315; Thu,  9 Jun 2022 15:23:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D52E1121314;
 Thu,  9 Jun 2022 15:23:01 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 259FN0vK030895;
 Thu, 9 Jun 2022 10:23:00 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 259FMxPg030894;
 Thu, 9 Jun 2022 10:22:59 -0500
Date: Thu, 9 Jun 2022 10:22:59 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220609152259.GB5254@octiron.msp.redhat.com>
References: <20220609101355.21365-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220609101355.21365-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] multipath-tools: tests: fix hwtable test
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 09, 2022 at 12:13:55PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> After "libmultipath: hwtable: new defaults for NVMe", we need to fix
> the unit tests.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  tests/hwtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/hwtable.c b/tests/hwtable.c
> index e60e914..bfaf613 100644
> --- a/tests/hwtable.c
> +++ b/tests/hwtable.c
> @@ -573,7 +573,7 @@ static void test_internal_nvme(const struct hwt_state *hwt)
>  	assert_ptr_not_equal(mp, NULL);
>  	TEST_PROP(checker_name(&pp->checker), NONE);
>  	TEST_PROP(pp->uid_attribute, DEFAULT_NVME_UID_ATTRIBUTE);
> -	assert_int_equal(mp->pgpolicy, DEFAULT_PGPOLICY);
> +	assert_int_equal(mp->pgpolicy, GROUP_BY_PRIO);
>  	assert_int_equal(mp->no_path_retry, DEFAULT_NO_PATH_RETRY);
>  	assert_int_equal(mp->retain_hwhandler, RETAIN_HWHANDLER_OFF);
>  
> @@ -586,7 +586,7 @@ static void test_internal_nvme(const struct hwt_state *hwt)
>  	assert_ptr_not_equal(mp, NULL);
>  	TEST_PROP(checker_name(&pp->checker), NONE);
>  	TEST_PROP(pp->uid_attribute, "ID_WWN");
> -	assert_int_equal(mp->pgpolicy, MULTIBUS);
> +	assert_int_equal(mp->pgpolicy, GROUP_BY_PRIO);
>  	assert_int_equal(mp->no_path_retry, NO_PATH_RETRY_QUEUE);
>  	assert_int_equal(mp->retain_hwhandler, RETAIN_HWHANDLER_OFF);
>  }
> -- 
> 2.36.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

