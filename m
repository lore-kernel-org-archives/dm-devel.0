From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/3] dm-mpath: add queue-length oriented
	dynamic load balancer
Date: Sat, 9 May 2009 01:31:36 +0100
Message-ID: <20090509003136.GI1320@agk-dp.fab.redhat.com>
References: <49F1729A.1000906@ct.jp.nec.com> <49F1733E.70006@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49F1733E.70006@ct.jp.nec.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, stefan.bader@canonical.com.redhat.com
List-Id: dm-devel.ids

On Fri, Apr 24, 2009 at 05:07:26PM +0900, Kiyoshi Ueda wrote:
> +	unsigned int		repeat_count;

Just 'unsigned repeat_count'

> +	struct selector *s = (struct selector *) ps->context;

Drop the cast when it's from void.

	struct selector *s = ps->context;

> +static int ql_status(struct path_selector *ps, struct dm_path *path,
> +		     status_type_t type, char *result, unsigned int maxlen)

unsigned maxlen

(We're doing things like this in all new patches, but only changing existing
code when it's touched for some other reason.)

> +	int sz = 0;

signed or unsigned sz?
(It's already used inconsistently, I know - but is unsigned better here?)

> +		case STATUSTYPE_INFO:
> +			DMEMIT("%u ", atomic_read(&pi->qlen));

Signed or unsigned?

> +	/* Parse the arguments */

Please document parameters and selection algorithm in Documentation dir and
maybe in inline comments too - it's not immediately obvious exactly how it
behaves.

> +static struct dm_path *ql_select_path(struct path_selector *ps,
> +				      unsigned *repeat_count, size_t nr_bytes)

Alasdair
