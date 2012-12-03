From: Guangliang Zhao <gzhao@suse.com>
Subject: Re: [dm-devel] [PATCH 2/3] dm raid1: add interface to set resync
 speed
Date: Mon, 3 Dec 2012 17:12:42 +0800
Message-ID: <20121203091242.GA2314@glzhao-laptop.site>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
 <1353565673-4233-3-git-send-email-gzhao@suse.com>
 <20121130113928.GO29064@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121130113928.GO29064@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
Cc: Lars Marowsky-Bree <lmb@suse.com>
List-Id: dm-devel.ids

On Fri, Nov 30, 2012 at 12:39:28PM +0100, Lars Marowsky-Bree wrote:
> On 2012-11-22T14:27:52, Guangliang Zhao <gzhao@suse.com> wrote:
>=20
> Hi Guangliang,
>=20
> thanks for adding this. I think this approach is a good direction to
> take, just one feedback:
>=20
> > Add ioctl to control resync speed, userspace tool
> > is dmsetup message, message format is:
> > 	dmsetup message $device 0 "set $speed"
> > e.g.
> > 	dmsetup message /dev/dm-2 "set 12345"
>=20
> I think this should be "set-max-resync-rate" or something; "set" is v=
ery
> generic and not very extensible going forward, should the need arise.
That's would be more clear, thanks.

>=20
> Regards,
>     Lars
>=20
> --=20
> Architect Storage/HA
> SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=
=B6rffer, HRB 21284 (AG N=C3=BCrnberg)
> "Experience is the name everyone gives to their mistakes." -- Oscar W=
ilde
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=20
Best regards,
Guangliang
