From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [patch] dm-raid1.c  a race bug in rh_dec()
Date: Tue, 2 Aug 2005 21:49:25 +0100
Message-ID: <20050802204925.GE5224@agk.surrey.redhat.com>
References: <004e01c5723e$3ba3da60$1f000064@polaris>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <004e01c5723e$3ba3da60$1f000064@polaris>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 16, 2005 at 02:40:05PM +0800, Zhao Qian wrote:
> patch here to avoid race condition:
 
And further analysis turns up several more races too.

But how many are left after applying the following patch?

Alasdair

--- linux-2.6.9/drivers/md/dm-raid1.c	2005-07-08 22:05:19.000000000 +0100
+++ linux-2.6.9-test/drivers/md/dm-raid1.c	2005-08-02 21:44:32.000000000 +0100
@@ -1229,7 +1230,7 @@ static int __init dm_mirror_init(void)
 	if (r)
 		return r;
 
-	_kmirrord_wq = create_workqueue("kmirrord");
+	_kmirrord_wq = create_singlethread_workqueue("kmirrord");
 	if (!_kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		dm_dirty_log_exit();
