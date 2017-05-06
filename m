From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [mdadm PATCH] Create: tell udev md device is not ready when first
 created.
Date: Sat, 6 May 2017 17:25:30 +0100
Message-ID: <590DF8FA.4090600@youngman.org.uk>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
 <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
 <87mvbasqx6.fsf@notabene.neil.brown.name>
 <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
 <87h919ruj5.fsf@notabene.neil.brown.name>
 <6bd347e1-170c-48e9-1171-09ff143ace83@redhat.com>
 <c5fe5d16-5ca6-94b0-fd5b-0b6009d78bab@gmail.com>
 <2f431da6-0dce-b485-4109-6f8669814430@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2f431da6-0dce-b485-4109-6f8669814430@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rajnoha <prajnoha@redhat.com>, Jes Sorensen <jes.sorensen@gmail.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/05/17 15:13, Peter Rajnoha wrote:
> There's a difference though - when you're *creating* a completely new
> device that is an abstraction over existing devices, you (most of the
> time) expect that new device to be initialized. For those corner cases
> where people do need to keep the old data, there can be an option to do
> that.

That's not a corner case. If there's old data that's the NORM. I get
what you're after, I'm inclined to agree with you, but the default
should be to DO NOTHING.

If you want mdadm to mess about with the content of the drives you
should either (a) explicitly tell it to (yes I would like that option
:-), or (b) do it yourself beforehand - dd if=/dev/zero etc etc.

It does seem weird to me that mdadm spends a lot of effort initialising
an array and calculating parity blah-di-blah, and you can't tell it to
just "set everything to zero". But there's no way it should mess about
with what was there before, without explicitly being told to.

 When you're inserting existing drives, you're not creating them -
> when those device come from factory (they're "created"), they never
> contain garbage and old data when you buy them.

As Jes says, USB devices rarely come with nothing on them. MS eventually
learnt their lesson, "doing something" BY DEFAULT with unknown/untrusted
data was a really stupid idea - it was far too easy to get your system
"pwned". Here it would be far too easy to trash an array you're trying
to recover.

Cheers,
Wol
