From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 7/9] libmultipath: don't link alua_rtpg.o twice
Date: Fri, 15 Mar 2019 17:11:53 +0100
Message-ID: <20190315161155.24062-8-mwilck@suse.com>
References: <20190315161155.24062-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190315161155.24062-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We link this already to libmultipath.so. Therefore, no need
to link ti to libprioalua.so, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 4d80c20c..9d0fe03c 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -28,9 +28,6 @@ endif
 
 all: $(LIBS)
 
-libprioalua.so: alua.o alua_rtpg.o
-	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
-
 libpriopath_latency.so: path_latency.o  ../checkers/libsg.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lm
 
-- 
2.21.0
