From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 4.10-rc7
Date: Fri, 3 Feb 2017 14:11:08 -0500
Message-ID: <20170203191108.GA3796@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 566cf877a1fcb6d6dc0126b076aad062054c2637:

  Linux 4.10-rc6 (2017-01-29 14:25:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-4.10-fixes

for you to fetch changes up to f5b0cba8f23915e92932f11eb063e37d70556a89:

  dm crypt: replace RCU read-side section with rwsem (2017-02-03 10:26:14 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- A fix for a race in .request_fn request-based DM request handling vs
  DM device destruction

- An RCU fix for dm-crypt's kernel keyring support that was included in
  4.10-rc1

- A -Wbool-operation warning fix for DM multipath

----------------------------------------------------------------
Mike Snitzer (2):
      dm mpath: cleanup -Wbool-operation warning in choose_pgpath()
      dm rq: cope with DM device destruction while in dm_old_request_fn()

Ondrej Kozina (1):
      dm crypt: replace RCU read-side section with rwsem

 drivers/md/dm-crypt.c | 8 ++++----
 drivers/md/dm-mpath.c | 4 ++--
 drivers/md/dm-rq.c    | 4 ++++
 3 files changed, 10 insertions(+), 6 deletions(-)
