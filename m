From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/3] block: add QUEUE_FLAG_DAX for devices to
 advertise their DAX support
Date: Thu, 23 Jun 2016 17:11:32 -0400
Message-ID: <20160623211131.GA9163@redhat.com>
References: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
 <1466639694-25394-2-git-send-email-toshi.kani@hpe.com>
 <CACTTzNYAxtY-d8+8Vo=Y2WpuXVaSkJk9PC7DcHXKJuU=gqvXFw@mail.gmail.com>
 <1466702773.3504.363.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466702773.3504.363.camel@hpe.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "yigal@plexistor.com" <yigal@plexistor.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 23 2016 at  1:36pm -0400,
Kani, Toshimitsu <toshi.kani@hpe.com> wrote:

> On Thu, 2016-06-23 at 19:31 +0300, Yigal Korman wrote:
> > On Thu, Jun 23, 2016 at 2:54 AM, Toshi Kani <toshi.kani@hpe.com> wr=
ote:
> > >=20
> > >=20
> > > Currently, presence of direct_access() in block_device_operations
> > > indicates support of DAX on its block device.=A0=A0Because
> > > block_device_operations is instantiated with 'const', this DAX
> > > capablity may not be enabled conditinally.
> > >=20
> > > In preparation for supporting DAX to device-mapper devices, add
> > > QUEUE_FLAG_DAX to request_queue flags to advertise their DAX
> > > support.=A0=A0This will allow to set the DAX capability based on =
how
> > > mapped device is composed.
> >=20
> > Hi Toshi,
> > This patch is very helpful!
> > I think QUEUE_FLAG_DAX can also help with identifying dax devices i=
n
> > userspace.
> > Perhaps you'd be willing to squash the patch below with this one or
> > add it to your submission?
>=20
> Hi Yigal,
>=20
> Good idea. =A0Mike can probably take it into his tree, but I will inc=
lude it
> into the series if I needed to submit v3.
>=20
> Acked-by: Toshi Kani <toshi.kani@hpe.com>

As you can see I sent out v3 of this set.  Jens will need to pick up th=
e
"block:" patches but I'll pick up the DM patches once Jens does so.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
