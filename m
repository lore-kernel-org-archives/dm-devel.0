From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 16/19] libmultipath: coalesce_paths: fix size
 mismatch handling
Date: Thu, 29 Nov 2018 14:53:20 -0600
Message-ID: <20181129205320.GL5077@octiron.msp.redhat.com>
References: <20181121101839.30784-1-mwilck@suse.com>
	<20181121101839.30784-17-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181121101839.30784-17-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 21, 2018 at 11:18:36AM +0100, Martin Wilck wrote:
> When there are paths with the same WWID but different sizes, and
> coalesce_paths() walks the pathvec, it checks paths _after_
> the current one for size mismatch and sets ACT_REJECT. However,
> these paths will be reached in the main loop later, and this time
> the already handled paths will not be checked for size mismatch;
> thus a map could be created, possibly even with mismatching
> devices.
> 
> Fix that by tracking which paths were already discarded, and
> skipping them in the main loop later.

Previously, multipath would retry if coalesce_paths returned
DOMAP_RETRY. With this patch, DOMAP_RETRY isn't returned, so that no
longer happens. Is this intentional?

Also, I would prefer if coalesce_paths always used named constants for
the return values, instead of converting them to numbers.

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 33 +++++++++++++++++++++++++--------
>  libmultipath/util.h      | 16 ++++++++++++++++
>  2 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 406cd4c9..4ed3cc23 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -1009,6 +1009,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  	vector pathvec = vecs->pathvec;
>  	struct config *conf;
>  	int allow_queueing;
> +	uint64_t *size_mismatch_seen;
>  
>  	/* ignore refwwid if it's empty */
>  	if (refwwid && !strlen(refwwid))
> @@ -1019,6 +1020,14 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  			pp1->mpp = NULL;
>  		}
>  	}
> +
> +	if (VECTOR_SIZE(pathvec) == 0)
> +		return 0;
> +	size_mismatch_seen = calloc((VECTOR_SIZE(pathvec) - 1) / 64 + 1,
> +				    sizeof(uint64_t));
> +	if (size_mismatch_seen == NULL)
> +		return 1;
> +
>  	vector_foreach_slot (pathvec, pp1, k) {
>  		int invalid;
>  		/* skip this path for some reason */
> @@ -1038,8 +1047,8 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  			continue;
>  		}
>  
> -		/* 2. if path already coalesced */
> -		if (pp1->mpp)
> +		/* 2. if path already coalesced, or seen and discarded */
> +		if (pp1->mpp || is_bit_set_in_array(k, size_mismatch_seen))
>  			continue;
>  
>  		/* 3. if path has disappeared */
> @@ -1088,9 +1097,10 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  				 * ouch, avoid feeding that to the DM
>  				 */
>  				condlog(0, "%s: size %llu, expected %llu. "
> -					"Discard", pp2->dev_t, pp2->size,
> +					"Discard", pp2->dev, pp2->size,
>  					mpp->size);
>  				mpp->action = ACT_REJECT;
> +				set_bit_in_array(i, size_mismatch_seen);
>  			}
>  		}
>  		verify_paths(mpp, vecs);
> @@ -1119,8 +1129,10 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  					"ignoring" : "removing");
>  				remove_map(mpp, vecs, 0);
>  				continue;
> -			} else /* if (r == DOMAP_RETRY) */
> -				return r;
> +			} else /* if (r == DOMAP_RETRY) */ {
> +				r = 1;
> +				goto out;
> +			}
>  		}
>  		if (r == DOMAP_DRY)
>  			continue;
> @@ -1161,8 +1173,10 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  
>  		if (newmp) {
>  			if (mpp->action != ACT_REJECT) {
> -				if (!vector_alloc_slot(newmp))
> -					return 1;
> +				if (!vector_alloc_slot(newmp)) {
> +					r = 1;
> +					goto out;
> +				}
>  				vector_set_slot(newmp, mpp);
>  			}
>  			else
> @@ -1193,7 +1207,10 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  				condlog(2, "%s: remove (dead)", alias);
>  		}
>  	}
> -	return 0;
> +	r = 0;
> +out:
> +	free(size_mismatch_seen);
> +	return r;
>  }
>  
>  struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type)
> diff --git a/libmultipath/util.h b/libmultipath/util.h
> index a818e29a..1f13c913 100644
> --- a/libmultipath/util.h
> +++ b/libmultipath/util.h
> @@ -3,6 +3,7 @@
>  
>  #include <sys/types.h>
>  #include <inttypes.h>
> +#include <stdbool.h>
>  
>  size_t strchop(char *);
>  int basenamecpy (const char *src, char *dst, size_t size);
> @@ -39,4 +40,19 @@ struct scandir_result {
>  };
>  void free_scandir_result(struct scandir_result *);
>  
> +static inline bool is_bit_set_in_array(unsigned int bit, const uint64_t *arr)
> +{
> +	return arr[bit / 64] & (1ULL << (bit % 64)) ? 1 : 0;
> +}
> +
> +static inline void set_bit_in_array(unsigned int bit, uint64_t *arr)
> +{
> +	arr[bit / 64] |= (1ULL << (bit % 64));
> +}
> +
> +static inline void clear_bit_in_array(unsigned int bit, uint64_t *arr)
> +{
> +	arr[bit / 64] &= ~(1ULL << (bit % 64));
> +}
> +
>  #endif /* _UTIL_H */
> -- 
> 2.19.1
