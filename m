From: Alasdair G Kergon <agk@redhat.com>
Subject: [0/4] Internal device-mapper public interface
Date: Wed, 26 Mar 2008 14:11:58 +0000
Message-ID: <20080326141158.GB12007@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

We've finally spent some time trying to clean up the device-mapper interface
and expose more of it for the use of other modules in include/linux.

The patches are here and pushed for -mm:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/series.html

and the following messages contain the updated .h files.

Have we missed anything?

Alasdair
-- 
agk@redhat.com
