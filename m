From: Mike Christie <mchristi@redhat.com>
Subject: PATCH 0/4] multipath-tools: Ceph rbd support v2
Date: Mon,  8 Aug 2016 07:01:46 -0500
Message-ID: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
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

The following patches made over Christophe's tree today,
add Ceph rbd support for handling blacklisted devices.


This is not general support for rbd and multipath. There is
no boot/root support and it does not support features like
multibus. My use is for HA configurations, specifically for exporting
rbd images through multiple LIO instances. In this case, we have one
rbd instance that has the ceph rbd exclusive lock and it can send
WRITE requests. If that host becomes unreachable, then another host
will grab the lock, and blacklist the original host to prevent it from
sending stale IO (when blacklisted IO will be failed by the OSD).

To recover from that type of scenario, this patchset adds a repair()
callout to the checker. If the path is in the PATH_DOWN state this
callout can be used to fix it up. For my case, I am remapping
the device to flush stale IO and cleanup the old lock,
and then unblacklisting the path, so it can be used again.

Changes since v1:
- Drop ID_UID use and implemented sysfs getuid support.
- Drop settings that were defaults and follow template.
- Fix ceph auth/user.
