From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: deterministic io throughput in multipath
Date: Tue, 17 Jan 2017 10:43:25 +0000
Message-ID: <8afcfb54df9c4d7c8525948917e64080@BRMWP-EXMB12.corp.brocade.com>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
	<20161221160940.GG19659@octiron.msp.redhat.com>
	<8cd4cc5f20b540a1b8312ad485711152@BRMWP-EXMB12.corp.brocade.com>
	<20170103171159.GA2732@octiron.msp.redhat.com>
	<4dfed25f04c04771a732580a4a8cc834@BRMWP-EXMB12.corp.brocade.com>
	<20170117010447.GW2732@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2538909769962282500=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170117010447.GW2732@octiron.msp.redhat.com>
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

--===============2538909769962282500==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_8afcfb54df9c4d7c8525948917e64080BRMWPEXMB12corpbrocadec_"

--_000_8afcfb54df9c4d7c8525948917e64080BRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi Ben,
Thanks for the review.
In dict.c  I will make sure I will make generic functions which will be used by both delay_checks and err_checks.

We want to increment the path failures every time the path goes down regardless of whether multipathd or the kernel noticed the failure of paths.
Thanks for pointing this.

I will completely agree with the idea which you mentioned below by reconsidering the san_path_err_threshold_window with
san_path_err_forget_rate. This will avoid counting time when the path was down as time where the path wasn't having problems.

I will incorporate all the changes mentioned below and will resend the patch once the testing is done.

Regards,
Muneendra.



-----Original Message-----
From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
Sent: Tuesday, January 17, 2017 6:35 AM
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] deterministic io throughput in multipath

On Mon, Jan 16, 2017 at 11:19:19AM +0000, Muneendra Kumar M wrote:
>    Hi Ben,
>    After the below discussion we  came with the approach which will meet our
>    requirement.
>    I have attached the patch which is working good in our field tests.
>    Could you please review the attached patch and provide us your valuable
>    comments .

I can see a number of issues with this patch.

First, some nit-picks:
- I assume "dis_reinstante_time" should be "dis_reinstate_time"

- The indenting in check_path_validity_err is wrong, which made it
  confusing until I noticed that

if (clock_gettime(CLOCK_MONOTONIC, &start_time) != 0)

  doesn't have an open brace, and shouldn't indent the rest of the
  function.

- You call clock_gettime in check_path, but never use the result.

- In dict.c, instead of writing your own functions that are the same as
  the *_delay_checks functions, you could make those functions generic
  and use them for both.  To go match the other generic function names
  they would probably be something like

set_off_int_undef

print_off_int_undef

  You would also need to change DELAY_CHECKS_* and ERR_CHECKS_* to
  point to some common enum that you created, the way
  user_friendly_names_states (to name one of many) does. The generic
  enum used by *_off_int_undef would be something like.

enum no_undef {
        NU_NO = -1,
        NU_UNDEF = 0,
}

  The idea is to try to cut down on the number of functions that are
  simply copy-pasting other functions in dict.c.


Those are all minor cleanup issues, but there are some bigger problems.

Instead of checking if san_path_err_threshold, san_path_err_threshold_window, and san_path_err_recovery_time are greater than zero seperately, you should probably check them all at the start of check_path_validity_err, and return 0 unless they all are set.
Right now, if a user sets san_path_err_threshold and san_path_err_threshold_window but not san_path_err_recovery_time, their path will never recover after it hits the error threshold.  I pretty sure that you don't mean to permanently disable the paths.


time_t is a signed type, which means that if you get the clock time in update_multpath and then fail to get the clock time in check_path_validity_err, this check:

start_time.tv_sec - pp->failure_start_time) < pp->mpp->san_path_err_threshold_window

will always be true.  I realize that clock_gettime is very unlikely to fail.  But if it does, probably the safest thing to so is to just immediately return 0 in check_path_validity_err.


The way you set path_failures in update_multipath may not get you what you want.  It will only count path failures found by the kernel, and not the path checker.  If the check_path finds the error, pp->state will be set to PATH_DOWN before pp->dmstate is set to PSTATE_FAILED. That means you will not increment path_failures. Perhaps this is what you want, but I would assume that you would want to count every time the path goes down regardless of whether multipathd or the kernel noticed it.


I'm not super enthusiastic about how the san_path_err_threshold_window works.  First, it starts counting from when the path goes down, so if the path takes long enough to get restored, and then fails immediately, it can just keep failing and it will never hit the san_path_err_threshold_window, since it spends so much of that time with the path failed.  Also, the window gets set on the first error, and never reset until the number of errors is over the threshold.  This means that if you get one early error and then a bunch of errors much later, you will go for (2 x san_path_err_threshold) - 1 errors until you stop reinstating the path, because of the window reset in the middle of the string of errors.  It seems like a better idea would be to have check_path_validity_err reset path_failures 
 as soon as it notices that you are past san_path_err_threshold_window, instead of waiting till the number of errors hits san_path_err_threshold.


If I was going to design this, I think I would have san_path_err_threshold and san_path_err_recovery_time like you do, but instead of having a san_path_err_threshold_window, I would have something like san_path_err_forget_rate.  The idea is that every san_path_err_forget_rate number of successful path checks you decrement path_failures by 1. This means that there is no window after which you reset.  If the path failures come in faster than the forget rate, you will eventually hit the error threshold. This also has the benefit of easily not counting time when the path was down as time where the path wasn't having problems. But if you don't like my idea, yours will work fine with some polish.

-Ben


>    Below are the files that has been changed .
>
>    libmultipath/config.c      |  3 +++
>    libmultipath/config.h      |  9 +++++++++
>    libmultipath/configure.c   |  3 +++
>    libmultipath/defaults.h    |  1 +
>    libmultipath/dict.c             | 80
>    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>    libmultipath/dict.h        |  1 +
>    libmultipath/propsel.c     | 44
>    ++++++++++++++++++++++++++++++++++++++++++++
>    libmultipath/propsel.h     |  6 ++++++
>    libmultipath/structs.h     | 12 +++++++++++-
>    libmultipath/structs_vec.c | 10 ++++++++++
>    multipath/multipath.conf.5 | 58
>    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>    multipathd/main.c          | 61
>    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>
>    We have added three new config parameters whose description is below.
>    1.san_path_err_threshold:
>            If set to a value greater than 0, multipathd will watch paths and
>    check how many times a path has been failed due to errors. If the number
>    of failures on a particular path is greater then the
>    san_path_err_threshold then the path will not  reinstate  till
>    san_path_err_recovery_time. These path failures should occur within a
>    san_path_err_threshold_window time frame, if not we will consider the path
>    is good enough to reinstate.
>
>    2.san_path_err_threshold_window:
>            If set to a value greater than 0, multipathd will check whether
>    the path failures has exceeded  the san_path_err_threshold within this
>    time frame i.e san_path_err_threshold_window . If so we will not reinstate
>    the path till          san_path_err_recovery_time.
>
>    3.san_path_err_recovery_time:
>    If set to a value greater than 0, multipathd will make sure that when path
>    failures has exceeded the san_path_err_threshold within
>    san_path_err_threshold_window then the path  will be placed in failed
>    state for san_path_err_recovery_time duration. Once
>    san_path_err_recovery_time has timeout  we will reinstate the failed path
>    .
>
>    Regards,
>    Muneendra.
>
>    -----Original Message-----
>    From: Muneendra Kumar M
>    Sent: Wednesday, January 04, 2017 6:56 PM
>    To: 'Benjamin Marzinski' <bmarzins@redhat.com<mailto:bmarzins@redhat.com>>
>    Cc: dm-devel@redhat.com<mailto:dm-devel@redhat.com>
>    Subject: RE: [dm-devel] deterministic io throughput in multipath
>
>    Hi Ben,
>    Thanks for the information.
>
>    Regards,
>    Muneendra.
>
>    -----Original Message-----
>    From: Benjamin Marzinski [[1]mailto:bmarzins@redhat.com]
>    Sent: Tuesday, January 03, 2017 10:42 PM
>    To: Muneendra Kumar M <[2]mmandala@Brocade.com<mailto:mmandala@Brocade.com>>
>    Cc: [3]dm-devel@redhat.com<mailto:dm-devel@redhat.com>
>    Subject: Re: [dm-devel] deterministic io throughput in multipath
>
>    On Mon, Dec 26, 2016 at 09:42:48AM +0000, Muneendra Kumar M wrote:
>    > Hi Ben,
>    >
>    > If there are two paths on a dm-1 say sda and sdb as below.
>    >
>    > #  multipath -ll
>    >        mpathd (3600110d001ee7f0102050001cc0b6751) dm-1 SANBlaze,VLUN
>    MyLun
>    >        size=8.0M features='0' hwhandler='0' wp=rw
>    >        `-+- policy='round-robin 0' prio=50 status=active
>    >          |- 8:0:1:0  sda 8:48 active ready  running
>    >          `- 9:0:1:0  sdb 8:64 active ready  running
>    >
>    > And on sda if iam seeing lot of errors due to which the sda path is
>    fluctuating from failed state to active state and vicevera.
>    >
>    > My requirement is something like this if sda is failed for more then 5
>    > times in a hour duration ,then I want to keep the sda in failed state
>    > for few hours (3hrs)
>    >
>    > And the data should travel only thorugh sdb path.
>    > Will this be possible with the below parameters.
>
>    No. delay_watch_checks sets how may path checks you watch a path that has
>    recently come back from the failed state. If the path fails again within
>    this time, multipath device delays it.  This means that the delay is
>    always trigger by two failures within the time limit.  It's possible to
>    adapt this to count numbers of failures, and act after a certain number
>    within a certain timeframe, but it would take a bit more work.
>
>    delay_wait_checks doesn't guarantee that it will delay for any set length
>    of time.  Instead, it sets the number of consecutive successful path
>    checks that must occur before the path is usable again. You could set this
>    for 3 hours of path checks, but if a check failed during this time, you
>    would restart the 3 hours over again.
>
>    -Ben
>
>    > Can you just let me know what values I should add for delay_watch_checks
>    and delay_wait_checks.
>    >
>    > Regards,
>    > Muneendra.
>    >
>    >
>    >
>    > -----Original Message-----
>    > From: Muneendra Kumar M
>    > Sent: Thursday, December 22, 2016 11:10 AM
>    > To: 'Benjamin Marzinski' <[4]bmarzins@redhat.com<mailto:bmarzins@redhat.com>>
>    > Cc: [5]dm-devel@redhat.com<mailto:dm-devel@redhat.com>
>    > Subject: RE: [dm-devel] deterministic io throughput in multipath
>    >
>    > Hi Ben,
>    >
>    > Thanks for the reply.
>    > I will look into this parameters will do the internal testing and let
>    you know the results.
>    >
>    > Regards,
>    > Muneendra.
>    >
>    > -----Original Message-----
>    > From: Benjamin Marzinski [[6]mailto:bmarzins@redhat.com]
>    > Sent: Wednesday, December 21, 2016 9:40 PM
>    > To: Muneendra Kumar M <[7]mmandala@Brocade.com<mailto:mmandala@Brocade.com>>
>    > Cc: [8]dm-devel@redhat.com<mailto:dm-devel@redhat.com>
>    > Subject: Re: [dm-devel] deterministic io throughput in multipath
>    >
>    > Have you looked into the delay_watch_checks and delay_wait_checks
>    configuration parameters?  The idea behind them is to minimize the use of
>    paths that are intermittently failing.
>    >
>    > -Ben
>    >
>    > On Mon, Dec 19, 2016 at 11:50:36AM +0000, Muneendra Kumar M wrote:
>    > >    Customers using Linux host (mostly RHEL host) using a SAN network
>    for
>    > >    block storage, complain the Linux multipath stack is not resilient
>    to
>    > >    handle non-deterministic storage network behaviors. This has caused
>    many
>    > >    customer move away to non-linux based servers. The intent of the
>    below
>    > >    patch and the prevailing issues are given below. With the below
>    design we
>    > >    are seeing the Linux multipath stack becoming resilient to such
>    network
>    > >    issues. We hope by getting this patch accepted will help in more
>    Linux
>    > >    server adoption that use SAN network.
>    > >
>    > >    I have already sent the design details to the community in a
>    different
>    > >    mail chain and the details are available in the below link.
>    > >
>    > >
>    [1][9]https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=DgIDAw&c=IL_XqQWOjubgfqINi2jTzg&r=E3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=vfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=q5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu52hG3MKzM&e=
>    .
>    > >
>    > >    Can you please go through the design and send the comments to us.
>    > >
>    > >
>    > >
>    > >    Regards,
>    > >
>    > >    Muneendra.
>    > >
>    > >
>    > >
>    > >
>    > >
>    > > References
>    > >
>    > >    Visible links
>    > >    1.
>    > >
>    [10]https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_
>    > > ar
>    > > chives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=DgIDAw&c=IL_XqQWOj
>    > > ub
>    > > gfqINi2jTzg&r=E3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=vfwpVp6e
>    > > 1K
>    > > XtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=q5OI-lfefNC2CHKmyUkokgiyiPo_Uj7M
>    > > Ru
>    > > 52hG3MKzM&e=
>    >
>    > > --
>    > > dm-devel mailing list
>    > > [11]dm-devel@redhat.com<mailto:dm-devel@redhat.com>
>    > >
>    [12]https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_
>    > > ma
>    > > ilman_listinfo_dm-2Ddevel&d=DgIDAw&c=IL_XqQWOjubgfqINi2jTzg&r=E3ftc4
>    > > 7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=vfwpVp6e1KXtRA0ctwHYJ7cDmPsL
>    > >
> i2C1L9pox7uexsY&s=UyE46dXOrNTbPz_TVGtpoHl3J3h_n0uYhI4TI-PgyWg&e=
>
>
> References
>
>    Visible links
>    1. mailto:bmarzins@redhat.com
>    2. mailto:mmandala@brocade.com
>    3. mailto:dm-devel@redhat.com
>    4. mailto:bmarzins@redhat.com
>    5. mailto:dm-devel@redhat.com
>    6. mailto:bmarzins@redhat.com
>    7. mailto:mmandala@brocade.com
>    8. mailto:dm-devel@redhat.com
>    9. https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=DgIDAw&c=IL_XqQWOjubgfqINi2jTzg&r=E3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=vfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=q5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu52hG3MKzM&e
>   10. https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_
>   11. mailto:dm-devel@redhat.com
>   12.
> https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_





--_000_8afcfb54df9c4d7c8525948917e64080BRMWPEXMB12corpbrocadec_
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
<div>Thanks for the review.</div>
<div>In dict.c&nbsp; I will make sure I will make generic functions which w=
ill be used by both delay_checks and err_checks.</div>
<div>&nbsp;</div>
<div>We want to increment the path failures every time the path goes down r=
egardless of whether multipathd or the kernel noticed the failure of paths.=
</div>
<div>Thanks for pointing this.</div>
<div>&nbsp;</div>
<div>I will completely agree with the idea which you mentioned below by rec=
onsidering the san_path_err_threshold_window with </div>
<div>san_path_err_forget_rate. This will avoid counting time when the path =
was down as time where the path wasn't having problems.</div>
<div>&nbsp;</div>
<div>I will incorporate all the changes mentioned below and will resend the=
 patch once the testing is done.</div>
<div>&nbsp;</div>
<div>Regards,</div>
<div>Muneendra.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<a name=3D"_MailEndCompose"></a>
<div>&nbsp;</div>
<div>-----Original Message-----<br>

From: Benjamin Marzinski [<a href=3D"mailto:bmarzins@redhat.com">mailto:bma=
rzins@redhat.com</a>]
<br>

Sent: Tuesday, January 17, 2017 6:35 AM<br>

To: Muneendra Kumar M &lt;mmandala@Brocade.com&gt;<br>

Cc: dm-devel@redhat.com<br>

Subject: Re: [dm-devel] deterministic io throughput in multipath</div>
<div>&nbsp;</div>
<div>On Mon, Jan 16, 2017 at 11:19:19AM &#43;0000, Muneendra Kumar M wrote:=
</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Hi Ben,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; After the below discussion we&nbsp; came with t=
he approach which will meet our</div>
<div>&gt;&nbsp;&nbsp;&nbsp; requirement.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; I have attached the patch which is working good=
 in our field tests.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Could you please review the attached patch and =
provide us your valuable</div>
<div>&gt;&nbsp;&nbsp;&nbsp; comments .</div>
<div>&nbsp;</div>
<div>I can see a number of issues with this patch.</div>
<div>&nbsp;</div>
<div>First, some nit-picks:</div>
<div>- I assume &quot;dis_reinstante_time&quot; should be &quot;dis_reinsta=
te_time&quot;</div>
<div>&nbsp;</div>
<div>- The indenting in check_path_validity_err is wrong, which made it</di=
v>
<div>&nbsp; confusing until I noticed that</div>
<div>&nbsp;</div>
<div>if (clock_gettime(CLOCK_MONOTONIC, &amp;start_time) !=3D 0)</div>
<div>&nbsp;</div>
<div>&nbsp; doesn't have an open brace, and shouldn't indent the rest of th=
e</div>
<div>&nbsp; function.</div>
<div>&nbsp;</div>
<div>- You call clock_gettime in check_path, but never use the result.</div=
>
<div>&nbsp;</div>
<div>- In dict.c, instead of writing your own functions that are the same a=
s</div>
<div>&nbsp; the *_delay_checks functions, you could make those functions ge=
neric</div>
<div>&nbsp; and use them for both.&nbsp; To go match the other generic func=
tion names</div>
<div>&nbsp; they would probably be something like</div>
<div>&nbsp;</div>
<div>set_off_int_undef</div>
<div>&nbsp;</div>
<div>print_off_int_undef</div>
<div>&nbsp;</div>
<div>&nbsp; You would also need to change DELAY_CHECKS_* and ERR_CHECKS_* t=
o</div>
<div>&nbsp; point to some common enum that you created, the way</div>
<div>&nbsp; user_friendly_names_states (to name one of many) does. The gene=
ric</div>
<div>&nbsp; enum used by *_off_int_undef would be something like.</div>
<div>&nbsp;</div>
<div>enum no_undef {</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NU_NO =3D -1,</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NU_UNDEF =3D 0,</div>
<div>}</div>
<div>&nbsp;</div>
<div>&nbsp; The idea is to try to cut down on the number of functions that =
are</div>
<div>&nbsp; simply copy-pasting other functions in dict.c.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>Those are all minor cleanup issues, but there are some bigger problems=
.</div>
<div>&nbsp;</div>
<div>Instead of checking if san_path_err_threshold, san_path_err_threshold_=
window, and san_path_err_recovery_time are greater than zero seperately, yo=
u should probably check them all at the start of check_path_validity_err, a=
nd return 0 unless they all are
set.</div>
<div>Right now, if a user sets san_path_err_threshold and san_path_err_thre=
shold_window but not san_path_err_recovery_time, their path will never reco=
ver after it hits the error threshold.&nbsp; I pretty sure that you don't m=
ean to permanently disable the paths.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>time_t is a signed type, which means that if you get the clock time in=
 update_multpath and then fail to get the clock time in check_path_validity=
_err, this check:</div>
<div>&nbsp;</div>
<div>start_time.tv_sec - pp-&gt;failure_start_time) &lt; pp-&gt;mpp-&gt;san=
_path_err_threshold_window</div>
<div>&nbsp;</div>
<div>will always be true.&nbsp; I realize that clock_gettime is very unlike=
ly to fail.&nbsp; But if it does, probably the safest thing to so is to jus=
t immediately return 0 in check_path_validity_err.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>The way you set path_failures in update_multipath may not get you what=
 you want.&nbsp; It will only count path failures found by the kernel, and =
not the path checker.&nbsp; If the check_path finds the error, pp-&gt;state=
 will be set to PATH_DOWN before pp-&gt;dmstate
is set to PSTATE_FAILED. That means you will not increment path_failures. P=
erhaps this is what you want, but I would assume that you would want to cou=
nt every time the path goes down regardless of whether multipathd or the ke=
rnel noticed it.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>I'm not super enthusiastic about how the san_path_err_threshold_window=
 works.&nbsp; First, it starts counting from when the path goes down, so if=
 the path takes long enough to get restored, and then fails immediately, it=
 can just keep failing and it will never
hit the san_path_err_threshold_window, since it spends so much of that time=
 with the path failed.&nbsp; Also, the window gets set on the first error, =
and never reset until the number of errors is over the threshold.&nbsp; Thi=
s means that if you get one early error and
then a bunch of errors much later, you will go for (2 x san_path_err_thresh=
old) - 1 errors until you stop reinstating the path, because of the window =
reset in the middle of the string of errors.&nbsp; It seems like a better i=
dea would be to have check_path_validity_err
reset path_failures as soon as it notices that you are past san_path_err_th=
reshold_window, instead of waiting till the number of errors hits san_path_=
err_threshold.</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>If I was going to design this, I think I would have san_path_err_thres=
hold and san_path_err_recovery_time like you do, but instead of having a sa=
n_path_err_threshold_window, I would have something like san_path_err_forge=
t_rate.&nbsp; The idea is that every
san_path_err_forget_rate number of successful path checks you decrement pat=
h_failures by 1. This means that there is no window after which you reset.&=
nbsp; If the path failures come in faster than the forget rate, you will ev=
entually hit the error threshold. This
also has the benefit of easily not counting time when the path was down as =
time where the path wasn't having problems. But if you don't like my idea, =
yours will work fine with some polish.</div>
<div>&nbsp;</div>
<div>-Ben</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Below are the files that has been changed .</di=
v>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/config.c&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; |&nbsp; 3 &#43;&#43;&#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/config.h&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; |&nbsp; 9 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/configure.c&nbsp;&nbsp; |&nbsp; 3 =
&#43;&#43;&#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/defaults.h&nbsp;&nbsp;&nbsp; |&nbs=
p; 1 &#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/dict.c&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 80</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/dict.h&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; |&nbsp; 1 &#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/propsel.c&nbsp;&nbsp;&nbsp;&nbsp; =
| 44</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/propsel.h&nbsp;&nbsp;&nbsp;&nbsp; =
|&nbsp; 6 &#43;&#43;&#43;&#43;&#43;&#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/structs.h&nbsp;&nbsp;&nbsp;&nbsp; =
| 12 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;-</div>
<div>&gt;&nbsp;&nbsp;&nbsp; libmultipath/structs_vec.c | 10 &#43;&#43;&#43;=
&#43;&#43;&#43;&#43;&#43;&#43;&#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; multipath/multipath.conf.5 | 58</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; multipathd/main.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; | 61</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#=
43;&#43;&#43;&#43;&#43;--</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; We have added three new config parameters whose=
 description is below.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; 1.san_path_err_threshold:</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If s=
et to a value greater than 0, multipathd will watch paths and</div>
<div>&gt;&nbsp;&nbsp;&nbsp; check how many times a path has been failed due=
 to errors. If the number</div>
<div>&gt;&nbsp;&nbsp;&nbsp; of failures on a particular path is greater the=
n the</div>
<div>&gt;&nbsp;&nbsp;&nbsp; san_path_err_threshold then the path will not&n=
bsp; reinstate&nbsp; till</div>
<div>&gt;&nbsp;&nbsp;&nbsp; san_path_err_recovery_time. These path failures=
 should occur within a</div>
<div>&gt;&nbsp;&nbsp;&nbsp; san_path_err_threshold_window time frame, if no=
t we will consider the path</div>
<div>&gt;&nbsp;&nbsp;&nbsp; is good enough to reinstate.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; 2.san_path_err_threshold_window:</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; If s=
et to a value greater than 0, multipathd will check whether</div>
<div>&gt;&nbsp;&nbsp;&nbsp; the path failures has exceeded&nbsp; the san_pa=
th_err_threshold within this</div>
<div>&gt;&nbsp;&nbsp;&nbsp; time frame i.e san_path_err_threshold_window . =
If so we will not reinstate</div>
<div>&gt;&nbsp;&nbsp;&nbsp; the path till&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; san_path_err_recovery_time.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; 3.san_path_err_recovery_time:</div>
<div>&gt;&nbsp;&nbsp;&nbsp; If set to a value greater than 0, multipathd wi=
ll make sure that when path</div>
<div>&gt;&nbsp;&nbsp;&nbsp; failures has exceeded the san_path_err_threshol=
d within</div>
<div>&gt;&nbsp;&nbsp;&nbsp; san_path_err_threshold_window then the path&nbs=
p; will be placed in failed</div>
<div>&gt;&nbsp;&nbsp;&nbsp; state for san_path_err_recovery_time duration. =
Once</div>
<div>&gt;&nbsp;&nbsp;&nbsp; san_path_err_recovery_time has timeout&nbsp; we=
 will reinstate the failed path</div>
<div>&gt;&nbsp;&nbsp;&nbsp; .</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Regards,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Muneendra.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; -----Original Message-----</div>
<div>&gt;&nbsp;&nbsp;&nbsp; From: Muneendra Kumar M</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Sent: Wednesday, January 04, 2017 6:56 PM</div>
<div>&gt;&nbsp;&nbsp;&nbsp; To: 'Benjamin Marzinski' &lt;<a href=3D"mailto:=
bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Cc: <a href=3D"mailto:dm-devel@redhat.com">dm-d=
evel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; Subject: RE: [dm-devel] deterministic io throug=
hput in multipath</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Hi Ben,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Thanks for the information.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Regards,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Muneendra.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; -----Original Message-----</div>
<div>&gt;&nbsp;&nbsp;&nbsp; From: Benjamin Marzinski [[1]<a href=3D"mailto:=
bmarzins@redhat.com">mailto:bmarzins@redhat.com</a>]</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Sent: Tuesday, January 03, 2017 10:42 PM</div>
<div>&gt;&nbsp;&nbsp;&nbsp; To: Muneendra Kumar M &lt;[2]<a href=3D"mailto:=
mmandala@Brocade.com">mmandala@Brocade.com</a>&gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Cc: [3]<a href=3D"mailto:dm-devel@redhat.com">d=
m-devel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; Subject: Re: [dm-devel] deterministic io throug=
hput in multipath</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; On Mon, Dec 26, 2016 at 09:42:48AM &#43;0000, M=
uneendra Kumar M wrote:</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Hi Ben,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; If there are two paths on a dm-1 say sda a=
nd sdb as below.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; #&nbsp; multipath -ll</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
mpathd (3600110d001ee7f0102050001cc0b6751) dm-1 SANBlaze,VLUN</div>
<div>&gt;&nbsp;&nbsp;&nbsp; MyLun</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
size=3D8.0M features=3D'0' hwhandler=3D'0' wp=3Drw</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
`-&#43;- policy=3D'round-robin 0' prio=3D50 status=3Dactive</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; |- 8:0:1:0&nbsp; sda 8:48 active ready&nbsp; running</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; `- 9:0:1:0&nbsp; sdb 8:64 active ready&nbsp; running&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; And on sda if iam seeing lot of errors due=
 to which the sda path is</div>
<div>&gt;&nbsp;&nbsp;&nbsp; fluctuating from failed state to active state a=
nd vicevera.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; My requirement is something like this if s=
da is failed for more then 5</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; times in a hour duration ,then I want to k=
eep the sda in failed state</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; for few hours (3hrs)</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; And the data should travel only thorugh sd=
b path.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Will this be possible with the below param=
eters.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; No. delay_watch_checks sets how may path checks=
 you watch a path that has</div>
<div>&gt;&nbsp;&nbsp;&nbsp; recently come back from the failed state. If th=
e path fails again within</div>
<div>&gt;&nbsp;&nbsp;&nbsp; this time, multipath device delays it.&nbsp; Th=
is means that the delay is</div>
<div>&gt;&nbsp;&nbsp;&nbsp; always trigger by two failures within the time =
limit.&nbsp; It's possible to</div>
<div>&gt;&nbsp;&nbsp;&nbsp; adapt this to count numbers of failures, and ac=
t after a certain number</div>
<div>&gt;&nbsp;&nbsp;&nbsp; within a certain timeframe, but it would take a=
 bit more work.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; delay_wait_checks doesn't guarantee that it wil=
l delay for any set length</div>
<div>&gt;&nbsp;&nbsp;&nbsp; of time.&nbsp; Instead, it sets the number of c=
onsecutive successful path</div>
<div>&gt;&nbsp;&nbsp;&nbsp; checks that must occur before the path is usabl=
e again. You could set this</div>
<div>&gt;&nbsp;&nbsp;&nbsp; for 3 hours of path checks, but if a check fail=
ed during this time, you</div>
<div>&gt;&nbsp;&nbsp;&nbsp; would restart the 3 hours over again.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; -Ben</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Can you just let me know what values I sho=
uld add for delay_watch_checks</div>
<div>&gt;&nbsp;&nbsp;&nbsp; and delay_wait_checks.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Regards,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Muneendra.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; -----Original Message-----</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; From: Muneendra Kumar M</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Sent: Thursday, December 22, 2016 11:10 AM=
</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; To: 'Benjamin Marzinski' &lt;[4]<a href=3D=
"mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Cc: [5]<a href=3D"mailto:dm-devel@redhat.c=
om">dm-devel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Subject: RE: [dm-devel] deterministic io t=
hroughput in multipath</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Hi Ben,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Thanks for the reply.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; I will look into this parameters will do t=
he internal testing and let</div>
<div>&gt;&nbsp;&nbsp;&nbsp; you know the results.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Regards,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Muneendra.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; -----Original Message-----</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; From: Benjamin Marzinski [[6]<a href=3D"ma=
ilto:bmarzins@redhat.com">mailto:bmarzins@redhat.com</a>]</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Sent: Wednesday, December 21, 2016 9:40 PM=
</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; To: Muneendra Kumar M &lt;[7]<a href=3D"ma=
ilto:mmandala@Brocade.com">mmandala@Brocade.com</a>&gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Cc: [8]<a href=3D"mailto:dm-devel@redhat.c=
om">dm-devel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Subject: Re: [dm-devel] deterministic io t=
hroughput in multipath</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; Have you looked into the delay_watch_check=
s and delay_wait_checks</div>
<div>&gt;&nbsp;&nbsp;&nbsp; configuration parameters?&nbsp; The idea behind=
 them is to minimize the use of</div>
<div>&gt;&nbsp;&nbsp;&nbsp; paths that are intermittently failing.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; -Ben</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; On Mon, Dec 19, 2016 at 11:50:36AM &#43;00=
00, Muneendra Kumar M wrote:</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; Customers using Lin=
ux host (mostly RHEL host) using a SAN network</div>
<div>&gt;&nbsp;&nbsp;&nbsp; for</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; block storage, comp=
lain the Linux multipath stack is not resilient</div>
<div>&gt;&nbsp;&nbsp;&nbsp; to</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; handle non-determin=
istic storage network behaviors. This has caused</div>
<div>&gt;&nbsp;&nbsp;&nbsp; many</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; customer move away =
to non-linux based servers. The intent of the</div>
<div>&gt;&nbsp;&nbsp;&nbsp; below</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; patch and the preva=
iling issues are given below. With the below</div>
<div>&gt;&nbsp;&nbsp;&nbsp; design we</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; are seeing the Linu=
x multipath stack becoming resilient to such</div>
<div>&gt;&nbsp;&nbsp;&nbsp; network</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; issues. We hope by =
getting this patch accepted will help in more</div>
<div>&gt;&nbsp;&nbsp;&nbsp; Linux</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; server adoption tha=
t use SAN network.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; I have already sent=
 the design details to the community in a</div>
<div>&gt;&nbsp;&nbsp;&nbsp; different</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; mail chain and the =
details are available in the below link.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; [1][9]<a href=3D"https://urldefense.proofpoint.=
com/v2/url?u=3Dhttps-3A__www.redhat.com_archives_dm-2Ddevel_2016-2DDecember=
_msg00122.html&amp;d=3DDgIDAw&amp;c=3DIL_XqQWOjubgfqINi2jTzg&amp;r=3DE3ftc4=
7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&amp;m=3DvfwpVp6e1KXtRA0ctwHYJ7cDmPsLi=
2C1L9pox7uexsY&amp;s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu52hG3MKzM&amp;e">h=
ttps://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_archiv=
es_dm-2Ddevel_2016-2DDecember_msg00122.html&amp;d=3DDgIDAw&amp;c=3DIL_XqQWO=
jubgfqINi2jTzg&amp;r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&amp;m=3D=
vfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&amp;s=3Dq5OI-lfefNC2CHKmyUkokgi=
yiPo_Uj7MRu52hG3MKzM&amp;e</a>=3D</div>
<div>&gt;&nbsp;&nbsp;&nbsp; .</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; Can you please go t=
hrough the design and send the comments to us.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; Regards,</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; Muneendra.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; References</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; Visible links</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;&nbsp;&nbsp;&nbsp; 1.</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; [10]<a href=3D"https://urldefense.proofpoint.co=
m/v2/url?u=3Dhttps-3A__www.redhat.com_">https://urldefense.proofpoint.com/v=
2/url?u=3Dhttps-3A__www.redhat.com_</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; ar</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; chives_dm-2Ddevel_2016-2DDecember_msg=
00122.html&amp;d=3DDgIDAw&amp;c=3DIL_XqQWOj</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; ub</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; gfqINi2jTzg&amp;r=3DE3ftc47B6BGtZ4fVa=
Yvkuv19wKvC_Mc6nhXaA1sBIP0&amp;m=3DvfwpVp6e</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; 1K</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; XtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&amp=
;s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7M</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; Ru</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; 52hG3MKzM&amp;e=3D</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; --</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; dm-devel mailing list</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; [11]<a href=3D"mailto:dm-devel@redhat=
.com">dm-devel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt;</div>
<div>&gt;&nbsp;&nbsp;&nbsp; [12]<a href=3D"https://urldefense.proofpoint.co=
m/v2/url?u=3Dhttps-3A__www.redhat.com_">https://urldefense.proofpoint.com/v=
2/url?u=3Dhttps-3A__www.redhat.com_</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; ma</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; ilman_listinfo_dm-2Ddevel&amp;d=3DDgI=
DAw&amp;c=3DIL_XqQWOjubgfqINi2jTzg&amp;r=3DE3ftc4</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; 7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0=
&amp;m=3DvfwpVp6e1KXtRA0ctwHYJ7cDmPsL</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &gt; &gt; </div>
<div>&gt; i2C1L9pox7uexsY&amp;s=3DUyE46dXOrNTbPz_TVGtpoHl3J3h_n0uYhI4TI-Pgy=
Wg&amp;e=3D</div>
<div>&gt;&nbsp;&nbsp;&nbsp; &nbsp;</div>
<div>&gt; </div>
<div>&gt; References</div>
<div>&gt; </div>
<div>&gt;&nbsp;&nbsp;&nbsp; Visible links</div>
<div>&gt;&nbsp;&nbsp;&nbsp; 1. <a href=3D"mailto:bmarzins@redhat.com">mailt=
o:bmarzins@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; 2. <a href=3D"mailto:mmandala@brocade.com">mail=
to:mmandala@brocade.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; 3. <a href=3D"mailto:dm-devel@redhat.com">mailt=
o:dm-devel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; 4. <a href=3D"mailto:bmarzins@redhat.com">mailt=
o:bmarzins@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; 5. <a href=3D"mailto:dm-devel@redhat.com">mailt=
o:dm-devel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; 6. <a href=3D"mailto:bmarzins@redhat.com">mailt=
o:bmarzins@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; 7. <a href=3D"mailto:mmandala@brocade.com">mail=
to:mmandala@brocade.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; 8. <a href=3D"mailto:dm-devel@redhat.com">mailt=
o:dm-devel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp;&nbsp; 9. <a href=3D"https://urldefense.proofpoint.com=
/v2/url?u=3Dhttps-3A__www.redhat.com_archives_dm-2Ddevel_2016-2DDecember_ms=
g00122.html&amp;d=3DDgIDAw&amp;c=3DIL_XqQWOjubgfqINi2jTzg&amp;r=3DE3ftc47B6=
BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&amp;m=3DvfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1=
L9pox7uexsY&amp;s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu52hG3MKzM&amp;e">http=
s://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_archives_=
dm-2Ddevel_2016-2DDecember_msg00122.html&amp;d=3DDgIDAw&amp;c=3DIL_XqQWOjub=
gfqINi2jTzg&amp;r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&amp;m=3Dvfw=
pVp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&amp;s=3Dq5OI-lfefNC2CHKmyUkokgiyiP=
o_Uj7MRu52hG3MKzM&amp;e</a></div>
<div>&gt;&nbsp;&nbsp; 10. <a href=3D"https://urldefense.proofpoint.com/v2/u=
rl?u=3Dhttps-3A__www.redhat.com_">https://urldefense.proofpoint.com/v2/url?=
u=3Dhttps-3A__www.redhat.com_</a></div>
<div>&gt;&nbsp;&nbsp; 11. <a href=3D"mailto:dm-devel@redhat.com">mailto:dm-=
devel@redhat.com</a></div>
<div>&gt;&nbsp;&nbsp; 12. </div>
<div>&gt; <a href=3D"https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A_=
_www.redhat.com_">https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__ww=
w.redhat.com_</a></div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
<div>&nbsp;</div>
</span></font>
</body>
</html>

--_000_8afcfb54df9c4d7c8525948917e64080BRMWPEXMB12corpbrocadec_--


--===============2538909769962282500==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2538909769962282500==--
