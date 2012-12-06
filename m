From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/3] dm-ioctl: fix unsafe use of
	dm_ioctl.data_size
Date: Thu, 6 Dec 2012 21:22:16 +0000
Message-ID: <20121206212216.GJ6834@agk.fab.redhat.com>
References: <Pine.LNX.4.64.1211221918270.11244@file.rdu.redhat.com>
	<Pine.LNX.4.64.1211221919540.11244@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211221919540.11244@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I don't think we need to support the situation when the value changes during
the copying of the parameters, so how about something more like this instead?

Alasdair


From: Alasdair G Kergon <agk@redhat.com>

Abort dm ioctl processing if userspace changes the data_size parameter
after we validated it but before we finished copying the data buffer
from userspace.

The dm ioctl parameters are processed in the following sequence:
 1. ctl_ioctl() calls copy_params();
 2. copy_params() makes a first copy of the fixed-sized portion of the
    userspace parameters into the local variable "tmp";
 3. copy_params() then validates tmp.data_size and allocates a new
    structure big enough to hold the complete data and copies the whole
    userspace buffer there;
 4. ctl_ioctl() reads userspace data the second time and copies the whole
    buffer into the pointer "param";
 5. ctl_ioctl() reads param->data_size without any validation and stores it
    in the variable "input_param_size";
 6. "input_param_size" is further used as the authoritative size of the
    kernel buffer.

The problem is that userspace code could change the contents of user
memory between steps 2 and 4.  In particular, the data_size parameter
can be changed to an invalid value after the kernel has validated it.
This lets userspace force the kernel to access invalid kernel memory.

The fix is to ensure that the size has not changed at step 4.

This patch shouldn't have a security impact because CAP_SYS_ADMIN is
required to run this code, but it should be fixed anyway.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/drivers/md/dm-ioctl.c
===================================================================
--- linux.orig/drivers/md/dm-ioctl.c
+++ linux/drivers/md/dm-ioctl.c
@@ -1566,6 +1566,14 @@ static int copy_params(struct dm_ioctl _
 	if (copy_from_user(dmi, user, tmp.data_size))
 		goto bad;
 
+	/*
+	 * Abort if something changed the ioctl data while it was being copied.
+	 */
+	if (dmi->data_size != tmp.data_size) {
+		DMERR("rejecting ioctl: data size modified while processing parameters");
+		goto bad;
+	}
+
 	/* Wipe the user buffer so we do not return it to userspace */
 	if (secure_data && clear_user(user, tmp.data_size))
 		goto bad;
