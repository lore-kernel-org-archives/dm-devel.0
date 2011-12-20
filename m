From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC][PATCH 0/3] persistent management feature for
 multipath-tools
Date: Tue, 20 Dec 2011 16:33:28 +0100
Message-ID: <4EF0AAC8.3010109@suse.de>
References: <EE2129A8E578DC4E94D643D6C1C1C67D078966CE@BTCMVEXC2-PRD.hq.netapp.com>
	<1324332972.4565.46.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1324332972.4565.46.camel@lapoo.opensvc.com>
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

On 12/19/2011 11:16 PM, Christophe Varoqui wrote:
> On lun., 2011-12-19 at 22:04 +0530, Chauhan, Vijay wrote:
>> PERSISTENT RESERVE OUT/IN commands are currently not supported on mpath =
device. Any command sent to mpath device is routed to only one of the physi=
cal path (selected by path selector) from the active path group. PR OUT reg=
istration service action is one of the such use-case which fails as it expe=
cts all the physical path for the given mpath device to be registered. Due =
to these limitations, most of the cluster applications needs to manage pers=
istent reservation through underlying physical path.
>>
> Persistent reservation is a path-centric command set. I don't see
> clearly the benefit of folding (obfuscating?) it into the multipath
> layer.
> =

Agree. Persistent reservations is not something multipath should be
handling internally. It'll just add functionality without any
immediate gain.
Plus we'd be incurring a support nightmare here.

However, adding a _separate_ program for handling persistent
reservations definitely would be a bonus, as this program could
access multipath internals not otherwise accessible.
And the integration into multipath doesn't gain us anything here;
it's just used to figure out onto which paths PR should be updated.

> Saving a few command lines ? I don't think there are wild admins playing
> with PR without a clustering toolkit out there, so the tricky command
> lines don't really matter.
> =

Beg to disagree. 'Tricky command lines' are not the problem;
figuring out multipath details (with the ever-changing output)
definitely _is_.

> I do maintain a clustering toolkit that handles PR, and I know this
> feature would add code (multipath specific), not remove the current more
> generic code.
> =

> I also realize some other multipath implementations (PowerPath for one)
> propose that feature. I'm curious to know the motivation.
> =

> Am I the only one on the list thinking along this line ? Anyway, I have
> no hard feelings against this work.
> =

As did we, trying to implement a HA agent with persistent
reservations :-)

And hence I would definitely be glad having a tool setting
persistent reservations on a multipathed device.
Only I don't thing it should be built-into multipath itself.

Much like kpartx: you definitely need the functionality, but this
functionality doesn't need to be part of multipath proper.

Other than that: good work.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
