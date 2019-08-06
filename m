From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/2] dm-crypt: get rid of cipher API for EBOIV
Date: Tue,  6 Aug 2019 11:02:32 +0300
Message-ID: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
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
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, snitzer@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, ebiggers@kernel.org, dm-devel@redhat.com, gmazyland@gmail.com, agk@redhat.com
List-Id: dm-devel.ids

This is a follow-up to the discussion [0] started by regarding adding
new uses of the cipher API to dm-crypt. In particular, the discussion
was about EBOIV, which is used by BitLocker to generate IVs from byte
offsets, to be used for AES encryption in CBC mode.

The way EBOIV support is currently integrated does not restrict it at
all, which means we may paint ourselves into a corner where we are
forced to support unexpected and novel ways users have decided to
wire up EBOIV. This may become a maintenance burden going forward,
and given that EBOIV uses the same key for generating the IV via
AES encryption as the one used for the data, it may produce configurations
that are not entirely safe.

So let's restrict EBOIV to cbc(aes) (patch #1), to prevent it from
being used in arbitrary cipher cocktails, and avoid ending up with
a disproportionate maintenance burden on the crypto API side.

Patch #2 switches the IV generation to the AES library, which avoids
potential key leaks due to the use of aes-generic as the cipher used
for IV generation.

[0] https://www.redhat.com/archives/dm-devel/2019-July/msg00041.html

Ard Biesheuvel (2):
  md/dm-crypt - restrict EBOIV to cbc(aes)
  md/dm-crypt - switch to AES library for EBOIV

 drivers/md/dm-crypt.c | 34 ++++++++------------
 1 file changed, 13 insertions(+), 21 deletions(-)

-- 
2.17.1
