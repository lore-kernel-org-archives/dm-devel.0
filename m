From: Hannes Reinecke <hare@suse.de>
Subject: Re: Priozier for remote port on fibre channel devices
Date: Fri, 11 Jan 2013 09:42:49 +0100
Message-ID: <50EFD089.9050606@suse.de>
References: <OF21470796.D356BC7E-ONC1257AF0.0022D29F-C1257AF0.00278317@continental-corporation.com>
	<50EFBDB0.5010004@suse.de>	<OF3C233FBC.B29A53C0-ONC1257AF0.002A1FF8-C1257AF0.002AC473@continental-corporation.com>
	<50EFC81F.1070209@suse.de>
	<OFE9A4507F.3E574BF0-ONC1257AF0.002D3A81-C1257AF0.002DAC1C@continental-corporation.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OFE9A4507F.3E574BF0-ONC1257AF0.002D3A81-C1257AF0.002DAC1C@continental-corporation.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 01/11/2013 09:18 AM, =

Andreas.Bleischwitz@continental-corporation.com wrote:
> Thanks for the hint, that will at least work for RHEL6+. For RHEL5 I
> will use the scripted version.
>
> The only downside on that is, that I will have a long line for the
> weightedpath regex definition as this has to be for each VPLEX-port.
> At least I will have reduced the need to write something on my own ;)
>
Or write you own udev rules to generate shorter names ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
