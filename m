From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
	block device is gone
Date: Wed, 31 Jul 2019 12:56:47 -0700
Message-ID: <CAPhsuW5zB=Kik4rq9YA-xBer7Z-h-23QV4WSCWe-jvhFgGc0Cw@mail.gmail.com>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
	<87zhkwl6ya.fsf@notabene.neil.brown.name>
	<6400083b-3cf3-cbc6-650a-c3ae6629b14c@canonical.com>
	<CAPhsuW69YrpHqBCOob2b5wzzWS9FM087sfe3iC0odX8kZWRwmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPhsuW69YrpHqBCOob2b5wzzWS9FM087sfe3iC0odX8kZWRwmA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: Neil F Brown <nfbrown@suse.com>, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On Wed, Jul 31, 2019 at 12:54 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Tue, Jul 30, 2019 at 5:31 AM Guilherme G. Piccoli
> <gpiccoli@canonical.com> wrote:
> >
> > On 29/07/2019 21:08, NeilBrown wrote:
> > >[...]
> > >> +    if (unlikely(test_bit(MD_BROKEN, &mddev->flags))) {
> > >> +            bio_io_error(bio);
> > >> +            return BLK_QC_T_NONE;
> > >> +    }
> > >
> > > I think this should only fail WRITE requests, not READ requests.
> > >
> > > Otherwise the patch is probably reasonable.
> > >
> > > NeilBrown
> >
> > Thanks for the feedback Neil! I thought about it; it seemed to me better
> > to deny/fail the reads instead of returning "wrong" reads, since a file
> > read in a raid0 will be incomplete if one member is missing.
> > But it's fine for me to change that in the next iteration of this patch.
>
> For reads at block/page level, we will either get EIO or valid data, right?
>
> If that's not the case, we should fail all writes.

Oops, I meant all _reads_.

>
> Thanks,
> Song
