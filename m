From: Milan Broz <mbroz@redhat.com>
Subject: Re: [BUG] Oops caused by FEC in 4.10.0
Date: Thu, 16 Mar 2017 08:15:49 +0100
Message-ID: <6f891ced-6806-1f11-bc2e-b7af6285c688@redhat.com>
References: <CAMKhuNG_AKfY_EB9C_Y-8q7sR+9u+Mn9w-hb1YvZQBCNLC_-ww@mail.gmail.com>
	<20170315221223.GA116381@samitolvanen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170315221223.GA116381@samitolvanen.mtv.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sami Tolvanen <samitolvanen@google.com>, michal virgovic <michalvirgovic1@gmail.com>
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 03/15/2017 11:12 PM, Sami Tolvanen wrote:
> On Wed, Mar 15, 2017 at 09:22:02PM +0100, michal virgovic wrote:
>> This oops keeps appearing.
> 
> This can happen if dm-verity is set up with an invalid root hash, for
> example. Please test the attached patch, which limits recursion and should
> allow it to fail more gracefully.
> 
> Sami

Thanks Sami!

I see these patches are already in Android, Why it is not upstream?
https://android.googlesource.com/kernel/goldfish/+/21c0fe9f24b7707d2b49401f8c740c3e35c580ea%5E%21/

We tried to finally implement FEC support in veritysetup and it would
be nice that upstream kernel contains all patches so we do not
need to reinvent the wheel...

Thanks,
Milan



> 
> ---
> 
> dm verity fec: limit error correction recursion
> 
> If the hash tree itself is sufficiently corrupt in addition to data blocks,
> it's possible for error correction to end up in a deep recursive loop,
> which eventually causes a kernel panic. This change limits the recursion to
> a reasonable level during a single I/O operation.
> 
> Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  drivers/md/dm-verity-fec.c | 12 +++++++++++-
>  drivers/md/dm-verity-fec.h |  4 ++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
> index 0f0eb8a3d922..c3cc04d89524 100644
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -439,6 +439,13 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
>  	if (!verity_fec_is_enabled(v))
>  		return -EOPNOTSUPP;
>  
> +	if (fio->level >= DM_VERITY_FEC_MAX_RECURSION) {
> +		DMWARN_LIMIT("%s: FEC: recursion too deep", v->data_dev->name);
> +		return -EIO;
> +	}
> +
> +	fio->level++;
> +
>  	if (type == DM_VERITY_BLOCK_TYPE_METADATA)
>  		block += v->data_blocks;
>  
> @@ -470,7 +477,7 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
>  	if (r < 0) {
>  		r = fec_decode_rsb(v, io, fio, rsb, offset, true);
>  		if (r < 0)
> -			return r;
> +			goto done;
>  	}
>  
>  	if (dest)
> @@ -480,6 +487,8 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
>  		r = verity_for_bv_block(v, io, iter, fec_bv_copy);
>  	}
>  
> +done:
> +	fio->level--;
>  	return r;
>  }
>  
> @@ -520,6 +529,7 @@ void verity_fec_init_io(struct dm_verity_io *io)
>  	memset(fio->bufs, 0, sizeof(fio->bufs));
>  	fio->nbufs = 0;
>  	fio->output = NULL;
> +	fio->level = 0;
>  }
>  
>  /*
> diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
> index 7fa0298b995e..bb31ce87a933 100644
> --- a/drivers/md/dm-verity-fec.h
> +++ b/drivers/md/dm-verity-fec.h
> @@ -27,6 +27,9 @@
>  #define DM_VERITY_FEC_BUF_MAX \
>  	(1 << (PAGE_SHIFT - DM_VERITY_FEC_BUF_RS_BITS))
>  
> +/* maximum recursion level for verity_fec_decode */
> +#define DM_VERITY_FEC_MAX_RECURSION	4
> +
>  #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
>  #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
>  #define DM_VERITY_OPT_FEC_START		"fec_start"
> @@ -58,6 +61,7 @@ struct dm_verity_fec_io {
>  	unsigned nbufs;		/* number of buffers allocated */
>  	u8 *output;		/* buffer for corrected output */
>  	size_t output_pos;
> +	unsigned level;		/* recursion level */
>  };
>  
>  #ifdef CONFIG_DM_VERITY_FEC
> 
