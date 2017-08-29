From: NeilBrown <neilb@suse.com>
Subject: [PATCH 0/2] Remove BIOSET_NEED_RESCUER from some DM
	biosets
Date: Wed, 30 Aug 2017 08:10:18 +1000
Message-ID: <150404441182.12966.7067251378068944343.stgit@noble>
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
To: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

hi,
 I'm working towards the bioset rescuer threads completely.
 Part of that is understanding where they are actually needed,
 and removing them where they are not.

 bioset rescuer threads are only needed on a bioset where
 a make_request_fn will
    allocate from the bioset
    submit that bio with generic_make_request
    allocate again from the bioset, other then non-blocking allocation

 Neither of the biosets in dm-crypt or dm-io are used with this pattern
 so the flag can be removed.

 The bioset allocated in dm.c *is* used with this pattern, so
 some restructuring will be needed there before the flag can be
 removed.

Thanks,
NeilBrown

---

NeilBrown (2):
      dm-crypt: remove BIOSET_NEED_RESCUER flag.
      dm-io: remove BIOSET_NEED_RESCUER flag from bios bioset


 drivers/md/dm-crypt.c |    3 +--
 drivers/md/dm-io.c    |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--
Signature
