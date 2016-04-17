From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] another device mapper fix for 4.6-rc4 (or
 4.6-rc5 if too late)
Date: Sun, 17 Apr 2016 11:38:49 -0400
Message-ID: <20160417153849.GA27814@redhat.com>
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
Cc: dm-devel@redhat.com, Ahmed Samy <f.fallen45@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 9567366fefddeaea4ed1d713270535d93a3b3c76:

  dm cache metadata: fix READ_LOCK macros and cleanup WRITE_LOCK macros (2016-04-14 17:34:49 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.6-fix-2

for you to fetch changes up to 6545b60baaf880b0cd29a5e89dbe745a06027e89:

  dm cache metadata: fix cmd_read_lock() acquiring write lock (2016-04-17 11:24:46 -0400)

Sorry for this oversight, please pull, thanks.
Mike

----------------------------------------------------------------
- Fix for earlier 4.6-rc4 stable@ commit that introduced improper use of
  write lock in cmd_read_lock() -- due to cut-n-paste gone awry (and
  sparse didn't catch it).

----------------------------------------------------------------
Ahmed Samy (1):
      dm cache metadata: fix cmd_read_lock() acquiring write lock

 drivers/md/dm-cache-metadata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
