Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCB5EE020F
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 22:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694643519;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q99PCpi3nDseCIhsTVVHh7xPz3je2+KGxqgWo3xPKZ8=;
	b=gd2gYrTWykdR0ZDdHjYOC+gGWIDumRpiIgZWONSt6Kap0CQl0+yeD158P1937mpTkyWiqK
	kOFFDPyjZHNpBkhtWDPQ4AzgFcLQ1D3U7Nf9FE111kAWgqF1HpJ0MjN4QBj3WBFsZIJXV4
	ytA5v2cnCiUgbe9qhRuHP4gvS2JZWyQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-5qVbuHclOJavaI9oZ5x-lw-1; Wed, 13 Sep 2023 18:18:36 -0400
X-MC-Unique: 5qVbuHclOJavaI9oZ5x-lw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2820B81D7C2;
	Wed, 13 Sep 2023 22:18:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A905100880F;
	Wed, 13 Sep 2023 22:18:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2266019465B5;
	Wed, 13 Sep 2023 22:18:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A5D119465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 22:18:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FE3E10F1BE8; Wed, 13 Sep 2023 22:18:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ECA1210F1BE7;
 Wed, 13 Sep 2023 22:18:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DMIHl8004469;
 Wed, 13 Sep 2023 17:18:17 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DMIHSY004468;
 Wed, 13 Sep 2023 17:18:17 -0500
Date: Wed, 13 Sep 2023 17:18:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230913221816.GY7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-29-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-29-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 28/37] multipath-tools tests: mock
 pthread_mutex_{lock, unlock}
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:37PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If some test fails with a lock held, cmocka doesn't deal well with
> pthread_cleanup_pop(). Such tests can cause deadlock with the locking
> primitives in the alias code, because locks don't get properly unlocked.  Just
> mock the lock/unlock functions and generate an error if they weren't paired at
> the end of the test.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/Makefile |  1 +
>  tests/alias.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/tests/Makefile b/tests/Makefile
> index c777d07..7dac8a8 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -52,6 +52,7 @@ blacklist-test_LIBDEPS := -ludev
>  vpd-test_OBJDEPS :=  $(multipathdir)/discovery.o
>  vpd-test_LIBDEPS := -ludev -lpthread -ldl
>  alias-test_TESTDEPS := test-log.o
> +alias-test_OBJDEPS := $(mpathutildir)/util.o
>  alias-test_LIBDEPS := -lpthread -ldl
>  valid-test_OBJDEPS := $(multipathdir)/valid.o $(multipathdir)/discovery.o
>  valid-test_LIBDEPS := -lmount -ludev -lpthread -ldl
> diff --git a/tests/alias.c b/tests/alias.c
> index 872b1fc..962c158 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -89,6 +89,47 @@ int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
>  	return ret;
>  }
>  
> +static int lock_errors;
> +static int bindings_locked;
> +static int timestamp_locked;
> +int __wrap_pthread_mutex_lock(pthread_mutex_t *mutex)
> +{
> +	if (mutex == &bindings_mutex) {
> +		if (bindings_locked) {
> +			fprintf(stderr, "%s: bindings_mutex LOCKED\n", __func__);
> +			lock_errors++;
> +		}
> +		bindings_locked = 1;
> +	}  else if (mutex == &timestamp_mutex) {
> +		if (timestamp_locked) {
> +			fprintf(stderr, "%s: timestamp_mutex LOCKED\n", __func__);
> +			lock_errors++;
> +		}
> +		timestamp_locked = 1;
> +	} else
> +		  fprintf(stderr, "%s called for unknown mutex %p\n", __func__, mutex);
> +	return 0;
> +}
> +
> +int __wrap_pthread_mutex_unlock(pthread_mutex_t *mutex)
> +{
> +	if (mutex == &bindings_mutex) {
> +		if (!bindings_locked) {
> +			fprintf(stderr, "%s: bindings_mutex UNLOCKED\n", __func__);
> +			lock_errors++;
> +		}
> +		bindings_locked = 0;
> +	}  else if (mutex == &timestamp_mutex) {
> +		if (!timestamp_locked) {
> +			fprintf(stderr, "%s: timestamp_mutex UNLOCKED\n", __func__);
> +			lock_errors++;
> +		}
> +		timestamp_locked = 0;
> +	} else
> +		  fprintf(stderr, "%s called for unknown mutex %p\n", __func__, mutex);
> +	return 0;
> +}
> +
>  #define TEST_FDNO 1234
>  #define TEST_FPTR ((FILE *) 0xaffe)
>  
> @@ -1718,6 +1759,10 @@ static void gufa_old_nomatch_nowwidmatch(void **state) {
>  	free(alias);
>  }
>  
> +static void gufa_check_locking(void **state) {
> +	assert_int_equal(lock_errors, 0);
> +}
> +
>  static int test_get_user_friendly_alias()
>  {
>  	const struct CMUnitTest tests[] = {
> @@ -1743,6 +1788,7 @@ static int test_get_user_friendly_alias()
>  		cmocka_unit_test_teardown(gufa_old_nomatch_wwidmatch, teardown_bindings),
>  		cmocka_unit_test_teardown(gufa_old_nomatch_wwidmatch_used, teardown_bindings),
>  		cmocka_unit_test_teardown(gufa_old_nomatch_nowwidmatch, teardown_bindings),
> +		cmocka_unit_test(gufa_check_locking),
>  	};
>  
>  	return cmocka_run_group_tests(tests, NULL, NULL);
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

