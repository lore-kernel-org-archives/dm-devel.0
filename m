From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/13] multipathd: no_map_shutdown option
Date: Fri, 22 Nov 2013 11:04:17 +0100
Message-ID: <528F2C21.1000005@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>	<1384511384-27642-14-git-send-email-hare@suse.de>	<20131121231710.GL1661@dhcp80-209.msp.redhat.com>	<528F2004.2050101@suse.de>
	<CABr-GncbrpsL5VLvHh+V0e714KguJrJEuRGfihrcq+1Wbs568w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GncbrpsL5VLvHh+V0e714KguJrJEuRGfihrcq+1Wbs568w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/22/2013 10:30 AM, Christophe Varoqui wrote:
> Hi,
> =

> To my knowledge, systemd has not been integrated in all distributions.
> It would be nice not to break the build of multipath-tools on those
> environments.
> =

> The current patchset breaks the build on non-systemd systems as soon
> as patch 06/13.
> I can apply the patchset from 01/13 to 05/13 included, and let you
> refactor the systemd integration proper in a new series.
> =

> Is that ok with you ?
> =

Yes, of course.

I'll be reworking the remaining patches to make systemd optional.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
