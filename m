Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED0A22626
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 23:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721085915; cv=none; b=JAFUnYwmowPdSkfKUpR6WPBGgEzAcVaU3/7S8P1KIoHZnVZR19uZaT90a3ZFfBE6G5Y2qUU2U9W58LZcsND5GbNj10s5vQ1mei3L2md12mLtTR5kHI/XXlz8jD8wpOxt0Yui6lRpgTa1FqNDnPo+NtYXyUeo1kkkGUZsQjO/2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721085915; c=relaxed/simple;
	bh=J85k2oZr4HrVdsT9FQyNvwvApeT/H5r8FeZ/5UPBBIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=g73HC621I0adKMnOQ3PmFSI9Kav1hFycAFJAGdJLojFppGBQ8sadzyCYcuD7vkFcU9PcHQFJuRR0lPJgId16Gnh/NS03Zr5Z0559C5qLS2/NlP9olrJFlwa8PE7Od9P/la95IQTK5cAqOMcwerxLMhum9yxikmfd4yuvRM/oZkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A0YfAJrP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0YfAJrP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721085911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tgyp0tNmXnbxvW5ugkLKi4jBSPSyDSjRq/jIPz9qOvM=;
	b=A0YfAJrPARa/W1N0oOiURb+Y2CqeX5qiOiQOCVU21ElhZw7Xxh932gMjnIvCu+rwauo+JY
	JE1FstyrhjSepGWZ9a/LC4cN+TcGDSVYKMzOKBzoO2qPwXQf/0B1Yx6cqdWIoP42urOLdb
	I8Fon6UqlrzIOjp5X8juoVD9qyX5E8w=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-Ot7uaWzaNDec2bXs7oP5Bg-1; Mon,
 15 Jul 2024 19:25:08 -0400
X-MC-Unique: Ot7uaWzaNDec2bXs7oP5Bg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 635721955D45;
	Mon, 15 Jul 2024 23:25:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBF06195605A;
	Mon, 15 Jul 2024 23:25:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FNP53M2097848
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 19:25:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FNP5FP2097847;
	Mon, 15 Jul 2024 19:25:05 -0400
Date: Mon, 15 Jul 2024 19:25:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 49/49] multipath-tools tests: fix directio test with
 real device
Message-ID: <ZpWv0eZdmjbNtS0q@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-50-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-50-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:57PM +0200, Martin Wilck wrote:
> Allow setting DIO_TEST_DEV during runtime, by reading the environment
> variable. The test was fragile despite the delay, because the real
> io_getevents() call isn't guaranteed to return the number of events
> requested. Fix that. Moreover, allow reading DIO_TEST_DELAY (in us)
> from the environment. With the io_getevents fix, for me the test
> succeeded even with 0 us delay.
> 
> Change the README accordingly.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/Makefile   |   8 ---
>  tests/README.md  |  29 ++++++--
>  tests/directio.c | 182 ++++++++++++++++++++++++++---------------------
>  3 files changed, 122 insertions(+), 97 deletions(-)
> 
> diff --git a/tests/Makefile b/tests/Makefile
> index 55fbf0f..02580e7 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -21,12 +21,6 @@ valgrind:	$(TESTS:%=%.vgr)
>  # test-specific compiler flags
>  # XYZ-test_FLAGS: Additional compiler flags for this test
>  
> -ifneq ($(wildcard directio_test_dev),)
> -DIO_TEST_DEV = $(shell sed -n -e 's/^[[:space:]]*DIO_TEST_DEV[[:space:]]*=[[:space:]]*\([^[:space:]\#]\+\).*/\1/p' < directio_test_dev)
> -endif
> -ifneq ($(DIO_TEST_DEV),)
> -directio-test_FLAGS := -DDIO_TEST_DEV=\"$(DIO_TEST_DEV)\"
> -endif
>  mpathvalid-test_FLAGS := -I$(mpathvaliddir)
>  features-test_FLAGS := -I$(multipathdir)/nvme
>  
> @@ -59,9 +53,7 @@ valid-test_LIBDEPS := -lmount -ludev -lpthread -ldl
>  devt-test_LIBDEPS := -ludev
>  mpathvalid-test_LIBDEPS := -ludev -lpthread -ldl
>  mpathvalid-test_OBJDEPS := $(mpathvaliddir)/mpath_valid.o
> -ifneq ($(DIO_TEST_DEV),)
>  directio-test_LIBDEPS := -laio
> -endif
>  strbuf-test_OBJDEPS := $(mpathutildir)/strbuf.o
>  sysfs-test_TESTDEPS := test-log.o
>  sysfs-test_OBJDEPS := $(multipathdir)/sysfs.o $(mpathutildir)/util.o
> diff --git a/tests/README.md b/tests/README.md
> index fd36fc1..0cae057 100644
> --- a/tests/README.md
> +++ b/tests/README.md
> @@ -13,6 +13,17 @@ If valgrind detects a bad memory access or leak, the test will fail. The
>  output of the test run, including valgrind output, is stored as
>  `<testname>.vgr`.
>  
> +## Running tests manually
> +
> +`make test` or `make -C test "$TEST.out"` will only run the test program if
> +the output files `$TEST.out` don't exist yet. To re-run the test, delete the
> +output file first. In order to run a test outside `make`, set the library
> +search path:
> +
> +    cd tests
> +    export LD_LIBRARY_PATH=.:../libmpathutil:../libmpathcmd
> +	./dmevents-test  # or whatever other test you want to run
> +
>  ## Controlling verbosity for unit tests
>  
>  Some test programs use the environment variable `MPATHTEST_VERBOSITY` to
> @@ -37,15 +48,21 @@ This test includes test items that require a access to a block device. The
>  device will be opened in read-only mode; you don't need to worry about data
>  loss. However, the user needs to specify a device to be used. Set the
>  environment variable `DIO_TEST_DEV` to the path of the device.
> -Alternatively, create a file `directio_test_dev` under
> -the `tests` directory containing a single line that sets this environment
> -variable in Bourne Shell syntax, like this:
> -
> -    DIO_TEST_DEV=/dev/sdc3
> -
>  After that, run `make directio.out` as root in the `tests` directory to
>  perform the test.
>  
> +With a real test device, the test results may note be 100% reproducible,
> +and sporadic test failures may occur under certain circumstances.
> +It may be necessary to introduce a certain delay between test
> +operations. To do so, set the environment variable `DIO_TEST_DELAY` to a
> +positive integer that determines the delay (in microseconds) after each
> +`io_submit()` operation. The default delay is 10 microseconds.
> +
> +*Note:* `DIO_TEST_DEV` doesn't have to be set during compilation of
> +`directio-test`. This used to be the case in previous versions of
> +multipath-tools. Previously, it was possible to set `DIO_TEST_DEV` in a file
> +`tests/directio_test_dev`. This is not supported any more.
> +
>  ## Adding tests
>  
>  The unit tests are based on the [cmocka test framework](https://cmocka.org/),
> diff --git a/tests/directio.c b/tests/directio.c
> index d5f84f1..763929e 100644
> --- a/tests/directio.c
> +++ b/tests/directio.c
> @@ -34,6 +34,8 @@ struct io_event mock_events[AIO_GROUP_SIZE]; /* same as the checker max */
>  int ev_off = 0;
>  struct timespec zero_timeout = { .tv_sec = 0 };
>  struct timespec full_timeout = { .tv_sec = -1 };
> +const char *test_dev = NULL;
> +unsigned int test_delay = 10000;
>  
>  #ifdef __GLIBC__
>  #define ioctl_request_t unsigned long
> @@ -45,12 +47,13 @@ int REAL_IOCTL(int fd, ioctl_request_t request, void *argp);
>  
>  int WRAP_IOCTL(int fd, ioctl_request_t request, void *argp)
>  {
> -#ifdef DIO_TEST_DEV
> -	mock_type(int);
> -	return REAL_IOCTL(fd, request, argp);
> -#else
>  	int *blocksize = (int *)argp;
>  
> +	if (test_dev) {
> +		mock_type(int);
> +		return REAL_IOCTL(fd, request, argp);
> +	}
> +
>  	assert_int_equal(fd, test_fd);
>  	/*
>  	 * On MUSL libc, the "request" arg is an int (glibc: unsigned long).
> @@ -64,88 +67,80 @@ int WRAP_IOCTL(int fd, ioctl_request_t request, void *argp)
>  	assert_non_null(blocksize);
>  	*blocksize = mock_type(int);
>  	return 0;
> -#endif
>  }
>  
>  int REAL_FCNTL (int fd, int cmd, long arg);
>  
>  int WRAP_FCNTL (int fd, int cmd, long arg)
>  {
> -#ifdef DIO_TEST_DEV
> -	return REAL_FCNTL(fd, cmd, arg);
> -#else
> +	if (test_dev)
> +		return REAL_FCNTL(fd, cmd, arg);
>  	assert_int_equal(fd, test_fd);
>  	assert_int_equal(cmd, F_GETFL);
>  	return O_DIRECT;
> -#endif
>  }
>  
>  int __real___fxstat(int ver, int fd, struct stat *statbuf);
>  
>  int __wrap___fxstat(int ver, int fd, struct stat *statbuf)
>  {
> -#ifdef DIO_TEST_DEV
> -	return __real___fxstat(ver, fd, statbuf);
> -#else
> +	if (test_dev)
> +		return __real___fxstat(ver, fd, statbuf);
> +
>  	assert_int_equal(fd, test_fd);
>  	assert_non_null(statbuf);
>  	memset(statbuf, 0, sizeof(struct stat));
>  	return 0;
> -#endif
> +
>  }
>  
>  int __real_io_setup(int maxevents, io_context_t *ctxp);
>  
>  int __wrap_io_setup(int maxevents, io_context_t *ctxp)
>  {
> -	ioctx_count++;
> -#ifdef DIO_TEST_DEV
>  	int ret = mock_type(int);
> -	assert_int_equal(ret, __real_io_setup(maxevents, ctxp));
> +
> +	if (test_dev)
> +		assert_int_equal(ret, __real_io_setup(maxevents, ctxp));
> +	ioctx_count++;
>  	return ret;
> -#else
> -	return mock_type(int);
> -#endif
>  }
>  
>  int __real_io_destroy(io_context_t ctx);
>  
>  int __wrap_io_destroy(io_context_t ctx)
>  {
> -	ioctx_count--;
> -#ifdef DIO_TEST_DEV
>  	int ret = mock_type(int);
> -	assert_int_equal(ret, __real_io_destroy(ctx));
> +
> +	ioctx_count--;
> +	if (test_dev)
> +		assert_int_equal(ret, __real_io_destroy(ctx));
> +
>  	return ret;
> -#else
> -	return mock_type(int);
> -#endif
>  }
>  
>  int __real_io_submit(io_context_t ctx, long nr, struct iocb *ios[]);
>  
>  int __wrap_io_submit(io_context_t ctx, long nr, struct iocb *ios[])
>  {
> -#ifdef DIO_TEST_DEV
> -	struct timespec dev_delay = { .tv_nsec = 100000 };
>  	int ret = mock_type(int);
> -	assert_int_equal(ret, __real_io_submit(ctx, nr, ios));
> -	nanosleep(&dev_delay, NULL);
> +
> +	if (test_dev) {
> +		struct timespec dev_delay = { .tv_nsec = test_delay };
> +		assert_int_equal(ret, __real_io_submit(ctx, nr, ios));
> +		nanosleep(&dev_delay, NULL);
> +	}
>  	return ret;
> -#else
> -	return mock_type(int);
> -#endif
>  }
>  
>  int __real_io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt);
>  
>  int __wrap_io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt)
>  {
> -#ifdef DIO_TEST_DEV
> -	return __real_io_cancel(ctx, iocb, evt);
> -#else
> -	return 0;
> -#endif
> +	if (test_dev)
> +		return __real_io_cancel(ctx, iocb, evt);
> +	else
> +		return 0;
>  }
>  
>  int REAL_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
> @@ -155,38 +150,43 @@ int WRAP_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
>  			struct io_event *events, struct timespec *timeout)
>  {
>  	int nr_evs;
> -#ifndef DIO_TEST_DEV
>  	struct timespec *sleep_tmo;
>  	int i;
>  	struct io_event *evs;
> -#endif
>  
>  	assert_non_null(timeout);
>  	nr_evs = mock_type(int);
>  	assert_true(nr_evs <= nr);
>  	if (!nr_evs)
>  		return 0;
> -#ifdef DIO_TEST_DEV
> -	mock_ptr_type(struct timespec *);
> -	mock_ptr_type(struct io_event *);
> -	assert_int_equal(nr_evs, REAL_IO_GETEVENTS(ctx, min_nr, nr_evs,
> -						   events, timeout));
> -#else
> -	sleep_tmo = mock_ptr_type(struct timespec *);
> -	if (sleep_tmo) {
> -		if (sleep_tmo->tv_sec < 0)
> -			nanosleep(timeout, NULL);
> -		else
> -			nanosleep(sleep_tmo, NULL);
> +	if (test_dev) {
> +		int n = 0;
> +		mock_ptr_type(struct timespec *);
> +		mock_ptr_type(struct io_event *);
> +
> +		condlog(2, "min_nr = %ld nr_evs = %d", min_nr, nr_evs);
> +		while (n < nr_evs) {
> +			min_nr = min_nr <= nr_evs - n ? min_nr : nr_evs - n;
> +			n += REAL_IO_GETEVENTS(ctx, min_nr, nr_evs - n,
> +					       events + n, timeout);
> +		}
> +		assert_int_equal(nr_evs, n);
> +	} else {
> +		sleep_tmo = mock_ptr_type(struct timespec *);
> +		if (sleep_tmo) {
> +			if (sleep_tmo->tv_sec < 0)
> +				nanosleep(timeout, NULL);
> +			else
> +				nanosleep(sleep_tmo, NULL);
> +		}
> +		if (nr_evs < 0) {
> +			errno = -nr_evs;
> +			return -1;
> +		}
> +		evs = mock_ptr_type(struct io_event *);
> +		for (i = 0; i < nr_evs; i++)
> +			events[i] = evs[i];
>  	}
> -	if (nr_evs < 0) {
> -		errno = -nr_evs;
> -		return -1;
> -	}
> -	evs = mock_ptr_type(struct io_event *);
> -	for (i = 0; i < nr_evs; i++)
> -		events[i] = evs[i];
> -#endif
>  	ev_off -= nr_evs;
>  	return nr_evs;
>  }
> @@ -259,10 +259,9 @@ static void do_libcheck_init(struct checker *c, int blocksize,
>  	assert_non_null(ct->req);
>  	if (req)
>  		*req = ct->req;
> -#ifndef DIO_TEST_DEV
> -	/* don't check fake blocksize on real devices */
> -	assert_int_equal(ct->req->blksize, blocksize);
> -#endif
> +	if (!test_dev)
> +		/* don't check fake blocksize on real devices */
> +		assert_int_equal(ct->req->blksize, blocksize);
>  }
>  
>  static int is_checker_running(struct checker *c)
> @@ -583,11 +582,11 @@ static void test_async_timeout_cancel_failed(void **state)
>  	do_check_state(&c[1], 0, 2, PATH_PENDING);
>  	return_io_getevents_none();
>  	do_check_state(&c[0], 0, 2, PATH_DOWN);
> -#ifndef DIO_TEST_DEV
> -	/* can't pick which even gets returned on real devices */
> -	return_io_getevents_nr(NULL, 1, &reqs[1], &res[1]);
> -	do_check_state(&c[1], 0, 2, PATH_UP);
> -#endif
> +	if (!test_dev) {
> +		/* can't pick which even gets returned on real devices */
> +		return_io_getevents_nr(NULL, 1, &reqs[1], &res[1]);
> +		do_check_state(&c[1], 0, 2, PATH_UP);
> +	}
>  	return_io_getevents_none();
>  	do_check_state(&c[0], 0, 2, PATH_DOWN);
>  	assert_true(is_checker_running(&c[0]));
> @@ -663,12 +662,11 @@ static void test_check_state_blksize(void **state)
>  	int blksize[] = {4096, 1024, 512};
>  	struct async_req *reqs[3];
>  	int res[] = {0,1,0};
> -#ifdef DIO_TEST_DEV
> -	/* can't pick event return state on real devices */
>  	int chk_state[] = {PATH_UP, PATH_UP, PATH_UP};
> -#else
> -	int chk_state[] = {PATH_UP, PATH_DOWN, PATH_UP};
> -#endif
> +
> +	/* can't pick event return state on real devices */
> +	if (!test_dev)
> +		chk_state[1] = PATH_DOWN;
>  
>  	assert_true(list_empty(&aio_grp_list));
>  	will_return(__wrap_io_setup, 0);
> @@ -718,20 +716,38 @@ static void test_check_state_async(void **state)
>  
>  static int setup(void **state)
>  {
> -#ifdef DIO_TEST_DEV
> -	test_fd = open(DIO_TEST_DEV, O_RDONLY);
> -	if (test_fd < 0)
> -		fail_msg("cannot open %s: %m", DIO_TEST_DEV);
> -#endif
> +	char *dl = getenv("DIO_TEST_DELAY");
> +	test_dev = getenv("DIO_TEST_DEV");
> +
> +	if (test_dev) {
> +		condlog(2, "%s: opening %s", __func__, test_dev);
> +		test_fd = open(test_dev, O_RDONLY);
> +		if (dl) {
> +			char *e;
> +			long int d = strtol(dl, &e, 10);
> +
> +			if (*e == '\0' && d >= 0 && (d * 1000) < (long)UINT_MAX)
> +				test_delay = d * 1000;
> +			else {
> +				condlog(1, "DIO_TEST_DELAY=%s is invalid", dl);
> +				return 1;
> +			}
> +		}
> +		condlog(2, "%s: delay = %u us", __func__, test_delay / 1000);
> +	}
> +	if (test_fd < 0) {
> +		fail_msg("cannot open %s: %m", test_dev);
> +		return 1;
> +	}
>  	return 0;
>  }
>  
>  static int teardown(void **state)
>  {
> -#ifdef DIO_TEST_DEV
> -	assert_true(test_fd > 0);
> -	assert_int_equal(close(test_fd), 0);
> -#endif
> +	if (test_dev) {
> +		assert_true(test_fd > 0);
> +		assert_int_equal(close(test_fd), 0);
> +	}
>  	return 0;
>  }
>  
> @@ -762,7 +778,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> -	init_test_verbosity(5);
> +	init_test_verbosity(2);
>  	ret += test_directio();
>  	return ret;
>  }
> -- 
> 2.45.2

