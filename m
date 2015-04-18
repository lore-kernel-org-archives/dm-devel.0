From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: ALUA - rescan device capacity on zero sized block
	devices
Date: Sun, 19 Apr 2015 00:56:52 +0200
Message-ID: <CABr-GnefEhc_dOKs360Hox7asbvO5qN8BqPczqC+V8CQ6Myh8w@mail.gmail.com>
References: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>
	<552C008A.9070201@sandisk.com>
	<987831457.156812.1428996031503.JavaMail.zimbra@kangaroot.net>
	<552CCC77.9040703@suse.de> <552CE2C2.8000809@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0167577685889388783=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <552CE2C2.8000809@sandisk.com>
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

--===============0167577685889388783==
Content-Type: multipart/alternative; boundary=001a11c30d14d696f60514079ce5

--001a11c30d14d696f60514079ce5
Content-Type: text/plain; charset=UTF-8

About five years ago, we faced a somewhat simular issue with Symmetrix
arrays, where the replicated LU of a SRDF pair (R2) was flagged read-only
by the kernel upon discovery. Splitting the pair with a symcli command
 made the LU read-write from the array controller point of view, but the
Linux kernel would not promote it read-write dynamically.

I don't know if the Symmetrix array also use a unit attention to signal the
change to the initiators. If it does, it might be worth trying to address
both the 3par peer persistance and the Symmetrix SRDF situations.

On the other hand, if the SRDF R2 rw promotion issue has been fixed since,
the patch might give guidance about where/how to plug the 3par peer
persistance ghost path rescans.

Best regards,
Christophe Varoqui
OpenSVC

On Tue, Apr 14, 2015 at 11:49 AM, Bart Van Assche <
bart.vanassche@sandisk.com> wrote:

> On 04/14/15 10:14, Hannes Reinecke wrote:
>
>> What we can try is to listen to uevents for the device capacity
>> change or ALUA state changes, and retry the read capacity for those
>> events.
>>
>
> Any mechanism that relies on uevents would be asynchronous. We need a way
> to ensure that the capacity data is up to date before any application
> starts using that data. In this context that means before multipath starts
> queueing I/O to a path. This might be challenging when processing uevents
> asynchronously ...
>
> Bart.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c30d14d696f60514079ce5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">About five years ago, we faced a somewhat simular issue wi=
th Symmetrix arrays, where the replicated LU of a SRDF pair (R2) was flagge=
d read-only by the kernel upon discovery. Splitting the pair with a symcli =
command =C2=A0made the LU read-write from the array controller point of vie=
w, but the Linux kernel would not promote it read-write dynamically.<div><b=
r></div><div>I don&#39;t know if the Symmetrix array also use a unit attent=
ion to signal the change to the initiators. If it does, it might be worth t=
rying to address both the 3par peer persistance and the Symmetrix SRDF situ=
ations.</div><div><br></div><div>On the other hand, if the SRDF R2 rw promo=
tion issue has been fixed since, the patch might give guidance about where/=
how to plug the 3par peer persistance ghost path rescans.</div><div><br></d=
iv><div>Best regards,</div><div>Christophe Varoqui</div><div>OpenSVC</div><=
/div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Apr =
14, 2015 at 11:49 AM, Bart Van Assche <span dir=3D"ltr">&lt;<a href=3D"mail=
to:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@sandisk.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">O=
n 04/14/15 10:14, Hannes Reinecke wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
What we can try is to listen to uevents for the device capacity<br>
change or ALUA state changes, and retry the read capacity for those<br>
events.<br>
</blockquote>
<br></span>
Any mechanism that relies on uevents would be asynchronous. We need a way t=
o ensure that the capacity data is up to date before any application starts=
 using that data. In this context that means before multipath starts queuei=
ng I/O to a path. This might be challenging when processing uevents asynchr=
onously ...<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
Bart.</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>

--001a11c30d14d696f60514079ce5--


--===============0167577685889388783==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0167577685889388783==--
