From: Hannes Reinecke <hare@suse.de>
Subject: multipath and READ_CAPACITY
Date: Thu, 24 Jul 2014 10:46:31 +0200
Message-ID: <53D0C7E7.6090806@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

Hi Christophe,

I've had a customer issue where someone complained that multipath =

would reject paths if they are in ALUA 'standby'.
As it turns out, SPC-3 does _not_ require the READ_CAPACITY command =

to be implemented if a target port is in standby.
Consecutively, linux would register this path with a capacity of =

'0', and multipath would reject the path in ev_add_path().

Which makes we wonder, do we actually _need_ the check for a matched =

capacity?
With VPD page 0x83 pretty much standard as of now (and I'm reasonbly =

sure we'll reject any device _not_ providing VPD page 0x83 anyway) =

we basically have to rely on that information.
IE if the WWID is identical we have assume the devices are =

identical. So it would make sense to just remove the check altogether.

Thoughts?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
