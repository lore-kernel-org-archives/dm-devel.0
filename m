From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH v2 2/3] init: Stricter checking of major:minor root= values
Date: Tue, 10 Feb 2015 15:20:50 -0800
Message-ID: <1423610451-22600-2-git-send-email-dehrenberg@chromium.org>
References: <1423610451-22600-1-git-send-email-dehrenberg@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423610451-22600-1-git-send-email-dehrenberg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, snitzer@redhat.com, agk@redhat.com
Cc: grundler@chromium.org, gwendal@chromium.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com, Dan Ehrenberg <dehrenberg@chromium.org>
List-Id: dm-devel.ids

In the kernel command-line, previously, root=1:2jakshflaksjdhfa would
be accepted and interpreted just like root=1:2. This patch adds
stricter checking so that additional characters after major:minor are
rejected by root=.

The goal of this patch is to help in unifying dm's interpretation of
its block device argument with the interpretation in other parts of
the kernel. dm rejects malformed major:minor pairs, and it seems
reasonable that root= could reject them as well.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 init/do_mounts.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 4b2daf1..24f359f 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -226,8 +226,9 @@ dev_t name_to_dev_t(const char *name)
 
 	if (strncmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
+		char dummy;
 
-		if (sscanf(name, "%u:%u", &maj, &min) == 2) {
+		if (sscanf(name, "%u:%u%c", &maj, &min, &dummy) == 2) {
 			res = MKDEV(maj, min);
 			if (maj != MAJOR(res) || min != MINOR(res))
 				goto fail;
-- 
2.2.0.rc0.207.ga3a616c
