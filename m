From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/32] block/fs/mm: prepare submit_bio_wait
 users for bi_rw split
Date: Thu, 05 Nov 2015 08:14:32 +0100
Message-ID: <563B01D8.5040901@suse.de>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
	<1446674909-5371-3-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-3-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 11/04/2015 11:07 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> =

> This patch prepares submit_bio_wait callers for the next
> patches that split bi_rw into a operation and flags field.
> Instead of passing in a bitmap with both the operation and
> flags mixed in, the callers now pass them in seperately.
> =

> Temp issue: When the fs.h read/write types, like WRITE_SYNC or
> WRITE_FUA, are used we still pass in the operation along with the
> flags in the flags argument. When all the code has been converted
> that will be cleaned up. It is left in here for compat and git
> bisect use and to try and make the patches smaller.
> =

> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  block/bio.c                |  8 ++++----
>  block/blk-flush.c          |  2 +-
>  drivers/md/bcache/debug.c  |  4 ++--
>  drivers/md/md.c            |  2 +-
>  drivers/md/raid1.c         |  2 +-
>  drivers/md/raid10.c        |  2 +-
>  fs/btrfs/check-integrity.c |  8 ++++----
>  fs/btrfs/check-integrity.h |  2 +-
>  fs/btrfs/extent_io.c       |  2 +-
>  fs/btrfs/scrub.c           |  6 +++---
>  fs/ext4/crypto.c           |  2 +-
>  fs/f2fs/segment.c          |  4 ++--
>  fs/hfsplus/hfsplus_fs.h    |  2 +-
>  fs/hfsplus/part_tbl.c      |  5 +++--
>  fs/hfsplus/super.c         |  6 ++++--
>  fs/hfsplus/wrapper.c       | 14 ++++++++------
>  fs/logfs/dev_bdev.c        |  2 +-
>  include/linux/bio.h        |  2 +-
>  kernel/power/swap.c        | 30 ++++++++++++++++++------------
>  19 files changed, 58 insertions(+), 47 deletions(-)
> =

> diff --git a/block/bio.c b/block/bio.c
> index ad3f276..610c704 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -859,21 +859,21 @@ static void submit_bio_wait_endio(struct bio *bio)
>  =

>  /**
>   * submit_bio_wait - submit a bio, and wait until it completes
> - * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
> + * @op: REQ_OP_*
> + * @flags: rq_flag_bits
>   * @bio: The &struct bio which describes the I/O
>   *
>   * Simple wrapper around submit_bio(). Returns 0 on success, or the erro=
r from
>   * bio_endio() on failure.
>   */
> -int submit_bio_wait(int rw, struct bio *bio)
> +int submit_bio_wait(int op, int flags, struct bio *bio)
>  {
>  	struct submit_bio_ret ret;
>  =

> -	rw |=3D REQ_SYNC;
>  	init_completion(&ret.event);
>  	bio->bi_private =3D &ret;
>  	bio->bi_end_io =3D submit_bio_wait_endio;
> -	submit_bio(rw, bio);
> +	submit_bio(op | flags | REQ_SYNC, bio);
>  	wait_for_completion(&ret.event);
>  =

>  	return ret.error;
Personally, I find it a bit odd to have flags starting with
REQ_ to be applied to bios; I would have expected them to be
applicable for requests, not for bios.

Not sure if it's worth the trouble to have the entire flag
set duplicated with BIO_XXX; maybe we should be using a common
set of flags prefixed with something else.

But in the end this is just a style issue, not a technical one.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
