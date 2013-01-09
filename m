From: Ritesh Raj Sarraf <rrs@debian.org>
Subject: [PATCH 3/3] Drop useless link to curses library
Date: Wed,  9 Jan 2013 14:02:48 +0530
Message-ID: <1357720368-17664-3-git-send-email-rrs@debian.org>
References: <1357720368-17664-1-git-send-email-rrs@debian.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357720368-17664-1-git-send-email-rrs@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: Ritesh Raj Sarraf <rrs@debian.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Description: Do not link against ncurses unnecessarily
Author: Sven Joachim <svenjoac@gmx.de>
Bug-Debian: http://bugs.debian.org/646148
Last-Update: <2011-11-05>

Signed-off-by: Ritesh Raj Sarraf <rrs@debian.org>
---
 multipathd/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/Makefile b/multipathd/Makefile
index 9553251..b490c1d 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -6,7 +6,7 @@ include ../Makefile.inc
 # basic flags setting
 #
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
-LDFLAGS += -lpthread -ldevmapper -lreadline -lncurses -ludev -ldl \
+LDFLAGS += -lpthread -ldevmapper -lreadline -ludev -ldl \
 	   -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
 
 #
-- 
1.7.10.4
