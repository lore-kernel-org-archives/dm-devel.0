From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Mon, 21 Nov 2016 12:19:03 -0600
Message-ID: <20161121181903.GA1972@octiron.msp.redhat.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<OF3A4A70D0.4D2612E4-ON4825806F.00029856-4825806F.0005B3C7@zte.com.cn>
	<1479454748.25031.4.camel@suse.com>
	<OFDDCD5089.D3C390A2-ON4825806F.002B819E-4825806F.002E2347@zte.com.cn>
	<1479457857.25031.8.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1479457857.25031.8.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On Fri, Nov 18, 2016 at 09:30:57AM +0100, Martin Wilck wrote:
> On Fri, 2016-11-18 at 16:24 +0800, tang.junhui@zte.com.cn wrote:
> > Hi Martin,=A0
> > =

> > In your case, my action is:=A0
> > 1) merger uevents 1) 2) to one uevent "add sda sdb", and process them
> > togother=A0
> =

> This will fail because sdb is non-existent at the time you try - no?

Yes. If we get a cluster of events for a device, and the last event is a
remove event, we don't need to precess them. Just like you mention,
after that remove event is sent by udev, the device is gone.  There is
nothing that multipathd could do with it even if it wanted to. So there
is no point in trying the add and change event processing, since we
already know that they will fail.

-Ben

> =

> > Though the processing efficiency in such scenario is lower than
> > yours, but it is simple and reliable,
> > more importantly, Martin, you still focus on such special scene,
> > which I concerned is like this:=A0
> =

> [...]
> =

> I understand what you're concerned with. I just think we need to do
> both. I agree that many events for many different devices are more
> likely. But once you start merging, you'd rather be prepared for
> several events for the same phys device, too.
> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
