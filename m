From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 71/74] multipath: use update_pathvec_from_dm()
Date: Wed, 05 Aug 2020 22:22:02 +0200
Message-ID: <ed5732db92891321d5a19a86b598c1b1975856d5.camel@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-19-mwilck@suse.com>
	<20200720025752.GZ11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200720025752.GZ11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, 2020-07-19 at 21:57 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 12:51:42PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > The multipath-specific function update_paths() can now be replaced
> > with
> > a call to update_pathvec_from_dm().
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  multipath/main.c | 67 +++-----------------------------------------
> > ----
> >  1 file changed, 3 insertions(+), 64 deletions(-)
> > 
> > diff --git a/multipath/main.c b/multipath/main.c
> > index 8a2a6f7..435c5d5 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > 
> >  static int
> >  get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec,
> > char * refwwid)
> >  {
> > @@ -273,13 +216,8 @@ get_dm_mpvec (enum mpath_cmds cmd, vector
> > curmp, vector pathvec, char * refwwid)
> >  		condlog(3, "status = %s", status);
> >  
> >  		disassemble_map(pathvec, params, mpp);
> > -
> > -		/*
> > -		 * disassemble_map() can add new paths to pathvec.
> > -		 * If not in "fast list mode", we need to fetch
> > information
> > -		 * about them
> > -		 */
> > -		update_paths(mpp, (cmd == CMD_LIST_SHORT));
> > +		update_pathvec_from_dm(pathvec, mpp,
> > +				       (cmd == CMD_LIST_SHORT ? 0 :
> > DI_ALL));
> 
> I personally don't think that "multipath -l" should be opening the
> path
> fd. Checking sysfs seems like the limit of what we want to do for
> fast
> listing. So, I would prefer
> 
> update_pathvec_from_dm(pathvec, mpp,
> 		       (cmd == CMD_LIST_SHORT ? DI_NOIO : DI_ALL));
> 
> That will make pathinfo exit early.

Good suggestion. But then I need to avoid rerunning pathinfo() for
already scanned paths in update_pathvec_from_dm(). Will do.

Regards
Martin
