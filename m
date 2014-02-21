From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 3/8] dm thin: set flag if
 metadata is out of space
Date: Fri, 21 Feb 2014 09:35:41 -0500
Message-ID: <20140221143540.GE4578@redhat.com>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-4-git-send-email-snitzer@redhat.com>
	<20140221142022.GC13298@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140221142022.GC13298@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Feb 21 2014 at  9:20am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> NACK.
> 
> It's odd that the interface has dm-thin telling dm-thin-metadata
> whether or not it's out of space (yet thin-metadata clears it
> itself).  So I don't like the patch from that point of view, though
> it's a minor quibble.

Yeap, minor quibble.. I can expose an interface that lets me reset it to
false after resize -- from thin.  Seems unnecessary given the expected
short lifetime of this code (see below).

> More importantly, running out of metadata space is a serious error
> that causes a transaction to be aborted.  Any thins that contained
> metadata changes in that aborted transaction need to be umounted and
> fscked.  We should not transistion back to WRITE mode just because
> more metadata space is provided since this doesn't force the sys admin
> to repare/check the thins that have lost io.

This is an incremental change that just adds the control of whether the
metadata is out of space or not.  The current kernel code cannot give us
that info.  This is a stop gap until you implement the reserve that
gives us a concrete value to test for to _know_ that metadata is out of
space.  That is why I said as much in the patch header.  Once we have
that this change can be reverted.  But for now it is needed.

> So I'm nacking because I think you're planning to special case running
> out of metadata space, rather than treating it the same as any other
> metadata error (eg, a failed write to the metadata device).
> 
> As we've discussed the correct thing to do when getting any error from
> a metadata operation is:
> 
>   i) Abort the current transaction
> 
>   ii) flick to READ_ONLY mode.  Any thin devices that lost writes due
>       to the abort will reflect this by erroring every subsequent
>       REQ_FUA or REQ_FLUSH.
> 
>   iii) Set a needs_check flag in the metadata to prevent a table
>        reload transitioning to WRITE mode.

I'm not seeing how running out of space on metadata is any different
than any other metadata operation that failed.  The transaction is
aborted, as soon as that happens all bets are off on upper level data
consistency.  So while thin metadata may be perfectly fine, it is still
prudent for the user to check their data.

Patch 7 impsoes this constraint.  It provides all 3 points you listed
above.
