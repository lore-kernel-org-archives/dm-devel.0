From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE]: LIO-Target/ConfigFS for v2.6.27
Date: Thu, 16 Oct 2008 16:11:13 -0700
Message-ID: <1224198674.5556.255.camel__7138.88618997789$1224198774$gmane$org@haakon2.linux-iscsi.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sour>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Greg KH <greg@kroah.com>, Jerome Martin <tramjoe.merin@gmail.com>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, "H. Peter Anvin" <hpa@zytor.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Greetings all,

I am happy to announce the release of LIO-Target/ConfigFS for v2.6.27.

http://linux-iscsi.org/index.php/LIO-Target/ConfigFS

Using ConfigFS it is now possible to create generic storage objects from
Linux/SCSI using struct scsi_device, Linux/BLOCK using struct
block_device and Linux/VFS using struct file into a generic target
infrastructure under /sys/kernel/config/target/core (target_core_mod).
From there, one can create ConfigFS symbolic links to destinations
under /sys/kernel/config/target/iscsi/ (iscsi_target_mod).  The idea is
that any $FABRIC module can access the same storage objects under the
generic target_core_mod configfs infrastracture.

I have primarly been working on completing the configfs conversion for
iscsi_target_mod, and as that work wraps up, I will next be focusing on
target_core_mod and the generic kernel target infrastructure in Linux.
This involves quite a few different things, merging existing in-tree
STGT code into so it can use /sys/kernel/config/target/core, merging out
of tree SCST code for multiple existing fabric modules and hardware
target mode drivers, the Target API, etc.  This work will definately
take lots of time and effort, but the end result will be a complete
target infrastructure under Linux that all manner of folks can use and
take advantage of and to build upon.

Thanks to the many folks you have made suggestions and comments in order
to get packets across the network and blocks down to storage up as
quickly as possible.  It was only ~7 weeks ago that Ming Zhang made the
recommendation to start using configfs, and now 6k new lines of code in
target_core_config.[c,h] and iscsi_target_configfs.[c.h]..  Wow..

As work continues on both fronts:  making iscsi_target_mod upstream
ready, and creating a generic target engine using configfs for
iscsi_target_mod and *ALL* fabric modules, the Linux-iSCSI.org team
invites anyone who is interested to start looking at the code.  You can
do this online at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/lio-core;hb=HEAD

or checkout your own git tree and start posting patching to the
LIO-Target devleopment list.  Instructions for git clone can be found
on:

http://linux-iscsi.org/index.php/LIO-Target

Please feel free to ask questions!

--nab
