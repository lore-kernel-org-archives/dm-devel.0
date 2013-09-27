From: Frank Mayhar <fmayhar@google.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Fri, 27 Sep 2013 09:37:13 -0700
Message-ID: <1380299833.25252.82.camel@bobble.lax.corp.google.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com> <524520B0.6010003@suse.de>
	<52453C76.6060403@suse.de> <20130927083742.GA683@agk-dp.fab.redhat.com>
	<52458DBA.5090109@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52458DBA.5090109@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, 2013-09-27 at 15:52 +0200, Hannes Reinecke wrote:
> On 09/27/2013 10:37 AM, Alasdair G Kergon wrote:
> > But this still dodges the fundamental problem:
> > 
> >   What is the right value to use for the timeout?
> >   - How long should you wait for a path to (re)appear?
> >     - In the current model, reinstating a path is a userspace 
> >       responsibility.
> > 
> And with my proposed patch it would still be userspace which is
> setting the timeout.
> Currently, no_path_retry is not a proper measure anyway, as it's
> depending on the time multipathd takes to complete a path check
> round. Which depends on the number of device, the state of those etc.
> 
> > The timeout, as proposed, is being used in two conflicting ways:
> >   - How long to wait for path recovery when all paths went down
> 
> That would be set via the new 'no_path_timeout' feature, which would
> be set instead of the (multipath-internal) no_path_retry
> setting.

Yes, this matches our setup as well.

> >   - How long to wait when the system locks without enough free
> >     memory even to reinstate a path (because of broken userspace
> >     code) before having multipath fail queued I/O in a desperate
> >     attempt at releasing memory to assist recovery
> Do we even handle that case currently?

My understanding is that the current code doesn't, no, but if it does I
would love to know how.

> Methinks this is precisely the use-case this is supposed to address.

Yes, exactly.

> When currently 'no_path_retry' is set _and_ we're running under a
> low-mem condition there is a quite large likelyhood that the
> multipath daemon will be killed by the OOM-killer or not able to
> send any dm messages down to the kernel, as the latter most likely
> require some memory allocations.
> 
> So in the current 'no_path_retry' scenario the maps would have been
> created with 'queue_if_no_path', and the daemon would have to reset
> the 'queue_if_no_path' flag if the no_path_retry value expires.
> Which it might not be able to do so due to the above scenario.
> 
> So with the proposed 'no_path_timeout' we would enable the dm-mpath
> module to terminate all outstanding I/O, irrespective on all
> userland conditions. Which seems like an improvement to me ...

And to me, which is why I went in this direction in the first place.  I
could see no dependable way to deal with outside of the kernel; if I
had, I would have taken it, since userspace changes are _much_ easier
for us to deal with than kernel changes.
-- 
Frank Mayhar
310-460-4042
