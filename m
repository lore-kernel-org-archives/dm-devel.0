From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: dmsetup fails on latest kernel
Date: Fri, 20 Jan 2012 06:45:51 -0800
Message-ID: <4F197E1F.20206@zytor.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <4F188817.3090104@zytor.com> <CALLzPKapudkuBxsF49jMAOtVpeu=hpa9SgY=WewtU6GYEm6M_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALLzPKapudkuBxsF49jMAOtVpeu=hpa9SgY=WewtU6GYEm6M_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
List-Id: dm-devel.ids

On 01/20/2012 05:35 AM, Kasatkin, Dmitry wrote:
> On Thu, Jan 19, 2012 at 11:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Here is a patch which should fix this problem.  I will run a few more
>> tests and then push it with the rest of the urgent queue to Linus.
>>
>>        -hpa
> 
> Hi,
> 
> Yes. It solves the problem..
> Do you still want straces?
> 

No need, thanks!

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
