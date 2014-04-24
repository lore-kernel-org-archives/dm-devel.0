From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [Gluster-devel] Puppet-Gluster+ThinP
Date: Thu, 24 Apr 2014 14:03:57 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404241346430.2121@localhost.localdomain>
References: <1397056420.4190.93.camel@freed>
	<1420171478.1325442.1397081884591.JavaMail.zimbra@redhat.com>
	<53545F62.8060001@redhat.com>
	<CADCaTgogBwyr9iYPV_oAAXFD=JKNqvm=PeJAwmqLJ_ksUn1Psw@mail.gmail.com>
	<535469F9.7050605@redhat.com>
	<CADCaTgoDKyhvL5z-voJFSKgmWRie1nnRxh2y9ohsKfp2S8ZrbQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CADCaTgoDKyhvL5z-voJFSKgmWRie1nnRxh2y9ohsKfp2S8ZrbQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James <purpleidea@gmail.com>
Cc: Paul Cuzner <pcuzner@redhat.com>, device-mapper development <dm-devel@redhat.com>, Ric Wheeler <rwheeler@redhat.com>, Gluster Devel <gluster-devel@nongnu.org>
List-Id: dm-devel.ids

On Thu, 24 Apr 2014, James wrote:

> Date: Thu, 24 Apr 2014 01:59:21 -0400
> From: James <purpleidea@gmail.com>
> To: Ric Wheeler <rwheeler@redhat.com>
> Cc: Paul Cuzner <pcuzner@redhat.com>,
>     Gluster Devel <gluster-devel@nongnu.org>,
>     device-mapper development <dm-devel@redhat.com>,
>     Lukas Czerner <lczerner@redhat.com>
> Subject: Re: [Gluster-devel] Puppet-Gluster+ThinP
> 
> On Sun, Apr 20, 2014 at 8:44 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> > On 04/20/2014 05:11 PM, James wrote:
> >>
> >> On Sun, Apr 20, 2014 at 7:59 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> >>>
> >>> The amount of space you set aside is very much workload dependent (rate
> >>> of
> >>> change, rate of deletion, rate of notifying the storage about the freed
> >>> space).
> >>
> >>  From the Puppet-Gluster perspective, this will be configurable. I
> >> would like to set a vaguely sensible default though, which I don't
> >> have at the moment.
> >
> >
> > This will require a bit of thinking as you have noticed, but let's start
> > with some definitions.
> >
> > The basic use case is one file system backed by an exclusive dm-thinp target
> > (no other file system writing to that dm-thinp pool or contending for
> > allocation).
> >
> > The goal is to get an alert in time to intervene before things get ugly, so
> > we are hoping to get a sense of rate of change in the file system and how
> > long any snapshot will be retained for.
> >
> > For example, if we have a 10TB file system (presented as such to the user)
> > and we write say 500GB of new data/day, daily snapshots will need that space
> > for as long as we retain them.  If you write much less (5GB/day), it will
> > clearly take a lot less.
> >
> > The above makes this all an effort to predict the future, but that is where
> > the watermark alert kicks in to help us recover from a bad prediction.
> >
> > Maybe we use a default of setting aside 20% of raw capacity for snapshots
> > and set that watermark at 90% full?  For a lot of use people, I suspect a
> > fairly low rate of change and that means pretty skinny snapshots.
> >
> > We will clearly need to have a lot of effort here in helping explain this to
> > users so they can make the trade off for their particular use case.
> >
> >
> >>
> >>> Keep in mind with snapshots (and thinly provisioned storage, whether
> >>> using a
> >>> software target or thinly provisioned array) we need to issue the
> >>> "discard"
> >>> commands down the IO stack in order to let the storage target reclaim
> >>> space.
> >>>
> >>> That typically means running the fstrim command on the local file system
> >>> (XFS, ext4, btrfs, etc) every so often. Less typically, you can mount
> >>> your
> >>> local file system with "-o discard" to do it inband (but that comes at a
> >>> performance penalty usually).
> >>
> >> Do you think it would make sense to have Puppet-Gluster add a cron job
> >> to do this operation?
> >> Exactly what command should run, and how often? (Again for having
> >> sensible defaults.)
> >
> >
> > I think that we should probably run fstrim once a day or so (hopefully late
> > at night or off peak)?  Adding in Lukas who lead a lot of the discard work.
> 
> I decided I'd kick off this party by writing a patch, and opening a
> bug against my own product (is it cool to do that?)
> Bug is: https://bugzilla.redhat.com/show_bug.cgi?id=1090757
> Patch is: https://github.com/purpleidea/puppet-gluster/commit/1444914fe5988cc285cd572e3ed1042365d58efd
> Please comment on the bug if you have any advice or recommendations
> about fstrim.

This is a good workaround (assuming that ${valid_path} is a
mountpoint of the file system on top of the thinp), but eventually I think
it would be great if this could be done automatically on the lower level.

There is already some effort from lvm2 team

https://bugzilla.redhat.com/show_bug.cgi?id=824900

But I think that best solution would be if they would fire off fstrim
on the file system when they hit watermark on the pool. This could
be done via their own dmeventd daemon.

They already have policy where dmeventd is watching thinp pool
utilization and at certain thresholds firing off lvm commands to
possibly extend the pool based on the lvm.conf settings. So I think
this is the right way to put this functionality.

But that needs to be discussed with lvm2 people.

Thanks!
-Lukas

> 
> Thanks!
> 
> >
> >
> >>
> >>> There is also a event mechanism to help us get notified when we hit a
> >>> target
> >>> configurable watermark ("help, we are running short on real disk, add
> >>> more
> >>> or clean up!").
> >>
> >> Can you point me to some docs about this feature?
> >
> >
> > My quick google search only shows my own very shallow talk slides, so let me
> > dig around for something better :)
> >
> >
> >>
> >>> Definitely worth following up with the LVM/device mapper people on how to
> >>> do
> >>> this best,
> >>>
> >>> Ric
> >>
> >> Thanks for the comments. From everyone I've talked to, it seems some
> >> of the answers are still in progress. The good news is, that I'm ahead
> >> of the curve for being ready for when this becomes more mainstream. I
> >> think Paul is in the same position too.
> >>
> >> James
> >
> >
> > This is all new stuff - even not with gluster on top of it - so this will
> > mean hitting a few bumps I fear.  Definitely worth putting thought into this
> > now and working on the documentation,
> >
> > Ric
> >
> 
