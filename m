From: Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 01/11] dm-snap: Replace special round_down()
Date: Mon, 13 Aug 2007 11:35:03 +0200
Message-ID: <20070813093503.GE12730@hasse.suse.de>
References: <20070810200204.455820246@suse.de>>
	<20070810200204.896267894@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="3MwIy2ne0vdjdPXF"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070810200204.896267894@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 10, Jan Blunck wrote:

> This patch removes the special round_down() to next power of 2 implementation
> used only at one place in the snapshot target. It is replaced by an equivalent
> 1 << fls() which might use an architecture specific implementation.

Err, ok this is the second fix for this patch. I hope it is the last. It
doesn't make any sense to have hash_size be defined as sector_t. Same goes for
max_buckets.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>

--3MwIy2ne0vdjdPXF
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="dm-snap-remove-round_down.diff"

Subject: dm-snap: Replace special round_down()

This patch removes the special round_down() to next power of 2 implementation
used only at one place in the snapshot target. It is replaced by an equivalent
1 << fls() which might use an architecture specific implementation.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-snap.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -333,21 +333,12 @@ static int calc_max_buckets(void)
 }
 
 /*
- * Rounds a number down to a power of 2.
- */
-static uint32_t round_down(uint32_t n)
-{
-	while (n & (n - 1))
-		n &= (n - 1);
-	return n;
-}
-
-/*
  * Allocate room for a suitable hash table.
  */
 static int init_hash_tables(struct dm_snapshot *s)
 {
-	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
+	unsigned int hash_size, max_buckets;
+	sector_t cow_dev_size, origin_dev_size;
 
 	/*
 	 * Calculate based on the size of the original volume or
@@ -361,7 +352,7 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(hash_size, max_buckets);
 
 	/* Round it down to a power of 2 */
-	hash_size = round_down(hash_size);
+	hash_size = 1 << (fls(hash_size) - 1);
 	if (init_exception_table(&s->complete, hash_size))
 		return -ENOMEM;
 

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--3MwIy2ne0vdjdPXF--
