Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C3DEE14AA
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694040545;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4Cle7uSDHdJEGwWjOfUK2xqgAkTJa2wkrC2CugdO+v4=;
	b=DXpQStmbm+CXzjcjgzqoTRaauuibi1ZkCQy29Q76D5fH9BdyjMc+ggjvFdDAcurALQbWit
	q9txhQEucPvVZmDLv1JKABwRWJ9QPJloxUMEjMhLE3HE/qhTb57zpFmvpQ23zgnVwAUaDe
	4igOckiJ5m2osyMsBIEgUMPm7vVNQvA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-UyTQeG3lPRuxARLoR3Hkmw-1; Wed, 06 Sep 2023 18:47:48 -0400
X-MC-Unique: UyTQeG3lPRuxARLoR3Hkmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5011489CB01;
	Wed,  6 Sep 2023 22:47:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3DED810EA0;
	Wed,  6 Sep 2023 22:47:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F35AE1946594;
	Wed,  6 Sep 2023 22:47:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E941194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 22:47:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F499C124A; Wed,  6 Sep 2023 22:47:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE6A363F6C;
 Wed,  6 Sep 2023 22:47:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 386MlZKC029024;
 Wed, 6 Sep 2023 17:47:35 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 386MlZYA029023;
 Wed, 6 Sep 2023 17:47:35 -0500
Date: Wed, 6 Sep 2023 17:47:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230906224735.GF7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-22-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230901180235.23980-22-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 21/21] libmultipath: adapt to new semantics
 of dm_get_uuid()
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

On Fri, Sep 01, 2023 at 08:02:34PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> dm_get_uuid() will return 1 for non-existing maps. Thus we don't need
> to call dm_map_present() any more in alias_already_taken(). This changes
> our semantics: previously we'd avoid using an alias for which dm_get_uuid()
> had failed. Now we treat failure in dm_get_uuid() as indication that the
> map doesn't exist. This is not dangerous because dm_task_get_uuid() cannot
> fail, and thus the modified dm_get_uuid() will fail if and only if
> dm_map_present() would return false.
> 
> This makes the "failed alias" test mostly obsolete, as "failed" is now
> treated as "unused".
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 23 ++++++++++++-----------
>  tests/alias.c        | 30 ++++++------------------------
>  2 files changed, 18 insertions(+), 35 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 6003df0..0f5af17 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -295,18 +295,19 @@ scan_devname(const char *alias, const char *prefix)
>  static bool alias_already_taken(const char *alias, const char *map_wwid)
>  {
>  
> -	if (dm_map_present(alias)) {
> -		char wwid[WWID_SIZE];
> +	char wwid[WWID_SIZE];
>  
> -		/* If both the name and the wwid match, then it's fine.*/
> -		if (dm_get_uuid(alias, wwid, sizeof(wwid)) == 0 &&
> -		    strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
> -			return false;
> -		condlog(3, "%s: alias '%s' already taken, reselecting alias",
> -			map_wwid, alias);
> -		return true;
> -	}
> -	return false;
> +	/* If the map doesn't exist, it's fine */
> +	if (dm_get_uuid(alias, wwid, sizeof(wwid)) != 0)
> +		return false;
> +
> +	/* If both the name and the wwid match, it's fine.*/
> +	if (strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
> +		return false;
> +
> +	condlog(3, "%s: alias '%s' already taken, reselecting alias",
> +		map_wwid, alias);
> +	return true;
>  }
>  
>  static bool id_already_taken(int id, const char *prefix, const char *map_wwid)
> diff --git a/tests/alias.c b/tests/alias.c
> index 4ac6425..4f54031 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -73,12 +73,6 @@ int __wrap_mkstemp(char *template)
>  	return 10;
>  }
>  
> -int __wrap_dm_map_present(const char * str)
> -{
> -	check_expected(str);
> -	return mock_type(int);
> -}
> -
>  int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
>  {
>  	int ret;
> @@ -398,14 +392,13 @@ static int test_scan_devname(void)
>  
>  static void mock_unused_alias(const char *alias)
>  {
> -	expect_string(__wrap_dm_map_present, str, alias);
> -	will_return(__wrap_dm_map_present, 0);
> +	expect_string(__wrap_dm_get_uuid, name, alias);
> +	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
> +	will_return(__wrap_dm_get_uuid, 1);
>  }
>  
>  static void mock_self_alias(const char *alias, const char *wwid)
>  {
> -	expect_string(__wrap_dm_map_present, str, alias);
> -	will_return(__wrap_dm_map_present, 1);
>  	expect_string(__wrap_dm_get_uuid, name, alias);
>  	expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);
>  	will_return(__wrap_dm_get_uuid, 0);
> @@ -432,18 +425,13 @@ static void mock_self_alias(const char *alias, const char *wwid)
>  
>  #define mock_failed_alias(alias, wwid)					\
>  	do {								\
> -		expect_string(__wrap_dm_map_present, str, alias);	\
> -		will_return(__wrap_dm_map_present, 1);			\
>  		expect_string(__wrap_dm_get_uuid, name, alias);		\
>  		expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);	\
>  		will_return(__wrap_dm_get_uuid, 1);			\
> -		expect_condlog(3, USED_STR(alias, wwid));		\
>  	} while (0)
>  
>  #define mock_used_alias(alias, wwid)					\
>  	do {								\
> -		expect_string(__wrap_dm_map_present, str, alias);	\
> -		will_return(__wrap_dm_map_present, 1);			\
>  		expect_string(__wrap_dm_get_uuid, name, alias);		\
>  		expect_value(__wrap_dm_get_uuid, uuid_len, WWID_SIZE);	\
>  		will_return(__wrap_dm_get_uuid, 0);			\
> @@ -566,9 +554,8 @@ static void lb_empty_failed(void **state)
>  	mock_bindings_file("");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_failed_alias("MPATHa", "WWID0");
> -	mock_unused_alias("MPATHb");
>  	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
> -	assert_int_equal(rc, 2);
> +	assert_int_equal(rc, 1);
>  	assert_ptr_equal(alias, NULL);
>  	free(alias);
>  }
> @@ -666,9 +653,8 @@ static void lb_nomatch_a_3_used_failed_self(void **state)
>  	mock_used_alias("MPATHc", "WWID1");
>  	mock_used_alias("MPATHd", "WWID1");
>  	mock_failed_alias("MPATHe", "WWID1");
> -	mock_self_alias("MPATHf", "WWID1");
>  	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
> -	assert_int_equal(rc, 6);
> +	assert_int_equal(rc, 5);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -949,11 +935,7 @@ static void lb_nomatch_b_a_aa_zz(void **state)
>  	 * lookup_binding finds MPATHaaa as next free entry, because MPATHaa is
>  	 * found before MPATHb, and MPATHzz was in the bindings, too.
>  	 */
> -	for (i = 0; i <= 26; i++) {
> -		print_strbuf(&buf,  "MPATH");
> -		format_devname(&buf, i + 1);
> -		print_strbuf(&buf,  " WWID%d\n", i);
> -	}
> +	fill_bindings(&buf, 0, 26);
>  	print_strbuf(&buf, "MPATHzz WWID676\n");
>  	mock_bindings_file(get_strbuf_str(&buf));
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID703"));
> -- 
> 2.41.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

