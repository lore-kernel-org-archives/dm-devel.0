From: Alasdair G Kergon <agk@redhat.com>
Subject: 2.6.11-rc3-udm2
Date: Wed, 9 Feb 2005 15:03:23 +0000
Message-ID: <20050209150323.GW10195@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/2.6.11-rc3/2.6.11-rc3-udm2.tar.bz2
 
Same as udm1 with a bit of tidying up.

Simplified the locking for now: it uses the per-device multipath lock everywhere.
We can refine this later to address the performance issues.
Updated version numbers and added a few more comments.

Please re-test and review this patchset - I'd like to submit patches 7-10 to -mm
after adding more documentation.

Alasdair

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
