From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] dm-thin: Add data block size limits to the
	Documentation
Date: Tue, 23 Jul 2013 11:03:16 -0300
Message-ID: <1374588196-9510-1-git-send-email-cmaiolino@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
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
List-Id: dm-devel.ids

$data_block_size can't be any arbitrary number, i.e. its value should be between
64K and 1G. Also, it should be a multiple of 64K.
Add this information to the dm-thin documentation in order to let users know
which values they must use.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 30b8b83..ff1629b 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -104,8 +104,8 @@ primarily interested in thin provisioning may want to use a value such
 as 1024 (512KB).  People doing lots of snapshotting may want a smaller value
 such as 128 (64KB).  If you are not zeroing newly-allocated data,
 a larger $data_block_size in the region of 256000 (128MB) is suggested.
-$data_block_size must be the same for the lifetime of the
-metadata device.
+$data_block_size must be between 128 (64KB) and 2097152 (1GB) and be a multiple
+of 128 (64KB), and the same for the lifetime of the metadata device.
 
 $low_water_mark is expressed in blocks of size $data_block_size.  If
 free space on the data device drops below this level then a dm event
-- 
1.8.1.4
