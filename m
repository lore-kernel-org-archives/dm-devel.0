From: Hannes Reinecke <hare@suse.de>
Subject: Re: different LUN numbers under the same dm device
Date: Fri, 08 Jun 2012 08:59:11 +0200
Message-ID: <4FD1A2BF.2090109@suse.de>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
	<20120606203507.GC16432@redhat.com>
	<A1C07741-D139-45F5-A877-A5E5DC792AD3@purestorage.com>
	<20120607223954.GC3211@ether.msp.redhat.com>
	<F6378CE3-200B-4AF4-97BC-B3A310231420@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F6378CE3-200B-4AF4-97BC-B3A310231420@purestorage.com>
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

(Third mail on this topic .. I really should've read the entire
thread before answering. But there you go.)

On 06/08/2012 01:26 AM, Brian Bunker wrote:
> The answer is yes they did have that LUN NAA value that comes from page c=
ode 0x83 in inquiry.
> Then the LUN was unmasked from that initiator. That initiator is
holding on to those device
> names in multipath. If you query them when they are in the state
that I show in the
> multipath -ll result, they will not return an NAA number at all in
page code 0x83 or
> a serial number in page code 0x80. They will instead return a PQ
of 1 meaning that the
> LUN is capable of supporting a peripheral device but is not currently.
> =

Hehe.

> I understand about LUN's needing different NAA numbers and ours do, and w=
e also have
> different LUN serial numbers for each LUN on the target. An
initiator doesn't always
> have to access to all LUN's that it once did. It is the re-use of
dm devices that
> seems to cause this result.
> =

No, rather a problem with the SCSI stack. multipath normally relies
on udev to keep track of any device events, like LUNs coming and
going. But this only works reliably if these events are triggered
via the underlying transport, like FC RSCN et al.

'Real' scsi events which will get transmitted via Sense codes are
not evaluated further, sadly.

So short-term you are supposed to call 'rescan-scsi-bus.sh -r'
whenever you made any LUN assigment changes on the array.
Mid-term we already agreed on implementing some proper sense code
handling in the SCSI midlayer.
However, as usual in these cases, real life interfered and I've been
busy with other things.
But it's definitely on the agenda.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
