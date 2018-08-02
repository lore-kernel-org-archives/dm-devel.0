From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Thu, 2 Aug 2018 14:52:24 -0700
Message-ID: <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
 <93bff248-6897-4867-841b-2dace11597de@torlan.ru> <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru> <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: wgh@torlan.ru
Cc: Ilya Dryomov <idryomov@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 2, 2018 at 2:39 PM WGH <wgh@torlan.ru> wrote:
>
> I've just found one public report of this bug, though:
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=900442

Yeah, it does sound like we should fix this issue.

Ilya?

             Linus
