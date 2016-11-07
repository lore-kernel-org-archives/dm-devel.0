From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH 0/3] Modified kernel keyring support patch
Date: Mon,  7 Nov 2016 10:38:12 +0100
Message-ID: <1478511495-20306-1-git-send-email-okozina@redhat.com>
References: <1470750966-13028-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470750966-13028-1-git-send-email-aryabinin@virtuozzo.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, aryabinin@virtuozzo.com, mpatocka@redhat.com, snitzer@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

Hi Andrey,

I'm sorry it took me so long to reply. I've revisited your patch and rebased it on top of my
fix for crypt_set_key(). The last patch in this series adresses my concerns about your original
patch. Would you mind resend your patch including those changes provided it doesn't break your
use case?

I haven't concluded the testing yet but so far cryptsetup testsuite passes with the patch set.

Please consider it still RFC only, I have to write corner-case tests for the kernel keyring bits yet.

With regard to my other suggestion related to guaranteed key erasure on table destruction (even when
provided only via optional parameter) it will require to patch kernel keyring
service so let's postpone it after we get those changes in upstream kernel.

Andrey Ryabinin (1):
  dm-crypt: add ability to use keys from the kernel key retention
    service

Ondrej Kozina (2):
  dm-crypt: mark key as invalid until properly loaded
  dm-crypt: modifications to previous patch

 drivers/md/dm-crypt.c | 147 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 132 insertions(+), 15 deletions(-)

-- 
2.7.4
