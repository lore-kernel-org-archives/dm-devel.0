From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: no_path_retry: NO_PATH_RETRY_FAIL vs NO_PATH_RETRY_UNDEF
Date: Mon, 7 Nov 2016 17:11:33 +0100
Message-ID: <de9f8dce-c3d4-b371-6c99-5cf9226d8f09@gmail.com>
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
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,


NO_PATH_RETRY_UNDEF is 0


no_path_retry    Specify what to do when all paths are down. Possible values are:

                    value > 0   number of retries until disable I/O queueing.

                    fail        for immediate failure (no I/O queueing).

                    queue       for never stop I/O queueing. Similar to queue_if_no_path.



Is there any real difference?


Thank you.
