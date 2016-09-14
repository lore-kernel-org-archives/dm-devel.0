From: Milan Broz <gmazyland@gmail.com>
Subject: Re: Can we please make 'allow_discards' the default for
	dm-crypt?
Date: Wed, 14 Sep 2016 09:06:46 +0200
Message-ID: <a2882024-b22e-48d2-80d7-dd18ed664792@gmail.com>
References: <CA+55aFwEDs26shapevLziT+BPwvHgqOyikCaGcKsNHQLAw6oSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+55aFwEDs26shapevLziT+BPwvHgqOyikCaGcKsNHQLAw6oSw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On 09/14/2016 04:10 AM, Linus Torvalds wrote:
> I really detest our current dm-crypt policy of not allowing discard by default.
> 
> It has this silly "but but security" reason behind it, but let's face
> it: if you don't want to do discards for security reasons, then JUST
> DON'T DO THEM. Or add a "no_discards" option.

Hi Linus,

then you are saying that the default should be "destroy all the data
on possible hidden disk" :-)

Because that should happen, if you will map "outer" volume with discards on,
and there is a hidden disk (for outer volume it is "unused" space").

And unfortunately it _is_ widely used in TrueCrypt and followers.

I am not advocating to use that feature that is even no longer
as fancy as many people see it, I am just saying that people already have
a lot of such devices that will not disappear after your rant.

It is easy to switch default in cryptsetup, it is impossible fix all
old versions of tools that just call dmsetup in Linux.

Anyway, I see the only way to switch this safely is to increase major version
of dm-crypt target and switch default in new version, this will make all
old tools incompatible. (And update tools together.)

> Because right now, the default behavior is wrong. It's geared toward
> the 0.1% crazy-anal people, and making a *default* option for those
> people is just silly. The whole argument that "you can see access
> patterns and how much free space there is" is just complete bullshit.
> It's not what any sane person would care about.

No, this is not the only argument. Even there, ignore patterns, that was
academic toy. (Years ago I did a dmcrypt pattern experiment to prove that there
is _some_ pattern possible just because many people did not believed it.)

But there are situations that such discard-by-default enables to prove that
your encrypted device has real data on it (without decryption).

You do not care, some people really do.
They can use the --crazy-anal switch, sure.

But it will not make the problem bullshit.


(There are more problems if we think about possible block-level authenticated
encryption - because of discard also wipes integrity tag, later reads should
fail with integrity errors.
Some information (in opposite direction that discard) that says "these sectors
are unused" on reads would be definitely nice. In fact it applies even
for non-auth encryption - why we should decrypt unused space and produce garbage?
Yes, on fs level we have this information but not below it.)

> The rest of us just want to encrypt our data on our laptops in case
> they get stolen, and we don't want to not be able to do the occasional
> "fstrim".
> Yes, good flash doesn't need trimming all that much, but it won't
> hurt. And right now we penalize people who want to do the sane good
> thing.

I think all people in storage will agree with this.

> Sure, we could say that distros should just add the "allow_discard"
> flag instead, and maybe have a checkbox to say "are you a crazy anal
> person" along with the "encrypt disk" checkbox. But EVEN IF the distro
> were to do that, that doesn't mean that the kernel default should be
> the wrong way around.

Sure, but I think many such distros already put allow_discards in crypttab,
and it works. For years.

Milan

p.s.
Anyone with a crazy-anal security people theme poster?
I definitely want one :-)
