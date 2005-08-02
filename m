From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: mirror patches - device failure detection/race
	fix/deadlock fix
Date: Tue, 2 Aug 2005 16:04:28 -0500
Message-ID: <23dfce5ae45001c2cd544b7160621bb6@redhat.com>
References: <278411eef6c06676d89c4ab5530cde8e@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: multipart/mixed; boundary=Apple-Mail-8-828064171
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <278411eef6c06676d89c4ab5530cde8e@redhat.com>
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
List-Id: dm-devel.ids


--Apple-Mail-8-828064171
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

On Aug 2, 2005, at 11:00 AM, Jonathan E Brassow wrote:

> The first 4 patches (0000[1234].patch) are the device failure  
> detection patches.  They've been cleaned up a bit from the last time  
> they were posted.
>
> The 'race.patch' fixes a couple race conditions that were a result of  
> the __rh_alloc() function releasing and regrabbing a lock when called.
>
> The 'deadlock.patch' switches all spin_lock calls on the region_lock  
> to spin_lock_irqsave.  Without this patch you machine will hang.
>
> The patches apply in the order described, and should apply to kernels  
> 2.6.12 - 2.6.13-rc5.
>
> I've made them all attachments to this e-mail.  If people don't like  
> it this way, let me know, and I'll do it lkml style.
>
>  brassow
>
> <00001.patch><00002.patch><00003.patch><00004.patch><race.patch><deadlo 
> ck.patch>--
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


I'm an idiot.  :)

The 0000[1234].patch files remain unchanged, but you can forget about  
the race & deadlock patch files.  For fixes to those problems, try this  
new race patch.

QA has confirmed that this patch has at least taken care of the  
problems I was trying to address with the other patches...

  brassow


--Apple-Mail-8-828064171
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream; x-unix-mode=0664; name="race2.patch"
Content-Disposition: attachment;
	filename=race2.patch

diff -purN linux-2.6.13-rc5-04/drivers/md/dm-raid1.c linux-2.6.13-rc5-05/drivers/md/dm-raid1.c
--- linux-2.6.13-rc5-04/drivers/md/dm-raid1.c	2005-08-02 15:31:27.590377441 -0500
+++ linux-2.6.13-rc5-05/drivers/md/dm-raid1.c	2005-08-02 15:20:22.331704140 -0500
@@ -1563,7 +1563,7 @@ static int __init dm_mirror_init(void)
 	if (r)
 		return r;
 
-	_kmirrord_wq = create_workqueue("kmirrord");
+	_kmirrord_wq = create_singlethread_workqueue("kmirrord");
 	if (!_kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		dm_dirty_log_exit();
@@ -1571,7 +1571,7 @@ static int __init dm_mirror_init(void)
 	}
 	INIT_WORK(&_kmirrord_work, do_work, NULL);
 
-	_kmir_mon_wq = create_workqueue("kmir_mon");
+	_kmir_mon_wq = create_singlethread_workqueue("kmir_mon");
 	if (!_kmir_mon_wq) {
 		DMERR("couldn't start kmir_mon");
 		dm_dirty_log_exit();

--Apple-Mail-8-828064171
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed



--Apple-Mail-8-828064171
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Apple-Mail-8-828064171--
