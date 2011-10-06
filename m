From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 3.1
Date: Thu, 6 Oct 2011 15:17:13 +0100
Message-ID: <20111006141713.GB2840@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, stable@kernel.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:

  http://people.redhat.com/agk/git/linux-dm for-linus

to get the following device-mapper fixes for inclusion in 3.1:

Jonthan Brassow (1):
      dm: raid fix write_mostly arg validation

Mike Snitzer (2):
      dm: flakey fix corrupt_bio_byte error path
      dm table: avoid crash if integrity profile changes

Milan Broz (1):
      dm crypt: always disable discard_zeroes_data

 drivers/md/dm-crypt.c         |    2 ++
 drivers/md/dm-flakey.c        |    4 +++-
 drivers/md/dm-raid.c          |    2 +-
 drivers/md/dm-table.c         |   32 ++++++++++++++++++++++++++------
 include/linux/device-mapper.h |    5 +++++
 5 files changed, 37 insertions(+), 8 deletions(-)

Thanks,
Alasdair
