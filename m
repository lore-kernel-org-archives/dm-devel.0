From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Can we please make 'allow_discards' the default for
	dm-crypt?
Date: Tue, 13 Sep 2016 19:10:42 -0700
Message-ID: <CA+55aFwEDs26shapevLziT+BPwvHgqOyikCaGcKsNHQLAw6oSw@mail.gmail.com>
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
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

I really detest our current dm-crypt policy of not allowing discard by default.

It has this silly "but but security" reason behind it, but let's face
it: if you don't want to do discards for security reasons, then JUST
DON'T DO THEM. Or add a "no_discards" option.

Because right now, the default behavior is wrong. It's geared toward
the 0.1% crazy-anal people, and making a *default* option for those
people is just silly. The whole argument that "you can see access
patterns and how much free space there is" is just complete bullshit.
It's not what any sane person would care about.

The rest of us just want to encrypt our data on our laptops in case
they get stolen, and we don't want to not be able to do the occasional
"fstrim".

Yes, good flash doesn't need trimming all that much, but it won't
hurt. And right now we penalize people who want to do the sane good
thing.

Sure, we could say that distros should just add the "allow_discard"
flag instead, and maybe have a checkbox to say "are you a crazy anal
person" along with the "encrypt disk" checkbox. But EVEN IF the distro
were to do that, that doesn't mean that the kernel default should be
the wrong way around.

Comments?

               Linus
