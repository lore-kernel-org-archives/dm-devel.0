From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: Add timeout mechanism for queue_if_no_path
Date: Fri, 10 Jan 2020 14:33:34 -0500
Message-ID: <20200110193334.GA13817@redhat.com>
References: <20200102224512.3605010-1-krisman@collabora.com>
	<20200106162833.GA15829@redhat.com>
	<CACGdZYK25G5BqQeG2AeF9JvwhXOtcFRxxwqGdRugnPC+vYJHXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACGdZYK25G5BqQeG2AeF9JvwhXOtcFRxxwqGdRugnPC+vYJHXQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Khazhismel Kumykov <khazhy@google.com>
Cc: Frank Mayhar <fmayhar@google.com>, dm-devel@redhat.com, Anatol Pomazau <anatol@google.com>, Bharath Ravi <rbharath@google.com>, kernel@collabora.com, Gabriel Krisman Bertazi <krisman@collabora.com>, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 06 2020 at  4:52pm -0500,
Khazhismel Kumykov <khazhy@google.com> wrote:

> On Mon, Jan 6, 2020 at 11:28 AM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > On Thu, Jan 02 2020 at  5:45pm -0500,
> > Gabriel Krisman Bertazi <krisman@collabora.com> wrote:
> >
> > > From: Anatol Pomazau <anatol@google.com>
> > >
> > > Add a configurable timeout mechanism to disable queue_if_no_path without
> > > assistance from multipathd.  In reality, this reimplements the
> > > no_path_retry mechanism from multipathd in kernel space, which is
> > > interesting for cases where we cannot rely on a daemon being present all
> > > the time, in case of failure or to reduce the guest footprint of cloud
> > > services.
> > >
> > > Despite replicating the policy configuration on kernel space, it is
> > > quite an important case to prevent IOs from hanging forever, waiting for
> > > userspace to behave correctly.
> > >
> > > Co-developed-by: Frank Mayhar <fmayhar@google.com>
> > > Signed-off-by: Frank Mayhar <fmayhar@google.com>
> > > Co-developed-by: Bharath Ravi <rbharath@google.com>
> > > Signed-off-by: Bharath Ravi <rbharath@google.com>
> > > Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
> > > Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> > > Signed-off-by: Anatol Pomazau <anatol@google.com>
> > > Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> > > Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> >
> > This seems like a slippery slope.
> >
> > I've heard this line of dm-multipath concern from Google before
> > (e.g. doesn't want to rely on availability of userspace component).
> >
> > Thing is, to properly use dm-multipath (e.g. to reinstate failed paths)
> > multipathd really is needed no?
> Yeah, in order to reinstate the failed paths, or any full recovery, we
> do need the user space component to be running, and this doesn't aim
> to change the responsibilities here. Rather, we're aiming to avoid
> in-kernel hangs/processes lingering indefinitely in unkillable sleep
> due to buggy/unavailable/down userspace multipath daemon.

Sorry but the above patch header clearly states:
"or to reduce the guest footprint of cloud services"

Which implies that multipathd isn't available by design in the
referenced environment.

> >
> > If not, how is it that the proposed patch is all that is missing when
> > multipathd isn't running?  I find that hard to appreciate.
> >
> > So I'm inclined to not accept this type of change.  But especially not
> > until more comprehensive context is given for how Google is using
> > dm-multipath without multipathd.
> 
> This patch isn't aimed at enabling dm-multipath without a userspace
> multipath daemon, rather to avoid processes hanging indefinitely in
> the event the daemon is unable to proceed (for whatever reason).

Again, I don't buy it given the patch header explicitly says
dm-multipath could be deployed in the cloud without the benefit of
multipathd running.

But I'll meet you half-way to start: rather than make the timeout
configurable on a per multipath table basis, please just set a longer
stopgap default and allow that timeout value to be configured with a
module parameter (e.g. dm_multipath.queue_if_no_path_timeout=120,
and setting it to 0 disables the timeout).

This would follow the same pattern that was established by DM
thin-provisioning's no_space_timeout modparm with these commits:
85ad643b dm thin: add timeout to stop out-of-data-space mode holding IO forever
80c57893 dm thin: add 'no_space_timeout' dm-thin-pool module param

That'd save us from having to do a bunch of fiddley DM multpath table
parsing for now.  But if for some crazy reason in the future it is
determined that a longer duration stop-gap timeout cannot be
one-size-fits-all we can layer per device configuration in at that
time.

How does that sound?

Mike
