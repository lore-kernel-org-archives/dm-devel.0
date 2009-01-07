From: Alasdair G Kergon <agk@redhat.com>
Subject: Patchwork and patch flow
Date: Wed, 7 Jan 2009 02:59:52 +0000
Message-ID: <20090107025952.GH3512@agk.fab.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patchwork was recently installed on kernel.org and dm-devel has been
added as I'd like to try it out as a way of keeping track of
patches posted to this list.

  http://patchwork.kernel.org/project/dm-devel/list/

I'd also like to see more people visibly reviewing and testing patches.
Please respond in the mailing list threads with comments and Reviewed-by: or
Tested-by: lines as appropriate.  If you've only reviewed part of the patch
or only tested a subset of the cases you think need testing, explain in the 
thread but don't add those lines.  Only offer a Reviewed-by line if you have
performed a complete line-by-line review of the patch and patch header and
you support its inclusion in the tree.

Also, if you post a patch, try to find suitable people to review and test it
for you and ask them to respond as above in the thread.

If you can't find people to do that, consider whether you ought to change
the patches in some way (usually breaking them into smaller compilable parts)
to make them easier to test and review.

I would like us to work towards a situation where each patch gets documented
as having been reviewed and tested before it hits its respective tree (the
linux-next tree in the case of kernel patches).

The current flow of kernel patches is:
   dm-devel list 
-> dm quilt tree   
    - http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
    - typically edit the series file to place the new patches you want to test 
      immediately below the 'mm' patch.
-> -mm 
-> linux-next 
    - patches should have Reviewed-by and Tested-by lines before this stage
-> linux-dm git (rebased for every set of patches)
    - http://git.kernel.org/?p=linux/kernel/git/agk/linux-2.6-dm.git
-> linux-2.6

Userspace multipath-tools patches go:
   dm-devel list -> Christoph Varoqui who checks them in.

Userspace dmsetup and libdevmapper patches go:
   Either lvm-devel or dm-devel list -> CVS
   (Some simple patches may be reviewed on lvm-devel after they are committed
   rather than before.)

Alasdair
-- 
agk@redhat.com
