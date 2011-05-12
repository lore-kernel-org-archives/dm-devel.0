From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm-crypt on RAID5/6 write performance - cause &
 proposed solutions
Date: Thu, 12 May 2011 10:47:27 +0200
Message-ID: <4DCB9E9F.7040000@redhat.com>
References: <BANLkTin82MipJ1t3uExAHkgVP_09Q7+eWQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BANLkTin82MipJ1t3uExAHkgVP_09Q7+eWQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Chris Lais <chris+linux@zenthought.org>
List-Id: dm-devel.ids

Hi,

On 05/11/2011 09:11 PM, Chris Lais wrote:
> I've recently installed a system with dm-crypt placed over a software
> RAID5 array, and have noticed some very severe issues with write
> performance due to the way dm-crypt works.
> 
> Almost all of these problems are caused by dm-crypt re-ordering bios
> to an extreme degree (as shown by blktrace), such that it is very hard
> for the raid layer to merge them in to full stripes, leading to many
> extra reads and writes.  There are minor problems with losing
> io_context and seeking for CFQ, but they have far less impact.

There is no explicit reordering of bios in dmcrypt.

There are basically two situations were dmcrypt can reorder request:

First is when crypto layer process request asynchronously
(probably not a case here - according to your system spec you should
be probably using AES-NI, right?)

The second possible reordering can happen if you run 2.6.38 kernel and
above, where the encryption run always on the cpu core which submitted it.

First thing is to check what's really going on your system and why.

- What's the io pattern here? Several applications issues writes
in parallel? Can you provide commands how do you tested it?

- Can you test older kernel (2.6.37) and check blktrace?
Does it behave differently (it should - no reordering but all
encryption just on one core.)

- Also 2.6.39-rc (with flush changes) can have influence here,
if you can test that the problems is still here, it would be nice
(any fix will be based on this version).

Anyway, we need to find what's really going before suggesting any fix.

> Using RAID5/6 without dm-crypt does /not/ have these problems in my
> setup, even with standard queue sizes, because the raid layer can
> handle the stripe merging when the bios are not so far out of order.
> Using lower RAID levels even with dm-crypt also does not have these
> problems to such an extreme degree, because they don't need
> read-parity-write cycles for partial stripes.

Ah, so you are suggesting that the problem is caused by read/write
interleaving (parity blocks)?
Or you are talking about degraded mode as well?

Milan
