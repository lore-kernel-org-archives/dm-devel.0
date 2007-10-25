From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: noflush resizing (0/3)
Date: Thu, 25 Oct 2007 02:24:56 +0100
Message-ID: <20071025012456.GK10006@agk.fab.redhat.com>
References: <471FB83D.4060307@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <471FB83D.4060307@ce.jp.nec.com>
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Oct 24, 2007 at 05:25:17PM -0400, Jun'ichi Nomura wrote:
>   - For some device-mapper targets (multipath and mirror),
>     the mapping table sometimes has to be replaced to cope with device
>     failure.
>     OTOH, device-mapper flushes all pending I/Os upon table replacement
>     and may result in I/O errors, if there are device failures.
>     'noflush' suspend is used to let dm queue the pending I/Os
>     instead of flushing them.
>     Since it's not possible for user space program to tell whether
>     the suspend could cause I/O error, they always use
>     'noflush' to suspend mirror/multipath targets.
> 
>   - Currently resizing is disabled for 'noflush' suspend.
>     Resizing occurs in the course of table replacement.
>     To resize the device under use, device-mapper needs to get its
>     bdev inode. However, using bdget() in this case could cause deadlock
>     by waiting for I_LOCK where an I/O process holding I_LOCK is
>     waiting for completion of table replacement.
 
Before reviewing the details of the proposed workaround, I'd like to see
a deeper analysis of the problem to see that there isn't a cleaner way
to resolve this.

For example:

Question) What are the realistic situations we must support that lead to
a resize during table reload with I/O outstanding?

- The resize is the purpose of the reload; noflush is only set to avoid losing
I/O if a path should fail.  So any outstanding I/O may be expected to be
consistent with both the old and new sizes of the device.  E.g. If it's
beyond the end of a shrinking device and userspace cared about not
losing that I/O, it would have waited for that I/O to be flushed
*before* issuing the resize.  If the I/O is beyond the end of the
existing device but within the new size, userspace would have waited for
the resize operation to complete before allowing the new I/O to be
issued.

=> Is it OK for device-mapper to handle the device size check
internally, rejecting any I/O that falls beyond the end of the table (it
already must do this lookup anyway), and to update the size recorded in
the inode later, after I/O is flowing through the device again, but (of
course) before reporting that the resize operation is complete?
I.e. does it eliminate deadlocks if the bdget() and i_size_write()
happen after the 'resume'?

Alasdair
-- 
agk@redhat.com
