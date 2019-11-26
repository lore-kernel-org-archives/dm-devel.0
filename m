From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH] dm clone: Add to the documentation index
Date: Tue, 26 Nov 2019 14:00:31 +0200
Message-ID: <6635828b-2ca6-c4d4-fc70-46e9a0bd2ed5@arrikto.com>
References: <2044145.ITN4Tc4rAJ@archlinux>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2044145.ITN4Tc4rAJ@archlinux>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: diegocg@gmail.com
List-Id: dm-devel.ids

From: Diego Calleja <diegocg@gmail.com>

It was missing from the initial commit

Signed-off-by: Diego Calleja <diegocg@gmail.com>

---
  Documentation/admin-guide/device-mapper/index.rst | 1 +
  1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/index.rst b/
Documentation/admin-guide/device-mapper/index.rst
index c77c58b8f67b..d8dec8911eb3 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -8,6 +8,7 @@ Device Mapper
      cache-policies
      cache
      delay
+    dm-clone
      dm-crypt
      dm-flakey
      dm-init
-- 
2.24.0
