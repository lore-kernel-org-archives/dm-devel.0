From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Can we please make 'allow_discards' the default for
	dm-crypt?
Date: Wed, 14 Sep 2016 12:16:59 -0400
Message-ID: <20160914161659.GA30078@redhat.com>
References: <CA+55aFwEDs26shapevLziT+BPwvHgqOyikCaGcKsNHQLAw6oSw@mail.gmail.com>
	<a2882024-b22e-48d2-80d7-dd18ed664792@gmail.com>
	<CA+55aFz8C16ijz9YHwtwe3M80YaF0CH_ra7BSniunfc3tXi11A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+55aFz8C16ijz9YHwtwe3M80YaF0CH_ra7BSniunfc3tXi11A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ondrej Kozina <okozina@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On Wed, Sep 14 2016 at 11:41am -0400,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Sep 14, 2016 at 12:06 AM, Milan Broz <gmazyland@gmail.com> wrote:
> >
> > then you are saying that the default should be "destroy all the data
> > on possible hidden disk" :-)
> 
> No.
> 
> > Because that should happen, if you will map "outer" volume with discards on,
> > and there is a hidden disk (for outer volume it is "unused" space").
> 
> But that's independent of the crypto setup, isn't it?
> 
> If the inner filesystem is some hidden crypto volume, then the outer
> filesystem could be anything. And if you write to the outer filesystem
> in some of the random hidden setups, you'll destroy the hidden volume
> anyway. No? So you'd never write to it in the first place, much less
> do "fstrim" on it.
> 
> I thought the people who used hidden ("deniable") things didn't
> actually ever *use* the outer filesystem at all, exactly so that they
> can just put the real encrypted thing in there and nor worry about it.
> 
> Am I missing something? What's the actual real setup?Can you explain -
> in particular, can we perhaps notice it somehow, so that the normal
> case at least can enable discard.
> 
> Because the reason I want to do this, of course, is that I think it
> was now my fifth or sixth setup where I had to manually enable this
> thing, and I have never *ever* actually wanted to disable it. And I
> bet that is true for 99.99% of all users (ie the normal case).

I spoke with Ondrej (cc'd), who works closely with Milan on cryptsetup
(they are designing v2 of that interface), and the hidden volumes thing
boils down to "TrueCrypt" devices.  Which has its own userspace to setup
the device.  But cryptsetup can activate (or even create) TrueCrypt
devices too.

So the current thinking is: this is a userspace defaults problem.  The
kernel dm-crypt discard default should stay disabled as is (otherwise
TrueCrypt devices can get corrupted on discard -- will defer to Milan
and/or others to further explain how if needed).

But that the cryptsetup userspace default for luks devices (your 99.9%)
can be changed to default to enabling discards.  cryptsetup's default
for TrueCrypt devices would still be to disable discards.

Ondrej said he'd need a day to work through it further with Milan.

Mike
