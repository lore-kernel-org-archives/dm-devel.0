From: mwilck@suse.com
Subject: [PATCH 03/11] multipath-tools: Makefile.inc: allow user
	settings for LDFLAGS
Date: Tue, 12 May 2020 00:39:23 +0200
Message-ID: <20200511223931.18261-4-mwilck@suse.com>
References: <20200511223931.18261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511223931.18261-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

This allows e.g. setting LDFLAGS="-m32 -Wl,-b,elf32-i386" to compile
for a 32bit target on a 64bit system.

Note that, like CFLAGS, the variable needs to be set in the environment,
not on the "make" command line.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 7a59db85..671dd1ca 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -104,7 +104,7 @@ CFLAGS		:= $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 BIN_CFLAGS	= -fPIE -DPIE
 LIB_CFLAGS	= -fPIC
 SHARED_FLAGS	= -shared
-LDFLAGS		= -Wl,-z,relro -Wl,-z,now
+LDFLAGS		:= $(LDFLAGS) -Wl,-z,relro -Wl,-z,now
 BIN_LDFLAGS	= -pie
 
 # Check whether a function with name $1 has been declared in header file $2.
-- 
2.26.2
