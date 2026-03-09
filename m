Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B456033D6DD
	for <dm-devel@lists.linux.dev>; Mon,  9 Mar 2026 18:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773081193; cv=none; b=AP1YHFfWYpBz3KRLQscyR03UIohiDVSuFhx6TNV55ZO89mI4MiVvSPHba35FVjCt++YrAh+3aehGrUhVaj0MwiqhJ+lcXhCPArkiwQzS43WUrZJ7blS7Yht0YK2LSIbAvARSt+gkDXnyjFp/Swta5B0mZ3vALHk0SfaacoNimRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773081193; c=relaxed/simple;
	bh=z+OI0eVVucRlAigSMrrJueyWZprYbJ33obYltTXkzXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=dZrXGp5x8jUt0liK2+ebheIBHMWtZJG5zksZtUFEA7gQLK+IuQtDMh54w8wBsLVqng6V/a56fMDuWKA99O046AecX+6l1zBON5A/SFLf7yxJuZIpnSio6sQaj9Dhn4F9k5lJfPWVZ8PGzHRcAgW3B8SttLiR0+KqCvz7r1Y9jh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NFU5pGaS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NFU5pGaS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773081190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YZS4qKNwuo+9TOwJjGLsPL8xRB/mfMIkiGw3p7j7dBY=;
	b=NFU5pGaS7dx8aNF+ff21MiRoM5fPjTFutlrVvzZlKV/WBLWDH5O2UnOoFjTIjp+/5cW1nc
	hdl0s5W9639IrunFh6oDIT0M7Lo6nHo2BOh4rM6rcdgO7M4id3LGmDcuxx2M/ErBeiu5Aq
	Qk4Lw5GXQyIjxOTM26J3ZgYqmWRdKNw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-470-orWfdDcjNcKQT5U1A8WQQQ-1; Mon,
 09 Mar 2026 14:33:09 -0400
X-MC-Unique: orWfdDcjNcKQT5U1A8WQQQ-1
X-Mimecast-MFC-AGG-ID: orWfdDcjNcKQT5U1A8WQQQ_1773081188
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3958419560B3;
	Mon,  9 Mar 2026 18:33:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04A1419560A6;
	Mon,  9 Mar 2026 18:33:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 629IX6OU2131481
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 9 Mar 2026 14:33:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 629IX6Zh2131480;
	Mon, 9 Mar 2026 14:33:06 -0400
Date: Mon, 9 Mar 2026 14:33:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev
Subject: Re: [PATCH] tests: add test demonstrating TUR checker race condition
Message-ID: <aa8SYkg7Uu7N52SU@redhat.com>
References: <20260307010614.1732-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260307010614.1732-1-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Zj0S0NL6acQ_1By-DwSQF15wzdFK5EtueKq5NDrE7HQ_1773081188
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 06, 2026 at 05:06:14PM -0800, Brian Bunker wrote:
> Add a test that reproduces the race condition in the TUR checker where
> the checker thread has finished updating ct->state and ct->msgid (under
> lock) but hasn't yet cleared ct->running. In this race window, the
> code incorrectly returns PATH_PENDING even though a valid result is
> already available.
> 
> NOTE: This test currently fails, demonstrating the bug exists.
> 
> The test includes two cases:
> - test_race_window_result_ready: Simulates the race window where
>   ct->running is still set but ct->msgid indicates the check has
>   completed. This currently returns PATH_PENDING instead of the
>   actual result (PATH_UP).
> - test_thread_still_running: Verifies that when ct->msgid is
>   MSG_TUR_RUNNING (thread genuinely hasn't finished), PATH_PENDING
>   is correctly returned.
> 

I thought your test program could show the TUR checker hanging. This is
just showing the known behavior, and I don't see a way for it to hang.
Also, unless you actually got the TUR checker to hang, I don't know of
anyone who has ever reported a hang.

-Ben

> == running tur_race-test ==
> [==========] Running 2 test(s).
> [ RUN      ] test_race_window_result_ready
> [  ERROR   ] --- 0x6 != 0x3
> [   LINE   ] --- tur_race.c:104: error: Failure!
> [  FAILED  ] test_race_window_result_ready
> [ RUN      ] test_thread_still_running
> [       OK ] test_thread_still_running
> [==========] 2 test(s) run.
> [  PASSED  ] 1 test(s).
> [  FAILED  ] 1 test(s), listed below:
> [  FAILED  ] test_race_window_result_ready
> 
>  1 FAILED TEST(S)
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> ---
>  tests/Makefile   |   3 +-
>  tests/tur_race.c | 175 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 177 insertions(+), 1 deletion(-)
>  create mode 100644 tests/tur_race.c
> 
> diff --git a/tests/Makefile b/tests/Makefile
> index 9f1b950f..3d033d9a 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -9,7 +9,7 @@ CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter -Wno-unused-function $(W_MISSING_I
>  LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpathcmd -lcmocka
>  
>  TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
> -	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo
> +	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo tur_race
>  HELPERS := test-lib.o test-log.o
>  
>  .PRECIOUS: $(TESTS:%=%-test)
> @@ -65,6 +65,7 @@ features-test_LIBDEPS := -ludev -lpthread
>  features-test_OBJDEPS := $(mpathutildir)/mt-libudev.o
>  cli-test_OBJDEPS := $(daemondir)/cli.o
>  mapinfo-test_LIBDEPS = -lpthread -ldevmapper
> +tur_race-test_LIBDEPS := -lpthread -lurcu
>  
>  %.o: %.c
>  	@echo building $@ because of $?
> diff --git a/tests/tur_race.c b/tests/tur_race.c
> new file mode 100644
> index 00000000..00ad3cea
> --- /dev/null
> +++ b/tests/tur_race.c
> @@ -0,0 +1,175 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Test for TUR checker race condition.
> + *
> + * This test demonstrates a race condition where the checker thread has
> + * finished (set state/msgid under lock) but hasn't yet cleared ct->running.
> + * Currently, libcheck_check() incorrectly returns PATH_PENDING even though
> + * a valid result is available.
> + *
> + * NOTE: test_race_window_result_ready currently FAILS, demonstrating the bug.
> + */
> +
> +#define _GNU_SOURCE
> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <stdarg.h>
> +#include <stddef.h>
> +#include <setjmp.h>
> +#include <stdlib.h>
> +#include <pthread.h>
> +#include <time.h>
> +#include "cmocka-compat.h"
> +
> +#include "globals.c"
> +#include "../libmultipath/checkers/tur.c"
> +
> +/* Mock device for testing */
> +static dev_t test_devt;
> +
> +static int setup(void **state)
> +{
> +	test_devt = makedev(8, 0);
> +	return 0;
> +}
> +
> +static int teardown(void **state)
> +{
> +	return 0;
> +}
> +
> +/*
> + * Test: Simulate the race window where thread has finished but running != 0
> + *
> + * This simulates the state between:
> + *   pthread_mutex_unlock(&ct->lock);  // thread released lock
> + *   uatomic_set(&ct->running, 0);     // thread hasn't cleared running yet
> + *
> + * In this window:
> + *   - ct->state and ct->msgid have the final result
> + *   - ct->running is still 1
> + *
> + * BUG: The code sees running != 0 and returns PATH_PENDING, ignoring
> + * the valid result that is already available.
> + *
> + * This test currently FAILS, demonstrating the race condition.
> + */
> +static void test_race_window_result_ready(void **state)
> +{
> +	struct checker c = {0};
> +	struct tur_checker_context *ct;
> +	int result;
> +
> +	/* Initialize the checker context manually to avoid dependencies */
> +	ct = calloc(1, sizeof(struct tur_checker_context));
> +	assert_non_null(ct);
> +
> +	pthread_mutex_init(&ct->lock, NULL);
> +	pthread_cond_init(&ct->active, NULL);
> +	uatomic_set(&ct->holders, 1);
> +	ct->state = PATH_UNCHECKED;
> +	ct->fd = -1;
> +
> +	c.fd = 1;
> +	c.timeout = 30;
> +	c.context = ct;
> +	assert_non_null(ct);
> +
> +	/*
> +	 * Simulate race condition state:
> +	 * - Thread has finished and set state/msgid
> +	 * - Thread has NOT yet cleared running
> +	 * - ct->thread is set (appears to be an active check)
> +	 */
> +	ct->thread = (pthread_t)1;  /* Non-zero: appears to be running */
> +	ct->devt = test_devt;
> +
> +	pthread_mutex_lock(&ct->lock);
> +	ct->state = PATH_UP;
> +	ct->msgid = CHECKER_MSGID_UP;
> +	pthread_mutex_unlock(&ct->lock);
> +
> +	uatomic_set(&ct->running, 1);  /* Thread "still running" */
> +	ct->time = time(NULL) + 100;   /* Not timed out */
> +
> +	/* Call libcheck_check - this is where the race manifests */
> +	result = libcheck_check(&c);
> +
> +	/*
> +	 * Expected: PATH_UP (the result is ready)
> +	 * Actual (BUG): PATH_PENDING (ignores ready result)
> +	 *
> +	 * This assertion currently FAILS, demonstrating the bug.
> +	 */
> +	assert_int_equal(result, PATH_UP);
> +	assert_int_equal(c.msgid, CHECKER_MSGID_UP);
> +
> +	/* ct->thread was cleared by libcheck_check when it collected result */
> +	ct->thread = 0;
> +	uatomic_set(&ct->running, 0);
> +	pthread_mutex_destroy(&ct->lock);
> +	pthread_cond_destroy(&ct->active);
> +	free(ct);
> +}
> +
> +/*
> + * Test: Verify thread still running returns PATH_PENDING
> + *
> + * When the thread genuinely hasn't finished (msgid == MSG_TUR_RUNNING),
> + * we should correctly return PATH_PENDING.
> + */
> +static void test_thread_still_running(void **state)
> +{
> +	struct checker c = {0};
> +	struct tur_checker_context *ct;
> +	int result;
> +
> +	/* Initialize the checker context manually to avoid dependencies */
> +	ct = calloc(1, sizeof(struct tur_checker_context));
> +	assert_non_null(ct);
> +
> +	pthread_mutex_init(&ct->lock, NULL);
> +	pthread_cond_init(&ct->active, NULL);
> +	uatomic_set(&ct->holders, 1);
> +	ct->state = PATH_UNCHECKED;
> +	ct->fd = -1;
> +
> +	c.fd = 1;
> +	c.timeout = 30;
> +	c.context = ct;
> +
> +	/* Thread is genuinely still running - no result yet */
> +	ct->thread = (pthread_t)1;
> +	ct->devt = test_devt;
> +
> +	pthread_mutex_lock(&ct->lock);
> +	ct->state = PATH_PENDING;
> +	ct->msgid = MSG_TUR_RUNNING;  /* Thread hasn't set result yet */
> +	pthread_mutex_unlock(&ct->lock);
> +
> +	uatomic_set(&ct->running, 1);
> +	ct->time = time(NULL) + 100;
> +
> +	result = libcheck_check(&c);
> +
> +	/* Should correctly return PATH_PENDING */
> +	assert_int_equal(result, PATH_PENDING);
> +
> +	ct->thread = 0;
> +	uatomic_set(&ct->running, 0);
> +	pthread_mutex_destroy(&ct->lock);
> +	pthread_cond_destroy(&ct->active);
> +	free(ct);
> +}
> +
> +int main(void)
> +{
> +	const struct CMUnitTest tests[] = {
> +		cmocka_unit_test_setup_teardown(test_race_window_result_ready,
> +						setup, teardown),
> +		cmocka_unit_test_setup_teardown(test_thread_still_running,
> +						setup, teardown),
> +	};
> +	return cmocka_run_group_tests(tests, NULL, NULL);
> +}
> +
> -- 
> 2.52.0

