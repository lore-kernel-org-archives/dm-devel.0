Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03B0C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:24:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6982860F43
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 15:24:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6982860F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627572275;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/vA7A9zxUa4QYVpX4FOyVQ3bqz3B4ypYUFS4NbMrh6E=;
	b=ixhO84hIjTJOd+rDID2QL5wnf82N7GmZxdfRNO3r7hHt7UtRpUE7VU8fOMniyWe1lkPhv7
	lTOkJAPNtcjAr1j+s/pbcT6Bep+FHd9+Mjztw1LB9uXwhHzkftrNEw0M+jsVlVpbbTh1Bt
	E/wQ6/ALKh8W7781LVPxTz0X6u+DCYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-ydC4FU5tN3KCYpNdXyHP6A-1; Thu, 29 Jul 2021 11:24:33 -0400
X-MC-Unique: ydC4FU5tN3KCYpNdXyHP6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1FFA910ECB;
	Thu, 29 Jul 2021 15:23:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35742369A;
	Thu, 29 Jul 2021 15:23:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A6D4180B7A2;
	Thu, 29 Jul 2021 15:23:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TFNC0m004018 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 11:23:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4A5843AC1; Thu, 29 Jul 2021 15:23:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 002336B555;
	Thu, 29 Jul 2021 15:22:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 16TFMZYe017538; 
	Thu, 29 Jul 2021 10:22:35 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 16TFMYQW017537;
	Thu, 29 Jul 2021 10:22:34 -0500
Date: Thu, 29 Jul 2021 10:22:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210729152234.GP3087@octiron.msp.redhat.com>
References: <20210715105223.30463-1-mwilck@suse.com>
	<20210715105223.30463-9-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210715105223.30463-9-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 8/9] libmultipath: use strbuf in alias.c.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jul 15, 2021 at 12:52:22PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> We can avoid some buffer length checks here, too. Also, simplify the
> implementation of format_devname().
> 
> Created a wrapper for the format_devname() test case, to avoid chaning
> the test cases themselves.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/alias.c | 84 +++++++++++++++++++-------------------------
>  tests/alias.c        | 41 +++++++++++++--------
>  2 files changed, 63 insertions(+), 62 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 02bc9d6..ad7e512 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -22,7 +22,7 @@
>  #include "util.h"
>  #include "errno.h"
>  #include "devmapper.h"
> -
> +#include "strbuf.h"
>  
>  /*
>   * significant parts of this file were taken from iscsi-bindings.c of the
> @@ -61,31 +61,23 @@ valid_alias(const char *alias)
>  	return 1;
>  }
>  
> -
> -static int
> -format_devname(char *name, int id, int len, const char *prefix)
> +static int format_devname(struct strbuf *buf, int id)
>  {
> -	int pos;
> -	int prefix_len = strlen(prefix);
> +	/*
> +	 * We need: 7 chars for 32bit integers, 14 chars for 64bit integers
> +	 */
> +	char devname[2 * sizeof(int)];
> +	int pos = sizeof(devname) - 1, rc;
>  
> -	if (len <= prefix_len + 1 || id <= 0)
> +	if (id <= 0)
>  		return -1;
>  
> -	memset(name, 0, len);
> -	strcpy(name, prefix);
> -	name[len - 1] = '\0';
> -	for (pos = len - 2; pos >= prefix_len; pos--) {
> -		id--;
> -		name[pos] = 'a' + id % 26;
> -		if (id < 26)
> -			break;
> -		id /= 26;
> -	}
> -	if (pos < prefix_len)
> -		return -1;
> +	devname[pos] = '\0';
> +	for (; id >= 1; id /= 26)
> +		devname[--pos] = 'a' + --id % 26;
>  
> -	memmove(name + prefix_len, name + pos, len - pos);
> -	return (prefix_len + len - pos - 1);
> +	rc = append_strbuf_str(buf, devname + pos);
> +	return rc >= 0 ? rc : -1;
>  }
>  
>  static int
> @@ -123,11 +115,14 @@ scan_devname(const char *alias, const char *prefix)
>  static int
>  id_already_taken(int id, const char *prefix, const char *map_wwid)
>  {
> -	char alias[LINE_MAX];
> +	STRBUF_ON_STACK(buf);
> +	const char *alias;
>  
> -	if (format_devname(alias, id, LINE_MAX, prefix) < 0)
> +	if (append_strbuf_str(&buf, prefix) < 0 ||
> +	    format_devname(&buf, id) < 0)
>  		return 0;
>  
> +	alias = get_strbuf_str(&buf);
>  	if (dm_map_present(alias)) {
>  		char wwid[WWID_SIZE];
>  
> @@ -285,10 +280,10 @@ rlookup_binding(FILE *f, char *buff, const char *map_alias)
>  static char *
>  allocate_binding(int fd, const char *wwid, int id, const char *prefix)
>  {
> -	char buf[LINE_MAX];
> +	STRBUF_ON_STACK(buf);
>  	off_t offset;
> +	ssize_t len;
>  	char *alias, *c;
> -	int i;
>  
>  	if (id <= 0) {
>  		condlog(0, "%s: cannot allocate new binding for id %d",
> @@ -296,16 +291,12 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
>  		return NULL;
>  	}
>  
> -	i = format_devname(buf, id, LINE_MAX, prefix);
> -	if (i == -1)
> +	if (append_strbuf_str(&buf, prefix) < 0 ||
> +	    format_devname(&buf, id) == -1)
>  		return NULL;
>  
> -	c = buf + i;
> -	if (snprintf(c, LINE_MAX - i, " %s\n", wwid) >= LINE_MAX - i) {
> -		condlog(1, "%s: line too long for %s\n", __func__, wwid);
> +	if (print_strbuf(&buf, " %s\n", wwid) < 0)
>  		return NULL;
> -	}
> -	buf[LINE_MAX - 1] = '\0';
>  
>  	offset = lseek(fd, 0, SEEK_END);
>  	if (offset < 0){
> @@ -313,24 +304,25 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
>  			strerror(errno));
>  		return NULL;
>  	}
> -	if (write(fd, buf, strlen(buf)) != (ssize_t)strlen(buf)){
> +
> +	len = get_strbuf_len(&buf);
> +	alias = steal_strbuf_str(&buf);
> +
> +	if (write(fd, alias, len) != len) {
>  		condlog(0, "Cannot write binding to bindings file : %s",
>  			strerror(errno));
>  		/* clear partial write */
>  		if (ftruncate(fd, offset))
>  			condlog(0, "Cannot truncate the header : %s",
>  				strerror(errno));
> +		free(alias);
>  		return NULL;
>  	}
> -	c = strchr(buf, ' ');
> +	c = strchr(alias, ' ');
>  	if (c)
>  		*c = '\0';
>  
> -	condlog(3, "Created new binding [%s] for WWID [%s]", buf, wwid);
> -	alias = strdup(buf);
> -	if (alias == NULL)
> -		condlog(0, "cannot copy new alias from bindings file: out of memory");
> -
> +	condlog(3, "Created new binding [%s] for WWID [%s]", alias, wwid);
>  	return alias;
>  }
>  
> @@ -560,7 +552,7 @@ static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
>  static int write_bindings_file(const Bindings *bindings, int fd)
>  {
>  	struct binding *bnd;
> -	char line[LINE_MAX];
> +	STRBUF_ON_STACK(line);
>  	int i;
>  
>  	if (write(fd, BINDINGS_FILE_HEADER, sizeof(BINDINGS_FILE_HEADER) - 1)
> @@ -570,16 +562,12 @@ static int write_bindings_file(const Bindings *bindings, int fd)
>  	vector_foreach_slot(bindings, bnd, i) {
>  		int len;
>  
> -		len = snprintf(line, sizeof(line), "%s %s\n",
> -			       bnd->alias, bnd->wwid);
> -
> -		if (len < 0 || (size_t)len >= sizeof(line)) {
> -			condlog(1, "%s: line overflow", __func__);
> +		if ((len = print_strbuf(&line, "%s %s\n",
> +					bnd->alias, bnd->wwid)) < 0)
>  			return -1;
> -		}
> -
> -		if (write(fd, line, len) != len)
> +		if (write(fd, get_strbuf_str(&line), len) != len)
>  			return -1;
> +		truncate_strbuf(&line, 0);
>  	}
>  	return 0;
>  }
> diff --git a/tests/alias.c b/tests/alias.c
> index 7e7c187..3ca6c28 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -81,12 +81,25 @@ int __wrap_dm_get_uuid(const char *name, char *uuid, int uuid_len)
>  	return ret;
>  }
>  
> +/* strbuf wrapper for the old format_devname() */
> +static int __format_devname(char *name, int id, size_t len, const char *prefix)
> +{
> +	STRBUF_ON_STACK(buf);
> +
> +	if (append_strbuf_str(&buf, prefix) < 0 ||
> +	    format_devname(&buf, id) < 0 ||
> +	    len <= get_strbuf_len(&buf))
> +		return -1;
> +	strcpy(name, get_strbuf_str(&buf));
> +	return get_strbuf_len(&buf);
> +}
> +
>  static void fd_mpatha(void **state)
>  {
>  	char buf[32];
>  	int rc;
>  
> -	rc = format_devname(buf, 1, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 1, sizeof(buf), "FOO");
>  	assert_int_equal(rc, 4);
>  	assert_string_equal(buf, "FOOa");
>  }
> @@ -97,7 +110,7 @@ static void fd_mpathz(void **state)
>  	char buf[5];
>  	int rc;
>  
> -	rc = format_devname(buf, 26, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 26, sizeof(buf), "FOO");
>  	assert_int_equal(rc, 4);
>  	assert_string_equal(buf, "FOOz");
>  }
> @@ -107,7 +120,7 @@ static void fd_mpathaa(void **state)
>  	char buf[32];
>  	int rc;
>  
> -	rc = format_devname(buf, 26 + 1, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 26 + 1, sizeof(buf), "FOO");
>  	assert_int_equal(rc, 5);
>  	assert_string_equal(buf, "FOOaa");
>  }
> @@ -117,7 +130,7 @@ static void fd_mpathzz(void **state)
>  	char buf[32];
>  	int rc;
>  
> -	rc = format_devname(buf, 26*26 + 26, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 26*26 + 26, sizeof(buf), "FOO");
>  	assert_int_equal(rc, 5);
>  	assert_string_equal(buf, "FOOzz");
>  }
> @@ -127,7 +140,7 @@ static void fd_mpathaaa(void **state)
>  	char buf[32];
>  	int rc;
>  
> -	rc = format_devname(buf, 26*26 + 27, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 26*26 + 27, sizeof(buf), "FOO");
>  	assert_int_equal(rc, 6);
>  	assert_string_equal(buf, "FOOaaa");
>  }
> @@ -137,7 +150,7 @@ static void fd_mpathzzz(void **state)
>  	char buf[32];
>  	int rc;
>  
> -	rc = format_devname(buf, 26*26*26 + 26*26 + 26, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 26*26*26 + 26*26 + 26, sizeof(buf), "FOO");
>  	assert_int_equal(rc, 6);
>  	assert_string_equal(buf, "FOOzzz");
>  }
> @@ -147,7 +160,7 @@ static void fd_mpathaaaa(void **state)
>  	char buf[32];
>  	int rc;
>  
> -	rc = format_devname(buf, 26*26*26 + 26*26 + 27, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 26*26*26 + 26*26 + 27, sizeof(buf), "FOO");
>  	assert_int_equal(rc, 7);
>  	assert_string_equal(buf, "FOOaaaa");
>  }
> @@ -157,7 +170,7 @@ static void fd_mpathzzzz(void **state)
>  	char buf[32];
>  	int rc;
>  
> -	rc = format_devname(buf, 26*26*26*26 + 26*26*26 + 26*26 + 26,
> +	rc = __format_devname(buf, 26*26*26*26 + 26*26*26 + 26*26 + 26,
>  			    sizeof(buf), "FOO");
>  	assert_int_equal(rc, 7);
>  	assert_string_equal(buf, "FOOzzzz");
> @@ -169,7 +182,7 @@ static void fd_mpath_max(void **state)
>  	char buf[32];
>  	int rc;
>  
> -	rc  = format_devname(buf, INT_MAX, sizeof(buf), "");
> +	rc  = __format_devname(buf, INT_MAX, sizeof(buf), "");
>  	assert_int_equal(rc, strlen(MPATH_ID_INT_MAX));
>  	assert_string_equal(buf, MPATH_ID_INT_MAX);
>  }
> @@ -180,7 +193,7 @@ static void fd_mpath_max1(void **state)
>  	char buf[32];
>  	int rc;
>  
> -	rc  = format_devname(buf, INT_MIN, sizeof(buf), "");
> +	rc  = __format_devname(buf, INT_MIN, sizeof(buf), "");
>  	assert_int_equal(rc, -1);
>  }
>  
> @@ -189,7 +202,7 @@ static void fd_mpath_short(void **state)
>  	char buf[4];
>  	int rc;
>  
> -	rc = format_devname(buf, 1, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 1, sizeof(buf), "FOO");
>  	assert_int_equal(rc, -1);
>  }
>  
> @@ -198,7 +211,7 @@ static void fd_mpath_short1(void **state)
>  	char buf[5];
>  	int rc;
>  
> -	rc = format_devname(buf, 27, sizeof(buf), "FOO");
> +	rc = __format_devname(buf, 27, sizeof(buf), "FOO");
>  	assert_int_equal(rc, -1);
>  }
>  
> @@ -323,7 +336,7 @@ static void sd_fd_many(void **state)
>  	int rc, i;
>  
>  	for (i = 1; i < 5000; i++) {
> -		rc = format_devname(buf, i, sizeof(buf), "MPATH");
> +		rc = __format_devname(buf, i, sizeof(buf), "MPATH");
>  		assert_in_range(rc, 6, 8);
>  		rc = scan_devname(buf, "MPATH");
>  		assert_int_equal(rc, i);
> @@ -338,7 +351,7 @@ static void sd_fd_random(void **state)
>  	srandom(1);
>  	for (i = 1; i < 1000; i++) {
>  		n = random() & 0xffff;
> -		rc = format_devname(buf, n, sizeof(buf), "MPATH");
> +		rc = __format_devname(buf, n, sizeof(buf), "MPATH");
>  		assert_in_range(rc, 6, 9);
>  		rc = scan_devname(buf, "MPATH");
>  		assert_int_equal(rc, n);
> -- 
> 2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

