From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: dm-cache: ensuring cache is flushed in timely manner
Date: Wed, 5 Jul 2017 19:49:02 +0200
Message-ID: <bfb4ced2-0c66-d0b8-177e-c4e01b6a842e@gmail.com>
References: <CAM2wQBtB2OSk_fgC99n=9WU0t3TGUK7J0j7+83GXwia=5tYGPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAM2wQBtB2OSk_fgC99n=9WU0t3TGUK7J0j7+83GXwia=5tYGPA@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@onapp.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 5.7.2017 v 17:21 Thanos Makatos napsal(a):
> Occasionally I need to flush a writeback cache in order to execute
> some other operation (e.g. take a back up). I do this by first setting
> the policy to cleaner, then wait for the number of dirty blocks to
> reach 0, and finally set the mode to writethrough. After that it is
> safe to execute the operation I want. Once I'm finished I set the
> policy to mq/smq and mode to writeback, job done. (Just a sanity check
> here, is my flush procedure correct?)
> 
> The problem is that when I/O is particularly heavy (e.g. lots of
> concurrent random writes) and the backing device is too slow (e.g. the
> HDD is some remote, virtualised block device), the number of dirty
> blocks not only fails to decrease, it even increases from time to
> time. This is happening on CentOS 3.18.44-20.el6.x86_64.
> 
> I was able to locally reproduce this by priming the cache, setting
> migration_threshold to 0, dirtying it, rate-limiting the backing
> device (e.g. to 1 MB/s), running fio with random writes and a queue
> depth of 32, and then finally restoring migration_threshold and
> setting the policy to cleaner. The number of dirty blocks generally
> fluctuates but never seems to reach 0.
> 
> I understand that I can solve the problem by rate-limiting the cache
> target such that there are more I/O resources for the flush to work
> with, but AFAIK the only way to do this is via cgroups and it requires
> an absolute number (e.g. MB/s or IOPS). Providing such an absolute
> number doesn't seem attractive as it always boils down to how heavily
> the cache target is used vs. the backing device I/O performance.
> 
> Ideally I'd like to use something like ionice where I could prioritise
> flushing (even slightly) over serving regular I/O, but that doesn't
> look like an option here as I don't see separate threads for handling
> regular I/O and flushing I/O.
> 
> Any ideas how I could solve this problem?
> 

Hi

I'd guess the primary issue is you keep 'writeback' with cleaner policy,
but this is unsupported - when you switch to cleaner policy, you also need to 
change to writethrough cache mode.

Regards

Zdenek
