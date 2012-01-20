From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: dmsetup fails on latest kernel
Date: Fri, 20 Jan 2012 14:52:56 +0200
Message-ID: <CALLzPKYrqD+FdHB0mLqR=gB6dptKGe2ouMO8i4Kj1R7U4Ev8Ow@mail.gmail.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
	<CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
	<CA+55aFwwkjFsVuSZWgasN4e_d9suRV4Afr94NMvNt4R7Ej0gbw@mail.gmail.com>
	<4F1875CC.4010006@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F1875CC.4010006@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Jan 19, 2012 at 9:58 PM, H. Peter Anvin <hpa@linux.intel.com> w=
rote:
> On 01/19/2012 11:05 AM, Linus Torvalds wrote:
>>>
>>>
>>> Hi,
>>>
>>> I have bisected the problem...
>>>
>>> It is introduced by this commit:
>>>
>>> 303395ac3bf3e2cb488435537d416bc840438fcb is the first bad commit
>>> commit 303395ac3bf3e2cb488435537d416bc840438fcb
>>> Author: H. Peter Anvin<hpa@linux.intel.com>
>>> Date: =C2=A0 Fri Nov 11 16:07:41 2011 -0800
>>>
>>> =C2=A0 =C2=A0x86: Generate system call tables and unistd_*.h from t=
ables
>>
>>
>> Interesting. I just munged the old pre-merge
>>
>> =C2=A0 arch/x86/kernel/syscall_table_32.S
>>
>> and the new
>>
>> =C2=A0 arch/x86/syscalls/syscall_32.tbl
>>
>> with some trivial shell scripting, and they are definitely identical=
=2E
>>
>> So the tables look like they match 1:1.
>>
>> The compat tables match too, except the new list contains the entry
>> for bdflush (134), but that's a legacy thing that doesn't matter.
>>
>> I wonder what else could be going on. Wrong number of system calls
>> check? Peter, any ideas?
>>
>
> Not off the top of my head. =C2=A0I will try to reproduce this and se=
e what the
> problem is. =C2=A0Dmitry, what version of binutils and gcc are you us=
ing? =C2=A0It
> could be that there is a toolchain problem.
>

gcc (Ubuntu/Linaro 4.6.1-9ubuntu3) 4.6.1
binutils 2.21.53.20110810-0ubuntu5.1


> =C2=A0 =C2=A0 =C2=A0 =C2=A0-hpa
>
>
