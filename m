From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 0/4] dm verity: add support for error correction
Date: Thu,  5 Nov 2015 02:02:30 +0000
Message-ID: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Sami Tolvanen <samitolvanen@google.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

This patch set adds error correction support to dm-verity, which
makes it possible to recover from data corruption in exchange of
increased space overhead.

The feature is implemented as part of dm-verity to take advantage
of the existing hash tree to improve performance and locate known
erasures.

Sami Tolvanen (4):
  dm verity: clean up duplicate hashing code
  dm verity: separate function for parsing opt args
  dm verity: add support for forward error correction
  dm verity: ignore zero blocks

 Documentation/device-mapper/verity.txt |   34 ++
 drivers/md/dm-verity.c                 | 1004 +++++++++++++++++++++++++++-----
 2 files changed, 892 insertions(+), 146 deletions(-)

-- 
2.6.0.rc2.230.g3dd15c0
