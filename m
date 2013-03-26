From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt performance
Date: Tue, 26 Mar 2013 21:58:49 +0100
Message-ID: <51520C09.9050808@gmail.com>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com> <20130326122713.GC27610@agk-dp.fab.redhat.com> <5151FF82.6090405@gmail.com> <20130326202837.GA5599@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130326202837.GA5599@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>, tj@kernel.org
List-Id: dm-devel.ids

On 26.3.2013 21:28, Mike Snitzer wrote:
> On Tue, Mar 26 2013 at  4:05pm -0400,
> Milan Broz <gmazyland@gmail.com> wrote:
>
>>> On Mon, Mar 25, 2013 at 11:47:22PM -0400, Mikulas Patocka wrote:
>>>
>>>> For best performance we could use the unbound workqueue implementation
>>>> with request sorting, if people don't object to the request sorting being
>>>> done in dm-crypt.
>>
>> So again:
>>
>> - why IO scheduler is not working properly here? Do it need some extensions?
>> If fixed, it can help even is some other non-dmcrypt IO patterns.
>> (I mean dmcrypt can set some special parameter for underlying device queue
>> automagically to fine-tune sorting parameters.)
>
> Not sure, but IO scheduler changes are fairly slow to materialize given
> the potential for adverse side-effects.  Are you so surprised that a
> shotgun blast of IOs might make the IO schduler less optimal than if
> some basic sorting were done at the layer above?

All I said is that I think the problems should be solved on proper layer where
are already all mechanisms to properly control it.
And only if it is not possible then use such workarounds.

CPU bounded io in dmcrypt is in kernel for >2 years and I know about just
few cases where it caused real problems. Maybe I am mistaken - then now is
ideal time for people to complain :)

Anyway, are we talking about the same Mikulas' patch I tested months ago
or you have something new?
I mean this part from series of dmcrypt patches:
http://mbroz.fedorapeople.org/dm-crypt/3.6-rc/dm-crypt-25-sort-writes.patch

Milan
