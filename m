From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: dm-ioctl on amd64 with 32bit userspace
Date: Thu, 20 Sep 2007 20:46:41 +0200
Message-ID: <20070920184641.GA5869@bogon.ms20.nix>
References: <20070917165726.GA11958@bogon.ms20.nix>
	<20070920153210.GP18444@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070920153210.GP18444@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,
On Thu, Sep 20, 2007 at 04:32:10PM +0100, Alasdair G Kergon wrote:
> Does this (untested) also work for you?
> 
> +	if (new_name < (char *) (align_ptr(param + 1) - 4) ||
> 
Yes this seems to work, I used:

Signed-off-by: Guido Guenther <agx@sigxcpu.org>

--- aa-amd64-smp/drivers/md/dm-ioctl.c	2007-09-17 14:51:10.000000000 +0000
+++ linux-2.6.22/drivers/md/dm-ioctl.c	2007-07-08 23:32:17.000000000 +0000
@@ -700,7 +700,7 @@
 	int r;
 	char *new_name = (char *) param + param->data_start;
 
-	if (new_name < (char *) (param + 1) ||
+	if (new_name < (char *) (align_ptr(param + 1) - 4) ||
 	    invalid_str(new_name, (void *) param + param_size)) {
 		DMWARN("Invalid new logical volume name supplied.");
 		return -EINVAL;
@@ -726,7 +726,7 @@
 	if (!md)
 		return -ENXIO;
 
-	if (geostr < (char *) (param + 1) ||
+	if (geostr < (char *) (align_ptr(param + 1) - 4) ||
 	    invalid_str(geostr, (void *) param + param_size)) {
 		DMWARN("Invalid geometry supplied.");
 		goto out;
@@ -1233,7 +1233,7 @@
 	if (r)
 		goto out;
 
-	if (tmsg < (struct dm_target_msg *) (param + 1) ||
+	if (tmsg < (struct dm_target_msg *) (align_ptr(param + 1) - 4) ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMWARN("Invalid target message parameters.");
 		r = -EINVAL;
