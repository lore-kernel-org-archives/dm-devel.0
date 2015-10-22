From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache: clean cache resyncs to origin on every boot
Date: Thu, 22 Oct 2015 18:19:36 +0100
Message-ID: <20151022171935.GA4296@rh-vpn>
References: <CAGRJ0wqVAcNkEJsW5o2vYPFY3doL1Nt5oD8M78w3gvL+t2Xnsw@mail.gmail.com>
	<20151020143304.GA15948@rh-vpn>
	<CAGRJ0wrPEo9m0kKeGy0U9BErKC=_GGUUgfgJn=NZm2cQpHnb3w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAGRJ0wrPEo9m0kKeGy0U9BErKC=_GGUUgfgJn=NZm2cQpHnb3w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Oct 20, 2015 at 11:06:07PM +0500, Bogdan Vasiliev wrote:
> Volume was clearly removed without dirty cahe blocks, re-initialized
> and began full re-sync to the origin. Is this normal behavior?

No, there is indeed a bug, fixed with the patch below.

Thanks,

- Joe


commit 7e0a9739fd9e72dc51490bdff92796400b12a34f
Author: Joe Thornber <ejt@redhat.com>
Date:   Thu Oct 22 18:10:55 2015 +0100

    [dm-cache] The CLEAN_SHUTDOWN flag was not being set
    
    or rather, it was being set on the disk, then immediately cleared again.
    
    If the CLEAN_SHUTDOWN flag is not set when a cache is loaded then all cache
    blocks are marked as dirty and a full writeback occurs.

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index e956c44..2073d30 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -634,10 +634,11 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 
        disk_super = dm_block_data(sblock);
 
+       disk_super->flags = cpu_to_le32(cmd->flags);
+
        if (mutator)
                update_flags(disk_super, mutator);
 
-       disk_super->flags = cpu_to_le32(cmd->flags);
        disk_super->mapping_root = cpu_to_le64(cmd->root);
        disk_super->hint_root = cpu_to_le64(cmd->hint_root);
        disk_super->discard_root = cpu_to_le64(cmd->discard_root);
