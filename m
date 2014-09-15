From: Hannes Reinecke <hare@suse.de>
Subject: Re: Powerpath vs dm-multipath - two points of FUD?
Date: Mon, 15 Sep 2014 08:54:17 +0200
Message-ID: <54168D19.3010908@suse.de>
References: <454E18A46D7B064CA63B41E99AD179508A754100@MX103CL02.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <454E18A46D7B064CA63B41E99AD179508A754100@MX103CL02.corp.emc.com>
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

Hi Jerome,

On 09/14/2014 08:44 PM, Levy, Jerome wrote:
>> Firstly, apologies if this is a common topic and my intentions are not =

>> to start a flame war. I've googled extensively but haven't found
>> specific information to address my queries, so I thought I would turn he=
re.
> =

> At the risk of getting involved in a religious discussion (disclaimer: I =
am an EMC employee
> and was an advanced support engineer for both PowerPath and
dm-multipath) I thought I'd pass
> along a few thoughts that might help:
> =

> PowerPath costs money. dm-multipath is included with the OS distro.
> =

[ .. ]
> =

> PowerPath contains proprietary load sensing and balancing algorithms whic=
h may help performance
> in a given situation. (It does. I've seen them.) YMMV.
> =

Unfortunately I'll have to agree with Jerome here.
If you have in-depth knowledge of the array you can cut some corners
and optimize for certain scenarios.
We haven't, and so we can't.

Neither can we estimate how _likely_ such a scenario is;
We live on the assumption that it's not, and that most customers are
happily living with the standard setups.
Surprisingly enough, most do :-)

> Request size and other switching options  can be useful in a number
> of specific situations -- some may call them corner cases, but
streaming
> media, heavy database backups, large dataset transfers, and others
have
> been shown to benefit from alternate PowerPath policies.
> =

See above. Of course.

> As Hannes points out, PowerPath is supported by EMC. If things don't work,
> you have someone to call. That can be comforting in the middle of
the night :)
> =

But so is device-mapper multipath :-)
Sorry.

> I've seen both PowerPath and native multipath solutions provide a lot of
> value in different ways,  and the decision as to which to use is
not always
> clear-cut. Hope this helps!
> =

Thanks for that. It surely helps.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
