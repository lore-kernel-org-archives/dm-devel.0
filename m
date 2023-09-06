Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8564EE14AA
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040212;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kqXPf7mVZCs/zKTgoe+oFPVxTHIrswu9z3JK4Jd54U4=;
	b=c5VcGWGTzrvZf6+FlbcT6oZv09w6XFsFxhUZVQfyT9qwCuzRVrVTRLs5owO99xHZKRzpKq
	kUIsEClAl3K4b1VKivPfHLqJmGQNaTv5np8ChBMHDEg5ROyF+G1004uW/ABo4Zkq+ZtWTY
	K5sLKMSZEDHepVenRhpYCJwcBfD2e2k=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-Sf4jmwmYOj619AWC5iuYlw-1; Wed, 06 Sep 2023 18:43:29 -0400
X-MC-Unique: Sf4jmwmYOj619AWC5iuYlw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 754A83C0D842;
	Wed,  6 Sep 2023 22:43:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 641C3200A4B6;
	Wed,  6 Sep 2023 22:43:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 22C6C194658D;
	Wed,  6 Sep 2023 22:43:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25661194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:43:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 13B6440411F; Wed,  6 Sep 2023 22:43:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB3DA404119;
 Wed,  6 Sep 2023 22:43:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386MhHLP028930;
 Wed, 6 Sep 2023 17:43:17 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386MhHAx028929;
 Wed, 6 Sep 2023 17:43:17 -0500
Date: Wed, 6 Sep 2023 17:43:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224317.GQ7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-7-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-7-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 06/21] multipath-tools test: simplify
 debugging for condlog mismatch
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:19PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If there's a mismatch between expected and actual log message,
> print both messages.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/test-log.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/test-log.c b/tests/test-log.c
> index c174587..6351699 100644
> --- a/tests/test-log.c
> +++ b/tests/test-log.c
> @@ -16,12 +16,14 @@ void __wrap_dlog (int prio, const char * fmt, ...)
>  	va_list ap;
>  	char *expected;
>  
> -	check_expected(prio);
>  	va_start(ap, fmt);
>  	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
>  	va_end(ap);
>  	fprintf(stderr, "%s(%d): %s", __func__, prio, buff);
>  	expected = mock_ptr_type(char *);
> +	if (memcmp(expected, buff, strlen(expected)))
> +		fprintf(stderr, "%s(expected): %s", __func__, expected);
> +	check_expected(prio);
>  	assert_memory_equal(buff, expected, strlen(expected));
>  }
>  
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

