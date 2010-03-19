From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after
	dm	resume	ioctl.
Date: Fri, 19 Mar 2010 15:08:39 +0100
Message-ID: <4BA38567.1050106@suse.de>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>	<4BA29CA4.9070000@redhat.com>	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>	<20100319090656.GR6379@soda.linbit>	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BA37B06.1040107@redhat.com>
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

Peter Rajnoha wrote:
> On 03/19/2010 10:24 AM, Kay Sievers wrote:
>> No, that's what "change" is for, and we already have these "change"
>> events for dm. Udev does not care if the device is ready or not, it
>> synchronizes /sys and /dev, and that works just fine with "change"
>> events.
> =

> CHANGE events, not quite... We can't even rely on these.
> =

> Just to mention, there's also a CHANGE event generated when
> read-only flag is set for a device (this is not managed by
> device-mapper of course). This one is generated even before
> the actual CHANGE event that is generated when DM device is
> ready to be used.
> =

As mentioned earlier, CHANGE events do not carry any
information about _what_ has changed.
The udev rules / programs are expected to check for
this themselves. So from that point of view yes, you
cannot simply wait for 'the' CHANGE event as you
might get more than one.

I guess most of this discussion could be solved if
the CHANGE events would be modify to attach some
enviroment variables indicating the nature of the change.

EG adding 'DM_STATE=3DLIVE' or whatever is appropriate
here.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
