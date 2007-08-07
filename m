From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Fixup kpartx rules for dmraid
Date: Tue, 07 Aug 2007 08:06:47 +0200
Message-ID: <46B80BF7.1010904@suse.de>
References: <46B70473.2030406@suse.de> <20070806184554.GA4415@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070806184554.GA4415@bogon.ms20.nix>
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
Cc: christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Guido Guenther wrote:
> On Mon, Aug 06, 2007 at 01:22:27PM +0200, Hannes Reinecke wrote:
>> -ENV{DM_UUID}=3D=3D"?*", IMPORT{program}=3D=3D"/lib/udev/kpartx_id %M =
%m $env{DM_UUID}"
>> +ENV{DM_UUID}=3D=3D"?*", IMPORT{program}=3D=3D"kpartx_id %M %m $env{DM=
_UUID}"
> /lib/udev/kpartx_id isn't in $PATH. This patch breaks the udev rule.

And /lib/udev is the standard path prefix since udev-0.89.

So?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
