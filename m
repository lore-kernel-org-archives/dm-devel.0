From: David Michael <fedora.dm0@gmail.com>
Subject: Re: Making udev aware of dm-init devices
Date: Tue, 5 Nov 2019 12:47:54 -0500
Message-ID: <CAEvUa7n9HTc=4is6ESTWR8S1jzjGisSv_tGcVX7_O_QoYGSUCg@mail.gmail.com>
References: <CAEvUa7nAYkrdsPhmQpV_ChP5Jtnn9oR2Xb=KmBbXJyTZpGUAzg@mail.gmail.com>
	<20191105170445.GA22109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191105170445.GA22109@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 5, 2019 at 12:04 PM Mike Snitzer <snitzer@redhat.com> wrote:
> On Mon, Nov 04 2019 at 10:43am -0500,
> David Michael <fedora.dm0@gmail.com> wrote:
>
> > Hi,
> >
> > I would like to be able to use a root device configured by
> > dm-mod.create with an initrd in some scenarios, but it appears that
> > the default udev rules do not recognize this setup which prevents
> > systemd from mounting the root file system.  There is a systemd bug
> > report with a demo script to illustrate what I mean.[1]  Has anyone
> > here encountered this, or is there a solution already?
>
> Why do you want this?  dm-mod.create and initrd are mutually
> exclussive... that was/is the point.

I am using the same image building process for custom systems with
dm-init etc. built into the kernel and for Fedora-based systems, which
require an initrd to load the device mapper kernel modules as well as
NVMe support so it can find the devices in the first place.  I'd
prefer to be uniform and use dm-mod.create everywhere rather than
bundle the configuration into an initrd for certain distros (or be
uniform by creating initrds for my custom builds that don't otherwise
need one).

As mentioned in the systemd bug, dm-mod.create works correctly with an
initrd aside from udev needing to be manually triggered before systemd
can use it.  I was looking for suggestions for how this could be
handled upstream ideally so I don't have to customize an initrd to add
a udevadm trigger.

Thanks.

David
