From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Correctly ignore empty prio names
Date: Fri, 10 May 2013 16:48:58 +0200
Message-ID: <518D08DA.6030804@suse.de>
References: <1368004423-8338-1-git-send-email-hare@suse.de>
	<20130508162803.GV6253@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130508162803.GV6253@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Christope Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/08/2013 06:28 PM, Benjamin Marzinski wrote:
> On Wed, May 08, 2013 at 11:13:43AM +0200, Hannes Reinecke wrote:
>> This is a partial revert of commit
>> 'Stop annoying prio_lookup warning messages',
>> as that patch would only fix the 'prio_put' case.
>> However, as the prio name might be empty even in
>> in prio_get() we should rather fix this in
>> prio_lookup() and handle both cases.
> =

> My feeling was that you would want to get that warning message if you
> failed to get the prioritizer in prio_get() because the name was empty.
> With this change it will silently fail unless you have the verbosity set
> to 3, in which case you'll get a message like
> =

> sdb: prio =3D  (config file default)
> =

> Which doesn't really look that much like an error.
> =

Yeah, one should modify this message.

> On the other hand, if you never got a prioritizer at all, you don't want
> a warning message when you try to free it in prio_put() since that's
> only happening because there is nothing to free.
> =

I'd rather have the functions to do the correct thing.
We've had tons and tons of issues with multipathing just because
no-one ever checked the function arguments.
So we should not be introducing this behaviour again.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
