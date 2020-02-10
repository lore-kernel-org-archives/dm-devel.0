From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 17/17] tests: make directio tests able to
 work on a real device
Date: Mon, 10 Feb 2020 18:27:24 +0100
Message-ID: <90762c8781e576cd39de14413e41348a9eb5a7f5.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-18-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-18-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> There is now a file in tests called directio_test_dev. If the
> commented
> out test device line is uncommented and set to a device, it can be
> used
> to test the directio checker on that device, instead of faking the
> device.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  tests/Makefile          |  16 +++++-
>  tests/directio.c        | 114
> ++++++++++++++++++++++++++++++++++++++--
>  tests/directio_test_dev |   4 ++
>  3 files changed, 130 insertions(+), 4 deletions(-)
>  create mode 100644 tests/directio_test_dev
> 
> @@ -359,6 +427,11 @@ static void test_check_state_timeout(void
> **state)
>  	will_return(__wrap_io_cancel, 0);
>  	do_check_state(&c, 1, 30, PATH_DOWN);
>  	check_aio_grp(aio_grp, 1, 0);
> +#ifdef DIO_TEST_DEV
> +	/* io_cancel will return negative value on timeout, so it
> happens again
> +	 * when freeing the checker */
> +	will_return(__wrap_io_cancel, 0);
> +#endif

I found this a bit confusing after the "will_return(__wrap_io_cancel,
0)" above. (The reader needs to realize that with DIO_TEST_DEV,
__wrap_io_cancel() discards the value passed by will_return()).

But that's just a nit.

Acked-by: Martin Wilck <mwilck@suse.com>
