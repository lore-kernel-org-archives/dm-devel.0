From: Rune Saetre <rune.saetre@netcom-gsm.no>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Sun, 18 Jun 2006 15:45:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.63.0606181533080.15173@pingle.local.rsnet>
References: <20060613235316.7f982af7@localhost><62b0912f0606140419s60c30535p
	bcc97c30ef99c50d@mail.gmail.com><Pine.LNX.4.63.0606141609310.7019@pingle.lo
	cal.rsnet><20060614215258.6aa76d0f@localhost>
	<62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279707905-45710902-1150638336=:15173"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62b0912f0606161121i52d05d08m66c5676ff7895da2@mail.gmail.com>
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

--279707905-45710902-1150638336=:15173
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi

> Arno Wagner:
>> If you can test it with reasonable effort and cost (e.g. put some of
>> them on another PSU), you might want to do that.
>
> Is that safe?

Don't know how safe it is to use different PSU's, but I have done it with=
=20
success several times on old hardware used for testing. I can't think of=20
any reason you should run into trouble if ground is common, and the disks=
=20
are powered up first.

> Another way could be to use a meter to gauge how much power it drains.

You better use an oscilloscope if anything, as you are looking for very=20
short transients. I have heard (but never tested) that the disks pull=20
large currents when moving the heads, but with seek times of some=20
milliseconds you wouldn't even see it on a regular amperemeter.

Rune

---
Rune S=E6tre <rune.saetre@netcom-gsm.no>
NetCom as
=2E.
--279707905-45710902-1150638336=:15173
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--279707905-45710902-1150638336=:15173--
