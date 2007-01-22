From: Mike Anderson <andmike@us.ibm.com>
Subject: [patch 0/3] dm-netlink: Add netlink events to dm
Date: Mon, 22 Jan 2007 10:17:18 -0800
Message-ID: <38410.4549455971$1169489824@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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

This patch series adds a new event interface to device mapper. The new
interface uses the netlink transport and attribute based messages.

Previous posts can be found in the list archive
http://dir.gmane.org/gmane.linux.kernel.device-mapper.devel

The patches have been broken down into smaller chunks compared to the
previous series to allow for easier review and also updated to newer
kernel interfaces.

This patch series contains the following:
- Add dm-netlink skeleton.
- Add support for the event functions.
- Add event calls for failed and reinstated paths.

-andmike
--
Michael Anderson
andmike@us.ibm.com
