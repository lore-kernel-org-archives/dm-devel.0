From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Allow userland access to metadata of a live thin
 provisioning pool
Date: Tue, 22 May 2012 17:21:38 -0400
Message-ID: <20120522212138.GA6495@redhat.com>
References: <1337266042-2875-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1337266042-2875-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, May 17 2012 at 10:47am -0400,
Joe Thornber <ejt@redhat.com> wrote:

> New feature.
> 
> This patch implements two new messages that can be sent to the thin
> pool target allowing it to take a snapshot of the _metadata_.  This,
> read-only snapshot can be accessed by userland, concurrently with the
> live target.
> 
> Only one metadata snapshot can be held at a time.  The pool's status
> line will give the block location for the current msnap.
> 
> The thin-provisioning-tools have been updated to v0.1.5.  The
> thin_dump program can now be used to display the msnap.  eg,
> 
>     thin_dump -m <msnap root> <metadata dev>
> 
> Available here: https://github.com/jthornber/thin-provisioning-tools
> 
> Now that userland can access the metadata we can do various things
> that have traditionally been kernel side tasks:
> 
>      i) Incremental backups.
> 
>      By using metadata snapshots we can work out what blocks have
>      changed over time.  Combined with data snapshots we can ensure
>      the data doesn't change while we back it up.
> 
>      A short proof of concept script can be found here:
> 
>      https://github.com/jthornber/thinp-test-suite/blob/master/incremental_backup_example.rb
> 
>      ii) Migration of thin devices from one pool to another.
> 
>      iii) Merging snapshots back into an external origin.
> 
>      iv) Asyncronous replication.

Hey Joe,

You forgot your Signed-off-by.

I reviewed the patch and had a few suggestions; please see the following
small incremental patch (Alasdair please feel free to fold these nits
into Joe's original patch).

The switch from dm_tm_unlock() to dm_bm_unlock() in 2 places was done
because the block was locked with the block-manager (rather than a tm
wrapper).

There are still remnants of "held root" but I didn't feel that strongly
to change the superblock's variable name, clean up the header comment,
etc.

Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/thin-provisioning.txt |    2 +-
 drivers/md/dm-thin-metadata.c                     |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 897e66da..f5cfc62 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -292,7 +292,7 @@ iii) Messages
         Reserve a copy of the data mapping btree for use by userland.
         This allows userland to inspect the mappings as they were when
         this message was executed.  Use the pool's status command to
-        get the root block.
+        get the root block associated with the metadata snapshot.
 
     release_metadata_snap
 
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 7e272e2..f53c6d0 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1093,7 +1093,8 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 	 * Copy the superblock.
 	 */
 	dm_sm_inc_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
-	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION, &sb_validator, &copy, &inc);
+	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION,
+			       &sb_validator, &copy, &inc);
 	if (r)
 		return r;
 	BUG_ON(!inc);
@@ -1111,7 +1112,8 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 	/*
 	 * Wipe the spacemap since we're not publishing this.
 	 */
-	memset(&disk_super->data_space_map_root, 0, sizeof(disk_super->data_space_map_root));
+	memset(&disk_super->data_space_map_root, 0,
+	       sizeof(disk_super->data_space_map_root));
 	memset(&disk_super->metadata_space_map_root, 0,
 	       sizeof(disk_super->metadata_space_map_root));
 
@@ -1135,7 +1137,7 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 
 	disk_super = dm_block_data(sblock);
 	disk_super->held_root = cpu_to_le64(held_root);
-	dm_tm_unlock(pmd->tm, sblock);
+	dm_bm_unlock(sblock);
 
 	pmd->need_commit = 1;
 	return 0;
@@ -1169,7 +1171,7 @@ static int __release_metadata_snap(struct dm_pool_metadata *pmd)
 	disk_super->held_root = cpu_to_le64(0);
 	pmd->need_commit = 1;
 
-	dm_tm_unlock(pmd->tm, sblock);
+	dm_bm_unlock(sblock);
 
 	if (!held_root) {
 		DMWARN("pool has no metadata snap");
