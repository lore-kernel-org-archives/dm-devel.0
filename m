Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15A1137C41
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712936533; cv=none; b=S7VRDXH6NLvvuYVBTVR/ggDuLLU8wTLY9Y30dM2YU8BvnJuj96RBocC6KWwq1NAYALPLl56qbWQ95H+0eK7WjKv3pchi4q50qz/rFBEayxCMvbfnWRBNy+6pLFoyLqwTKJOLmf1Jyo8sM4UebH6TKyexmBuuy1KSFnWigr2J/sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712936533; c=relaxed/simple;
	bh=ewJIaQ6f6HnnIizgfryTtIwKVHT8IR6mzVajXoPzGZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=iy2xJNLq9C4ARQem1oCSmE4ZMhBfJAuqi1qf3hEFNN6YM8zd4O9IguurUcdrjuWUTByhFLE5bb0szhnohh2BW/OxpDhv6b7zzj9MFMqqVdJHdTWEs4sf/FJUSAHhhp2VYTK40qyieRg9jZkGmX8gWv+AVnFs3AYARodBm65jkCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JALzhXyJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JALzhXyJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712936530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w5VqzDlNTE9EsRGSgaHU3Ay+hMCb71fLZfa3aE2dI+U=;
	b=JALzhXyJTbOC3cMkFCh6kcebdidL3eoRNek9RAGBGeMHr44baZ1hHYiTXiV2mkUdpg/tYj
	TKzVpw/Y8tqY4sswXijmeqFQs6J6l+NAEIVtSha4XwsxGf4ylLxpLQ6zruL+47/VIFY7lq
	rxygBz7017VZxT6oM2BSS527lRt3wiA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-oloASKoBMBmTAQ3kxU2ohA-1; Fri, 12 Apr 2024 11:42:08 -0400
X-MC-Unique: oloASKoBMBmTAQ3kxU2ohA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E34C480171B;
	Fri, 12 Apr 2024 15:42:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCA162026D06;
	Fri, 12 Apr 2024 15:42:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43CFg7um1871695
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Apr 2024 11:42:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43CFg7F41871694;
	Fri, 12 Apr 2024 11:42:07 -0400
Date: Fri, 12 Apr 2024 11:42:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] multipath-tools tests: fix CI failures with clang on
 Fedora Rawhide
Message-ID: <ZhlWT2nlEtpbUdUZ@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240412093258.20037-1-mwilck@suse.com>
 <20240412093258.20037-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240412093258.20037-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 12, 2024 at 11:32:58AM +0200, Martin Wilck wrote:
> Fedora's glibc 2.39 includes the following patch:
> 
> https://patches.linaro.org/project/libc-alpha/patch/20240208184622.332678-10-adhemerval.zanella@linaro.org/
> 
> It causes open("file", O_RDONLY) to resolve to __open64_2(),
> whereas it resolves to open64() with gcc, causing CI failures because of
> wrong wrapper substitutions.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  tests/dmevents.c |  6 ++---
>  tests/sysfs.c    | 58 ++++++++++++++++++++++++------------------------
>  tests/test-lib.c |  6 ++---
>  tests/wrap64.h   | 14 ++++++++++++
>  4 files changed, 49 insertions(+), 35 deletions(-)
> 
> diff --git a/tests/dmevents.c b/tests/dmevents.c
> index 540bf0d..395b16d 100644
> --- a/tests/dmevents.c
> +++ b/tests/dmevents.c
> @@ -207,7 +207,7 @@ static int teardown(void **state)
>  	return 0;
>  }
>  
> -int WRAP_FUNC(open)(const char *pathname, int flags)
> +int WRAP_OPEN(const char *pathname, int flags)
>  {
>  	assert_ptr_equal(pathname, "/dev/mapper/control");
>  	assert_int_equal(flags, O_RDWR);
> @@ -389,7 +389,7 @@ static void test_init_waiter_bad1(void **state)
>  	struct test_data *datap = (struct test_data *)(*state);
>  	if (datap == NULL)
>  		skip();
> -	wrap_will_return(WRAP_FUNC(open), -1);
> +	wrap_will_return(WRAP_OPEN, -1);
>  	assert_int_equal(init_dmevent_waiter(&datap->vecs), -1);
>  	assert_ptr_equal(waiter, NULL);
>  }
> @@ -400,7 +400,7 @@ static void test_init_waiter_good0(void **state)
>  	struct test_data *datap = (struct test_data *)(*state);
>  	if (datap == NULL)
>  		skip();
> -	wrap_will_return(WRAP_FUNC(open), 2);
> +	wrap_will_return(WRAP_OPEN, 2);
>  	assert_int_equal(init_dmevent_waiter(&datap->vecs), 0);
>  	assert_ptr_not_equal(waiter, NULL);
>  }
> diff --git a/tests/sysfs.c b/tests/sysfs.c
> index fc256d8..c623d1b 100644
> --- a/tests/sysfs.c
> +++ b/tests/sysfs.c
> @@ -29,7 +29,7 @@ char *__wrap_udev_device_get_syspath(struct udev_device *ud)
>  	return val;
>  }
>  
> -int WRAP_FUNC(open)(const char *pathname, int flags)
> +int WRAP_OPEN(const char *pathname, int flags)
>  {
>  	int ret;
>  
> @@ -167,10 +167,10 @@ static void test_sagv_open_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> -	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> +	expect_string(WRAP_OPEN, pathname, "/foo/bar");
> +	expect_value(WRAP_OPEN, flags, O_RDONLY);
>  	errno = ENOENT;
> -	wrap_will_return(WRAP_FUNC(open), -1);
> +	wrap_will_return(WRAP_OPEN, -1);
>  	expect_condlog(3, "__sysfs_attr_get_value: attribute '/foo/bar' cannot be opened");
>  	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
>  					      buf, sizeof(buf)), -ENOENT);
> @@ -182,9 +182,9 @@ static void test_sagv_read_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> -	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> -	wrap_will_return(WRAP_FUNC(open), TEST_FD);
> +	expect_string(WRAP_OPEN, pathname, "/foo/bar");
> +	expect_value(WRAP_OPEN, flags, O_RDONLY);
> +	wrap_will_return(WRAP_OPEN, TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, sizeof(buf));
>  	errno = EISDIR;
> @@ -197,9 +197,9 @@ static void test_sagv_read_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/baz'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/baz");
> -	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> -	wrap_will_return(WRAP_FUNC(open), TEST_FD);
> +	expect_string(WRAP_OPEN, pathname, "/foo/baz");
> +	expect_value(WRAP_OPEN, flags, O_RDONLY);
> +	wrap_will_return(WRAP_OPEN, TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, sizeof(buf));
>  	errno = EPERM;
> @@ -223,9 +223,9 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
>  	memset(buf, '.', sizeof(buf));
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> -	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> -	wrap_will_return(WRAP_FUNC(open), TEST_FD);
> +	expect_string(WRAP_OPEN, pathname, "/foo/bar");
> +	expect_value(WRAP_OPEN, flags, O_RDONLY);
> +	wrap_will_return(WRAP_OPEN, TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, bufsz);
>  	will_return(__wrap_read, sizeof(input) - 1);
> @@ -250,9 +250,9 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
>  	memset(buf, '.', sizeof(buf));
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/baz'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/baz");
> -	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> -	wrap_will_return(WRAP_FUNC(open), TEST_FD);
> +	expect_string(WRAP_OPEN, pathname, "/foo/baz");
> +	expect_value(WRAP_OPEN, flags, O_RDONLY);
> +	wrap_will_return(WRAP_OPEN, TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, bufsz);
>  	will_return(__wrap_read, sizeof(input) - 1);
> @@ -301,9 +301,9 @@ static void _test_sagv_read_zeroes(void **state, unsigned int bufsz)
>  	memset(buf, '.', sizeof(buf));
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> -	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> -	wrap_will_return(WRAP_FUNC(open), TEST_FD);
> +	expect_string(WRAP_OPEN, pathname, "/foo/bar");
> +	expect_value(WRAP_OPEN, flags, O_RDONLY);
> +	wrap_will_return(WRAP_OPEN, TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, bufsz);
>  	will_return(__wrap_read, sizeof(input) - 1);
> @@ -386,10 +386,10 @@ static void test_sasv_open_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> -	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
> +	expect_string(WRAP_OPEN, pathname, "/foo/bar");
> +	expect_value(WRAP_OPEN, flags, O_WRONLY);
>  	errno = EPERM;
> -	wrap_will_return(WRAP_FUNC(open), -1);
> +	wrap_will_return(WRAP_OPEN, -1);
>  	expect_condlog(3, "sysfs_attr_set_value: attribute '/foo/bar' cannot be opened");
>  	assert_int_equal(sysfs_attr_set_value((void *)state, "bar",
>  					      buf, sizeof(buf)), -EPERM);
> @@ -401,9 +401,9 @@ static void test_sasv_write_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> -	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
> -	wrap_will_return(WRAP_FUNC(open), TEST_FD);
> +	expect_string(WRAP_OPEN, pathname, "/foo/bar");
> +	expect_value(WRAP_OPEN, flags, O_WRONLY);
> +	wrap_will_return(WRAP_OPEN, TEST_FD);
>  	expect_value(__wrap_write, fd, TEST_FD);
>  	expect_value(__wrap_write, count, sizeof(buf));
>  	errno = EISDIR;
> @@ -422,9 +422,9 @@ static void _test_sasv_write(void **state, unsigned int n_written)
>  	assert_in_range(n_written, 0, sizeof(buf));
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> -	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
> -	wrap_will_return(WRAP_FUNC(open), TEST_FD);
> +	expect_string(WRAP_OPEN, pathname, "/foo/bar");
> +	expect_value(WRAP_OPEN, flags, O_WRONLY);
> +	wrap_will_return(WRAP_OPEN, TEST_FD);
>  	expect_value(__wrap_write, fd, TEST_FD);
>  	expect_value(__wrap_write, count, sizeof(buf));
>  	will_return(__wrap_write, n_written);
> @@ -489,7 +489,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> -	init_test_verbosity(4);
> +	init_test_verbosity(5);
>  	ret += test_sysfs();
>  	return ret;
>  }
> diff --git a/tests/test-lib.c b/tests/test-lib.c
> index 665d438..cdb2780 100644
> --- a/tests/test-lib.c
> +++ b/tests/test-lib.c
> @@ -40,17 +40,17 @@ const char default_wwid_1[] = "TEST-WWID-1";
>   */
>  
>  
> -int REAL_FUNC(open)(const char *path, int flags, int mode);
> +int REAL_OPEN(const char *path, int flags, int mode);
>  
>  static const char _mocked_filename[] = "mocked_path";
>  
> -int WRAP_FUNC(open)(const char *path, int flags, int mode)
> +int WRAP_OPEN(const char *path, int flags, int mode)
>  {
>  	condlog(4, "%s: %s", __func__, path);
>  
>  	if (!strcmp(path, _mocked_filename))
>  		return 111;
> -	return REAL_FUNC(open)(path, flags, mode);
> +	return REAL_OPEN(path, flags, mode);
>  }
>  
>  int __wrap_libmp_get_version(int which, unsigned int version[3])
> diff --git a/tests/wrap64.h b/tests/wrap64.h
> index 6b92751..b1dfa38 100644
> --- a/tests/wrap64.h
> +++ b/tests/wrap64.h
> @@ -29,6 +29,20 @@
>  #define WRAP_FUNC(x) CONCAT2(__wrap_, WRAP_NAME(x))
>  #define REAL_FUNC(x) CONCAT2(__real_, WRAP_NAME(x))
>  
> +/*
> + * With clang, glibc 2.39, and _FILE_OFFSET_BITS==64,
> + * open() resolves to __open64_2().
> + */
> +#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 39) && \
> +	defined(__clang__) && __clang__ == 1 && \
> +	defined(__fortify_use_clang) && __fortify_use_clang == 1
> +#define WRAP_OPEN_NAME __open64_2
> +#else
> +#define WRAP_OPEN_NAME WRAP_NAME(open)
> +#endif
> +#define WRAP_OPEN CONCAT2(__wrap_, WRAP_OPEN_NAME)
> +#define REAL_OPEN CONCAT2(__real_, WRAP_OPEN_NAME)
> +
>  /*
>   * fcntl() needs special treatment; fcntl64() has been introduced in 2.28.
>   * https://savannah.gnu.org/forum/forum.php?forum_id=9205
> -- 
> 2.44.0

