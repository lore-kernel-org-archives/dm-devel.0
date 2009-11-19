From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 00/12] snapshot-merge target
Date: Thu, 19 Nov 2009 12:45:52 -0500
Message-ID: <20091119174551.GA5852@redhat.com>
References: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
	<87y6m24uyk.fsf@basil.nowhere.org>
	<20091119140233.GA3894@redhat.com>
	<20091119145338.GF6644@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091119145338.GF6644@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>
List-Id: dm-devel.ids

On Thu, Nov 19 2009 at  9:53am -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Nov 19, 2009 at 09:02:33AM -0500, Mike Snitzer wrote:
> > DM (and LVM) snapshot merging allows a snapshot (its COW store) to be
> > merged back into the snapshot's origin device.
> > One expected use of snapshot merging is rollback of a root filesystem
> > after system upgrades (e.g.: yum update).
> 
> Has the patch to 'Documentation/device-mapper' been written yet?
> (It won't go upstream until we have that of course.  Same for the
> replicator and any other new dm targets.)

Nope, I'll work on that (and adding comments like Andi suggested).  I'll
include these changes into the v4 snapshot-merge patchset submission
that I'll be getting out today.  The v4 patchset will be based on v9 of
the handover patch that we worked on (which I just emailed to dm-devel).

Mike
