From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Allow zero paths for multipath priority groups
Date: Tue, 21 Jul 2009 16:46:59 +0200
Message-ID: <4A65D4E3.9050405@suse.de>
References: <200907081415.39925.knikanth@suse.de>
	<20090720203753.GG32330@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090720203753.GG32330@agk-dp.fab.redhat.com>
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
Cc: Nikanth Karthikesan <knikanth@suse.de>
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Wed, Jul 08, 2009 at 02:15:39PM +0530, Nikanth Karthikesan wrote:
>> From: Hannes Reinecke <hare@suse.de>
>> Subject: Allow zero paths for multipath priority groups
>>
>> For correct handling of the all-paths-down scenario we have to
>> allow zero paths as a valid argument for priority groups.
> =20
> That seems counter-intuitive.
> Can you be more specific, with example scenarios?
>=20
Currently we're not allowing the last path to be removed
from a multipath target. With earlier kernel revisions
this wasn't a problem as dev_loss_tmo didn't work correctly
and so in effect no devices were ever removed from the system.

However, with newer kernels dev_loss_tmo works correctly, so
any dead path will be removed from the system.
So when the last path goes down, we're having a stale reference
to an sdev which for all intents and purposes should have been
removed.

And even worse, when this path comes back the SCSI subsystem
isn't even able to assign it to the old device number, as this
is already taken.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
