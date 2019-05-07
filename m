From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
Date: Tue, 7 May 2019 18:51:36 -0300
Message-ID: <21d2ab66-4295-6b69-ef85-d798f3406fbd@canonical.com>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com>
 <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
 <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Song Liu <liu.song.a23@gmail.com>
Cc: linux-block@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>, Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net, Ming Lei <ming.lei@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, stable@vger.kernel.org
List-Id: dm-devel.ids

On 06/05/2019 18:07, Song Liu wrote:
>> [...]
>> I understand this could in theory affects all the RAID levels, but in
>> practice I don't think it'll happen. RAID0 is the only "blind" mode of
>> RAID, in the sense it's the only one that doesn't care at all with
>> failures. In fact, this was the origin of my other thread [0], regarding
>> the change of raid0's behavior in error cases..because it currently does
>> not care with members being removed and rely only in filesystem failures
>> (after submitting many BIOs to the removed device).
>>
>> That said, in this change I've only took care of raid0, since in my
>> understanding the other levels won't submit BIOs to dead devices; we can
>> experiment that to see if it's true.
> 
> Could you please run a quick test with raid5? I am wondering whether
> some race condition could get us into similar crash. If we cannot easily
> trigger the bug, we can process with this version.
> 
> Thanks,
> Song

Hi Song, I've tested both RAID5 (with 3 disks, removing one at a time),
and also RAID 1 (2 disks, also removing one at a time); no issues
observed in kernel 5.1. We can see one interesting message in kernel
log: "super_written gets error=10", which corresponds to md detecting
the error (bi_status == BLK_STS_IOERROR) and instantly failing the
write, making FS read-only.

So, I think really the issue happens only in RAID0, which writes
"blindly" to its components.
Let me know your thoughts - thanks again for your input!

Cheers,


Guilherme
