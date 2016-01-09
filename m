From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [RFC] disk doesn't spin down with thin pool +
	dmeventd
Date: Sat, 9 Jan 2016 11:51:32 +0000
Message-ID: <5690F444.1010108@gmail.com>
References: <568EBD08.70800@gmail.com> <5690DBF1.6020409@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5690DBF1.6020409@gmail.com>
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

On 09/01/16 10:07, Alan Jenkins wrote:
> On 08/01/16 08:17, Zdenek Kabelac wrote:
> > Dne 7.1.2016 v 20:31 Alan Jenkins napsal(a):
> >> Hi
> >>
> >> I tried using Docker on my Fedora NAS box.  It created a thin pool LV,
> >> which
> >> caused hard drive activity every ~10 seconds.
> >>
> >> dmeventd queries the thin pool every 10 seconds, and it causes a
> >> transaction
> >> commit in order to make sure the statistics are up to date. But
> >> transactions
> >> are already supposed to be committed after 1 second. (See
> >> Documentation/device-mapper/thin-provisioning.txt, "Updating on-disk
> >> metadata").
> >>
> >> It seems like a simple case of "don't do that".  The kernel already
> >> lets us
> >> avoid the commit.  How about it (patch below)?  If it seems
> >> reasonable, I can
> >> whip up a commit message for it.
> >>
> >
> > Hi
> >
> > I believe it's already solved upstream in version 2.02.133
> > of lvm2 package with this commit:
> >
> > 81e9ab3156badecc6a64447708c4ae4886e3c244
> > Date: Thu Oct 22 12:36:25 2015 +0200
> >
> > Which version of lvm2 are you using ?
> >
> > Regards
> >
> > Zdenek
>
> Thanks! That explains a question I had.
>
> My patch was based on lvm2 master. The upstream commit applies to the 
> _status_ task, but I applied dm_task_no_flush() to the _wait_ task: 
> DM_DEVICE_WAITEVENT / DM_DEV_WAIT_CMD.
>
> I need to test this again, and I shall. (I started testing with 
> version lvm2-2.02.132-2.fc23.x86_64).
>
> But from the code, it looks like we need *both* patches to fix the 
> problem. See:
>
>
> 1. dm-ioctl.c: dev_wait() seems to include the exact same code as 
> dev_table_status, specifically the call to __dev_status():

Nevermind.  For me, the upstream commit fixes the problem on its own.

The wait task does get run every 10 seconds.  But the 10 second timeout 
interrupts it before __dev_status() is called.  So setting noflush on 
the status task, had already fixed the problem.

Thanks
Alan


P.S. if anyone wants to take my comment describing the problem, they're 
still welcome :).

	/*
	 * Avoid repeatedly forcing a flush.
	 *
	 * Allow the disks to sleep, and accept "out-of-date" statistics.
	 * E.g. affects thin pools.  Commits will occur every second already,
	 * if the pool state is changing.
	 */
