From: Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH] dm-kcopyd: Correctly free requests
Date: Fri, 26 Aug 2011 12:15:42 +0200
Message-ID: <20110826101542.GB20197@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

kcopyd only frees the requests if the master job information is set up
correctly, but it was not in the recently added path. This leads to many
unfreed slabs during snapshot usage.

Signed-off-by: Bastian Blank <waldi@debian.org>
Tested-by: Andreas Barth <aba@not.so.argh.org>

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index f821470..32ac708 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -628,6 +628,7 @@ void *dm_kcopyd_prepare_callback(struct dm_kcopyd_client *kc,
 	job->kc = kc;
 	job->fn = fn;
 	job->context = context;
+	job->master_job = job;
 
 	atomic_inc(&kc->nr_jobs);
 
-- 
Landru! Guide us!
		-- A Beta 3-oid, "The Return of the Archons", stardate 3157.4
