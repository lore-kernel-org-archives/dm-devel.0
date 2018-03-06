From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/4] fixes for path wwid detection and path
	change uevents
Date: Tue,  6 Mar 2018 23:15:46 +0100
Message-ID: <20180306221550.10030-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Christophe,

this small series fixes some minor glitches I found in the current path
discovery code, and attempts to implement the safe part of the functionality
discussed in the thread "multipathd: update path's udev in uev_update_path"
in January (based on an idea from Wu Chongyun).

Martin Wilck (4):
  libmultipath: get_uid: check VPD pages for SCSI only
  libmultipath: get_uid: don't quit prematurely without udev
  libmultipath: uev_update_path: always warn if WWID changed
  libmultipath: uev_update_path: update path properties

 libmultipath/discovery.c | 58 ++++++++++++++++++++++++++++--------------------
 multipathd/main.c        | 29 +++++++++++++++++-------
 2 files changed, 55 insertions(+), 32 deletions(-)

-- 
2.16.1
