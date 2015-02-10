From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFCv2 05/10] dm-dedup: COW B-tree backend
Date: Tue, 10 Feb 2015 10:25:41 -0500
Message-ID: <20150210152541.GA13266@redhat.com>
References: <53ffb654.c86f320a.5069.ffffc210@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53ffb654.c86f320a.5069.ffffc210@mx.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vasily Tarasov <tarasov@vasily.name>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

On Thu, Aug 28, 2014 at 06:07:29PM -0400, Vasily Tarasov wrote:

[..]
> +static struct metadata *init_meta_cowbtree(void *input_param, bool *unformatted)
> +{
> +	int ret;
> +	struct metadata *md;
> +	struct dm_block_manager *meta_bm;
> +	struct dm_space_map *meta_sm;
> +	struct dm_space_map *data_sm = NULL;
> +	struct dm_transaction_manager *tm;
> +	struct init_param_cowbtree *p =
> +				(struct init_param_cowbtree *)input_param;
> +
> +	DMINFO("Initializing COWBTREE backend");
> +
> +	md = kzalloc(sizeof(*md), GFP_NOIO);
> +	if (!md)
> +		return ERR_PTR(-ENOMEM);
> +
> +	meta_bm = dm_block_manager_create(p->metadata_bdev, METADATA_BSIZE,
> +				METADATA_CACHESIZE, METADATA_MAXLOCKS);
> +	if (IS_ERR(meta_bm)) {
> +		md = (struct metadata *)meta_bm;
> +		goto badbm;
> +	}

I am wondering how is the error handling working in this function. Upon
error, we are replacing the md pointer (which is pointing to a kzalloc
memory) and later calling kfree(md).

md = kzalloc(sizeof(*md), GFP_NOIO);
if (err)
  md = struct metadata *)meta_bm;
kfree(md).

What am I missing here.

[..]
> +badwritesuper:
> +	dm_sm_destroy(data_sm);
> +badsm:
> +	dm_tm_destroy(tm);
> +	dm_sm_destroy(meta_sm);
> +badtm:
> +	dm_block_manager_destroy(meta_bm);
> +badbm:
> +	kfree(md);
> +	return md;
> +}

There are multiple such substituions in this function. I think these are
bugs (until and unless I am missing something). I will fix these.

For now, I have pulled in dm-dedup-devel branch and will do code changes
locally. I am planning to push my branch in following repo for everybody
to have a look.

https://github.com/rhvgoyal/linux

I have yet to push a branch though.

Thanks
Vivek
