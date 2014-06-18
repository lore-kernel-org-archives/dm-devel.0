From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH ] multipath: Fall back to getuid_callout if
 ID_SERIAL attribute is missing.
Date: Wed, 18 Jun 2014 08:18:00 +0200
Message-ID: <53A12F18.60300@suse.de>
References: <229730203dc540ef9cae7b665577519c@hioexcmbx01-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <229730203dc540ef9cae7b665577519c@hioexcmbx01-prd.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/18/2014 02:17 AM, Merla, ShivaKrishna wrote:
>   Sometimes whenever a path is added, scsi_id call during udev rule proce=
ssing
>   can fail and ID_SERIAL attribute will not be set. This causes multipath=
d to add
>   the path as orphan. We have seen several instances of this happening du=
ring
>   testing.
>
>        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid_attribute =3D=
 ID_SERIAL (config file default)
>        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: no ID_SERIAL attr=
ibute
>        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid =3D <empty> (=
udev)
>        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: no ID_SERIAL attr=
ibute
>        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid =3D <empty> (=
udev)
>        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: failed to get pat=
h uid
>        Jun 17 10:14:43 ictm-vader multipathd[474]: sda: orphan path, fail=
ed to add path
>
>   This patch handles this case by allowing to fall back to explict getuid=
_callout
>   incase if ID_SERIAL attribute is not set. This way support for deprecat=
ed
>   getuid_callout is not lost for older versions where ID_SERIAL attribute=
 is not
>   present but also serves good purpose in the scenario mentioned above.
>
> Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>

Hmm. I have a similar patch in my tree. Will be checking.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
