From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-integrity
Date: Mon, 3 Jul 2017 17:05:35 +0200
Message-ID: <4d2e0176-071a-1cb4-3eaa-3c3552a2ce09@gmail.com>
References: <bbf2a91d-2eac-5b10-903d-50939acfb57a@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bbf2a91d-2eac-5b10-903d-50939acfb57a@yandex.ru>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Renesanso <renesanso@yandex.ru>, dm-devel@redhat.com
Cc: mpatocka@redhat.com
List-Id: dm-devel.ids

On 07/03/2017 06:44 AM, Renesanso wrote:
> Hi for all.
> 
> Dmitry Kasatkin's fork of linux.git write dm-integrity patch for linux 
...

yes, unfortunately we named the target the same (and I realized it too late).

It is doing something similar but definitely it is not the same.

> I try to use dmsetup to setup  dm-integrity in ecc mode (but if change 
> block on backend device dm-integrity gives not reaction and give another 
> md5sum to upper level. but non error), for dm-crypt I cannot understand 
> how to use AEAD mode.

You probably configured it in mode when it only provide tag space,
but does not calculate and verify internal hash.

(ECC means error correction, this target do not provide error correction,
only detection of error (such a tool could be written on top of dm-integrity though).

> Please, give full instrustion to use dm-integrity in ecc mode and with 
> dm-crypt  (with kernel keychain creation)..

dm-integrity can work in standalone mode or together with dm-crypt.

For the standalone mode, it is the best to use integritysetup tool
(for now in master branch of cryptsetup project).
https://gitlab.com/cryptsetup/cryptsetup

There is some simple documentation in man page and on this page
https://gitlab.com/cryptsetup/cryptsetup/wikis/DMIntegrity

(You can setup HMAC integrity protection in standalone mode as well.)
I will update it soon with some more info and prepare some better examples
(the whole userspace is still not finished though but should work.)

For the combination with dm-crypt and AEAD - this is part of LUKS2 branch
in the same repository but it is really only for experiments.
Once we will have some testing build, I'll write more here, sorry, it takes
longer than I expected.

Milan
