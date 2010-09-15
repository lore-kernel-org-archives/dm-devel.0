From: McPacino <mcpacino@gmail.com>
Subject: Re: new "multi-version snapshot target" [was: Re: [PATCH] vfs:
 calculate block-size correctly]
Date: Wed, 15 Sep 2010 23:44:03 +0800
Message-ID: <AANLkTinJ4nDfSKTPoN=OXDR+tUum8KjPQy-ZrmoE=5UM@mail.gmail.com>
References: <AANLkTinpFpAdiU=kNTmL4FNn4kTyRUiVcKxnq=mi2O2D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinpFpAdiU=kNTmL4FNn4kTyRUiVcKxnq=mi2O2D@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Sep 15, 2010 at 10:20 PM, Mike Snitzer <snitzer@redhat.com> wro=
te:
> On Wed, Sep 15, 2010 at 4:14 AM, McPacino <mcpacino@gmail.com> wrote:
>> On Tue, Sep 14, 2010 at 7:09 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>>
>>> On Wed, 8 Sep 2010 18:07:10 +0800
>>> Cong Meng <mcpacino@gmail.com> wrote:
>>>
>>> > I sent this patch half mount ago, but no response at all. If anyt=
hing is
>>> > wrong, please tell me. Thanks a lots. This is my first time to se=
nd patch
>>> > to linux kernel.
>>> >
>>> > The invocation of __getblk(bdev, block, size) will cause kernel s=
tall if
>>> > the @size parameter is not equal to the blockr-size of @bdev, whi=
ch is saved
>>> > in bdev->bd_inode->i_blkbits.
>>> >
>>> > submit_bh() has the similar problem.
>>> >
>>> > This patch calculates the block-size using i_blkbits.
>>> > So that, for example, __getblk() can get a 4K buffer head while t=
he
>>> > block-size of @bdev is 1K.
>>> >
>>>
>>> This comes up every couple of years and iirc we always decided that
>>> it's a bug in the calling code somewhere. =A0How did you hit it?
>>>
>>
>> I am working on a new multi-version snapshot target module for devic=
e-mapper
>> which is almost done.
>
> And you hope to have this code included upstream? =A0Do you intend to
> post your patches to dm-devel?
>

Of course, yes.
The code is almost finished and is being tested.
I will post it few weeks later if everything goes well.

> Thanks,
> Mike
>
