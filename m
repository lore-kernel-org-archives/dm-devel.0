From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Mon, 16 Feb 2009 02:14:38 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902160213010.32560@hs20-bc2-1.build.redhat.com>
References: <200901231836184950432@163.com>,
	<Pine.LNX.4.64.0901231514590.9877@hs20-bc2-1.build.redhat.com>,
	<200901301800149019891@163.com>,
	<Pine.LNX.4.64.0901301533390.5744@hs20-bc2-1.build.redhat.com>,
	<200901311416111648168@163.com>,
	<Pine.LNX.4.64.0902031505180.28433@hs20-bc2-1.build.redhat.com>,
	<200902051113011850587@163.com>,
	<Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902052218040.5380@hs20-bc2-1.build.redhat.com>,
	<200902061924107769776@163.com>,
	<Pine.LNX.4.64.0902061815440.11986@hs20-bc2-1.build.redhat.com>,
	<200902072041046488539@163.com>,
	<Pine.LNX.4.64.0902090311340.28754@hs20-bc2-1.build.redhat.com>,
	<200902101305353713189@163.com>,
	<Pine.LNX.4.64.0902101832050.386@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902110552550.20020@hs20-bc2-1.build.redhat.com>,
	<200902121131140773281@163.com>,
	<Pine.LNX.4.64.0902130138400.26381@hs20-bc2-1.build.redhat.com>,
	<Pine.LNX.4.64.0902130229040.2110@hs20-bc2-1.build.redhat.com>
	<200902131912139165975@163.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200902131912139165975@163.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jacky Kim <jcy_2008@163.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Fri, 13 Feb 2009, Jacky Kim wrote:

> Hi,
> 
> 1. I test with the origin LV, and don't write to snapshots.
> 2. I don't delete snapshots when copy big files to the origin LV, but do create snapshot sometimes.
> 3. The snapshots have the same chunk size: 4KB or 64KB.
> 4. It seems to work well with 1 snapshot. But it always crashes each time with 2 snapshots.
> 5. I don't resize the origin device and the snapshots.
> 
> The latest debug information is as follows:

Ohhh, the last patch from me was wrong, so it could produce a false 
positive, so its result is unusable. Apply this on the top of it.

Mikulas

---
 drivers/md/dm-snap.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.28-snap-debug/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28-snap-debug.orig/drivers/md/dm-snap.c	2009-02-16 08:09:22.000000000 +0100
+++ linux-2.6.28-snap-debug/drivers/md/dm-snap.c	2009-02-16 08:09:47.000000000 +0100
@@ -874,6 +874,7 @@ static struct bio *put_pending_exception
 	pe->snap->store.check_pending_exception(&pe->snap->store, pe, __LINE__);
 
 	primary_pe = pe->primary_pe;
+	pe->primary_pe = NULL;
 
 	if (primary_pe) {
 		if (atomic_read(&primary_pe->ref_count) <= 0 || primary_pe->magic != 0x12345678) {
