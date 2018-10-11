From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 4.19 final
Date: Wed, 10 Oct 2018 23:37:11 -0400
Message-ID: <20181011033711.GA12723@redhat.com>
References: <20181010164643.GA10173@redhat.com>
	<20181010203502.GC6979@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181010203502.GC6979@kroah.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 10 2018 at  4:35P -0400,
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Wed, Oct 10, 2018 at 12:46:44PM -0400, Mike Snitzer wrote:
> > Hi Greg,
> > 
> > The following changes since commit 0238df646e6224016a45505d2c111a24669ebe21:
> > 
> >   Linux 4.19-rc7 (2018-10-07 17:26:02 +0200)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.19/dm-fixes-3
> 
> Now merged, thanks.

Hey Greg,

Sadly the previous DM pull request had a stupid oversight on my part.
Damien was quick to correct it and I've now made it available.  Sorry
for the noise, that's what I get for requesting you pull the same day I
stage a commit, I'll be more careful!

The following changes since commit beb9caac211c1be1bc118bb62d5cf09c4107e6a5:

  dm linear: eliminate linear_end_io call if CONFIG_DM_ZONED disabled (2018-10-10 12:11:09 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.19/dm-fixes-4

for you to fetch changes up to 118aa47c7072bce05fc39bd40a1c0a90caed72ab:

  dm linear: fix linear_end_io conditional definition (2018-10-10 23:22:24 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix for earlier 4.19 final DM linear change that incorrectly
  checked for CONFIG_DM_ZONED rather than CONFIG_BLK_DEV_ZONED.

----------------------------------------------------------------
Damien Le Moal (1):
      dm linear: fix linear_end_io conditional definition

 drivers/md/dm-flakey.c | 2 ++
 drivers/md/dm-linear.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)
