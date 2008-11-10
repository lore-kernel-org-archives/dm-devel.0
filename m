From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: updated Chandra's patch for dm_any_congested
Date: Mon, 10 Nov 2008 11:34:26 -0600
Message-ID: <1226338466.5014.29.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0811101206570.7687@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0811101206570.7687@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, 2008-11-10 at 12:14 -0500, Mikulas Patocka wrote:
> --- so that there is not a possibility to deadlock device suspend
> that 
> wait for pending variable to drop to zero.
> 
> You can put it into your series as a quick "stop crash" patch, until
> we 
> find a better solution as we talked about today.
> 
> BTW. if you some times ago wondered why I'm using yield() and not
> waiting 
> queues in performance non-critical paths, it's to avoid bugs like
> this :)


> From: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> dm_any_congested() just checks for the DMF_BLOCK_IO and has no
> code to make sure that suspend waits for dm_any_congested() to
> complete.  This patch adds such a check.
> 
> Without it, a race can occur with dm_table_put() attempting to
> destroying the table in the wrong thread, the one running
> dm_any_congested() which is meant to be quick and return
> immediately.
> 
> Two examples of problems:
> 1. Sleeping functions called from congested code, the caller
>    of which holds a spin lock.
> 2. An ABBA deadlock between pdflush and multipathd. The two locks
>    in contention are inode lock and kernel lock.
> 
> [AGK: Is the return value always correct when the table is skipped?]
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Stylistically, there needs to be a brief description of your alteration
in the text above (traditionally in square brackets preceeded by your
email address so we know how the patch got altered).

> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> ---
>  drivers/md/dm.c |   20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6.28-rc3-devel/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.28-rc3-devel.orig/drivers/md/dm.c 2008-11-05
> 09:19:18.000000000 +0100
> +++ linux-2.6.28-rc3-devel/drivers/md/dm.c      2008-11-10
> 18:05:24.000000000 +0100
> @@ -941,16 +941,22 @@ static void dm_unplug_all(struct request
>  
>  static int dm_any_congested(void *congested_data, int bdi_bits)
>  {
> -       int r;
> +       int r = bdi_bits;
>         struct mapped_device *md = (struct mapped_device *)
> congested_data;
> -       struct dm_table *map = dm_get_table(md);
> +       struct dm_table *map;
>  
> -       if (!map || test_bit(DMF_BLOCK_IO, &md->flags))
> -               r = bdi_bits;
> -       else
> -               r = dm_table_any_congested(map, bdi_bits);
> +       atomic_inc(&md->pending);
> +       if (test_bit(DMF_BLOCK_IO, &md->flags))
> +               goto done;
>  
> -       dm_table_put(map);
> +       map = dm_get_table(md);
> +       if (map) {
> +               r = dm_table_any_congested(map, bdi_bits);
> +               dm_table_put(map);
> +       }
> +done:

This isn't really the best use of goto.  Intentation isn't going wild
here, so it should be

if (!test_bit(DMF_BLOCK_IO, &md->flags)) {
	... all the code
}
... code after done

If there were more than one goto done; for the error out case, then
fine, but there's only this one.

James
