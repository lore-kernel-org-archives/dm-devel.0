From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: deterministic io throughput in multipath
Date: Mon, 16 Jan 2017 11:19:19 +0000
Message-ID: <4dfed25f04c04771a732580a4a8cc834@BRMWP-EXMB12.corp.brocade.com>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
	<20161221160940.GG19659@octiron.msp.redhat.com>
	<8cd4cc5f20b540a1b8312ad485711152@BRMWP-EXMB12.corp.brocade.com>
	<20170103171159.GA2732@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_005_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_"
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--_005_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_
Content-Type: multipart/alternative;
	boundary="_000_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_"

--_000_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi Ben,
After the below discussion we  came with the approach which will meet our requirement.
I have attached the patch which is working good in our field tests.

Could you please review the attached patch and provide us your valuable comments .
Below are the files that has been changed .

 libmultipath/config.c      |  3 +++
 libmultipath/config.h      |  9 +++++++++
 libmultipath/configure.c   |  3 +++
 libmultipath/defaults.h    |  1 +
 libmultipath/dict.c            | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/dict.h        |  1 +
 libmultipath/propsel.c     | 44 ++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/propsel.h     |  6 ++++++
 libmultipath/structs.h     | 12 +++++++++++-
 libmultipath/structs_vec.c | 10 ++++++++++
 multipath/multipath.conf.5 | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 multipathd/main.c          | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

We have added three new config parameters whose description is below.
1.san_path_err_threshold:
        If set to a value greater than 0, multipathd will watch paths and check how many times a path has been failed due to errors. If the number of failures on a particular path is greater then the san_path_err_threshold then the path will not  reinstate  till san_path_err_recovery_time. These path failures should occur within a san_path_err_threshold_window time frame, if not we will consider the path is good enough to reinstate.

2.san_path_err_threshold_window:
        If set to a value greater than 0, multipathd will check whether the path failures has exceeded  the san_path_err_threshold within this time frame i.e san_path_err_threshold_window . If so we will not reinstate the path till         san_path_err_recovery_time.

3.san_path_err_recovery_time:
If set to a value greater than 0, multipathd will make sure that when path failures has exceeded the san_path_err_threshold within san_path_err_threshold_window then the path  will be placed in failed state for san_path_err_recovery_time duration. Once san_path_err_recovery_time has timeout  we will reinstate the failed path .

Regards,
Muneendra.

-----Original Message-----
From: Muneendra Kumar M
Sent: Wednesday, January 04, 2017 6:56 PM
To: 'Benjamin Marzinski' <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
Subject: RE: [dm-devel] deterministic io throughput in multipath

Hi Ben,
Thanks for the information.

Regards,
Muneendra.

-----Original Message-----
From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
Sent: Tuesday, January 03, 2017 10:42 PM
To: Muneendra Kumar M <mmandala@Brocade.com<mailto:mmandala@Brocade.com>>
Cc: dm-devel@redhat.com<mailto:dm-devel@redhat.com>
Subject: Re: [dm-devel] deterministic io throughput in multipath

On Mon, Dec 26, 2016 at 09:42:48AM +0000, Muneendra Kumar M wrote:
> Hi Ben,
>
> If there are two paths on a dm-1 say sda and sdb as below.
>
> #  multipath -ll
>       mpathd (3600110d001ee7f0102050001cc0b6751) dm-1 SANBlaze,VLUN MyLun
>       size=8.0M features='0' hwhandler='0' wp=rw
>       `-+- policy='round-robin 0' prio=50 status=active
>         |- 8:0:1:0  sda 8:48 active ready  running
>         `- 9:0:1:0  sdb 8:64 active ready  running
>
> And on sda if iam seeing lot of errors due to which the sda path is fluctuating from failed state to active state and vicevera.
>
> My requirement is something like this if sda is failed for more then 5
> times in a hour duration ,then I want to keep the sda in failed state
> for few hours (3hrs)
>
> And the data should travel only thorugh sdb path.
> Will this be possible with the below parameters.

No. delay_watch_checks sets how may path checks you watch a path that has recently come back from the failed state. If the path fails again within this time, multipath device delays it.  This means that the delay is always trigger by two failures within the time limit.  It's possible to adapt this to count numbers of failures, and act after a certain number within a certain timeframe, but it would take a bit more work.

delay_wait_checks doesn't guarantee that it will delay for any set length of time.  Instead, it sets the number of consecutive successful path checks that must occur before the path is usable again. You could set this for 3 hours of path checks, but if a check failed during this time, you would restart the 3 hours over again.

-Ben

> Can you just let me know what values I should add for delay_watch_checks and delay_wait_checks.
>
> Regards,
> Muneendra.
>
>
>
> -----Original Message-----
> From: Muneendra Kumar M
> Sent: Thursday, December 22, 2016 11:10 AM
> To: 'Benjamin Marzinski' <bmarzins@redhat.com<mailto:bmarzins@redhat.com>>
> Cc: dm-devel@redhat.com<mailto:dm-devel@redhat.com>
> Subject: RE: [dm-devel] deterministic io throughput in multipath
>
> Hi Ben,
>
> Thanks for the reply.
> I will look into this parameters will do the internal testing and let you know the results.
>
> Regards,
> Muneendra.
>
> -----Original Message-----
> From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
> Sent: Wednesday, December 21, 2016 9:40 PM
> To: Muneendra Kumar M <mmandala@Brocade.com<mailto:mmandala@Brocade.com>>
> Cc: dm-devel@redhat.com<mailto:dm-devel@redhat.com>
> Subject: Re: [dm-devel] deterministic io throughput in multipath
>
> Have you looked into the delay_watch_checks and delay_wait_checks configuration parameters?  The idea behind them is to minimize the use of paths that are intermittently failing.
>
> -Ben
>
> On Mon, Dec 19, 2016 at 11:50:36AM +0000, Muneendra Kumar M wrote:
> >    Customers using Linux host (mostly RHEL host) using a SAN network for
> >    block storage, complain the Linux multipath stack is not resilient to
> >    handle non-deterministic storage network behaviors. This has caused many
> >    customer move away to non-linux based servers. The intent of the below
> >    patch and the prevailing issues are given below. With the below design we
> >    are seeing the Linux multipath stack becoming resilient to such network
> >    issues. We hope by getting this patch accepted will help in more Linux
> >    server adoption that use SAN network.
> >
> >    I have already sent the design details to the community in a different
> >    mail chain and the details are available in the below link.
> >
> >    [1]https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=DgIDAw&c=IL_XqQWOjubgfqINi2jTzg&r=E3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=vfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=q5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu52hG3MKzM&e= .
> >
> >    Can you please go through the design and send the comments to us.
> >
> >
> >
> >    Regards,
> >
> >    Muneendra.
> >
> >
> >
> >
> >
> > References
> >
> >    Visible links
> >    1.
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_
> > ar
> > chives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=DgIDAw&c=IL_XqQWOj
> > ub
> > gfqINi2jTzg&r=E3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=vfwpVp6e
> > 1K
> > XtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=q5OI-lfefNC2CHKmyUkokgiyiPo_Uj7M
> > Ru
> > 52hG3MKzM&e=
>
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com<mailto:dm-devel@redhat.com>
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_
> > ma
> > ilman_listinfo_dm-2Ddevel&d=DgIDAw&c=IL_XqQWOjubgfqINi2jTzg&r=E3ftc4
> > 7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=vfwpVp6e1KXtRA0ctwHYJ7cDmPsL
> > i2C1L9pox7uexsY&s=UyE46dXOrNTbPz_TVGtpoHl3J3h_n0uYhI4TI-PgyWg&e=


--_000_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from rtf -->
<style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left:=
 #800000 2px solid; } --></style>
</head>
<body>
<font face=3D"Calibri" size=3D"2"><span style=3D"font-size:11pt;">
<div>Hi Ben,</div>
<div>After the below discussion we&nbsp; came with the approach which will =
meet our requirement.</div>
<div>I have attached the patch which is working good in our field tests. </=
div>
<div> </div>
<div>Could you please review the attached patch and provide us your valuabl=
e comments . </div>
<div>Below are the files that has been changed . </div>
<div>&nbsp;</div>
<div> libmultipath/config.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 3 &#43;&#=
43;&#43;</div>
<div> libmultipath/config.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 9 &#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div> libmultipath/configure.c&nbsp;&nbsp; |&nbsp; 3 &#43;&#43;&#43;</div>
<div> libmultipath/defaults.h&nbsp;&nbsp;&nbsp; |&nbsp; 1 &#43;</div>
<div> libmultipath/dict.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; | 80 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div> libmultipath/dict.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;=
 1 &#43;</div>
<div> libmultipath/propsel.c&nbsp;&nbsp;&nbsp;&nbsp; | 44 &#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div> libmultipath/propsel.h&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 6 &#43;&#43;&#=
43;&#43;&#43;&#43;</div>
<div> libmultipath/structs.h&nbsp;&nbsp;&nbsp;&nbsp; | 12 &#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;-</div>
<div> libmultipath/structs_vec.c | 10 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;</div>
<div> multipath/multipath.conf.5 | 58 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;</div>
<div> multipathd/main.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; | 61 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;--</div>
<div>&nbsp;</div>
<div>We have added three new config parameters whose description is below.<=
/div>
<div>1.<b>san_path_err_threshold</b>:</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If set to a value greater t=
han 0, multipathd will watch paths and check how many times a path has been=
 failed due to errors. If the number of failures on a particular path is gr=
eater then the san_path_err_threshold then the path will not&nbsp; reinstat=
e&nbsp;
till san_path_err_recovery_time. These path failures should occur within a =
san_path_err_threshold_window time frame, if not we will consider the path =
is good enough to reinstate.</div>
<div>&nbsp;</div>
<div>2.<b>san_path_err_threshold_window</b>:</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If set to a value greater t=
han 0, multipathd will check whether the path failures has exceeded&nbsp; t=
he san_path_err_threshold within this time frame i.e san_path_err_threshold=
_window . If so we will not reinstate the path till&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; san_path_err_recovery_time.
</div>
<div>&nbsp;</div>
<div>3.<b>san_path_err_recovery_time</b>:</div>
<div>If set to a value greater than 0, multipathd will make sure that when =
path failures has exceeded the san_path_err_threshold within san_path_err_t=
hreshold_window then the path&nbsp; will be placed in failed state for san_=
path_err_recovery_time duration. Once
san_path_err_recovery_time has timeout&nbsp; we will reinstate the failed p=
ath .</div>
<a name=3D"_MailEndCompose"></a>
<div>&nbsp;</div>
<div>Regards,</div>
<div>Muneendra.</div>
<div>&nbsp;</div>
<div>-----Original Message-----<br>

From: Muneendra Kumar M <br>

Sent: Wednesday, January 04, 2017 6:56 PM<br>

To: 'Benjamin Marzinski' &lt;bmarzins@redhat.com&gt;<br>

Cc: dm-devel@redhat.com<br>

Subject: RE: [dm-devel] deterministic io throughput in multipath</div>
<div>&nbsp;</div>
<div>Hi Ben,</div>
<div>Thanks for the information.</div>
<div>&nbsp;</div>
<div>Regards,</div>
<div>Muneendra.</div>
<div>&nbsp;</div>
<div>-----Original Message-----</div>
<div>From: Benjamin Marzinski [<a href=3D"mailto:bmarzins@redhat.com">mailt=
o:bmarzins@redhat.com</a>]</div>
<div>Sent: Tuesday, January 03, 2017 10:42 PM</div>
<div>To: Muneendra Kumar M &lt;<a href=3D"mailto:mmandala@Brocade.com">mman=
dala@Brocade.com</a>&gt;</div>
<div>Cc: <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a></di=
v>
<div>Subject: Re: [dm-devel] deterministic io throughput in multipath</div>
<div>&nbsp;</div>
<div>On Mon, Dec 26, 2016 at 09:42:48AM &#43;0000, Muneendra Kumar M wrote:=
</div>
<div>&gt; Hi Ben,</div>
<div>&gt; </div>
<div>&gt; If there are two paths on a dm-1 say sda and sdb as below.</div>
<div>&gt; </div>
<div>&gt; #&nbsp; multipath -ll</div>
<div>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mpathd (3600110d001ee7f=
0102050001cc0b6751) dm-1 SANBlaze,VLUN MyLun</div>
<div>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; size=3D8.0M features=3D=
'0' hwhandler=3D'0' wp=3Drw</div>
<div>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `-&#43;- policy=3D'roun=
d-robin 0' prio=3D50 status=3Dactive</div>
<div>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |- 8:0:1:0&=
nbsp; sda 8:48 active ready&nbsp; running</div>
<div>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `- 9:0:1:0&=
nbsp; sdb 8:64 active ready&nbsp; running&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; </div>
<div>&gt; </div>
<div>&gt; And on sda if iam seeing lot of errors due to which the sda path =
is fluctuating from failed state to active state and vicevera.</div>
<div>&gt; </div>
<div>&gt; My requirement is something like this if sda is failed for more t=
hen 5 </div>
<div>&gt; times in a hour duration ,then I want to keep the sda in failed s=
tate </div>
<div>&gt; for few hours (3hrs)</div>
<div>&gt; </div>
<div>&gt; And the data should travel only thorugh sdb path.</div>
<div>&gt; Will this be possible with the below parameters.</div>
<div>&nbsp;</div>
<div>No. delay_watch_checks sets how may path checks you watch a path that =
has recently come back from the failed state. If the path fails again withi=
n this time, multipath device delays it.&nbsp; This means that the delay is=
 always trigger by two failures within
the time limit.&nbsp; It's possible to adapt this to count numbers of failu=
res, and act after a certain number within a certain timeframe, but it woul=
d take a bit more work.</div>
<div>&nbsp;</div>
<div>delay_wait_checks doesn't guarantee that it will delay for any set len=
gth of time.&nbsp; Instead, it sets the number of consecutive successful pa=
th checks that must occur before the path is usable again. You could set th=
is for 3 hours of path checks, but if
a check failed during this time, you would restart the 3 hours over again.<=
/div>
<div>&nbsp;</div>
<div>-Ben</div>
<div>&nbsp;</div>
<div>&gt; Can you just let me know what values I should add for delay_watch=
_checks and delay_wait_checks.</div>
<div>&gt; </div>
<div>&gt; Regards,</div>
<div>&gt; Muneendra.</div>
<div>&gt; </div>
<div>&gt; </div>
<div>&gt; </div>
<div>&gt; -----Original Message-----</div>
<div>&gt; From: Muneendra Kumar M</div>
<div>&gt; Sent: Thursday, December 22, 2016 11:10 AM</div>
<div>&gt; To: 'Benjamin Marzinski' &lt;<a href=3D"mailto:bmarzins@redhat.co=
m">bmarzins@redhat.com</a>&gt;</div>
<div>&gt; Cc: <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a=
></div>
<div>&gt; Subject: RE: [dm-devel] deterministic io throughput in multipath<=
/div>
<div>&gt; </div>
<div>&gt; Hi Ben,</div>
<div>&gt; </div>
<div>&gt; Thanks for the reply.</div>
<div>&gt; I will look into this parameters will do the internal testing and=
 let you know the results.</div>
<div>&gt; </div>
<div>&gt; Regards,</div>
<div>&gt; Muneendra.</div>
<div>&gt; </div>
<div>&gt; -----Original Message-----</div>
<div>&gt; From: Benjamin Marzinski [<a href=3D"mailto:bmarzins@redhat.com">=
mailto:bmarzins@redhat.com</a>]</div>
<div>&gt; Sent: Wednesday, December 21, 2016 9:40 PM</div>
<div>&gt; To: Muneendra Kumar M &lt;<a href=3D"mailto:mmandala@Brocade.com"=
>mmandala@Brocade.com</a>&gt;</div>
<div>&gt; Cc: <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a=
></div>
<div>&gt; Subject: Re: [dm-devel] deterministic io throughput in multipath<=
/div>
<div>&gt; </div>
<div>&gt; Have you looked into the delay_watch_checks and delay_wait_checks=
 configuration parameters?&nbsp; The idea behind them is to minimize the us=
e of paths that are intermittently failing.</div>
<div>&gt; </div>
<div>&gt; -Ben</div>
<div>&gt; </div>
<div>&gt; On Mon, Dec 19, 2016 at 11:50:36AM &#43;0000, Muneendra Kumar M w=
rote:</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; Customers using Linux host (mostly RHEL ho=
st) using a SAN network for</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; block storage, complain the Linux multipat=
h stack is not resilient to</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; handle non-deterministic storage network b=
ehaviors. This has caused many</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; customer move away to non-linux based serv=
ers. The intent of the below</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; patch and the prevailing issues are given =
below. With the below design we</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; are seeing the Linux multipath stack becom=
ing resilient to such network</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; issues. We hope by getting this patch acce=
pted will help in more Linux</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; server adoption that use SAN network.</div=
>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; I have already sent the design details to =
the community in a different</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; mail chain and the details are available i=
n the below link.</div>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; [1]<a href=3D"https://urldefense.proofpoin=
t.com/v2/url?u=3Dhttps-3A__www.redhat.com_archives_dm-2Ddevel_2016-2DDecemb=
er_msg00122.html&amp;d=3DDgIDAw&amp;c=3DIL_XqQWOjubgfqINi2jTzg&amp;r=3DE3ft=
c47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&amp;m=3DvfwpVp6e1KXtRA0ctwHYJ7cDmPs=
Li2C1L9pox7uexsY&amp;s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu52hG3MKzM&amp;e"=
>https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_arch=
ives_dm-2Ddevel_2016-2DDecember_msg00122.html&amp;d=3DDgIDAw&amp;c=3DIL_XqQ=
WOjubgfqINi2jTzg&amp;r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&amp;m=
=3DvfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&amp;s=3Dq5OI-lfefNC2CHKmyUko=
kgiyiPo_Uj7MRu52hG3MKzM&amp;e</a>=3D
.</div>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; Can you please go through the design and s=
end the comments to us.</div>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; Regards,</div>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; Muneendra.</div>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt; &gt; </div>
<div>&gt; &gt; References</div>
<div>&gt; &gt; </div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; Visible links</div>
<div>&gt; &gt;&nbsp;&nbsp;&nbsp; 1. </div>
<div>&gt; &gt; <a href=3D"https://urldefense.proofpoint.com/v2/url?u=3Dhttp=
s-3A__www.redhat.com_">https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3=
A__www.redhat.com_</a></div>
<div>&gt; &gt; ar</div>
<div>&gt; &gt; chives_dm-2Ddevel_2016-2DDecember_msg00122.html&amp;d=3DDgID=
Aw&amp;c=3DIL_XqQWOj</div>
<div>&gt; &gt; ub</div>
<div>&gt; &gt; gfqINi2jTzg&amp;r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sB=
IP0&amp;m=3DvfwpVp6e</div>
<div>&gt; &gt; 1K</div>
<div>&gt; &gt; XtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&amp;s=3Dq5OI-lfefNC2CHKmyU=
kokgiyiPo_Uj7M</div>
<div>&gt; &gt; Ru</div>
<div>&gt; &gt; 52hG3MKzM&amp;e=3D</div>
<div>&gt; </div>
<div>&gt; &gt; --</div>
<div>&gt; &gt; dm-devel mailing list</div>
<div>&gt; &gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</=
a></div>
<div>&gt; &gt; <a href=3D"https://urldefense.proofpoint.com/v2/url?u=3Dhttp=
s-3A__www.redhat.com_">https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3=
A__www.redhat.com_</a></div>
<div>&gt; &gt; ma</div>
<div>&gt; &gt; ilman_listinfo_dm-2Ddevel&amp;d=3DDgIDAw&amp;c=3DIL_XqQWOjub=
gfqINi2jTzg&amp;r=3DE3ftc4</div>
<div>&gt; &gt; 7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&amp;m=3DvfwpVp6e1KXtRA=
0ctwHYJ7cDmPsL</div>
<div>&gt; &gt; i2C1L9pox7uexsY&amp;s=3DUyE46dXOrNTbPz_TVGtpoHl3J3h_n0uYhI4T=
I-PgyWg&amp;e=3D </div>
<div>&nbsp;</div>
</span></font>
</body>
</html>

--_000_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_--

--_005_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_
Content-Type: application/octet-stream; name="san_path_err.patch"
Content-Description: san_path_err.patch
Content-Disposition: attachment; filename="san_path_err.patch"; size=20594;
	creation-date="Mon, 16 Jan 2017 06:39:48 GMT";
	modification-date="Mon, 16 Jan 2017 06:30:13 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWcuYyBiL2xpYm11bHRpcGF0aC9jb25maWcu
YwppbmRleCAxNWRkYmQ4Li4xOWFkYjk3IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvY29uZmln
LmMKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZy5jCkBAIC0zNDgsNiArMzQ4LDkgQEAgbWVyZ2Vf
aHdlIChzdHJ1Y3QgaHdlbnRyeSAqIGRzdCwgc3RydWN0IGh3ZW50cnkgKiBzcmMpCiAJbWVyZ2Vf
bnVtKGRlbGF5X3dhaXRfY2hlY2tzKTsKIAltZXJnZV9udW0oc2tpcF9rcGFydHgpOwogCW1lcmdl
X251bShtYXhfc2VjdG9yc19rYik7CisJbWVyZ2VfbnVtKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQp
OworCW1lcmdlX251bShzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyk7CisJbWVyZ2VfbnVt
KHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKTsKIAogCS8qCiAJICogTWFrZSBzdXJlIGZlYXR1
cmVzIGlzIGNvbnNpc3RlbnQgd2l0aApkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL2NvbmZpZy5o
IGIvbGlibXVsdGlwYXRoL2NvbmZpZy5oCmluZGV4IDk2NzAwMjAuLjI5ODU5NTggMTAwNjQ0Ci0t
LSBhL2xpYm11bHRpcGF0aC9jb25maWcuaAorKysgYi9saWJtdWx0aXBhdGgvY29uZmlnLmgKQEAg
LTY1LDYgKzY1LDkgQEAgc3RydWN0IGh3ZW50cnkgewogCWludCBkZWZlcnJlZF9yZW1vdmU7CiAJ
aW50IGRlbGF5X3dhdGNoX2NoZWNrczsKIAlpbnQgZGVsYXlfd2FpdF9jaGVja3M7CisJaW50IHNh
bl9wYXRoX2Vycl90aHJlc2hvbGQ7CisJaW50IHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93
OworCWludCBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZTsKIAlpbnQgc2tpcF9rcGFydHg7CiAJ
aW50IG1heF9zZWN0b3JzX2tiOwogCWNoYXIgKiBibF9wcm9kdWN0OwpAQCAtOTMsNiArOTYsOSBA
QCBzdHJ1Y3QgbXBlbnRyeSB7CiAJaW50IGRlZmVycmVkX3JlbW92ZTsKIAlpbnQgZGVsYXlfd2F0
Y2hfY2hlY2tzOwogCWludCBkZWxheV93YWl0X2NoZWNrczsKKwlpbnQgc2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZDsKKwlpbnQgc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3c7CisJaW50IHNhbl9w
YXRoX2Vycl9yZWNvdmVyeV90aW1lOwogCWludCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3NlY3Rv
cnNfa2I7CiAJdWlkX3QgdWlkOwpAQCAtMTM4LDYgKzE0NCw5IEBAIHN0cnVjdCBjb25maWcgewog
CWludCBwcm9jZXNzZWRfbWFpbl9jb25maWc7CiAJaW50IGRlbGF5X3dhdGNoX2NoZWNrczsKIAlp
bnQgZGVsYXlfd2FpdF9jaGVja3M7CisJaW50IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQ7CisJaW50
IHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93OworCWludCBzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZTsKIAlpbnQgdXhzb2NrX3RpbWVvdXQ7CiAJaW50IHN0cmljdF90aW1pbmc7CiAJaW50
IHJldHJpZ2dlcl90cmllczsKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWd1cmUuYyBi
L2xpYm11bHRpcGF0aC9jb25maWd1cmUuYwppbmRleCBhMGZjYWQ5Li4wZjUwODI2IDEwMDY0NAot
LS0gYS9saWJtdWx0aXBhdGgvY29uZmlndXJlLmMKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZ3Vy
ZS5jCkBAIC0yOTQsNiArMjk0LDkgQEAgaW50IHNldHVwX21hcChzdHJ1Y3QgbXVsdGlwYXRoICpt
cHAsIGNoYXIgKnBhcmFtcywgaW50IHBhcmFtc19zaXplKQogCXNlbGVjdF9kZWZlcnJlZF9yZW1v
dmUoY29uZiwgbXBwKTsKIAlzZWxlY3RfZGVsYXlfd2F0Y2hfY2hlY2tzKGNvbmYsIG1wcCk7CiAJ
c2VsZWN0X2RlbGF5X3dhaXRfY2hlY2tzKGNvbmYsIG1wcCk7CisJc2VsZWN0X3Nhbl9wYXRoX2Vy
cl90aHJlc2hvbGQoY29uZiwgbXBwKTsKKwlzZWxlY3Rfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93
aW5kb3coY29uZiwgbXBwKTsKKwlzZWxlY3Rfc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUoY29u
ZiwgbXBwKTsKIAlzZWxlY3Rfc2tpcF9rcGFydHgoY29uZiwgbXBwKTsKIAlzZWxlY3RfbWF4X3Nl
Y3RvcnNfa2IoY29uZiwgbXBwKTsKIApkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL2RlZmF1bHRz
LmggYi9saWJtdWx0aXBhdGgvZGVmYXVsdHMuaAppbmRleCBiOWIwYTM3Li45ZTgwNTljIDEwMDY0
NAotLS0gYS9saWJtdWx0aXBhdGgvZGVmYXVsdHMuaAorKysgYi9saWJtdWx0aXBhdGgvZGVmYXVs
dHMuaApAQCAtMjQsNiArMjQsNyBAQAogI2RlZmluZSBERUZBVUxUX0RFVEVDVF9QUklPCURFVEVD
VF9QUklPX09OCiAjZGVmaW5lIERFRkFVTFRfREVGRVJSRURfUkVNT1ZFCURFRkVSUkVEX1JFTU9W
RV9PRkYKICNkZWZpbmUgREVGQVVMVF9ERUxBWV9DSEVDS1MJREVMQVlfQ0hFQ0tTX09GRgorI2Rl
ZmluZSBERUZBVUxUX0VSUl9DSEVDS1MJRVJSX0NIRUNLU19PRkYKICNkZWZpbmUgREVGQVVMVF9V
RVZFTlRfU1RBQ0tTSVpFIDI1NgogI2RlZmluZSBERUZBVUxUX1JFVFJJR0dFUl9ERUxBWQkxMAog
I2RlZmluZSBERUZBVUxUX1JFVFJJR0dFUl9UUklFUwkzCmRpZmYgLS1naXQgYS9saWJtdWx0aXBh
dGgvZGljdC5jIGIvbGlibXVsdGlwYXRoL2RpY3QuYwppbmRleCBkYzIxODQ2Li5hNTY4OWJkIDEw
MDY0NAotLS0gYS9saWJtdWx0aXBhdGgvZGljdC5jCisrKyBiL2xpYm11bHRpcGF0aC9kaWN0LmMK
QEAgLTEwNzQsNiArMTA3NCw3MiBAQCBkZWNsYXJlX2h3X3NucHJpbnQoZGVsYXlfd2FpdF9jaGVj
a3MsIHByaW50X2RlbGF5X2NoZWNrcykKIGRlY2xhcmVfbXBfaGFuZGxlcihkZWxheV93YWl0X2No
ZWNrcywgc2V0X2RlbGF5X2NoZWNrcykKIGRlY2xhcmVfbXBfc25wcmludChkZWxheV93YWl0X2No
ZWNrcywgcHJpbnRfZGVsYXlfY2hlY2tzKQogCisKK3N0YXRpYyBpbnQKK3NldF9wYXRoX2Vycl9p
bmZvKHZlY3RvciBzdHJ2ZWMsIHZvaWQgKnB0cikKK3sKKyAgICAgICAgaW50ICppbnRfcHRyID0g
KGludCAqKXB0cjsKKyAgICAgICAgY2hhciAqIGJ1ZmY7CisKKyAgICAgICAgYnVmZiA9IHNldF92
YWx1ZShzdHJ2ZWMpOworICAgICAgICBpZiAoIWJ1ZmYpCisgICAgICAgICAgICAgICAgcmV0dXJu
IDE7CisKKyAgICAgICAgaWYgKCFzdHJjbXAoYnVmZiwgIm5vIikgfHwgIXN0cmNtcChidWZmLCAi
MCIpKQorICAgICAgICAgICAgICAgICppbnRfcHRyID0gRVJSX0NIRUNLU19PRkY7CisgICAgICAg
IGVsc2UgaWYgKCgqaW50X3B0ciA9IGF0b2koYnVmZikpIDwgMSkKKyAgICAgICAgICAgICAgICAq
aW50X3B0ciA9IEVSUl9DSEVDS1NfVU5ERUY7CisKKyAgICAgICAgRlJFRShidWZmKTsKKyAgICAg
ICAgcmV0dXJuIDA7Cit9CisKK2ludAorcHJpbnRfcGF0aF9lcnJfaW5mbyhjaGFyICogYnVmZiwg
aW50IGxlbiwgdm9pZCAqcHRyKQoreworICAgICAgICBpbnQgKmludF9wdHIgPSAoaW50ICopcHRy
OworCisgICAgICAgIHN3aXRjaCgqaW50X3B0cikgeworICAgICAgICBjYXNlIEVSUl9DSEVDS1Nf
VU5ERUY6CisgICAgICAgICAgICAgICAgcmV0dXJuIDA7CisgICAgICAgIGNhc2UgRVJSX0NIRUNL
U19PRkY6CisgICAgICAgICAgICAgICAgcmV0dXJuIHNucHJpbnRmKGJ1ZmYsIGxlbiwgIlwib2Zm
XCIiKTsKKyAgICAgICAgZGVmYXVsdDoKKyAgICAgICAgICAgICAgICByZXR1cm4gc25wcmludGYo
YnVmZiwgbGVuLCAiJWkiLCAqaW50X3B0cik7CisgICAgICAgIH0KK30KKworCisKKworCitkZWNs
YXJlX2RlZl9oYW5kbGVyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHNldF9wYXRoX2Vycl9pbmZv
KQorZGVjbGFyZV9kZWZfc25wcmludChzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBwcmludF9wYXRo
X2Vycl9pbmZvKQorZGVjbGFyZV9vdnJfaGFuZGxlcihzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBz
ZXRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfb3ZyX3NucHJpbnQoc2FuX3BhdGhfZXJyX3RocmVz
aG9sZCwgcHJpbnRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfaHdfaGFuZGxlcihzYW5fcGF0aF9l
cnJfdGhyZXNob2xkLCBzZXRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfaHdfc25wcmludChzYW5f
cGF0aF9lcnJfdGhyZXNob2xkLCBwcmludF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9tcF9oYW5k
bGVyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9t
cF9zbnByaW50KHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHByaW50X3BhdGhfZXJyX2luZm8pCisK
K2RlY2xhcmVfZGVmX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3csIHNldF9w
YXRoX2Vycl9pbmZvKQorZGVjbGFyZV9kZWZfc25wcmludChzYW5fcGF0aF9lcnJfdGhyZXNob2xk
X3dpbmRvdywgcHJpbnRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfb3ZyX2hhbmRsZXIoc2FuX3Bh
dGhfZXJyX3RocmVzaG9sZF93aW5kb3csIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9vdnJf
c25wcmludChzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdywgcHJpbnRfcGF0aF9lcnJfaW5m
bykKK2RlY2xhcmVfaHdfaGFuZGxlcihzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdywgc2V0
X3BhdGhfZXJyX2luZm8pCitkZWNsYXJlX2h3X3NucHJpbnQoc2FuX3BhdGhfZXJyX3RocmVzaG9s
ZF93aW5kb3csIHByaW50X3BhdGhfZXJyX2luZm8pCitkZWNsYXJlX21wX2hhbmRsZXIoc2FuX3Bh
dGhfZXJyX3RocmVzaG9sZF93aW5kb3csIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9tcF9z
bnByaW50KHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93LCBwcmludF9wYXRoX2Vycl9pbmZv
KQorCisKK2RlY2xhcmVfZGVmX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIHNl
dF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9kZWZfc25wcmludChzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZSwgcHJpbnRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfb3ZyX2hhbmRsZXIoc2FuX3Bh
dGhfZXJyX3JlY292ZXJ5X3RpbWUsIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9vdnJfc25w
cmludChzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSwgcHJpbnRfcGF0aF9lcnJfaW5mbykKK2Rl
Y2xhcmVfaHdfaGFuZGxlcihzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSwgc2V0X3BhdGhfZXJy
X2luZm8pCitkZWNsYXJlX2h3X3NucHJpbnQoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIHBy
aW50X3BhdGhfZXJyX2luZm8pCitkZWNsYXJlX21wX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWUsIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9tcF9zbnByaW50KHNhbl9wYXRo
X2Vycl9yZWNvdmVyeV90aW1lLCBwcmludF9wYXRoX2Vycl9pbmZvKQogc3RhdGljIGludAogZGVm
X3V4c29ja190aW1lb3V0X2hhbmRsZXIoc3RydWN0IGNvbmZpZyAqY29uZiwgdmVjdG9yIHN0cnZl
YykKIHsKQEAgLTE0MDQsNiArMTQ3MCwxMCBAQCBpbml0X2tleXdvcmRzKHZlY3RvciBrZXl3b3Jk
cykKIAlpbnN0YWxsX2tleXdvcmQoImNvbmZpZ19kaXIiLCAmZGVmX2NvbmZpZ19kaXJfaGFuZGxl
ciwgJnNucHJpbnRfZGVmX2NvbmZpZ19kaXIpOwogCWluc3RhbGxfa2V5d29yZCgiZGVsYXlfd2F0
Y2hfY2hlY2tzIiwgJmRlZl9kZWxheV93YXRjaF9jaGVja3NfaGFuZGxlciwgJnNucHJpbnRfZGVm
X2RlbGF5X3dhdGNoX2NoZWNrcyk7CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNr
cyIsICZkZWZfZGVsYXlfd2FpdF9jaGVja3NfaGFuZGxlciwgJnNucHJpbnRfZGVmX2RlbGF5X3dh
aXRfY2hlY2tzKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfdGhyZXNo
b2xkIiwgJmRlZl9zYW5fcGF0aF9lcnJfdGhyZXNob2xkX2hhbmRsZXIsICZzbnByaW50X2RlZl9z
YW5fcGF0aF9lcnJfdGhyZXNob2xkKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0
aF9lcnJfdGhyZXNob2xkX3dpbmRvdyIsICZkZWZfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5k
b3dfaGFuZGxlciwgJnNucHJpbnRfZGVmX3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KTsK
KyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSIsICZk
ZWZfc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWVfaGFuZGxlciwgJnNucHJpbnRfZGVmX3Nhbl9w
YXRoX2Vycl9yZWNvdmVyeV90aW1lKTsKKwogCWluc3RhbGxfa2V5d29yZCgiZmluZF9tdWx0aXBh
dGhzIiwgJmRlZl9maW5kX211bHRpcGF0aHNfaGFuZGxlciwgJnNucHJpbnRfZGVmX2ZpbmRfbXVs
dGlwYXRocyk7CiAJaW5zdGFsbF9rZXl3b3JkKCJ1eHNvY2tfdGltZW91dCIsICZkZWZfdXhzb2Nr
X3RpbWVvdXRfaGFuZGxlciwgJnNucHJpbnRfZGVmX3V4c29ja190aW1lb3V0KTsKIAlpbnN0YWxs
X2tleXdvcmQoInJldHJpZ2dlcl90cmllcyIsICZkZWZfcmV0cmlnZ2VyX3RyaWVzX2hhbmRsZXIs
ICZzbnByaW50X2RlZl9yZXRyaWdnZXJfdHJpZXMpOwpAQCAtMTQ4Niw2ICsxNTU2LDkgQEAgaW5p
dF9rZXl3b3Jkcyh2ZWN0b3Iga2V5d29yZHMpCiAJaW5zdGFsbF9rZXl3b3JkKCJkZWZlcnJlZF9y
ZW1vdmUiLCAmaHdfZGVmZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZzbnByaW50X2h3X2RlZmVycmVk
X3JlbW92ZSk7CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YXRjaF9jaGVja3MiLCAmaHdfZGVs
YXlfd2F0Y2hfY2hlY2tzX2hhbmRsZXIsICZzbnByaW50X2h3X2RlbGF5X3dhdGNoX2NoZWNrcyk7
CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZod19kZWxheV93YWl0X2No
ZWNrc19oYW5kbGVyLCAmc25wcmludF9od19kZWxheV93YWl0X2NoZWNrcyk7CisgICAgICAgIGlu
c3RhbGxfa2V5d29yZCgic2FuX3BhdGhfZXJyX3RocmVzaG9sZCIsICZod19zYW5fcGF0aF9lcnJf
dGhyZXNob2xkX2hhbmRsZXIsICZzbnByaW50X2h3X3Nhbl9wYXRoX2Vycl90aHJlc2hvbGQpOwor
ICAgICAgICBpbnN0YWxsX2tleXdvcmQoInNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93Iiwg
Jmh3X3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93X2hhbmRsZXIsICZzbnByaW50X2h3X3Nh
bl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJz
YW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSIsICZod19zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGlt
ZV9oYW5kbGVyLCAmc25wcmludF9od19zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CiAJaW5z
dGFsbF9rZXl3b3JkKCJza2lwX2twYXJ0eCIsICZod19za2lwX2twYXJ0eF9oYW5kbGVyLCAmc25w
cmludF9od19za2lwX2twYXJ0eCk7CiAJaW5zdGFsbF9rZXl3b3JkKCJtYXhfc2VjdG9yc19rYiIs
ICZod19tYXhfc2VjdG9yc19rYl9oYW5kbGVyLCAmc25wcmludF9od19tYXhfc2VjdG9yc19rYik7
CiAJaW5zdGFsbF9zdWJsZXZlbF9lbmQoKTsKQEAgLTE1MTUsNiArMTU4OCwxMCBAQCBpbml0X2tl
eXdvcmRzKHZlY3RvciBrZXl3b3JkcykKIAlpbnN0YWxsX2tleXdvcmQoImRlZmVycmVkX3JlbW92
ZSIsICZvdnJfZGVmZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZzbnByaW50X292cl9kZWZlcnJlZF9y
ZW1vdmUpOwogCWluc3RhbGxfa2V5d29yZCgiZGVsYXlfd2F0Y2hfY2hlY2tzIiwgJm92cl9kZWxh
eV93YXRjaF9jaGVja3NfaGFuZGxlciwgJnNucHJpbnRfb3ZyX2RlbGF5X3dhdGNoX2NoZWNrcyk7
CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZvdnJfZGVsYXlfd2FpdF9j
aGVja3NfaGFuZGxlciwgJnNucHJpbnRfb3ZyX2RlbGF5X3dhaXRfY2hlY2tzKTsKKyAgICAgICAg
aW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfdGhyZXNob2xkIiwgJm92cl9zYW5fcGF0aF9l
cnJfdGhyZXNob2xkX2hhbmRsZXIsICZzbnByaW50X292cl9zYW5fcGF0aF9lcnJfdGhyZXNob2xk
KTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRv
dyIsICZvdnJfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3dfaGFuZGxlciwgJnNucHJpbnRf
b3ZyX3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KTsKKyAgICAgICAgaW5zdGFsbF9rZXl3
b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSIsICZvdnJfc2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWVfaGFuZGxlciwgJnNucHJpbnRfb3ZyX3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1l
KTsKKwogCWluc3RhbGxfa2V5d29yZCgic2tpcF9rcGFydHgiLCAmb3ZyX3NraXBfa3BhcnR4X2hh
bmRsZXIsICZzbnByaW50X292cl9za2lwX2twYXJ0eCk7CiAJaW5zdGFsbF9rZXl3b3JkKCJtYXhf
c2VjdG9yc19rYiIsICZvdnJfbWF4X3NlY3RvcnNfa2JfaGFuZGxlciwgJnNucHJpbnRfb3ZyX21h
eF9zZWN0b3JzX2tiKTsKIApAQCAtMTU0Myw2ICsxNjIwLDkgQEAgaW5pdF9rZXl3b3Jkcyh2ZWN0
b3Iga2V5d29yZHMpCiAJaW5zdGFsbF9rZXl3b3JkKCJkZWZlcnJlZF9yZW1vdmUiLCAmbXBfZGVm
ZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZzbnByaW50X21wX2RlZmVycmVkX3JlbW92ZSk7CiAJaW5z
dGFsbF9rZXl3b3JkKCJkZWxheV93YXRjaF9jaGVja3MiLCAmbXBfZGVsYXlfd2F0Y2hfY2hlY2tz
X2hhbmRsZXIsICZzbnByaW50X21wX2RlbGF5X3dhdGNoX2NoZWNrcyk7CiAJaW5zdGFsbF9rZXl3
b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZtcF9kZWxheV93YWl0X2NoZWNrc19oYW5kbGVyLCAm
c25wcmludF9tcF9kZWxheV93YWl0X2NoZWNrcyk7CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0
aF9lcnJfdGhyZXNob2xkIiwgJm1wX3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfaGFuZGxlciwgJnNu
cHJpbnRfbXBfc2FuX3BhdGhfZXJyX3RocmVzaG9sZCk7CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5f
cGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyIsICZtcF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dp
bmRvd19oYW5kbGVyLCAmc25wcmludF9tcF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyk7
CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSIsICZtcF9zYW5f
cGF0aF9lcnJfcmVjb3ZlcnlfdGltZV9oYW5kbGVyLCAmc25wcmludF9tcF9zYW5fcGF0aF9lcnJf
cmVjb3ZlcnlfdGltZSk7CiAJaW5zdGFsbF9rZXl3b3JkKCJza2lwX2twYXJ0eCIsICZtcF9za2lw
X2twYXJ0eF9oYW5kbGVyLCAmc25wcmludF9tcF9za2lwX2twYXJ0eCk7CiAJaW5zdGFsbF9rZXl3
b3JkKCJtYXhfc2VjdG9yc19rYiIsICZtcF9tYXhfc2VjdG9yc19rYl9oYW5kbGVyLCAmc25wcmlu
dF9tcF9tYXhfc2VjdG9yc19rYik7CiAJaW5zdGFsbF9zdWJsZXZlbF9lbmQoKTsKZGlmZiAtLWdp
dCBhL2xpYm11bHRpcGF0aC9kaWN0LmggYi9saWJtdWx0aXBhdGgvZGljdC5oCmluZGV4IDRjZDAz
YzUuLmFkYWE5ZjEgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9kaWN0LmgKKysrIGIvbGlibXVs
dGlwYXRoL2RpY3QuaApAQCAtMTUsNSArMTUsNiBAQCBpbnQgcHJpbnRfZmFzdF9pb19mYWlsKGNo
YXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpOwogaW50IHByaW50X2Rldl9sb3NzKGNoYXIg
KiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpOwogaW50IHByaW50X3Jlc2VydmF0aW9uX2tleShj
aGFyICogYnVmZiwgaW50IGxlbiwgdm9pZCAqIHB0cik7CiBpbnQgcHJpbnRfZGVsYXlfY2hlY2tz
KGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpOworaW50IHByaW50X3BhdGhfZXJyX2lu
Zm8oY2hhciAqIGJ1ZmYsIGludCBsZW4sIHZvaWQgKnB0cik7CiAKICNlbmRpZiAvKiBfRElDVF9I
ICovCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvcHJvcHNlbC5jIGIvbGlibXVsdGlwYXRoL3By
b3BzZWwuYwppbmRleCBjMGJjNjE2Li5mNGNhMzc4IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
cHJvcHNlbC5jCisrKyBiL2xpYm11bHRpcGF0aC9wcm9wc2VsLmMKQEAgLTY0Myw3ICs2NDMsNTEg
QEAgb3V0OgogCXJldHVybiAwOwogCiB9CitpbnQgc2VsZWN0X3Nhbl9wYXRoX2Vycl90aHJlc2hv
bGQoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXApCit7CisgICAgICAg
IGNoYXIgKm9yaWdpbiwgYnVmZlsxMl07CisKKyAgICAgICAgbXBfc2V0X21wZShzYW5fcGF0aF9l
cnJfdGhyZXNob2xkKTsKKyAgICAgICAgbXBfc2V0X292cihzYW5fcGF0aF9lcnJfdGhyZXNob2xk
KTsKKyAgICAgICAgbXBfc2V0X2h3ZShzYW5fcGF0aF9lcnJfdGhyZXNob2xkKTsKKyAgICAgICAg
bXBfc2V0X2NvbmYoc2FuX3BhdGhfZXJyX3RocmVzaG9sZCk7CisgICAgICAgIG1wX3NldF9kZWZh
dWx0KHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIERFRkFVTFRfRVJSX0NIRUNLUyk7CitvdXQ6Cisg
ICAgICAgIHByaW50X3BhdGhfZXJyX2luZm8oYnVmZiwgMTIsICZtcC0+c2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZCk7CisgICAgICAgIGNvbmRsb2coMywgIiVzOiBzYW5fcGF0aF9lcnJfdGhyZXNob2xk
ID0gJXMgJXMiLCBtcC0+YWxpYXMsIGJ1ZmYsIG9yaWdpbik7CisgICAgICAgIHJldHVybiAwOwor
fQorCitpbnQgc2VsZWN0X3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KHN0cnVjdCBjb25m
aWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKm1wKQoreworICAgICAgICBjaGFyICpvcmlnaW4s
IGJ1ZmZbMTJdOworCisgICAgICAgIG1wX3NldF9tcGUoc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93
aW5kb3cpOworICAgICAgICBtcF9zZXRfb3ZyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93
KTsKKyAgICAgICAgbXBfc2V0X2h3ZShzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyk7Cisg
ICAgICAgIG1wX3NldF9jb25mKHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KTsKKyAgICAg
ICAgbXBfc2V0X2RlZmF1bHQoc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3csIERFRkFVTFRf
RVJSX0NIRUNLUyk7CitvdXQ6CisgICAgICAgIHByaW50X3BhdGhfZXJyX2luZm8oYnVmZiwgMTIs
ICZtcC0+c2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cpOworICAgICAgICBjb25kbG9nKDMs
ICIlczogc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cgPSAlcyAlcyIsIG1wLT5hbGlhcywg
YnVmZiwgb3JpZ2luKTsKKyAgICAgICAgcmV0dXJuIDA7CisKK30KK2ludCBzZWxlY3Rfc2FuX3Bh
dGhfZXJyX3JlY292ZXJ5X3RpbWUoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0
aCAqbXApCit7CisgICAgICAgIGNoYXIgKm9yaWdpbiwgYnVmZlsxMl07CiAKKyAgICAgICAgbXBf
c2V0X21wZShzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CisgICAgICAgIG1wX3NldF9vdnIo
c2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUpOworICAgICAgICBtcF9zZXRfaHdlKHNhbl9wYXRo
X2Vycl9yZWNvdmVyeV90aW1lKTsKKyAgICAgICAgbXBfc2V0X2NvbmYoc2FuX3BhdGhfZXJyX3Jl
Y292ZXJ5X3RpbWUpOworICAgICAgICBtcF9zZXRfZGVmYXVsdChzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZSwgREVGQVVMVF9FUlJfQ0hFQ0tTKTsKK291dDoKKyAgICAgICAgcHJpbnRfcGF0aF9l
cnJfaW5mbyhidWZmLCAxMiwgJm1wLT5zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CisgICAg
ICAgIGNvbmRsb2coMywgIiVzOiBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSA9ICVzICVzIiwg
bXAtPmFsaWFzLCBidWZmLCBvcmlnaW4pOworICAgICAgICByZXR1cm4gMDsKKworfQogaW50IHNl
bGVjdF9za2lwX2twYXJ0eCAoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAq
IG1wKQogewogCWNoYXIgKm9yaWdpbjsKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9wcm9wc2Vs
LmggYi9saWJtdWx0aXBhdGgvcHJvcHNlbC5oCmluZGV4IGFkOThmYTUuLjg4YjU4NDAgMTAwNjQ0
Ci0tLSBhL2xpYm11bHRpcGF0aC9wcm9wc2VsLmgKKysrIGIvbGlibXVsdGlwYXRoL3Byb3BzZWwu
aApAQCAtMjQsMyArMjQsOSBAQCBpbnQgc2VsZWN0X2RlbGF5X3dhdGNoX2NoZWNrcyAoc3RydWN0
IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqIG1wKTsKIGludCBzZWxlY3RfZGVsYXlf
d2FpdF9jaGVja3MgKHN0cnVjdCBjb25maWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKiBtcCk7
CiBpbnQgc2VsZWN0X3NraXBfa3BhcnR4IChzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3QgbXVs
dGlwYXRoICogbXApOwogaW50IHNlbGVjdF9tYXhfc2VjdG9yc19rYiAoc3RydWN0IGNvbmZpZyAq
Y29uZiwgc3RydWN0IG11bHRpcGF0aCAqIG1wKTsKK2ludCBzZWxlY3Rfc2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZF93aW5kb3coc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXAp
OworaW50IHNlbGVjdF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkKHN0cnVjdCBjb25maWcgKmNvbmYs
IHN0cnVjdCBtdWx0aXBhdGggKm1wKTsKK2ludCBzZWxlY3Rfc2FuX3BhdGhfZXJyX3JlY292ZXJ5
X3RpbWUoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXApOworCisKKwpk
aWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL3N0cnVjdHMuaCBiL2xpYm11bHRpcGF0aC9zdHJ1Y3Rz
LmgKaW5kZXggMzk2ZjY5ZC4uOGI3YTgwMyAxMDA2NDQKLS0tIGEvbGlibXVsdGlwYXRoL3N0cnVj
dHMuaAorKysgYi9saWJtdWx0aXBhdGgvc3RydWN0cy5oCkBAIC0xNTYsNiArMTU2LDEwIEBAIGVu
dW0gZGVsYXlfY2hlY2tzX3N0YXRlcyB7CiAJREVMQVlfQ0hFQ0tTX09GRiA9IC0xLAogCURFTEFZ
X0NIRUNLU19VTkRFRiA9IDAsCiB9OworZW51bSBlcnJfY2hlY2tzX3N0YXRlcyB7CisJRVJSX0NI
RUNLU19PRkYgPSAtMSwKKwlFUlJfQ0hFQ0tTX1VOREVGID0gMCwKK307CiAKIGVudW0gaW5pdGlh
bGl6ZWRfc3RhdGVzIHsKIAlJTklUX0ZBSUxFRCwKQEAgLTIyMyw3ICsyMjcsMTAgQEAgc3RydWN0
IHBhdGggewogCWludCBpbml0aWFsaXplZDsKIAlpbnQgcmV0cmlnZ2VyczsKIAlpbnQgd3dpZF9j
aGFuZ2VkOwotCisJdW5zaWduZWQgaW50IHBhdGhfZmFpbHVyZXM7CisJdGltZV90ICAgZmFpbHVy
ZV9zdGFydF90aW1lOworCXRpbWVfdCBkaXNfcmVpbnN0YW50ZV90aW1lOworCWludCBkaXNhYmxl
X3JlaW5zdGF0ZTsKIAkvKiBjb25maWdsZXQgcG9pbnRlcnMgKi8KIAlzdHJ1Y3QgaHdlbnRyeSAq
IGh3ZTsKIH07CkBAIC0yNTUsNiArMjYyLDkgQEAgc3RydWN0IG11bHRpcGF0aCB7CiAJaW50IGRl
ZmVycmVkX3JlbW92ZTsKIAlpbnQgZGVsYXlfd2F0Y2hfY2hlY2tzOwogCWludCBkZWxheV93YWl0
X2NoZWNrczsKKwlpbnQgc2FuX3BhdGhfZXJyX3RocmVzaG9sZDsKKwlpbnQgc2FuX3BhdGhfZXJy
X3RocmVzaG9sZF93aW5kb3c7CisJaW50IHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lOwogCWlu
dCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3NlY3RvcnNfa2I7CiAJdW5zaWduZWQgaW50IGRldl9s
b3NzOwpkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL3N0cnVjdHNfdmVjLmMgYi9saWJtdWx0aXBh
dGgvc3RydWN0c192ZWMuYwppbmRleCAyMmJlOGUwLi5iZjg0YjE3IDEwMDY0NAotLS0gYS9saWJt
dWx0aXBhdGgvc3RydWN0c192ZWMuYworKysgYi9saWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYwpA
QCAtNTQ2LDYgKzU0Niw3IEBAIGludCB1cGRhdGVfbXVsdGlwYXRoIChzdHJ1Y3QgdmVjdG9ycyAq
dmVjcywgY2hhciAqbWFwbmFtZSwgaW50IHJlc2V0KQogCXN0cnVjdCBwYXRoZ3JvdXAgICpwZ3A7
CiAJc3RydWN0IHBhdGggKnBwOwogCWludCBpLCBqOworCXN0cnVjdCB0aW1lc3BlYyBzdGFydF90
aW1lOwogCiAJbXBwID0gZmluZF9tcF9ieV9hbGlhcyh2ZWNzLT5tcHZlYywgbWFwbmFtZSk7CiAK
QEAgLTU3MCw2ICs1NzEsMTUgQEAgaW50IHVwZGF0ZV9tdWx0aXBhdGggKHN0cnVjdCB2ZWN0b3Jz
ICp2ZWNzLCBjaGFyICptYXBuYW1lLCBpbnQgcmVzZXQpCiAJCQkJaW50IG9sZHN0YXRlID0gcHAt
PnN0YXRlOwogCQkJCWNvbmRsb2coMiwgIiVzOiBtYXJrIGFzIGZhaWxlZCIsIHBwLT5kZXYpOwog
CQkJCW1wcC0+c3RhdF9wYXRoX2ZhaWx1cmVzKys7CisJCQkJLypDYXB0dXJlZCB0aGUgdGltZSB3
aGVuIHdlIHNlZSB0aGUgZmlyc3QgZmFpbHVyZSBvbiB0aGUgcGF0aCovCisJCQkJaWYocHAtPnBh
dGhfZmFpbHVyZXMgPT0gMCkgeworCQkJCQlpZiAoY2xvY2tfZ2V0dGltZShDTE9DS19NT05PVE9O
SUMsICZzdGFydF90aW1lKSAhPSAwKQorCQkJCQkJc3RhcnRfdGltZS50dl9zZWMgPSAwOworCQkJ
CQlwcC0+ZmFpbHVyZV9zdGFydF90aW1lID0gc3RhcnRfdGltZS50dl9zZWM7CisJCisJCQkJfQor
CQkJCS8qSW5jcmVtZW50IHRoZSBudW1iZXIgb2YgcGF0aCBmYWlsdXJlcyovCisJCQkJcHAtPnBh
dGhfZmFpbHVyZXMrKzsKIAkJCQlwcC0+c3RhdGUgPSBQQVRIX0RPV047CiAJCQkJaWYgKG9sZHN0
YXRlID09IFBBVEhfVVAgfHwKIAkJCQkgICAgb2xkc3RhdGUgPT0gUEFUSF9HSE9TVCkKZGlmZiAt
LWdpdCBhL211bHRpcGF0aC9tdWx0aXBhdGguY29uZi41IGIvbXVsdGlwYXRoL211bHRpcGF0aC5j
b25mLjUKaW5kZXggMzY1ODlmNS4uN2RmZDQ4YSAxMDA2NDQKLS0tIGEvbXVsdGlwYXRoL211bHRp
cGF0aC5jb25mLjUKKysrIGIvbXVsdGlwYXRoL211bHRpcGF0aC5jb25mLjUKQEAgLTc1MSw2ICs3
NTEsNDYgQEAgVGhlIGRlZmF1bHQgaXM6IFxmQi9ldGMvbXVsdGlwYXRoL2NvbmYuZC9cZlIKIC4K
IC4KIC5UUAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZAorSWYgc2V0IHRvIGEgdmFsdWUgZ3Jl
YXRlciB0aGFuIDAsIG11bHRpcGF0aGQgd2lsbCB3YXRjaCBwYXRocyBhbmQgY2hlY2sgaG93IG1h
bnkKK3RpbWVzIGEgcGF0aCBoYXMgYmVlbiBmYWlsZWQgZHVlIHRvIGVycm9ycy5JZiB0aGUgbnVt
YmVyIG9mIGZhaWx1cmVzIG9uIGEgcGFydGljdWxhcgorcGF0aCBpcyBncmVhdGVyIHRoZW4gdGhl
IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQgdGhlbiB0aGUgcGF0aCB3aWxsIG5vdCAgcmVpbnN0YW50
ZQordGlsbCBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZS5UaGVzZSBwYXRoIGZhaWx1cmVzIHNo
b3VsZCBvY2N1ciB3aXRoaW4gYSAKK3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93IHRpbWUg
ZnJhbWUsIGlmIG5vdCB3ZSB3aWxsIGNvbnNpZGVyIHRoZSBwYXRoIGlzIGdvb2QgZW5vdWdoCit0
byByZWluc3RhbnRhdGUuCisuUlMKKy5UUAorVGhlIGRlZmF1bHQgaXM6IFxmQm5vXGZSCisuUkUK
Ky4KKy4KKy5UUAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cKK0lmIHNldCB0byBh
IHZhbHVlIGdyZWF0ZXIgdGhhbiAwLCBtdWx0aXBhdGhkIHdpbGwgY2hlY2sgd2hldGhlciB0aGUg
cGF0aCBmYWlsdXJlcworaGFzIGV4Y2VlZGVkICB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9sZCB3
aXRoaW4gdGhpcyB0aW1lIGZyYW1lIGkuZSAKK3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93
IC4gSWYgc28gd2Ugd2lsbCBub3QgcmVpbnN0YW50ZSB0aGUgcGF0aCB0aWxsCitzYW5fcGF0aF9l
cnJfcmVjb3ZlcnlfdGltZS4KK3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93IHZhbHVlIHNo
b3VsZCBiZSBpbiBzZWNzLgorLlJTCisuVFAKK1RoZSBkZWZhdWx0IGlzOiBcZkJub1xmUgorLlJF
CisuCisuCisuVFAKKy5CIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCitJZiBzZXQgdG8gYSB2
YWx1ZSBncmVhdGVyIHRoYW4gMCwgbXVsdGlwYXRoZCB3aWxsIG1ha2Ugc3VyZSB0aGF0IHdoZW4g
cGF0aCBmYWlsdXJlcworaGFzIGV4Y2VlZGVkIHRoZSBzYW5fcGF0aF9lcnJfdGhyZXNob2xkIHdp
dGhpbiBzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyB0aGVuIHRoZSBwYXRoCit3aWxsIGJl
IHBsYWNlZCBpbiBmYWlsZWQgc3RhdGUgZm9yIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lIGR1
cmF0aW9uLk9uY2Ugc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUKK2hhcyB0aW1lb3V0ICB3ZSB3
aWxsIHJlaW5zdGFudGUgdGhlIGZhaWxlZCBwYXRoIC4KK3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90
aW1lIHZhbHVlIHNob3VsZCBiZSBpbiBzZWNzLgorLlJTCisuVFAKK1RoZSBkZWZhdWx0IGlzOiBc
ZkJub1xmUgorLlJFCisuCisuCisuVFAKIC5CIGRlbGF5X3dhdGNoX2NoZWNrcwogSWYgc2V0IHRv
IGEgdmFsdWUgZ3JlYXRlciB0aGFuIDAsIG11bHRpcGF0aGQgd2lsbCB3YXRjaCBwYXRocyB0aGF0
IGhhdmUKIHJlY2VudGx5IGJlY29tZSB2YWxpZCBmb3IgdGhpcyBtYW55IGNoZWNrcy4gSWYgdGhl
eSBmYWlsIGFnYWluIHdoaWxlIHRoZXkgYXJlCkBAIC0xMDE1LDYgKzEwNTUsMTIgQEAgYXJlIHRh
a2VuIGZyb20gdGhlIFxmSWRlZmF1bHRzXGZSIG9yIFxmSWRldmljZXNcZlIgc2VjdGlvbjoKIC5U
UAogLkIgZGVmZXJyZWRfcmVtb3ZlCiAuVFAKKy5CIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKy5U
UAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cKKy5UUAorLkIgc2FuX3BhdGhfZXJy
X3JlY292ZXJ5X3RpbWUKKy5UUAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5
X3dhaXRfY2hlY2tzCkBAIC0xMTI4LDYgKzExNzQsMTIgQEAgc2VjdGlvbjoKIC5UUAogLkIgZGVm
ZXJyZWRfcmVtb3ZlCiAuVFAKKy5CIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKy5UUAorLkIgc2Fu
X3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cKKy5UUAorLkIgc2FuX3BhdGhfZXJyX3JlY292ZXJ5
X3RpbWUKKy5UUAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5X3dhaXRfY2hl
Y2tzCkBAIC0xMTkyLDYgKzEyNDQsMTIgQEAgdGhlIHZhbHVlcyBhcmUgdGFrZW4gZnJvbSB0aGUg
XGZJZGV2aWNlc1xmUiBvciBcZklkZWZhdWx0c1xmUiBzZWN0aW9uczoKIC5UUAogLkIgZGVmZXJy
ZWRfcmVtb3ZlCiAuVFAKKy5CIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKy5UUAorLkIgc2FuX3Bh
dGhfZXJyX3RocmVzaG9sZF93aW5kb3cKKy5UUAorLkIgc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3Rp
bWUKKy5UUAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5X3dhaXRfY2hlY2tz
CmRpZmYgLS1naXQgYS9tdWx0aXBhdGhkL21haW4uYyBiL211bHRpcGF0aGQvbWFpbi5jCmluZGV4
IGFkYzMyNTguLmZhY2ZjMDMgMTAwNjQ0Ci0tLSBhL211bHRpcGF0aGQvbWFpbi5jCisrKyBiL211
bHRpcGF0aGQvbWFpbi5jCkBAIC0xNDg2LDcgKzE0ODYsNTQgQEAgdm9pZCByZXBhaXJfcGF0aChz
dHJ1Y3QgcGF0aCAqIHBwKQogCWNoZWNrZXJfcmVwYWlyKCZwcC0+Y2hlY2tlcik7CiAJTE9HX01T
RygxLCBjaGVja2VyX21lc3NhZ2UoJnBwLT5jaGVja2VyKSk7CiB9CitzdGF0aWMgaW50IGNoZWNr
X3BhdGhfdmFsaWRpdHlfZXJyKCBzdHJ1Y3QgcGF0aCAqIHBwKXsKKwlzdHJ1Y3QgdGltZXNwZWMg
c3RhcnRfdGltZTsKKwlpbnQgZGlzYWJsZV9yZWluc3RhdGUgPSAwOworCisJaWYgKGNsb2NrX2dl
dHRpbWUoQ0xPQ0tfTU9OT1RPTklDLCAmc3RhcnRfdGltZSkgIT0gMCkKKwkJc3RhcnRfdGltZS50
dl9zZWMgPSAwOworCisJCS8qSWYgbnVtYmVyIG9mIHBhdGggZmFpbHVyZXMgYXJlIG1vcmUgdGhl
biB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9sZCovCisJCWlmKChwcC0+bXBwLT5zYW5fcGF0aF9l
cnJfdGhyZXNob2xkID4gMCkmJiAocHAtPnBhdGhfZmFpbHVyZXMgPiBwcC0+bXBwLT5zYW5fcGF0
aF9lcnJfdGhyZXNob2xkKSl7CisJCQljb25kbG9nKDMsIlxucGF0aCAlcyA6aGl0IHRoZSBlcnJv
ciB0aHJlc2hvbGRcbiIscHAtPmRldik7CisKKwkJCWlmKCFwcC0+ZGlzYWJsZV9yZWluc3RhdGUp
eworCQkJCS8qaWYgdGhlIGVycm9yIHRocmVzaG9sZCBoYXMgaGl0IGhpdCB3aXRoaW4gdGhlIHNh
bl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93CisJCQkJICogdGltZSBmcmFtZSBkb25vdCByZWlu
c3RhbnRlIHRoZSBwYXRoIHRpbGwgdGhlIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCisJCQkJ
ICogcGxhY2UgdGhlIHBhdGggaW4gZmFpbGVkIHN0YXRlIHRpbGwgc2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWUgc28gdGhhdCB0aGUgCisJCQkJICogY3V0b21lciBjYW4gcmVjdGlmeSB0aGUgaXNz
dWUgd2l0aGluIHRoaXMgdGltZSAuT25jZSB0aGUgY29wbGV0aW9uIG9mIAorCQkJCSAqIHNhbl9w
YXRoX2Vycl9yZWNvdmVyeV90aW1lIGl0IHNob3VsZCBhdXRvbWF0aWNhbGx5IHJlaW5zdGFudGF0
ZSB0aGUgcGF0aAorCQkJCSAqICovCisJCQkJaWYoKHBwLT5tcHAtPnNhbl9wYXRoX2Vycl90aHJl
c2hvbGRfd2luZG93ID4gMCkgJiYgCisJCQkJICAgKChzdGFydF90aW1lLnR2X3NlYyAtIHBwLT5m
YWlsdXJlX3N0YXJ0X3RpbWUpIDwgcHAtPm1wcC0+c2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5k
b3cpKXsKKwkJCQkJY29uZGxvZygzLCJcbnBhdGggJXMgOmhpdCB0aGUgZXJyb3IgdGhyZXNob2xk
IHdpdGhpbiB0aGUgdGhyc2hvbGQgd2luZG93IHRpbWVcbiIscHAtPmRldik7CisJCQkJCWRpc2Fi
bGVfcmVpbnN0YXRlID0gMTsgCisJCQkJCXBwLT5kaXNfcmVpbnN0YW50ZV90aW1lID0gc3RhcnRf
dGltZS50dl9zZWMgOworCQkJCQlwcC0+ZGlzYWJsZV9yZWluc3RhdGUgPSAxOworCQkJCX1lbHNl
eworCQkJCQkvKmV2ZW4gdGhvdWdoIHRoZSBudW1iZXIgb2YgZXJyb3JzIGFyZSBncmVhdGVyIHRo
ZW4gdGhlIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKwkJCQkJICpzaW5jZSBpdCBkb2Vzbm90IGhp
dCB3aXRoaW4gdGhlIHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93IHRpbWUgIHdlIHNob3Vs
ZCBub3QgdGFrZSB0aGVzZQorCQkJCQkgKiBlcnJyb3MgaW50byBhY2NvdW50IGFuZCB3ZSBoYXZl
IHRvIHJld2F0Y2ggdGhlIGVycm9ycworCQkJCQkgKi8KKwkJCQkJcHAtPnBhdGhfZmFpbHVyZXMg
PSAwOworCQkJCQlwcC0+ZGlzYWJsZV9yZWluc3RhdGUgPSAwOworCisJCQkJfQorCQkJfQorCQkJ
aWYocHAtPmRpc2FibGVfcmVpbnN0YXRlKXsKKwkJCQlkaXNhYmxlX3JlaW5zdGF0ZSA9IDE7CisJ
CQkJaWYoKHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lID4gMCkgJiYgCisJCQkJ
ICAgKHN0YXJ0X3RpbWUudHZfc2VjIC0gcHAtPmRpc19yZWluc3RhbnRlX3RpbWUgKSA+IHBwLT5t
cHAtPnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKXsKKwkJCQkJZGlzYWJsZV9yZWluc3RhdGUg
PTA7CisJCQkJCXBwLT5wYXRoX2ZhaWx1cmVzID0gMDsKKwkJCQkJcHAtPmRpc2FibGVfcmVpbnN0
YXRlID0gMDsKKwkJCQkJIGNvbmRsb2coMywiXG5wYXRoICVzIDpyZWluc3RhdGUgdGhlIHBhdGgg
YWZ0ZXIgZXJyIHJlY292ZXJ5IHRpbWVcbiIscHAtPmRldik7CisJCQkJfQogCisJCQl9CisJCX0K
KwlyZXR1cm4gIGRpc2FibGVfcmVpbnN0YXRlOworfQogLyoKICAqIFJldHVybnMgJzEnIGlmIHRo
ZSBwYXRoIGhhcyBiZWVuIGNoZWNrZWQsICctMScgaWYgaXQgd2FzIGJsYWNrbGlzdGVkCiAgKiBh
bmQgJzAnIG90aGVyd2lzZQpAQCAtMTUwMyw3ICsxNTUwLDExIEBAIGNoZWNrX3BhdGggKHN0cnVj
dCB2ZWN0b3JzICogdmVjcywgc3RydWN0IHBhdGggKiBwcCwgaW50IHRpY2tzKQogCWludCByZXRy
aWdnZXJfdHJpZXMsIGNoZWNraW50OwogCXN0cnVjdCBjb25maWcgKmNvbmY7CiAJaW50IHJldDsK
KwlzdHJ1Y3QgdGltZXNwZWMgc3RhcnRfdGltZTsKIAorCWlmIChjbG9ja19nZXR0aW1lKENMT0NL
X01PTk9UT05JQywgJnN0YXJ0X3RpbWUpICE9IDApCisJCXN0YXJ0X3RpbWUudHZfc2VjID0gMDsK
KwkKIAlpZiAoKHBwLT5pbml0aWFsaXplZCA9PSBJTklUX09LIHx8CiAJICAgICBwcC0+aW5pdGlh
bGl6ZWQgPT0gSU5JVF9SRVFVRVNURURfVURFVikgJiYgIXBwLT5tcHApCiAJCXJldHVybiAwOwpA
QCAtMTYxNSwxMiArMTY2NiwxOCBAQCBjaGVja19wYXRoIChzdHJ1Y3QgdmVjdG9ycyAqIHZlY3Ms
IHN0cnVjdCBwYXRoICogcHAsIGludCB0aWNrcykKIAkgKiBhbmQgaWYgdGFyZ2V0IHN1cHBvcnRz
IG9ubHkgaW1wbGljaXQgdHBncyBtb2RlLgogCSAqIHRoaXMgd2lsbCBwcmV2ZW50IHVubmVjZXNz
YXJ5IGkvbyBieSBkbSBvbiBzdGFuZC1ieQogCSAqIHBhdGhzIGlmIHRoZXJlIGFyZSBubyBvdGhl
ciBhY3RpdmUgcGF0aHMgaW4gbWFwLgorCSAqCisJICogd2hlbiBwYXRoIGZhaWx1cmVzIGhhcyBl
eGNlZWRlZCB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9sZCAKKwkgKiB3aXRoaW4gc2FuX3BhdGhf
ZXJyX3RocmVzaG9sZF93aW5kb3cgdGhlbiB3ZSBkb24ndCByZWluc3RhdGUKKwkgKiBmYWlsZWQg
cGF0aCBmb3Igc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUKIAkgKi8KLQlkaXNhYmxlX3JlaW5z
dGF0ZSA9IChuZXdzdGF0ZSA9PSBQQVRIX0dIT1NUICYmCisJZGlzYWJsZV9yZWluc3RhdGUgPSAo
KG5ld3N0YXRlID09IFBBVEhfR0hPU1QgJiYKIAkJCSAgICBwcC0+bXBwLT5ucl9hY3RpdmUgPT0g
MCAmJgotCQkJICAgIHBwLT50cGdzID09IFRQR1NfSU1QTElDSVQpID8gMSA6IDA7CisJCQkgICAg
cHAtPnRwZ3MgPT0gVFBHU19JTVBMSUNJVCkgPyAxIDoKKwkJCSAgICBjaGVja19wYXRoX3ZhbGlk
aXR5X2VycihwcCkpOwogCiAJcHAtPmNoa3JzdGF0ZSA9IG5ld3N0YXRlOworCiAJaWYgKG5ld3N0
YXRlICE9IHBwLT5zdGF0ZSkgewogCQlpbnQgb2xkc3RhdGUgPSBwcC0+c3RhdGU7CiAJCXBwLT5z
dGF0ZSA9IG5ld3N0YXRlOwo=

--_005_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_
Content-Type: application/octet-stream; name="san_path_err.patch"
Content-Description: san_path_err.patch
Content-Disposition: attachment; filename="san_path_err.patch"; size=20594;
	creation-date="Mon, 16 Jan 2017 06:39:48 GMT";
	modification-date="Mon, 16 Jan 2017 06:30:13 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWcuYyBiL2xpYm11bHRpcGF0aC9jb25maWcu
YwppbmRleCAxNWRkYmQ4Li4xOWFkYjk3IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvY29uZmln
LmMKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZy5jCkBAIC0zNDgsNiArMzQ4LDkgQEAgbWVyZ2Vf
aHdlIChzdHJ1Y3QgaHdlbnRyeSAqIGRzdCwgc3RydWN0IGh3ZW50cnkgKiBzcmMpCiAJbWVyZ2Vf
bnVtKGRlbGF5X3dhaXRfY2hlY2tzKTsKIAltZXJnZV9udW0oc2tpcF9rcGFydHgpOwogCW1lcmdl
X251bShtYXhfc2VjdG9yc19rYik7CisJbWVyZ2VfbnVtKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQp
OworCW1lcmdlX251bShzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyk7CisJbWVyZ2VfbnVt
KHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKTsKIAogCS8qCiAJICogTWFrZSBzdXJlIGZlYXR1
cmVzIGlzIGNvbnNpc3RlbnQgd2l0aApkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL2NvbmZpZy5o
IGIvbGlibXVsdGlwYXRoL2NvbmZpZy5oCmluZGV4IDk2NzAwMjAuLjI5ODU5NTggMTAwNjQ0Ci0t
LSBhL2xpYm11bHRpcGF0aC9jb25maWcuaAorKysgYi9saWJtdWx0aXBhdGgvY29uZmlnLmgKQEAg
LTY1LDYgKzY1LDkgQEAgc3RydWN0IGh3ZW50cnkgewogCWludCBkZWZlcnJlZF9yZW1vdmU7CiAJ
aW50IGRlbGF5X3dhdGNoX2NoZWNrczsKIAlpbnQgZGVsYXlfd2FpdF9jaGVja3M7CisJaW50IHNh
bl9wYXRoX2Vycl90aHJlc2hvbGQ7CisJaW50IHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93
OworCWludCBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZTsKIAlpbnQgc2tpcF9rcGFydHg7CiAJ
aW50IG1heF9zZWN0b3JzX2tiOwogCWNoYXIgKiBibF9wcm9kdWN0OwpAQCAtOTMsNiArOTYsOSBA
QCBzdHJ1Y3QgbXBlbnRyeSB7CiAJaW50IGRlZmVycmVkX3JlbW92ZTsKIAlpbnQgZGVsYXlfd2F0
Y2hfY2hlY2tzOwogCWludCBkZWxheV93YWl0X2NoZWNrczsKKwlpbnQgc2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZDsKKwlpbnQgc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3c7CisJaW50IHNhbl9w
YXRoX2Vycl9yZWNvdmVyeV90aW1lOwogCWludCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3NlY3Rv
cnNfa2I7CiAJdWlkX3QgdWlkOwpAQCAtMTM4LDYgKzE0NCw5IEBAIHN0cnVjdCBjb25maWcgewog
CWludCBwcm9jZXNzZWRfbWFpbl9jb25maWc7CiAJaW50IGRlbGF5X3dhdGNoX2NoZWNrczsKIAlp
bnQgZGVsYXlfd2FpdF9jaGVja3M7CisJaW50IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQ7CisJaW50
IHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93OworCWludCBzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZTsKIAlpbnQgdXhzb2NrX3RpbWVvdXQ7CiAJaW50IHN0cmljdF90aW1pbmc7CiAJaW50
IHJldHJpZ2dlcl90cmllczsKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWd1cmUuYyBi
L2xpYm11bHRpcGF0aC9jb25maWd1cmUuYwppbmRleCBhMGZjYWQ5Li4wZjUwODI2IDEwMDY0NAot
LS0gYS9saWJtdWx0aXBhdGgvY29uZmlndXJlLmMKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZ3Vy
ZS5jCkBAIC0yOTQsNiArMjk0LDkgQEAgaW50IHNldHVwX21hcChzdHJ1Y3QgbXVsdGlwYXRoICpt
cHAsIGNoYXIgKnBhcmFtcywgaW50IHBhcmFtc19zaXplKQogCXNlbGVjdF9kZWZlcnJlZF9yZW1v
dmUoY29uZiwgbXBwKTsKIAlzZWxlY3RfZGVsYXlfd2F0Y2hfY2hlY2tzKGNvbmYsIG1wcCk7CiAJ
c2VsZWN0X2RlbGF5X3dhaXRfY2hlY2tzKGNvbmYsIG1wcCk7CisJc2VsZWN0X3Nhbl9wYXRoX2Vy
cl90aHJlc2hvbGQoY29uZiwgbXBwKTsKKwlzZWxlY3Rfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93
aW5kb3coY29uZiwgbXBwKTsKKwlzZWxlY3Rfc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUoY29u
ZiwgbXBwKTsKIAlzZWxlY3Rfc2tpcF9rcGFydHgoY29uZiwgbXBwKTsKIAlzZWxlY3RfbWF4X3Nl
Y3RvcnNfa2IoY29uZiwgbXBwKTsKIApkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL2RlZmF1bHRz
LmggYi9saWJtdWx0aXBhdGgvZGVmYXVsdHMuaAppbmRleCBiOWIwYTM3Li45ZTgwNTljIDEwMDY0
NAotLS0gYS9saWJtdWx0aXBhdGgvZGVmYXVsdHMuaAorKysgYi9saWJtdWx0aXBhdGgvZGVmYXVs
dHMuaApAQCAtMjQsNiArMjQsNyBAQAogI2RlZmluZSBERUZBVUxUX0RFVEVDVF9QUklPCURFVEVD
VF9QUklPX09OCiAjZGVmaW5lIERFRkFVTFRfREVGRVJSRURfUkVNT1ZFCURFRkVSUkVEX1JFTU9W
RV9PRkYKICNkZWZpbmUgREVGQVVMVF9ERUxBWV9DSEVDS1MJREVMQVlfQ0hFQ0tTX09GRgorI2Rl
ZmluZSBERUZBVUxUX0VSUl9DSEVDS1MJRVJSX0NIRUNLU19PRkYKICNkZWZpbmUgREVGQVVMVF9V
RVZFTlRfU1RBQ0tTSVpFIDI1NgogI2RlZmluZSBERUZBVUxUX1JFVFJJR0dFUl9ERUxBWQkxMAog
I2RlZmluZSBERUZBVUxUX1JFVFJJR0dFUl9UUklFUwkzCmRpZmYgLS1naXQgYS9saWJtdWx0aXBh
dGgvZGljdC5jIGIvbGlibXVsdGlwYXRoL2RpY3QuYwppbmRleCBkYzIxODQ2Li5hNTY4OWJkIDEw
MDY0NAotLS0gYS9saWJtdWx0aXBhdGgvZGljdC5jCisrKyBiL2xpYm11bHRpcGF0aC9kaWN0LmMK
QEAgLTEwNzQsNiArMTA3NCw3MiBAQCBkZWNsYXJlX2h3X3NucHJpbnQoZGVsYXlfd2FpdF9jaGVj
a3MsIHByaW50X2RlbGF5X2NoZWNrcykKIGRlY2xhcmVfbXBfaGFuZGxlcihkZWxheV93YWl0X2No
ZWNrcywgc2V0X2RlbGF5X2NoZWNrcykKIGRlY2xhcmVfbXBfc25wcmludChkZWxheV93YWl0X2No
ZWNrcywgcHJpbnRfZGVsYXlfY2hlY2tzKQogCisKK3N0YXRpYyBpbnQKK3NldF9wYXRoX2Vycl9p
bmZvKHZlY3RvciBzdHJ2ZWMsIHZvaWQgKnB0cikKK3sKKyAgICAgICAgaW50ICppbnRfcHRyID0g
KGludCAqKXB0cjsKKyAgICAgICAgY2hhciAqIGJ1ZmY7CisKKyAgICAgICAgYnVmZiA9IHNldF92
YWx1ZShzdHJ2ZWMpOworICAgICAgICBpZiAoIWJ1ZmYpCisgICAgICAgICAgICAgICAgcmV0dXJu
IDE7CisKKyAgICAgICAgaWYgKCFzdHJjbXAoYnVmZiwgIm5vIikgfHwgIXN0cmNtcChidWZmLCAi
MCIpKQorICAgICAgICAgICAgICAgICppbnRfcHRyID0gRVJSX0NIRUNLU19PRkY7CisgICAgICAg
IGVsc2UgaWYgKCgqaW50X3B0ciA9IGF0b2koYnVmZikpIDwgMSkKKyAgICAgICAgICAgICAgICAq
aW50X3B0ciA9IEVSUl9DSEVDS1NfVU5ERUY7CisKKyAgICAgICAgRlJFRShidWZmKTsKKyAgICAg
ICAgcmV0dXJuIDA7Cit9CisKK2ludAorcHJpbnRfcGF0aF9lcnJfaW5mbyhjaGFyICogYnVmZiwg
aW50IGxlbiwgdm9pZCAqcHRyKQoreworICAgICAgICBpbnQgKmludF9wdHIgPSAoaW50ICopcHRy
OworCisgICAgICAgIHN3aXRjaCgqaW50X3B0cikgeworICAgICAgICBjYXNlIEVSUl9DSEVDS1Nf
VU5ERUY6CisgICAgICAgICAgICAgICAgcmV0dXJuIDA7CisgICAgICAgIGNhc2UgRVJSX0NIRUNL
U19PRkY6CisgICAgICAgICAgICAgICAgcmV0dXJuIHNucHJpbnRmKGJ1ZmYsIGxlbiwgIlwib2Zm
XCIiKTsKKyAgICAgICAgZGVmYXVsdDoKKyAgICAgICAgICAgICAgICByZXR1cm4gc25wcmludGYo
YnVmZiwgbGVuLCAiJWkiLCAqaW50X3B0cik7CisgICAgICAgIH0KK30KKworCisKKworCitkZWNs
YXJlX2RlZl9oYW5kbGVyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHNldF9wYXRoX2Vycl9pbmZv
KQorZGVjbGFyZV9kZWZfc25wcmludChzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBwcmludF9wYXRo
X2Vycl9pbmZvKQorZGVjbGFyZV9vdnJfaGFuZGxlcihzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBz
ZXRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfb3ZyX3NucHJpbnQoc2FuX3BhdGhfZXJyX3RocmVz
aG9sZCwgcHJpbnRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfaHdfaGFuZGxlcihzYW5fcGF0aF9l
cnJfdGhyZXNob2xkLCBzZXRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfaHdfc25wcmludChzYW5f
cGF0aF9lcnJfdGhyZXNob2xkLCBwcmludF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9tcF9oYW5k
bGVyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9t
cF9zbnByaW50KHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHByaW50X3BhdGhfZXJyX2luZm8pCisK
K2RlY2xhcmVfZGVmX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3csIHNldF9w
YXRoX2Vycl9pbmZvKQorZGVjbGFyZV9kZWZfc25wcmludChzYW5fcGF0aF9lcnJfdGhyZXNob2xk
X3dpbmRvdywgcHJpbnRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfb3ZyX2hhbmRsZXIoc2FuX3Bh
dGhfZXJyX3RocmVzaG9sZF93aW5kb3csIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9vdnJf
c25wcmludChzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdywgcHJpbnRfcGF0aF9lcnJfaW5m
bykKK2RlY2xhcmVfaHdfaGFuZGxlcihzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdywgc2V0
X3BhdGhfZXJyX2luZm8pCitkZWNsYXJlX2h3X3NucHJpbnQoc2FuX3BhdGhfZXJyX3RocmVzaG9s
ZF93aW5kb3csIHByaW50X3BhdGhfZXJyX2luZm8pCitkZWNsYXJlX21wX2hhbmRsZXIoc2FuX3Bh
dGhfZXJyX3RocmVzaG9sZF93aW5kb3csIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9tcF9z
bnByaW50KHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93LCBwcmludF9wYXRoX2Vycl9pbmZv
KQorCisKK2RlY2xhcmVfZGVmX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIHNl
dF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9kZWZfc25wcmludChzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZSwgcHJpbnRfcGF0aF9lcnJfaW5mbykKK2RlY2xhcmVfb3ZyX2hhbmRsZXIoc2FuX3Bh
dGhfZXJyX3JlY292ZXJ5X3RpbWUsIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9vdnJfc25w
cmludChzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSwgcHJpbnRfcGF0aF9lcnJfaW5mbykKK2Rl
Y2xhcmVfaHdfaGFuZGxlcihzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSwgc2V0X3BhdGhfZXJy
X2luZm8pCitkZWNsYXJlX2h3X3NucHJpbnQoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIHBy
aW50X3BhdGhfZXJyX2luZm8pCitkZWNsYXJlX21wX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWUsIHNldF9wYXRoX2Vycl9pbmZvKQorZGVjbGFyZV9tcF9zbnByaW50KHNhbl9wYXRo
X2Vycl9yZWNvdmVyeV90aW1lLCBwcmludF9wYXRoX2Vycl9pbmZvKQogc3RhdGljIGludAogZGVm
X3V4c29ja190aW1lb3V0X2hhbmRsZXIoc3RydWN0IGNvbmZpZyAqY29uZiwgdmVjdG9yIHN0cnZl
YykKIHsKQEAgLTE0MDQsNiArMTQ3MCwxMCBAQCBpbml0X2tleXdvcmRzKHZlY3RvciBrZXl3b3Jk
cykKIAlpbnN0YWxsX2tleXdvcmQoImNvbmZpZ19kaXIiLCAmZGVmX2NvbmZpZ19kaXJfaGFuZGxl
ciwgJnNucHJpbnRfZGVmX2NvbmZpZ19kaXIpOwogCWluc3RhbGxfa2V5d29yZCgiZGVsYXlfd2F0
Y2hfY2hlY2tzIiwgJmRlZl9kZWxheV93YXRjaF9jaGVja3NfaGFuZGxlciwgJnNucHJpbnRfZGVm
X2RlbGF5X3dhdGNoX2NoZWNrcyk7CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNr
cyIsICZkZWZfZGVsYXlfd2FpdF9jaGVja3NfaGFuZGxlciwgJnNucHJpbnRfZGVmX2RlbGF5X3dh
aXRfY2hlY2tzKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfdGhyZXNo
b2xkIiwgJmRlZl9zYW5fcGF0aF9lcnJfdGhyZXNob2xkX2hhbmRsZXIsICZzbnByaW50X2RlZl9z
YW5fcGF0aF9lcnJfdGhyZXNob2xkKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0
aF9lcnJfdGhyZXNob2xkX3dpbmRvdyIsICZkZWZfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5k
b3dfaGFuZGxlciwgJnNucHJpbnRfZGVmX3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KTsK
KyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSIsICZk
ZWZfc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWVfaGFuZGxlciwgJnNucHJpbnRfZGVmX3Nhbl9w
YXRoX2Vycl9yZWNvdmVyeV90aW1lKTsKKwogCWluc3RhbGxfa2V5d29yZCgiZmluZF9tdWx0aXBh
dGhzIiwgJmRlZl9maW5kX211bHRpcGF0aHNfaGFuZGxlciwgJnNucHJpbnRfZGVmX2ZpbmRfbXVs
dGlwYXRocyk7CiAJaW5zdGFsbF9rZXl3b3JkKCJ1eHNvY2tfdGltZW91dCIsICZkZWZfdXhzb2Nr
X3RpbWVvdXRfaGFuZGxlciwgJnNucHJpbnRfZGVmX3V4c29ja190aW1lb3V0KTsKIAlpbnN0YWxs
X2tleXdvcmQoInJldHJpZ2dlcl90cmllcyIsICZkZWZfcmV0cmlnZ2VyX3RyaWVzX2hhbmRsZXIs
ICZzbnByaW50X2RlZl9yZXRyaWdnZXJfdHJpZXMpOwpAQCAtMTQ4Niw2ICsxNTU2LDkgQEAgaW5p
dF9rZXl3b3Jkcyh2ZWN0b3Iga2V5d29yZHMpCiAJaW5zdGFsbF9rZXl3b3JkKCJkZWZlcnJlZF9y
ZW1vdmUiLCAmaHdfZGVmZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZzbnByaW50X2h3X2RlZmVycmVk
X3JlbW92ZSk7CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YXRjaF9jaGVja3MiLCAmaHdfZGVs
YXlfd2F0Y2hfY2hlY2tzX2hhbmRsZXIsICZzbnByaW50X2h3X2RlbGF5X3dhdGNoX2NoZWNrcyk7
CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZod19kZWxheV93YWl0X2No
ZWNrc19oYW5kbGVyLCAmc25wcmludF9od19kZWxheV93YWl0X2NoZWNrcyk7CisgICAgICAgIGlu
c3RhbGxfa2V5d29yZCgic2FuX3BhdGhfZXJyX3RocmVzaG9sZCIsICZod19zYW5fcGF0aF9lcnJf
dGhyZXNob2xkX2hhbmRsZXIsICZzbnByaW50X2h3X3Nhbl9wYXRoX2Vycl90aHJlc2hvbGQpOwor
ICAgICAgICBpbnN0YWxsX2tleXdvcmQoInNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93Iiwg
Jmh3X3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93X2hhbmRsZXIsICZzbnByaW50X2h3X3Nh
bl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJz
YW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSIsICZod19zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGlt
ZV9oYW5kbGVyLCAmc25wcmludF9od19zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CiAJaW5z
dGFsbF9rZXl3b3JkKCJza2lwX2twYXJ0eCIsICZod19za2lwX2twYXJ0eF9oYW5kbGVyLCAmc25w
cmludF9od19za2lwX2twYXJ0eCk7CiAJaW5zdGFsbF9rZXl3b3JkKCJtYXhfc2VjdG9yc19rYiIs
ICZod19tYXhfc2VjdG9yc19rYl9oYW5kbGVyLCAmc25wcmludF9od19tYXhfc2VjdG9yc19rYik7
CiAJaW5zdGFsbF9zdWJsZXZlbF9lbmQoKTsKQEAgLTE1MTUsNiArMTU4OCwxMCBAQCBpbml0X2tl
eXdvcmRzKHZlY3RvciBrZXl3b3JkcykKIAlpbnN0YWxsX2tleXdvcmQoImRlZmVycmVkX3JlbW92
ZSIsICZvdnJfZGVmZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZzbnByaW50X292cl9kZWZlcnJlZF9y
ZW1vdmUpOwogCWluc3RhbGxfa2V5d29yZCgiZGVsYXlfd2F0Y2hfY2hlY2tzIiwgJm92cl9kZWxh
eV93YXRjaF9jaGVja3NfaGFuZGxlciwgJnNucHJpbnRfb3ZyX2RlbGF5X3dhdGNoX2NoZWNrcyk7
CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZvdnJfZGVsYXlfd2FpdF9j
aGVja3NfaGFuZGxlciwgJnNucHJpbnRfb3ZyX2RlbGF5X3dhaXRfY2hlY2tzKTsKKyAgICAgICAg
aW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfdGhyZXNob2xkIiwgJm92cl9zYW5fcGF0aF9l
cnJfdGhyZXNob2xkX2hhbmRsZXIsICZzbnByaW50X292cl9zYW5fcGF0aF9lcnJfdGhyZXNob2xk
KTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRv
dyIsICZvdnJfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3dfaGFuZGxlciwgJnNucHJpbnRf
b3ZyX3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KTsKKyAgICAgICAgaW5zdGFsbF9rZXl3
b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSIsICZvdnJfc2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWVfaGFuZGxlciwgJnNucHJpbnRfb3ZyX3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1l
KTsKKwogCWluc3RhbGxfa2V5d29yZCgic2tpcF9rcGFydHgiLCAmb3ZyX3NraXBfa3BhcnR4X2hh
bmRsZXIsICZzbnByaW50X292cl9za2lwX2twYXJ0eCk7CiAJaW5zdGFsbF9rZXl3b3JkKCJtYXhf
c2VjdG9yc19rYiIsICZvdnJfbWF4X3NlY3RvcnNfa2JfaGFuZGxlciwgJnNucHJpbnRfb3ZyX21h
eF9zZWN0b3JzX2tiKTsKIApAQCAtMTU0Myw2ICsxNjIwLDkgQEAgaW5pdF9rZXl3b3Jkcyh2ZWN0
b3Iga2V5d29yZHMpCiAJaW5zdGFsbF9rZXl3b3JkKCJkZWZlcnJlZF9yZW1vdmUiLCAmbXBfZGVm
ZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZzbnByaW50X21wX2RlZmVycmVkX3JlbW92ZSk7CiAJaW5z
dGFsbF9rZXl3b3JkKCJkZWxheV93YXRjaF9jaGVja3MiLCAmbXBfZGVsYXlfd2F0Y2hfY2hlY2tz
X2hhbmRsZXIsICZzbnByaW50X21wX2RlbGF5X3dhdGNoX2NoZWNrcyk7CiAJaW5zdGFsbF9rZXl3
b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZtcF9kZWxheV93YWl0X2NoZWNrc19oYW5kbGVyLCAm
c25wcmludF9tcF9kZWxheV93YWl0X2NoZWNrcyk7CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0
aF9lcnJfdGhyZXNob2xkIiwgJm1wX3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfaGFuZGxlciwgJnNu
cHJpbnRfbXBfc2FuX3BhdGhfZXJyX3RocmVzaG9sZCk7CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5f
cGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyIsICZtcF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dp
bmRvd19oYW5kbGVyLCAmc25wcmludF9tcF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyk7
CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSIsICZtcF9zYW5f
cGF0aF9lcnJfcmVjb3ZlcnlfdGltZV9oYW5kbGVyLCAmc25wcmludF9tcF9zYW5fcGF0aF9lcnJf
cmVjb3ZlcnlfdGltZSk7CiAJaW5zdGFsbF9rZXl3b3JkKCJza2lwX2twYXJ0eCIsICZtcF9za2lw
X2twYXJ0eF9oYW5kbGVyLCAmc25wcmludF9tcF9za2lwX2twYXJ0eCk7CiAJaW5zdGFsbF9rZXl3
b3JkKCJtYXhfc2VjdG9yc19rYiIsICZtcF9tYXhfc2VjdG9yc19rYl9oYW5kbGVyLCAmc25wcmlu
dF9tcF9tYXhfc2VjdG9yc19rYik7CiAJaW5zdGFsbF9zdWJsZXZlbF9lbmQoKTsKZGlmZiAtLWdp
dCBhL2xpYm11bHRpcGF0aC9kaWN0LmggYi9saWJtdWx0aXBhdGgvZGljdC5oCmluZGV4IDRjZDAz
YzUuLmFkYWE5ZjEgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9kaWN0LmgKKysrIGIvbGlibXVs
dGlwYXRoL2RpY3QuaApAQCAtMTUsNSArMTUsNiBAQCBpbnQgcHJpbnRfZmFzdF9pb19mYWlsKGNo
YXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpOwogaW50IHByaW50X2Rldl9sb3NzKGNoYXIg
KiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpOwogaW50IHByaW50X3Jlc2VydmF0aW9uX2tleShj
aGFyICogYnVmZiwgaW50IGxlbiwgdm9pZCAqIHB0cik7CiBpbnQgcHJpbnRfZGVsYXlfY2hlY2tz
KGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpOworaW50IHByaW50X3BhdGhfZXJyX2lu
Zm8oY2hhciAqIGJ1ZmYsIGludCBsZW4sIHZvaWQgKnB0cik7CiAKICNlbmRpZiAvKiBfRElDVF9I
ICovCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvcHJvcHNlbC5jIGIvbGlibXVsdGlwYXRoL3By
b3BzZWwuYwppbmRleCBjMGJjNjE2Li5mNGNhMzc4IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
cHJvcHNlbC5jCisrKyBiL2xpYm11bHRpcGF0aC9wcm9wc2VsLmMKQEAgLTY0Myw3ICs2NDMsNTEg
QEAgb3V0OgogCXJldHVybiAwOwogCiB9CitpbnQgc2VsZWN0X3Nhbl9wYXRoX2Vycl90aHJlc2hv
bGQoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXApCit7CisgICAgICAg
IGNoYXIgKm9yaWdpbiwgYnVmZlsxMl07CisKKyAgICAgICAgbXBfc2V0X21wZShzYW5fcGF0aF9l
cnJfdGhyZXNob2xkKTsKKyAgICAgICAgbXBfc2V0X292cihzYW5fcGF0aF9lcnJfdGhyZXNob2xk
KTsKKyAgICAgICAgbXBfc2V0X2h3ZShzYW5fcGF0aF9lcnJfdGhyZXNob2xkKTsKKyAgICAgICAg
bXBfc2V0X2NvbmYoc2FuX3BhdGhfZXJyX3RocmVzaG9sZCk7CisgICAgICAgIG1wX3NldF9kZWZh
dWx0KHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIERFRkFVTFRfRVJSX0NIRUNLUyk7CitvdXQ6Cisg
ICAgICAgIHByaW50X3BhdGhfZXJyX2luZm8oYnVmZiwgMTIsICZtcC0+c2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZCk7CisgICAgICAgIGNvbmRsb2coMywgIiVzOiBzYW5fcGF0aF9lcnJfdGhyZXNob2xk
ID0gJXMgJXMiLCBtcC0+YWxpYXMsIGJ1ZmYsIG9yaWdpbik7CisgICAgICAgIHJldHVybiAwOwor
fQorCitpbnQgc2VsZWN0X3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KHN0cnVjdCBjb25m
aWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKm1wKQoreworICAgICAgICBjaGFyICpvcmlnaW4s
IGJ1ZmZbMTJdOworCisgICAgICAgIG1wX3NldF9tcGUoc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93
aW5kb3cpOworICAgICAgICBtcF9zZXRfb3ZyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93
KTsKKyAgICAgICAgbXBfc2V0X2h3ZShzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyk7Cisg
ICAgICAgIG1wX3NldF9jb25mKHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93KTsKKyAgICAg
ICAgbXBfc2V0X2RlZmF1bHQoc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3csIERFRkFVTFRf
RVJSX0NIRUNLUyk7CitvdXQ6CisgICAgICAgIHByaW50X3BhdGhfZXJyX2luZm8oYnVmZiwgMTIs
ICZtcC0+c2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cpOworICAgICAgICBjb25kbG9nKDMs
ICIlczogc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cgPSAlcyAlcyIsIG1wLT5hbGlhcywg
YnVmZiwgb3JpZ2luKTsKKyAgICAgICAgcmV0dXJuIDA7CisKK30KK2ludCBzZWxlY3Rfc2FuX3Bh
dGhfZXJyX3JlY292ZXJ5X3RpbWUoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0
aCAqbXApCit7CisgICAgICAgIGNoYXIgKm9yaWdpbiwgYnVmZlsxMl07CiAKKyAgICAgICAgbXBf
c2V0X21wZShzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CisgICAgICAgIG1wX3NldF9vdnIo
c2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUpOworICAgICAgICBtcF9zZXRfaHdlKHNhbl9wYXRo
X2Vycl9yZWNvdmVyeV90aW1lKTsKKyAgICAgICAgbXBfc2V0X2NvbmYoc2FuX3BhdGhfZXJyX3Jl
Y292ZXJ5X3RpbWUpOworICAgICAgICBtcF9zZXRfZGVmYXVsdChzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZSwgREVGQVVMVF9FUlJfQ0hFQ0tTKTsKK291dDoKKyAgICAgICAgcHJpbnRfcGF0aF9l
cnJfaW5mbyhidWZmLCAxMiwgJm1wLT5zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CisgICAg
ICAgIGNvbmRsb2coMywgIiVzOiBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSA9ICVzICVzIiwg
bXAtPmFsaWFzLCBidWZmLCBvcmlnaW4pOworICAgICAgICByZXR1cm4gMDsKKworfQogaW50IHNl
bGVjdF9za2lwX2twYXJ0eCAoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAq
IG1wKQogewogCWNoYXIgKm9yaWdpbjsKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9wcm9wc2Vs
LmggYi9saWJtdWx0aXBhdGgvcHJvcHNlbC5oCmluZGV4IGFkOThmYTUuLjg4YjU4NDAgMTAwNjQ0
Ci0tLSBhL2xpYm11bHRpcGF0aC9wcm9wc2VsLmgKKysrIGIvbGlibXVsdGlwYXRoL3Byb3BzZWwu
aApAQCAtMjQsMyArMjQsOSBAQCBpbnQgc2VsZWN0X2RlbGF5X3dhdGNoX2NoZWNrcyAoc3RydWN0
IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqIG1wKTsKIGludCBzZWxlY3RfZGVsYXlf
d2FpdF9jaGVja3MgKHN0cnVjdCBjb25maWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKiBtcCk7
CiBpbnQgc2VsZWN0X3NraXBfa3BhcnR4IChzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3QgbXVs
dGlwYXRoICogbXApOwogaW50IHNlbGVjdF9tYXhfc2VjdG9yc19rYiAoc3RydWN0IGNvbmZpZyAq
Y29uZiwgc3RydWN0IG11bHRpcGF0aCAqIG1wKTsKK2ludCBzZWxlY3Rfc2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZF93aW5kb3coc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXAp
OworaW50IHNlbGVjdF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkKHN0cnVjdCBjb25maWcgKmNvbmYs
IHN0cnVjdCBtdWx0aXBhdGggKm1wKTsKK2ludCBzZWxlY3Rfc2FuX3BhdGhfZXJyX3JlY292ZXJ5
X3RpbWUoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXApOworCisKKwpk
aWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL3N0cnVjdHMuaCBiL2xpYm11bHRpcGF0aC9zdHJ1Y3Rz
LmgKaW5kZXggMzk2ZjY5ZC4uOGI3YTgwMyAxMDA2NDQKLS0tIGEvbGlibXVsdGlwYXRoL3N0cnVj
dHMuaAorKysgYi9saWJtdWx0aXBhdGgvc3RydWN0cy5oCkBAIC0xNTYsNiArMTU2LDEwIEBAIGVu
dW0gZGVsYXlfY2hlY2tzX3N0YXRlcyB7CiAJREVMQVlfQ0hFQ0tTX09GRiA9IC0xLAogCURFTEFZ
X0NIRUNLU19VTkRFRiA9IDAsCiB9OworZW51bSBlcnJfY2hlY2tzX3N0YXRlcyB7CisJRVJSX0NI
RUNLU19PRkYgPSAtMSwKKwlFUlJfQ0hFQ0tTX1VOREVGID0gMCwKK307CiAKIGVudW0gaW5pdGlh
bGl6ZWRfc3RhdGVzIHsKIAlJTklUX0ZBSUxFRCwKQEAgLTIyMyw3ICsyMjcsMTAgQEAgc3RydWN0
IHBhdGggewogCWludCBpbml0aWFsaXplZDsKIAlpbnQgcmV0cmlnZ2VyczsKIAlpbnQgd3dpZF9j
aGFuZ2VkOwotCisJdW5zaWduZWQgaW50IHBhdGhfZmFpbHVyZXM7CisJdGltZV90ICAgZmFpbHVy
ZV9zdGFydF90aW1lOworCXRpbWVfdCBkaXNfcmVpbnN0YW50ZV90aW1lOworCWludCBkaXNhYmxl
X3JlaW5zdGF0ZTsKIAkvKiBjb25maWdsZXQgcG9pbnRlcnMgKi8KIAlzdHJ1Y3QgaHdlbnRyeSAq
IGh3ZTsKIH07CkBAIC0yNTUsNiArMjYyLDkgQEAgc3RydWN0IG11bHRpcGF0aCB7CiAJaW50IGRl
ZmVycmVkX3JlbW92ZTsKIAlpbnQgZGVsYXlfd2F0Y2hfY2hlY2tzOwogCWludCBkZWxheV93YWl0
X2NoZWNrczsKKwlpbnQgc2FuX3BhdGhfZXJyX3RocmVzaG9sZDsKKwlpbnQgc2FuX3BhdGhfZXJy
X3RocmVzaG9sZF93aW5kb3c7CisJaW50IHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lOwogCWlu
dCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3NlY3RvcnNfa2I7CiAJdW5zaWduZWQgaW50IGRldl9s
b3NzOwpkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL3N0cnVjdHNfdmVjLmMgYi9saWJtdWx0aXBh
dGgvc3RydWN0c192ZWMuYwppbmRleCAyMmJlOGUwLi5iZjg0YjE3IDEwMDY0NAotLS0gYS9saWJt
dWx0aXBhdGgvc3RydWN0c192ZWMuYworKysgYi9saWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYwpA
QCAtNTQ2LDYgKzU0Niw3IEBAIGludCB1cGRhdGVfbXVsdGlwYXRoIChzdHJ1Y3QgdmVjdG9ycyAq
dmVjcywgY2hhciAqbWFwbmFtZSwgaW50IHJlc2V0KQogCXN0cnVjdCBwYXRoZ3JvdXAgICpwZ3A7
CiAJc3RydWN0IHBhdGggKnBwOwogCWludCBpLCBqOworCXN0cnVjdCB0aW1lc3BlYyBzdGFydF90
aW1lOwogCiAJbXBwID0gZmluZF9tcF9ieV9hbGlhcyh2ZWNzLT5tcHZlYywgbWFwbmFtZSk7CiAK
QEAgLTU3MCw2ICs1NzEsMTUgQEAgaW50IHVwZGF0ZV9tdWx0aXBhdGggKHN0cnVjdCB2ZWN0b3Jz
ICp2ZWNzLCBjaGFyICptYXBuYW1lLCBpbnQgcmVzZXQpCiAJCQkJaW50IG9sZHN0YXRlID0gcHAt
PnN0YXRlOwogCQkJCWNvbmRsb2coMiwgIiVzOiBtYXJrIGFzIGZhaWxlZCIsIHBwLT5kZXYpOwog
CQkJCW1wcC0+c3RhdF9wYXRoX2ZhaWx1cmVzKys7CisJCQkJLypDYXB0dXJlZCB0aGUgdGltZSB3
aGVuIHdlIHNlZSB0aGUgZmlyc3QgZmFpbHVyZSBvbiB0aGUgcGF0aCovCisJCQkJaWYocHAtPnBh
dGhfZmFpbHVyZXMgPT0gMCkgeworCQkJCQlpZiAoY2xvY2tfZ2V0dGltZShDTE9DS19NT05PVE9O
SUMsICZzdGFydF90aW1lKSAhPSAwKQorCQkJCQkJc3RhcnRfdGltZS50dl9zZWMgPSAwOworCQkJ
CQlwcC0+ZmFpbHVyZV9zdGFydF90aW1lID0gc3RhcnRfdGltZS50dl9zZWM7CisJCisJCQkJfQor
CQkJCS8qSW5jcmVtZW50IHRoZSBudW1iZXIgb2YgcGF0aCBmYWlsdXJlcyovCisJCQkJcHAtPnBh
dGhfZmFpbHVyZXMrKzsKIAkJCQlwcC0+c3RhdGUgPSBQQVRIX0RPV047CiAJCQkJaWYgKG9sZHN0
YXRlID09IFBBVEhfVVAgfHwKIAkJCQkgICAgb2xkc3RhdGUgPT0gUEFUSF9HSE9TVCkKZGlmZiAt
LWdpdCBhL211bHRpcGF0aC9tdWx0aXBhdGguY29uZi41IGIvbXVsdGlwYXRoL211bHRpcGF0aC5j
b25mLjUKaW5kZXggMzY1ODlmNS4uN2RmZDQ4YSAxMDA2NDQKLS0tIGEvbXVsdGlwYXRoL211bHRp
cGF0aC5jb25mLjUKKysrIGIvbXVsdGlwYXRoL211bHRpcGF0aC5jb25mLjUKQEAgLTc1MSw2ICs3
NTEsNDYgQEAgVGhlIGRlZmF1bHQgaXM6IFxmQi9ldGMvbXVsdGlwYXRoL2NvbmYuZC9cZlIKIC4K
IC4KIC5UUAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZAorSWYgc2V0IHRvIGEgdmFsdWUgZ3Jl
YXRlciB0aGFuIDAsIG11bHRpcGF0aGQgd2lsbCB3YXRjaCBwYXRocyBhbmQgY2hlY2sgaG93IG1h
bnkKK3RpbWVzIGEgcGF0aCBoYXMgYmVlbiBmYWlsZWQgZHVlIHRvIGVycm9ycy5JZiB0aGUgbnVt
YmVyIG9mIGZhaWx1cmVzIG9uIGEgcGFydGljdWxhcgorcGF0aCBpcyBncmVhdGVyIHRoZW4gdGhl
IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQgdGhlbiB0aGUgcGF0aCB3aWxsIG5vdCAgcmVpbnN0YW50
ZQordGlsbCBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZS5UaGVzZSBwYXRoIGZhaWx1cmVzIHNo
b3VsZCBvY2N1ciB3aXRoaW4gYSAKK3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93IHRpbWUg
ZnJhbWUsIGlmIG5vdCB3ZSB3aWxsIGNvbnNpZGVyIHRoZSBwYXRoIGlzIGdvb2QgZW5vdWdoCit0
byByZWluc3RhbnRhdGUuCisuUlMKKy5UUAorVGhlIGRlZmF1bHQgaXM6IFxmQm5vXGZSCisuUkUK
Ky4KKy4KKy5UUAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cKK0lmIHNldCB0byBh
IHZhbHVlIGdyZWF0ZXIgdGhhbiAwLCBtdWx0aXBhdGhkIHdpbGwgY2hlY2sgd2hldGhlciB0aGUg
cGF0aCBmYWlsdXJlcworaGFzIGV4Y2VlZGVkICB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9sZCB3
aXRoaW4gdGhpcyB0aW1lIGZyYW1lIGkuZSAKK3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93
IC4gSWYgc28gd2Ugd2lsbCBub3QgcmVpbnN0YW50ZSB0aGUgcGF0aCB0aWxsCitzYW5fcGF0aF9l
cnJfcmVjb3ZlcnlfdGltZS4KK3Nhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93IHZhbHVlIHNo
b3VsZCBiZSBpbiBzZWNzLgorLlJTCisuVFAKK1RoZSBkZWZhdWx0IGlzOiBcZkJub1xmUgorLlJF
CisuCisuCisuVFAKKy5CIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCitJZiBzZXQgdG8gYSB2
YWx1ZSBncmVhdGVyIHRoYW4gMCwgbXVsdGlwYXRoZCB3aWxsIG1ha2Ugc3VyZSB0aGF0IHdoZW4g
cGF0aCBmYWlsdXJlcworaGFzIGV4Y2VlZGVkIHRoZSBzYW5fcGF0aF9lcnJfdGhyZXNob2xkIHdp
dGhpbiBzYW5fcGF0aF9lcnJfdGhyZXNob2xkX3dpbmRvdyB0aGVuIHRoZSBwYXRoCit3aWxsIGJl
IHBsYWNlZCBpbiBmYWlsZWQgc3RhdGUgZm9yIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lIGR1
cmF0aW9uLk9uY2Ugc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUKK2hhcyB0aW1lb3V0ICB3ZSB3
aWxsIHJlaW5zdGFudGUgdGhlIGZhaWxlZCBwYXRoIC4KK3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90
aW1lIHZhbHVlIHNob3VsZCBiZSBpbiBzZWNzLgorLlJTCisuVFAKK1RoZSBkZWZhdWx0IGlzOiBc
ZkJub1xmUgorLlJFCisuCisuCisuVFAKIC5CIGRlbGF5X3dhdGNoX2NoZWNrcwogSWYgc2V0IHRv
IGEgdmFsdWUgZ3JlYXRlciB0aGFuIDAsIG11bHRpcGF0aGQgd2lsbCB3YXRjaCBwYXRocyB0aGF0
IGhhdmUKIHJlY2VudGx5IGJlY29tZSB2YWxpZCBmb3IgdGhpcyBtYW55IGNoZWNrcy4gSWYgdGhl
eSBmYWlsIGFnYWluIHdoaWxlIHRoZXkgYXJlCkBAIC0xMDE1LDYgKzEwNTUsMTIgQEAgYXJlIHRh
a2VuIGZyb20gdGhlIFxmSWRlZmF1bHRzXGZSIG9yIFxmSWRldmljZXNcZlIgc2VjdGlvbjoKIC5U
UAogLkIgZGVmZXJyZWRfcmVtb3ZlCiAuVFAKKy5CIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKy5U
UAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cKKy5UUAorLkIgc2FuX3BhdGhfZXJy
X3JlY292ZXJ5X3RpbWUKKy5UUAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5
X3dhaXRfY2hlY2tzCkBAIC0xMTI4LDYgKzExNzQsMTIgQEAgc2VjdGlvbjoKIC5UUAogLkIgZGVm
ZXJyZWRfcmVtb3ZlCiAuVFAKKy5CIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKy5UUAorLkIgc2Fu
X3BhdGhfZXJyX3RocmVzaG9sZF93aW5kb3cKKy5UUAorLkIgc2FuX3BhdGhfZXJyX3JlY292ZXJ5
X3RpbWUKKy5UUAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5X3dhaXRfY2hl
Y2tzCkBAIC0xMTkyLDYgKzEyNDQsMTIgQEAgdGhlIHZhbHVlcyBhcmUgdGFrZW4gZnJvbSB0aGUg
XGZJZGV2aWNlc1xmUiBvciBcZklkZWZhdWx0c1xmUiBzZWN0aW9uczoKIC5UUAogLkIgZGVmZXJy
ZWRfcmVtb3ZlCiAuVFAKKy5CIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKy5UUAorLkIgc2FuX3Bh
dGhfZXJyX3RocmVzaG9sZF93aW5kb3cKKy5UUAorLkIgc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3Rp
bWUKKy5UUAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5X3dhaXRfY2hlY2tz
CmRpZmYgLS1naXQgYS9tdWx0aXBhdGhkL21haW4uYyBiL211bHRpcGF0aGQvbWFpbi5jCmluZGV4
IGFkYzMyNTguLmZhY2ZjMDMgMTAwNjQ0Ci0tLSBhL211bHRpcGF0aGQvbWFpbi5jCisrKyBiL211
bHRpcGF0aGQvbWFpbi5jCkBAIC0xNDg2LDcgKzE0ODYsNTQgQEAgdm9pZCByZXBhaXJfcGF0aChz
dHJ1Y3QgcGF0aCAqIHBwKQogCWNoZWNrZXJfcmVwYWlyKCZwcC0+Y2hlY2tlcik7CiAJTE9HX01T
RygxLCBjaGVja2VyX21lc3NhZ2UoJnBwLT5jaGVja2VyKSk7CiB9CitzdGF0aWMgaW50IGNoZWNr
X3BhdGhfdmFsaWRpdHlfZXJyKCBzdHJ1Y3QgcGF0aCAqIHBwKXsKKwlzdHJ1Y3QgdGltZXNwZWMg
c3RhcnRfdGltZTsKKwlpbnQgZGlzYWJsZV9yZWluc3RhdGUgPSAwOworCisJaWYgKGNsb2NrX2dl
dHRpbWUoQ0xPQ0tfTU9OT1RPTklDLCAmc3RhcnRfdGltZSkgIT0gMCkKKwkJc3RhcnRfdGltZS50
dl9zZWMgPSAwOworCisJCS8qSWYgbnVtYmVyIG9mIHBhdGggZmFpbHVyZXMgYXJlIG1vcmUgdGhl
biB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9sZCovCisJCWlmKChwcC0+bXBwLT5zYW5fcGF0aF9l
cnJfdGhyZXNob2xkID4gMCkmJiAocHAtPnBhdGhfZmFpbHVyZXMgPiBwcC0+bXBwLT5zYW5fcGF0
aF9lcnJfdGhyZXNob2xkKSl7CisJCQljb25kbG9nKDMsIlxucGF0aCAlcyA6aGl0IHRoZSBlcnJv
ciB0aHJlc2hvbGRcbiIscHAtPmRldik7CisKKwkJCWlmKCFwcC0+ZGlzYWJsZV9yZWluc3RhdGUp
eworCQkJCS8qaWYgdGhlIGVycm9yIHRocmVzaG9sZCBoYXMgaGl0IGhpdCB3aXRoaW4gdGhlIHNh
bl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93CisJCQkJICogdGltZSBmcmFtZSBkb25vdCByZWlu
c3RhbnRlIHRoZSBwYXRoIHRpbGwgdGhlIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCisJCQkJ
ICogcGxhY2UgdGhlIHBhdGggaW4gZmFpbGVkIHN0YXRlIHRpbGwgc2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWUgc28gdGhhdCB0aGUgCisJCQkJICogY3V0b21lciBjYW4gcmVjdGlmeSB0aGUgaXNz
dWUgd2l0aGluIHRoaXMgdGltZSAuT25jZSB0aGUgY29wbGV0aW9uIG9mIAorCQkJCSAqIHNhbl9w
YXRoX2Vycl9yZWNvdmVyeV90aW1lIGl0IHNob3VsZCBhdXRvbWF0aWNhbGx5IHJlaW5zdGFudGF0
ZSB0aGUgcGF0aAorCQkJCSAqICovCisJCQkJaWYoKHBwLT5tcHAtPnNhbl9wYXRoX2Vycl90aHJl
c2hvbGRfd2luZG93ID4gMCkgJiYgCisJCQkJICAgKChzdGFydF90aW1lLnR2X3NlYyAtIHBwLT5m
YWlsdXJlX3N0YXJ0X3RpbWUpIDwgcHAtPm1wcC0+c2FuX3BhdGhfZXJyX3RocmVzaG9sZF93aW5k
b3cpKXsKKwkJCQkJY29uZGxvZygzLCJcbnBhdGggJXMgOmhpdCB0aGUgZXJyb3IgdGhyZXNob2xk
IHdpdGhpbiB0aGUgdGhyc2hvbGQgd2luZG93IHRpbWVcbiIscHAtPmRldik7CisJCQkJCWRpc2Fi
bGVfcmVpbnN0YXRlID0gMTsgCisJCQkJCXBwLT5kaXNfcmVpbnN0YW50ZV90aW1lID0gc3RhcnRf
dGltZS50dl9zZWMgOworCQkJCQlwcC0+ZGlzYWJsZV9yZWluc3RhdGUgPSAxOworCQkJCX1lbHNl
eworCQkJCQkvKmV2ZW4gdGhvdWdoIHRoZSBudW1iZXIgb2YgZXJyb3JzIGFyZSBncmVhdGVyIHRo
ZW4gdGhlIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKwkJCQkJICpzaW5jZSBpdCBkb2Vzbm90IGhp
dCB3aXRoaW4gdGhlIHNhbl9wYXRoX2Vycl90aHJlc2hvbGRfd2luZG93IHRpbWUgIHdlIHNob3Vs
ZCBub3QgdGFrZSB0aGVzZQorCQkJCQkgKiBlcnJyb3MgaW50byBhY2NvdW50IGFuZCB3ZSBoYXZl
IHRvIHJld2F0Y2ggdGhlIGVycm9ycworCQkJCQkgKi8KKwkJCQkJcHAtPnBhdGhfZmFpbHVyZXMg
PSAwOworCQkJCQlwcC0+ZGlzYWJsZV9yZWluc3RhdGUgPSAwOworCisJCQkJfQorCQkJfQorCQkJ
aWYocHAtPmRpc2FibGVfcmVpbnN0YXRlKXsKKwkJCQlkaXNhYmxlX3JlaW5zdGF0ZSA9IDE7CisJ
CQkJaWYoKHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lID4gMCkgJiYgCisJCQkJ
ICAgKHN0YXJ0X3RpbWUudHZfc2VjIC0gcHAtPmRpc19yZWluc3RhbnRlX3RpbWUgKSA+IHBwLT5t
cHAtPnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKXsKKwkJCQkJZGlzYWJsZV9yZWluc3RhdGUg
PTA7CisJCQkJCXBwLT5wYXRoX2ZhaWx1cmVzID0gMDsKKwkJCQkJcHAtPmRpc2FibGVfcmVpbnN0
YXRlID0gMDsKKwkJCQkJIGNvbmRsb2coMywiXG5wYXRoICVzIDpyZWluc3RhdGUgdGhlIHBhdGgg
YWZ0ZXIgZXJyIHJlY292ZXJ5IHRpbWVcbiIscHAtPmRldik7CisJCQkJfQogCisJCQl9CisJCX0K
KwlyZXR1cm4gIGRpc2FibGVfcmVpbnN0YXRlOworfQogLyoKICAqIFJldHVybnMgJzEnIGlmIHRo
ZSBwYXRoIGhhcyBiZWVuIGNoZWNrZWQsICctMScgaWYgaXQgd2FzIGJsYWNrbGlzdGVkCiAgKiBh
bmQgJzAnIG90aGVyd2lzZQpAQCAtMTUwMyw3ICsxNTUwLDExIEBAIGNoZWNrX3BhdGggKHN0cnVj
dCB2ZWN0b3JzICogdmVjcywgc3RydWN0IHBhdGggKiBwcCwgaW50IHRpY2tzKQogCWludCByZXRy
aWdnZXJfdHJpZXMsIGNoZWNraW50OwogCXN0cnVjdCBjb25maWcgKmNvbmY7CiAJaW50IHJldDsK
KwlzdHJ1Y3QgdGltZXNwZWMgc3RhcnRfdGltZTsKIAorCWlmIChjbG9ja19nZXR0aW1lKENMT0NL
X01PTk9UT05JQywgJnN0YXJ0X3RpbWUpICE9IDApCisJCXN0YXJ0X3RpbWUudHZfc2VjID0gMDsK
KwkKIAlpZiAoKHBwLT5pbml0aWFsaXplZCA9PSBJTklUX09LIHx8CiAJICAgICBwcC0+aW5pdGlh
bGl6ZWQgPT0gSU5JVF9SRVFVRVNURURfVURFVikgJiYgIXBwLT5tcHApCiAJCXJldHVybiAwOwpA
QCAtMTYxNSwxMiArMTY2NiwxOCBAQCBjaGVja19wYXRoIChzdHJ1Y3QgdmVjdG9ycyAqIHZlY3Ms
IHN0cnVjdCBwYXRoICogcHAsIGludCB0aWNrcykKIAkgKiBhbmQgaWYgdGFyZ2V0IHN1cHBvcnRz
IG9ubHkgaW1wbGljaXQgdHBncyBtb2RlLgogCSAqIHRoaXMgd2lsbCBwcmV2ZW50IHVubmVjZXNz
YXJ5IGkvbyBieSBkbSBvbiBzdGFuZC1ieQogCSAqIHBhdGhzIGlmIHRoZXJlIGFyZSBubyBvdGhl
ciBhY3RpdmUgcGF0aHMgaW4gbWFwLgorCSAqCisJICogd2hlbiBwYXRoIGZhaWx1cmVzIGhhcyBl
eGNlZWRlZCB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9sZCAKKwkgKiB3aXRoaW4gc2FuX3BhdGhf
ZXJyX3RocmVzaG9sZF93aW5kb3cgdGhlbiB3ZSBkb24ndCByZWluc3RhdGUKKwkgKiBmYWlsZWQg
cGF0aCBmb3Igc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUKIAkgKi8KLQlkaXNhYmxlX3JlaW5z
dGF0ZSA9IChuZXdzdGF0ZSA9PSBQQVRIX0dIT1NUICYmCisJZGlzYWJsZV9yZWluc3RhdGUgPSAo
KG5ld3N0YXRlID09IFBBVEhfR0hPU1QgJiYKIAkJCSAgICBwcC0+bXBwLT5ucl9hY3RpdmUgPT0g
MCAmJgotCQkJICAgIHBwLT50cGdzID09IFRQR1NfSU1QTElDSVQpID8gMSA6IDA7CisJCQkgICAg
cHAtPnRwZ3MgPT0gVFBHU19JTVBMSUNJVCkgPyAxIDoKKwkJCSAgICBjaGVja19wYXRoX3ZhbGlk
aXR5X2VycihwcCkpOwogCiAJcHAtPmNoa3JzdGF0ZSA9IG5ld3N0YXRlOworCiAJaWYgKG5ld3N0
YXRlICE9IHBwLT5zdGF0ZSkgewogCQlpbnQgb2xkc3RhdGUgPSBwcC0+c3RhdGU7CiAJCXBwLT5z
dGF0ZSA9IG5ld3N0YXRlOwo=

--_005_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_005_4dfed25f04c04771a732580a4a8cc834BRMWPEXMB12corpbrocadec_--
