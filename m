From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 02/17] dm snapshot: add suspended flag to
	dm_snapshot
Date: Mon, 16 Nov 2009 13:17:17 -0500
Message-ID: <20091116181716.GA17448@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
	<1256078825-11331-3-git-send-email-snitzer@redhat.com>
	<20091105005635.GN13375@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091105005635.GN13375@agk-dp.fab.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 04 2009 at  7:56pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Tue, Oct 20, 2009 at 06:46:50PM -0400, Mike Snitzer wrote:
> > Allow the snapshot target to be able to verify its state relative to a
> > requested operation.  Allows for invalid operations to be prevented,
> > e.g. an attempt handover an "old" snapshot's exceptions without it
> > having been suspended first.
>  
> OK - same as we do in dm-raid1.
> 
> But just be aware that:
>         /* This does not get reverted if there's an error later. */
>         dm_table_presuspend_targets(map);
> 
> and so it's not identical to querying the dm_suspended() property directly.

Right, it is now clear that I should be using postsuspend.  The handover
patch has a need to know that another snapshot target has been
suspended; setting dm-snapshot's 'suspended' in .presuspend doesn't give
us that information.

So the dm-snapshot-track-suspended-state-in-target.patch that you have
queued should be changed with: s/presuspend/postsuspend/

(the same search and replace is needed in the v7 handover patch)

Mike
