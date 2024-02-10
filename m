Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433F220E4
	for <dm-devel@lists.linux.dev>; Sat, 10 Feb 2024 03:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707535858; cv=none; b=W2XSHRFGKjAf2C75Iuhik4+/mjFKf08nbRB+ismOQhZtBIsenDQ9nW2h4YeOsduyr+If6x8uuWP6K4oVIQURo31T1NDn7bplhssZ3RE1VaCLy0CaYBc2KZ5kcs+c04LexdcnVgMa9jQMmN+y24z2boUGZMejIZj/N9SSU8R/zPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707535858; c=relaxed/simple;
	bh=UZ7sQ0nHmiz+HcWFzW61vs2bvHpJyvp9FV10mJedfsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=iq/VJaYrSaZZGy2Q/G+5IrZECieG6UzuujCF7OjGY6Xet9TCyTL5pLavnbsw8tK7SupPfXtDwOqF+gfs+u/wXlliJYguakxmXck+gLM6TBBW5mDwAbBzwmmJS3hIyIPfIyahNffRq4Wj3EVp3Cnuj3kH949BTHFKwmc3KwaMzME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ayQ5ac8U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ayQ5ac8U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707535855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9LsDbE8OknVlM6rA9DMdCOUZpr5C+dIen0ONEzvVIU4=;
	b=ayQ5ac8Uq/UjUozwLmAJFv8F9o1IRJVq94+32DMA0ZSXHmQ5CzgLLgORqqGc7uD1h25TMa
	H5v+17f8/sj/i0QsBpeO0lEtnLEWxX1zm9c74YAKasMztvB5WKYFrOrYsRVEBMKgsXFs5h
	UJv9F4UM3cPpTV4uqmyU+ctncmqXNjk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-9Tmz0J8NP_GZX_KyVZeQrQ-1; Fri, 09 Feb 2024 22:30:51 -0500
X-MC-Unique: 9Tmz0J8NP_GZX_KyVZeQrQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 059B7811E79;
	Sat, 10 Feb 2024 03:30:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDF1EC0FDCB;
	Sat, 10 Feb 2024 03:30:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41A3Uolj353282
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Feb 2024 22:30:50 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41A3UoIf353281;
	Fri, 9 Feb 2024 22:30:50 -0500
Date: Fri, 9 Feb 2024 22:30:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH v2 7/7] multipath-tools: Makefile.inc: set
 _FILE_OFFSET_BITS=64
Message-ID: <Zcbt6sakOpkqWFvP@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240209232735.9791-1-mwilck@suse.com>
 <20240209232735.9791-8-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240209232735.9791-8-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 10, 2024 at 12:27:35AM +0100, Martin Wilck wrote:
> Set _FILE_OFFSET_BITS=64 in order to avoid EOVERFLOW error for getdents()
> syscalls on some file systems (in particular, ext4) in emultated 32bit
> environments on 64 bit kernel, e.g. when running in qemu. This error occured
> in arm/v7 CI runs on Ubuntu runners on GitHub, which can be enabled after
> applying this change.  See
> e.g. https://sourceware.org/bugzilla/show_bug.cgi?id=23960.
> 
> This change requires fixes for the unit tests: If -D_FILE_OFFSET_BITS=64 is
> set, glibc headers replace some functions with their 64bit equivalents. open()
> is replaced by open64(), etc. cmocka wrappers for these functions must have
> correct name: defining __wrap_open() has no effect for calls to open64(). Unit
> tests using the wrongly named wrapper functions will fail in non-obvious ways.
> 
> Use CPP macros to substitute the correct name for affected functions. Also,
> the Makefile rule that builds the -Wl,wrap= options must parse the C preprocessor
> output to generate suitable command line parameters for the linker.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  Makefile.inc     |  1 +
>  tests/Makefile   |  5 ++++-
>  tests/alias.c    |  4 ++--
>  tests/directio.c |  7 +++---
>  tests/dmevents.c |  8 +++----
>  tests/sysfs.c    | 57 ++++++++++++++++++++++++------------------------
>  tests/test-lib.c |  9 +++++---
>  tests/wrap64.h   | 48 ++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 98 insertions(+), 41 deletions(-)
>  create mode 100644 tests/wrap64.h
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index a0e36c4..5668e63 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -100,6 +100,7 @@ WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implici
>  		  -Werror=implicit-function-declaration -Werror=format-security \
>  		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
>  CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
> +		   -D_FILE_OFFSET_BITS=64 \
>  		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" \
>  		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
>  		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DSTATE_DIR=\"$(statedir)\" \
> diff --git a/tests/Makefile b/tests/Makefile
> index 7dac8a8..7dde8bd 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -105,8 +105,11 @@ include $(wildcard $(OBJS:.o=.d))
>  dep_clean:
>  	$(Q)$(RM) $(OBJS:.o=.d)
>  
> +# Parse the C code for __wrap_xyz() functions and generate linker options from them.
> +# See comment in wrap64.h
>  %.o.wrap:	%.c
> -	@sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' $< | \
> +	$(Q)$(CC) $(CPPFLAGS) $($*-test_FLAGS) -E $< | \
> +		sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' | \
>  		sort -u | tr '\n' ' ' >$@
>  
>  # Pass the original values of CFLAGS etc. to the sub-make, which will include
> diff --git a/tests/alias.c b/tests/alias.c
> index c2ae915..95ce994 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -9,7 +9,7 @@
>  #include "test-log.h"
>  #include <errno.h>
>  #include <string.h>
> -
> +#include "wrap64.h"
>  #include "globals.c"
>  #include "../libmultipath/alias.c"
>  
> @@ -71,7 +71,7 @@ int __wrap_rename(const char *old, const char *new)
>  	return __set_errno(mock_type(int));
>  }
>  
> -int __wrap_mkstemp(char *template)
> +int WRAP_FUNC(mkstemp)(char *template)
>  {
>  	return 10;
>  }
> diff --git a/tests/directio.c b/tests/directio.c
> index 5201d21..cbedcc9 100644
> --- a/tests/directio.c
> +++ b/tests/directio.c
> @@ -24,6 +24,7 @@
>  #include <setjmp.h>
>  #include <stdlib.h>
>  #include <cmocka.h>
> +#include "wrap64.h"
>  #include "globals.c"
>  #include "../libmultipath/checkers/directio.c"
>  
> @@ -66,12 +67,12 @@ int __wrap_ioctl(int fd, ioctl_request_t request, void *argp)
>  #endif
>  }
>  
> -int __real_fcntl(int fd, int cmd, long arg);
> +int REAL_FCNTL (int fd, int cmd, long arg);
>  
> -int __wrap_fcntl(int fd, int cmd, long arg)
> +int WRAP_FCNTL (int fd, int cmd, long arg)
>  {
>  #ifdef DIO_TEST_DEV
> -	return __real_fcntl(fd, cmd, arg);
> +	return REAL_FCNTL(fd, cmd, arg);
>  #else
>  	assert_int_equal(fd, test_fd);
>  	assert_int_equal(cmd, F_GETFL);
> diff --git a/tests/dmevents.c b/tests/dmevents.c
> index f08e649..540bf0d 100644
> --- a/tests/dmevents.c
> +++ b/tests/dmevents.c
> @@ -29,7 +29,7 @@
>  #include <fcntl.h>
>  #include "structs.h"
>  #include "structs_vec.h"
> -
> +#include "wrap64.h"
>  #include "globals.c"
>  /* I have to do this to get at the static variables */
>  #include "../multipathd/dmevents.c"
> @@ -207,7 +207,7 @@ static int teardown(void **state)
>  	return 0;
>  }
>  
> -int __wrap_open(const char *pathname, int flags)
> +int WRAP_FUNC(open)(const char *pathname, int flags)
>  {
>  	assert_ptr_equal(pathname, "/dev/mapper/control");
>  	assert_int_equal(flags, O_RDWR);
> @@ -389,7 +389,7 @@ static void test_init_waiter_bad1(void **state)
>  	struct test_data *datap = (struct test_data *)(*state);
>  	if (datap == NULL)
>  		skip();
> -	will_return(__wrap_open, -1);
> +	wrap_will_return(WRAP_FUNC(open), -1);
>  	assert_int_equal(init_dmevent_waiter(&datap->vecs), -1);
>  	assert_ptr_equal(waiter, NULL);
>  }
> @@ -400,7 +400,7 @@ static void test_init_waiter_good0(void **state)
>  	struct test_data *datap = (struct test_data *)(*state);
>  	if (datap == NULL)
>  		skip();
> -	will_return(__wrap_open, 2);
> +	wrap_will_return(WRAP_FUNC(open), 2);
>  	assert_int_equal(init_dmevent_waiter(&datap->vecs), 0);
>  	assert_ptr_not_equal(waiter, NULL);
>  }
> diff --git a/tests/sysfs.c b/tests/sysfs.c
> index 6e07efd..fc256d8 100644
> --- a/tests/sysfs.c
> +++ b/tests/sysfs.c
> @@ -18,6 +18,7 @@
>  #include "test-log.h"
>  #include "sysfs.h"
>  #include "util.h"
> +#include "wrap64.h"
>  
>  #define TEST_FD 123
>  
> @@ -28,7 +29,7 @@ char *__wrap_udev_device_get_syspath(struct udev_device *ud)
>  	return val;
>  }
>  
> -int __wrap_open(const char *pathname, int flags)
> +int WRAP_FUNC(open)(const char *pathname, int flags)
>  {
>  	int ret;
>  
> @@ -166,10 +167,10 @@ static void test_sagv_open_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(__wrap_open, pathname, "/foo/bar");
> -	expect_value(__wrap_open, flags, O_RDONLY);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> +	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
>  	errno = ENOENT;
> -	will_return(__wrap_open, -1);
> +	wrap_will_return(WRAP_FUNC(open), -1);
>  	expect_condlog(3, "__sysfs_attr_get_value: attribute '/foo/bar' cannot be opened");
>  	assert_int_equal(sysfs_attr_get_value((void *)state, "bar",
>  					      buf, sizeof(buf)), -ENOENT);
> @@ -181,9 +182,9 @@ static void test_sagv_read_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(__wrap_open, pathname, "/foo/bar");
> -	expect_value(__wrap_open, flags, O_RDONLY);
> -	will_return(__wrap_open, TEST_FD);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> +	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> +	wrap_will_return(WRAP_FUNC(open), TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, sizeof(buf));
>  	errno = EISDIR;
> @@ -196,9 +197,9 @@ static void test_sagv_read_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/baz'");
> -	expect_string(__wrap_open, pathname, "/foo/baz");
> -	expect_value(__wrap_open, flags, O_RDONLY);
> -	will_return(__wrap_open, TEST_FD);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/baz");
> +	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> +	wrap_will_return(WRAP_FUNC(open), TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, sizeof(buf));
>  	errno = EPERM;
> @@ -222,9 +223,9 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
>  	memset(buf, '.', sizeof(buf));
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(__wrap_open, pathname, "/foo/bar");
> -	expect_value(__wrap_open, flags, O_RDONLY);
> -	will_return(__wrap_open, TEST_FD);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> +	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> +	wrap_will_return(WRAP_FUNC(open), TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, bufsz);
>  	will_return(__wrap_read, sizeof(input) - 1);
> @@ -249,9 +250,9 @@ static void _test_sagv_read(void **state, unsigned int bufsz)
>  	memset(buf, '.', sizeof(buf));
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/baz'");
> -	expect_string(__wrap_open, pathname, "/foo/baz");
> -	expect_value(__wrap_open, flags, O_RDONLY);
> -	will_return(__wrap_open, TEST_FD);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/baz");
> +	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> +	wrap_will_return(WRAP_FUNC(open), TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, bufsz);
>  	will_return(__wrap_read, sizeof(input) - 1);
> @@ -300,9 +301,9 @@ static void _test_sagv_read_zeroes(void **state, unsigned int bufsz)
>  	memset(buf, '.', sizeof(buf));
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(__wrap_open, pathname, "/foo/bar");
> -	expect_value(__wrap_open, flags, O_RDONLY);
> -	will_return(__wrap_open, TEST_FD);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> +	expect_value(WRAP_FUNC(open), flags, O_RDONLY);
> +	wrap_will_return(WRAP_FUNC(open), TEST_FD);
>  	expect_value(__wrap_read, fd, TEST_FD);
>  	expect_value(__wrap_read, count, bufsz);
>  	will_return(__wrap_read, sizeof(input) - 1);
> @@ -385,10 +386,10 @@ static void test_sasv_open_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(__wrap_open, pathname, "/foo/bar");
> -	expect_value(__wrap_open, flags, O_WRONLY);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> +	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
>  	errno = EPERM;
> -	will_return(__wrap_open, -1);
> +	wrap_will_return(WRAP_FUNC(open), -1);
>  	expect_condlog(3, "sysfs_attr_set_value: attribute '/foo/bar' cannot be opened");
>  	assert_int_equal(sysfs_attr_set_value((void *)state, "bar",
>  					      buf, sizeof(buf)), -EPERM);
> @@ -400,9 +401,9 @@ static void test_sasv_write_fail(void **state)
>  
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(__wrap_open, pathname, "/foo/bar");
> -	expect_value(__wrap_open, flags, O_WRONLY);
> -	will_return(__wrap_open, TEST_FD);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> +	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
> +	wrap_will_return(WRAP_FUNC(open), TEST_FD);
>  	expect_value(__wrap_write, fd, TEST_FD);
>  	expect_value(__wrap_write, count, sizeof(buf));
>  	errno = EISDIR;
> @@ -421,9 +422,9 @@ static void _test_sasv_write(void **state, unsigned int n_written)
>  	assert_in_range(n_written, 0, sizeof(buf));
>  	will_return(__wrap_udev_device_get_syspath, "/foo");
>  	expect_condlog(4, "open '/foo/bar'");
> -	expect_string(__wrap_open, pathname, "/foo/bar");
> -	expect_value(__wrap_open, flags, O_WRONLY);
> -	will_return(__wrap_open, TEST_FD);
> +	expect_string(WRAP_FUNC(open), pathname, "/foo/bar");
> +	expect_value(WRAP_FUNC(open), flags, O_WRONLY);
> +	wrap_will_return(WRAP_FUNC(open), TEST_FD);
>  	expect_value(__wrap_write, fd, TEST_FD);
>  	expect_value(__wrap_write, count, sizeof(buf));
>  	will_return(__wrap_write, n_written);
> diff --git a/tests/test-lib.c b/tests/test-lib.c
> index f75ea31..665d438 100644
> --- a/tests/test-lib.c
> +++ b/tests/test-lib.c
> @@ -16,6 +16,7 @@
>  #include "propsel.h"
>  #include "unaligned.h"
>  #include "test-lib.h"
> +#include "wrap64.h"
>  
>  const int default_mask = (DI_SYSFS|DI_BLACKLIST|DI_WWID|DI_CHECKER|DI_PRIO|DI_SERIAL);
>  const char default_devnode[] = "sdxTEST";
> @@ -38,16 +39,18 @@ const char default_wwid_1[] = "TEST-WWID-1";
>   * resolved by the assembler before the linking stage.
>   */
>  
> -int __real_open(const char *path, int flags, int mode);
> +
> +int REAL_FUNC(open)(const char *path, int flags, int mode);
>  
>  static const char _mocked_filename[] = "mocked_path";
> -int __wrap_open(const char *path, int flags, int mode)
> +
> +int WRAP_FUNC(open)(const char *path, int flags, int mode)
>  {
>  	condlog(4, "%s: %s", __func__, path);
>  
>  	if (!strcmp(path, _mocked_filename))
>  		return 111;
> -	return __real_open(path, flags, mode);
> +	return REAL_FUNC(open)(path, flags, mode);
>  }
>  
>  int __wrap_libmp_get_version(int which, unsigned int version[3])
> diff --git a/tests/wrap64.h b/tests/wrap64.h
> new file mode 100644
> index 0000000..8c91d27
> --- /dev/null
> +++ b/tests/wrap64.h
> @@ -0,0 +1,48 @@
> +#ifndef _WRAP64_H
> +#define _WRAP64_H 1
> +#include "util.h"
> +
> +/*
> + * Make cmocka work with _FILE_OFFSET_BITS == 64
> + *
> + * If -D_FILE_OFFSET_BITS=64 is set, glibc headers replace some functions with
> + * their 64bit equivalents. "open()" is replaced by "open64()", etc. cmocka
> + * wrappers for these functions must have correct name __wrap_open() doesn't
> + * work if the function called is not open() but open64(). Consequently, unit
> + * tests using such wrappers will fail.
> + * Use some CPP trickery to insert the correct name. The Makefile rule that
> + * creates the .wrap file must parse the C preprocessor output to generate the
> + * correct -Wl,wrap= option.
> + */
> +
> +/* Without this indirection, WRAP_FUNC(x) would be expanded to __wrap_WRAP_NAME(x) */
> +#define CONCAT2_(x, y) x ## y
> +#define CONCAT2(x, y) CONCAT2_(x, y)
> +
> +#if defined(__GLIBC__) && _FILE_OFFSET_BITS == 64
> +#define WRAP_NAME(x) x ## 64
> +#else
> +#define WRAP_NAME(x) x
> +#endif
> +#define WRAP_FUNC(x) CONCAT2(__wrap_, WRAP_NAME(x))
> +#define REAL_FUNC(x) CONCAT2(__real_, WRAP_NAME(x))
> +
> +/*
> + * fcntl() needs special treatment; fcntl64() has been introduced in 2.28.
> + * https://savannah.gnu.org/forum/forum.php?forum_id=9205
> + */
> +#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 28)
> +#define WRAP_FCNTL_NAME WRAP_NAME(fcntl)
> +#else
> +#define WRAP_FCNTL_NAME fcntl
> +#endif
> +#define WRAP_FCNTL CONCAT2(__wrap_, WRAP_FCNTL_NAME)
> +#define REAL_FCNTL CONCAT2(__real_, WRAP_FCNTL_NAME)
> +
> +/*
> + * will_return() is itself a macro that uses CPP "stringizing". We need a
> + * macro indirection to make sure the *value* of WRAP_FUNC() is stringized
> + * (see https://gcc.gnu.org/onlinedocs/cpp/Stringizing.html).
> + */
> +#define wrap_will_return(x, y) will_return(x, y)
> +#endif
> -- 
> 2.43.0

