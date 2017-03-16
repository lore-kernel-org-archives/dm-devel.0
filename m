From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 0/7] Data integrity protection with dm-integrity
	and dm-crypt
Date: Thu, 16 Mar 2017 15:39:37 +0100
Message-ID: <20170316143944.19843-1-gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

These are additional patches to previously submitted integrity protection commits,
based on for-next branch in Mike's DM tree.

Most of them probably can be folded-in, patches are separated for better readability.

The last patch for large encryption sectors is a new feature but because it depends
on all previous patches it is posted in this series.

Milan Broz (7):
  dm-crypt: Fix documentation of integrity table option.
  dm-crypt: Move IV constructor to separate function.
  dm-crypt: Introduce new format of cipher with capi: prefix.
  dm-crypt: Compute HMAC key size in a separate function.
  dm-crypt: Parse cipher specification according to AEAD flag.
  dm-crypt: Remove obsolete integrity_mode function.
  dm-crypt: optionally support larger encryption sector size

 Documentation/device-mapper/dm-crypt.txt |  65 +++--
 drivers/md/dm-crypt.c                    | 479 +++++++++++++++++++++----------
 2 files changed, 371 insertions(+), 173 deletions(-)

-- 
2.11.0
