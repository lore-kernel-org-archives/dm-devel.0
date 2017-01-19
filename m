From: Peter Desnoyers <pjd@ccs.neu.edu>
Subject: Question about dmsetup / udev interactions
Date: Thu, 19 Jan 2017 17:43:53 -0500
Message-ID: <55BECEAF-A213-425D-87F8-9C83ABA4DDA9@ccs.neu.edu>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
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
To: dm-devel@redhat.com
Cc: Mohammad Hossein Hajkazemi <hajkazemi@gmail.com>, MAniA Abdi <mania.abdi287@gmail.com>
List-Id: dm-devel.ids

I'm not quite sure where to start with this. We've got a device mapper target (implementing a translation layer over shingled disk) where a lot of the functionality is up at user level. In our current design, when the target is first created it doesn't have any mapping information, and so must block all I/Os until the user space daemon has fed that information to it, after which it unblocks any pending I/Os.

The problem we have is a deadlock with udev - when the target device appears, udev seems to try to read its partition table, hanging until the userspace daemon sends the map down and enables I/Os. However some versions of dmsetup / libdevmapper interact with udev, so the device doesn't get created (and thus we can't feed it the map) because we're blocked on udevd.

At the moment we're not really sure where to start looking to figure a way out of this - would it be a udev rules change or something simple like that? Or for now should we just rebuild the LVM tools with one or two of the thirty-odd options set to a different value?

Any suggestions on which direction we should start looking would be welcome.

Thanks,
.....................................................................
 Peter Desnoyers                                  pjd@ccs.neu.edu
 Northeastern Computer & Information Science      (617) 373-8683
