From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipathd removing DM devices that don't belong to
 it
Date: Mon, 27 Jul 2015 11:12:34 +0200
Message-ID: <55B5F602.1020206@suse.de>
References: <DM2PR11MB0335ECB1EAC777CF47163BEED5810@DM2PR11MB0335.namprd11.prod.outlook.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DM2PR11MB0335ECB1EAC777CF47163BEED5810@DM2PR11MB0335.namprd11.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/24/2015 07:53 PM, Artem Danielov wrote:
> Hi,
> =

> Any chance you guys have looked into this problem? Thank you!
> =

>  =

> =

> *From:* Artem Danielov
> *Sent:* Tuesday, June 16, 2015 15:02
> *To:* 'dm-devel@redhat.com'
> *Subject:* multipathd removing DM devices that don't belong to it
> =

>  =

> =

> Hello,
> =

> Looking for an advice on whether this is an expected behavior or a bug.
> =

> device-mapper-multipath-0.4.9-77.el7.x86_64
> =

>  =

> =

> When multipathd service starts it will remove any DM devices with
> multipath target, _even if the underlying devices are blacklisted_.
> =

> We are trying to use dmsetup directly  to implement custom multipath
> management logic separate from multipathd. But unfortunately if
> multipathd is present and enabled it removes DM devices with
> multipath target that we create.
> =

Well, hardly surprising.
ATM multipathd expects to be the only one creating multipath tables,
so of course it would try to 'rectify' the situation.

What one could try is to use a different UUID prefix (ie something
else than 'mpath') and then teach multipath to ignore all
device-mapper devices of type 'multipath' but without the 'mpath'
UUID prefix.

>  =

> =

> Is this a bug?
> =

Not as such.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
