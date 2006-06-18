From: Rune Saetre <rune.saetre@netcom-gsm.no>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Sun, 18 Jun 2006 17:33:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.63.0606181719081.15173@pingle.local.rsnet>
References: <20060613235316.7f982af7@localhost><20060614215258.6aa76d0f@loca
	lhost><62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com><Pine.LN
	X.4.63.0606181533080.15173@pingle.local.rsnet>
	<87f94c370606180813q70122483k5607c3d5a182b6e7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="279707905-1604272374-1150644786=:15173"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87f94c370606180813q70122483k5607c3d5a182b6e7@mail.gmail.com>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279707905-1604272374-1150644786=:15173
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi

In PC's ground is usually connected to the box itself. To be sure ground=20
in the PSU's can just be connected.

I have never experienced problems with ground loops in PCs. In PC's you=20
have all kinds of ground loops, as the same ground is usually connected to=
=20
signal leads, power supply leads and the chassis. As long as the cables=20
are kept short this shouldn't cause problems.

Rune

---
Rune S=E6tre <rune.saetre@netcom-gsm.no>
NetCom as
=2E.

On Sun, 18 Jun 2006, Greg Freemyer wrote:

> On 6/18/06, Rune Saetre <rune.saetre@netcom-gsm.no> wrote:
>> Hi
>>=20
>> > Arno Wagner:
>> >> If you can test it with reasonable effort and cost (e.g. put some of
>> >> them on another PSU), you might want to do that.
>> >
>> > Is that safe?
>>=20
>> Don't know how safe it is to use different PSU's, but I have done it wit=
h
>> success several times on old hardware used for testing. I can't think of
>> any reason you should run into trouble if ground is common, and the disk=
s
>> are powered up first.
>
> Its the common ground part that can be challeging.  I'm not an expert
> of PC powersupplies, but in general power supplies have a floating
> ground, so if you have two of them plugged in the same AC power, you
> will still not have a common ground on the DC side.
>
> Greg
> --=20
> Greg Freemyer
> The Norcross Group
> Forensics for the 21st Century
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
--279707905-1604272374-1150644786=:15173
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--279707905-1604272374-1150644786=:15173--
