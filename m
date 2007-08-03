From: Hannes Reinecke <hare@suse.de>
Subject: Re: [ANNOUNCE] multipath-tools-0.4.8
Date: Fri, 03 Aug 2007 08:21:42 +0200
Message-ID: <46B2C976.1070809@suse.de>
References: <1186093625.20108.69.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1186093625.20108.69.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

Christophe Varoqui wrote:
> Hello,
>=20
> here goes multipath-tools-0.4.8.
>=20
> Well, a year after the last release, let's see what changed in the
> multipath tools package.
>=20
And of course, what would be a release without fixes ...
I've found two bugs in that release already ;-)

- kpartx miscalculates the size of the device-mapper table
  for an extended partition
- kpartx udev rules do not generate persistent links for
  dmraid devices

I'll send those patches with separate mails.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
