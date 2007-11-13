From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC] How to fix system stall on root volume multipath
Date: Tue, 13 Nov 2007 14:30:33 -0500 (EST)
Message-ID: <20071113.143033.74751626.k-ueda@ct.jp.nec.com>
References: <20071110033113.GA22843@agk.fab.redhat.com>
	<20071112.112454.71086888.k-ueda@ct.jp.nec.com>
	<1194915684.6724.66.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1194915684.6724.66.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

On Tue, 13 Nov 2007 02:01:24 +0100, Christophe Varoqui <christophe.varoqui@free.fr> wrote:
> Le lundi 12 novembre 2007  11:24 -0500, Kiyoshi Ueda a crit :
> > Hi Alasdair,
> > 
> > On Sat, 10 Nov 2007 03:31:13 +0000, Alasdair G Kergon <agk@redhat.com> wrote:
> > > On Fri, Nov 09, 2007 at 06:17:19PM -0500, Kiyoshi Ueda wrote:
> > > > If we use multipath for "/", temporal all-paths failure could lead to
> > > > system stall because multipathd depends on callout programs on "/".
> > > > I would like to hear your comments about my idea to fix it.
> > >  
> > > I thought it avoided that problem by pre-loading everything into a ramdisk:
> > > did that code get dropped for some reason?
> > 
> > Thank you for the information!  I had forgotten it!
> > Yes, we used to have it, and it seems to be removed by the commit below:
> >     http://git.kernel.org/gitweb.cgi?p=linux/storage/multipath-tools/.git;a=commitdiff;h=cad20ecf8919b2126ab6f4f793a1a738e9864f59
> > 
> > And probably the following thread is related to the commit.
> >     https://www.redhat.com/archives/dm-devel/2005-July/msg00044.html
> > 
> > 
> > Ben, Christophe,
> > Is that code still problem for current multipathd?
> > And what do you think about my proposal?
>
> I'm not found of yet-another user-visible ramfs for multipathd use,
> that's why I started with the private namespace tricks. The problems are
> still there, and will stay till we stop using pthreads.
> 
> That may happen someday, as one of the main reason for pthread was the
> (blocking ioctl) libdevmapper event collection. And this is being
> superseded by path status uevents.
> 
> But not soon enough, and the private namespace stuff suffers from lack
> of friendliness anyway : we can't expect users to grasp easily that
> changing their prioritizer in /sbin won't be seen by the multipath
> daemon till restart, for example.
> 
> So I propose to start playing with your prioritizers-as-lib idea to see
> if it's practical.
> 
> I prepared the following patch to that effect. It is not complete
> (actually segfaults, no useful prioritizer ported) but can start fixing
> bugs and go where ever your personnal interest leads.

Thank you for the patch.
OK, I'll try the implementation.

Thanks,
Kiyoshi Ueda
