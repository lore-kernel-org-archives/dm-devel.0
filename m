Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EE7EE3F39
	for <dm-devel@archiver.kernel.org>; Tue, 12 Sep 2023 23:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694559651;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=i4Jt48z2AUn774PC4S93DVQJSNzb51lvWVwWjy1vh0Y=;
	b=dvUPncZj+IRr6g6F7YboFCLuRdO94S27IQsV5dkp0ojp423vZ6xF9kk1vtjrwB4Lx+b/ly
	WaR7L2XWyBKRfieDbP3wGUU/uj1ePQq/cNe5aud43O9d13GbzxHPbVip9ozGwtfKdNaV5p
	5rX7FN2KepKtRHzXIPDmrrYuhs4mm9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-3gPqZkBgPWeG3x0qlWE3Mg-1; Tue, 12 Sep 2023 19:00:48 -0400
X-MC-Unique: 3gPqZkBgPWeG3x0qlWE3Mg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52978101A529;
	Tue, 12 Sep 2023 23:00:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3CF4210F1BE7;
	Tue, 12 Sep 2023 23:00:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ED76A19465A8;
	Tue, 12 Sep 2023 23:00:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AD268194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Sep 2023 23:00:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 986F910F1BE8; Tue, 12 Sep 2023 23:00:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E95A10F1BE7;
 Tue, 12 Sep 2023 23:00:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38CN0Sep031055;
 Tue, 12 Sep 2023 18:00:28 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38CN0Rw1031053;
 Tue, 12 Sep 2023 18:00:27 -0500
Date: Tue, 12 Sep 2023 18:00:27 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230912230027.GP7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-8-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-8-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 07/37] multipath-tools tests: add tests
 for get_user_friendly_alias()
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

On Mon, Sep 11, 2023 at 06:38:16PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/alias.c | 441 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 441 insertions(+)
> 
> diff --git a/tests/alias.c b/tests/alias.c
> index 11f209e..7e443b0 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -81,6 +81,35 @@ int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
>  	return ret;
>  }
>  
> +#define TEST_FDNO 1234
> +#define TEST_FPTR ((FILE *) 0xaffe)
> +
> +int __wrap_open_file(const char *file, int *can_write, const char *header)
> +{
> +	int cw = mock_type(int);
> +
> +        *can_write = cw;
> +	return TEST_FDNO;
> +}
> +
> +FILE *__wrap_fdopen(int fd, const char *mode)
> +{
> +	assert_int_equal(fd, TEST_FDNO);
> +	return TEST_FPTR;
> +}
> +
> +int __wrap_fflush(FILE *f)
> +{
> +	assert_ptr_equal(f, TEST_FPTR);
> +	return 0;
> +}
> +
> +int __wrap_fclose(FILE *f)
> +{
> +	assert_ptr_equal(f, TEST_FPTR);
> +	return 0;
> +}
> +
>  /* strbuf wrapper for the old format_devname() */
>  static int __format_devname(char *name, int id, size_t len, const char *prefix)
>  {
> @@ -399,6 +428,22 @@ static void mock_self_alias(const char *alias, const char *wwid)
>  }
>  
>  #define USED_STR(alias_str, wwid_str) wwid_str ": alias '" alias_str "' already taken, reselecting alias\n"
> +#define NOMATCH_STR(alias_str) ("No matching alias [" alias_str "] in bindings file.\n")
> +#define FOUND_STR(alias_str, wwid_str)				\
> +	"Found matching wwid [" wwid_str "] in bindings file."	\
> +	" Setting alias to " alias_str "\n"
> +#define FOUND_ALIAS_STR(alias_str, wwid_str)				\
> +	"Found matching alias [" alias_str "] in bindings file."	\
> +	" Setting wwid to " wwid_str "\n"
> +#define NOMATCH_WWID_STR(wwid_str) ("No matching wwid [" wwid_str "] in bindings file.\n")
> +#define NEW_STR(alias_str, wwid_str) ("Created new binding [" alias_str "] for WWID [" wwid_str "]\n")
> +#define EXISTING_STR(alias_str, wwid_str) ("Use existing binding [" alias_str "] for WWID [" wwid_str "]\n")
> +#define ALLOC_STR(alias_str, wwid_str) ("Allocated existing binding [" alias_str "] for WWID [" wwid_str "]\n")
> +#define BINDING_STR(alias_str, wwid_str) (alias_str " " wwid_str "\n")
> +#define BOUND_STR(alias_str, wwid_str) ("alias "alias_str " already bound to wwid " wwid_str ", cannot reuse")
> +#define ERR_STR(alias_str, wwid_str) ("ERROR: old alias [" alias_str "] for wwid [" wwid_str "] is used by other map\n")
> +#define REUSE_STR(alias_str, wwid_str) ("alias " alias_str " already bound to wwid " wwid_str ", cannot reuse\n")
> +#define NOMORE_STR "no more available user_friendly_names\n"
>  
>  static void mock_failed_alias(const char *alias, char *msg)
>  {
> @@ -421,6 +466,24 @@ static void mock_used_alias(const char *alias, char *msg)
>  	expect_condlog(3, msg);
>  }
>  
> +static void mock_bindings_file(const char *content, int match_line)
> +{
> +	static char cnt[1024];
> +	char *token;
> +	int i;
> +
> +	assert_in_range(strlcpy(cnt, content, sizeof(cnt)), 0, sizeof(cnt) - 1);
> +
> +	for (token = strtok(cnt, "\n"), i = 0;
> +	     token && *token;
> +	     token = strtok(NULL, "\n"), i++) {
> +		will_return(__wrap_fgets, token);
> +		if (match_line == i)
> +			return;
> +	}
> +	will_return(__wrap_fgets, NULL);
> +}
> +
>  static void lb_empty(void **state)
>  {
>  	int rc;
> @@ -1147,6 +1210,382 @@ static int test_allocate_binding(void)
>  	return cmocka_run_group_tests(tests, NULL, NULL);
>  }
>  
> +#define mock_allocate_binding(alias, wwid)				\
> +	do {								\
> +		static const char ln[] = BINDING_STR(alias, wwid);	\
> +									\
> +		will_return(__wrap_lseek, 0);				\
> +		expect_value(__wrap_write, count, strlen(ln));		\
> +		expect_string(__wrap_write, buf, ln);			\
> +		will_return(__wrap_write, strlen(ln));			\
> +		expect_condlog(3, NEW_STR(alias, wwid));		\
> +	} while (0)
> +
> +static void gufa_empty_new_rw(void **state) {
> +	char *alias;
> +
> +	will_return(__wrap_open_file, true);
> +
> +	will_return(__wrap_fgets, NULL);
> +	mock_unused_alias("MPATHa");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +
> +	mock_allocate_binding("MPATHa", "WWID0");
> +	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", false);
> +	assert_string_equal(alias, "MPATHa");
> +	free(alias);
> +}
> +
> +static void gufa_empty_new_ro_1(void **state) {
> +	char *alias;
> +	will_return(__wrap_open_file, false);
> +	will_return(__wrap_fgets, NULL);
> +	mock_unused_alias("MPATHa");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", false);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void gufa_empty_new_ro_2(void **state) {
> +	char *alias;
> +
> +	will_return(__wrap_open_file, true);
> +
> +	will_return(__wrap_fgets, NULL);
> +	mock_unused_alias("MPATHa");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void gufa_match_a_unused(void **state) {
> +	char *alias;
> +
> +	will_return(__wrap_open_file, true);
> +
> +	will_return(__wrap_fgets, BINDING_STR("MPATHa", "WWID0"));
> +	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> +	mock_unused_alias("MPATHa");
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
> +	assert_string_equal(alias, "MPATHa");
> +	free(alias);
> +}
> +
> +static void gufa_match_a_self(void **state) {
> +	char *alias;
> +
> +	will_return(__wrap_open_file, true);
> +
> +	will_return(__wrap_fgets, BINDING_STR("MPATHa", "WWID0"));
> +	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> +	mock_self_alias("MPATHa", "WWID0");
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
> +	assert_string_equal(alias, "MPATHa");
> +	free(alias);
> +}
> +
> +static void gufa_match_a_used(void **state) {
> +	char *alias;
> +
> +	will_return(__wrap_open_file, true);
> +
> +	will_return(__wrap_fgets, BINDING_STR("MPATHa", "WWID0"));
> +	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> +	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void gufa_nomatch_a_c(void **state) {
> +	char *alias;
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file("MPATHa WWID0\n"
> +			   "MPATHc WWID2",
> +			   -1);
> +	mock_unused_alias("MPATHb");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
> +
> +	mock_allocate_binding("MPATHb", "WWID1");
> +
> +	alias = get_user_friendly_alias("WWID1", "x", "", "MPATH", false);
> +	assert_string_equal(alias, "MPATHb");
> +	free(alias);
> +}
> +
> +static void gufa_nomatch_c_a(void **state) {
> +	char *alias;
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file("MPATHc WWID2\n"
> +			   "MPATHa WWID0",
> +			   -1);
> +	mock_unused_alias("MPATHb");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
> +
> +	mock_allocate_binding("MPATHb", "WWID1");
> +
> +	alias = get_user_friendly_alias("WWID1", "x", "", "MPATH", false);
> +	assert_string_equal(alias, "MPATHb");
> +	free(alias);
> +}
> +
> +static void gufa_nomatch_c_b(void **state) {
> +	char *alias;
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file("MPATHc WWID2\n"
> +			   "MPATHb WWID1\n",
> +			   -1);
> +	mock_unused_alias("MPATHa");
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +
> +	mock_allocate_binding("MPATHa", "WWID0");
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", false);
> +	assert_string_equal(alias, "MPATHa");
> +	free(alias);
> +}
> +
> +static void gufa_nomatch_c_b_used(void **state) {
> +	char *alias;
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file("MPATHc WWID2\n"
> +			   "MPATHb WWID1",
> +			   -1);
> +	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID4"));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID4"));
> +	mock_unused_alias("MPATHd");
> +
> +	mock_allocate_binding("MPATHd", "WWID4");
> +
> +	alias = get_user_friendly_alias("WWID4", "x", "", "MPATH", false);
> +	assert_string_equal(alias, "MPATHd");
> +	free(alias);
> +}
> +
> +static void gufa_nomatch_b_f_a(void **state) {
> +	char *alias;
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATHf WWID6\n"
> +			   "MPATHa WWID0\n",
> +			   -1);
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID7"));
> +	mock_unused_alias("MPATHg");
> +
> +	mock_allocate_binding("MPATHg", "WWID7");
> +
> +	alias = get_user_friendly_alias("WWID7", "x", "", "MPATH", false);
> +	assert_string_equal(alias, "MPATHg");
> +	free(alias);
> +}
> +
> +static void gufa_old_empty(void **state) {
> +	char *alias;
> +	will_return(__wrap_open_file, true);
> +
> +	/* rlookup_binding for ALIAS */
> +	will_return(__wrap_fgets, NULL);
> +	expect_condlog(3, NOMATCH_STR("MPATHz"));
> +
> +	/* lookup_binding */
> +	will_return(__wrap_fgets, NULL);
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +
> +	mock_allocate_binding("MPATHz", "WWID0");
> +	expect_condlog(2, ALLOC_STR("MPATHz", "WWID0"));
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	assert_string_equal(alias, "MPATHz");
> +	free(alias);
> +}
> +
> +static void gufa_old_match(void **state) {
> +	char *alias;
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file("MPATHb WWID1\n"
> +			   "MPATHz WWID0",
> +			   1);
> +	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID0"));
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	assert_string_equal(alias, "MPATHz");
> +	free(alias);
> +}
> +
> +static void gufa_old_match_other(void **state) {
> +	char *alias;
> +	static const char bindings[] = "MPATHz WWID9";
> +
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file(bindings, 0);
> +	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
> +	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
> +
> +	mock_bindings_file(bindings, -1);
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +	mock_unused_alias("MPATHa");
> +
> +	mock_allocate_binding("MPATHa", "WWID0");
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	assert_string_equal(alias, "MPATHa");
> +	free(alias);
> +}
> +
> +static void gufa_old_match_other_used(void **state) {
> +	char *alias;
> +	static const char bindings[] = "MPATHz WWID9";
> +
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file(bindings, 0);
> +	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
> +	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
> +
> +	mock_bindings_file(bindings, -1);
> +	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +	mock_unused_alias("MPATHb");
> +
> +	mock_allocate_binding("MPATHb", "WWID0");
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	assert_string_equal(alias, "MPATHb");
> +	free(alias);
> +}
> +
> +static void gufa_old_match_other_wwidmatch(void **state) {
> +	char *alias;
> +	static const char bindings[] = ("MPATHz WWID9\n"
> +					"MPATHc WWID2");
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file(bindings, 0);
> +	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
> +	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
> +
> +	mock_bindings_file(bindings, 1);
> +	expect_condlog(3, FOUND_STR("MPATHc", "WWID2"));
> +	mock_unused_alias("MPATHc");
> +
> +	alias = get_user_friendly_alias("WWID2", "x", "MPATHz", "MPATH", false);
> +	assert_string_equal(alias, "MPATHc");
> +	free(alias);
> +}
> +
> +static void gufa_old_match_other_wwidmatch_used(void **state) {
> +	char *alias;
> +	static const char bindings[] = ("MPATHz WWID9\n"
> +					"MPATHc WWID2");
> +
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file(bindings, 0);
> +	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID9"));
> +	expect_condlog(0, REUSE_STR("MPATHz", "WWID9"));
> +
> +	mock_bindings_file(bindings, 1);
> +	expect_condlog(3, FOUND_STR("MPATHc", "WWID2"));
> +	mock_used_alias("MPATHc", USED_STR("MPATHc", "WWID2"));
> +
> +	alias = get_user_friendly_alias("WWID2", "x", "MPATHz", "MPATH", false);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void gufa_old_nomatch_wwidmatch(void **state) {
> +	char *alias;
> +	static const char bindings[] = "MPATHa WWID0";
> +
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file(bindings, -1);
> +	expect_condlog(3, NOMATCH_STR("MPATHz"));
> +
> +	mock_bindings_file(bindings, 0);
> +	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> +	mock_unused_alias("MPATHa");
> +	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	assert_string_equal(alias, "MPATHa");
> +	free(alias);
> +}
> +
> +static void gufa_old_nomatch_wwidmatch_used(void **state) {
> +	char *alias;
> +	static const char bindings[] = "MPATHa WWID0";
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file(bindings, -1);
> +	expect_condlog(3, NOMATCH_STR("MPATHz"));
> +
> +	mock_bindings_file(bindings, 0);
> +	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> +	mock_used_alias("MPATHa", USED_STR("MPATHa", "WWID0"));
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	assert_ptr_equal(alias, NULL);
> +}
> +
> +static void gufa_old_nomatch_nowwidmatch(void **state) {
> +	char *alias;
> +	static const char bindings[] = "MPATHb WWID1";
> +
> +	will_return(__wrap_open_file, true);
> +
> +	mock_bindings_file(bindings, -1);
> +	expect_condlog(3, NOMATCH_STR("MPATHz"));
> +
> +	mock_bindings_file(bindings, -1);
> +	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> +
> +	mock_allocate_binding("MPATHz", "WWID0");
> +	expect_condlog(2, ALLOC_STR("MPATHz", "WWID0"));
> +
> +	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	assert_string_equal(alias, "MPATHz");
> +	free(alias);
> +}
> +
> +static int test_get_user_friendly_alias()
> +{
> +	const struct CMUnitTest tests[] = {
> +		cmocka_unit_test(gufa_empty_new_rw),
> +		cmocka_unit_test(gufa_empty_new_ro_1),
> +		cmocka_unit_test(gufa_empty_new_ro_2),
> +		cmocka_unit_test(gufa_match_a_unused),
> +		cmocka_unit_test(gufa_match_a_self),
> +		cmocka_unit_test(gufa_match_a_used),
> +		cmocka_unit_test(gufa_nomatch_a_c),
> +		cmocka_unit_test(gufa_nomatch_c_a),
> +		cmocka_unit_test(gufa_nomatch_c_b),
> +		cmocka_unit_test(gufa_nomatch_c_b_used),
> +		cmocka_unit_test(gufa_nomatch_b_f_a),
> +		cmocka_unit_test(gufa_old_empty),
> +		cmocka_unit_test(gufa_old_match),
> +		cmocka_unit_test(gufa_old_match_other),
> +		cmocka_unit_test(gufa_old_match_other_used),
> +		cmocka_unit_test(gufa_old_match_other_wwidmatch),
> +		cmocka_unit_test(gufa_old_match_other_wwidmatch_used),
> +		cmocka_unit_test(gufa_old_nomatch_wwidmatch),
> +		cmocka_unit_test(gufa_old_nomatch_wwidmatch_used),
> +		cmocka_unit_test(gufa_old_nomatch_nowwidmatch),
> +	};
> +
> +	return cmocka_run_group_tests(tests, NULL, NULL);
> +}
> +
>  int main(void)
>  {
>  	int ret = 0;
> @@ -1157,6 +1596,8 @@ int main(void)
>  	ret += test_lookup_binding();
>  	ret += test_rlookup_binding();
>  	ret += test_allocate_binding();
> +	ret += test_allocate_binding();
> +	ret += test_get_user_friendly_alias();
>  
>  	return ret;
>  }
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

