From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2 02/17] dm snapshot: add suspended flag to
	dm_snapshot
Date: Thu, 5 Nov 2009 00:56:35 +0000
Message-ID: <20091105005635.GN13375@agk-dp.fab.redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
	<1256078825-11331-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1256078825-11331-3-git-send-email-snitzer@redhat.com>
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

On Tue, Oct 20, 2009 at 06:46:50PM -0400, Mike Snitzer wrote:
> Allow the snapshot target to be able to verify its state relative to a
> requested operation.  Allows for invalid operations to be prevented,
> e.g. an attempt handover an "old" snapshot's exceptions without it
> having been suspended first.
 
OK - same as we do in dm-raid1.

But just be aware that:
        /* This does not get reverted if there's an error later. */
        dm_table_presuspend_targets(map);

and so it's not identical to querying the dm_suspended() property directly.

Alasdair
