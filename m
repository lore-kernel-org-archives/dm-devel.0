From: Mailing Lists <mailinglists35@gmail.com>
Subject: ablkcipher plugins for pcrypt
Date: Sun, 18 Nov 2018 00:42:15 +0200
Message-ID: <CABjXrGFXTDNLxbCF8GBq1wv+eFwbvU7aO_OjGBQ82F0Tg9n4uQ@mail.gmail.com>
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
Cc: steffen.klassert@secunet.com
List-Id: dm-devel.ids

Dear Steffen,

I stumbled upon this old thread[1] about the possibility of getting
pcrypt work for dm-crypt.

About around the same time dm-crypt got parallel support[2] but as far
as I understand the patch only enabled parallelism if there are
multiple simultaneous requests, but still goes single threaded on a
single I/O submitter (rsync for example):

"This patch changes the crypto workqueue to be per CPU. This means
that as long as the IO submitter (or the interrupt target CPUs
for reads) runs on different CPUs the encryption work will be also
parallel."

Currently pcrypt still only deals with AEAD[3]; is there any chance
you could revisit the old work you were mentioning in the
discussion[1]?

Many thanks!

[1] https://www.redhat.com/archives/dm-devel/2010-June/msg00036.html
[2] https://lwn.net/Articles/390075/
[3] https://github.com/torvalds/linux/blob/master/crypto/pcrypt.c#L346
