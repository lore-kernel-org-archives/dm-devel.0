From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/29] SLES resync
Date: Mon, 15 Jul 2013 16:12:04 +0200
Message-ID: <51E40334.6090108@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
	<51E3FEEF.7050301@profitbricks.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <51E3FEEF.7050301@profitbricks.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 07/15/2013 03:53 PM, Sebastian Riemer wrote:
> On 15.07.2013 15:00, Hannes Reinecke wrote:
> [...]
>> - When using libudev to read attribute variables we'd be getting
>>   an automated caching from libudev. Which is nice, unless the
>>   data changed in between. So I'd have to go back an roll our
>>   own accessors, skipping libudev here.
> [...]
> =

> Hi Hannes,
> =

> nice, that's what I've already reported. Could you point me to the fix
> commit(s) for this please?
> =


Gnaa. Merge error.
For some reason the patch _should_ be 0014, but then it contains
random merge errors.

I'll be posting an additional patch for this.
Christophe, I'll be probably have to rebase the branch, so wait a
bit with pulling.

Cheers,

Hannes


-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
