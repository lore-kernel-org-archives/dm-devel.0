From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm: noflush resizing (0/3)
Date: Thu, 25 Oct 2007 10:18:02 -0400
Message-ID: <4720A59A.8060001@ce.jp.nec.com>
References: <471FB83D.4060307@ce.jp.nec.com>
	<20071025012456.GK10006@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071025012456.GK10006@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Alasdair,

Alasdair G Kergon wrote:
> Before reviewing the details of the proposed workaround, I'd like to see
> a deeper analysis of the problem to see that there isn't a cleaner way
> to resolve this.

OK. Let me try.

> For example:
> 
> Question) What are the realistic situations we must support that lead to
> a resize during table reload with I/O outstanding?

'noflush' is currently the only option for userspace to suspend without
risking otherwise-avoidable I/O lost, because failure of underlying
device might occur *after* the userspace started normal suspend
but *before* the flushing completes. (normal suspend = flushing suspend)

E.g. if userspace wants to resize dm-mpath device with queue_if_no_path,
it has to use 'noflush' suspend on table swapping.
Otherwise, path failures during the suspend will cause I/O error,
though queue_if_no_path is specified.

Other possible solution would be allowing the suspend to fail if it
can't flush all I/O and letting userspace to retry after fixing
the device failure.

> - The resize is the purpose of the reload; noflush is only set to avoid losing
> I/O if a path should fail.  So any outstanding I/O may be expected to be
> consistent with both the old and new sizes of the device. E.g. If it's
> beyond the end of a shrinking device and userspace cared about not
> losing that I/O, it would have waited for that I/O to be flushed
> *before* issuing the resize.  If the I/O is beyond the end of the
> existing device but within the new size, userspace would have waited for
> the resize operation to complete before allowing the new I/O to be
> issued.

If userspace cares about not losing I/O, it should wait for the I/O
before trying to shrink the device size.
After the shrinking started, any I/O beyond the new end of the device
would have a possibility of lost.

Reducing the size of the device while actively running I/O on it
would anyway have a possibility of losing some of the I/O.

> If the I/O is beyond the end of the
> existing device but within the new size, userspace would have waited for
> the resize operation to complete before allowing the new I/O to be
> issued.

Issuing the I/O beyond the end of the existing device would get error.
If the issuer knows the device will be extended, it should wait for
the completion of the extention.
If it doesn't know, such I/O won't be issued.


> => Is it OK for device-mapper to handle the device size check
> internally, rejecting any I/O that falls beyond the end of the table (it

I think this check is needed in current dm, regardless of noflush.

> already must do this lookup anyway), and to update the size recorded in
> the inode later, after I/O is flowing through the device again, but (of
> course) before reporting that the resize operation is complete?
> I.e. does it eliminate deadlocks if the bdget() and i_size_write()
> happen after the 'resume'?

There is no guarantee that the I/O flowing through the device again.
The table might need be replaced again, but to do that, the resume
should have been completed to let the userspace know it.

bdget() in noflush suspend has a possibility of stall.
Once it stalls, the remedy is userspace to replace the table with
working one. However, since bdget() occurs inside of suspend_lock,
it's not possible to run other instance of suspend/resume.
OTOH, calling bdget() and i_size_write() outside of the lock
can cause race with other table swapping and may result in setting
wrong device size.

Also, bdget() allocates new bdev inode if there isn't.
But dm wants to access bdev inode only when it exists in memory.
So something like bdlookup() will fit for the purpose, IMO.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
