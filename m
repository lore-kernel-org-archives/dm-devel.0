From: Mikulas Patocka <mpatocka@redhat.com>
Subject: snapshots of mirror problems
Date: Wed, 18 Aug 2010 10:50:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1008181021460.7416@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The problem is this:

Creating the first snapshot:
----------------------------

- preloads -cow, -real devices and origin and snapshot targets

- suspends the underlying lv (mirror in this case) without 
DM_SUSPEND_NOFLUSH_FLAG and with DM_SUSPEND_LOCKFS_FLAG. This waits for 
all bios to drain and calls a filesystem driver to bring it to consistent 
state.

- swap table with origin targets

- resumes the underlying lv, the snapshot target and the origin target

Handing a mirror failure:
-------------------------

- preload the new table with linear volume or a mirror with reduced number 
of legs or a mirror with new legs allocated according to the allocation 
policy

- suspend the mirror with "noflush" flag, "noflush" causes that failing 
bios are queued in device mapper

- swap table with the new one

- resume the mirror, queued buis are dequeued and passed to the new device


Now, the problem:
-----------------

1. If you say that these two operations are independednt, two processes 
will race with suspend and resume on the same device. Bad.

2. If you put lock around, it changes into deadlock possibility: if during 
bio draining or filesystem cleanup dm-raid1 suffers a failure, the failure 
can't be recovered.

3. If you are suspending without DM_SUSPEND_NOFLUSH_FLAG, DM_ENDIO_REQUEUE 
is not allowd and requests returned with DM_ENDIO_REQUEUE are returned 
with -EIO (see function dec_pending). So if mirror leg or log failure 
happens, dm-raid1 returns DM_ENDIO_REQUEUE and the I/O is incorrectly 
finished with -EIO. If you remove this DM_ENDIO_REQUEUE->-EIO logic from 
dec_pending, go to case 2 above (deadlock).


As of the possibility "it is very improbable" --- I think there is one 
case where the probability may be more than minimal. If the user has a 
mounted filesystem and doesn't use it for long time, the disk may have 
failed (or be unplugged) and the system doesn't notice it because the disk 
isn't used. Now, if the user creates a snapshot of mirror and it starts 
cleaning up filesystem journal, it may be the point where the disk error 
is detected. But it can't be repaired.

I think it isn't easy to fix (see those 3 points above), the only possible 
ways to fix it would be:

- make the mirror self-sufficient (integrate md) 
or
- attach dummy dm-linear (or snapshot-origin) passthrough target on the 
top of each mirror. If we do it, snapshot creation could suspend this 
dummy passthrough target and simultaneously dmeventd could suspend the 
underlying mirror and there would be no race or deadlock.

Mikulas
