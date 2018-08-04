From: WGH <wgh@torlan.ru>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 13:01:32 +0300
Message-ID: <a5feeaa7-e043-3987-cf23-4090e3eeec4a@torlan.ru>
References: <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <20180803133102.GA3092@redhat.com> <20180803152034.GD32066@thunk.org>
 <20180803183932.GA3258@redhat.com>
 <CA+55aFwGGjs_imFFkEPJ4g99Kseam=4Qppv4G6Q=ZfZXdzF7Vw@mail.gmail.com>
 <20180803190617.GA4498@redhat.com>
 <CA+55aFzSM6qhZpM4CCpRNR_LWNCbLyRtQQ3hnPwnRrBdDkwWUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzSM6qhZpM4CCpRNR_LWNCbLyRtQQ3hnPwnRrBdDkwWUw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On 08/03/2018 10:22 PM, Linus Torvalds wrote:
> And in fact, maybe the right thing to do is to not revert the original
> commit entirely, but instead just weaken it a lot. Turn the "you did a
> write request on a RO disk" into a WARN_ON_ONCE() instead of a hard
> error.
>
> Something like the attached patch.
>
> WGH, do you build your own kernels? Does this attached (untested)
> patch make things work for you? It should give a big warning, but let
> the old behavior through..

The patch works for me.

However, there's no text messsage in the kernel log, just a traceback. I
think that's because WARN_ONCE is supposed to take condition as a first
argument.
