From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm transaction manager: handle space map checker
	failure
Date: Wed, 20 Jun 2012 18:15:43 -0400
Message-ID: <20120620221542.GA18880@redhat.com>
References: <1340220299-17771-1-git-send-email-snitzer@redhat.com>
	<20120620212010.GK22599@redhat.com>
	<20120620213756.GL22599@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120620213756.GL22599@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Jun 20 2012 at  5:37pm -0400,
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Jun 20, 2012 at 05:20:10PM -0400, Vivek Goyal wrote:
> > On Wed, Jun 20, 2012 at 03:24:59PM -0400, Mike Snitzer wrote:
> > > If CONFIG_DM_DEBUG_SPACE_MAPS is enabled and dm_sm_checker_create()
> > > fails, dm_tm_create_internal() would still return success even though it
> > > cleaned up all resources it was supposed to have created.
> > > 
> > > Fix the space map checker code to return an appropriate ERR_PTR and have
> > > dm_tm_create_internal() check for it with IS_ERR.
> > > 
> > 
> > I tested the patch and it works. It fails gracefully instead of segfaulting.
> > 
> > device-mapper: reload ioctl failed: Cannot allocate memory
> > 
> > I still do get waring though about large memory allocation. That's a
> > separate issue though.
> 
> I put a trace_printk() in ca_create() to see how much memory we are trying
> to allocated using kzalloc. And answer is 10485760. Number of blocks
> obtained from space map is 2621440. I think this might be happening because 
> my metadata device size is 10G.

It is.  My metadata device is 1G and I'm seeing nr_blocks=262144

So kzalloc on your system cannot find 10M of contiguous memory.

How does this patch work for you?

diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md/persistent-data/dm-space-map-checker.c
index 6d7c832..75ab11f 100644
--- a/drivers/md/persistent-data/dm-space-map-checker.c
+++ b/drivers/md/persistent-data/dm-space-map-checker.c
@@ -89,7 +89,7 @@ static int ca_create(struct count_array *ca, struct dm_space_map *sm)
 
 	ca->nr = nr_blocks;
 	ca->nr_free = nr_blocks;
-	ca->counts = kzalloc(sizeof(*ca->counts) * nr_blocks, GFP_KERNEL);
+	ca->counts = vzalloc(sizeof(*ca->counts) * nr_blocks);
 	if (!ca->counts)
 		return -ENOMEM;
 
