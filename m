From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: crash in multipathd
Date: Wed, 02 Feb 2005 23:21:27 +0100
Message-ID: <42015267.9090109@free.fr>
References: <CC9E49E3-72FD-11D9-8EBB-000A95A2734C@nanisky.com>
	<a80f8224e84fa48e92f6e4ad243143ec@fotango.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <a80f8224e84fa48e92f6e4ad243143ec@fotango.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Arthur Bergman <abergman@fotango.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Works here on x86 and amd64.
Can you give a little more background ?

regards,
cvaroqui

Arthur Bergman wrote:

> I tried compiling my own version and the same thing happens,
>
> so using multipath -S works to set them up, but multipathd crashes...
>
> also, gdb crashes when I try to debug it!
>
> cheers
> Arthur
>
> -----
> CTO @ Fotango Ltd
> +447834716919
> http://www.fotango.com/
>
> On 30 Jan 2005, at 20:30, Arthur Bergman wrote:
>
>> Trying to get multipath-tools working on a debian system, multipath 
>> the tool works but multipathd segfaults.
>>
>> getrlimit(RLIMIT_STACK, {rlim_cur=RLIM_INFINITY, 
>> rlim_max=RLIM_INFINITY}) = 0
>> setrlimit(RLIMIT_STACK, {rlim_cur=2044*1024, rlim_max=RLIM_INFINITY}) 
>> = 0
>> getpid()                                = 3700
>> rt_sigaction(SIGRTMIN, {0x40024030, [], 0}, NULL, 8) = 0
>> rt_sigaction(SIGRT_1, {0x40024080, [], 0}, NULL, 8) = 0
>> rt_sigaction(SIGRT_2, {0x40024150, [], 0}, NULL, 8) = 0
>> rt_sigprocmask(SIG_BLOCK, [RTMIN], NULL, 8) = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RT_1], NULL, 8) = 0
>> _sysctl({{CTL_KERN, KERN_VERSION}, 2, 0xbffffa74, 31, (nil), 0}) = 0
>> brk(0)                                  = 0x8052000
>> brk(0x8073000)                          = 0x8073000
>> brk(0)                                  = 0x8073000
>> clone(Process 3701 attached
>> child_stack=0x8056038, flags=CLONE_NEWNS) = 3701
>> [pid  3700] exit_group(0)               = ?
>> [pid  3701] --- SIGSEGV (Segmentation fault) @ 0 (0) ---
>> Process 3701 detached
>>
>> please advice, should I try to compile my own version?
>>
>> Cheers
>> Arthur
>>
>> -----
>> CTO @ Fotango Ltd
>> +447834716919
>> http://www.fotango.com/
>> -- 
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
