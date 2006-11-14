From: Neil Brown <neilb@suse.de>
Subject: Re: bio too big device dm-XX (256 > 255) on 2.6.17
Date: Tue, 14 Nov 2006 15:25:08 +1100
Message-ID: <17753.17700.818164.511147@cse.unsw.edu.au>
References: <20061109005227.73b4fd14.pegasus@nerv.eu.org>
	<20061114004120.30c821c8.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jure  =?ISO-8859-1?Q?=20Pe=1B$,1?=  =?ISO-8859-1?Q?=20-=1B(Bar?= on Tuesday November 14
Sender: linux-raid-owner@vger.kernel.org
To: Jure =?UTF-8?B?UGXEjWFy?= <pegasus@nerv.eu.org>
Cc: linux-raid@vger.kernel.org, evms-devel@lists.sourceforge.net, dm-devel@redhat.com, reiserfs-list@namesys.com
List-Id: dm-devel.ids

On Tuesday November 14, pegasus@nerv.eu.org wrote:
> 
> Hello,
> 
> this is getting more and more annoying.
> 
> Somewhere in the stack reiserfs-dm-md-hd[bd] lies the problem that's causing "bio too big device dm-10 (256 > 255)" errors, which cause i/o failures.
> 
> It works as expected on reiserfs-dm-sda and on ext3-dm-md-hd[bd].
> 
> Debian Etch, 2.6.17-2.
> 

Please try this patch (I can give more detailed instructions if needed).

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-table.c |    3 +++
 1 file changed, 3 insertions(+)

diff .prev/drivers/md/dm-table.c ./drivers/md/dm-table.c
--- .prev/drivers/md/dm-table.c	2006-11-14 15:23:08.000000000 +1100
+++ ./drivers/md/dm-table.c	2006-11-14 15:23:57.000000000 +1100
@@ -99,6 +99,9 @@ static void combine_restrictions_low(str
 	lhs->max_segment_size =
 		min_not_zero(lhs->max_segment_size, rhs->max_segment_size);
 
+	lhs->max_hw_sectors = 
+		min_not_zero(lhs->max_hw_sectors, rhs->max_hw_sectors);
+
 	lhs->seg_boundary_mask =
 		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
 
