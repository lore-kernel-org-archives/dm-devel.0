From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: What's the status on I/O-stats for dm block devices?
Date: Wed, 23 Nov 2005 00:03:56 +0000
Message-ID: <20051123000356.GG26394@agk.surrey.redhat.com>
References: <20051122223701.GA23045@shuttle.vanvergehaald.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051122223701.GA23045@shuttle.vanvergehaald.nl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Tue, Nov 22, 2005 at 11:37:03PM +0100, Toon van der Pas wrote:
> See: http://bugme.osdl.org/show_bug.cgi?id=1806
 
I wasn't aware of that, but you'll see there's been some work on this
recently:

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
    dm-disk-statistics*

If people can test these patches and report back, I'm hoping to submit them 
for 2.5.16.

  dm-disk-statistics-basic.patch
  dm-disk-statistics-timing.patch

Additional patches for the latest -mm kernels:
  dm-disk-statistics-basic-mm.patch
  dm-disk-statistics-timing-mm.patch

There's also a more-sophisticated dm statistics target module on the way.

PS Another patch there people might like to play with is
  dm-loop.patch
(I haven't reviewed it yet.)


I'm trying to work through the backlog of patches from various
sources and add them to that tree so they can be
cleaned up, tested and submitted upstream.

My plan is:
  editing directory: 
    This is a copy of my working directory.
    A low threshold for acceptance of patches here.
    Some patches might never get any further.
    As patches get closer to being ready for submission upstream they'll shuffle
    higher up the list in the 'series' file.
    Some patches towards the bottom of the list might not even compile yet
    or might break things.
    If you know of patches you'd like me to consider adding, please submit 
    them (again) or send me a URL.  (I still have a backlog after dealing 
    with the LVM2 snapshot work, but patches that more people ask for 
    are likely to get dealt with first.)

  When I rebase to a new kernel, I'll archive the 'editing' directory under
a directory for the old kernel.

  Periodically I'll issue snapshots of the directory as -dm kernels, like
we used to have -udm releases.

Note that any patches submitted now need to be accompanied by a 'Signed-Off-By' 
declaration as per Documentation/SubmittingPatches (section 11).

Alasdair
-- 
agk@redhat.com
