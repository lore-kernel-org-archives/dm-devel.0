From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 18:10:28 +0200
Message-ID: <CALLzPKYuKufGoUkXb9kPSn6buzVY0awzCL2F9onr1=NxysP3_w@mail.gmail.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
	<CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@linux.intel.com>
List-Id: dm-devel.ids

On Thu, Jan 19, 2012 at 5:56 PM, Kasatkin, Dmitry
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
> Date: =C2=A0 Fri Nov 11 16:07:41 2011 -0800
>
> =C2=A0 =C2=A0x86: Generate system call tables and unistd_*.h from tab=
les
>
>
> It came from: =C2=A0Merge branch 'x86-syscall-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> Was on 17.01.2012...
>
> I have 32 bit VM and I have SYSVIPC enabled in the configuration...
>
> - Dmitry

It seems "semget" is missing from: arch/x86/syscalls/syscall_32.tbl
But it presents in: arch/x86/syscalls/syscall_64.tbl

Is it a bug then?

- Dmitry
