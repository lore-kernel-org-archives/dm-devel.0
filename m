From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 0/2] Add suspended state check for target messages
Date: Fri, 13 Nov 2009 00:06:37 -0800
Message-ID: <20091113080637.17587.64935.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds a accessor function that allows determining if a
mapped_device is in the suspended state and then adds this check to the
multipath targets multipath_message function.

As previously described in the email at the archive url provided below the
target_message ioctl can call into the target after suspend completes.
This can cause new work to be queued and actions to be taken by the target
that should be prevented in the suspended state.

http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/10486

---

Mike Anderson (2):
      dm: Add accessor dm_table_md_suspended
      dm: Add suspended check to multipath_message


 drivers/md/dm-mpath.c         |    3 +++
 drivers/md/dm-table.c         |    6 ++++++
 include/linux/device-mapper.h |    1 +
 3 files changed, 10 insertions(+), 0 deletions(-)

--
-andmike

Michael Anderson <andmike@linux.vnet.ibm.com>
