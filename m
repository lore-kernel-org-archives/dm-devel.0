From: Hannes Reinecke <hare@suse.de>
Subject: Re: [BUG] multipath-tools: uuid has become meaningless
Date: Wed, 21 Jul 2010 12:44:02 +0200
Message-ID: <4C46CF72.3020101@suse.de>
References: <20100719224528.GA23414@us.ibm.com>	<1279604124.2841.5.camel@Nokia-N900-42-11>	<20100720065410.GA3166@us.ibm.com>
	<4C454D8A.3020203@suse.de> <20100720220644.GA25337@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100720220644.GA25337@us.ibm.com>
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

Malahal Naineni wrote:
> Hannes Reinecke [hare@suse.de] wrote:
>> Malahal Naineni wrote:
>>> This is where I was heading. I did some investigation and found that we
>>> really need to rename to wwid based names before we finally rename to
>>> the intended name. So we may actually have two passes just to rename
>>> (first to wwid based names and then to actual names).  Also the current
>>> code doesn't do rename followed by reload even if it is needed. Someone
>>> sets friendly name and some other defaults that need reload like path
>>> grouping policy etc, we just rename! Probably a bug in itself.
> =

>> You sure? I would rather rely on device-mapper uuids here.
> =

> Hannes, I am not sure what you are referring to when you say, "You
> sure?" Are you saying if I am sure about this bug? If so, you can see
> yourself by swapping couple entries in the bindings file. As I said,
> you will notice this bug only when you enable 'user_friendly_names' in
> initrd in real life!
> =

Well, I wanted to inquire about the double renaming thing.
But

>> So we can use the known naming scheme for the uuid to regenerate the
>> wwid; with this we can identify/access the device and we should be able =
to
>> make do with just one pass.
> =

> Say, you have "mpath0[uuid0]" and "mpath1[uuid1]" loaded currently.  How
> can we rename mpath0 to mpath1 and vice-versa? It does require an
> intermediate step of renaming to something else, right? =

>  =

is a valid point. So yes, we have to put in a renaming mechanism.
So falling back to wwid should work here.

Sorry for the noise, you are correct here.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
