From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: superblock may write succeed before other
 metadata blocks because of wirting metadata in async mode.
Date: Tue, 19 Jun 2018 11:00:32 -0400
Message-ID: <20180619150032.GA31378@redhat.com>
References: <20180522005336.GA30152@yyp.> <20180619131106.GA31018@redhat.com>
	<20180619144300.lhygtljn5aoazr5h@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180619144300.lhygtljn5aoazr5h@reti>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Monty Pavel <monty_pavel@sina.com>, dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 19 2018 at 10:43am -0400,
Joe Thornber <thornber@redhat.com> wrote:

> On Tue, Jun 19, 2018 at 09:11:06AM -0400, Mike Snitzer wrote:
> > On Mon, May 21 2018 at  8:53pm -0400,
> > Monty Pavel <monty_pavel@sina.com> wrote:
> > 
> > > 
> > > If dm_bufio_write_dirty_buffers func is called by __commit_transaction
> > > func and power loss happens during executing it, coincidencely
> > > superblock wrote correctly but some metadata blocks didn't. The reason
> > > is we write all metadata in async mode. We can guarantee that we send
> > > superblock after other blocks but we cannot guarantee that superblock
> > > write completely early than other blocks.
> > > So, We need to commit other metadata blocks before change superblock.
> > > 
> > > Signed-off-by: Monty Pavel <monty_pavel@sina.com>
> > > ---
> > >  drivers/md/dm-thin-metadata.c |    8 ++++++++
> > >  1 files changed, 8 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> > > index 36ef284..897d7d6 100644
> > > --- a/drivers/md/dm-thin-metadata.c
> > > +++ b/drivers/md/dm-thin-metadata.c
> > > @@ -813,6 +813,14 @@ static int __commit_transaction(struct dm_pool_metadata *pmd)
> > >  	if (r)
> > >  		return r;
> > >  
> > > +	r = dm_tm_commit(pmd->tm, sblock);
> > > +	if (r)
> > > +		return r;
> > > +
> > > +	r = superblock_lock(pmd, &sblock);
> > > +	if (r)
> > > +		return r;
> > > +
> > >  	disk_super = dm_block_data(sblock);
> > >  	disk_super->time = cpu_to_le32(pmd->time);
> > >  	disk_super->data_mapping_root = cpu_to_le64(pmd->root);
> 
> I don't believe you've tested this; sblock is passed to dm_tm_commit()
> uninitialised, and you didn't even bother to remove the later (and correct)
> call to dm_tm_commit().

I pointed out to Joe that the patch, in isolation, is decieving.  It
_looks_ like sblock may be uninitialized, etc.  But once the patch is
applied and you look at the entirety of __commit_transaction() it is
clear that you're reusing the existing superblock_lock() to safely
accomplish your additional call to dm_tm_commit().

> What is the issue that started you looking in this area?

Right, as my previous reply asked: please clarify if you _know_ your
patch fixes an actual problem you've experienced.  The more details the
better.

Thanks,
Mike
