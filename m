From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 0/4] dm-netlink: Add netlink events to dm
Date: Tue, 9 Jan 2007 01:30:06 -0800
Message-ID: <20070109093006.GA11649@us.ibm.com>
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

This patch series adds netlink event support to dm

A early patch series was posted in this thread.
http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/1409

The patches have been broken down into smaller chunks compared to the
previous series to allow for easier review and also updated to newer
kernel interfaces.

This patch series contains the following:
1. Add dm-netlink skeleton (dm-netlink.patch)
2. Add support for the event functions (dm-netlink-add-netlink.patch)
3. Add event calls for failed and reinstated paths (dm-netlink-mpath.patch)
4. Add mempool support to dm-netlink (dm-netlink-mempool.patch)

-andmike
--
Michael Anderson
andmike@us.ibm.com
