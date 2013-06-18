From: Michael Fortson <mfortson@permabit.com>
Subject: Re: [dm-devel] Performance Comparison among EnhanceIO, bcache and dm-cache.
Date: Tue, 18 Jun 2013 12:30:20 -0400
Message-ID: <CADLFSker0ttaLhdmDF433vRoMjz=pP6-mHaHg5o8PMoM4oER_A@mail.gmail.com>
References: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
	<20130617102943.GA11121@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130617102943.GA11121@debian>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, OS Engineering <osengineering@stec-inc.com>, "koverstreet@google.com" <koverstreet@google.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Padmini Balasubramaniyan <padminib@stec-inc.com>, Amit Phansalkar <aphansalkar@stec-inc.com>
List-Id: dm-devel.ids

On Mon, Jun 17, 2013 at 6:29 AM, Joe Thornber <thornber@redhat.com> wrote:
> On Tue, Jun 11, 2013 at 03:05:07PM +0000, OS Engineering wrote:
>
> ...
>
>> Dm-cache commits on-disk metadata every time a REQ_SYNC or REQ_FUA
>> bio is written. If no such requests are made then it commits
>> metadata once every second. If power is lost, it may lose some
>> recent writes.
>
> Not true (though it is true for thinp, which may be where you got this
> idea?).  For caching we have to commit whenever data is moved about,
> otherwise a crash could result in us reading data that is not just out
> of date (acceptable for some), but used to belong to a totally
> different part of the device (always unacceptable).
>
> - Joe

(Apologies if this is received multiple times -- I forgot to disable
HTML the first time)

Hi Joe,

In Documentation/device-mapper/cache.txt, is this text out of date?

     On-disk metadata is committed every time a REQ_SYNC or REQ_FUA
     bio is written.  If no such requests are made then commits will
     occur every second.  This means the cache behaves like a physical
     disk that has a write cache (the same is true of the
     thin-provisioning target).  If power is lost you may lose some
     recent writes.  The metadata should always be consistent in spite
     of any crash.

You say that this is the case for thinp, however.  Does that mean that
it's not possible to get stable writes with dm-thin without using
cache-control commands?  I don't see any documentation to this effect.
 If so, are there any plans to change this behavior (or make it
configurable)?

Thanks,
-Michael
