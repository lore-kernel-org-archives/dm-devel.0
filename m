Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80691EE14D0
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 07:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694073321;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a5fqQcFjDRiu57XyeReVIVVjFyZc4/AwbHMHuD8HSuI=;
	b=F/p/M98PZGD7gVgKXjrLgoXLJ0fFOs06I6faYU+vRl5dPS8rSl3IODoMK2FWQDE7hObKKk
	w177GLgXSeD6r+hPpxHV+TPh2JbxCuR/59m9nkx8OU8rNNoXMTl1mscgEoYKnnfeL/nFeT
	Gui13Ru8R+S1j+6ZyW0qYrT6Z32CyUw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-fa8LikooOPy5jm-9x0w1dA-1; Thu, 07 Sep 2023 03:55:19 -0400
X-MC-Unique: fa8LikooOPy5jm-9x0w1dA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05D258E3421;
	Thu,  7 Sep 2023 07:55:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E6341121314;
	Thu,  7 Sep 2023 07:55:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5EE50194658F;
	Thu,  7 Sep 2023 07:55:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4DD69194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 07:55:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1617F21EE56A; Thu,  7 Sep 2023 07:55:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F321200ACDB
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 07:55:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA8521C09CCD
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 07:55:15 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-1KyYRfGKNKGtxTp8PTEkpA-1; Thu,
 07 Sep 2023 03:55:14 -0400
X-MC-Unique: 1KyYRfGKNKGtxTp8PTEkpA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 804C81F750;
 Thu,  7 Sep 2023 07:55:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5C5A5138F9;
 Thu,  7 Sep 2023 07:55:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id +z8OFeCB+WTrHAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 07 Sep 2023 07:55:12 +0000
Message-ID: <b25c74e1df74ad9050824130fb9ce832e26112c4.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 07 Sep 2023 09:55:11 +0200
In-Reply-To: <20230906224330.GR7412@octiron.msp.redhat.com>
References: <20230901180235.23980-1-mwilck@suse.com>
 <20230901180235.23980-8-mwilck@suse.com>
 <20230906224330.GR7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 07/21] multipath-tools tests: add tests for
 get_user_friendly_alias()
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
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-09-06 at 17:43 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 01, 2023 at 08:02:20PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0tests/alias.c | 531
> > ++++++++++++++++++++++++++++++++++++++++++++++++++
> > =A01 file changed, 531 insertions(+)
> >=20
> > diff --git a/tests/alias.c b/tests/alias.c
> > index 11f209e..e2372d1 100644
> > --- a/tests/alias.c
> > +++ b/tests/alias.c
> > @@ -81,6 +81,35 @@ int __wrap_dm_get_uuid(const char *name, char
> > *uuid, int uuid_len)
> > =A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > =A0}
> > =A0
> > +#define TEST_FDNO 1234
> > +#define TEST_FPTR ((FILE *) 0xaffe)
> > +
> > +int __wrap_open_file(const char *file, int *can_write, const char
> > *header)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int cw =3D mock_type(int);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0 *can_write =3D cw;
> > +=A0=A0=A0=A0=A0=A0=A0return TEST_FDNO;
> > +}
> > +
> > +FILE *__wrap_fdopen(int fd, const char *mode)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(fd, TEST_FDNO);
> > +=A0=A0=A0=A0=A0=A0=A0return TEST_FPTR;
> > +}
> > +
> > +int __wrap_fflush(FILE *f)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0assert_ptr_equal(f, TEST_FPTR);
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > +int __wrap_fclose(FILE *f)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0assert_ptr_equal(f, TEST_FPTR);
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > =A0/* strbuf wrapper for the old format_devname() */
> > =A0static int __format_devname(char *name, int id, size_t len, const
> > char *prefix)
> > =A0{
> > @@ -399,6 +428,22 @@ static void mock_self_alias(const char *alias,
> > const char *wwid)
> > =A0}
> > =A0
> > =A0#define USED_STR(alias_str, wwid_str) wwid_str ": alias '"
> > alias_str "' already taken, reselecting alias\n"
> > +#define NOMATCH_STR(alias_str) ("No matching alias [" alias_str "]
> > in bindings file.\n")
> > +#define FOUND_STR(alias_str, wwid_str)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0"Found matching wwid [" wwid_str "] in bindings f=
ile."=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0" Setting alias to " alias_str "\n"
> > +#define FOUND_ALIAS_STR(alias_str,
> > wwid_str)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0"Found matching alias [" alias_str "] in bindings
> > file."=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0" Setting wwid to " wwid_str "\n"
> > +#define NOMATCH_WWID_STR(wwid_str) ("No matching wwid [" wwid_str
> > "] in bindings file.\n")
> > +#define NEW_STR(alias_str, wwid_str) ("Created new binding ["
> > alias_str "] for WWID [" wwid_str "]\n")
> > +#define EXISTING_STR(alias_str, wwid_str) ("Use existing binding
> > [" alias_str "] for WWID [" wwid_str "]\n")
> > +#define ALLOC_STR(alias_str, wwid_str) ("Allocated existing
> > binding [" alias_str "] for WWID [" wwid_str "]\n")
> > +#define BINDING_STR(alias_str, wwid_str) (alias_str " " wwid_str
> > "\n")
> > +#define BOUND_STR(alias_str, wwid_str) ("alias "alias_str "
> > already bound to wwid " wwid_str ", cannot reuse")
> > +#define ERR_STR(alias_str, wwid_str) ("ERROR: old alias ["
> > alias_str "] for wwid [" wwid_str "] is used by other map\n")
> > +#define REUSE_STR(alias_str, wwid_str) ("alias " alias_str "
> > already bound to wwid " wwid_str ", cannot reuse\n")
> > +#define NOMORE_STR "no more available user_friendly_names\n"
> > =A0
> > =A0static void mock_failed_alias(const char *alias, char *msg)
> > =A0{
> > @@ -421,6 +466,24 @@ static void mock_used_alias(const char *alias,
> > char *msg)
> > =A0=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, msg);
> > =A0}
> > =A0
> > +static void mock_bindings_file(const char *content, int
> > match_line)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0static char cnt[1024];
> > +=A0=A0=A0=A0=A0=A0=A0char *token;
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0assert_in_range(strlcpy(cnt, content, sizeof(cnt)=
), 0,
> > sizeof(cnt) - 1);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0for (token =3D strtok(cnt, "\n"), i =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 token && *token;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 token =3D strtok(NULL, "\n"), i++) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets,=
 token);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (match_line =3D=3D i)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, NULL);
> > +}
> > +
> > =A0static void lb_empty(void **state)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int rc;
> > @@ -1147,6 +1210,472 @@ static int test_allocate_binding(void)
> > =A0=A0=A0=A0=A0=A0=A0=A0return cmocka_run_group_tests(tests, NULL, NULL=
);
> > =A0}
> > =A0
> > +#define mock_allocate_binding(alias,
> > wwid)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0do
> > {=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0static const char ln[] =
=3D BINDING_STR(alias,
> > wwid);=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> > =A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_lseek,
> > 0);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0expect_value(__wrap_write=
, count,
> > strlen(ln));=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0expect_string(__wrap_writ=
e, buf,
> > ln);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_write,
> > strlen(ln));=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NEW_STR=
(alias,
> > wwid));=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> > +=A0=A0=A0=A0=A0=A0=A0} while (0)
> > +
> > +static void gufa_empty_new_rw(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHa");
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_allocate_binding("MPATHa", "WWID0");
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
", "MPATH",
> > false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHa");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_empty_new_ro_1(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, false);
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHa");
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
", "MPATH",
> > false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_ptr_equal(alias, NULL);
> > +}
> > +
> > +static void gufa_empty_new_ro_2(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHa");
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
", "MPATH",
> > true);
> > +=A0=A0=A0=A0=A0=A0=A0assert_ptr_equal(alias, NULL);
> > +}
> > +
> > +static void gufa_match_a_unused(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, BINDING_STR("MPATHa", "=
WWID0"));
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHa");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
", "MPATH",
> > true);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHa");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_match_a_self(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, BINDING_STR("MPATHa", "=
WWID0"));
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> > +=A0=A0=A0=A0=A0=A0=A0mock_self_alias("MPATHa", "WWID0");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
", "MPATH",
> > true);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHa");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_match_a_used(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, BINDING_STR("MPATHa", "=
WWID0"));
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
> > +=A0=A0=A0=A0=A0=A0=A0mock_used_alias("MPATHa", USED_STR("MPATHa", "WWI=
D0"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
", "MPATH",
> > true);
> > +=A0=A0=A0=A0=A0=A0=A0assert_ptr_equal(alias, NULL);
> > +}
> > +
> > +static void gufa_nomatch_a_c(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_bindings_file("MPATHa WWID0\n"
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "MPATHc WWID2",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 -1);
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHb");
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_allocate_binding("MPATHb", "WWID1");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID1", "x", "=
", "MPATH",
> > false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHb");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_nomatch_c_a(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_bindings_file("MPATHc WWID2\n"
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "MPATHa WWID0",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 -1);
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHb");
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID1"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_allocate_binding("MPATHb", "WWID1");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID1", "x", "=
", "MPATH",
> > false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHb");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_nomatch_c_b(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_bindings_file("MPATHc WWID2\n"
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "MPATHb WWID1\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 -1);
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHa");
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_allocate_binding("MPATHa", "WWID0");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
", "MPATH",
> > false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHa");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_nomatch_c_b_used(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_bindings_file("MPATHc WWID2\n"
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "MPATHb WWID1",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 -1);
> > +=A0=A0=A0=A0=A0=A0=A0mock_used_alias("MPATHa", USED_STR("MPATHa", "WWI=
D4"));
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID4"));
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHd");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_allocate_binding("MPATHd", "WWID4");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID4", "x", "=
", "MPATH",
> > false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHd");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_nomatch_b_f_a(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_bindings_file("MPATHb WWID1\n"
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "MPATHf WWID6\n"
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "MPATHa WWID0\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 -1);
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID7"));
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHg");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_allocate_binding("MPATHg", "WWID7");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID7", "x", "=
", "MPATH",
> > false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHg");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_old_empty(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* rlookup_binding for ALIAS */
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_STR("MPATHz"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* lookup_binding */
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_unused_alias("MPATHz");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_allocate_binding("MPATHz", "WWID0");
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(2, ALLOC_STR("MPATHz", "WWID0"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
MPATHz",
> > "MPATH", false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHz");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
> > +static void gufa_old_empty_self(void **state) {
> > +=A0=A0=A0=A0=A0=A0=A0char *alias;
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_open_file, true);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_STR("MPATHz"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_fgets, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
> > +=A0=A0=A0=A0=A0=A0=A0mock_self_alias("MPATHz", "WWID0");
> > +
> > +=A0=A0=A0=A0=A0=A0=A0mock_allocate_binding("MPATHz", "WWID0");
> > +=A0=A0=A0=A0=A0=A0=A0expect_condlog(2, ALLOC_STR("MPATHz", "WWID0"));
> > +
> > +=A0=A0=A0=A0=A0=A0=A0alias =3D get_user_friendly_alias("WWID0", "x", "=
MPATHz",
> > "MPATH", false);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(alias, "MPATHz");
> > +=A0=A0=A0=A0=A0=A0=A0free(alias);
> > +}
> > +
>=20
> I'm not sure this is a valid test. Neither are gufa_old_match_used()
> and
> gufa_old_nomatch_nowwidmatch_used(). Like I said, If
> get_user_friendly_alias() is called with a non-NULL alias_old, I
> think
> that means that there is current a device named alias_old with the
> expected wwid.=A0 So I don't think mock_used_alias() returning a
> non-matching WWID is possible in real life. Again, if I'm wrong and
> it
> is possible to have alias_old set without there being a dm device,
> then
> this is a reasonable test.

Let's clarify this in the discussion about patch 4/21. I think the test
itself is valid. It tests a combination of arguments / internal state
variables that shouldn't occur, but that's true for many of our unit
tests.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

