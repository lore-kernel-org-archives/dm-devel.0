From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio
Date: Fri, 23 Mar 2012 10:21:33 -0400
Message-ID: <20120323142133.GF7220@redhat.com>
References: <CALLzPKZyOc+_Pjht8uR6AJOBsMFXQN=y5QWvD0_OZFaYJpvRig@mail.gmail.com>
	<4F6C5A1F.1000103@redhat.com>
	<CALLzPKb+xrQQ-+sOTY0-MHbfVDkgvY2TYqmpP0Mqi7XwD4iEDg@mail.gmail.com>
	<CALLzPKYkLXz0iZPwSbw268w1dkQtvjgoX19aVTK6cEAgt5L50g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALLzPKYkLXz0iZPwSbw268w1dkQtvjgoX19aVTK6cEAgt5L50g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, mpatocka@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Mar 23 2012 at 10:12am -0400,
Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> On Fri, Mar 23, 2012 at 1:26 PM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
> > On Fri, Mar 23, 2012 at 1:10 PM, Zdenek Kabelac <zkabelac@redhat.com> w=
rote:
> >> Dne 23.3.2012 12:01, Kasatkin, Dmitry napsal(a):
> >>> Hello,
> >>>
> >>> When using dm-bufio and dm-io in general, how to ensure that all dirty
> >>> buffers are written to the storage when machine reboots?
> >>> suspend hooks could be used, but they are not called on reboot, only
> >>> when suspending/removing the target...
> >>>
> >>
> >> You mean you reboot without running =A0'sync' command?
> >>
> >> And yes - on reboot you should properly unmount devices - so you should
> >> see removal of target on your shutdown sequence - =A0I believe Fedora =
currently
> >> tries to support switch to some shutdown ramdisk, so all filesystem and
> >> devices might be properly unmounted and destroyed.
> >>
> >
> > Hello,
> >
> > Thanks for response.
> > I use bufio to store some data on block device.
> > It is not mounted in anyway. My target just use it to load/store data.
> > When machine reboots, I want to be sure that bufio written all dirty bu=
ffers...
> >
> > - Dmitry
> >
> =

> At the moment, I have reboot notifier which does the following
> =

> 	dm_bufio_write_dirty_buffers(d->bufio);
> 	sync_blockdev(d->dev->bdev);
> 	blkdev_issue_flush(d->dev->bdev, GFP_KERNEL, NULL);
> =

> without first line on the next boot I got corrupted/not updated blocks.
> and I am not sure if I need last 2 lines...

Are you cleanly removing the target from the kernel before reboot
(e.g. dmsetup remove devname)?

As long as your target's .dtr is making sure to flush all outstanding IO
(like your reboot notifier does) you should be fine.
