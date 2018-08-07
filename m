From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Is thin provisioning still experimental?
Date: Tue, 7 Aug 2018 17:11:21 -0400
Message-ID: <20180807211120.GA29735@redhat.com>
References: <CAN-y+EK612pGsJTH-zO=FU0DpcFJxKfEHuDNs+6ufE6we9aK+g@mail.gmail.com>
	<20180723140053.GA28984@redhat.com>
	<20180723140734.GB28984@redhat.com>
	<CAN-y+E+9J5w8fx-UYcT9+2SxqFL8nzkn3BYE6cWpW=yP9KdDtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAN-y+E+9J5w8fx-UYcT9+2SxqFL8nzkn3BYE6cWpW=yP9KdDtA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Drew Hastings <dhastings@crucialwebhost.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

[Please don't top-post.. it really compromises the ability to provide
proper context for inlined replies, etc]

On Fri, Aug 03 2018 at 11:13pm -0400,
Drew Hastings <dhastings@crucialwebhost.com> wrote:

>    Thank you for that insight, I appreciate it.
>    Can you elaborate on your concern related to running out of space?
>
>    Assuming the metadata device always has space, is it unsafe to let the the
>    data device for the thin pool run out of space if queue_if_no_space is
>    set? Would it not be safe on the block IO level?

You definitely want to avoid running out of metadata space.  That is one
area where we seem to have some lingering issues (that we're actively
working to find).

But running out of data space isn't a huge problem, especially if you'd
like to queue the IO indefinitely because you're closely administering
the space on your host with the hypervisor that will consume the thinp
devices.

You can configure a timeout for the queuing (after timeout expires the
thin-pool will transition to error_if_no_space mode).  It defaults to 60
seconds.  But you can also disable the timeout be setting it to 0.
 
>    > No idea what, if any, filesystem you intend to run but XFS has the
>    ability to discontinue retries for certain error conditions.  I highly
>    recommend you enable that for ENOSPC, otherwise you _will_ see the kernel
>    block indefinitely in XFS if thinp runs out of space underneath XFS.
> 
>    My use case involves doing block level IO for virtual machines with KVM...
>    so there's virtualization in between the thin device and whatever the VM
>    is doing. In that scenario, I would expect the IO requests to just hang
>    until the thin pool is provided more space for the data device and queued
>    IO from the VM would just wait for that. Maybe what you're describing with
>    XFS wouldn't be an issue on that setup, since XFS would be running within
>    the VM.

Yes, you can have it hang indefinitely (waiting for thin-pool resize) by
setting the 'no_space_timeout' module paramter for dm-thin-pool to 0,
e.g.:

modprobe dm-thin-pool no_space_timeout=0
or
echo 0 > /sys/module/dm_thin_pool/parameters/no_space_timeout

That just puts more importance on the admin (I assume you) feeding the
thin-pool extra free space as needed.

lvm2 has some pretty robust support for resizing both the thin-pool's
data and metadata devices.  Please have a look at the 'lvmthin' manpage
that is provided with a more recent lvm2 package.

Thanks,
Mike
