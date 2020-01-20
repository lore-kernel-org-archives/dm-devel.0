From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 15/15] tests: add directio unit tests
Date: Mon, 20 Jan 2020 09:27:25 +0100
Message-ID: <e45a8a4058b97970412455f835c00e1982d8a5d0.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-16-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-16-git-send-email-bmarzins@redhat.com>
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

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  tests/Makefile   |   3 +-
>  tests/directio.c | 704
> +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 706 insertions(+), 1 deletion(-)
>  create mode 100644 tests/directio.c
> 
> diff --git a/tests/Makefile b/tests/Makefile
> index a5cdf390..275fdd7d 100644
> +
> +/* test async checkers pending and getting resovled by another
> checker
> + * as well as the loops for getting multiple events */
> +static void test_check_state_async(void **state)
> +{
> +	int i;
> +	struct checker c[257] = {0};
> +	struct async_req *reqs[257];
> +	int res[257] = {0};
> +
> +	do_libcheck_load();
> +	for (i = 0; i < 257; i++)
> +		do_libcheck_init(&c[i], 4096, &reqs[i]);
> +	for (i = 0; i < 256; i++) {
> +		return_io_getevents_none();
> +		do_check_state(&c[i], 0, 30, PATH_PENDING);
> +		assert_true(is_checker_running(&c[i]));
> +	}
> +	return_io_getevents_nr(&full_timeout, 256, reqs, res);
> +	return_io_getevents_nr(NULL, 1, &reqs[256], &res[256]);
> +	do_check_state(&c[256], 0, 30, PATH_UP);
> +	assert_false(is_checker_running(&c[256]));
> +	libcheck_free(&c[i]);

Writing &c[256] here would be better readable. Apart from that, this is
looking good. Some of the tests are implementation-specific, but that's
fine if we stick with this implementation.

I wish we could have some tests with real aio for this, but that would
be difficult to set up right. Perhaps scsi_debug could be leveraged for
it.

Regards
Martin
