From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: dmsetup fails on latest kernel
Date: Thu, 19 Jan 2012 12:17:32 -0800
Message-ID: <CA+55aFxNVaJ8AYXka8khUnkzr=tND9+SMpQ9CU0KFDbvxAJY0Q@mail.gmail.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
 <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <4F187980.2000306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F187980.2000306@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
List-Id: dm-devel.ids

On Thu, Jan 19, 2012 at 12:13 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Could you please send me:
>
> a) your full strace;
> b) arch/x86/kernel/syscall_32.o from your build?

Btw, the strace before-and-after (working vs nonworking) would
probably be useful. They aren't easily comparable (all the random
pointers change depending on allocations etc), but some scripting and
editing out pointer values might make the difference be obvious.

                         Linus
