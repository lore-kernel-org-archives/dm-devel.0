From: Neil Brown <neilb@suse.de>
Subject: Re: bio too big device dm-XX (256 > 255) on 2.6.17
Date: Fri, 17 Nov 2006 16:54:23 +1100
Message-ID: <17757.20111.137896.276508@cse.unsw.edu.au>
References: <20061109005227.73b4fd14.pegasus@nerv.eu.org>
	<20061114004120.30c821c8.pegasus@nerv.eu.org>
	<17753.17700.818164.511147@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <evms-devel-bounces@lists.sourceforge.net>
In-Reply-To: message from Neil Brown on Tuesday November 14
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: evms-devel-bounces@lists.sourceforge.net
Errors-To: evms-devel-bounces@lists.sourceforge.net
To: Jure =?UTF-8?B?UGXEjWFy?= <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org, evms-devel@lists.sourceforge.net, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tuesday November 14, neilb@suse.de wrote:
> On Tuesday November 14, pegasus@nerv.eu.org wrote:
> > 
> > Hello,
> > 
> > this is getting more and more annoying.
> > 
> > Somewhere in the stack reiserfs-dm-md-hd[bd] lies the problem that's causing "bio too big device dm-10 (256 > 255)" errors, which cause i/o failures.
> > 
> > It works as expected on reiserfs-dm-sda and on ext3-dm-md-hd[bd].
> > 
> > Debian Etch, 2.6.17-2.
> > 
> 
> Please try this patch (I can give more detailed instructions if needed).
> 

Of course, that patch didn't even compile :-(

This one does.

NeilBrown

-------------------
Make sure dm honours max_hw_sectors of underlying devices


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-table.c         |    7 +++++++
 ./include/linux/device-mapper.h |    1 +
 2 files changed, 8 insertions(+)

diff .prev/drivers/md/dm-table.c ./drivers/md/dm-table.c
--- .prev/drivers/md/dm-table.c	2006-11-17 16:48:34.000000000 +1100
+++ ./drivers/md/dm-table.c	2006-11-17 16:45:53.000000000 +1100
@@ -99,6 +99,9 @@ static void combine_restrictions_low(str
 	lhs->max_segment_size =
 		min_not_zero(lhs->max_segment_size, rhs->max_segment_size);
 
+	lhs->max_hw_sectors =
+		min_not_zero(lhs->max_hw_sectors, rhs->max_hw_sectors);
+
 	lhs->seg_boundary_mask =
 		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
 
@@ -561,6 +564,9 @@ void dm_set_device_limits(struct dm_targ
 	rs->max_segment_size =
 		min_not_zero(rs->max_segment_size, q->max_segment_size);
 
+	rs->max_hw_sectors =
+		min_not_zero(rs->max_hw_sectors, q->max_hw_sectors);
+
 	rs->seg_boundary_mask =
 		min_not_zero(rs->seg_boundary_mask,
 			     q->seg_boundary_mask);
@@ -889,6 +895,7 @@ void dm_table_set_restrictions(struct dm
 	q->max_hw_segments = t->limits.max_hw_segments;
 	q->hardsect_size = t->limits.hardsect_size;
 	q->max_segment_size = t->limits.max_segment_size;
+	q->max_hw_sectors = t->limits.max_hw_sectors;
 	q->seg_boundary_mask = t->limits.seg_boundary_mask;
 	if (t->limits.no_cluster)
 		q->queue_flags &= ~(1 << QUEUE_FLAG_CLUSTER);

diff .prev/include/linux/device-mapper.h ./include/linux/device-mapper.h
--- .prev/include/linux/device-mapper.h	2006-11-17 16:48:34.000000000 +1100
+++ ./include/linux/device-mapper.h	2006-11-17 16:48:41.000000000 +1100
@@ -113,6 +113,7 @@ struct io_restrictions {
 	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
+	unsigned int		max_hw_sectors;
 	unsigned long		seg_boundary_mask;
 	unsigned char		no_cluster; /* inverted so that 0 is default */
 };

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
