From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Jun 4 (md/dm-writecache.c)
Date: Mon, 4 Jun 2018 11:27:55 -0700
Message-ID: <7b566935-a03d-ecab-be2a-10e25e4554f6@infradead.org>
References: <20180604215911.75399f6e@canb.auug.org.au>
 <0e3fa62d-727e-ccb8-53ae-a6aaa6c506e2@infradead.org>
 <20180604182259.GA5440@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180604182259.GA5440@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next Mailing List <linux-next@vger.kernel.org>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 06/04/2018 11:22 AM, Mike Snitzer wrote:
> On Mon, Jun 04 2018 at 12:06pm -0400,
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> On 06/04/2018 04:59 AM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20180601:
>>>
>>
>> on x86_64:
>>
>> In file included from ../drivers/md/dm-writecache.c:8:0:
>> ../drivers/md/dm-writecache.c: In function ‘writecache_status’:
>> ../include/linux/compiler.h:61:17: warning: format ‘%ld’ expects argument of type ‘long int’, but argument 4 has type ‘int’ [-Wformat=]
>>    static struct ftrace_branch_data   \
>>                  ^
>> ../include/linux/device-mapper.h:550:46: note: in definition of macro ‘DMEMIT’
>>       0 : scnprintf(result + sz, maxlen - sz, x))
>>                                               ^
>> ../include/linux/compiler.h:48:24: note: in expansion of macro ‘__branch_check__’
>>  #  define unlikely(x) (__branch_check__(x, 0, __builtin_constant_p(x)))
>>                         ^
>> ../drivers/md/dm-writecache.c:414:35: note: in expansion of macro ‘unlikely’
>>  #define writecache_has_error(wc) (unlikely(READ_ONCE((wc)->error)))
>>                                    ^
>> ../include/linux/compiler.h:56:23: note: in expansion of macro ‘__trace_if’
>>  #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>>                        ^
>> ../include/linux/compiler.h:251:2: note: in expansion of macro ‘if’
>>   if (check)       \
>>   ^
>> ../include/linux/compiler.h:258:22: note: in expansion of macro ‘__READ_ONCE’
>>  #define READ_ONCE(x) __READ_ONCE(x, 1)
>>                       ^
>> ../drivers/md/dm-writecache.c:414:44: note: in expansion of macro ‘READ_ONCE’
>>  #define writecache_has_error(wc) (unlikely(READ_ONCE((wc)->error)))
>>                                             ^
>> ../drivers/md/dm-writecache.c:2196:32: note: in expansion of macro ‘writecache_has_error’
>>    DMEMIT("%ld %llu %llu %llu", writecache_has_error(wc),
>>                                 ^
>>
>> s/%ld/%d/
> 
> AFAICT, this is the correct fix:
> https://patchwork.kernel.org/patch/10438865/
> 
> Not seen any response to it (Steven and Ingo were emailed, Arnd and LKML
> were cc'd).

Yes, thanks.  That looks good.

-- 
~Randy
