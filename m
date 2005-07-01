From: "goggin, edward" <egoggin@emc.com>
Subject: unintentional path group failback
Date: Thu, 30 Jun 2005 21:38:11 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB37@SRMANNING.eng.emc.com>
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

I submitted the entry below to dm-devel on June 20th.

	 (1) Looks like it might be possible for a currently disabled path
group
	which is not the highest priority path group to remain disabled even
	when paths in the group test successfully.  This seems to be
possible
	because the code in switch_pathgroup() called by checkerloop() in
	multipathd only fails back to the highest priority path group.
Granted
	that the problem is primarily (__only__) cosmetic since the other
group(s)
	are not being actively used anyway, but it is still misleading to a
viewer of
	"multipath -l" to see disabled path groups which should not be in
this state.
	are not being actively used anyway, but it is still misleading to a
viewer of
	"multipath -l" to see disabled path groups which should not be in
this state.

I want to update the post for this entry since it turns out that this
problem is not
just cosmetic in nature.  I apologize in advance if this problem is already
fixed
in the multipath-tools git head for I haven't yet been able to install
cogito on my host :((

If the path group which is not the highest priority path group is left in a
disabled state
for a host, despite the fact that the paths in the path group are active
from that host, a
path group reassignment operation initiated from a different host (think of
a SAN
management GUI or a peer host in a cluster) will cause the original host to
immediately
switch the active path group back to the highest priority path group (assume
a steady
stream of data to the logical unit) -- despite the fact that path group
failback is disabled
for the original host.

This is because io to the highest priority path group after the external
path reassignment
will cause even the highest priority path group to be put into a bypassed
state.  When the
failed io is retried, it will continually be retried on only the highest
priority path group as
long as all path groups are in a bypassed state.  When a pg_init succeeds to
the highest
priority path group, the unintended failback is complete.
