From: Phil Turmel <philip@turmel.org>
Subject: Re: [mdadm PATCH] Create: tell udev md device is not ready when first
 created.
Date: Sat, 6 May 2017 15:50:29 -0400
Message-ID: <b19a7608-db1f-1fcd-f20f-f606c7851d77@turmel.org>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
 <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
 <87mvbasqx6.fsf@notabene.neil.brown.name>
 <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
 <87h919ruj5.fsf@notabene.neil.brown.name>
 <6bd347e1-170c-48e9-1171-09ff143ace83@redhat.com>
 <c5fe5d16-5ca6-94b0-fd5b-0b6009d78bab@gmail.com>
 <2f431da6-0dce-b485-4109-6f8669814430@redhat.com>
 <590DF8FA.4090600@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590DF8FA.4090600@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Peter Rajnoha <prajnoha@redhat.com>, Jes Sorensen <jes.sorensen@gmail.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/06/2017 12:25 PM, Wols Lists wrote:
> On 03/05/17 15:13, Peter Rajnoha wrote:
>> There's a difference though - when you're *creating* a completely new
>> device that is an abstraction over existing devices, you (most of the
>> time) expect that new device to be initialized. For those corner cases
>> where people do need to keep the old data, there can be an option to do
>> that.
> 
> That's not a corner case. If there's old data that's the NORM. I get
> what you're after, I'm inclined to agree with you, but the default
> should be to DO NOTHING.

There's some miscommunication here, it seems.  mdadm does NOT wipe the
primary device in a mirror during create, nor data blocks in a
parity-based array's stripes, but it DOES wipe the 2nd and following
copy of all mirrored blocks, and DOES wipe all parity and Q blocks.
This behaviour is really important for later consistency when degraded,
and for parallelizing reads of mirrors.

I think a case can be made for wiping it all during create, for
consistency with other kernel behaviour.  If you allocate memory for
userspace, or or create a new file on a filesystem with a specific size,
linux goes to some length to deliver zeros in both cases.  Arguably, it
should do so in MD, too.

However, changing the default behaviour would fit Linus' definition of a
regression, I would think.

Phil
