Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBE8EE14AA
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040259;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ku/Ea5SCJdeV9qQxzQ5tQjTHPIyEcXsvcCRMYisJjUo=;
	b=WSNie6YdjoQv92+uz/tdwpENzk7YccVCnrkjb+8VjIemPazpCkuMyrhWaC7X1C5TDvH6Ax
	jQae8y/0tTgYUryw+In6JtvAPIlKbwgr54fajnZiZmjWzw2cIvci481kWYiZB9LAMheUNi
	Lr3D+jalz48HRzhz6GUEkW6JNfw5qWo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-CYsnsyLrN--cqmTsYIHuFg-1; Wed, 06 Sep 2023 18:44:16 -0400
X-MC-Unique: CYsnsyLrN--cqmTsYIHuFg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7983D1C05AE9;
	Wed,  6 Sep 2023 22:44:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 670C9C124A;
	Wed,  6 Sep 2023 22:44:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3714C19465B5;
	Wed,  6 Sep 2023 22:44:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E590B19465BC
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:44:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D09A810EA0; Wed,  6 Sep 2023 22:44:03 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A68431182ED;
 Wed,  6 Sep 2023 22:44:03 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386MhtVc028948;
 Wed, 6 Sep 2023 17:43:55 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386Mht6b028947;
 Wed, 6 Sep 2023 17:43:55 -0500
Date: Wed, 6 Sep 2023 17:43:54 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224354.GT7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-11-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-11-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 10/21] multipath-tools test: use
 mock_bindings_file() consistently
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 01, 2023 at 08:02:23PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Further improve test readablity.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/alias.c | 186 ++++++++++++++++++++++----------------------------
>  1 file changed, 80 insertions(+), 106 deletions(-)
> 
> diff --git a/tests/alias.c b/tests/alias.c
> index cb6695b..a1415c6 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -489,7 +489,7 @@ static void lb_empty(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	rc = lookup_binding(NULL, "WWID0", &alias, NULL, 0);
>  	assert_int_equal(rc, 1);
> @@ -501,7 +501,7 @@ static void lb_empty_unused(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
> @@ -515,7 +515,7 @@ static void lb_empty_failed(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	mock_failed_alias("MPATHa", "WWID0");
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> @@ -530,7 +530,7 @@ static void lb_empty_1_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	mock_used_alias("MPATHa", "WWID0");
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> @@ -545,7 +545,7 @@ static void lb_empty_1_used_self(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	mock_used_alias("MPATHa", "WWID0");
>  	mock_self_alias("MPATHb", "WWID0");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> @@ -560,7 +560,7 @@ static void lb_match_a(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> +	mock_bindings_file("MPATHa WWID0\n", 0);
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 0);
>  	assert_int_equal(rc, 0);
> @@ -574,8 +574,7 @@ static void lb_nomatch_a(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
>  	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 0);
>  	assert_int_equal(rc, 2);
> @@ -587,8 +586,7 @@ static void lb_nomatch_a_bad_check(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n", -1);
>  	expect_condlog(0, NOMORE_STR);
>  	rc = lookup_binding(NULL, "WWID1", &alias, NULL, 1);
>  	assert_int_equal(rc, -1);
> @@ -600,8 +598,7 @@ static void lb_nomatch_a_unused(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n", -1);
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
>  	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
> @@ -614,8 +611,7 @@ static void lb_nomatch_a_3_used_failed_self(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n", -1);
>  	mock_used_alias("MPATHb", "WWID1");
>  	mock_used_alias("MPATHc", "WWID1");
>  	mock_used_alias("MPATHd", "WWID1");
> @@ -632,8 +628,8 @@ static void do_lb_match_c(void **state, int check_if_taken)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHc WWID1\n");
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHc WWID1", 1);
>  	expect_condlog(3, FOUND_STR("MPATHc", "WWID1"));
>  	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", check_if_taken);
>  	assert_int_equal(rc, 0);
> @@ -657,9 +653,8 @@ static void lb_nomatch_a_c(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHc WWID1\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHc WWID1", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
>  	assert_int_equal(rc, 2);
> @@ -671,9 +666,8 @@ static void lb_nomatch_a_d_unused(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHd WWID1\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHd WWID1", -1);
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> @@ -686,9 +680,8 @@ static void lb_nomatch_a_d_1_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHd WWID1\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHd WWID1", -1);
>  	mock_used_alias("MPATHb", "WWID2");
>  	mock_unused_alias("MPATHc");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> @@ -702,9 +695,8 @@ static void lb_nomatch_a_d_2_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHd WWID1\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHd WWID1", -1);
>  	mock_used_alias("MPATHb", "WWID2");
>  	mock_used_alias("MPATHc", "WWID2");
>  	mock_unused_alias("MPATHe");
> @@ -719,9 +711,8 @@ static void lb_nomatch_a_d_3_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHd WWID1\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHd WWID1", -1);
>  	mock_used_alias("MPATHb", "WWID2");
>  	mock_used_alias("MPATHc", "WWID2");
>  	mock_used_alias("MPATHe", "WWID2");
> @@ -737,9 +728,8 @@ static void lb_nomatch_c_a(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHc WWID1\n");
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHc WWID1\n"
> +			   "MPATHa WWID0\n", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
>  	assert_int_equal(rc, 2);
> @@ -751,10 +741,9 @@ static void lb_nomatch_d_a_unused(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHc WWID1\n");
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHd WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHc WWID1\n"
> +			   "MPATHa WWID0\n"
> +			   "MPATHd WWID0\n", -1);
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> @@ -767,10 +756,9 @@ static void lb_nomatch_d_a_1_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHc WWID1\n");
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHd WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHc WWID1\n"
> +			   "MPATHa WWID0\n"
> +			   "MPATHd WWID0\n", -1);
>  	mock_used_alias("MPATHb", "WWID2");
>  	mock_unused_alias("MPATHe");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> @@ -784,10 +772,9 @@ static void lb_nomatch_a_b(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHz WWID26\n");
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHz WWID26\n"
> +			   "MPATHb WWID1\n", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
>  	assert_int_equal(rc, 3);
> @@ -799,10 +786,9 @@ static void lb_nomatch_a_b_bad(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHz WWID26\n");
> -	will_return(__wrap_fgets, "MPATHb\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHz WWID26\n"
> +			   "MPATHb\n", -1);
>  	expect_condlog(3, "Ignoring malformed line 3 in bindings file\n");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
> @@ -815,10 +801,9 @@ static void lb_nomatch_a_b_bad_self(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHz WWID26\n");
> -	will_return(__wrap_fgets, "MPATHb\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHz WWID26\n"
> +			   "MPATHb\n", -1);
>  	expect_condlog(3, "Ignoring malformed line 3 in bindings file\n");
>  	mock_self_alias("MPATHc", "WWID2");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> @@ -832,10 +817,9 @@ static void lb_nomatch_b_a(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, "MPATHz WWID26\n");
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATHz WWID26\n"
> +			   "MPATHa WWID0\n", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
>  	assert_int_equal(rc, 27);
> @@ -847,10 +831,9 @@ static void lb_nomatch_b_a_3_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, "MPATHz WWID26\n");
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATHz WWID26\n"
> +			   "MPATHa WWID0\n", -1);
>  	mock_used_alias("MPATHaa", "WWID2");
>  	mock_used_alias("MPATHab", "WWID2");
>  	mock_used_alias("MPATHac", "WWID2");
> @@ -867,10 +850,9 @@ static void do_lb_nomatch_int_max(void **state, int check_if_taken)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n");
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n"
> +			   "MPATHa WWID0\n", -1);
>  	expect_condlog(0, NOMORE_STR);
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", check_if_taken);
>  	assert_int_equal(rc, -1);
> @@ -892,9 +874,8 @@ static void lb_nomatch_int_max_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n", -1);
>  	mock_used_alias("MPATHa", "WWID2");
>  	expect_condlog(0, NOMORE_STR);
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> @@ -907,10 +888,9 @@ static void lb_nomatch_int_max_m1(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n"
> +			   "MPATHa WWID0\n", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
>  	assert_int_equal(rc, INT_MAX);
> @@ -922,10 +902,9 @@ static void lb_nomatch_int_max_m1_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n"
> +			   "MPATHa WWID0\n", -1);
>  	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWID2");
>  	expect_condlog(0, NOMORE_STR);
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> @@ -938,9 +917,8 @@ static void lb_nomatch_int_max_m1_1_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n", -1);
>  	mock_used_alias("MPATHa", "WWID2");
>  	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> @@ -954,9 +932,8 @@ static void lb_nomatch_int_max_m1_2_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	will_return(__wrap_fgets, "MPATHb WWID1\n");
> -	will_return(__wrap_fgets, "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n", -1);
>  	mock_used_alias("MPATHa", "WWID2");
>  	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWID2");
>  	expect_condlog(0, NOMORE_STR);
> @@ -1014,7 +991,7 @@ static void rl_empty(void **state)
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_STR("MPATHa"));
>  	rc = rlookup_binding(NULL, buf, "MPATHa");
>  	assert_int_equal(rc, -1);
> @@ -1027,7 +1004,7 @@ static void rl_match_a(void **state)
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> +	mock_bindings_file("MPATHa WWID0\n", 0);
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHa", "WWID0"));
>  	rc = rlookup_binding(NULL, buf, "MPATHa");
>  	assert_int_equal(rc, 0);
> @@ -1040,8 +1017,7 @@ static void rl_nomatch_a(void **state)
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa WWID0\n", -1);
>  	expect_condlog(3, NOMATCH_STR("MPATHb"));
>  	rc = rlookup_binding(NULL, buf, "MPATHb");
>  	assert_int_equal(rc, -1);
> @@ -1054,8 +1030,7 @@ static void rl_malformed_a(void **state)
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	will_return(__wrap_fgets, "MPATHa     \n");
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("MPATHa     \n", -1);
>  	expect_condlog(3, "Ignoring malformed line 1 in bindings file\n");
>  	expect_condlog(3, NOMATCH_STR("MPATHa"));
>  	rc = rlookup_binding(NULL, buf, "MPATHa");
> @@ -1074,8 +1049,7 @@ static void rl_overlong_a(void **state)
>  	snprintf(line + sizeof(line) - 2, 2, "\n");
>  
>  	buf[0] = '\0';
> -	will_return(__wrap_fgets, line);
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file(line, -1);
>  	expect_condlog(3, "Ignoring too large wwid at 1 in bindings file\n");
>  	expect_condlog(3, NOMATCH_STR("MPATHa"));
>  	rc = rlookup_binding(NULL, buf, "MPATHa");
> @@ -1089,9 +1063,9 @@ static void rl_match_b(void **state)
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	will_return(__wrap_fgets, "MPATHa WWID0\n");
> -	will_return(__wrap_fgets, "MPATHz WWID26\n");
> -	will_return(__wrap_fgets, "MPATHb WWID2\n");
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHz WWID26\n"
> +			   "MPATHb WWID2\n", 2);
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHb", "WWID2"));
>  	rc = rlookup_binding(NULL, buf, "MPATHb");
>  	assert_int_equal(rc, 0);
> @@ -1222,7 +1196,7 @@ static void gufa_empty_new_rw(void **state) {
>  
>  	will_return(__wrap_open_file, true);
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  
> @@ -1235,7 +1209,7 @@ static void gufa_empty_new_rw(void **state) {
>  static void gufa_empty_new_ro_1(void **state) {
>  	char *alias;
>  	will_return(__wrap_open_file, false);
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  
> @@ -1248,7 +1222,7 @@ static void gufa_empty_new_ro_2(void **state) {
>  
>  	will_return(__wrap_open_file, true);
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  
> @@ -1261,7 +1235,7 @@ static void gufa_match_a_unused(void **state) {
>  
>  	will_return(__wrap_open_file, true);
>  
> -	will_return(__wrap_fgets, BINDING_STR("MPATHa", "WWID0"));
> +	mock_bindings_file("MPATHa WWID0", 0);
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_unused_alias("MPATHa");
>  
> @@ -1275,7 +1249,7 @@ static void gufa_match_a_self(void **state) {
>  
>  	will_return(__wrap_open_file, true);
>  
> -	will_return(__wrap_fgets, BINDING_STR("MPATHa", "WWID0"));
> +	mock_bindings_file("MPATHa WWID0", 0);
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_self_alias("MPATHa", "WWID0");
>  
> @@ -1289,7 +1263,7 @@ static void gufa_match_a_used(void **state) {
>  
>  	will_return(__wrap_open_file, true);
>  
> -	will_return(__wrap_fgets, BINDING_STR("MPATHa", "WWID0"));
> +	mock_bindings_file("MPATHa WWID0", 0);
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_used_alias("MPATHa", "WWID0");
>  
> @@ -1389,11 +1363,11 @@ static void gufa_old_empty(void **state) {
>  	will_return(__wrap_open_file, true);
>  
>  	/* rlookup_binding for ALIAS */
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_STR("MPATHz"));
>  
>  	/* lookup_binding */
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  
>  	mock_unused_alias("MPATHz");
> @@ -1410,10 +1384,10 @@ static void gufa_old_empty_self(void **state) {
>  	char *alias;
>  	will_return(__wrap_open_file, true);
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_STR("MPATHz"));
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_self_alias("MPATHz", "WWID0");
>  
> @@ -1429,10 +1403,10 @@ static void gufa_old_empty_used(void **state) {
>  	char *alias;
>  	will_return(__wrap_open_file, true);
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_STR("MPATHz"));
>  
> -	will_return(__wrap_fgets, NULL);
> +	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_used_alias("MPATHz", "WWID0");
>  	expect_condlog(0, ERR_STR("MPATHz", "WWID0"));
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

