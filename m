From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 0/4] multipath-tools: Ceph rbd support
Date: Tue,  5 Jul 2016 03:12:29 -0500
Message-ID: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

The following patches add Ceph rbd support for handling
blacklisted devices. This does not support features like
multibus.

My specific use is for exporting rbd images through multiple
LIO instances. In this case, we have one rbd instance that
has the exclusive lock and send WRITE requests. If that host
becomes unreachable, then another host will grab the lock,
and blacklist the original host to prevent it from sending stale
IO (when blacklisted IO will be failed by the OSD).

To recover from this, this patchset adds a repair() callout
to the checker. If the path is in the PATH_DOWN state this
callout can be used to fix it up. For my case, I am remapping
the device to flush stale IO and cleanup the old lock,
and then unblacklisting myself.
