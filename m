From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipathing pending issues with rhel
Date: Wed, 8 Oct 2008 17:11:48 -0500
Message-ID: <20081008221148.GC6453@ether.msp.redhat.com>
References: <20081008230725.3ece5f56@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081008230725.3ece5f56@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 08, 2008 at 11:07:25PM +0200, Christophe Varoqui wrote:
> Ben,
> 
> I'd like to summarize all the issues I raised recently through my
> employers support channel on the multipath subsystem.
> And see if something can be done about it, at least in the upstream
> concerned codebases.
> 
> 1/ multipathd private namespace pins lvm2 logical volumes maps mounted
> at daemon startup, thus making "vgchange -ay" fail, even after
> umounting the visible mount. In my context, it also means I can't stop
> a clustered service build on this vg to start it on another node. This
> problem does not affect upstream which does not create a private
> namespace.

This already has a fix queued for 5.3.  Multipathd now unounts all of
the unnecessary mount points after creating the private namespace.

> 
> 2/ can't map a rw multipath over read-only paths. Quick workaround to
> create ro multipath, but ro->rw promotion is not automatic when paths
> become writable. I keep thinking we should allow rw multipath over ro
> paths. The ro->rw event might also work, but what will trigger the
> kernel rw status change in the first place ? To my knowledge, only a
> manual scsi device rescan can force this status update ... which
> accounts for a less user-friendly solution than the former.

The workaround is in place for 5.3, but I fully agree that a kernel
patch to allow rw maps on top of ro devices is the way to go in the
future.

> 3/ Can't use scsi-3 persistent reservations on clariion multipathed
> luns : paths reserved on node A, writes submitted on node B should be
> errored immediately to ensure data integrity. Instead, writes get
> buffered in the "queue_if_no_path" logic, and finally corrupt the data
> when reservation get cleared. In my context, reservation is the
> prefered io fencing method for clusters.
> The kernel knows the write io submitted on a path is refused due to a
> reservation conflict, but this status is not propagated to multipath
> for it to react by not queuing this io as it should.
> 
> Regards,
> cvaroqui
