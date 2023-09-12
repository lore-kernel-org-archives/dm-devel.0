Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 603C8EE3F39
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 22:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694556219;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lg1JGIA/rJTOCfoPz8fvcRvXBPY/yClzCzBxnc4uMOY=;
	b=JT3TWKX7VUipjwqVnnh1aTIqn72hlysmemt2OIEeY0flNDlSDz9PxDLoO5RJwyJ4jhtLGZ
	6gqFeWobd4PzHbA8KJb3Bm4IebEIfqX9omOCXRtySYVKHT/iIi2XTeDkdVqkRKLJWy2bRA
	/n9xO2561or97z6hSq97HrrpiHgjzqI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-J85GsS4PNueV6FoNblOJhw-1; Tue, 12 Sep 2023 18:03:36 -0400
X-MC-Unique: J85GsS4PNueV6FoNblOJhw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6DEA3C14AA2;
	Tue, 12 Sep 2023 22:03:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BFB340C6EA8;
	Tue, 12 Sep 2023 22:03:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 213E419465A8;
	Tue, 12 Sep 2023 22:03:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BBB40194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 22:02:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C1B12024CD5; Tue, 12 Sep 2023 22:02:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 585B320268C8;
 Tue, 12 Sep 2023 22:02:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38CM2lVg030973;
 Tue, 12 Sep 2023 17:02:47 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38CM2l7j030972;
 Tue, 12 Sep 2023 17:02:47 -0500
Date: Tue, 12 Sep 2023 17:02:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230912220246.GL7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-20-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-20-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v2 19/37] multipath-tools tests: fix alias
 tests
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:28PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The different implementation of get_user_friendly_alias() and its helpers
> necessitates changes in the unit tests. It would be nice if it didn't, but the
> unit tests are too closely bound to the implementation to make this possible.
> 
> - The bindings table is held in memory in alphabetically sorted order, which
>   may change the result of looking for free alias IDs if the entries in the
>   bindings file were unordered initially. In particular, if only a small
>   number of bindings exists, "holes" in the file will be detected more easily.
>   But because the sort order of the aliases differs from simple alphabetic
>   sorting ("mpathz" precedes "mpathaa"), a bindings file that contains all
>   bindings from "a" to "aa" (or more) will appear unsorted.
>   As an extra check, some of the unit tests deliberately use a different
>   implementation of add_binding() that does not order the bindings
>   table.
> 
> - Broken lines in the bindings file never make it to the in-memory
>   representation. An alias that appeard "used" because it occurred in a broken
>   line will not appear used any more. Warnings about malformed lines will only
>   be printed while the bindings file is read, not from get_user_friendly_alias().
> 
> - The match_line argument of mock_bindings_file() is obsolete.
> 
> - lookup_binding() and rlookup_binding() have been removed from
>   libmultipath. They are now emulated in the unit test code.
> 
> - lookup_binding() didn't check for used alias in all cases previously, but it does now.
> 
> - prefix != NULL and check_if_taken == false is not supported any more
>   in lookup_binding().
> 
> - allocate_binding() uses a very different sequence of systems calls now, as
>   it's implemented using update_bindings_file(). In particular, it's now more
>   difficult to predict the content of the write() call that creates the
>   bindings file. See comments for __wrap_write().
> 
> - some unit tests for get_user_friendly_alias() had to call
>   mock_bindings_file() twice, because the old implementation would read the
>   file twice (first rlookup_binding() and then lookup_binding()). This is not
>   necessary any more.
> 
> - The unit tests need a teardown function to clear the bindings table in memory.
> 
> - Minor changes are necessary because of changed ordering of the log messages.
>   Previously, lookup_binding() combined check for an existing entry and the
>   search for a new ID. The new algorithm does this in two separate steps and
>   tests for used aliases in between, which causes a change in the order in which
>   log messages are emitted.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/alias.c | 971 ++++++++++++++++++++++++++++++++------------------
>  1 file changed, 621 insertions(+), 350 deletions(-)
> 
> diff --git a/tests/alias.c b/tests/alias.c
> index f334f92..50a21ec 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -3,10 +3,12 @@
>  #include <setjmp.h>
>  #include <stdio.h>
>  #include <cmocka.h>
> +#include "strbuf.h"
>  #include "util.h"
>  #include "alias.h"
>  #include "test-log.h"
>  #include <errno.h>
> +#include <string.h>
>  
>  #include "globals.c"
>  #include "../libmultipath/alias.c"
> @@ -20,18 +22,6 @@
>  #define MPATH_ID_INT_MAX_p1 "fxshrxx"
>  #endif
>  
> -void __wrap_rewind(FILE *stream)
> -{}
> -
> -char *__wrap_fgets(char *buf, int n, FILE *stream)
> -{
> -	char *val = mock_ptr_type(char *);
> -	if (!val)
> -		return NULL;
> -	strlcpy(buf, val, n);
> -	return buf;
> -}
> -
>  static int __set_errno(int err)
>  {
>  	if (err >= 0) {
> @@ -43,25 +33,46 @@ static int __set_errno(int err)
>  	}
>  }
>  
> -off_t __wrap_lseek(int fd, off_t offset, int whence)
> -{
> -	return __set_errno(mock_type(int));
> -
> -}
> -
> +/*
> + * allocate_binding -> write_bindings_file() writes the entire file, i.e. the
> + * header, any pre-existing bindings, and the new binding. The complete content
> + * depends on history and is different to predict here. Therefore we check only
> + * the newly added binding. Because add_binding() sorts entries, this new
> + * binding isn't necessarily the last one; receive it from will_return() and
> + * search for it with strstr().
> + * If the string to be written doesn't start with the bindings file
> + * header, it's a test of a partial write.
> + */
>  ssize_t __wrap_write(int fd, const void *buf, size_t count)
>  {
> +	const char *binding, *start;
> +
> +#if DEBUG_WRITE
> +	fprintf(stderr, "%s: %zx exp %zx\n===\n%s\n===\n", __func__, strlen(buf),
> +		count, (const char *)buf);
> +#endif
> +	if (!strncmp((const char *)buf, BINDINGS_FILE_HEADER,
> +		     sizeof(BINDINGS_FILE_HEADER) - 1))
> +		start = (const char *)buf + sizeof(BINDINGS_FILE_HEADER) - 1;
> +	else
> +		start = buf;
> +	binding = mock_ptr_type(char *);
> +	start = strstr(start, binding);
>  	check_expected(count);
> -	check_expected(buf);
> +	assert_ptr_not_equal(start, NULL);
>  	return __set_errno(mock_type(int));
>  }
>  
> -int __wrap_ftruncate(int fd, off_t length)
> +int __wrap_rename(const char *old, const char *new)
>  {
> -	check_expected(length);
>  	return __set_errno(mock_type(int));
>  }
>  
> +int __wrap_mkstemp(char *template)
> +{
> +	return 10;
> +}
> +
>  int __wrap_dm_map_present(const char * str)
>  {
>  	check_expected(str);
> @@ -84,32 +95,6 @@ int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
>  #define TEST_FDNO 1234
>  #define TEST_FPTR ((FILE *) 0xaffe)
>  
> -int __wrap_open_file(const char *file, int *can_write, const char *header)
> -{
> -	int cw = mock_type(int);
> -
> -        *can_write = cw;
> -	return TEST_FDNO;
> -}
> -
> -FILE *__wrap_fdopen(int fd, const char *mode)
> -{
> -	assert_int_equal(fd, TEST_FDNO);
> -	return TEST_FPTR;
> -}
> -
> -int __wrap_fflush(FILE *f)
> -{
> -	assert_ptr_equal(f, TEST_FPTR);
> -	return 0;
> -}
> -
> -int __wrap_fclose(FILE *f)
> -{
> -	assert_ptr_equal(f, TEST_FPTR);
> -	return 0;
> -}
> -
>  /* strbuf wrapper for the old format_devname() */
>  static int __format_devname(char *name, int id, size_t len, const char *prefix)
>  {
> @@ -466,22 +451,85 @@ static void mock_self_alias(const char *alias, const char *wwid)
>  		expect_condlog(3, USED_STR(alias, wwid));		\
>  	} while(0)
>  
> -static void mock_bindings_file(const char *content, int match_line)
> +static int add_binding_unsorted(Bindings *bindings,
> +				const char *alias, const char *wwid)
>  {
> -	static char cnt[1024];
> -	char *token;
> +	struct binding *bdg = calloc(1, sizeof(*bdg));
> +
> +	if (!bdg)
> +		return -1;
> +	bdg->wwid = strdup(wwid);
> +	bdg->alias = strdup(alias);
> +	if (!bdg->wwid || !bdg->alias || !vector_alloc_slot(bindings)) {
> +		free(bdg->alias);
> +		free(bdg->wwid);
> +		free(bdg);
> +		return BINDING_ERROR;
> +	}
> +	vector_set_slot(bindings, bdg);
> +	return BINDING_ADDED;
> +}
> +
> +static void __mock_bindings_file(const char *content,
> +				 int (*add)(Bindings *, const char *, const char *))
> +{
> +	char *cnt __attribute__((cleanup(cleanup_charp))) = NULL;
> +	char *token, *savep = NULL;
>  	int i;
>  
> -	assert_in_range(strlcpy(cnt, content, sizeof(cnt)), 0, sizeof(cnt) - 1);
> +	cnt = strdup(content);
> +	assert_ptr_not_equal(cnt, NULL);
>  
> -	for (token = strtok(cnt, "\n"), i = 0;
> +	for (token = strtok_r(cnt, "\n", &savep), i = 0;
>  	     token && *token;
> -	     token = strtok(NULL, "\n"), i++) {
> -		will_return(__wrap_fgets, token);
> -		if (match_line == i)
> -			return;
> +	     token = strtok_r(NULL, "\n", &savep), i++) {
> +		char *alias, *wwid;
> +		int rc;
> +
> +		if (read_binding(token, i + 1, &alias, &wwid)
> +		    == READ_BINDING_SKIP)
> +			continue;
> +
> +		rc = add(&global_bindings, alias, wwid);
> +		assert_int_equal(rc, BINDING_ADDED);
>  	}
> -	will_return(__wrap_fgets, NULL);
> +}
> +
> +static void mock_bindings_file(const char *content) {
> +	return __mock_bindings_file(content, add_binding);
> +}
> +
> +static void mock_bindings_file_unsorted(const char *content) {
> +	return __mock_bindings_file(content, add_binding_unsorted);
> +}
> +
> +static int teardown_bindings(void **state)
> +{
> +	cleanup_bindings();
> +	return 0;
> +}
> +
> +static int lookup_binding(FILE *dummy, const char *wwid, char **alias,
> +			  const char *prefix, int check_if_taken)
> +{
> +	const struct binding *bdg;
> +	int id;
> +
> +	/*
> +	 * get_free_id() always checks if aliases are taken.
> +	 * Therefore if prefix is non-null, check_if_taken must be true.
> +	 */
> +	assert_true(!prefix || check_if_taken);
> +	*alias = NULL;
> +	bdg = get_binding_for_wwid(&global_bindings, wwid);
> +	if (bdg) {
> +		*alias = strdup(bdg->alias);
> +		return 0;
> +	} else if (!prefix && check_if_taken)
> +		return -1;
> +
> +	id = get_free_id(&global_bindings, prefix, wwid);
> +	return id;
>  }
>  
>  static void lb_empty(void **state)
> @@ -489,7 +537,7 @@ static void lb_empty(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("", -1);
> +	mock_bindings_file("");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	rc = lookup_binding(NULL, "WWID0", &alias, NULL, 0);
>  	assert_int_equal(rc, 1);
> @@ -501,7 +549,7 @@ static void lb_empty_unused(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("", -1);
> +	mock_bindings_file("");
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
> @@ -515,10 +563,10 @@ static void lb_empty_failed(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("", -1);
> +	mock_bindings_file("");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_failed_alias("MPATHa", "WWID0");
>  	mock_unused_alias("MPATHb");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 2);
>  	assert_ptr_equal(alias, NULL);
> @@ -530,10 +578,10 @@ static void lb_empty_1_used(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("", -1);
> +	mock_bindings_file("");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_used_alias("MPATHa", "WWID0");
>  	mock_unused_alias("MPATHb");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 2);
>  	assert_ptr_equal(alias, NULL);
> @@ -545,10 +593,10 @@ static void lb_empty_1_used_self(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("", -1);
> +	mock_bindings_file("");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_used_alias("MPATHa", "WWID0");
>  	mock_self_alias("MPATHb", "WWID0");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 2);
>  	assert_ptr_equal(alias, NULL);
> @@ -560,9 +608,9 @@ static void lb_match_a(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("MPATHa WWID0\n", 0);
> +	mock_bindings_file("MPATHa WWID0\n");
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> -	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 0);
> +	rc = lookup_binding(NULL, "WWID0", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 0);
>  	assert_ptr_not_equal(alias, NULL);
>  	assert_string_equal(alias, "MPATHa");
> @@ -574,9 +622,10 @@ static void lb_nomatch_a(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("MPATHa WWID0\n", -1);
> +	mock_bindings_file("MPATHa WWID0\n");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
> -	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 0);
> +	mock_unused_alias("MPATHb");
> +	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 2);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -586,8 +635,8 @@ static void lb_nomatch_a_bad_check(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("MPATHa WWID0\n", -1);
> -	expect_condlog(0, NOMORE_STR);
> +	mock_bindings_file("MPATHa WWID0\n");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
>  	rc = lookup_binding(NULL, "WWID1", &alias, NULL, 1);
>  	assert_int_equal(rc, -1);
>  	assert_ptr_equal(alias, NULL);
> @@ -598,7 +647,7 @@ static void lb_nomatch_a_unused(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("MPATHa WWID0\n", -1);
> +	mock_bindings_file("MPATHa WWID0\n");
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
>  	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
> @@ -611,27 +660,27 @@ static void lb_nomatch_a_3_used_failed_self(void **state)
>  	int rc;
>  	char *alias;
>  
> -	mock_bindings_file("MPATHa WWID0\n", -1);
> +	mock_bindings_file("MPATHa WWID0\n");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
>  	mock_used_alias("MPATHb", "WWID1");
>  	mock_used_alias("MPATHc", "WWID1");
>  	mock_used_alias("MPATHd", "WWID1");
>  	mock_failed_alias("MPATHe", "WWID1");
>  	mock_self_alias("MPATHf", "WWID1");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
>  	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 6);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> -static void do_lb_match_c(void **state, int check_if_taken)
> +static void do_lb_match_c(void **state)
>  {
>  	int rc;
>  	char *alias;
>  
>  	mock_bindings_file("MPATHa WWID0\n"
> -			   "MPATHc WWID1", 1);
> +			   "MPATHc WWID1");
>  	expect_condlog(3, FOUND_STR("MPATHc", "WWID1"));
> -	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", check_if_taken);
> +	rc = lookup_binding(NULL, "WWID1", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 0);
>  	assert_ptr_not_equal(alias, NULL);
>  	assert_string_equal(alias, "MPATHc");
> @@ -640,12 +689,12 @@ static void do_lb_match_c(void **state, int check_if_taken)
>  
>  static void lb_match_c(void **state)
>  {
> -	do_lb_match_c(state, 0);
> +	do_lb_match_c(state);
>  }
>  
>  static void lb_match_c_check(void **state)
>  {
> -	do_lb_match_c(state, 1);
> +	do_lb_match_c(state);
>  }
>  
>  static void lb_nomatch_a_c(void **state)
> @@ -654,9 +703,10 @@ static void lb_nomatch_a_c(void **state)
>  	char *alias;
>  
>  	mock_bindings_file("MPATHa WWID0\n"
> -			   "MPATHc WWID1", -1);
> +			   "MPATHc WWID1");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
> +	mock_unused_alias("MPATHb");
> +	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 2);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -667,7 +717,7 @@ static void lb_nomatch_a_d_unused(void **state)
>  	char *alias;
>  
>  	mock_bindings_file("MPATHa WWID0\n"
> -			   "MPATHd WWID1", -1);
> +			   "MPATHd WWID1");
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> @@ -681,10 +731,10 @@ static void lb_nomatch_a_d_1_used(void **state)
>  	char *alias;
>  
>  	mock_bindings_file("MPATHa WWID0\n"
> -			   "MPATHd WWID1", -1);
> +			   "MPATHd WWID1");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	mock_used_alias("MPATHb", "WWID2");
>  	mock_unused_alias("MPATHc");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 3);
>  	assert_ptr_equal(alias, NULL);
> @@ -696,11 +746,11 @@ static void lb_nomatch_a_d_2_used(void **state)
>  	char *alias;
>  
>  	mock_bindings_file("MPATHa WWID0\n"
> -			   "MPATHd WWID1", -1);
> +			   "MPATHd WWID1");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	mock_used_alias("MPATHb", "WWID2");
>  	mock_used_alias("MPATHc", "WWID2");
>  	mock_unused_alias("MPATHe");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 5);
>  	assert_ptr_equal(alias, NULL);
> @@ -712,12 +762,12 @@ static void lb_nomatch_a_d_3_used(void **state)
>  	char *alias;
>  
>  	mock_bindings_file("MPATHa WWID0\n"
> -			   "MPATHd WWID1", -1);
> +			   "MPATHd WWID1");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	mock_used_alias("MPATHb", "WWID2");
>  	mock_used_alias("MPATHc", "WWID2");
>  	mock_used_alias("MPATHe", "WWID2");
>  	mock_unused_alias("MPATHf");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 6);
>  	assert_ptr_equal(alias, NULL);
> @@ -729,9 +779,10 @@ static void lb_nomatch_c_a(void **state)
>  	char *alias;
>  
>  	mock_bindings_file("MPATHc WWID1\n"
> -			   "MPATHa WWID0\n", -1);
> +			   "MPATHa WWID0\n");
> +	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
> +	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 2);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -743,7 +794,7 @@ static void lb_nomatch_d_a_unused(void **state)
>  
>  	mock_bindings_file("MPATHc WWID1\n"
>  			   "MPATHa WWID0\n"
> -			   "MPATHd WWID0\n", -1);
> +			   "MPATHd WWID0\n");
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> @@ -758,10 +809,10 @@ static void lb_nomatch_d_a_1_used(void **state)
>  
>  	mock_bindings_file("MPATHc WWID1\n"
>  			   "MPATHa WWID0\n"
> -			   "MPATHd WWID0\n", -1);
> +			   "MPATHd WWID0\n");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	mock_used_alias("MPATHb", "WWID2");
>  	mock_unused_alias("MPATHe");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 5);
>  	assert_ptr_equal(alias, NULL);
> @@ -774,9 +825,10 @@ static void lb_nomatch_a_b(void **state)
>  
>  	mock_bindings_file("MPATHa WWID0\n"
>  			   "MPATHz WWID26\n"
> -			   "MPATHb WWID1\n", -1);
> +			   "MPATHb WWID1\n");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
> +	mock_unused_alias("MPATHc");
> +	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 3);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -786,13 +838,19 @@ static void lb_nomatch_a_b_bad(void **state)
>  	int rc;
>  	char *alias;
>  
> +	expect_condlog(1, "invalid line 3 in bindings file, missing WWID\n");
> +	/*
> +	 * The broken line will be ignored when constructing the bindings vector.
> +	 * Thus in lookup_binding() MPATHb is never encountered,
> +	 * and MPATHb appears usable.
> +	 */
>  	mock_bindings_file("MPATHa WWID0\n"
>  			   "MPATHz WWID26\n"
> -			   "MPATHb\n", -1);
> -	expect_condlog(3, "Ignoring malformed line 3 in bindings file\n");
> +			   "MPATHb\n");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
> -	assert_int_equal(rc, 3);
> +	mock_unused_alias("MPATHb");
> +	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	assert_int_equal(rc, 2);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -801,28 +859,140 @@ static void lb_nomatch_a_b_bad_self(void **state)
>  	int rc;
>  	char *alias;
>  
> +	expect_condlog(1, "invalid line 3 in bindings file, missing WWID\n");
>  	mock_bindings_file("MPATHa WWID0\n"
>  			   "MPATHz WWID26\n"
> -			   "MPATHb\n", -1);
> -	expect_condlog(3, "Ignoring malformed line 3 in bindings file\n");
> -	mock_self_alias("MPATHc", "WWID2");
> +			   "MPATHb\n");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> +	mock_self_alias("MPATHb", "WWID2");
> +	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	assert_int_equal(rc, 2);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void lb_nomatch_b_z_a(void **state)
> +{
> +	int rc;
> +	char *alias;
> +
> +	/*
> +	 * add_bindings() sorts alphabetically. Therefore get_free_id()
> +	 * finds MPATHc as a free entry.
> +	 */
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATHz WWID26\n"
> +			   "MPATHa WWID0\n");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> +	mock_unused_alias("MPATHc");
>  	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
>  	assert_int_equal(rc, 3);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> +static void lb_nomatch_b_aa_a(void **state)
> +{
> +	int rc;
> +	char *alias;
> +
> +	/*
> +	 * add_bindings() sorts alphabetically. ("a", "aa", b").
> +	 * The get_free_id() algorithm finds the "hole" after "b".
> +	 */
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATHz WWID26\n"
> +			   "MPATHa WWID0\n");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> +	mock_unused_alias("MPATHc");
> +	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	assert_int_equal(rc, 3);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void fill_bindings(struct strbuf *buf, int start, int end)
> +{
> +	int i;
> +
> +	for (i = start; i <= end; i++) {
> +		print_strbuf(buf,  "MPATH");
> +		format_devname(buf, i + 1);
> +		print_strbuf(buf,  " WWID%d\n", i);
> +	}
> +}
> +
> +static void lb_nomatch_b_a_aa(void **state)
> +{
> +	int rc;
> +	char *alias;
> +	STRBUF_ON_STACK(buf);
> +
> +	/*
> +	 * add_bindings() sorts alphabetically. ("a", "aa", "ab", "b", "c", ...)
> +	 * lookup_binding finds MPATHac as next free entry.
> +	 */
> +	fill_bindings(&buf, 0, 26);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID28"));
> +	mock_unused_alias("MPATHab");
> +	rc = lookup_binding(NULL, "WWID28", &alias, "MPATH", 1);
> +	assert_int_equal(rc, 28);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void lb_nomatch_b_a_aa_zz(void **state)
> +{
> +	int rc, i;
> +	char *alias;
> +	STRBUF_ON_STACK(buf);
> +
> +	/*
> +	 * add_bindings() sorts alphabetically. ("a", "aa", "ab", "b", "c", ...)
> +	 * lookup_binding finds MPATHaaa as next free entry, because MPATHaa is
> +	 * found before MPATHb, and MPATHzz was in the bindings, too.
> +	 */
> +	for (i = 0; i <= 26; i++) {
> +		print_strbuf(&buf,  "MPATH");
> +		format_devname(&buf, i + 1);
> +		print_strbuf(&buf,  " WWID%d\n", i);
> +	}
> +	print_strbuf(&buf, "MPATHzz WWID676\n");
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID703"));
> +	mock_unused_alias("MPATHaaa");
> +	rc = lookup_binding(NULL, "WWID703", &alias, "MPATH", 1);
> +	assert_int_equal(rc, 703);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void lb_nomatch_b_z_a_unsorted(void **state)
> +{
> +	int rc;
> +	char *alias;
> +
> +	/*
> +	 * With unsorted bindings (shouldn't happen normally), get_free_id()
> +	 * plays safe and returns MPATHaa as first free entry.
> +	 */
> +	mock_bindings_file_unsorted("MPATHb WWID1\n"
> +				    "MPATHz WWID26\n"
> +				    "MPATHa WWID0\n");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> +	mock_unused_alias("MPATHaa");
> +	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	assert_int_equal(rc, 27);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
>  static void lb_nomatch_b_a(void **state)
>  {
>  	int rc;
>  	char *alias;
>  
>  	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATHz WWID26\n"
> -			   "MPATHa WWID0\n", -1);
> +			   "MPATHa WWID0\n");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
> -	assert_int_equal(rc, 27);
> +	mock_unused_alias("MPATHc");
> +	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	assert_int_equal(rc, 3);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -830,55 +1000,59 @@ static void lb_nomatch_b_a_3_used(void **state)
>  {
>  	int rc;
>  	char *alias;
> +	STRBUF_ON_STACK(buf);
>  
> -	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATHz WWID26\n"
> -			   "MPATHa WWID0\n", -1);
> -	mock_used_alias("MPATHaa", "WWID2");
> -	mock_used_alias("MPATHab", "WWID2");
> -	mock_used_alias("MPATHac", "WWID2");
> -	mock_unused_alias("MPATHad");
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> -	assert_int_equal(rc, 30);
> +	fill_bindings(&buf, 0, 26);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID31"));
> +	mock_used_alias("MPATHab", "WWID31");
> +	mock_used_alias("MPATHac", "WWID31");
> +	mock_used_alias("MPATHad", "WWID31");
> +	mock_unused_alias("MPATHae");
> +	rc = lookup_binding(NULL, "WWID31", &alias, "MPATH", 1);
> +	assert_int_equal(rc, 31);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
>  #ifdef MPATH_ID_INT_MAX
> -static void do_lb_nomatch_int_max(void **state, int check_if_taken)
> +/*
> + * The bindings will be sorted by alias, alphabetically, which is not
> + * the same as the "numeric" sort order for user-friendly aliases.
> + * get_free_id() selects the highest used ID + 1 if an unsorted entry
> + * is encountered in the bindings table and it's id is equal to the
> + * next "expected" id. This happens if all IDs from "a" to "aa" are
> + * in the table. If the INT_MAX entry is in the table, too, it will
> + * overflow.
> + */
> +static void lb_nomatch_int_max(void **state)
>  {
>  	int rc;
>  	char *alias;
> +	STRBUF_ON_STACK(buf);
>  
> -	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n"
> -			   "MPATHa WWID0\n", -1);
> +	fill_bindings(&buf, 0, 26);
> +	print_strbuf(&buf, "MPATH%s WWIDMAX\n", MPATH_ID_INT_MAX);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWIDNOMORE"));
>  	expect_condlog(0, NOMORE_STR);
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", check_if_taken);
> +	rc = lookup_binding(NULL, "WWIDNOMORE", &alias, "MPATH", 1);
>  	assert_int_equal(rc, -1);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> -static void lb_nomatch_int_max(void **state)
> -{
> -	do_lb_nomatch_int_max(state, 0);
> -}
> -
> -static void lb_nomatch_int_max_check(void **state)
> -{
> -	do_lb_nomatch_int_max(state, 1);
> -}
> -
>  static void lb_nomatch_int_max_used(void **state)
>  {
>  	int rc;
>  	char *alias;
> +	STRBUF_ON_STACK(buf);
>  
> -	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATH" MPATH_ID_INT_MAX " WWIDMAX\n", -1);
> -	mock_used_alias("MPATHa", "WWID2");
> +	fill_bindings(&buf, 1, 26);
> +	print_strbuf(&buf, "MPATH%s WWIDMAX\n", MPATH_ID_INT_MAX);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWIDNOMORE"));
> +	mock_used_alias("MPATHa", "WWIDNOMORE");
>  	expect_condlog(0, NOMORE_STR);
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	rc = lookup_binding(NULL, "WWIDNOMORE", &alias, "MPATH", 1);
>  	assert_int_equal(rc, -1);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -887,12 +1061,14 @@ static void lb_nomatch_int_max_m1(void **state)
>  {
>  	int rc;
>  	char *alias;
> +	STRBUF_ON_STACK(buf);
>  
> -	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n"
> -			   "MPATHa WWID0\n", -1);
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 0);
> +	fill_bindings(&buf, 0, 26);
> +	print_strbuf(&buf, "MPATH%s WWIDMAXM1\n", MPATH_ID_INT_MAX_m1);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
> +	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
> +	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
>  	assert_int_equal(rc, INT_MAX);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -901,13 +1077,15 @@ static void lb_nomatch_int_max_m1_used(void **state)
>  {
>  	int rc;
>  	char *alias;
> +	STRBUF_ON_STACK(buf);
>  
> -	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n"
> -			   "MPATHa WWID0\n", -1);
> -	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWID2");
> +	fill_bindings(&buf, 0, 26);
> +	print_strbuf(&buf, "MPATH%s WWIDMAXM1\n", MPATH_ID_INT_MAX_m1);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
> +	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWIDMAX");
>  	expect_condlog(0, NOMORE_STR);
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
>  	assert_int_equal(rc, -1);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -916,13 +1094,15 @@ static void lb_nomatch_int_max_m1_1_used(void **state)
>  {
>  	int rc;
>  	char *alias;
> +	STRBUF_ON_STACK(buf);
>  
> -	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n", -1);
> -	mock_used_alias("MPATHa", "WWID2");
> +	fill_bindings(&buf, 1, 26);
> +	print_strbuf(&buf, "MPATH%s WWIDMAXM1\n", MPATH_ID_INT_MAX_m1);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
> +	mock_used_alias("MPATHa", "WWIDMAX");
>  	mock_unused_alias("MPATH" MPATH_ID_INT_MAX);
> -	expect_condlog(3, NOMATCH_WWID_STR("WWID2"));
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
>  	assert_int_equal(rc, INT_MAX);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -931,13 +1111,17 @@ static void lb_nomatch_int_max_m1_2_used(void **state)
>  {
>  	int rc;
>  	char *alias;
> +	STRBUF_ON_STACK(buf);
>  
> -	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATH" MPATH_ID_INT_MAX_m1 " WWIDMAX\n", -1);
> -	mock_used_alias("MPATHa", "WWID2");
> -	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWID2");
> +	fill_bindings(&buf, 1, 26);
> +	print_strbuf(&buf, "MPATH%s WWIDMAXM1\n", MPATH_ID_INT_MAX_m1);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +
> +	expect_condlog(3, NOMATCH_WWID_STR("WWIDMAX"));
> +	mock_used_alias("MPATHa", "WWIDMAX");
> +	mock_used_alias("MPATH" MPATH_ID_INT_MAX, "WWIDMAX");
>  	expect_condlog(0, NOMORE_STR);
> -	rc = lookup_binding(NULL, "WWID2", &alias, "MPATH", 1);
> +	rc = lookup_binding(NULL, "WWIDMAX", &alias, "MPATH", 1);
>  	assert_int_equal(rc, -1);
>  	assert_ptr_equal(alias, NULL);
>  }
> @@ -946,52 +1130,68 @@ static void lb_nomatch_int_max_m1_2_used(void **state)
>  static int test_lookup_binding(void)
>  {
>  	const struct CMUnitTest tests[] = {
> -		cmocka_unit_test(lb_empty),
> -		cmocka_unit_test(lb_empty_unused),
> -		cmocka_unit_test(lb_empty_failed),
> -		cmocka_unit_test(lb_empty_1_used),
> -		cmocka_unit_test(lb_empty_1_used_self),
> -		cmocka_unit_test(lb_match_a),
> -		cmocka_unit_test(lb_nomatch_a),
> -		cmocka_unit_test(lb_nomatch_a_bad_check),
> -		cmocka_unit_test(lb_nomatch_a_unused),
> -		cmocka_unit_test(lb_nomatch_a_3_used_failed_self),
> -		cmocka_unit_test(lb_match_c),
> -		cmocka_unit_test(lb_match_c_check),
> -		cmocka_unit_test(lb_nomatch_a_c),
> -		cmocka_unit_test(lb_nomatch_a_d_unused),
> -		cmocka_unit_test(lb_nomatch_a_d_1_used),
> -		cmocka_unit_test(lb_nomatch_a_d_2_used),
> -		cmocka_unit_test(lb_nomatch_a_d_3_used),
> -		cmocka_unit_test(lb_nomatch_c_a),
> -		cmocka_unit_test(lb_nomatch_d_a_unused),
> -		cmocka_unit_test(lb_nomatch_d_a_1_used),
> -		cmocka_unit_test(lb_nomatch_a_b),
> -		cmocka_unit_test(lb_nomatch_a_b_bad),
> -		cmocka_unit_test(lb_nomatch_a_b_bad_self),
> -		cmocka_unit_test(lb_nomatch_b_a),
> -		cmocka_unit_test(lb_nomatch_b_a_3_used),
> +		cmocka_unit_test_teardown(lb_empty, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_empty_unused, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_empty_failed, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_empty_1_used, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_empty_1_used_self, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_match_a, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_bad_check, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_unused, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_3_used_failed_self, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_match_c, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_match_c_check, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_c, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_d_unused, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_d_1_used, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_d_2_used, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_d_3_used, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_c_a, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_d_a_unused, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_d_a_1_used, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_b, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_b_bad, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_a_b_bad_self, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_b_z_a, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_b_aa_a, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_b_a_aa, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_b_a_aa_zz, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_b_z_a_unsorted, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_b_a, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_b_a_3_used, teardown_bindings),
>  #ifdef MPATH_ID_INT_MAX
> -		cmocka_unit_test(lb_nomatch_int_max),
> -		cmocka_unit_test(lb_nomatch_int_max_check),
> -		cmocka_unit_test(lb_nomatch_int_max_used),
> -		cmocka_unit_test(lb_nomatch_int_max_m1),
> -		cmocka_unit_test(lb_nomatch_int_max_m1_used),
> -		cmocka_unit_test(lb_nomatch_int_max_m1_1_used),
> -		cmocka_unit_test(lb_nomatch_int_max_m1_2_used),
> +		cmocka_unit_test_teardown(lb_nomatch_int_max, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_int_max_used, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_int_max_m1, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_int_max_m1_used, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_int_max_m1_1_used, teardown_bindings),
> +		cmocka_unit_test_teardown(lb_nomatch_int_max_m1_2_used, teardown_bindings),
>  #endif
>  	};
>  
>  	return cmocka_run_group_tests(tests, NULL, NULL);
>  }
>  
> +static int rlookup_binding(FILE *dummy, char *buf, const char *alias) {
> +
> +	const struct binding *bdg;
> +
> +	bdg = get_binding_for_alias(&global_bindings, alias);
> +	if (!bdg) {
> +		return -1;
> +	}
> +	strlcpy(buf, bdg->wwid, WWID_SIZE);
> +	return 0;
> +}
> +
>  static void rl_empty(void **state)
>  {
>  	int rc;
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	mock_bindings_file("", -1);
> +	mock_bindings_file("");
>  	expect_condlog(3, NOMATCH_STR("MPATHa"));
>  	rc = rlookup_binding(NULL, buf, "MPATHa");
>  	assert_int_equal(rc, -1);
> @@ -1004,7 +1204,7 @@ static void rl_match_a(void **state)
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	mock_bindings_file("MPATHa WWID0\n", 0);
> +	mock_bindings_file("MPATHa WWID0\n");
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHa", "WWID0"));
>  	rc = rlookup_binding(NULL, buf, "MPATHa");
>  	assert_int_equal(rc, 0);
> @@ -1017,7 +1217,7 @@ static void rl_nomatch_a(void **state)
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	mock_bindings_file("MPATHa WWID0\n", -1);
> +	mock_bindings_file("MPATHa WWID0\n");
>  	expect_condlog(3, NOMATCH_STR("MPATHb"));
>  	rc = rlookup_binding(NULL, buf, "MPATHb");
>  	assert_int_equal(rc, -1);
> @@ -1030,8 +1230,8 @@ static void rl_malformed_a(void **state)
>  	char buf[WWID_SIZE];
>  
>  	buf[0] = '\0';
> -	mock_bindings_file("MPATHa     \n", -1);
> -	expect_condlog(3, "Ignoring malformed line 1 in bindings file\n");
> +	expect_condlog(1, "invalid line 1 in bindings file, missing WWID\n");
> +	mock_bindings_file("MPATHa     \n");
>  	expect_condlog(3, NOMATCH_STR("MPATHa"));
>  	rc = rlookup_binding(NULL, buf, "MPATHa");
>  	assert_int_equal(rc, -1);
> @@ -1049,8 +1249,8 @@ static void rl_overlong_a(void **state)
>  	snprintf(line + sizeof(line) - 2, 2, "\n");
>  
>  	buf[0] = '\0';
> -	mock_bindings_file(line, -1);
>  	expect_condlog(3, "Ignoring too large wwid at 1 in bindings file\n");
> +	mock_bindings_file(line);
>  	expect_condlog(3, NOMATCH_STR("MPATHa"));
>  	rc = rlookup_binding(NULL, buf, "MPATHa");
>  	assert_int_equal(rc, -1);
> @@ -1065,7 +1265,7 @@ static void rl_match_b(void **state)
>  	buf[0] = '\0';
>  	mock_bindings_file("MPATHa WWID0\n"
>  			   "MPATHz WWID26\n"
> -			   "MPATHb WWID2\n", 2);
> +			   "MPATHb WWID2\n");
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHb", "WWID2"));
>  	rc = rlookup_binding(NULL, buf, "MPATHb");
>  	assert_int_equal(rc, 0);
> @@ -1075,31 +1275,41 @@ static void rl_match_b(void **state)
>  static int test_rlookup_binding(void)
>  {
>  	const struct CMUnitTest tests[] = {
> -		cmocka_unit_test(rl_empty),
> -		cmocka_unit_test(rl_match_a),
> -		cmocka_unit_test(rl_nomatch_a),
> -		cmocka_unit_test(rl_malformed_a),
> -		cmocka_unit_test(rl_overlong_a),
> -		cmocka_unit_test(rl_match_b),
> +		cmocka_unit_test_teardown(rl_empty, teardown_bindings),
> +		cmocka_unit_test_teardown(rl_match_a, teardown_bindings),
> +		cmocka_unit_test_teardown(rl_nomatch_a, teardown_bindings),
> +		cmocka_unit_test_teardown(rl_malformed_a, teardown_bindings),
> +		cmocka_unit_test_teardown(rl_overlong_a, teardown_bindings),
> +		cmocka_unit_test_teardown(rl_match_b, teardown_bindings),
>  	};
>  
>  	return cmocka_run_group_tests(tests, NULL, NULL);
>  }
>  
> +void check_bindings_size(int n)
> +{
> +	/* avoid -Waddress problem */
> +	Bindings *bindings = &global_bindings;
> +
> +	assert_int_equal(VECTOR_SIZE(bindings), n);
> +}
> +
>  static void al_a(void **state)
>  {
>  	static const char ln[] = "MPATHa WWIDa\n";
>  	char *alias;
>  
> -	will_return(__wrap_lseek, 0);
> -	expect_value(__wrap_write, count, strlen(ln));
> -	expect_string(__wrap_write, buf, ln);
> -	will_return(__wrap_write, strlen(ln));
> +	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_write, ln);
> +	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_rename, 0);
> +	expect_condlog(1, "updated bindings file foo");
>  	expect_condlog(3, NEW_STR("MPATHa", "WWIDa"));
>  
> -	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
> +	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
>  	assert_ptr_not_equal(alias, NULL);
>  	assert_string_equal(alias, "MPATHa");
> +	check_bindings_size(1);
>  	free(alias);
>  }
>  
> @@ -1108,15 +1318,17 @@ static void al_zz(void **state)
>  	static const char ln[] = "MPATHzz WWIDzz\n";
>  	char *alias;
>  
> -	will_return(__wrap_lseek, 0);
> -	expect_value(__wrap_write, count, strlen(ln));
> -	expect_string(__wrap_write, buf, ln);
> -	will_return(__wrap_write, strlen(ln));
> +	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_write, ln);
> +	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_rename, 0);
> +	expect_condlog(1, "updated bindings file foo");
>  	expect_condlog(3, NEW_STR("MPATHzz", "WWIDzz"));
>  
> -	alias = allocate_binding(0, "WWIDzz", 26*26 + 26, "MPATH");
> +	alias = allocate_binding("foo", "WWIDzz", 26*26 + 26, "MPATH");
>  	assert_ptr_not_equal(alias, NULL);
>  	assert_string_equal(alias, "MPATHzz");
> +	check_bindings_size(1);
>  	free(alias);
>  }
>  
> @@ -1127,6 +1339,7 @@ static void al_0(void **state)
>  	expect_condlog(0, "allocate_binding: cannot allocate new binding for id 0\n");
>  	alias = allocate_binding(0, "WWIDa", 0, "MPATH");
>  	assert_ptr_equal(alias, NULL);
> +	check_bindings_size(0);
>  }
>  
>  static void al_m2(void **state)
> @@ -1136,67 +1349,133 @@ static void al_m2(void **state)
>  	expect_condlog(0, "allocate_binding: cannot allocate new binding for id -2\n");
>  	alias = allocate_binding(0, "WWIDa", -2, "MPATH");
>  	assert_ptr_equal(alias, NULL);
> +	check_bindings_size(0);
>  }
>  
> -static void al_lseek_err(void **state)
> +static void al_write_partial(void **state)
>  {
> +	static const char ln[] = "MPATHa WWIDa\n";
>  	char *alias;
>  
> -	will_return(__wrap_lseek, -ENODEV);
> -	expect_condlog(0, "Cannot seek to end of bindings file : No such device\n");
> -	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
> +	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_write, ln);
> +	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln) - 1);
> +	expect_value(__wrap_write, count, 1);
> +	will_return(__wrap_write, ln + sizeof(ln) - 2);
> +	will_return(__wrap_write, 1);
> +	will_return(__wrap_rename, 0);
> +	expect_condlog(1, "updated bindings file foo");
> +	expect_condlog(3, "Created new binding [MPATHa] for WWID [WWIDa]\n");
> +
> +	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
> +	assert_ptr_not_equal(alias, NULL);
> +	assert_string_equal(alias, "MPATHa");
> +	check_bindings_size(1);
> +	free(alias);
> +}
> +
> +static void al_write_short(void **state)
> +{
> +	static const char ln[] = "MPATHa WWIDa\n";
> +	char *alias;
> +
> +	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_write, ln);
> +	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln) - 1);
> +	expect_value(__wrap_write, count, 1);
> +	will_return(__wrap_write, ln + sizeof(ln) - 2);
> +	will_return(__wrap_write, 0);
> +	expect_condlog(2, "write_bindings_file: short write");
> +	expect_condlog(1, "failed to write new bindings file");
> +	expect_condlog(1, "allocate_binding: deleting binding MPATHa for WWIDa");
> +
> +	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
>  	assert_ptr_equal(alias, NULL);
> +	check_bindings_size(0);
>  }
>  
>  static void al_write_err(void **state)
>  {
>  	static const char ln[] = "MPATHa WWIDa\n";
> -	const int offset = 20;
>  	char *alias;
>  
> -	will_return(__wrap_lseek, offset);
> -	expect_value(__wrap_write, count, strlen(ln));
> -	expect_string(__wrap_write, buf, ln);
> -	will_return(__wrap_write, strlen(ln) - 1);
> -	expect_value(__wrap_ftruncate, length, offset);
> -	will_return(__wrap_ftruncate, 0);
> -	expect_condlog(0, "Cannot write binding to bindings file :");
> +	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_write, ln);
> +	will_return(__wrap_write, -EPERM);
> +	expect_condlog(1, "failed to write new bindings file");
> +	expect_condlog(1, "allocate_binding: deleting binding MPATHa for WWIDa");
>  
> -	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
> +	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
>  	assert_ptr_equal(alias, NULL);
> +	check_bindings_size(0);
> +}
> +
> +static void al_rename_err(void **state)
> +{
> +	static const char ln[] = "MPATHa WWIDa\n";
> +	char *alias;
> +
> +	expect_value(__wrap_write, count, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_write, ln);
> +	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
> +	will_return(__wrap_rename, -EROFS);
> +
> +	expect_condlog(0, "update_bindings_file: rename: Read-only file system");
> +	expect_condlog(1, "allocate_binding: deleting binding MPATHa for WWIDa");
> +	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
> +	assert_ptr_equal(alias, NULL);
> +	check_bindings_size(0);
>  }
>  
>  static int test_allocate_binding(void)
>  {
>  	const struct CMUnitTest tests[] = {
> -		cmocka_unit_test(al_a),
> -		cmocka_unit_test(al_zz),
> -		cmocka_unit_test(al_0),
> -		cmocka_unit_test(al_m2),
> -		cmocka_unit_test(al_lseek_err),
> -		cmocka_unit_test(al_write_err),
> +		cmocka_unit_test_teardown(al_a, teardown_bindings),
> +		cmocka_unit_test_teardown(al_zz, teardown_bindings),
> +		cmocka_unit_test_teardown(al_0, teardown_bindings),
> +		cmocka_unit_test_teardown(al_m2, teardown_bindings),
> +		cmocka_unit_test_teardown(al_write_partial, teardown_bindings),
> +		cmocka_unit_test_teardown(al_write_short, teardown_bindings),
> +		cmocka_unit_test_teardown(al_write_err, teardown_bindings),
> +		cmocka_unit_test_teardown(al_rename_err, teardown_bindings),
>  	};
>  
>  	return cmocka_run_group_tests(tests, NULL, NULL);
>  }
>  
> -#define mock_allocate_binding(alias, wwid)				\
> +#define mock_allocate_binding_err_len(alias, wwid, len, err, msg)	\
>  	do {								\
>  		static const char ln[] = BINDING_STR(alias, wwid);	\
>  									\
> -		will_return(__wrap_lseek, 0);				\
> -		expect_value(__wrap_write, count, strlen(ln));		\
> -		expect_string(__wrap_write, buf, ln);			\
> -		will_return(__wrap_write, strlen(ln));			\
> -		expect_condlog(3, NEW_STR(alias, wwid));		\
> +		expect_value(__wrap_write, count,			\
> +			     strlen(BINDINGS_FILE_HEADER) + (len) + strlen(ln)); \
> +		will_return(__wrap_write, ln);				\
> +		will_return(__wrap_write,				\
> +			    strlen(BINDINGS_FILE_HEADER) + (len) + strlen(ln)); \
> +		will_return(__wrap_rename, err);			\
> +		if (err == 0) {						\
> +			expect_condlog(1, "updated bindings file x\n");	\
> +			expect_condlog(3, NEW_STR(alias, wwid));	\
> +		} else {						\
> +			expect_condlog(0, "update_bindings_file: rename: " msg "\n"); \
> +			expect_condlog(1, "allocate_binding: deleting binding "	\
> +				       alias " for " wwid "\n");	\
> +		}							\
>  	} while (0)
>  
> +#define mock_allocate_binding_err(alias, wwid, err, msg)	\
> +	mock_allocate_binding_err_len(alias, wwid, 0, err, msg)
> +
> +#define mock_allocate_binding(alias, wwid)			\
> +	mock_allocate_binding_err(alias, wwid, 0, "")
> +
> +#define mock_allocate_binding_len(alias, wwid, len)			\
> +	mock_allocate_binding_err_len(alias, wwid, len, 0, "")
> +
>  static void gufa_empty_new_rw(void **state) {
>  	char *alias;
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file("", -1);
> +	mock_bindings_file("");
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  
> @@ -1208,10 +1487,11 @@ static void gufa_empty_new_rw(void **state) {
>  
>  static void gufa_empty_new_ro_1(void **state) {
>  	char *alias;
> -	will_return(__wrap_open_file, false);
> -	mock_bindings_file("", -1);
> +
> +	mock_bindings_file("");
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +	mock_allocate_binding_err("MPATHa", "WWID0", -EROFS, "Read-only file system");
>  
>  	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", false);
>  	assert_ptr_equal(alias, NULL);
> @@ -1220,11 +1500,9 @@ static void gufa_empty_new_ro_1(void **state) {
>  static void gufa_empty_new_ro_2(void **state) {
>  	char *alias;
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file("", -1);
> -	mock_unused_alias("MPATHa");
> +	mock_bindings_file("");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +	mock_unused_alias("MPATHa");
>  
>  	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
>  	assert_ptr_equal(alias, NULL);
> @@ -1233,11 +1511,10 @@ static void gufa_empty_new_ro_2(void **state) {
>  static void gufa_match_a_unused(void **state) {
>  	char *alias;
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file("MPATHa WWID0", 0);
> +	mock_bindings_file("MPATHa WWID0");
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_unused_alias("MPATHa");
> +	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
>  
>  	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
>  	assert_string_equal(alias, "MPATHa");
> @@ -1247,11 +1524,10 @@ static void gufa_match_a_unused(void **state) {
>  static void gufa_match_a_self(void **state) {
>  	char *alias;
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file("MPATHa WWID0", 0);
> +	mock_bindings_file("MPATHa WWID0");
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_self_alias("MPATHa", "WWID0");
> +	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
>  
>  	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
>  	assert_string_equal(alias, "MPATHa");
> @@ -1261,9 +1537,8 @@ static void gufa_match_a_self(void **state) {
>  static void gufa_match_a_used(void **state) {
>  	char *alias;
>  
> -	will_return(__wrap_open_file, true);
>  
> -	mock_bindings_file("MPATHa WWID0", 0);
> +	mock_bindings_file("MPATHa WWID0");
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_used_alias("MPATHa", "WWID0");
>  
> @@ -1273,15 +1548,14 @@ static void gufa_match_a_used(void **state) {
>  
>  static void gufa_nomatch_a_c(void **state) {
>  	char *alias;
> -	will_return(__wrap_open_file, true);
> +	static const char bindings[] = ("MPATHa WWID0\n"
> +					"MPATHc WWID2\n");
>  
> -	mock_bindings_file("MPATHa WWID0\n"
> -			   "MPATHc WWID2",
> -			   -1);
> +	mock_bindings_file(bindings);
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
>  
> -	mock_allocate_binding("MPATHb", "WWID1");
> +	mock_allocate_binding_len("MPATHb", "WWID1", strlen(bindings));
>  
>  	alias = get_user_friendly_alias("WWID1", "x", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHb");
> @@ -1290,15 +1564,14 @@ static void gufa_nomatch_a_c(void **state) {
>  
>  static void gufa_nomatch_c_a(void **state) {
>  	char *alias;
> -	will_return(__wrap_open_file, true);
> +	const char bindings[] = ("MPATHc WWID2\n"
> +				 "MPATHa WWID0\n");
>  
> -	mock_bindings_file("MPATHc WWID2\n"
> -			   "MPATHa WWID0",
> -			   -1);
> +	mock_bindings_file(bindings);
>  	mock_unused_alias("MPATHb");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
>  
> -	mock_allocate_binding("MPATHb", "WWID1");
> +	mock_allocate_binding_len("MPATHb", "WWID1", sizeof(bindings) - 1);
>  
>  	alias = get_user_friendly_alias("WWID1", "x", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHb");
> @@ -1307,15 +1580,14 @@ static void gufa_nomatch_c_a(void **state) {
>  
>  static void gufa_nomatch_c_b(void **state) {
>  	char *alias;
> -	will_return(__wrap_open_file, true);
> +	const char bindings[] = ("MPATHc WWID2\n"
> +				 "MPATHb WWID1\n");
>  
> -	mock_bindings_file("MPATHc WWID2\n"
> -			   "MPATHb WWID1\n",
> -			   -1);
> -	mock_unused_alias("MPATHa");
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +	mock_unused_alias("MPATHa");
>  
> -	mock_allocate_binding("MPATHa", "WWID0");
> +	mock_allocate_binding_len("MPATHa", "WWID0", sizeof(bindings) - 1);
>  
>  	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHa");
> @@ -1324,16 +1596,15 @@ static void gufa_nomatch_c_b(void **state) {
>  
>  static void gufa_nomatch_c_b_used(void **state) {
>  	char *alias;
> -	will_return(__wrap_open_file, true);
> +	const char bindings[] = ("MPATHc WWID2\n"
> +				 "MPATHb WWID1\n");
>  
> -	mock_bindings_file("MPATHc WWID2\n"
> -			   "MPATHb WWID1",
> -			   -1);
> -	mock_used_alias("MPATHa", "WWID4");
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID4"));
> +	mock_used_alias("MPATHa", "WWID4");
>  	mock_unused_alias("MPATHd");
>  
> -	mock_allocate_binding("MPATHd", "WWID4");
> +	mock_allocate_binding_len("MPATHd", "WWID4", sizeof(bindings) - 1);
>  
>  	alias = get_user_friendly_alias("WWID4", "x", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHd");
> @@ -1342,32 +1613,59 @@ static void gufa_nomatch_c_b_used(void **state) {
>  
>  static void gufa_nomatch_b_f_a(void **state) {
>  	char *alias;
> -	will_return(__wrap_open_file, true);
> +	const char bindings[] = ("MPATHb WWID1\n"
> +				 "MPATHf WWID6\n"
> +				 "MPATHa WWID0\n");
>  
> -	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATHf WWID6\n"
> -			   "MPATHa WWID0\n",
> -			   -1);
> +	mock_bindings_file_unsorted(bindings);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID7"));
>  	mock_unused_alias("MPATHg");
>  
> -	mock_allocate_binding("MPATHg", "WWID7");
> +	mock_allocate_binding_len("MPATHg", "WWID7", sizeof(bindings) - 1);
>  
>  	alias = get_user_friendly_alias("WWID7", "x", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHg");
>  	free(alias);
>  }
>  
> +static void gufa_nomatch_b_aa_a(void **state) {
> +	char *alias;
> +	STRBUF_ON_STACK(buf);
> +
> +	fill_bindings(&buf, 0, 26);
> +	mock_bindings_file(get_strbuf_str(&buf));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID28"));
> +	mock_unused_alias("MPATHab");
> +	mock_allocate_binding_len("MPATHab", "WWID28", get_strbuf_len(&buf));
> +
> +	alias = get_user_friendly_alias("WWID28", "x", "", "MPATH", false);
> +	assert_string_equal(alias, "MPATHab");
> +	free(alias);
> +}
> +
> +static void gufa_nomatch_b_f_a_sorted(void **state) {
> +	char *alias;
> +	const char bindings[] = ("MPATHb WWID1\n"
> +				 "MPATHf WWID6\n"
> +				 "MPATHa WWID0\n");
> +
> +	mock_bindings_file(bindings);
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID7"));
> +	mock_unused_alias("MPATHc");
> +
> +	mock_allocate_binding_len("MPATHc", "WWID7", sizeof(bindings) - 1);
> +
> +	alias = get_user_friendly_alias("WWID7", "x", "", "MPATH", false);
> +	assert_string_equal(alias, "MPATHc");
> +	free(alias);
> +}
> +
>  static void gufa_old_empty(void **state) {
>  	char *alias;
> -	will_return(__wrap_open_file, true);
>  
>  	/* rlookup_binding for ALIAS */
> -	mock_bindings_file("", -1);
> +	mock_bindings_file("");
>  	expect_condlog(3, NOMATCH_STR("MPATHz"));
> -
> -	/* lookup_binding */
> -	mock_bindings_file("", -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  
>  	mock_allocate_binding("MPATHz", "WWID0");
> @@ -1380,11 +1678,9 @@ static void gufa_old_empty(void **state) {
>  
>  static void gufa_old_match(void **state) {
>  	char *alias;
> -	will_return(__wrap_open_file, true);
>  
>  	mock_bindings_file("MPATHb WWID1\n"
> -			   "MPATHz WWID0",
> -			   1);
> +			   "MPATHz WWID0");
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID0"));
>  
>  	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> @@ -1394,19 +1690,15 @@ static void gufa_old_match(void **state) {
>  
>  static void gufa_old_match_other(void **state) {
>  	char *alias;
> -	static const char bindings[] = "MPATHz WWID9";
> +	static const char bindings[] = "MPATHz WWID9\n";
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file(bindings, 0);
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
>  	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
> -
> -	mock_bindings_file(bindings, -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_unused_alias("MPATHa");
>  
> -	mock_allocate_binding("MPATHa", "WWID0");
> +	mock_allocate_binding_len("MPATHa", "WWID0", sizeof(bindings) - 1);
>  
>  	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHa");
> @@ -1415,21 +1707,16 @@ static void gufa_old_match_other(void **state) {
>  
>  static void gufa_old_match_other_used(void **state) {
>  	char *alias;
> -	static const char bindings[] = "MPATHz WWID9";
> +	static const char bindings[] = "MPATHz WWID9\n";
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file(bindings, 0);
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
>  	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
> -
> -	mock_bindings_file(bindings, -1);
> -	mock_used_alias("MPATHa", "WWID0");
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +	mock_used_alias("MPATHa", "WWID0");
>  	mock_unused_alias("MPATHb");
>  
> -	mock_allocate_binding("MPATHb", "WWID0");
> -
> +	mock_allocate_binding_len("MPATHb", "WWID0", sizeof(bindings) - 1);
>  	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHb");
>  	free(alias);
> @@ -1439,15 +1726,13 @@ static void gufa_old_match_other_wwidmatch(void **state) {
>  	char *alias;
>  	static const char bindings[] = ("MPATHz WWID9\n"
>  					"MPATHc WWID2");
> -	will_return(__wrap_open_file, true);
>  
> -	mock_bindings_file(bindings, 0);
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
>  	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
> -
> -	mock_bindings_file(bindings, 1);
>  	expect_condlog(3, FOUND_STR("MPATHc", "WWID2"));
>  	mock_unused_alias("MPATHc");
> +	expect_condlog(3, EXISTING_STR("MPATHc", "WWID2"));
>  
>  	alias = get_user_friendly_alias("WWID2", "x", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHc");
> @@ -1459,13 +1744,9 @@ static void gufa_old_match_other_wwidmatch_used(void **state) {
>  	static const char bindings[] = ("MPATHz WWID9\n"
>  					"MPATHc WWID2");
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file(bindings, 0);
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
>  	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
> -
> -	mock_bindings_file(bindings, 1);
>  	expect_condlog(3, FOUND_STR("MPATHc", "WWID2"));
>  	mock_used_alias("MPATHc", "WWID2");
>  
> @@ -1477,12 +1758,8 @@ static void gufa_old_nomatch_wwidmatch(void **state) {
>  	char *alias;
>  	static const char bindings[] = "MPATHa WWID0";
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file(bindings, -1);
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, NOMATCH_STR("MPATHz"));
> -
> -	mock_bindings_file(bindings, 0);
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
> @@ -1495,12 +1772,9 @@ static void gufa_old_nomatch_wwidmatch(void **state) {
>  static void gufa_old_nomatch_wwidmatch_used(void **state) {
>  	char *alias;
>  	static const char bindings[] = "MPATHa WWID0";
> -	will_return(__wrap_open_file, true);
>  
> -	mock_bindings_file(bindings, -1);
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, NOMATCH_STR("MPATHz"));
> -
> -	mock_bindings_file(bindings, 0);
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_used_alias("MPATHa", "WWID0");
>  
> @@ -1510,17 +1784,13 @@ static void gufa_old_nomatch_wwidmatch_used(void **state) {
>  
>  static void gufa_old_nomatch_nowwidmatch(void **state) {
>  	char *alias;
> -	static const char bindings[] = "MPATHb WWID1";
> +	static const char bindings[] = "MPATHb WWID1\n";
>  
> -	will_return(__wrap_open_file, true);
> -
> -	mock_bindings_file(bindings, -1);
> +	mock_bindings_file(bindings);
>  	expect_condlog(3, NOMATCH_STR("MPATHz"));
> -
> -	mock_bindings_file(bindings, -1);
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  
> -	mock_allocate_binding("MPATHz", "WWID0");
> +	mock_allocate_binding_len("MPATHz", "WWID0", sizeof(bindings) - 1);
>  	expect_condlog(2, ALLOC_STR("MPATHz", "WWID0"));
>  
>  	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> @@ -1531,26 +1801,28 @@ static void gufa_old_nomatch_nowwidmatch(void **state) {
>  static int test_get_user_friendly_alias()
>  {
>  	const struct CMUnitTest tests[] = {
> -		cmocka_unit_test(gufa_empty_new_rw),
> -		cmocka_unit_test(gufa_empty_new_ro_1),
> -		cmocka_unit_test(gufa_empty_new_ro_2),
> -		cmocka_unit_test(gufa_match_a_unused),
> -		cmocka_unit_test(gufa_match_a_self),
> -		cmocka_unit_test(gufa_match_a_used),
> -		cmocka_unit_test(gufa_nomatch_a_c),
> -		cmocka_unit_test(gufa_nomatch_c_a),
> -		cmocka_unit_test(gufa_nomatch_c_b),
> -		cmocka_unit_test(gufa_nomatch_c_b_used),
> -		cmocka_unit_test(gufa_nomatch_b_f_a),
> -		cmocka_unit_test(gufa_old_empty),
> -		cmocka_unit_test(gufa_old_match),
> -		cmocka_unit_test(gufa_old_match_other),
> -		cmocka_unit_test(gufa_old_match_other_used),
> -		cmocka_unit_test(gufa_old_match_other_wwidmatch),
> -		cmocka_unit_test(gufa_old_match_other_wwidmatch_used),
> -		cmocka_unit_test(gufa_old_nomatch_wwidmatch),
> -		cmocka_unit_test(gufa_old_nomatch_wwidmatch_used),
> -		cmocka_unit_test(gufa_old_nomatch_nowwidmatch),
> +		cmocka_unit_test_teardown(gufa_empty_new_rw, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_empty_new_ro_1, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_empty_new_ro_2, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_match_a_unused, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_match_a_self, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_match_a_used, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_nomatch_a_c, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_nomatch_c_a, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_nomatch_c_b, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_nomatch_c_b_used, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_nomatch_b_f_a, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_nomatch_b_aa_a, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_nomatch_b_f_a_sorted, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_empty, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_match, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_match_other, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_match_other_used, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_match_other_wwidmatch, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_match_other_wwidmatch_used, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_nomatch_wwidmatch, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_nomatch_wwidmatch_used, teardown_bindings),
> +		cmocka_unit_test_teardown(gufa_old_nomatch_nowwidmatch, teardown_bindings),
>  	};
>  
>  	return cmocka_run_group_tests(tests, NULL, NULL);
> @@ -1566,7 +1838,6 @@ int main(void)
>  	ret += test_lookup_binding();
>  	ret += test_rlookup_binding();
>  	ret += test_allocate_binding();
> -	ret += test_allocate_binding();
>  	ret += test_get_user_friendly_alias();
>  
>  	return ret;
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

