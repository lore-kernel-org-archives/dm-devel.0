Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0BDEE3F39
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 23:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694559706;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qS7b1v+tke8rx9eIqgrj1j5kyZJ8m+wECNGyDaUVNR4=;
	b=KY8EBXHGSQ3gJ7ei8xTOeRSur4ZxlbgSskHum5xJINKwuho667SrHuUb4+ZK3hJ7ZVivtO
	al6xiwUUfUPnj6+w4gT3BiPdEv4QbDJ2/erz6igvAGFh2rfJQNleh03lyYgcvKJ7TvmcYL
	zPiG0j3QqMhHDYMWh23N9Rtm6Uro2Wo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-9DPpOIcIOw6zyePfB8Hmvw-1; Tue, 12 Sep 2023 19:01:43 -0400
X-MC-Unique: 9DPpOIcIOw6zyePfB8Hmvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A9FE816526;
	Tue, 12 Sep 2023 23:01:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 06ABD2026D4B;
	Tue, 12 Sep 2023 23:01:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B776B19465A8;
	Tue, 12 Sep 2023 23:01:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9CB66194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 23:01:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7D66340C6EBF; Tue, 12 Sep 2023 23:01:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66F5640C6EA8;
 Tue, 12 Sep 2023 23:01:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38CN13CT031196;
 Tue, 12 Sep 2023 18:01:03 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38CN12NW031195;
 Tue, 12 Sep 2023 18:01:02 -0500
Date: Tue, 12 Sep 2023 18:01:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230912230102.GS7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-24-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-24-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 23/37] multipath-tools tests: fix alias
 test after sort order change
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:32PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/alias.c | 30 ++++++++++++------------------
>  1 file changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/tests/alias.c b/tests/alias.c
> index d1cc487..8ed95d7 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -932,16 +932,15 @@ static void lb_nomatch_b_a_aa_zz(void **state)
>  
>  	/*
>  	 * add_bindings() sorts alphabetically. ("a", "aa", "ab", "b", "c", ...)
> -	 * lookup_binding finds MPATHaaa as next free entry, because MPATHaa is
> -	 * found before MPATHb, and MPATHzz was in the bindings, too.
> +	 * lookup_binding finds MPATHab as next free entry.
>  	 */
>  	fill_bindings(&buf, 0, 26);
>  	print_strbuf(&buf, "MPATHzz WWID676\n");
>  	mock_bindings_file(get_strbuf_str(&buf));
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID703"));
> -	mock_unused_alias("MPATHaaa");
> +	mock_unused_alias("MPATHab");
>  	rc = lookup_binding(NULL, "WWID703", &alias, "MPATH", 1);
> -	assert_int_equal(rc, 703);
> +	assert_int_equal(rc, 28);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -998,13 +997,8 @@ static void lb_nomatch_b_a_3_used(void **state)
>  
>  #ifdef MPATH_ID_INT_MAX
>  /*
> - * The bindings will be sorted by alias, alphabetically, which is not
> - * the same as the "numeric" sort order for user-friendly aliases.
> - * get_free_id() selects the highest used ID + 1 if an unsorted entry
> - * is encountered in the bindings table and it's id is equal to the
> - * next "expected" id. This happens if all IDs from "a" to "aa" are
> - * in the table. If the INT_MAX entry is in the table, too, it will
> - * overflow.
> + * The bindings will be sorted by alias. Therefore we have no chance to
> + * simulate a "full" table.
>   */
>  static void lb_nomatch_int_max(void **state)
>  {
> @@ -1016,9 +1010,9 @@ static void lb_nomatch_int_max(void **state)
>  	print_strbuf(&buf, "MPATH%s WWIDMAX\n", MPATH_ID_INT_MAX);
>  	mock_bindings_file(get_strbuf_str(&buf));
>  	expect_condlog(3, NOMATCH_WWID_STR("WWIDNOMORE"));
> -	expect_condlog(0, NOMORE_STR);
> +	mock_unused_alias("MPATHab");
>  	rc = lookup_binding(NULL, "WWIDNOMORE", &alias, "MPATH", 1);
> -	assert_int_equal(rc, -1);
> +	assert_int_equal(rc, 28);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -1049,9 +1043,9 @@ static void lb_nomatch_int_max_m1(void **state)
>  	print_strbuf(&buf, "MPATH%s WWIDMAXM1\n", MPATH_ID_INT_MAX_m1);
>  	mock_bindings_file(get_strbuf_str(&buf));
>  	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
> -	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
> +	mock_unused_alias("MPATHab");
>  	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
> -	assert_int_equal(rc, INT_MAX);
> +	assert_int_equal(rc, 28);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -1065,10 +1059,10 @@ static void lb_nomatch_int_max_m1_used(void **state)
>  	print_strbuf(&buf, "MPATH%s WWIDMAXM1\n", MPATH_ID_INT_MAX_m1);
>  	mock_bindings_file(get_strbuf_str(&buf));
>  	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
> -	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWIDMAX");
> -	expect_condlog(0, NOMORE_STR);
> +	mock_used_alias("MPATHab", "WWIDMAX");
> +	mock_unused_alias("MPATHac");
>  	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
> -	assert_int_equal(rc, -1);
> +	assert_int_equal(rc, 29);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

