From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/2] multipath-tools: avoid error messages with
	NVMe
Date: Mon,  1 Oct 2018 20:45:05 +0200
Message-ID: <20181001184507.4162-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

These two patches avoid useless error messages for NVMe devices.

Martin Wilck (2):
  libmultipath: allow sysfs_pathinfo to return SKIPPED
  multipathd: try SCSI persistent reservations for SCSI only

 libmultipath/discovery.c | 86 +++++++++++++++++++++-------------------
 multipathd/main.c        |  3 ++
 2 files changed, 48 insertions(+), 41 deletions(-)

-- 
2.19.0
