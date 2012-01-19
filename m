From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 12:30:12 -0800
Message-ID: <4F187D54.602@zytor.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <4F187980.2000306@zytor.com> <CA+55aFxNVaJ8AYXka8khUnkzr=tND9+SMpQ9CU0KFDbvxAJY0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxNVaJ8AYXka8khUnkzr=tND9+SMpQ9CU0KFDbvxAJY0Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
List-Id: dm-devel.ids

On 01/19/2012 12:17 PM, Linus Torvalds wrote:
> On Thu, Jan 19, 2012 at 12:13 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Could you please send me:
>>
>> a) your full strace;
>> b) arch/x86/kernel/syscall_32.o from your build?
> 
> Btw, the strace before-and-after (working vs nonworking) would
> probably be useful. They aren't easily comparable (all the random
> pointers change depending on allocations etc), but some scripting and
> editing out pointer values might make the difference be obvious.
> 
>                          Linus

Possible.  I have actually reproduced it and reduced it to a small test
case already, so I hopefully will have it nailed down soon.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
