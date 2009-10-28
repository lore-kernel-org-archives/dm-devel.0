From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: possible regression by the barrier patch in
	2.6.30-rc2
Date: Wed, 28 Oct 2009 15:21:39 +0000
Message-ID: <20091028152139.GP25303@agk-dp.fab.redhat.com>
References: <49E80C1E.1040905@ct.jp.nec.com>
	<20090417132252.GA7843@agk.fab.redhat.com>
	<49EBF994.90801@ct.jp.nec.com>
	<Pine.LNX.4.64.0904200217230.22707@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904200217230.22707@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Well let's go back to first principles.

There are two types of suspend.

(1) I don't care about the ordering of the I/O on the disk relative to
the suspend.  This one is easy: it's --noflush --nolockfs.

(2) I do want some control over the state of the device at the point
of the suspend.

Break this second case down.
If I have a filesystem, I require it to be consistent, so I require lockfs.

If the device belongs to a userspace database, I require it to be consistent,
so I must pause the database, at which point there is no further I/O being
issued to the device, then I suspend (and everything prior to this must be
flushed) and resume etc.  This can be either a "suspend with flush" OR the
flush could have been issued prior to the suspend (and any decent database
would have done that).

If I have any other application owning the device that cares about the
state on the device at the point of the suspend it *must* stop issuing
I/O while the suspend ioctl is run.  If any I/O continues to arrive
during the suspend, then that tells us we are necessarily in case (1).

So the implementation of 'suspend with flush' is simply 'issue a flush
using the standard mechanism for doing this and then issue a suspend'.
The 'suspend' itself does not need any special handling for 'flush'.
In practice, anything that requires a flush will issue it prior to
calling the suspend ioctl and not send I/O concurrently with the
suspend.  For backwards compatibility we could still support the
'suspend with flush' as I described - issue a flush internally before
entering the code that performs the suspend.

Alasdair
