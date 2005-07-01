From: "goggin, edward" <egoggin@emc.com>
Subject: multipath state discrepancies between user and kernel
	space
Date: Fri, 1 Jul 2005 17:30:33 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB3B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Two of them.

(1) In the event that automatic path group failback is not configured, which
value for the highest
priority path group should be displayed by "multipath -l" -- the one used by
the multipath target
driver in the kernel or the path group which is actually the highest
priority path group at that
moment in time?  Or both -- or still do (see issue (2) below) for path
state?

The notion of highest priority path group in the kernel may be different
from the actual highest
priority path group in a case whereby:

(a)	auto failback is not enabled
(b) 	all paths to the highest priority path group are failed
(c) 	multipath is run manually -- causing path group switching to another
path group
(d) 	one or more of the paths that were had failed are now made active
again -- yet
	because auto failback is not enabled, this path group is not made
the highest
	priority path group in the kernel, although by definition it is the
highest priority
	path group


(2) Two path state values, one for user space and one for the kernel
resident multipath target driver,
will be shown whenever the cached device configuration information is hot.
Otherwise, "multipath -l"
shows only the kernel driver's path state value since the user space path
state value is not displayed
if its value is PATH_UNCHECKED which it will be (for "multipath -l") if the
saved device configuration
cache is not used.

Seems like either one value should always be displayed or two values should
always be displayed --
I would certainly prefer that only one value be displayed at all times.
Seems like a simple change.
