From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] dm flakey: fix error return code in flakey_ctr()
Date: Mon,  8 Aug 2016 14:09:27 +0000
Message-ID: <1470665367-12771-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Fix to return error code -EINVAL instead of 0(r is overwrote to
0 by dm_read_arg() call), as done elsewhere in this function.

Fixes: e80d1c805a3b ("dm: do not override error code returned
from dm_get_device()")
Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/md/dm-flakey.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 19db13e..f0cb0fe 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -200,11 +200,13 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (!(fc->up_interval + fc->down_interval)) {
 		ti->error = "Total (up + down) interval is zero";
+		r = -EINVAL;
 		goto bad;
 	}
 
 	if (fc->up_interval + fc->down_interval < fc->up_interval) {
 		ti->error = "Interval overflow";
+		r = -EINVAL;
 		goto bad;
 	}

