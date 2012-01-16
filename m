From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: About the thin provision function @ kernel 3.2 or
 later.
Date: Mon, 16 Jan 2012 10:59:59 -0500
Message-ID: <20120116155959.GC4667@thunk.org>
References: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
	<20120116143816.GA2184@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120116143816.GA2184@ubuntu>
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

On Mon, Jan 16, 2012 at 02:38:17PM +0000, Joe Thornber wrote:
> 
> There are a couple of documents here:
> 
> https://github.com/jthornber/storage-papers/tree/master/thinp-snapshots-2011
> 
> I'll be updating the presentation soon for a talk next month.

Hi Joe,

Thanks for making a pointer to the paper available!  I have a question
about one of the slides, where you say: "snapshots of external
origins".  Am I correct in suppose this means you can take a snapshot
of something which is currently not a thin-provisioned volume?

If so, is this currently implemented?  Looking at the documentation in
the v3.2's Documentation/device-mapper/thin-provisioning.txt, I don't
see a way of doing it:

    create_snap <dev id> <origin id>

    Create a new snapshot of another thinly-provisioned device.
    <dev id> is an arbitrary unique 24-bit identifier chosen by
    the caller.
    <origin id> is the identifier of the thinly-provisioned device
    of which the new device will be a snapshot.

Is this a feature which is yet to be implemented?  And if so, what's
the timeline for implementing it.

If this is not a feature to be implemented, can I please put it on the
wishlist?  I can imagine a lot of ext4 users who would be interested
in thin-provisioning, especially if there is discard support such than
when we delete a file, we send a discard which causes the
thin-provisioned space in the snapshot to be dropped.  (This is also
apparently not implemented, from what I can tell from the source; do
you have an approximate idea of where in the priority list / when it
is scheduled to be implemented?)

Many thanks,

						- Ted
