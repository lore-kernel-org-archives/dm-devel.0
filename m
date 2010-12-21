From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 0/7] dm crypt fixes and loop-aes mode support
Date: Tue, 21 Dec 2010 16:28:12 +0100
Message-ID: <cover.1292944625.git.mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Patch 1 and 2 are fixes (maybe fold it in per cpu patch)
others are preparation and changes for multikey support
(compatibility mode for loop-aes mappings).

Note: the patchset is based on top of dm devel queue,
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/series.html
it requires per-cpu dmcrypt change

Milan Broz (7):
  dm crypt: fix per cpu struct dereference in destructor
  dm crypt: remove redundant setkey call
  dm crypt: set key size early
  dm crypt: remove unused compatible table output
  dm crypt: redefine IV generator function and add post IV call
  [RFC]dm crypt: add multi-key capability
  [RFC]dm crypt: add loop-aes LMK IV generator

 Documentation/device-mapper/dm-crypt.txt |    7 +-
 drivers/md/dm-crypt.c                    |  382 ++++++++++++++++++++++++------
 2 files changed, 314 insertions(+), 75 deletions(-)

-- 
1.7.2.3
