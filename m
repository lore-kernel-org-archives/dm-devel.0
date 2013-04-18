From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Thu, 18 Apr 2013 22:45:10 +0800
Message-ID: <517006F6.7030806@cn.fujitsu.com>
References: <516E5EF8.9090507@cn.fujitsu.com> <1366209997.8817.12.camel@pippen.local.home> <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com> <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com> <20130418143014.GZ4816@kernel.dk>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130418143014.GZ4816@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, namhyung@gmail.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>
List-Id: dm-devel.ids

On 04/18/2013 10:30 PM, Jens Axboe wrote:
> On Thu, Apr 18 2013, Wanlong Gao wrote:
>> On 04/18/2013 09:35 PM, Jens Axboe wrote:
>>> On Thu, Apr 18 2013, Wanlong Gao wrote:
>>>>> A bio is always fully initialized, regardless of which internal
>>>>> allocator it came from. If people are doing private kmallocs, then they
>>>>> better be using bio_init() as well.
>>>>>
>>>>> Wanlong, would it be possible to get a full dmesg on boot see I can see
>>>>> what drivers and file systems are in use? Anything special about your
>>>>> setup.
>>>>
>>>> Sure, attached.
>>>
>>> Does the below help?
>>
>> Still got panic with this patch. :-(
> 
> Could you capture the full dump? I'd like to see what rcx was, and that
> seems to have scrolled off.

OK, but I should capture it tomorrow morning because this remote machine has already panicked
and need hard reboot.

Thanks,
Wanlong Gao

> 
