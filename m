From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: make alloc error info more clearly.
Date: Mon, 8 Jul 2013 06:39:52 -0400
Message-ID: <20130708103951.GB6853@redhat.com>
References: <1373180926-29264-1-git-send-email-robin.k.dong@gmail.com>
	<20130707093119.GB13191@agk-dp.fab.redhat.com>
	<CANsebLFx6vAYZuvQULb62fdLZPbDwtF9Ru9dRsW89DHmk2n_0w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CANsebLFx6vAYZuvQULb62fdLZPbDwtF9Ru9dRsW89DHmk2n_0w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Robin Dong <robin.k.dong@gmail.com>
Cc: dm-devel@redhat.com, Robin Dong <sanbai@taobao.com>
List-Id: dm-devel.ids

On Sun, Jul 07 2013 at  8:29am -0400,
Robin Dong <robin.k.dong@gmail.com> wrote:

> 2013/7/7 Alasdair G Kergon <agk@redhat.com>
> >
> > On Sun, Jul 07, 2013 at 03:08:46PM +0800, Robin Dong wrote:
> > > If dm-delay structure allocation failed, report more precise error
> information.
> >
> > Do you have some test result that shows this?
> >
> >   DMERR("%s: %s: %s", dm_device_name(t->md), type, tgt->error);
> >
> > ?
> 
> Oh, sorry for my omission.
> But I stil think that print "Cannot allocate linear context" in dm-flakey
> is puzzling...

Yeah, that should get fixed up (with s/linear //), clearly got
introduced via cut and paste.
