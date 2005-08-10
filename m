From: "goggin, edward" <egoggin@emc.com>
Subject: in favor of multipath display of both active and best
	path groups
Date: Wed, 10 Aug 2005 17:33:35 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ABC3@SRMANNING.eng.emc.com>
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

I am in favor of the multipath display distinguishing between
the highest priority path group and the currently active one,
similar to what we had when the multipath display would show
both "best" and "active" path groups respectively.  I do not think
the dual display is necessarily redundant.

These two attributes can differ if path group failback is not enabled
and one of the non-highest priority path groups has been made
the active path group either due to IO failure on all paths of the
highest priority path group or as a result of a path group reassignment
operation done external to the host in question, (that is, by
either a SAN utility or another node in a multi-node cluster).

Having this capability to see that the active path group is different
than the highest priority path group for a significant number of block
devices can provide incentive for customers to enable path group
failback for the block devices in question.
