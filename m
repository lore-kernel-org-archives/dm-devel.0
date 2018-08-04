From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 10:04:47 -0700
Message-ID: <CA+55aFza3_+poqmw34ev+a_jZ1Tz0rxjTu7YfnU4HX-SU52abQ@mail.gmail.com>
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
	<a5feeaa7-e043-3987-cf23-4090e3eeec4a@torlan.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a5feeaa7-e043-3987-cf23-4090e3eeec4a@torlan.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: wgh@torlan.ru
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
List-Id: dm-devel.ids

On Sat, Aug 4, 2018 at 3:03 AM WGH <wgh@torlan.ru> wrote:
>
> >
> The patch works for me.
>
> However, there's no text messsage in the kernel log, just a traceback. I
> think that's because WARN_ONCE is supposed to take condition as a first
> argument.

Duh.

It needs to be WARN_ONCE(1, ...);

I obviously didn't test that patch, but I _did_ compile it. I wonder
why I didn't get a compiler warning for it...

[ Goes off and looks ]

Oh, because the "bio_devname(bio, b)" argument ended up being
interpreted as the format string, and since it was a dynamic string
the compiler felt it was all fine. Just bad luck.

Anyway, just out of curiosity, what was the traceback?

I'm not entirely happy with that patch either (even after the obvious
fix to add the "1" argument), but it does seem like the minimal
temporary workaround for now.

              Linus
