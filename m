From: Mikulas Patocka <mpatocka@redhat.com>
Subject: snapshot of mirror (was: possible regression by the
 barrier patch in 2.6.30-rc2)
Date: Thu, 5 Nov 2009 21:42:13 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911052134190.18661@hs20-bc2-1.build.redhat.com>
References: <49E80C1E.1040905@ct.jp.nec.com>
	<20090417132252.GA7843@agk.fab.redhat.com>
	<49EBF994.90801@ct.jp.nec.com>
	<Pine.LNX.4.64.0904200217230.22707@hs20-bc2-1.build.redhat.com>
	<20091028152139.GP25303@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911042042350.22545@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911042057050.27821@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911042057050.27821@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Anyway, suspend unconditionally purges all I/Os from target drivers. All 
> that this "noflush" flag does is that it allows the I/O to be held and 
> requeued for new dm table incarnation, if the target requests it with 
> DM_MAPIO_REQUEUE (dm-raid1 and dm-multipath do it). If no target returns 
> DM_MAPIO_REQUEUE, then "flush" and "noflush" suspend is equivalent.

Hmm, I think it makes snapshot-of-mirrors implementation impossible.

If we create the first snapshot or delete the last snapshot, we must 
inevitably suspend the underlying origin device. If we do a "flush" 
suspend and mirror log or leg fails at the same time, the i/o would be 
incorrectly returned with -EIO. If we do a "noflush" suspend, we couldn't 
synchronize the filesystem on snapshot creation and we couldn't get the 
I/Os out of origin target (because they would be queued in the underlying 
-real device).

Mirrors must to be self-sufficient (i.e. handle errors on their own 
without queuing i/os and needing immediate action of dmeventd) to enable 
snapshots-of-mirrors work. Jon, will your log duplication work meet this 
requirement?

Mikulas
