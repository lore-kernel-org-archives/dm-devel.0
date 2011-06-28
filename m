From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm mpath: fix potential NULL pointer in feature
	arg processing
Date: Tue, 28 Jun 2011 16:12:50 -0400
Message-ID: <1309291970-12674-1-git-send-email-snitzer@redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

If a user specifies an mpath target as having 1 or more features but
doesn't specify the corresponding feature args a NULL pointer occurs
in parse_features() -- @param_name is NULL when passed to strnicmp().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@kernel.org
---
 drivers/md/dm-mpath.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aa4e570..209991b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -807,6 +807,11 @@ static int parse_features(struct arg_set *as, struct multipath *m)
 	if (!argc)
 		return 0;
 
+	if (argc > as->argc) {
+		ti->error = "not enough arguments for features";
+		return -EINVAL;
+	}
+
 	do {
 		param_name = shift(as);
 		argc--;
-- 
1.7.4.4
