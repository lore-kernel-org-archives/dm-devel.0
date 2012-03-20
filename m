From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 13/14] dm_thin: commit just before	processing
	a pool target info request
Date: Tue, 20 Mar 2012 10:12:42 +0000
Message-ID: <20120320101241.GA5384@ubuntu>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
	<1331911358-8848-13-git-send-email-ejt@redhat.com>
	<20120319140012.GB4495@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120319140012.GB4495@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 19, 2012 at 02:00:12PM +0000, Alasdair G Kergon wrote:
> On Fri, Mar 16, 2012 at 03:22:36PM +0000, Joe Thornber wrote:
> > This makes the free block counts more accurate.
>  
> I'm not keen on this one: deferring it.
> 
> > --- a/drivers/md/dm-thin.c
> > +++ b/drivers/md/dm-thin.c
> > @@ -2305,6 +2305,15 @@ static int pool_status(struct dm_target *ti, status_type_t type,
> 
> (Used by dmsetup status and wait.)
> 
> > +		/*
> > +		 * If we're in the middle of a transaction the free block
> > +		 * counts can be quite out of date, so we do a quick
> > +		 * commit.
> > +		 */
> > +		r = dm_pool_commit_metadata(pool->pmd);
> > +		if (r)
> > +			return r;
> > +
> 
> 1) If commit fails (repeatedly?) we still need to get the status.
> 
> 2) Could the commit ever be too slow?  (Or re-use NOFLUSH flag to skip it?)

Agreed.  The correct solution is to switch to a read-only mode if the
commit fails, and thus never commit again.  Commit does some io
obviously; not sure what constitutes 'too slow'.

- Joe
