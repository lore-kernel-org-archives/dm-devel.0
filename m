From: Richard Kralovic <Richard.Kralovic@dcs.fmph.uniba.sk>
Subject: Re: CFQ and dm-crypt
Date: Mon, 25 Oct 2010 11:53:39 +0200
Message-ID: <4CC553A3.5070308@dcs.fmph.uniba.sk>
References: <4CC439ED.8090400@dcs.fmph.uniba.sk> <4CC45BAD.2060308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CC45BAD.2060308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/24/10 18:15, Milan Broz wrote:
> On 10/24/2010 03:51 PM, Richard Kralovic wrote:
>> CFQ io scheduler relies on using task_struct current to determine which
>> process makes the io request. On the other hand, some dm modules (such
>> as dm-crypt) use separate threads for doing io. As CFQ sees only these
>> threads, it provides a very poor performance in such a case.
>>
>> IMHO the correct solution for this would be to store, for every io
>> request, the process that initiated it (and preserve this information
>> while the request is processed by device mapper). Would that be feasible?
> 
> Yes, this seems to be correct solution. I think this should be
> handled by core device-mapper (as you noted, more dm targets using
> threads to process.)

Do you think it is possible to handle this in device-mapper, without any
support from the cfq code?

I also noticed that a solution for this problem was proposed a few years
ago by Hirokazu Takahashi (a patch for linux-2.6.25,
http://lkml.org/lkml/2008/4/22/193), but there was no response to it. Is
such an approach wrong?

>> Other possibility is to avoid using separate threads for doing io in dm
>> modules. The attached patch (against 2.6.36) modifies dm-crypt in this
>> way, what results into much better behavior of cfq (e.g., io priorities
>> work correctly).
> 
> Sorry, this completely dismantles the way how dm-crypt solves problems
> with stacking dm devices.
> Basically it reintroduces possible deadlocks for low memory
> situations (the reason why there are these threads).

Would the problem with deadlock be still present if the io worker queue
was used for writes only, but reads were issued directly? (Even this
would be a significant improvement for people using cfq and a full-disk
encryption over dm-crypt, since asynchronous writes are not supported by
cfq anyway.)

	Richard
