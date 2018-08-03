From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] LVM snapshot broke between 4.14 and 4.16
Date: Fri, 3 Aug 2018 22:26:38 +0100
Message-ID: <20180803212638.GC31444@agk-dp.fab.redhat.com>
References: <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com> <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com> <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru> <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru> <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com> <20180803133102.GA3092@redhat.com> <20180803152034.GD32066@thunk.org> <20180803195636.GA31444@agk-dp.fab.redhat.com> <20180803200817.GB31444@agk-dp.fab.redhat.com> <CA+55aFyFXxN3Qkt+=Ke5Mqctbc3+iX5_HzeH0gHFZK8tDpa=Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyFXxN3Qkt+=Ke5Mqctbc3+iX5_HzeH0gHFZK8tDpa=Uw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 03, 2018 at 01:42:52PM -0700, Linus Torvalds wrote:
> So even in case 2, we do try to avoid versioning. More often we add a
> new flag, and say "hey, if you want the new behavior, use the new flag
> to say so". Not versioning, but explicit "I want the new behavior"
 
There are spare flags available in dm-ioctl - one could indeed turn on 
the new more-restrictive behaviour.

Alasdair
