From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] dm log: Use ULL suffix for 64-bit constants
Date: Sun, 19 Apr 2015 00:07:30 +0200
Message-ID: <1429394850-8480-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Josef Bacik <jbacik@fb.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: dm-devel.ids

On 32-bit:

drivers/md/dm-log-writes.c: In function =E2=80=98log_super=E2=80=99:
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type
drivers/md/dm-log-writes.c:323: warning: integer constant is too large =
for =E2=80=98long=E2=80=99 type

Add a ULL suffix to WRITE_LOG_MAGIC to fix this.
Also add a ULL suffix to WRITE_LOG_VERSION as it's stored in a __le64
field.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/dm-log-writes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 93e08446a87d06ff..ad1b049ae2ab80a9 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -55,8 +55,8 @@
 #define LOG_DISCARD_FLAG (1 << 2)
 #define LOG_MARK_FLAG (1 << 3)
=20
-#define WRITE_LOG_VERSION 1
-#define WRITE_LOG_MAGIC 0x6a736677736872
+#define WRITE_LOG_VERSION 1ULL
+#define WRITE_LOG_MAGIC 0x6a736677736872ULL
=20
 /*
  * The disk format for this is braindead simple.
--=20
1.9.1
