From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Patch added to scsi-pending-2.6: [SCSI] scsi_dh: Use
	SCSI device handler in dm-multipath
Date: Tue, 29 Apr 2008 15:56:29 +0100
Message-ID: <20080429145629.GK18935@agk.fab.redhat.com>
References: <200804241603.m3OG3B5M030182@hera.kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200804241603.m3OG3B5M030182@hera.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, andmike@us.ibm.com, Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 24, 2008 at 04:03:11PM +0000, James Bottomley wrote:
>     This patch converts dm-mpath to scsi hw handlers. It does
>     not add any new functionality and old behaviors and userspace
>     tools work as is except we use the safe clariion default instead
>     of using the userspace setting.

OK.  Comments from my first line-by-line reading of this.

Firstly, the patch header is rather too brief for my liking - the patch
does make some subtle functional changes that ought to be commented upon
to explain to people why they are being made.  (I would have preferred
this patch to have been broken up into smaller ones in a manner that
made the functional changes more obvious i.e. separated from the code
reorganisation.)

1. Currently the supplied hw_handler name is validated at table load
time so userspace cannot create a device using a non-existent
hw_handler.  After this patch it looks as if that validation is delayed
until something starts to access the device - and then the paths simply
get failed, a new failure mode for the userspace tools to handle.  Is
that change hard to avoid or was it judged not worth the effort to leave
things as they were and perform as much validation / resource allocation
as possible up front?

2.  parse_hw_handler() now ignores hw_handler arguments.
Please add a comment to explain that or perhaps log a warning message if
any are supplied.
BTW r looks superfluous now:

        if (read_param(_params, shift(as), &hw_argc, &ti->error))
                return -EINVAL;

3. The dmsetup table output has changed - it no longer matches the input
in the case where arguments got ignored.  I don't think this matters
(unlike a similar issue we had with crypt), but it should be noted in
comments inline.

4.  /* Fields used by hardware handler usage */
Comment doesn't add anything - drop it?

5. char *hw_handler_name;
const?

6. The code now assumes all hw_handlers have a pg_init function: in
practice this is likely to be the case.  Does that permit further
simplification of some of the logic?

7. I note that the 'bypassed' argument to the pg_init function has been
dropped - presumably as none of the existing handlers made any use of
it.

8. A new workqueue is introduced without comment.  Which of the changes
means we need it now?  What's the reason it's not single-threaded
(and per-device)?  Is there a clearer name than "khwhandlerd" -
something that tells people it's connected with multipath, and
can the name of the struct workqueue_struct variable match this?
Previously the hw_handler pg_init function was required to return
immediately.  Can its replacement scsi_dh_activate() block (but not in a
way that could deadlock of course)?  Should some of its functionality be
got out of the way at initialisation time within multipath_ctr()?

9. What does m->path_to_activate give us that m->current_pgpath
doesn't?

10. Is activate_passive_path() an accurate function name?  Is the
supplied path argument always 'passive'?

11. Where has the use of pg_init_retries gone?

I still need to check the updated state machine logic and associated
locking once we have a final version of this patch.

Alasdair
-- 
agk@redhat.com
