From: Joe Thornber <thornber@redhat.com>
Subject: Re: About the thin provision function @ kernel 3.2 or
 later.
Date: Tue, 17 Jan 2012 10:13:31 +0000
Message-ID: <20120117101330.GA15182@ubuntu>
References: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
	<20120116143816.GA2184@ubuntu> <20120116155959.GC4667@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120116155959.GC4667@thunk.org>
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

Hi Ted,

Thanks for taking time to look at thinp.

On Mon, Jan 16, 2012 at 10:59:59AM -0500, Ted Ts'o wrote:
> Thanks for making a pointer to the paper available!  I have a question
> about one of the slides, where you say: "snapshots of external
> origins".  Am I correct in suppose this means you can take a snapshot
> of something which is currently not a thin-provisioned volume?

...

> Is this a feature which is yet to be implemented?  And if so, what's
> the timeline for implementing it.

Yes, that's exactly it.  I do want to support it in the near future
(2-3 months).  There are a few options on this front.

i) We only support a read-only external origin.  Of course people can
use snapshots if they want writeable versions of the current state.
An explicit merge facility will need to be added if people want to
copy the snap back over the origin.  This is by far the simplest
approach, and I'll probably start with this - at least in a dev branch.

ii) We support read/write origins.  When I last looked at this 15
months ago I struggled to come up with a metadata design that allowed
both efficient snapshot lookup _and_ efficient snapshot deletion.  I'm
expecting people to use many, many more snapshots with thinp; deletion
performance really is a problem.

iii) We add support to patch metadata changes into the running
metadata device.  This would allow us to map the origin directly into
the pools data device (eg, using a linear target).  And then introduce
a mapping for that origin.  This would mean the origin would appear as
a thin dev within the pool.  This approach greatly improves the
performance since we wouldn't have to always COW on the first write to
an origin block (i.e. the overlapping block optimisation is still
valid).

> If this is not a feature to be implemented, can I please put it on the
> wishlist?  I can imagine a lot of ext4 users who would be interested
> in thin-provisioning, especially if there is discard support such than
> when we delete a file, we send a discard which causes the
> thin-provisioned space in the snapshot to be dropped.  (This is also
> apparently not implemented, from what I can tell from the source; do
> you have an approximate idea of where in the priority list / when it
> is scheduled to be implemented?)

Discard was in until recently.  There were some race conditions
associated with it that I didn't have time to work through before the
merge window.  Expect this to reappear sometime in the next 2-3 months.

- Joe
