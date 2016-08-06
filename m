From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/3] revert three devices
Date: Sat,  6 Aug 2016 13:18:34 +0200
Message-ID: <1470482314-4707-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

I'm unsure about some of the options are correct. Sorry for the noise and
double work.

Xose Vazquez Perez (3):
  multipath-tools: revert add TEGILE devices to hardware table
  multipath-tools: revert add INFINIDAT devices to hardware table
  multipath-tools: revert add VIOLIN/CONCERTO ARRAY to hardware table

 libmultipath/hwtable.c | 45 ---------------------------------------------
 1 file changed, 45 deletions(-)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.7.4
