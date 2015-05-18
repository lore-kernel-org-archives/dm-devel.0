From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: reinstate path not working
Date: Mon, 18 May 2015 11:27:47 -0500
Message-ID: <20150518162747.GE8491@octiron.msp.redhat.com>
References: <CAH=b03uWBZrOpVtAvifGmJxR83iNcGp5Q1KBzQBcpmsOwvpW=w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAH=b03uWBZrOpVtAvifGmJxR83iNcGp5Q1KBzQBcpmsOwvpW=w@mail.gmail.com>
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

On Mon, May 18, 2015 at 02:09:27PM +0530, Tejaswini Poluri wrote:
>    Hii,
>    We are trying to test multipath setup in our target and tried the vari=
ous
>    commands of multipathd demaon and we find the following error:
>    root@x86-generic-64:~# multipathd -k"fail path sdc"; multipathd
>    -k'reinstate path
>    sdc'; multipathd -k"show paths";
>    [ 3962.708523] device-mapper: multipath: Failing path=A08:32.
>    ok
>    ok
>    hcil=A0 =A0 dev dev_t pri dm_st=A0 =A0chk_st=A0 =A0next_check
>    4:0:0:1 sdc=A08:32=A0 1=A0 =A0[active][faulty] .......... 1/20=A0 =A0 =
<<<=3D=3D=3D CHECK
>    5:0:0:1 sdd=A08:48=A0 1=A0 =A0[active][ready]=A0 XX........ 4/20
>    sdc path becomes [active][ready] only after the polling interval but n=
ot
>    immediately after the reinstate path command.=A0
>    I am observing this in latest multipath tools in ubuntu machine as wel=
l.
>    Please let me know if its a known issue or if I am doing something wro=
ng.
>    Regards.
>    Tejaswini

the reinstate command is supposed to reinstate the device with the
kernel, and it does that. The checker state doesn't change until the
next time that the path is checked.  I agree that it's odd that the
check state switches to faulty as soon as you fail the path, but it
doesn't switch back until the next check after you reinistate it.

The issue is that multipathd needs to override the checker output,
so that a failed path won't be immeditately reinstated.  Once the
path comes back, multipathd wants to record the switch in the checker
thread, so that it can refresh path information what wasn't
automatically done when the path was reinstated.  However, it may make
more sense to have a different checker state for when the device is
in the failed state, so that it's obvious that the checker state is
being overruled.

-Ben

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
