From: Kees Cook <keescook@chromium.org>
Subject: Re: dm: writecache: Use 2-factor allocator arguments
Date: Wed, 27 Jun 2018 14:53:09 -0700
Message-ID: <CAGXu5jL896qy0OmztQ0Re9Z4-a7ry4jL1RMkgGncs1K85eW-Kw@mail.gmail.com>
References: <20180618175033.GA2627@beast> <CAGXu5j+Su3fObnuzntQ7Tp8W6jfMt1hc=h-3Xhidgx--Nau1Ew@mail.gmail.com>
 <20180627215227.GA13549@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180627215227.GA13549@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Dan Williams <dan.j.williams@intel.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 27, 2018 at 2:52 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Jun 27 2018 at  5:48pm -0400,
> Kees Cook <keescook@chromium.org> wrote:
>
>> On Mon, Jun 18, 2018 at 10:50 AM, Kees Cook <keescook@chromium.org> wrote:
>> > This adjusts the allocator calls to use the 2-factor argument style, as
>> > already done treewide for better defense against allocator overflows.
>> > Additionally adjusts style nit to avoid assignments in test expressions.
>> >
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> Friendly ping -- I'd like to make sure this makes it into 4.18. All
>> other 2-factor allocations have been fixed in the kernel.
>
> Yeap, I'll be sending it to Linus this week.  Already staged and ready
> to go, please see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=50a7d3ba7c9ac5e0b7e03fc7f420180989361dbf

Ah! Thank you very much! :)

-Kees

-- 
Kees Cook
Pixel Security
