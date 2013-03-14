From: Hannes Reinecke <hare@suse.de>
Subject: Re: Can DM-Multipath work on non-SCSI block device
Date: Thu, 14 Mar 2013 11:44:03 +0100
Message-ID: <5141A9F3.90801@suse.de>
References: <CAKNWCPZGKuA=TGOm3_Wzq+vwFc75W-1yviLuMwvX85st5Y-i=A@mail.gmail.com>
	<51419874.50308@suse.de> <5141A948.3010403@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5141A948.3010403@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/14/2013 11:41 AM, Bryn M. Reeves wrote:
> On 03/14/2013 09:29 AM, Hannes Reinecke wrote:
>> On 03/14/2013 08:58 AM, Ahmed Al-Mehdi wrote:
>>> Hello,
>>>
>>> I read the documentation on the dm-multipath home page:
>>> htttp://christophe.varoqui.free.fr/refbook.html
>>> <http://christophe.varoqui.free.fr/refbook.html> , that describes
>>> how the userspace multipath tool detects and maps (scsi) devices.
>>> However, would like to confirm, does the dm-multipath utilty only
>>> work with SCSI devices.  Is there any option to make it (or fake it)
>>> to work with non-SCSI  block device.
>>>
>> If you can figure out a way on how to get a unique _disk_ id without
>> SCSI, sure.
>
> E.g. cciss devices are supported using the cciss_id program - that's
> a good example of a very "non-scsi" device type working with multipath.
>
> As well as the WWID problem you'll need to come up with some scheme
> for faking unique HCIL values for the devices since multipath
> userspace cares about that. The cciss approach is to force lun and
> channel to '0' for all devices and to use the CCISS controller (cN)
> and disk (dN) values for the host and id (aka target) values.
>
> See the functions in discovery.c with a cciss_ prefix for more
> examples.
>
Or the dasd variant of those.

However, the HCIL variable is mostly cosmetic.
The disk id is the true issue; without it you cannot do multipathing.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
