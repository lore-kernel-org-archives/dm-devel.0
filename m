From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 0/3 v2] dm crypt: add Loop-AES compatibility mode
	support
Date: Thu,  6 Jan 2011 21:03:59 +0100
Message-ID: <cover.1294344057.git.mbroz@redhat.com>
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

These patches add compatibility mode support for Loop-AES encryption
system, see http://loop-aes.sourceforge.net/

Note: the patchset is based on top of dm devel queue,
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/series.html

Milan Broz (3):
  dm crypt: add post IV call to IV generator
  dm crypt: add multi-key capability
  dm crypt: add Loop-AES IV generator

 Documentation/device-mapper/dm-crypt.txt |    7 +-
 drivers/md/dm-crypt.c                    |  313 ++++++++++++++++++++++++++----
 2 files changed, 285 insertions(+), 35 deletions(-)

-- 
1.7.2.3
