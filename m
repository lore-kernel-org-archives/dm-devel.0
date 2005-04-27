From: "goggin, edward" <egoggin@emc.com>
Subject: what is the current utility in testing active paths from
	multipat hd?
Date: Wed, 27 Apr 2005 12:27:32 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A94B@SRMANNING.eng.emc.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Although I know it sounds a bit radical and counter intuitive,
but I'm not sure of the utility gained in the current multipathing
implementation by multipathd periodically testing paths which
are known to be in an active state in the multipath target driver.
Possibly someone can convince me otherwise.

If not, it may be possible to significantly reduce the cpu&io
resource utilization consumed by multipathd path testing on
enterprise scale configurations by only testing those paths
which the kernel thinks are in a failed state -- obviously a
much smaller set of paths.  Paths known to be in a failed
state in the multipath target driver must be tested since it is
currently the sole responsibility of multipathd initiated
invocations of multipath to make these paths usable in the
kernel again by changing their state to active in the multipath
target driver.

The path testing is done in checkerloop in multipathd/main.c.
This function is really only interested in cases where the
multipathd view on a path's state has changed, that is, from
active to failed or failed to active.  The other two cases are
uninteresting.

Furthermore, while the checkloop function reacts immediately
to a multipathd state transition of failed to active, the code
appears little interested (other than updating the multipathd
path state to failed) in the case where the multipathd path
state changes from active to failed.

Certainly, the risk is in having multipathd path state not being
updated periodically to reflect path test failures on paths which
incur little to no io traffic.  Paths that see any io after a path failure
will have the multipathd path state updated to reflect the
kernel's path state via mark_failed_path invoked from a device
mapper io event callback.

Yet, unlike the multipath configurator, the multipathd code
currently appears to have little utility for keeping its own path
state separate from the kernel's.  This makes me believe that
there is little to no utility currently gained by having multipathd
test paths which the kernel thinks are active.  Certainly, if the
multipathd/multipath code changes to update kernel path state
from active to failed as a result of failed path tests done by
multipathd, this will no longer be true.  This seems unlikely
apparently due to the difficulty in implementing consistently
accurate path testing in user space.
