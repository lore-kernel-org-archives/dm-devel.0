From: monty <monty_pavel@sina.com>
Subject: Re: dm thin: superblock may write succeed before other
 metadata blocks because of wirting metadata in async mode.
Date: Thu, 21 Jun 2018 12:54:54 -0400
Message-ID: <47936.7960048423$1529545495@news.gmane.org>
References: <20180522005336.GA30152@yyp.> <20180619131106.GA31018@redhat.com>
	<20180619144300.lhygtljn5aoazr5h@reti>
	<20180619150032.GA31378@redhat.com> <20180620170357.GA5838@yyp.>
	<20180620145117.GA4323@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180620145117.GA4323@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, thornber@redhat.com
List-Id: dm-devel.ids


On Wed, Jun 20, 2018 at 10:51:17AM -0400, Mike Snitzer wrote:
> 
> On Wed, Jun 20 2018 at  1:03pm -0400,
> monty <monty_pavel@sina.com> wrote:
> 
> > 
> > On Tue, Jun 19, 2018 at 11:00:32AM -0400, Mike Snitzer wrote:
> > > 
> > > On Tue, Jun 19 2018 at 10:43am -0400,
> > > Joe Thornber <thornber@redhat.com> wrote:
> > > 
> > > > On Tue, Jun 19, 2018 at 09:11:06AM -0400, Mike Snitzer wrote:
> > > > > On Mon, May 21 2018 at  8:53pm -0400,
> > > > > Monty Pavel <monty_pavel@sina.com> wrote:
> > > > > 
> > > > > > 
> > > > > > If dm_bufio_write_dirty_buffers func is called by __commit_transaction
> > > > > > func and power loss happens during executing it, coincidencely
> > > > > > superblock wrote correctly but some metadata blocks didn't. The reason
> > > > > > is we write all metadata in async mode. We can guarantee that we send
> > > > > > superblock after other blocks but we cannot guarantee that superblock
> > > > > > write completely early than other blocks.
> > > > > > So, We need to commit other metadata blocks before change superblock.
> > > > > > 
> > > > > > Signed-off-by: Monty Pavel <monty_pavel@sina.com>
> > > > > > ---
> > > > > >  drivers/md/dm-thin-metadata.c |    8 ++++++++
> > > > > >  1 files changed, 8 insertions(+), 0 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> > > > > > index 36ef284..897d7d6 100644
> > > > > > --- a/drivers/md/dm-thin-metadata.c
> > > > > > +++ b/drivers/md/dm-thin-metadata.c
> > > > > > @@ -813,6 +813,14 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
> > > > > >  	if (r)
> > > > > >  		return r;
> > > > > >  
> > > > > > +	r = dm_tm_commit(pmd->tm, sblock);
> > > > > > +	if (r)
> > > > > > +		return r;
> > > > > > +
> > > > > > +	r = superblock_lock(pmd, &sblock);
> > > > > > +	if (r)
> > > > > > +		return r;
> > > > > > +
> > > > > >  	disk_super = dm_block_data(sblock);
> > > > > >  	disk_super->time = cpu_to_le32(pmd->time);
> > > > > >  	disk_super->data_mapping_root = cpu_to_le64(pmd->root);
> > > > 
> > > > I don't believe you've tested this; sblock is passed to dm_tm_commit()
> > > > uninitialised, and you didn't even bother to remove the later (and correct)
> > > > call to dm_tm_commit().
> > > 
> > > I pointed out to Joe that the patch, in isolation, is decieving.  It
> > > _looks_ like sblock may be uninitialized, etc.  But once the patch is
> > > applied and you look at the entirety of __commit_transaction() it is
> > > clear that you're reusing the existing superblock_lock() to safely
> > > accomplish your additional call to dm_tm_commit().
> > > 
> > > > What is the issue that started you looking in this area?
> > > 
> > > Right, as my previous reply asked: please clarify if you _know_ your
> > > patch fixes an actual problem you've experienced.  The more details the
> > > better.
> > > 
> > > Thanks,
> > > Mike
> > > 
> > Hi, Mike and Joe. Thanks for your reply. I read __commit_transaction
> > many times and didn't find any problem of 2-phase commit. I use
> > md-raid1(PCIe nvme and md-raid5) in write-behind mode to store dm-thin
> > metadata.
> > Test case:
> > 1. I do copy-diff test on thin device and then reboot my machine.
> > 2. Rebuild our device stack and exec "vgchang -ay".
> > The thin-pool can not be established(details_root become a bitmap node
> > and metadata's bitmap_root become a btree_node).
> 
> But are you saying your double commit in __commit_transaction() serves
> as a workaround for the corruption you're seeing?
> 
> Is it just a case where raid5's writebehind mode is _not_ safe for your
> storage config?  By "reboot" do you mean a clean shutdown?  Or a forced
> powerfail scenario?
> 
> Mike
> 
Reboot my machine means exec reboot command.
My patch seems unnecessary, because 2-phase commit have ensure that
committing superblock after other metadata have written to metadata
device.
This problem is hard to recreate, it didn't happen after applying the
patch above. I will check my device stack if there is any possible that
superblock write complete early than other metadata block.

Monty
