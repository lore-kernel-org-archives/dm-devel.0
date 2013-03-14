From: Hannes Reinecke <hare@suse.de>
Subject: Re: Can DM-Multipath work on non-SCSI block device
Date: Thu, 14 Mar 2013 10:29:24 +0100
Message-ID: <51419874.50308@suse.de>
References: <CAKNWCPZGKuA=TGOm3_Wzq+vwFc75W-1yviLuMwvX85st5Y-i=A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKNWCPZGKuA=TGOm3_Wzq+vwFc75W-1yviLuMwvX85st5Y-i=A@mail.gmail.com>
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

On 03/14/2013 08:58 AM, Ahmed Al-Mehdi wrote:
> Hello,
>
> I read the documentation on the dm-multipath home page:
> htttp://christophe.varoqui.free.fr/refbook.html
> <http://christophe.varoqui.free.fr/refbook.html> , that describes
> how the userspace multipath tool detects and maps (scsi) devices.
> However, would like to confirm, does the dm-multipath utilty only
> work with SCSI devices.  Is there any option to make it (or fake it)
> to work with non-SCSI  block device.
>
If you can figure out a way on how to get a unique _disk_ id without =

SCSI, sure.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
