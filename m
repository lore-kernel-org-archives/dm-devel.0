From: Milan Broz <gmazyland@gmail.com>
Subject: Re: Can we please make 'allow_discards' the default for
	dm-crypt?
Date: Wed, 14 Sep 2016 18:44:39 +0200
Message-ID: <e56c07d2-ccf3-ab0f-909c-607b8846dccd@gmail.com>
References: <CA+55aFwEDs26shapevLziT+BPwvHgqOyikCaGcKsNHQLAw6oSw@mail.gmail.com>
	<a2882024-b22e-48d2-80d7-dd18ed664792@gmail.com>
	<CA+55aFz8C16ijz9YHwtwe3M80YaF0CH_ra7BSniunfc3tXi11A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: dm-devel.ids

On 09/14/2016 05:41 PM, Linus Torvalds wrote:
> On Wed, Sep 14, 2016 at 12:06 AM, Milan Broz <gmazyland@gmail.com> wrote:
>>
>> then you are saying that the default should be "destroy all the data
>> on possible hidden disk" :-)
> 
> No.
> 
>> Because that should happen, if you will map "outer" volume with discards on,
>> and there is a hidden disk (for outer volume it is "unused" space").
> 
> But that's independent of the crypto setup, isn't it?
> 
> If the inner filesystem is some hidden crypto volume, then the outer
> filesystem could be anything. And if you write to the outer filesystem
> in some of the random hidden setups, you'll destroy the hidden volume
> anyway. No? So you'd never write to it in the first place, much less
> do "fstrim" on it.

Well, they actually should "use" outer from time to time so the data looks "recent"
and for the whole "hidden OS" they should be even able to boot to outer decoy
OS on request, just to show that something working is there.

For the TrueCrypt the whole trick that they use FAT for outer volume.
If the hidden part is for example in the second half of the volume and
if you never write more than half of available data space, its trivial allocation
logic should not overwrite hidden volume. (And vice versa, it will overwrite
only unused space from hidden volume in outer fs).

(I am just explaining this - I do not believe it is really good idea today,
it is fragile and it will not work with other fs than FAT actually.)

My point is that by enabling discard by default now we risk loosing user's data,
even if it is 0.00001%, I definitely care about it. 
(Anyone can build such a system today and expect discards are rejected.)
...

> Am I missing something? What's the actual real setup?Can you explain -
> in particular, can we perhaps notice it somehow, so that the normal
> case at least can enable discard.

I think that if we handle this in userspace, default can be enabled.
(It really makes sense for most of users.) Just do not enable it
if activating specific device types that require it for some
paranoid reasons.

If you care about normal case, it is usually LUKS (or similar format).
So I see no problem to move decision of enabling discard there.
(If anyone uses dmsetup, it is definitely not the normal ... case :)

> Because the reason I want to do this, of course, is that I think it
> was now my fifth or sixth setup where I had to manually enable this
> thing, and I have never *ever* actually wanted to disable it. And I
> bet that is true for 99.99% of all users (ie the normal case).

Yes, you are not alone. (I thought installers do this automatically.)

The problem is that for LUKS we have no on-disk option for storing
discard-enabled option (crypttab is initscript/systemd thing, cryptsetup
does not use it directly) so there should be reliable way how to disable it.
(I want to avoid updating on-disk format now, backward compatibility
is big plus currently and the format has far more problems than this one
anyway.)

For the new format (we are playing with "LUKS2" already) discard info is
already stored on-disk, so no problem to changing default
and provide user way to change it.
Just this will take time until the new format is merged and become used
in distributions.

Mike is DM maintainer, so I will use in cryptsetup whatever appears
in kernel. But I would really prefer that it is userspace decision with
discard not enabled in dm-crypt by default...

Milan
