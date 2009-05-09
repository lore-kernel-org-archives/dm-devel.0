From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 3/3] dm-mpath: add service-time oriented
	dynamic load balancer
Date: Sat, 9 May 2009 01:49:59 +0100
Message-ID: <20090509004959.GJ1320@agk-dp.fab.redhat.com>
References: <49F1729A.1000906@ct.jp.nec.com> <49F17362.7080205@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49F17362.7080205@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 24, 2009 at 05:08:02PM +0900, Kiyoshi Ueda wrote:
> +	struct selector *s = (struct selector *) ps->context;
> +		     status_type_t type, char *result, unsigned int maxlen)
> +	int sz = 0;
> +			DMEMIT("%u %lu ", atomic_read(&pi->in_flight_size),

(similar comments)

> +			DMEMIT("%u %lu ", pi->repeat_count, pi->perf);

Need to handle both 32 and 64 bit archs: cast to llu.

> +	if ((argc == 2) && (sscanf(argv[1], "%lu", &perf) != 1)) {

Please do sscanf for size_t the same way as dm-crypt does.
(Or scan for lu, if the intent is to impose a size limit ahead of the later
do_div() then cast explicitly.)

> +/*
> + * Returns:
> + * < 0 : pi1 is better
> + * 0   : no difference between pi1 and pi2
> + * > 0 : pi2 is better
> + */

Please document the parameters and algorithm.
Nothing explains what the performance value is for and examples of anticipated values.

> +	do_div(sz1, pi1->perf);
> +	do_div(sz2, pi2->perf);

Or sector_div ?
But what's the performance of those divisions like?
Is there a better way of getting the same answer?
Is there validation limiting the size of 'perf'?

(Also, did you check there's adequate locking & memory barriers around all the
atomics?)

Alasdair
