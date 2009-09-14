From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools: Add preferred TPG prioritizer
Date: Mon, 14 Sep 2009 10:59:00 -0500
Message-ID: <20090914155859.GO15326@ether.msp.redhat.com>
References: <20090911182308.GN15326@ether.msp.redhat.com>
	<4AADE1A7.1080008@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AADE1A7.1080008@suse.de>
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
List-Id: dm-devel.ids

On Mon, Sep 14, 2009 at 08:24:39AM +0200, Hannes Reinecke wrote:
> Benjamin Marzinski wrote:
>> Instead of using the Target port's Asymmetric Access State to determin=
e
>> priority, some users what to use the preferred port bit.  This patch m=
akes
>> a new prioritizer, based off the ALUA prioritizer, but using the prefe=
rred
>> port bit instead.
>>
> Please, no.
>
> This would mean that 'tpg_pref' would evaluate the PREF bit _only_,
> with total disregard to the other settings.
>

The PREF bit isn't static.  It can change whenever the AAS status
changes.  I'd like to think that most devices do something sane like
removing the PREF bit from offline and unavailable ports. Perhaps that
is hoping for too much.  So making sure that the preferred port
is a sane choice makes sense.  I'm not sure what you patch does, but I
got the feeling that people wanted to choose, for instance, a preferred
standby port over a non-preferred active port.  If you have a patch that
does that, I'm all for it.  Otherwise, I can add some logic to make sure
that the preferred port is a reasonable one (not unavailable or offline).

How does that sound?

-Ben

> We should be updating the existing 'alua' prioritizer to evaluate
> the PREF bit together with the existing AAS status; then we could
> be using it for all scenarios.
>
> I think I got a patch somewhere ...
>
> Cheers,
>
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
