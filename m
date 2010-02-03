From: Alex Zeffertt <alex.zeffertt@eu.citrix.com>
Subject: [PATCH] multipathd pthread locking fix
Date: Wed, 3 Feb 2010 11:39:25 +0000
Message-ID: <4B69606D.2090206@eu.citrix.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090301060204090205040605"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--------------090301060204090205040605
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

The following patch is needed to stop multipathd segfaulting on uClibc.

Regards,

Alex Zeffertt

--------------090301060204090205040605
Content-Type: text/x-diff; name="dm-multipath-fix-pthread-bug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dm-multipath-fix-pthread-bug.patch"

Fix pthread bug in multipath-tools.

You should lock the mutex before doing a pthread_cond_wait otherwise
undefined results occur.  In fact we get away with this with glibc,
but with uclibc it causes a segfault.


Signed-off-by: Alex Zeffertt <alex.zeffertt@eu.citrix.com>

--- ./multipathd/main.c.orig	2010-02-03 05:42:14.000000000 -0500
+++ ./multipathd/main.c	2010-02-03 05:43:13.000000000 -0500
@@ -1668,6 +1668,7 @@
 	/*pthread_create(&uevent_thr, &attr, ueventloop, vecs);*/
 	pthread_create(&uxlsnr_thr, &attr, uxlsnrloop, vecs);
 
+	lock(&exit_mutex);
 	pthread_cond_wait(&exit_cond, &exit_mutex);
 
 	/*

--------------090301060204090205040605
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090301060204090205040605--
