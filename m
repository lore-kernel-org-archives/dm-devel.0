From: Hannes Reinecke <hare@suse.de>
Subject: Re: different LUN numbers under the same dm device
Date: Mon, 11 Jun 2012 08:38:20 +0200
Message-ID: <4FD5925C.1070305@suse.de>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
	<20120606203507.GC16432@redhat.com>
	<A1C07741-D139-45F5-A877-A5E5DC792AD3@purestorage.com>
	<20120607223954.GC3211@ether.msp.redhat.com>
	<F6378CE3-200B-4AF4-97BC-B3A310231420@purestorage.com>
	<4FD1A2BF.2090109@suse.de> <4FD1AF59.3040101@cs.wisc.edu>
	<F9D694F1-5E66-4B09-AF2B-DA2F56CAC492@purestorage.com>
	<4FD230C4.1000702@cs.wisc.edu>
	<EA0F3E77-2BD1-40E3-BCCD-B5C6E50BE321@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <EA0F3E77-2BD1-40E3-BCCD-B5C6E50BE321@purestorage.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/08/2012 07:18 PM, Brian Bunker wrote:
> Mike and all,
> =

> Thanks for the information. I think that everyone is on the same page now.
> The problem comes up for us because we have mostly automated tools
processing
> this output and they choked when they saw 4 paths even though as
Hannes
> pointed out 2 are faulty. We changed the automated scripts to look
at the
> state as well so we will get past this. We were mostly curious why
we only
> see this occasionally and on some dm devices. I will also change the
> rescanning mechanism to use 'rescan-scsi-bus.sh'. I think that we
should
> use both -r and -i right so that we send a LIP to the FC target?
>
Gnaa. I should have never implemented the '-i' option in the first
place. '-i' is just a horrible hack for misbehaving SANs.
FC arrays should detect any change in the port mapping themselves,
either via RSCNs or if a LIP reset occured.
During normal operation LIP should _not_ be necessary; in fact, I
would consider it a bug if you do.

> I think that our current rescan behavior was just to go the =

> /sys/class/fc_host/hostX and echo 1 to issue_lip. To answer all the
> questions, yes LUN 10 and LUN 12 did point to the same data LUN on the
> array not two different ones. If we ever shared NAA numbers for
different
> LUN's on the array itself we would have a big problem and would see
> corruption everywhere.
> =

Close, but not banana. 'issue_lip' is in fact a nasty method of
invoking a scan, it basically amounts to a card reset.

The 'correct' way would be to do a

echo '- - -' > /sys/class/fc_host/hostX/scan

and then remove all devices for which sg_tur / sg_inq returns an
error code.
Which is what rescan-scsi-bus.sh -r does.

But occasionally you're indeed better off by coding it by hand.
I know rescan-scsi-bus.sh far too well to recommend it to each and
sundry :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
