From: Renesanso <renesanso@yandex.ru>
Subject: dmitry.kasatkin@huawei.com
Date: Mon, 3 Jul 2017 07:44:07 +0300
Message-ID: <bbf2a91d-2eac-5b10-903d-50939acfb57a@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: ru-RU
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com, gmazyland@gmail.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi for all.

Dmitry Kasatkin's fork of linux.git write dm-integrity patch for linux 
kernel and write example to create dm device 
https://kernel.googlesource.com/pub/scm/linux/kernel/git/kasatkin/linux-digsig/+/2dfa67a1a4c049fd33fcc6abcb1c8ca57b17a268/Documentation/device-mapper/dm-integrity.txt 
, but
it mainline kernel is other dm-integrity, that must work in ecc mode or 
as AEAD-backend for dm-crypt. 
https://github.com/torvalds/linux/blob/master/Documentation/device-mapper/dm-integrity.txt 
https://www.redhat.com/archives/dm-devel/2017-January/msg00028.html

I try to use dmsetup to setup  dm-integrity in ecc mode (but if change 
block on backend device dm-integrity gives not reaction and give another 
md5sum to upper level. but non error), for dm-crypt I cannot understand 
how to use AEAD mode.

Please, give full instrustion to use dm-integrity in ecc mode and with 
dm-crypt  (with kernel keychain creation)..

Thanks, Renesanso.
