From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Disable partitions scan for multipathed
	devices
Date: Wed, 12 Mar 2014 13:27:55 +0100
Message-ID: <532052CB.2090605@suse.de>
References: <1394624936-118530-1-git-send-email-hare@suse.de>
	<20140312122310.GB14017@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140312122310.GB14017@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Peter Rajnoha <prajnoha@redhat.com>
List-Id: dm-devel.ids

On 03/12/2014 01:23 PM, Alasdair G Kergon wrote:
> On Wed, Mar 12, 2014 at 12:48:56PM +0100, Hannes Reinecke wrote:
>> For this I've implemented a new feature 'no_partitions' which
>> just serves as a notifier to kpartx to _not_ create partitions
>> on these devices.
>  =

> This should be covered by the existing cookie flags (which udev rules
> already use, if you're using udev).  It's not a multipath-specific
> problem but can apply to other targets too.
> =

Ah.

How? To my knowledge the 'cookies' mechanism is to enable
libdevmapper to wait until udev is done with device creation.

Can you elaborate here?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
