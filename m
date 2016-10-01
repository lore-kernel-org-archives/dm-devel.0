From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/9] md/dm-table: Move an assignment for the variable "end" in
 dm_split_args()
Date: Sat, 1 Oct 2016 09:47:43 +0200
Message-ID: <e3522c84-b4df-2278-aece-dce7ac8350d1@users.sourceforge.net>
References: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <45984567-4421-5f8d-ddf3-eb2a769a1860@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 07:51:55 +0200

Move the assignment for the local variable "end" behind the source code
for the initial two condition checks by this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e74763c..0f60417 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -538,7 +538,7 @@ static char **realloc_argv(unsigned *array_size, char **old_argv)
  */
 int dm_split_args(int *argc, char ***argvp, char *input)
 {
-	char *start, *end = input, *out, **argv;
+	char *start, *end, *out, **argv;
 	unsigned array_size = 0;
 
 	*argc = 0;
@@ -552,6 +552,7 @@ int dm_split_args(int *argc, char ***argvp, char *input)
 	if (!argv)
 		return -ENOMEM;
 
+	end = input;
 	while (1) {
 		/* Skip whitespace */
 		start = skip_spaces(end);
-- 
2.10.0
