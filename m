From: Christophe Saout <christophe@saout.de>
Subject: Re: Block regression since 3.1-rc3
Date: Sun, 09 Oct 2011 15:47:06 +0200
Message-ID: <1318168026.24616.5.camel@localhost>
References: <1317397918.27140.15.camel@localhost>
	 <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	 <1317729761.25998.4.camel@localhost>
	 <x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	 <CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
	 <20111008161421.GA5743@redhat.com>
	 <CANejiEXzPp4TvLsZ0VXN9EicMgkHXfkhpLcuXzVvoEH5MJfQuQ@mail.gmail.com>
	 <CANejiEV+Joc7qvWr1DF4cOR61GKy8MLX4TT4oWh7pxMkhb74Qg@mail.gmail.com>
	 <1318147923.22902.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1318147923.22902.3.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Jens@redhat.com, device-mapper@redhat.com, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

Hello again,

> Also for the record: Jeff's patch causes other crashes on my machine
> (already posted), so while it might be fine from a technical point of
> view, it still has issues in its current form. Jeff is working on it.

I have to apologize.  Looks like I made a mistake the first time I tried
Jeff's patch.  Shaohua asked me to check again and this time the box
runs nicely.  I probably forgot something stupid like a modules_install.

The patch that Jeff posted is actually working.  Mea culpa.  Sorry for
the fuzz!

Thanks,
	Christophe
