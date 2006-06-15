From: Rune Saetre <rune.saetre@netcom-gsm.no>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Fri, 16 Jun 2006 00:48:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.63.0606160031480.22065@pingle.local.rsnet>
References: <20060613235316.7f982af7@localhost><62b0912f0606140419s60c30535p
	bcc97c30ef99c50d@mail.gmail.com><Pine.LNX.4.63.0606141609310.7019@pingle.lo
	cal.rsnet><20060614215258.6aa76d0f@localhost><87f94c370606151329y4132e53dgf
	964a093683435e3@mail.gmail.com> <20060615232542.6b085337@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279707905-924356278-1150411704=:22065"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060615232542.6b085337@localhost>
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

--279707905-924356278-1150411704=:22065
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi

Next silly question then:
It can't be the power supply not coping with a large number of disks=20
seeking simultaneously? If the voltage drops too much some disks might=20
shut down.

Probably unlikely, but it would yield a simple solution..

Rune

---
Rune S=E6tre <rune.saetre@netcom-gsm.no>
NetCom as
=2E.

On Thu, 15 Jun 2006, Tom Wirschell wrote:

> On 15 Jun 2006, Greg Freemyer wrote:
>>
>> In 2.6.17-mm there is a huge SATA error handler (EH) rewrite.  Is is
>> planned to hit the stable Linus kernel with 2.6.18 towards the end of
>> the summer, but even then it will only have a few of the actual
>> drivers modified to use the EH infrastructure.
>
> Damn. I read about this in the LWN.net Kernel pages for may 17th. I
> figured that once it was in, everything would automagically be using it
> too (i.e. the drivers wouldn't need to be updated to the new system).
> Guess I was a tad na=EFve about that.
> I tried 2.6.17-rc5-mm2 and ran into some BUG()s which went away when I
> just stuck to 2.6.17-rc5.
>
>> I would repost your problem to the lkml-ide list and see if they think
>> that the new EH should help you, and when/if your controller will be
>> using the new EH infrastructure.
>
> Looks like a good idea, thanks!
> Don't let that keep anybody on this list who might have an explanation
> for this be deterred from responding though. :)
>
>> Also, there is a ton of testing going on with the new EH, so if your
>> willing to be a guinea pig, I'm sure you will get a lot of support
>> from the dev. team and get your specific driver updated ASAP.
>
> I've been sitting on a non-functional array for almost 3 months now.
> Don't mind having weird issues a little longer if it means things will
> end up working nicely in the end (or I at least get a sensible
> explanation for what's wrong, so I know what I must do to fix it).
>
> Kind regards,
>
> Tom Wirschell
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
--279707905-924356278-1150411704=:22065
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--279707905-924356278-1150411704=:22065--
