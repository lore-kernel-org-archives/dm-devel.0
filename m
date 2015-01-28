From: Joe Thornber <thornber@redhat.com>
Subject: Re: [patch] dm cache: fix up IS_ERR vs NULL confusion
Date: Wed, 28 Jan 2015 12:11:28 +0000
Message-ID: <20150128121127.GB21433@debian>
References: <20150128064609.GD30893@mwanda>
 <20150128105311.GA21433@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150128105311.GA21433@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Here's my take.  You were destroying the metadata object with the
mutex still held, which I'd been trying to avoid.

commit ea87d6105c1b13c13ece0fc8d9add09c78b1aa4c
Author: Joe Thornber <ejt@redhat.com>
Date:   Wed Jan 28 12:07:46 2015 +0000

    dm-cache: fixup evil err ptrs that were ommitted from earlier patch.

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 8876250..b6dc968 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -683,7 +683,7 @@ static struct dm_cache_metadata *metadata_open(struct block_device *bdev,
        cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
        if (!cmd) {
                DMERR("could not allocate metadata struct");
-               return NULL;
+               return ERR_PTR(-ENOMEM);
        }
 
        atomic_set(&cmd->ref_count, 1);
@@ -745,7 +745,7 @@ static struct dm_cache_metadata *lookup_or_open(struct block_device *bdev,
                return cmd;
 
        cmd = metadata_open(bdev, data_block_size, may_format_device, policy_hint_size);
-       if (cmd) {
+       if (!IS_ERR(cmd)) {
                mutex_lock(&table_lock);
                cmd2 = lookup(bdev);
                if (cmd2) {
@@ -779,9 +779,9 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
                                                 size_t policy_hint_size)
 {
        struct dm_cache_metadata *cmd = lookup_or_open(bdev, data_block_size, may_format_device, policy_hint_size);
-       if (cmd && !same_params(cmd, data_block_size)) {
+       if (!IS_ERR(cmd) && !same_params(cmd, data_block_size)) {
                dm_cache_metadata_close(cmd);
-               return NULL;
+               return ERR_PTR(-EINVAL);
        }
 
        return cmd;
