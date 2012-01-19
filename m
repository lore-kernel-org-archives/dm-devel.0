From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 11:05:41 -0800
Message-ID: <CA+55aFwwkjFsVuSZWgasN4e_d9suRV4Afr94NMvNt4R7Ej0gbw@mail.gmail.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
 <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
List-Id: dm-devel.ids

On Thu, Jan 19, 2012 at 7:56 AM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Thu, Jan 19, 2012 at 3:02 PM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
>> Hi,
>>
>> (subject added)
>>
>> I rebased on the stop of latest mainline tree and now dmsetup fails.=
=2E.
>> It says: "Failed to create notification semaphore: Function not impl=
emented".
>> I run strace and saw that dmsetup uses "semget" which returns -ENOSY=
S...
>>
>> It works on
>> 122804ecb59493fbb4d31b3ba9ac59faaf45276f
>>
>> but does not work on
>> ccb19d263fd1c9e34948e2158c53eacbff369344
>>
>> Any ideas?
>>
>> - Dmitry
>
> Hi,
>
> I have bisected the problem...
>
> It is introduced by this commit:
>
> 303395ac3bf3e2cb488435537d416bc840438fcb is the first bad commit
> commit 303395ac3bf3e2cb488435537d416bc840438fcb
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date: =A0 Fri Nov 11 16:07:41 2011 -0800
>
> =A0 =A0x86: Generate system call tables and unistd_*.h from tables

Interesting. I just munged the old pre-merge

  arch/x86/kernel/syscall_table_32.S

and the new

  arch/x86/syscalls/syscall_32.tbl

with some trivial shell scripting, and they are definitely identical.

So the tables look like they match 1:1.

The compat tables match too, except the new list contains the entry
for bdflush (134), but that's a legacy thing that doesn't matter.

I wonder what else could be going on. Wrong number of system calls
check? Peter, any ideas?

                        Linus
