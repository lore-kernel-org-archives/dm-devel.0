From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/6] Delete attributes with default values
Date: Sat,  9 Jul 2016 01:58:42 +0200
Message-ID: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
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

Xose Vazquez Perez (6):
  multipath-tools: delete attributes with DEFAULT_* values in hwtable.c
  multipath-tools: delete prio_args attribute when it is equal to default value
  multipath-tools: delete no_path_retry attribute when it is equal to default value
  multipath-tools: delete minio_rq attribute when it is equal to default value
  multipath-tools: delete fast_io_fail attribute when it is equal to default value
  multipath-tools: delete pgpolicy attribute when it is equal to default value

 libmultipath/hwtable.c | 226 -------------------------------------------------
 1 file changed, 226 deletions(-)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

--
2.7.4
