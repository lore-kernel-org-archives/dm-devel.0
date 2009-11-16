From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 0/2] dm-mpath: mutex and suspended check for
	messages
Date: Sun, 15 Nov 2009 23:38:19 -0800
Message-ID: <20091116073819.4070.40173.stgit@localhost.localdomain>
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

This patch series is applied on top of the patch previously posted by
Kiyoshi Ueda. Archive url provided below.

http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/10504

This patch series adds a mutex and element to the multipath structure to
allow synchronization between possible work creators and callers flushing
work while providing indication of suspended state.

---

Mike Anderson (2):
      dm-mpath: Add mutex to synchronize adding and flushing work
      dm-mpath: Add element for suspended state.


 drivers/md/dm-mpath.c |   71 +++++++++++++++++++++++++++++++++++--------------
 1 files changed, 50 insertions(+), 21 deletions(-)

--
-andmike

Michael Anderson <andmike@linux.vnet.ibm.com>
