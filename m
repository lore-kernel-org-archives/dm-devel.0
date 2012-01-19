From: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 11:58:04 -0800
Message-ID: <4F1875CC.4010006@linux.intel.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <CA+55aFwwkjFsVuSZWgasN4e_d9suRV4Afr94NMvNt4R7Ej0gbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwwkjFsVuSZWgasN4e_d9suRV4Afr94NMvNt4R7Ej0gbw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 01/19/2012 11:05 AM, Linus Torvalds wrote:
>>
>> Hi,
>>
>> I have bisected the problem...
>>
>> It is introduced by this commit:
>>
>> 303395ac3bf3e2cb488435537d416bc840438fcb is the first bad commit
>> commit 303395ac3bf3e2cb488435537d416bc840438fcb
>> Author: H. Peter Anvin<hpa@linux.intel.com>
>> Date:   Fri Nov 11 16:07:41 2011 -0800
>>
>>     x86: Generate system call tables and unistd_*.h from tables
>
> Interesting. I just munged the old pre-merge
>
>    arch/x86/kernel/syscall_table_32.S
>
> and the new
>
>    arch/x86/syscalls/syscall_32.tbl
>
> with some trivial shell scripting, and they are definitely identical.
>
> So the tables look like they match 1:1.
>
> The compat tables match too, except the new list contains the entry
> for bdflush (134), but that's a legacy thing that doesn't matter.
>
> I wonder what else could be going on. Wrong number of system calls
> check? Peter, any ideas?
>

Not off the top of my head.  I will try to reproduce this and see what 
the problem is.  Dmitry, what version of binutils and gcc are you using? 
  It could be that there is a toolchain problem.

	-hpa
