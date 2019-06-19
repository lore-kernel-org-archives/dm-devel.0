From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/4] crypto: switch to crypto API for
	ESSIV generation
Date: Wed, 19 Jun 2019 15:13:15 +0200
Message-ID: <CAKv+Gu8bkTbEL+BAk4OoNpaPyJFvnOQS7pgdQj7By+F2MbdO7w@mail.gmail.com>
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org>
	<099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com>
	<CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
	<CAKv+Gu9q5qTgEeTLCW6ZM6Wu6RK559SjFhsgWis72_6-p6RrZA@mail.gmail.com>
	<f5de99dd-0b6a-9f7e-46b7-cd3c5ed3100e@gmail.com>
	<CAKv+Gu9NW2H-TDd66quKSUMpEWGwqEjN-vmf_zueo1tEJLa-xg@mail.gmail.com>
	<b5b013eb-9cab-4985-9c24-563cc57c140e@gmail.com>
	<CAKv+Gu91RHpwE6XzdFYcsN77DRJ-4OsFRjxNAyKk92Q3q6dCYw@mail.gmail.com>
	<CAKv+Gu_XFbB9TTjMO+=QmZ40H1LV5DB57-zeUEb9dN3yNyia=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKv+Gu_XFbB9TTjMO+=QmZ40H1LV5DB57-zeUEb9dN3yNyia=w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, 19 Jun 2019 at 14:49, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 19 Jun 2019 at 14:36, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > On Wed, 19 Jun 2019 at 13:33, Milan Broz <gmazyland@gmail.com> wrote:
> > >
> > > On 19/06/2019 13:16, Ard Biesheuvel wrote:
> > > >> Try
> > > >>   cryptsetup open --type plain -c null /dev/sdd test -q
> > > >> or
> > > >>   dmsetup create test --table " 0 417792 crypt cipher_null-ecb - 0 /dev/sdd 0"
> > > >>
> > > >> (or just run full cryptsetup testsuite)
> > > >>
> > > >
> > > > Is that your mode-test script?
> > > >
> > > > I saw some errors about the null cipher, but tbh, it looked completely
> > > > unrelated to me, so i skipped those for the moment. But now, it looks
> > > > like it is related after all.
> > >
> > > This was triggered by align-test, mode-test fails the same though.
> > >
> > > It is definitely related, I think you just changed the mode parsing in dm-crypt.
> > > (cipher null contains only one dash I guess).
> > >
> >
> > On my unpatched 4.19 kernel, mode-test gives me
> >
> > $ sudo ./mode-test
> > aes                            PLAIN:[table OK][status OK]
> > LUKS1:[table OK][status OK] CHECKSUM:[OK]
> > aes-plain                      PLAIN:[table OK][status OK]
> > LUKS1:[table OK][status OK] CHECKSUM:[OK]
> > null                           PLAIN:[table OK][status OK]
> > LUKS1:[table OK][status OK] CHECKSUM:[OK]
> > cipher_null                    PLAIN:[table FAIL]
> >  Expecting cipher_null-ecb got cipher_null-cbc-plain.
> > FAILED at line 64 ./mode-test
> >
> > which is why I commented out those tests in the first place.
> >
> > I can reproduce the crash after I re-enable them again, so I will need
> > to look into that. But something seems to be broken already.
> > Note that this is running on arm64 using a kconfig based on the Debian kernel.
>
> Actually, could this be an issue with cryptsetup being out of date? On
> another arm64 system with a more recent distro, it works fine

This should fix the crash you are seeing

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 89efd7d249fd..12d28880ec34 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2357,7 +2357,7 @@ static int crypt_ctr_cipher_old(struct dm_target
*ti, char *cipher_in, char *key
        if (!cipher_api)
                goto bad_mem;

-       if (!strcmp(*ivmode, "essiv")) {
+       if (*ivmode && !strcmp(*ivmode, "essiv")) {
                if (!*ivopts) {
                        ti->error = "Digest algorithm missing for ESSIV mode";
                        return -EINVAL;

Apologies for the sloppiness - this is a check that I had added and
then removed again, given that *ivmode was assigned unconditionally,
but i didn't realize tmp could be NULL.

With these two changes applied, mode-test successfully runs to completion.

Can you recommend another test suite I could run?
