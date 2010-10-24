From: Milan Broz <mbroz@redhat.com>
Subject: Re: Fwd: [dm-crypt] [BUG] bad performance and system stalls when
 using dm-crypt
Date: Sun, 24 Oct 2010 18:31:18 +0200
Message-ID: <4CC45F56.7010305@redhat.com>
References: <AANLkTinbeAn4ObFSb4f4znjYHGNKTMnfV7eQja+cnsLe@mail.gmail.com> <20100911065725.GA6279@fancy-poultry.org> <AANLkTikTq=GTy-XPD6ye6kStASNL4Pa07wHhH_ABmpm1@mail.gmail.com> <AANLkTim7RvpOcBajyqCkrBP8EW-FwNysvwuF5MaDJiFV@mail.gmail.com> <AANLkTi=PCd1=w-mkc=Sj4EEda=PnTv0JGyV1Ysxq4ej4@mail.gmail.com> <AANLkTikLSFFpbgX+rBR5banBygmB6rRvzMBYKfPcFPuJ@mail.gmail.com> <4C8C9834.8060201@redhat.com> <AANLkTi=8jJMz3f0VGwg+6P+BJEfxj6i-jBkGmqx8hCVg@mail.gmail.com> <AANLkTinohRReVsYoetEjqAp-XrL9C2jxGgXLVnLafSUM@mail.gmail.com> <AANLkTikqhMbW7sWbbU_we5YE9Y9U=MPUTm553AmCyH51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikqhMbW7sWbbU_we5YE9Y9U=MPUTm553AmCyH51@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dave b <db.pub.mail@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/24/2010 05:32 PM, dave b wrote:
> I am forwarding this to the linux kernel mailing list to see if anyone
> is actually interested with this bug or not. I suspect that the patch
> to allow DM-CRYPT to use multiple cpus(Scale to multiple CPUs) will
> remove most of the problem but *not* all of it. As I previously was
> triggering the bug on a single core system.

Hi,
sorry for not updating the bug. We know about this.

Fix was expected to be based on top of the Andi's dm-crypt per-cpu
patch but unfortunately I found serious problems there
(see this thread http://lkml.org/lkml/2010/10/20/215 )

So there are now several known situations when dm-crypt doesn't
perform as expected (another problem just appeared when using CFQ,
(because dm(-crypt) lost the issuing process reference)
see http://lkml.org/lkml/2010/10/24/59).

Milan
