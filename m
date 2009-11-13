From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 0/3] Add deleting state check for target messages
Date: Fri, 13 Nov 2009 00:04:22 -0800
Message-ID: <20091113080422.17412.49305.stgit@localhost.localdomain>
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
mapped_device is in the deleting state and then adds this check to the
target_message function. The result of this change would be that all
targets would not be allowed to process messages post a mapped device
entering the deleting state.

As previously described in the email at the archive url provided below the
target_message ioctl can result in new work / activities being started
post the mapped device entering states that new target work could cause
issues.

http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/10486

This patch depends on the previous patch that added dm_suspended_check due
to proximity of changes in common files.

---

Mike Anderson (3):
      dm: Add dm_deleting accesor function
      dm: Add accessor dm_table_md_deleting
      dm: Add deleting check to target_message


 drivers/md/dm-ioctl.c         |    6 ++++++
 drivers/md/dm-table.c         |    6 ++++++
 drivers/md/dm.c               |    5 +++++
 include/linux/device-mapper.h |    2 ++
 4 files changed, 19 insertions(+), 0 deletions(-)

--
-andmike

Michael Anderson <andmike@linux.vnet.ibm.com>
