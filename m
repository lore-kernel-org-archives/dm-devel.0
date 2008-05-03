From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 06/10] scsi_dh: Do not allow arguments for
	hardware handlers
Date: Fri, 02 May 2008 17:01:07 -0700
Message-ID: <1209772867.21974.90.camel@chandra-ubuntu>
References: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
	 <20080501215017.27759.37314.sendpatchset@chandra-ubuntu>
	 <20080502224731.GH18935@agk.fab.redhat.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20080502224731.GH18935@agk.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com
List-Id: dm-devel.ids


On Fri, 2008-05-02 at 23:47 +0100, Alasdair G Kergon wrote:
> On Thu, May 01, 2008 at 02:50:17PM -0700, Chandra Seetharaman wrote:
> > Subject: [PATCH 06/10] scsi_dh: Do not allow arguments for hardware handlers
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > The new implementation does not use the arguments provided with the
> > hardware handler. This patch makes the change visible to the user by
> > failing table load when arguments are provided with the hardware handler.
> 
> But then someone supplying such an arg may need to update their
> userspace multipath config file before they can use this new kernel.
> 
> Past experience suggests that changes like that usually come back
> and bite us.  Let's instead just have the kernel log a message noting
> that the args have been ignored and allow people to deal with it at
> their leisure.

Understand.

How does the following patch look ?
--------------------
Subject: [PATCH 06/10] scsi_dh: Print warning when arguments were provided for hardware handlers

From: Chandra Seetharaman <sekharan@us.ibm.com>

The new implementation does not use the arguments provided with the
hardware handler. This patch makes the change visible to the user by
printing a warning to the kernel log.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.25/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25/drivers/md/dm-mpath.c
@@ -656,8 +656,11 @@ static int parse_hw_handler(struct arg_s
 		{0, 1024, "invalid number of hardware handler args"},
 	};
 
-	if (read_param(_params, shift(as), &hw_argc, &ti->error))
-		return -EINVAL;
+	if (read_param(_params, shift(as), &hw_argc, &ti->error)) {
+		if (hw_argc > 1)
+			printk(KERN_WARN "Additional arguments provided to "
+				"hardware handler were ignored\n");
+	}
 
 	if (!hw_argc)
 		return 0;
------------------------
> 
> Alasdair

