From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Can we please make 'allow_discards' the default for
	dm-crypt?
Date: Wed, 14 Sep 2016 08:41:45 -0700
Message-ID: <CA+55aFz8C16ijz9YHwtwe3M80YaF0CH_ra7BSniunfc3tXi11A@mail.gmail.com>
References: <CA+55aFwEDs26shapevLziT+BPwvHgqOyikCaGcKsNHQLAw6oSw@mail.gmail.com>
	<a2882024-b22e-48d2-80d7-dd18ed664792@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a2882024-b22e-48d2-80d7-dd18ed664792@gmail.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On Wed, Sep 14, 2016 at 12:06 AM, Milan Broz <gmazyland@gmail.com> wrote:
>
> then you are saying that the default should be "destroy all the data
> on possible hidden disk" :-)

No.

> Because that should happen, if you will map "outer" volume with discards on,
> and there is a hidden disk (for outer volume it is "unused" space").

But that's independent of the crypto setup, isn't it?

If the inner filesystem is some hidden crypto volume, then the outer
filesystem could be anything. And if you write to the outer filesystem
in some of the random hidden setups, you'll destroy the hidden volume
anyway. No? So you'd never write to it in the first place, much less
do "fstrim" on it.

I thought the people who used hidden ("deniable") things didn't
actually ever *use* the outer filesystem at all, exactly so that they
can just put the real encrypted thing in there and nor worry about it.

Am I missing something? What's the actual real setup?Can you explain -
in particular, can we perhaps notice it somehow, so that the normal
case at least can enable discard.

Because the reason I want to do this, of course, is that I think it
was now my fifth or sixth setup where I had to manually enable this
thing, and I have never *ever* actually wanted to disable it. And I
bet that is true for 99.99% of all users (ie the normal case).

              Linus
