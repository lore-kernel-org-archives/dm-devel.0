From: weiyj_lk@163.com
Subject: [PATCH] dm crypt: fix error return code in crypt_ctr()
Date: Thu, 16 Apr 2015 20:21:25 +0800
Message-ID: <1429186885-21072-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 713a962..8154f58 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1816,6 +1816,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		if (ret)
 			goto bad;
 
+		ret = -EINVAL;
 		while (opt_params--) {
 			opt_string = dm_shift_arg(&as);
 			if (!opt_string) {

