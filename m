From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 12:36:15 -0700
Message-ID: <CA+55aFzPDchiWn0sxPjO-ha1o4nYuHnE0YD+rG9LoSe4+Lt1OA@mail.gmail.com>
References: <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
 <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru> <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com> <CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
 <20180803185431.GB3258@redhat.com> <CA+55aFwDEY7B6OMh5xL2wc8BRj1KkzBHggNowAjbsWfma6H5Zg@mail.gmail.com>
 <20180803193037.GA4581@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180803193037.GA4581@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Zdenek Kabelac <zkabelac@redhat.com>, wgh@torlan.ru, Ilya Dryomov <idryomov@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 3, 2018 at 12:30 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> I was trying to give context for the "best to update lvm2 anyway"
> disclaimer that was used.  Yeah, it was specious.

So I'll apologize for the strong words, and I'll just say - not
excuse, but explanation - that this is the *ONE* thing that continues
to drive me absolutely bat-shit insane.

It's the *ONE* thing I will refuse to even discuss. Pretty much any
technical thing, I'll happily discuss, and I'll admit when I was
completely wrong and a f*cking moron.

Hey, it happens.

But the "no regressions" thing is _so_ important to me, and _so_
frustrating when I get the feeling that people ignore it, that I just
go ballistic.

I'm sorry for going ballistic, but there it is. It keeps happening
every once in a while. I thought we'd gotten mostly over it.

                Linus
