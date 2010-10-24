From: Milan Broz <mbroz@redhat.com>
Subject: Re: Fwd: [dm-crypt] [BUG] bad performance and system stalls when
 using dm-crypt
Date: Sun, 24 Oct 2010 19:05:55 +0200
Message-ID: <4CC46773.2000606@redhat.com>
References: <AANLkTinbeAn4ObFSb4f4znjYHGNKTMnfV7eQja+cnsLe@mail.gmail.com> <20100911065725.GA6279@fancy-poultry.org> <AANLkTikTq=GTy-XPD6ye6kStASNL4Pa07wHhH_ABmpm1@mail.gmail.com> <AANLkTim7RvpOcBajyqCkrBP8EW-FwNysvwuF5MaDJiFV@mail.gmail.com> <AANLkTi=PCd1=w-mkc=Sj4EEda=PnTv0JGyV1Ysxq4ej4@mail.gmail.com> <AANLkTikLSFFpbgX+rBR5banBygmB6rRvzMBYKfPcFPuJ@mail.gmail.com> <4C8C9834.8060201@redhat.com> <AANLkTi=8jJMz3f0VGwg+6P+BJEfxj6i-jBkGmqx8hCVg@mail.gmail.com> <AANLkTinohRReVsYoetEjqAp-XrL9C2jxGgXLVnLafSUM@mail.gmail.com> <AANLkTikqhMbW7sWbbU_we5YE9Y9U=MPUTm553AmCyH51@mail.gmail.com> <4CC45F56.7010305@redhat.com> <AANLkTi=Hw-iU98rTjyDFAPSqqrWvzhOnE_0UBV-tMeie@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Hw-iU98rTjyDFAPSqqrWvzhOnE_0UBV-tMeie@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dave b <db.pub.mail@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/24/2010 06:52 PM, dave b wrote:
>> So there are now several known situations when dm-crypt doesn't
>> perform as expected (another problem just appeared when using CFQ,
>> (because dm(-crypt) lost the issuing process reference)
>> see http://lkml.org/lkml/2010/10/24/59).
> 
> Thank for you replying  ^ ^
> I was aware with the problems and I am following Andi's dm-crypt
> per-cpu patch (I haven't applied or tested it). However, I didn't know
> about http://lkml.org/lkml/2010/10/24/59 -->
> So this may well be the root of the problem!
> Also, won't http://lkml.org/lkml/2010/10/24/59  need to be altered
> (again) to work with Andi's patch ?

CFQ related problem should be solved - probably device-mapper core
have to provide some help. (It is not only about dm-crypt,
lot of situations when IO is submitted from different internal process.
The proposed patch is not the proper and complete way how to solve it.)

For the per-cpu patch - I am waiting for replay, apparently some
additional work there is needed.
But I would like to solve it ASAP.

Milan
