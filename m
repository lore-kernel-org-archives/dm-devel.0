From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/3] Makefile.inc: Allow additional CFLAGS to
 be specified on the command line
Date: Tue, 12 Dec 2017 14:33:20 +0100
Message-ID: <4d434633-5192-278b-aa35-5fb0f5983bb1@gmail.com>
References: <20171212004503.12823-1-bart.vanassche@wdc.com>
	<20171212004503.12823-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171212004503.12823-2-bart.vanassche@wdc.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>, Thomas Deutschmann <whissi@gentoo.org>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


These two pending patches are incompatible.

-------- Forwarded Message --------
Subject: [dm-devel] [PATCH 1/3] Makefile.inc: Allow additional CFLAGS to be specified on the command line
Date: Mon, 11 Dec 2017 16:45:01 -0800
From: Bart Van Assche <bart.vanassche@wdc.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
CC: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com

Compiling the multipath-tools source code with e.g. sparse requires
to specify additional compiler flags on the command line. Modify the
Makefile such that this becomes possible.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 Makefile.inc | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 29c290a22e8f..d953f5ef34e6 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -90,7 +90,8 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
 		  --param=ssp-buffer-size=4
 -CFLAGS		= $(OPTFLAGS) -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
+CFLAGS		:= $(OPTFLAGS) -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
+		   $(CFLAGS)
 BIN_CFLAGS	= -fPIE -DPIE
 LIB_CFLAGS	= -fPIC
 SHARED_FLAGS	= -shared
-- 
2.15.1


-------- Forwarded Message --------
Subject: [dm-devel] [PATCH] multipath-tools: Makefile: Respect standard toolchain related envvars
Date: Thu, 30 Nov 2017 00:23:11 +0100
From: Thomas Deutschmann <whissi@gentoo.org>
To: dm-devel@redhat.com

The Makefile overrides standard envvars that control the toolchain flags.
This patch should set things right without reducing default behavior.

Signed-off-by: Thomas Deutschmann <whissi@gentoo.org>
---
 Makefile.inc | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 29c290a2..951d58fc 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -90,11 +90,12 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
 		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
 		  --param=ssp-buffer-size=4
 -CFLAGS		= $(OPTFLAGS) -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
+CFLAGS		?= $(OPTFLAGS)
+CFLAGS		+= -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
 BIN_CFLAGS	= -fPIE -DPIE
 LIB_CFLAGS	= -fPIC
 SHARED_FLAGS	= -shared
-LDFLAGS		= -Wl,-z,relro -Wl,-z,now
+LDFLAGS		+= -Wl,-z,relro -Wl,-z,now
 BIN_LDFLAGS	= -pie
  # Check whether a function with name $1 has been declared in header file $2.
-- 
2.15.1
