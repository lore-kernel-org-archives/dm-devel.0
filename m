From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v4.8 dm-mpath
Date: Fri, 26 Aug 2016 10:26:47 -0400
Message-ID: <20160826142647.GA1876@redhat.com>
References: <afa6895b-7301-2856-a68e-eaf81bde311b@sandisk.com>
	<20160816191241.GA16948@redhat.com>
	<20160817024302.GA29089@redhat.com>
	<a85fe9dc-e09a-152f-8576-13e899cde9c4@sandisk.com>
	<20160818015433.GA8972@redhat.com>
	<ab6df671-d6b3-86b1-72e3-25e162b679b4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ab6df671-d6b3-86b1-72e3-25e162b679b4@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 25 2016 at  1:40pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 08/17/2016 06:54 PM, Mike Snitzer wrote:
> >On Wed, Aug 17 2016 at  8:29pm -0400,
> >Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> >>Earlier today I came up with three patches that avoid the hang in
> >>truncate_inode_pages_range() that I had reported before. It would be
> >>appreciated if you could have a look at these patches. Please keep
> >>in mind that I'm not a dm expert.
> >
> >I don't recall where you mentioned a hang in
> >truncate_inode_pages_range().. ah I see it here:
> >https://patchwork.kernel.org/patch/9202331/
> 
> Hello Mike,
> 
> As usual, thanks for the quick feedback. But it seems like I sent my
> e-mail too soon: after I had sent my e-mail I ran again into the
> truncate_inode_pages_range() hang.

I was skeptical your 3 earlier patches (particularly the __dm_destroy to
use internel suspend patch) would fix anything you care about in your
testing.  __dm_destroy is only used once all references on the DM mpath
device are dropped.  When you do your fio + cable pull tests you're just
bouncing underlying paths around.  You aren't _ever_ destroying the
multipath device.  That is why your __dm_destroy patch seemed off the
mark to me.

> So far I have run the fio +
> simulated cable pulling test with the following configurations:
> * scsi-mq + single queue dm: hang occurs after a few iterations.
> * scsi-mq + dm-mq: hang occurs after a few iterations.
> * single queue scsi + dm-mq: test passes.
> 
> I will have another look at the blk-mq core and scsi-mq core layers.

OK.
