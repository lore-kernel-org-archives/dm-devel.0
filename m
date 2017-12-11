From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: dm: fix uninitialized variable reference
Date: Mon, 11 Dec 2017 16:50:56 +0100
Message-ID: <CAK8P3a3118k4bn4jw-KZ57yK5HyE+ozXRTSBX06bBYkxfN9jjg@mail.gmail.com>
References: <20171211113358.3599287-1-arnd@arndb.de> <20171211135015.GA22786@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171211135015.GA22786@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bart.vanassche@wdc.com>, NeilBrown <neilb@suse.com>, Mikulas Patocka <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Damien Le Moal <damien.lemoal@wdc.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Dec 11, 2017 at 2:50 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Mon, Dec 11 2017 at  6:33am -0500,
> Arnd Bergmann <arnd@arndb.de> wrote:
>>
>
> Already resolved this thanks to Stephen Rothwell's earlier
> (substantially more discrete) mail.
>
> I always enjoy a good public shaming but this cc list is particularly
> wide.  Why?

;-)

Sorry about that, I just used the defaults that
scripts/get_maintainer.pl offered,
which is often easier than coming up with a smaller distribution list. You are
right this was a lot more than necessary in this case.

> Anyway, I resolved this differently:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=496cc64f4d10ba112aa0679a3bf29ae6ea74ff3d

Ok, thanks!

      Arnd
