From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Flush deferred queue when dm_suspend() is
	interrupted
Date: Sun, 12 Mar 2006 21:02:08 +0000
Message-ID: <20060312210208.GG25317@agk.surrey.redhat.com>
References: <4410BECD.9080908@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4410BECD.9080908@ce.jp.nec.com>
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

On Thu, Mar 09, 2006 at 06:48:29PM -0500, Jun'ichi Nomura wrote:
> I found in a code review that dm_suspend() doesn't flush
> deferred queue when it's interrupted and failed to suspend.
 
Yup - adding to tree.

> But I don't have a testcase to pick this point

Suspend the device below & issue I/O so the loop won't exit
until you abort the suspend.  That's the reason for that code.

> For the failed dm_suspend() case, there is another problem
> that presuspend is not reverted.

Not a problem yet: no user of that should do anything that needs
reverting should suspension fail, as per the comment (not a FIXME):
       /* This does not get reverted if there's an error later. */

If new targets or enhancements need new hooks then of course
we can consider adding them when the need arises.

Alasdair
-- 
agk@redhat.com
