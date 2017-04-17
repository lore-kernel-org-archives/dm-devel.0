From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH RESEND] dm ioctl: Remove double parentheses
Date: Mon, 17 Apr 2017 11:05:03 -0700
Message-ID: <20170417180503.30435-1-mka@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Grant Grundler <grundler@chromium.org>, Greg Hackmann <ghackmann@google.com>, Michael Davidson <md@google.com>, Matthias Kaehlcke <mka@chromium.org>
List-Id: dm-devel.ids

The extra pair of parantheses is not needed and causes clang to generate
the following warning:

drivers/md/dm-ioctl.c:1776:11: error: equality comparison with extraneous parentheses [-Werror,-Wparentheses-equality]
        if ((cmd == DM_DEV_CREATE_CMD)) {
             ~~~~^~~~~~~~~~~~~~~~~~~~
drivers/md/dm-ioctl.c:1776:11: note: remove extraneous parentheses around the comparison to silence this warning
        if ((cmd == DM_DEV_CREATE_CMD)) {
            ~    ^                   ~
drivers/md/dm-ioctl.c:1776:11: note: use '=' to turn this equality comparison into an assignment
        if ((cmd == DM_DEV_CREATE_CMD)) {
                 ^~
                 =

Also remove another double parentheses that don't cause a warning.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 drivers/md/dm-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 4da6fc6b1ffd..acd8f12439e4 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1778,12 +1778,12 @@ static int validate_params(uint cmd, struct dm_ioctl *param)
 	    cmd == DM_LIST_VERSIONS_CMD)
 		return 0;
 
-	if ((cmd == DM_DEV_CREATE_CMD)) {
+	if (cmd == DM_DEV_CREATE_CMD) {
 		if (!*param->name) {
 			DMWARN("name not supplied when creating device");
 			return -EINVAL;
 		}
-	} else if ((*param->uuid && *param->name)) {
+	} else if (*param->uuid && *param->name) {
 		DMWARN("only supply one of name or uuid, cmd(%u)", cmd);
 		return -EINVAL;
 	}
-- 
2.12.2.762.g0e3151a226-goog
