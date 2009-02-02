From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 12 of 12]:
	dm-snapshot-new-ctr-table-format.patch
Date: Tue, 3 Feb 2009 07:55:32 +0900
Message-ID: <20090203075414U.fujita.tomonori@lab.ntt.co.jp>
References: <1232482467.19993.48.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1232482467.19993.48.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 20 Jan 2009 14:14:27 -0600
Jonathan Brassow <jbrassow@redhat.com> wrote:

> -	if (1 /* less change patch to patch */) {
> +	/* Detect old-style table line with type as second arg. */
> +	if (!isdigit(*argv[1])) {
>  		if (argc < 3) {
>  			ti->error = "Insufficient exception store arguments";
>  			return -EINVAL;
> @@ -605,10 +611,34 @@ static int create_exception_store(struct
>  		return dm_exception_store_create(toupper(*argv[1]), ti, 2,
>  						 tmp_argv, store);
>  	}
> +
> +	if (sscanf(argv[1], "%u", &param_count) != 1) {
> +		ti->error = "Invalid exception store argument count";
> +		return -EINVAL;
> +	}
> +
> +	*args_used = 2 + param_count;
> +
> +	if (argc < *args_used) {
> +		ti->error = "Insufficient exception store arguments";
> +		return -EINVAL;
> +	}
> +
> +	return dm_exception_store_create(argv[0], ti, param_count,
> +					 argv + 2, store);
>  }

Seems that this gives me:

drivers/md/dm-snap.c: In function 'create_exception_store':
drivers/md/dm-snap.c:613: warning: passing argument 1 of 'dm_exception_store_create' makes pointer from integer without a cast


BTW, how about adding something like 'compat_name' to struct
dm_exception_store_type instead of registering two similar structures
like the followings?

static struct dm_exception_store_type _persistent_type = {
	.name = "persistent",
	.module = THIS_MODULE,
	.ctr = persistent_ctr,
	.dtr = persistent_dtr,
	.read_metadata = persistent_read_metadata,
	.prepare_exception = persistent_prepare_exception,
	.commit_exception = persistent_commit_exception,
	.drop_snapshot = persistent_drop_snapshot,
	.fraction_full = persistent_fraction_full,
	.status = persistent_status,
};

static struct dm_exception_store_type _persistent_compat_type = {
	.name = "P",
	.module = THIS_MODULE,
	.ctr = persistent_ctr,
	.dtr = persistent_dtr,
	.read_metadata = persistent_read_metadata,
	.prepare_exception = persistent_prepare_exception,
	.commit_exception = persistent_commit_exception,
	.drop_snapshot = persistent_drop_snapshot,
	.fraction_full = persistent_fraction_full,
	.status = persistent_status,
};
