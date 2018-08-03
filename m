From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 15:33:50 -0400
Message-ID: <20180803193349.GB4581@redhat.com>
References: <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <20180803133102.GA3092@redhat.com>
 <20180803152034.GD32066@thunk.org>
 <20180803183932.GA3258@redhat.com>
 <CA+55aFwGGjs_imFFkEPJ4g99Kseam=4Qppv4G6Q=ZfZXdzF7Vw@mail.gmail.com>
 <20180803190617.GA4498@redhat.com>
 <CA+55aFy+j6fyvXxbZH8rnrqvSTQ=jFMOq-yu6Hmncf4fOiP=Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy+j6fyvXxbZH8rnrqvSTQ=jFMOq-yu6Hmncf4fOiP=Mw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 03 2018 at  3:11pm -0400,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Aug 3, 2018 at 12:06 PM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > But you're making Zdenek's response into mine and threathening to no
> > longer pull from me.
> 
> No. I'm *very* unhappy about how you seem to think that Zdenek's
> response was even half-way ok, and you jumped in when Ted said it
> wasn't.

I'm inclined not to make people who aren't kernel developers cry over
spilt milk.

But zero tolerance of kernel regressions is important.  And that mantra
wasn't properly impressed upon lvm2 developers.
