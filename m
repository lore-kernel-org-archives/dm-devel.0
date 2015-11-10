From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Bug in dm_any_congested?
Date: Tue, 10 Nov 2015 15:39:04 +0100
Message-ID: <56420188.7030406@redhat.com>
References: <CAEp_DRAcgXsjEPttRnVoDYo97ZeeQ6heiBZhGMkppOUxTnOxjA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAEp_DRAcgXsjEPttRnVoDYo97ZeeQ6heiBZhGMkppOUxTnOxjA@mail.gmail.com>
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

Dne 10.11.2015 v 14:14 Bo=9Atjan =8Akufca @ Teon.si napsal(a):
> Hi all,
>
> (I am not sure if this is the right address for this bug, but dm_* is
> the first function listed in trace)
>
> this happened when I tried dd-ing LV, which resides on RAID10 sw
> storage, to network via netcat. The actual user-visible manifestation
> was segfault of dd that was used for reading.
>
> On first request the error reported was "unable to handle kernel NULL
> pointer dereference...", but on subsequent tries this changed to
> "general protection fault", see below.
>
> HW is a bit dated, but had no problems with it up to now, and SW raid
> is used here. Kernel was 4.2.4.
>
> Is this the right mlist for such bug?

Hi

Yes the issue is known - but source is not fully known.
I've opened public BZ: https://bugzilla.redhat.com/1279941
There is some potential fix - but unclear what it solves:
http://git.kernel.org/linus/ad5f498f610

Regards

Zdenek
