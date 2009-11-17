From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2 02/17] dm snapshot: add suspended flag to
	dm_snapshot
Date: Tue, 17 Nov 2009 02:24:30 +0000
Message-ID: <20091117022430.GA6644@agk-dp.fab.redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
	<1256078825-11331-3-git-send-email-snitzer@redhat.com>
	<20091105005635.GN13375@agk-dp.fab.redhat.com>
	<20091116181716.GA17448@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091116181716.GA17448@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 16, 2009 at 01:17:17PM -0500, Mike Snitzer wrote:
> So the dm-snapshot-track-suspended-state-in-target.patch that you have
> queued should be changed with: s/presuspend/postsuspend/
 
Changed.

As discussed earlier, as we have something that works, we'll leave the
suspended state tracking as-is for now.  Then once all the batches of
patches for the next kernel are signed off, we can return to this and
clean it up in all the targets.

Alasdair
