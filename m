From: Ondrej Kozina <okozina@redhat.com>
Subject: [BUG] dm crypt: kernel keyring key processing bug
Date: Fri, 12 Jan 2018 16:30:31 +0100
Message-ID: <1515771032-26247-1-git-send-email-okozina@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, mpatocka@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

Hi,

there's unfortunate and quite nasty bug in IV initialization
when key is being passed via kernel keyring service.

We erase internal key copy too soon and we pass wrong key
to IV initialization routines. Affected IVs I reproduced [1] the
bug with are: 'essiv' and 'tcw'. I don't have a test yet for 'lmk',
but it's probably also affected.

Users probably won't notice the bug if they don't mix loading
keys via keyring service and via classical hexbyte representation.

But doing so and using any affected IV will lead to data corruption.

The good news is keyring service is not used with LUKS1 devices
and with plain encryption in cryptsetup (even with cryptsetup 2.0.0).
This may change when users start adopting LUKS2 format and convert
LUKS1 device with i.e.: cbc-essiv:sha256 mode to LUKS2. LUKS2 uses
keyring service by default.

Mike, If you accept the patch please resend also to stable kernels.

[1] https://gitlab.com/cryptsetup/cryptsetup/blob/wip-luks2/tests/keyring-compat-test

Ondrej Kozina (1):
  dm crypt: wipe kernel key copy after IV initialization

 drivers/md/dm-crypt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
1.8.3.1
