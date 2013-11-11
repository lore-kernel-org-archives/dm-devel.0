From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.13 0/6] dm cache: simple cache block
	invalidation interface
Date: Mon, 11 Nov 2013 12:20:42 -0500
Message-ID: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

This patches reflect dm-cache changes that have been staged in
linux-next for the v3.13 merge.  I'm posting these to give a heads up
that we've chosen to resort to "plan-b" on the approach taken for
supporting cache block invalidation (while simpler in approach,
eliminates use of the shim/stack policy interface and the era shim
stacked ontop of the mq policy, it will require near-term follow-on
work to have a separate "era" target that sits between the SSD and
cache target -- this work will land in v3.14).

Joe will elaborate on the overall direction and approach associated
with "plan-b" shortly.  For now, the first step is a more minimalist
implementation for cache block invalidation for v3.13.

All patches for v3.13 can be found in the 'for-next' branch of the
linux-dm.git repo, see:
http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

Joe Thornber (6):
  dm cache: cache shrinking support
  dm cache: add passthrough mode
  dm cache metadata: check the metadata version when reading the superblock
  dm cache policy mq: reduce memory requirements
  dm cache: add remove_cblock method to policy interface
  dm cache: add cache block invalidation support

 Documentation/device-mapper/cache.txt |   31 ++-
 drivers/md/dm-cache-metadata.c        |   95 ++++++-
 drivers/md/dm-cache-metadata.h        |    5 +
 drivers/md/dm-cache-policy-internal.h |    5 +
 drivers/md/dm-cache-policy-mq.c       |  572 +++++++++++++++------------------
 drivers/md/dm-cache-policy.h          |   21 +-
 drivers/md/dm-cache-target.c          |  497 ++++++++++++++++++++++++++---
 7 files changed, 859 insertions(+), 367 deletions(-)

-- 
1.7.4.4
