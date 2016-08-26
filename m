From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v4.8 dm-mpath
Date: Fri, 26 Aug 2016 12:35:21 -0400
Message-ID: <20160826163521.GA2480@redhat.com>
References: <afa6895b-7301-2856-a68e-eaf81bde311b@sandisk.com>
	<20160816191241.GA16948@redhat.com>
	<20160817024302.GA29089@redhat.com>
	<a85fe9dc-e09a-152f-8576-13e899cde9c4@sandisk.com>
	<20160818015433.GA8972@redhat.com>
	<ab6df671-d6b3-86b1-72e3-25e162b679b4@sandisk.com>
	<20160826142647.GA1876@redhat.com>
	<47ef2a90-d465-9afa-ef1a-51b43f5c7915@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <47ef2a90-d465-9afa-ef1a-51b43f5c7915@sandisk.com>
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

On Fri, Aug 26 2016 at 11:33am -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 08/26/2016 07:26 AM, Mike Snitzer wrote:
> >On Thu, Aug 25 2016 at  1:40pm -0400,
> >Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> >>As usual, thanks for the quick feedback. But it seems like I sent my
> >>e-mail too soon: after I had sent my e-mail I ran again into the
> >>truncate_inode_pages_range() hang.
> >
> >I was skeptical your 3 earlier patches (particularly the __dm_destroy to
> >use internel suspend patch) would fix anything you care about in your
> >testing.  __dm_destroy is only used once all references on the DM mpath
> >device are dropped.  When you do your fio + cable pull tests you're just
> >bouncing underlying paths around.  You aren't _ever_ destroying the
> >multipath device.  That is why your __dm_destroy patch seemed off the
> >mark to me.
> 
> Hello Mike,
> 
> In case it wasn't clear, I want to drop the three patches you
> referred to. But I also want to clarify that my tests *do* trigger
> __dm_destroy(). If you have a look at the srp-test scripts then you
> will see that "dmsetup remove" is invoked after each test. What I
> see is that lock_page() and other page cache functions hang
> sporadically around the time the dm device is removed, most likely
> due to I/O that is submitted but never completed. That's why I
> started looking at the scsi-mq/blk-mq device removal code.

We're going round and round with a test that doesn't reflect 99% of the
usage that DM multipath sees.  I think we need to take a step back and
re-evaluate the test in question.

Could well be that there is some problem with outstanding IO racing with
DM multipath device removal.  BUT I'd really appreciate it if you could
make the 'dmsetup remove' phase secondary.  You're welcome to keep the
test you have (with DM device removal mixed with IO), make it
configurable with a flag or whatever, but it strikes me as much more of
a niche concern.  Not dismissing the need to make whatever it is you're
doing work.. but we're seriously conflating all the variables in play.

Customers aren't removing their multipath devices a lot.  So can we do
this?

test step1:
Lets at least verify that DM multipath fault handling capabilities
during normal IO in the face of cable pulls is reliable (be them
syntehtic pulls or real).

test step2:
Once the IO completes (after paths are restored) and fio ends _then_
DM multipath devices can be removed.

You'll note that all mptest tests follow this 2 step pattern.
