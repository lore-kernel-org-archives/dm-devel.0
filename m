From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/6] Handle blocked FC rports
Date: Thu, 14 Mar 2013 15:08:42 +0100
Message-ID: <1363270128-20900-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Occasionally, FC HBAs might lose track of the status of
the attached remote ports. This will cause I/O to be
stuck and the FC HBAs to invoke the error handler,
which will take _LONG_ to complete (we're speaking hours here).

This patch implements a 'suspend path' mechanism in multipath
for handling these situations. Key point is to have a
writeable 'port_state' sysfs attribute for the remote ports.
This is introduced by the patch
'scsi_transport_fc: Make 'port_state' writeable'
posted to linux-scsi.

There are two ways of suspending a path, either by a
path checker returning 'PATH_TIMEOUT', or by the user
invoking the new CLI command 'suspend path'.
This will then set the 'port_state' attribute to 'blocked',
causing the 'fast_io_fail' mechanism to trigger.
This will eventually cause all outstanding I/O to be
aborted and result in a quick failover.

Paths will be resumed either from the FC HBA when a
new RSCN state update is recieved from the SAN, or by
the user by calling the new CLI command 'resume path'.

Signed-off-by: Hannes Reinecke <hare@suse.de>

Hannes Reinecke (6):
  libmultipath: return PATH_DOWN for quiesced paths
  libmultipath: Implement PATH_TIMEOUT
  libmultipath: improve debugging messages in sysfs_attr_set_value()
  libmultipath: Implement sysfs_attr_get_value()
  libmultipath: Implement sysfs_set_fc_rport_state()
  multipathd: Implement 'suspend/resume path'

 libmultipath/checkers.h     |    5 ++++
 libmultipath/checkers/tur.c |    2 +-
 libmultipath/discovery.c    |   65 ++++++++++++++++++++++++++++++++++++++++++-
 libmultipath/discovery.h    |    1 +
 libmultipath/print.c        |    4 +++
 libmultipath/sysfs.c        |   64 ++++++++++++++++++++++++++++++++++++++++--
 libmultipath/sysfs.h        |    2 ++
 multipathd/cli.c            |    2 ++
 multipathd/cli_handlers.c   |   50 +++++++++++++++++++++++++++++++++
 multipathd/cli_handlers.h   |    2 ++
 multipathd/main.c           |    7 +++++
 11 files changed, 200 insertions(+), 4 deletions(-)

-- 
1.7.10.4
