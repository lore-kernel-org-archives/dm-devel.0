From: Hannes Reinecke <hare@suse.de>
Subject: Re: kernel crash with multipath-tools v0.4.7
Date: Thu, 13 Jun 2013 10:25:54 +0200
Message-ID: <51B98212.3070903@suse.de>
References: <975E8BE292621F4CA5B67883EB72497A03C2597E@nonamew.ptu.promise.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <975E8BE292621F4CA5B67883EB72497A03C2597E@nonamew.ptu.promise.com>
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
Cc: Mohan Rowlands - PTU <mohanr@promise.com>, Manoj Mathew - PTU <manojm@promise.com>, Praveen Dhanasekaran - PTI <praveend@promise.com>, Nagendra Vadlakunta - PTU <nagendra.vadlakunta@promise.com>
List-Id: dm-devel.ids

On 06/12/2013 01:03 PM, Praveen Dhanasekaran - PTI wrote:
> Hello All,
>  =

> I have a RAID storage box connected to a Linux server through fc
> cables. The server is using
> kernel 2.6.26, and multipath-tools v0.4.7 (with dm-mpath target
> version 1.0.5) is installed on it
> to handle the disk scsi devices from the storage box. The multipath
> device is mounted and
> used for a file system.
>  =

This kernel is ancient, and there were several fixes for the SCSI
layer to fixup these issues.
Update the kernel or talk to your linux distributor.

(I know of one who'd be happy to help you out :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
