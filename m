From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/10] various multipath-tools patches
Date: Tue, 23 Oct 2018 15:43:44 +0200
Message-ID: <20181023134348.17915-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This is v2 of my series from Oct. 10; starting from 7 as the
other patches have already been merged.

Changes wrt v2:
  7/10: handle failure of libcheck_init() (Ben). I decided not to
 	return PATH_TIMEOUT in this case, rationale in my reply to
	Ben's review.
  9/10: new, add the suggestions from Ben's review of 8/8 of v1.
 10/10: new, see Ben's comment on patch 5/8 of v1.

Martin Wilck (4):
  libmultipath: handle TUR threads that can't be cancelled
  multipathd: handle repeated udev retrigger failure
  multipathd: improve "add missing path" handling
  multipath.8: fix description of "device" argument

 libmultipath/checkers/tur.c | 24 ++++++++++++++--
 multipath/multipath.8       | 32 +++++++++++----------
 multipathd/main.c           | 55 +++++++++++++++++++++++++------------
 3 files changed, 76 insertions(+), 35 deletions(-)

-- 
2.19.1
