From: "Guilherme G. Piccoli" <guilherme@gpiccoli.net>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Wed, 8 May 2019 11:52:29 -0300
Message-ID: <0ad36b2f-ec36-6930-b587-da0526613567@gpiccoli.net>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com>
 <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
 <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
 <5CD2A172.4010302@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <5CD2A172.4010302@youngman.org.uk>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Song Liu <liu.song.a23@gmail.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net, Ming Lei <ming.lei@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, stable@vger.kernel.org
List-Id: dm-devel.ids

On 5/8/19 6:29 AM, Wols Lists wrote:
> On 06/05/19 22:07, Song Liu wrote:
>> Could you please run a quick test with raid5? I am wondering whether
>> some race condition could get us into similar crash. If we cannot easily
>> trigger the bug, we can process with this version.
> 
> Bear in mind I just read the list and write documentation, but ...
> 
> My gut feeling is that if it can theoretically happen for all raid
> modes, it should be fixed for all raid modes. What happens if code
> changes elsewhere and suddenly it really does happen for say raid-5?
> 
> On the other hand, if fixing it in md.c only gets tested for raid-0, how
> do we know it will actually work for other raids if they do suddenly
> start falling through.

Hi, I understand your concern. But all other raid levels contains 
failure-event mechanisms. For example, in all my tests with raid5 or 
raid1, it first complained the device was removed, then it failed in 
super_written() when no other available device was present.
On the other hand, raid0 does "blind-writes": it just selects the device 
in which that bio should be written (given the stripe math) and change 
the bio's device, sending it back via generic_make_request(). It's 
dummy, but not in a bad way, but rather for performance reasons. It has 
no "intelligence" for failures, as all other raid levels.

That said, we could fix md.c for all raid levels, but I personally think 
it's a bazooka shot, only raid0 shows consistently this issue.

> 
> Academic purity versus engineering practicality :-)

Heheh you have good points here! Thanks for the input =)
Cheers,


Guilherme


> 
> Cheers,
> Wol
> 
