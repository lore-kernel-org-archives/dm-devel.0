From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: BUG: unable to handle kernel paging request
Date: Fri, 29 Sep 2017 11:08:28 -0400
Message-ID: <20170929150828.GA24949@redhat.com>
References: <f5fcde71-f10d-7b38-6a66-bef9714e5c4c@citrix.com>
	<20170928175606.GA19419@redhat.com>
	<d072404e-dba4-dee7-b1d8-b55c569be51e@citrix.com>
	<20170928201737.GA19972@redhat.com>
	<9758c2f9-5b47-f354-9d11-8235b3dcf93c@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <9758c2f9-5b47-f354-9d11-8235b3dcf93c@citrix.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Igor Druzhinin <igor.druzhinin@citrix.com>
Cc: bart.vanassche@sandisk.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 28 2017 at  7:19pm -0400,
Igor Druzhinin <igor.druzhinin@citrix.com> wrote:

> On 28/09/17 21:17, Mike Snitzer wrote:
> > 
> > Anyway, the issue you're talking about was also fixed, just not sure of
> > the fix right now but will keep looking.
> > 
> > See: https://www.redhat.com/archives/dm-devel/2016-February/msg00073.html
> > 
> > Could be the various fixes that Bart did to cope with queue teardown
> > races.
> 
> Do you mean those fixes?
> 
> https://www.spinics.net/lists/linux-scsi/msg101312.html

Yes, but there have been _a lot_ of fixes and performance improvements
to DM multipath's blk-mq support independent of those fixes (fixes range
from SCSI, to block core to DM core, to DM multipath).

Trying to make a "stable" 4.4 kernel have all the fixes is a noble task
but I have no interest in taking it on.  Nor do I have time to coach you
(or others) through it.

Just rebase to a newer kernel!  (Sorry)

Mike
