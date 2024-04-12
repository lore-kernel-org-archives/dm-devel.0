Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B815824AD
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712936040; cv=none; b=YwHdmmJFDQJTGg0YdFWeeJYKvY0sKGWK9Ref5DjFDO2kGtEtk1o0oajkLxHaOPPDco/FQQzDpkQ0CTmsEG0aptBOwWScaiBRzUwahADd/bSh84qmeAcuAP+vu/ExpiH9mYcO/FWxefBbvtEC6Z5UNHl8VlZAd3XrFKxyYYm1S1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712936040; c=relaxed/simple;
	bh=g5pT3Am42qMjMcH8YDyKby367dGvL2weZsFxpGA4sS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VTWvM/uhdWg46f+ATnfdh79GFUr8hwQOTHLuXBnNUOKrTLSVJJDbg00AfiCNbmaHA8M2mCMded/JysgggxELyJkJ9aZzabTav44g5k50At2gDqgL+FLC1pwJp+RdZQbB1JhqCaMNBKYC3uPMaM5mRIdhXGMA6V2hIWvndff6Gjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S/wALR1q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S/wALR1q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712936037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aZ4j4BKSYPyqaYRvMBYYHRyPwftX9Lo0rd0nBB68M4s=;
	b=S/wALR1qBWVAKcIlyJGtxbneRzQGcSYPECYyEGnm+WJVAySHE40jV0t4OX5cVHrUDt5dm+
	ceGlJRMOFFXk9z1YX1H9pVoA92QmETKTQ1wKqMIKplUZRzPsV1lTWyNquFPupo6CR4iZlM
	wWjxX6PV+NAYKIEhLW8OmnTnnA2DVH8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-68-QA78X74INb2DoUp8fiGHJw-1; Fri,
 12 Apr 2024 11:33:55 -0400
X-MC-Unique: QA78X74INb2DoUp8fiGHJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CD2E38116EA;
	Fri, 12 Apr 2024 15:33:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 724EB40C6CBF;
	Fri, 12 Apr 2024 15:33:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43CFXtdD1871629
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Apr 2024 11:33:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43CFXsPh1871628;
	Fri, 12 Apr 2024 11:33:54 -0400
Date: Fri, 12 Apr 2024 11:33:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] multipath-tools tests: fix CI failures on arm/v7
 with glibc 2.37
Message-ID: <ZhlUYv6aygFNgH4W@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240412093258.20037-1-mwilck@suse.com>
 <20240412093258.20037-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240412093258.20037-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 12, 2024 at 11:32:57AM +0200, Martin Wilck wrote:
> glibc 2.37 has added several new wrappers around the ioctl and
> io_getevents system calls on 32 bit systems, to deal with 64bit
> time_t. These aren't resolved with cmocka's wrapping technique.
> 
> Fix this with C preprocessor trickery, similar to
> 7b217f8 ("multipath-tools: Makefile.inc: set _FILE_OFFSET_BITS=64").
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/directio.c | 22 +++++++++++-----------
>  tests/vpd.c      | 35 ++++++++++++++++++-----------------
>  tests/wrap64.h   | 23 ++++++++++++++++++++++-
>  3 files changed, 51 insertions(+), 29 deletions(-)
> 
> diff --git a/tests/directio.c b/tests/directio.c
> index cbedcc9..a5a5c0e 100644
> --- a/tests/directio.c
> +++ b/tests/directio.c
> @@ -41,9 +41,9 @@ struct timespec full_timeout = { .tv_sec = -1 };
>  #define ioctl_request_t int
>  #endif
>  
> -int __real_ioctl(int fd, ioctl_request_t request, void *argp);
> +int REAL_IOCTL(int fd, ioctl_request_t request, void *argp);
>  
> -int __wrap_ioctl(int fd, ioctl_request_t request, void *argp)
> +int WRAP_IOCTL(int fd, ioctl_request_t request, void *argp)
>  {
>  #ifdef DIO_TEST_DEV
>  	mock_type(int);
> @@ -148,10 +148,10 @@ int __wrap_io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt)
>  #endif
>  }
>  
> -int __real_io_getevents(io_context_t ctx, long min_nr, long nr,
> +int REAL_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
>  			struct io_event *events, struct timespec *timeout);

Maybe I'm missing something here, but I don't see where you define
REAL_IO_GETEVENTS. Also, WRAP_IO_GETEVENTS calls __real_io_getevents()
not REAL_IO_GETEVENTS(). The same thing happens with REAL_IOCTL (it's
not defined and __read_ioctl is called in directio.c and test-lib.c).
REAL_FCNTL works how I'd expect.

-Ben

>  
> -int __wrap_io_getevents(io_context_t ctx, long min_nr, long nr,
> +int WRAP_IO_GETEVENTS(io_context_t ctx, long min_nr, long nr,
>  			struct io_event *events, struct timespec *timeout)
>  {
>  	int nr_evs;
> @@ -193,7 +193,7 @@ int __wrap_io_getevents(io_context_t ctx, long min_nr, long nr,
>  
>  static void return_io_getevents_none(void)
>  {
> -	will_return(__wrap_io_getevents, 0);
> +	wrap_will_return(WRAP_IO_GETEVENTS, 0);
>  }
>  
>  static void return_io_getevents_nr(struct timespec *ts, int nr,
> @@ -207,15 +207,15 @@ static void return_io_getevents_nr(struct timespec *ts, int nr,
>  			mock_events[i + ev_off].res = reqs[i]->blksize;
>  	}
>  	while (nr > 0) {
> -		will_return(__wrap_io_getevents, (nr > 128)? 128 : nr);
> -		will_return(__wrap_io_getevents, ts);
> -		will_return(__wrap_io_getevents, &mock_events[off + ev_off]);
> +		wrap_will_return(WRAP_IO_GETEVENTS, (nr > 128)? 128 : nr);
> +		wrap_will_return(WRAP_IO_GETEVENTS, ts);
> +		wrap_will_return(WRAP_IO_GETEVENTS, &mock_events[off + ev_off]);
>  		ts = NULL;
>  		off += 128;
>  		nr -= 128;
>  	}
>  	if (nr == 0)
> -		will_return(__wrap_io_getevents, 0);
> +		wrap_will_return(WRAP_IO_GETEVENTS, 0);
>  	ev_off += i;
>  }
>  
> @@ -251,7 +251,7 @@ static void do_libcheck_init(struct checker *c, int blocksize,
>  	struct directio_context * ct;
>  
>  	c->fd = test_fd;
> -	will_return(__wrap_ioctl, blocksize);
> +	wrap_will_return(WRAP_IOCTL, blocksize);
>  	assert_int_equal(libcheck_init(c), 0);
>  	ct = (struct directio_context *)c->context;
>  	assert_non_null(ct);
> @@ -762,7 +762,7 @@ int main(void)
>  {
>  	int ret = 0;
>  
> -	init_test_verbosity(2);
> +	init_test_verbosity(5);
>  	ret += test_directio();
>  	return ret;
>  }
> diff --git a/tests/vpd.c b/tests/vpd.c
> index 1b2d62d..e3212e6 100644
> --- a/tests/vpd.c
> +++ b/tests/vpd.c
> @@ -20,6 +20,7 @@
>  #include "vector.h"
>  #include "structs.h"
>  #include "discovery.h"
> +#include "wrap64.h"
>  #include "globals.c"
>  
>  #define VPD_BUFSIZ 4096
> @@ -58,7 +59,7 @@ static const char vendor_id[] = "Linux";
>  static const char test_id[] =
>  	"A123456789AbcDefB123456789AbcDefC123456789AbcDefD123456789AbcDef";
>  
> -int __wrap_ioctl(int fd, unsigned long request, void *param)
> +int WRAP_IOCTL(int fd, unsigned long request, void *param)
>  {
>  	int len;
>  	struct sg_io_hdr *io_hdr;
> @@ -428,8 +429,8 @@ static void test_vpd_vnd_ ## len ## _ ## wlen(void **state)             \
>  	/* Replace spaces, like code under test */			\
>  	exp_subst = subst_spaces(exp_wwid);				\
>  	free(exp_wwid);							\
> -	will_return(__wrap_ioctl, n);					\
> -	will_return(__wrap_ioctl, vt->vpdbuf);				\
> +	wrap_will_return(WRAP_IOCTL, n);				\
> +	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
>  	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
>  	assert_correct_wwid("test_vpd_vnd_" #len "_" #wlen,		\
>  			    exp_len, ret, '1', 0, false,		\
> @@ -458,8 +459,8 @@ static void test_vpd_str_ ## typ ## _ ## len ## _ ## wlen(void **state) \
>  		exp_len--;						\
>  	if (exp_len >= wlen)						\
>  		exp_len = wlen - 1;					\
> -	will_return(__wrap_ioctl, n);					\
> -	will_return(__wrap_ioctl, vt->vpdbuf);				\
> +	wrap_will_return(WRAP_IOCTL, n);				\
> +	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
>  	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
>  	assert_correct_wwid("test_vpd_str_" #typ "_" #len "_" #wlen,	\
>  			    exp_len, ret, byte0[type], 0,		\
> @@ -495,8 +496,8 @@ static void test_vpd_naa_ ## naa ## _ ## wlen(void **state)             \
>  									\
>  	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id,	\
>  			 3, naa, 0);					\
> -	will_return(__wrap_ioctl, n);					\
> -	will_return(__wrap_ioctl, vt->vpdbuf);				\
> +	wrap_will_return(WRAP_IOCTL, n);				\
> +	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
>  	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
>  	assert_correct_wwid("test_vpd_naa_" #naa "_" #wlen,		\
>  			    exp_len, ret, '3', '0' + naa, true,		\
> @@ -518,8 +519,8 @@ static void test_vpd_naa_##NAA##_badlen_##BAD(void **state)	\
>  	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id, 3, NAA, 0); \
>  									\
>  	vt->vpdbuf[7] = BAD;						\
> -	will_return(__wrap_ioctl, n);					\
> -	will_return(__wrap_ioctl, vt->vpdbuf);				\
> +	wrap_will_return(WRAP_IOCTL, n);				\
> +	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
>  	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, 40);			\
>  	assert_int_equal(-ret, -ERR);					\
>  }
> @@ -545,11 +546,11 @@ static void test_vpd_eui_ ## len ## _ ## wlen ## _ ## sml(void **state)	\
>  		/* overwrite the page size to DEFAULT_SGIO_LEN + 1 */	\
>  		put_unaligned_be16(255, vt->vpdbuf + 2);		\
>  		/* this causes get_vpd_sgio to do a second ioctl */	\
> -		will_return(__wrap_ioctl, n);				\
> -		will_return(__wrap_ioctl, vt->vpdbuf);			\
> +		wrap_will_return(WRAP_IOCTL, n);			\
> +		wrap_will_return(WRAP_IOCTL, vt->vpdbuf);		\
>  	}								\
> -	will_return(__wrap_ioctl, n);					\
> -	will_return(__wrap_ioctl, vt->vpdbuf);				\
> +	wrap_will_return(WRAP_IOCTL, n);				\
> +	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
>  	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
>  	assert_correct_wwid("test_vpd_eui_" #len "_" #wlen "_" #sml,	\
>  			    exp_len, ret, '2', 0, true,			\
> @@ -571,8 +572,8 @@ static void test_vpd_eui_badlen_##LEN##_##BAD(void **state)	\
>  	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id, 2, 0, LEN); \
>  									\
>  	vt->vpdbuf[7] = BAD;						\
> -	will_return(__wrap_ioctl, n);					\
> -	will_return(__wrap_ioctl, vt->vpdbuf);				\
> +	wrap_will_return(WRAP_IOCTL, n);				\
> +	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
>  	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, 40);			\
>  	assert_int_equal(ret, ERR);					\
>  	if (ERR >= 0)							\
> @@ -600,8 +601,8 @@ static void test_vpd80_ ## size ## _ ## len ## _ ## wlen(void **state)  \
>  		exp_len = wlen - 1;					\
>  	n = create_vpd80(vt->vpdbuf, sizeof(vt->vpdbuf), input,		\
>  			 size, len);					\
> -	will_return(__wrap_ioctl, n);					\
> -	will_return(__wrap_ioctl, vt->vpdbuf);				\
> +	wrap_will_return(WRAP_IOCTL, n);				\
> +	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
>  	ret = get_vpd_sgio(10, 0x80, 0, vt->wwid, wlen);		\
>  	assert_correct_wwid("test_vpd80_" #size "_" #len "_" #wlen,	\
>  			    exp_len, ret, 0, 0, false,			\
> diff --git a/tests/wrap64.h b/tests/wrap64.h
> index 8c91d27..6b92751 100644
> --- a/tests/wrap64.h
> +++ b/tests/wrap64.h
> @@ -1,5 +1,7 @@
>  #ifndef _WRAP64_H
>  #define _WRAP64_H 1
> +#include <syscall.h>
> +#include <linux/types.h>
>  #include "util.h"
>  
>  /*
> @@ -31,7 +33,9 @@
>   * fcntl() needs special treatment; fcntl64() has been introduced in 2.28.
>   * https://savannah.gnu.org/forum/forum.php?forum_id=9205
>   */
> -#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 28)
> +#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 37) && defined(__arm__) && __ARM_ARCH == 7
> +#define WRAP_FCNTL_NAME __fcntl_time64
> +#elif defined(__GLIBC__) && __GLIBC_PREREQ(2, 28)
>  #define WRAP_FCNTL_NAME WRAP_NAME(fcntl)
>  #else
>  #define WRAP_FCNTL_NAME fcntl
> @@ -39,6 +43,23 @@
>  #define WRAP_FCNTL CONCAT2(__wrap_, WRAP_FCNTL_NAME)
>  #define REAL_FCNTL CONCAT2(__real_, WRAP_FCNTL_NAME)
>  
> +/*
> + * glibc 2.37 uses __ioctl_time64 for ioctl
> + */
> +#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 37) && defined(__arm__) && __ARM_ARCH == 7
> +#define WRAP_IOCTL_NAME __ioctl_time64
> +#else
> +#define WRAP_IOCTL_NAME ioctl
> +#endif
> +#define WRAP_IOCTL CONCAT2(__wrap_, WRAP_IOCTL_NAME)
> +
> +#if defined(__NR_io_pgetevents) && __BITS_PER_LONG == 32 && defined(_TIME_BITS) && _TIME_BITS == 64
> +#define WRAP_IO_GETEVENTS_NAME io_getevents_time64
> +#else
> +#define WRAP_IO_GETEVENTS_NAME io_getevents
> +#endif
> +#define WRAP_IO_GETEVENTS CONCAT2(__wrap_, WRAP_IO_GETEVENTS_NAME)
> +
>  /*
>   * will_return() is itself a macro that uses CPP "stringizing". We need a
>   * macro indirection to make sure the *value* of WRAP_FUNC() is stringized
> -- 
> 2.44.0

