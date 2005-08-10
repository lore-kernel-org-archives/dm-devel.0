From: "goggin, edward" <egoggin@emc.com>
Subject: display of path group active/best state
Date: Wed, 10 Aug 2005 17:58:03 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ABC4@SRMANNING.eng.emc.com>
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

I think the cached value in the kernel and the actual value
for active and highest priority path group can differ.  While
the multipath display output is showing the kernel value for
the active path group, it also showed the kernel value for the
best path group when this attribute was displayed.

Unfortunately, the kernel value for each of these attributes
does not always correctly reflect the actual highest priority
and active path groups.  This most likely happens for the
active path group attribute whenever the active path group
is changed via an externally initiated path group
reassignment operation.

This state divergence can happen on clusters where one node
has initiated changing the active path group while the other
node(s) remain in the dark without servicing IO through the
block device in question.  While this problem is most likely
associated only with the active/passive or asymmetric storage
systems, unless it is fixed, it will be possible that the multipath
display will show different active path groups for the same block
device when issued from different nodes in a cluster.  This is
not a good thing.

While this state divergence is quickly rectified upon attempt
to service the first IO to the particular block device on the host
in question, the time in which the state may remain diverged is
non-determinant.

Fixing this issue requires at least that the active path group
be detectable by multipath or by both multipath and multipathd
via a new callout mechanism or by an API modification to the
existing path checker callout.  Either multipath could always
display the active path group based on the results of the new
callout instead of the cached value of this attribute from the
kernel or multipathd could be changed to update the kernel's
status of which path group is active when the kernel and user
space components disagree.  The 2nd option may also
require synchronizing the kernel code which changes the
active path group with the code which returns an indication
of which path group is active.
