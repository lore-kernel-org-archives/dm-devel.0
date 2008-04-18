From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Notice] multipath-tools changes upstream
Date: Fri, 18 Apr 2008 16:45:59 +0200
Message-ID: <4808B427.1000209@suse.de>
References: <1208278929.11770.62.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1208278929.11770.62.camel@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

Hi Christophe,

Christophe Varoqui wrote:
> Hi,
>=20
> please take notice I updated the upstream git tree for the
> multipath-tools project. This tree includes lots of code shuffling :
>=20
> 1) prioritizers as dlopen'ed shared libs (/lib/libmultipath/libprio*.so=
)
> 2) checkers as dlopen'ed shared libs (/lib/libmultipath/libcheck*.so)
Maybe /lib/multipath is more appropriate; eventually something more might
be stored in there.

>=20
> Consequences :
> The multipath tool is about to get shot for good
About time :-)
But: how do I get the topology output?
I hope not via the 'multipathd -k' option?
Maybe we should just have it symlinked to multipathd
and print out the appropriate output ...

> The klibc build is gone
Even better.

Oh, and I do have some fixes queued which I need to polish up
and post here. Just as a reminder if you thought of doing
a release or somesuch ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
