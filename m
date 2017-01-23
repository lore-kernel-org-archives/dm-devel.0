From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: deterministic io throughput in multipath
Date: Mon, 23 Jan 2017 11:02:42 +0000
Message-ID: <26d8e0b78873443c8e15b863bc33922d@BRMWP-EXMB12.corp.brocade.com>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
	<20161221160940.GG19659@octiron.msp.redhat.com>
	<8cd4cc5f20b540a1b8312ad485711152@BRMWP-EXMB12.corp.brocade.com>
	<20170103171159.GA2732@octiron.msp.redhat.com>
	<4dfed25f04c04771a732580a4a8cc834@BRMWP-EXMB12.corp.brocade.com>
	<20170117010447.GW2732@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_004_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_"
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

--_004_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_
Content-Type: multipart/alternative;
	boundary="_000_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_"

--_000_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi Ben,
I have made the changes as per the below review comments .

Could you please review the attached patch and provide us your valuable comments .

Below are the files that has been changed .

libmultipath/config.c      |  3 +++
 libmultipath/config.h      |  9 +++++++++
 libmultipath/configure.c   |  3 +++
 libmultipath/defaults.h    |  3 ++-
 libmultipath/dict.c        | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 libmultipath/dict.h        |  3 +--
 libmultipath/propsel.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 libmultipath/propsel.h     |  3 +++
 libmultipath/structs.h     | 14 ++++++++++----
 libmultipath/structs_vec.c |  6 ++++++
 multipath/multipath.conf.5 | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 multipathd/main.c          | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---


Regards,
Muneendra.

_____________________________________________
From: Muneendra Kumar M
Sent: Tuesday, January 17, 2017 4:13 PM
To: 'Benjamin Marzinski' <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
Subject: RE: [dm-devel] deterministic io throughput in multipath


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
To: Muneendra Kumar M <mmandala@Brocade.com<mailto:mmandala@Brocade.com>>
Cc: dm-devel@redhat.com<mailto:dm-devel@redhat.com>
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





--_000_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_
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
<div><font color=3D"#1F497D">Hi Ben,</font></div>
<div><font color=3D"#1F497D">I have made the changes as per the below revie=
w comments .</font></div>
<a name=3D"_MailEndCompose"></a>
<div><font color=3D"#1F497D">&nbsp;</font></div>
<div><font color=3D"#1F497D">Could you please review the attached patch and=
 provide us your valuable comments . </font></div>
<div><font color=3D"#1F497D"> </font></div>
<div><font color=3D"#1F497D">Below are the files that has been changed . </=
font></div>
<div><font color=3D"#1F497D">&nbsp;</font></div>
<div><font color=3D"#1F497D">libmultipath/config.c&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; |&nbsp; 3 &#43;&#43;&#43;</font></div>
<div><font color=3D"#1F497D"> libmultipath/config.h&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; |&nbsp; 9 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</font></div>
<div><font color=3D"#1F497D"> libmultipath/configure.c&nbsp;&nbsp; |&nbsp; =
3 &#43;&#43;&#43;</font></div>
<div><font color=3D"#1F497D"> libmultipath/defaults.h&nbsp;&nbsp;&nbsp; |&n=
bsp; 3 &#43;&#43;-</font></div>
<div><font color=3D"#1F497D"> libmultipath/dict.c&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; | 84 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;------------------------</font></div>
<div><font color=3D"#1F497D"> libmultipath/dict.h&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; |&nbsp; 3 &#43;--</font></div>
<div><font color=3D"#1F497D"> libmultipath/propsel.c&nbsp;&nbsp;&nbsp;&nbsp=
; | 48 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;--</font></div>
<div><font color=3D"#1F497D"> libmultipath/propsel.h&nbsp;&nbsp;&nbsp;&nbsp=
; |&nbsp; 3 &#43;&#43;&#43;</font></div>
<div><font color=3D"#1F497D"> libmultipath/structs.h&nbsp;&nbsp;&nbsp;&nbsp=
; | 14 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;----</font></div>
<div><font color=3D"#1F497D"> libmultipath/structs_vec.c |&nbsp; 6 &#43;&#4=
3;&#43;&#43;&#43;&#43;</font></div>
<div><font color=3D"#1F497D"> multipath/multipath.conf.5 | 57 &#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;</font></div>
<div><font color=3D"#1F497D"> multipathd/main.c&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; | 70 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#4=
3;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;---</fon=
t></div>
<div><font color=3D"#1F497D">&nbsp;</font></div>
<div><font color=3D"#1F497D">&nbsp;</font></div>
<div><font color=3D"#1F497D">Regards,</font></div>
<div><font color=3D"#1F497D">Muneendra.</font></div>
<div><font color=3D"#1F497D">&nbsp;</font></div>
<div>_____________________________________________<br>

<b>From:</b> Muneendra Kumar M <br>

<b>Sent:</b> Tuesday, January 17, 2017 4:13 PM<br>

<b>To:</b> 'Benjamin Marzinski' &lt;bmarzins@redhat.com&gt;<br>

<b>Cc:</b> dm-devel@redhat.com<br>

<b>Subject:</b> RE: [dm-devel] deterministic io throughput in multipath</di=
v>
<div>&nbsp;</div>
<div>&nbsp;</div>
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
<div>&nbsp;</div>
<div>-----Original Message-----<br>

From: Benjamin Marzinski [<a href=3D"mailto:bmarzins@redhat.com"><font colo=
r=3D"#0563C1"><u>mailto:bmarzins@redhat.com</u></font></a>]
<br>

Sent: Tuesday, January 17, 2017 6:35 AM<br>

To: Muneendra Kumar M &lt;<a href=3D"mailto:mmandala@Brocade.com"><font col=
or=3D"#0563C1"><u>mmandala@Brocade.com</u></font></a>&gt;<br>

Cc: <a href=3D"mailto:dm-devel@redhat.com"><font color=3D"#0563C1"><u>dm-de=
vel@redhat.com</u></font></a><br>

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

--_000_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_--

--_004_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_
Content-Type: application/octet-stream; name="san_path_error.patch"
Content-Description: san_path_error.patch
Content-Disposition: attachment; filename="san_path_error.patch"; size=23007;
	creation-date="Mon, 23 Jan 2017 06:23:07 GMT";
	modification-date="Mon, 23 Jan 2017 06:26:33 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWcuYyBiL2xpYm11bHRpcGF0aC9jb25maWcu
YwppbmRleCAxNWRkYmQ4Li5iZTM4NGFmIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvY29uZmln
LmMKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZy5jCkBAIC0zNDgsNiArMzQ4LDkgQEAgbWVyZ2Vf
aHdlIChzdHJ1Y3QgaHdlbnRyeSAqIGRzdCwgc3RydWN0IGh3ZW50cnkgKiBzcmMpCiAJbWVyZ2Vf
bnVtKGRlbGF5X3dhaXRfY2hlY2tzKTsKIAltZXJnZV9udW0oc2tpcF9rcGFydHgpOwogCW1lcmdl
X251bShtYXhfc2VjdG9yc19rYik7CisJbWVyZ2VfbnVtKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQp
OworCW1lcmdlX251bShzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUpOworCW1lcmdlX251bShzYW5f
cGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CiAKIAkvKgogCSAqIE1ha2Ugc3VyZSBmZWF0dXJlcyBp
cyBjb25zaXN0ZW50IHdpdGgKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWcuaCBiL2xp
Ym11bHRpcGF0aC9jb25maWcuaAppbmRleCA5NjcwMDIwLi45ZTQ3ODk0IDEwMDY0NAotLS0gYS9s
aWJtdWx0aXBhdGgvY29uZmlnLmgKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZy5oCkBAIC02NSw2
ICs2NSw5IEBAIHN0cnVjdCBod2VudHJ5IHsKIAlpbnQgZGVmZXJyZWRfcmVtb3ZlOwogCWludCBk
ZWxheV93YXRjaF9jaGVja3M7CiAJaW50IGRlbGF5X3dhaXRfY2hlY2tzOworCWludCBzYW5fcGF0
aF9lcnJfdGhyZXNob2xkOworCWludCBzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGU7CisJaW50IHNh
bl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lOwogCWludCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3Nl
Y3RvcnNfa2I7CiAJY2hhciAqIGJsX3Byb2R1Y3Q7CkBAIC05Myw2ICs5Niw5IEBAIHN0cnVjdCBt
cGVudHJ5IHsKIAlpbnQgZGVmZXJyZWRfcmVtb3ZlOwogCWludCBkZWxheV93YXRjaF9jaGVja3M7
CiAJaW50IGRlbGF5X3dhaXRfY2hlY2tzOworCWludCBzYW5fcGF0aF9lcnJfdGhyZXNob2xkOwor
CWludCBzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGU7CisJaW50IHNhbl9wYXRoX2Vycl9yZWNvdmVy
eV90aW1lOwogCWludCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3NlY3RvcnNfa2I7CiAJdWlkX3Qg
dWlkOwpAQCAtMTM4LDYgKzE0NCw5IEBAIHN0cnVjdCBjb25maWcgewogCWludCBwcm9jZXNzZWRf
bWFpbl9jb25maWc7CiAJaW50IGRlbGF5X3dhdGNoX2NoZWNrczsKIAlpbnQgZGVsYXlfd2FpdF9j
aGVja3M7CisJaW50IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQ7CisJaW50IHNhbl9wYXRoX2Vycl9m
b3JnZXRfcmF0ZTsKKwlpbnQgc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWU7CiAJaW50IHV4c29j
a190aW1lb3V0OwogCWludCBzdHJpY3RfdGltaW5nOwogCWludCByZXRyaWdnZXJfdHJpZXM7CmRp
ZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvY29uZmlndXJlLmMgYi9saWJtdWx0aXBhdGgvY29uZmln
dXJlLmMKaW5kZXggYTBmY2FkOS4uNWFkMzAwNyAxMDA2NDQKLS0tIGEvbGlibXVsdGlwYXRoL2Nv
bmZpZ3VyZS5jCisrKyBiL2xpYm11bHRpcGF0aC9jb25maWd1cmUuYwpAQCAtMjk0LDYgKzI5NCw5
IEBAIGludCBzZXR1cF9tYXAoc3RydWN0IG11bHRpcGF0aCAqbXBwLCBjaGFyICpwYXJhbXMsIGlu
dCBwYXJhbXNfc2l6ZSkKIAlzZWxlY3RfZGVmZXJyZWRfcmVtb3ZlKGNvbmYsIG1wcCk7CiAJc2Vs
ZWN0X2RlbGF5X3dhdGNoX2NoZWNrcyhjb25mLCBtcHApOwogCXNlbGVjdF9kZWxheV93YWl0X2No
ZWNrcyhjb25mLCBtcHApOworCXNlbGVjdF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkKGNvbmYsIG1w
cCk7CisJc2VsZWN0X3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZShjb25mLCBtcHApOworCXNlbGVj
dF9zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZShjb25mLCBtcHApOwogCXNlbGVjdF9za2lwX2tw
YXJ0eChjb25mLCBtcHApOwogCXNlbGVjdF9tYXhfc2VjdG9yc19rYihjb25mLCBtcHApOwogCmRp
ZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvZGVmYXVsdHMuaCBiL2xpYm11bHRpcGF0aC9kZWZhdWx0
cy5oCmluZGV4IGI5YjBhMzcuLjNlZjE1NzkgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9kZWZh
dWx0cy5oCisrKyBiL2xpYm11bHRpcGF0aC9kZWZhdWx0cy5oCkBAIC0yMyw3ICsyMyw4IEBACiAj
ZGVmaW5lIERFRkFVTFRfUkVUQUlOX0hXSEFORExFUiBSRVRBSU5fSFdIQU5ETEVSX09OCiAjZGVm
aW5lIERFRkFVTFRfREVURUNUX1BSSU8JREVURUNUX1BSSU9fT04KICNkZWZpbmUgREVGQVVMVF9E
RUZFUlJFRF9SRU1PVkUJREVGRVJSRURfUkVNT1ZFX09GRgotI2RlZmluZSBERUZBVUxUX0RFTEFZ
X0NIRUNLUwlERUxBWV9DSEVDS1NfT0ZGCisjZGVmaW5lIERFRkFVTFRfREVMQVlfQ0hFQ0tTCU5V
X05PCisjZGVmaW5lIERFRkFVTFRfRVJSX0NIRUNLUwlOVV9OTwogI2RlZmluZSBERUZBVUxUX1VF
VkVOVF9TVEFDS1NJWkUgMjU2CiAjZGVmaW5lIERFRkFVTFRfUkVUUklHR0VSX0RFTEFZCTEwCiAj
ZGVmaW5lIERFRkFVTFRfUkVUUklHR0VSX1RSSUVTCTMKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0
aC9kaWN0LmMgYi9saWJtdWx0aXBhdGgvZGljdC5jCmluZGV4IGRjMjE4NDYuLjQ3NTQ1NzIgMTAw
NjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9kaWN0LmMKKysrIGIvbGlibXVsdGlwYXRoL2RpY3QuYwpA
QCAtMTAyMyw3ICsxMDIzLDcgQEAgZGVjbGFyZV9tcF9oYW5kbGVyKHJlc2VydmF0aW9uX2tleSwg
c2V0X3Jlc2VydmF0aW9uX2tleSkKIGRlY2xhcmVfbXBfc25wcmludChyZXNlcnZhdGlvbl9rZXks
IHByaW50X3Jlc2VydmF0aW9uX2tleSkKIAogc3RhdGljIGludAotc2V0X2RlbGF5X2NoZWNrcyh2
ZWN0b3Igc3RydmVjLCB2b2lkICpwdHIpCitzZXRfb2ZmX2ludF91bmRlZih2ZWN0b3Igc3RydmVj
LCB2b2lkICpwdHIpCiB7CiAJaW50ICppbnRfcHRyID0gKGludCAqKXB0cjsKIAljaGFyICogYnVm
ZjsKQEAgLTEwMzMsNDcgKzEwMzMsNjkgQEAgc2V0X2RlbGF5X2NoZWNrcyh2ZWN0b3Igc3RydmVj
LCB2b2lkICpwdHIpCiAJCXJldHVybiAxOwogCiAJaWYgKCFzdHJjbXAoYnVmZiwgIm5vIikgfHwg
IXN0cmNtcChidWZmLCAiMCIpKQotCQkqaW50X3B0ciA9IERFTEFZX0NIRUNLU19PRkY7CisJCSpp
bnRfcHRyID0gTlVfTk87CiAJZWxzZSBpZiAoKCppbnRfcHRyID0gYXRvaShidWZmKSkgPCAxKQot
CQkqaW50X3B0ciA9IERFTEFZX0NIRUNLU19VTkRFRjsKKwkJKmludF9wdHIgPSBOVV9VTkRFRjsK
IAogCUZSRUUoYnVmZik7CiAJcmV0dXJuIDA7CiB9CiAKIGludAotcHJpbnRfZGVsYXlfY2hlY2tz
KGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpCitwcmludF9vZmZfaW50X3VuZGVmKGNo
YXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpCiB7CiAJaW50ICppbnRfcHRyID0gKGludCAq
KXB0cjsKIAogCXN3aXRjaCgqaW50X3B0cikgewotCWNhc2UgREVMQVlfQ0hFQ0tTX1VOREVGOgor
CWNhc2UgTlVfVU5ERUY6CiAJCXJldHVybiAwOwotCWNhc2UgREVMQVlfQ0hFQ0tTX09GRjoKKwlj
YXNlIE5VX05POgogCQlyZXR1cm4gc25wcmludGYoYnVmZiwgbGVuLCAiXCJvZmZcIiIpOwogCWRl
ZmF1bHQ6CiAJCXJldHVybiBzbnByaW50ZihidWZmLCBsZW4sICIlaSIsICppbnRfcHRyKTsKIAl9
CiB9CiAKLWRlY2xhcmVfZGVmX2hhbmRsZXIoZGVsYXlfd2F0Y2hfY2hlY2tzLCBzZXRfZGVsYXlf
Y2hlY2tzKQotZGVjbGFyZV9kZWZfc25wcmludChkZWxheV93YXRjaF9jaGVja3MsIHByaW50X2Rl
bGF5X2NoZWNrcykKLWRlY2xhcmVfb3ZyX2hhbmRsZXIoZGVsYXlfd2F0Y2hfY2hlY2tzLCBzZXRf
ZGVsYXlfY2hlY2tzKQotZGVjbGFyZV9vdnJfc25wcmludChkZWxheV93YXRjaF9jaGVja3MsIHBy
aW50X2RlbGF5X2NoZWNrcykKLWRlY2xhcmVfaHdfaGFuZGxlcihkZWxheV93YXRjaF9jaGVja3Ms
IHNldF9kZWxheV9jaGVja3MpCi1kZWNsYXJlX2h3X3NucHJpbnQoZGVsYXlfd2F0Y2hfY2hlY2tz
LCBwcmludF9kZWxheV9jaGVja3MpCi1kZWNsYXJlX21wX2hhbmRsZXIoZGVsYXlfd2F0Y2hfY2hl
Y2tzLCBzZXRfZGVsYXlfY2hlY2tzKQotZGVjbGFyZV9tcF9zbnByaW50KGRlbGF5X3dhdGNoX2No
ZWNrcywgcHJpbnRfZGVsYXlfY2hlY2tzKQotCi1kZWNsYXJlX2RlZl9oYW5kbGVyKGRlbGF5X3dh
aXRfY2hlY2tzLCBzZXRfZGVsYXlfY2hlY2tzKQotZGVjbGFyZV9kZWZfc25wcmludChkZWxheV93
YWl0X2NoZWNrcywgcHJpbnRfZGVsYXlfY2hlY2tzKQotZGVjbGFyZV9vdnJfaGFuZGxlcihkZWxh
eV93YWl0X2NoZWNrcywgc2V0X2RlbGF5X2NoZWNrcykKLWRlY2xhcmVfb3ZyX3NucHJpbnQoZGVs
YXlfd2FpdF9jaGVja3MsIHByaW50X2RlbGF5X2NoZWNrcykKLWRlY2xhcmVfaHdfaGFuZGxlcihk
ZWxheV93YWl0X2NoZWNrcywgc2V0X2RlbGF5X2NoZWNrcykKLWRlY2xhcmVfaHdfc25wcmludChk
ZWxheV93YWl0X2NoZWNrcywgcHJpbnRfZGVsYXlfY2hlY2tzKQotZGVjbGFyZV9tcF9oYW5kbGVy
KGRlbGF5X3dhaXRfY2hlY2tzLCBzZXRfZGVsYXlfY2hlY2tzKQotZGVjbGFyZV9tcF9zbnByaW50
KGRlbGF5X3dhaXRfY2hlY2tzLCBwcmludF9kZWxheV9jaGVja3MpCi0KK2RlY2xhcmVfZGVmX2hh
bmRsZXIoZGVsYXlfd2F0Y2hfY2hlY2tzLCBzZXRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfZGVm
X3NucHJpbnQoZGVsYXlfd2F0Y2hfY2hlY2tzLCBwcmludF9vZmZfaW50X3VuZGVmKQorZGVjbGFy
ZV9vdnJfaGFuZGxlcihkZWxheV93YXRjaF9jaGVja3MsIHNldF9vZmZfaW50X3VuZGVmKQorZGVj
bGFyZV9vdnJfc25wcmludChkZWxheV93YXRjaF9jaGVja3MsIHByaW50X29mZl9pbnRfdW5kZWYp
CitkZWNsYXJlX2h3X2hhbmRsZXIoZGVsYXlfd2F0Y2hfY2hlY2tzLCBzZXRfb2ZmX2ludF91bmRl
ZikKK2RlY2xhcmVfaHdfc25wcmludChkZWxheV93YXRjaF9jaGVja3MsIHByaW50X29mZl9pbnRf
dW5kZWYpCitkZWNsYXJlX21wX2hhbmRsZXIoZGVsYXlfd2F0Y2hfY2hlY2tzLCBzZXRfb2ZmX2lu
dF91bmRlZikKK2RlY2xhcmVfbXBfc25wcmludChkZWxheV93YXRjaF9jaGVja3MsIHByaW50X29m
Zl9pbnRfdW5kZWYpCitkZWNsYXJlX2RlZl9oYW5kbGVyKGRlbGF5X3dhaXRfY2hlY2tzLCBzZXRf
b2ZmX2ludF91bmRlZikKK2RlY2xhcmVfZGVmX3NucHJpbnQoZGVsYXlfd2FpdF9jaGVja3MsIHBy
aW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX292cl9oYW5kbGVyKGRlbGF5X3dhaXRfY2hlY2tz
LCBzZXRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfb3ZyX3NucHJpbnQoZGVsYXlfd2FpdF9jaGVj
a3MsIHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX2h3X2hhbmRsZXIoZGVsYXlfd2FpdF9j
aGVja3MsIHNldF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9od19zbnByaW50KGRlbGF5X3dhaXRf
Y2hlY2tzLCBwcmludF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9tcF9oYW5kbGVyKGRlbGF5X3dh
aXRfY2hlY2tzLCBzZXRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfbXBfc25wcmludChkZWxheV93
YWl0X2NoZWNrcywgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfZGVmX2hhbmRsZXIoc2Fu
X3BhdGhfZXJyX3RocmVzaG9sZCwgc2V0X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX2RlZl9zbnBy
aW50KHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJl
X292cl9oYW5kbGVyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHNldF9vZmZfaW50X3VuZGVmKQor
ZGVjbGFyZV9vdnJfc25wcmludChzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBwcmludF9vZmZfaW50
X3VuZGVmKQorZGVjbGFyZV9od19oYW5kbGVyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQsIHNldF9v
ZmZfaW50X3VuZGVmKQorZGVjbGFyZV9od19zbnByaW50KHNhbl9wYXRoX2Vycl90aHJlc2hvbGQs
IHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX21wX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZCwgc2V0X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX21wX3NucHJpbnQoc2FuX3BhdGhf
ZXJyX3RocmVzaG9sZCwgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfZGVmX2hhbmRsZXIo
c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlLCBzZXRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfZGVm
X3NucHJpbnQoc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlLCBwcmludF9vZmZfaW50X3VuZGVmKQor
ZGVjbGFyZV9vdnJfaGFuZGxlcihzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUsIHNldF9vZmZfaW50
X3VuZGVmKQorZGVjbGFyZV9vdnJfc25wcmludChzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUsIHBy
aW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX2h3X2hhbmRsZXIoc2FuX3BhdGhfZXJyX2Zvcmdl
dF9yYXRlLCBzZXRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfaHdfc25wcmludChzYW5fcGF0aF9l
cnJfZm9yZ2V0X3JhdGUsIHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX21wX2hhbmRsZXIo
c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlLCBzZXRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfbXBf
c25wcmludChzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUsIHByaW50X29mZl9pbnRfdW5kZWYpCitk
ZWNsYXJlX2RlZl9oYW5kbGVyKHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lLCBzZXRfb2ZmX2lu
dF91bmRlZikKK2RlY2xhcmVfZGVmX3NucHJpbnQoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUs
IHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX292cl9oYW5kbGVyKHNhbl9wYXRoX2Vycl9y
ZWNvdmVyeV90aW1lLCBzZXRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfb3ZyX3NucHJpbnQoc2Fu
X3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX2h3
X2hhbmRsZXIoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIHNldF9vZmZfaW50X3VuZGVmKQor
ZGVjbGFyZV9od19zbnByaW50KHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lLCBwcmludF9vZmZf
aW50X3VuZGVmKQorZGVjbGFyZV9tcF9oYW5kbGVyKHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1l
LCBzZXRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfbXBfc25wcmludChzYW5fcGF0aF9lcnJfcmVj
b3ZlcnlfdGltZSwgcHJpbnRfb2ZmX2ludF91bmRlZikKIHN0YXRpYyBpbnQKIGRlZl91eHNvY2tf
dGltZW91dF9oYW5kbGVyKHN0cnVjdCBjb25maWcgKmNvbmYsIHZlY3RvciBzdHJ2ZWMpCiB7CkBA
IC0xNDA0LDYgKzE0MjYsMTAgQEAgaW5pdF9rZXl3b3Jkcyh2ZWN0b3Iga2V5d29yZHMpCiAJaW5z
dGFsbF9rZXl3b3JkKCJjb25maWdfZGlyIiwgJmRlZl9jb25maWdfZGlyX2hhbmRsZXIsICZzbnBy
aW50X2RlZl9jb25maWdfZGlyKTsKIAlpbnN0YWxsX2tleXdvcmQoImRlbGF5X3dhdGNoX2NoZWNr
cyIsICZkZWZfZGVsYXlfd2F0Y2hfY2hlY2tzX2hhbmRsZXIsICZzbnByaW50X2RlZl9kZWxheV93
YXRjaF9jaGVja3MpOwogCWluc3RhbGxfa2V5d29yZCgiZGVsYXlfd2FpdF9jaGVja3MiLCAmZGVm
X2RlbGF5X3dhaXRfY2hlY2tzX2hhbmRsZXIsICZzbnByaW50X2RlZl9kZWxheV93YWl0X2NoZWNr
cyk7CisgICAgICAgIGluc3RhbGxfa2V5d29yZCgic2FuX3BhdGhfZXJyX3RocmVzaG9sZCIsICZk
ZWZfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF9oYW5kbGVyLCAmc25wcmludF9kZWZfc2FuX3BhdGhf
ZXJyX3RocmVzaG9sZCk7CisgICAgICAgIGluc3RhbGxfa2V5d29yZCgic2FuX3BhdGhfZXJyX2Zv
cmdldF9yYXRlIiwgJmRlZl9zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGVfaGFuZGxlciwgJnNucHJp
bnRfZGVmX3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSk7CisgICAgICAgIGluc3RhbGxfa2V5d29y
ZCgic2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUiLCAmZGVmX3Nhbl9wYXRoX2Vycl9yZWNvdmVy
eV90aW1lX2hhbmRsZXIsICZzbnByaW50X2RlZl9zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7
CisKIAlpbnN0YWxsX2tleXdvcmQoImZpbmRfbXVsdGlwYXRocyIsICZkZWZfZmluZF9tdWx0aXBh
dGhzX2hhbmRsZXIsICZzbnByaW50X2RlZl9maW5kX211bHRpcGF0aHMpOwogCWluc3RhbGxfa2V5
d29yZCgidXhzb2NrX3RpbWVvdXQiLCAmZGVmX3V4c29ja190aW1lb3V0X2hhbmRsZXIsICZzbnBy
aW50X2RlZl91eHNvY2tfdGltZW91dCk7CiAJaW5zdGFsbF9rZXl3b3JkKCJyZXRyaWdnZXJfdHJp
ZXMiLCAmZGVmX3JldHJpZ2dlcl90cmllc19oYW5kbGVyLCAmc25wcmludF9kZWZfcmV0cmlnZ2Vy
X3RyaWVzKTsKQEAgLTE0ODYsNiArMTUxMiw5IEBAIGluaXRfa2V5d29yZHModmVjdG9yIGtleXdv
cmRzKQogCWluc3RhbGxfa2V5d29yZCgiZGVmZXJyZWRfcmVtb3ZlIiwgJmh3X2RlZmVycmVkX3Jl
bW92ZV9oYW5kbGVyLCAmc25wcmludF9od19kZWZlcnJlZF9yZW1vdmUpOwogCWluc3RhbGxfa2V5
d29yZCgiZGVsYXlfd2F0Y2hfY2hlY2tzIiwgJmh3X2RlbGF5X3dhdGNoX2NoZWNrc19oYW5kbGVy
LCAmc25wcmludF9od19kZWxheV93YXRjaF9jaGVja3MpOwogCWluc3RhbGxfa2V5d29yZCgiZGVs
YXlfd2FpdF9jaGVja3MiLCAmaHdfZGVsYXlfd2FpdF9jaGVja3NfaGFuZGxlciwgJnNucHJpbnRf
aHdfZGVsYXlfd2FpdF9jaGVja3MpOworICAgICAgICBpbnN0YWxsX2tleXdvcmQoInNhbl9wYXRo
X2Vycl90aHJlc2hvbGQiLCAmaHdfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF9oYW5kbGVyLCAmc25w
cmludF9od19zYW5fcGF0aF9lcnJfdGhyZXNob2xkKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3Jk
KCJzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUiLCAmaHdfc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRl
X2hhbmRsZXIsICZzbnByaW50X2h3X3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSk7CisgICAgICAg
IGluc3RhbGxfa2V5d29yZCgic2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUiLCAmaHdfc2FuX3Bh
dGhfZXJyX3JlY292ZXJ5X3RpbWVfaGFuZGxlciwgJnNucHJpbnRfaHdfc2FuX3BhdGhfZXJyX3Jl
Y292ZXJ5X3RpbWUpOwogCWluc3RhbGxfa2V5d29yZCgic2tpcF9rcGFydHgiLCAmaHdfc2tpcF9r
cGFydHhfaGFuZGxlciwgJnNucHJpbnRfaHdfc2tpcF9rcGFydHgpOwogCWluc3RhbGxfa2V5d29y
ZCgibWF4X3NlY3RvcnNfa2IiLCAmaHdfbWF4X3NlY3RvcnNfa2JfaGFuZGxlciwgJnNucHJpbnRf
aHdfbWF4X3NlY3RvcnNfa2IpOwogCWluc3RhbGxfc3VibGV2ZWxfZW5kKCk7CkBAIC0xNTE1LDYg
KzE1NDQsMTAgQEAgaW5pdF9rZXl3b3Jkcyh2ZWN0b3Iga2V5d29yZHMpCiAJaW5zdGFsbF9rZXl3
b3JkKCJkZWZlcnJlZF9yZW1vdmUiLCAmb3ZyX2RlZmVycmVkX3JlbW92ZV9oYW5kbGVyLCAmc25w
cmludF9vdnJfZGVmZXJyZWRfcmVtb3ZlKTsKIAlpbnN0YWxsX2tleXdvcmQoImRlbGF5X3dhdGNo
X2NoZWNrcyIsICZvdnJfZGVsYXlfd2F0Y2hfY2hlY2tzX2hhbmRsZXIsICZzbnByaW50X292cl9k
ZWxheV93YXRjaF9jaGVja3MpOwogCWluc3RhbGxfa2V5d29yZCgiZGVsYXlfd2FpdF9jaGVja3Mi
LCAmb3ZyX2RlbGF5X3dhaXRfY2hlY2tzX2hhbmRsZXIsICZzbnByaW50X292cl9kZWxheV93YWl0
X2NoZWNrcyk7CisgICAgICAgIGluc3RhbGxfa2V5d29yZCgic2FuX3BhdGhfZXJyX3RocmVzaG9s
ZCIsICZvdnJfc2FuX3BhdGhfZXJyX3RocmVzaG9sZF9oYW5kbGVyLCAmc25wcmludF9vdnJfc2Fu
X3BhdGhfZXJyX3RocmVzaG9sZCk7CisgICAgICAgIGluc3RhbGxfa2V5d29yZCgic2FuX3BhdGhf
ZXJyX2ZvcmdldF9yYXRlIiwgJm92cl9zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGVfaGFuZGxlciwg
JnNucHJpbnRfb3ZyX3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSk7CisgICAgICAgIGluc3RhbGxf
a2V5d29yZCgic2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUiLCAmb3ZyX3Nhbl9wYXRoX2Vycl9y
ZWNvdmVyeV90aW1lX2hhbmRsZXIsICZzbnByaW50X292cl9zYW5fcGF0aF9lcnJfcmVjb3Zlcnlf
dGltZSk7CisKIAlpbnN0YWxsX2tleXdvcmQoInNraXBfa3BhcnR4IiwgJm92cl9za2lwX2twYXJ0
eF9oYW5kbGVyLCAmc25wcmludF9vdnJfc2tpcF9rcGFydHgpOwogCWluc3RhbGxfa2V5d29yZCgi
bWF4X3NlY3RvcnNfa2IiLCAmb3ZyX21heF9zZWN0b3JzX2tiX2hhbmRsZXIsICZzbnByaW50X292
cl9tYXhfc2VjdG9yc19rYik7CiAKQEAgLTE1NDMsNiArMTU3Niw5IEBAIGluaXRfa2V5d29yZHMo
dmVjdG9yIGtleXdvcmRzKQogCWluc3RhbGxfa2V5d29yZCgiZGVmZXJyZWRfcmVtb3ZlIiwgJm1w
X2RlZmVycmVkX3JlbW92ZV9oYW5kbGVyLCAmc25wcmludF9tcF9kZWZlcnJlZF9yZW1vdmUpOwog
CWluc3RhbGxfa2V5d29yZCgiZGVsYXlfd2F0Y2hfY2hlY2tzIiwgJm1wX2RlbGF5X3dhdGNoX2No
ZWNrc19oYW5kbGVyLCAmc25wcmludF9tcF9kZWxheV93YXRjaF9jaGVja3MpOwogCWluc3RhbGxf
a2V5d29yZCgiZGVsYXlfd2FpdF9jaGVja3MiLCAmbXBfZGVsYXlfd2FpdF9jaGVja3NfaGFuZGxl
ciwgJnNucHJpbnRfbXBfZGVsYXlfd2FpdF9jaGVja3MpOworCWluc3RhbGxfa2V5d29yZCgic2Fu
X3BhdGhfZXJyX3RocmVzaG9sZCIsICZtcF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkX2hhbmRsZXIs
ICZzbnByaW50X21wX3Nhbl9wYXRoX2Vycl90aHJlc2hvbGQpOworCWluc3RhbGxfa2V5d29yZCgi
c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlIiwgJm1wX3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZV9o
YW5kbGVyLCAmc25wcmludF9tcF9zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUpOworCWluc3RhbGxf
a2V5d29yZCgic2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUiLCAmbXBfc2FuX3BhdGhfZXJyX3Jl
Y292ZXJ5X3RpbWVfaGFuZGxlciwgJnNucHJpbnRfbXBfc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3Rp
bWUpOwogCWluc3RhbGxfa2V5d29yZCgic2tpcF9rcGFydHgiLCAmbXBfc2tpcF9rcGFydHhfaGFu
ZGxlciwgJnNucHJpbnRfbXBfc2tpcF9rcGFydHgpOwogCWluc3RhbGxfa2V5d29yZCgibWF4X3Nl
Y3RvcnNfa2IiLCAmbXBfbWF4X3NlY3RvcnNfa2JfaGFuZGxlciwgJnNucHJpbnRfbXBfbWF4X3Nl
Y3RvcnNfa2IpOwogCWluc3RhbGxfc3VibGV2ZWxfZW5kKCk7CmRpZmYgLS1naXQgYS9saWJtdWx0
aXBhdGgvZGljdC5oIGIvbGlibXVsdGlwYXRoL2RpY3QuaAppbmRleCA0Y2QwM2M1Li4yZDYwOTdk
IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvZGljdC5oCisrKyBiL2xpYm11bHRpcGF0aC9kaWN0
LmgKQEAgLTE0LDYgKzE0LDUgQEAgaW50IHByaW50X25vX3BhdGhfcmV0cnkoY2hhciAqIGJ1ZmYs
IGludCBsZW4sIHZvaWQgKnB0cik7CiBpbnQgcHJpbnRfZmFzdF9pb19mYWlsKGNoYXIgKiBidWZm
LCBpbnQgbGVuLCB2b2lkICpwdHIpOwogaW50IHByaW50X2Rldl9sb3NzKGNoYXIgKiBidWZmLCBp
bnQgbGVuLCB2b2lkICpwdHIpOwogaW50IHByaW50X3Jlc2VydmF0aW9uX2tleShjaGFyICogYnVm
ZiwgaW50IGxlbiwgdm9pZCAqIHB0cik7Ci1pbnQgcHJpbnRfZGVsYXlfY2hlY2tzKGNoYXIgKiBi
dWZmLCBpbnQgbGVuLCB2b2lkICpwdHIpOwotCitpbnQgcHJpbnRfb2ZmX2ludF91bmRlZihjaGFy
ICogYnVmZiwgaW50IGxlbiwgdm9pZCAqcHRyKTsKICNlbmRpZiAvKiBfRElDVF9IICovCmRpZmYg
LS1naXQgYS9saWJtdWx0aXBhdGgvcHJvcHNlbC5jIGIvbGlibXVsdGlwYXRoL3Byb3BzZWwuYwpp
bmRleCBjMGJjNjE2Li5lNGFmZWY3IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvcHJvcHNlbC5j
CisrKyBiL2xpYm11bHRpcGF0aC9wcm9wc2VsLmMKQEAgLTYyMyw3ICs2MjMsNyBAQCBpbnQgc2Vs
ZWN0X2RlbGF5X3dhdGNoX2NoZWNrcyhzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3QgbXVsdGlw
YXRoICptcCkKIAltcF9zZXRfY29uZihkZWxheV93YXRjaF9jaGVja3MpOwogCW1wX3NldF9kZWZh
dWx0KGRlbGF5X3dhdGNoX2NoZWNrcywgREVGQVVMVF9ERUxBWV9DSEVDS1MpOwogb3V0OgotCXBy
aW50X2RlbGF5X2NoZWNrcyhidWZmLCAxMiwgJm1wLT5kZWxheV93YXRjaF9jaGVja3MpOworCXBy
aW50X29mZl9pbnRfdW5kZWYoYnVmZiwgMTIsICZtcC0+ZGVsYXlfd2F0Y2hfY2hlY2tzKTsKIAlj
b25kbG9nKDMsICIlczogZGVsYXlfd2F0Y2hfY2hlY2tzID0gJXMgJXMiLCBtcC0+YWxpYXMsIGJ1
ZmYsIG9yaWdpbik7CiAJcmV0dXJuIDA7CiB9CkBAIC02MzgsMTIgKzYzOCw1NiBAQCBpbnQgc2Vs
ZWN0X2RlbGF5X3dhaXRfY2hlY2tzKHN0cnVjdCBjb25maWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBh
dGggKm1wKQogCW1wX3NldF9jb25mKGRlbGF5X3dhaXRfY2hlY2tzKTsKIAltcF9zZXRfZGVmYXVs
dChkZWxheV93YWl0X2NoZWNrcywgREVGQVVMVF9ERUxBWV9DSEVDS1MpOwogb3V0OgotCXByaW50
X2RlbGF5X2NoZWNrcyhidWZmLCAxMiwgJm1wLT5kZWxheV93YWl0X2NoZWNrcyk7CisJcHJpbnRf
b2ZmX2ludF91bmRlZihidWZmLCAxMiwgJm1wLT5kZWxheV93YWl0X2NoZWNrcyk7CiAJY29uZGxv
ZygzLCAiJXM6IGRlbGF5X3dhaXRfY2hlY2tzID0gJXMgJXMiLCBtcC0+YWxpYXMsIGJ1ZmYsIG9y
aWdpbik7CiAJcmV0dXJuIDA7CiAKIH0KK2ludCBzZWxlY3Rfc2FuX3BhdGhfZXJyX3RocmVzaG9s
ZChzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3QgbXVsdGlwYXRoICptcCkKK3sKKyAgICAgICAg
Y2hhciAqb3JpZ2luLCBidWZmWzEyXTsKKworICAgICAgICBtcF9zZXRfbXBlKHNhbl9wYXRoX2Vy
cl90aHJlc2hvbGQpOworICAgICAgICBtcF9zZXRfb3ZyKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQp
OworICAgICAgICBtcF9zZXRfaHdlKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQpOworICAgICAgICBt
cF9zZXRfY29uZihzYW5fcGF0aF9lcnJfdGhyZXNob2xkKTsKKyAgICAgICAgbXBfc2V0X2RlZmF1
bHQoc2FuX3BhdGhfZXJyX3RocmVzaG9sZCwgREVGQVVMVF9FUlJfQ0hFQ0tTKTsKK291dDoKKyAg
ICAgICAgcHJpbnRfb2ZmX2ludF91bmRlZihidWZmLCAxMiwgJm1wLT5zYW5fcGF0aF9lcnJfdGhy
ZXNob2xkKTsKKyAgICAgICAgY29uZGxvZygzLCAiJXM6IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQg
PSAlcyAlcyIsIG1wLT5hbGlhcywgYnVmZiwgb3JpZ2luKTsKKyAgICAgICAgcmV0dXJuIDA7Cit9
CisKK2ludCBzZWxlY3Rfc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlKHN0cnVjdCBjb25maWcgKmNv
bmYsIHN0cnVjdCBtdWx0aXBhdGggKm1wKQoreworICAgICAgICBjaGFyICpvcmlnaW4sIGJ1ZmZb
MTJdOworCisgICAgICAgIG1wX3NldF9tcGUoc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlKTsKKyAg
ICAgICAgbXBfc2V0X292cihzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUpOworICAgICAgICBtcF9z
ZXRfaHdlKHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSk7CisgICAgICAgIG1wX3NldF9jb25mKHNh
bl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSk7CisgICAgICAgIG1wX3NldF9kZWZhdWx0KHNhbl9wYXRo
X2Vycl9mb3JnZXRfcmF0ZSwgREVGQVVMVF9FUlJfQ0hFQ0tTKTsKK291dDoKKyAgICAgICAgcHJp
bnRfb2ZmX2ludF91bmRlZihidWZmLCAxMiwgJm1wLT5zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUp
OworICAgICAgICBjb25kbG9nKDMsICIlczogc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlID0gJXMg
JXMiLCBtcC0+YWxpYXMsIGJ1ZmYsIG9yaWdpbik7CisgICAgICAgIHJldHVybiAwOworCit9Citp
bnQgc2VsZWN0X3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKHN0cnVjdCBjb25maWcgKmNvbmYs
IHN0cnVjdCBtdWx0aXBhdGggKm1wKQoreworICAgICAgICBjaGFyICpvcmlnaW4sIGJ1ZmZbMTJd
OwogCisgICAgICAgIG1wX3NldF9tcGUoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUpOworICAg
ICAgICBtcF9zZXRfb3ZyKHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKTsKKyAgICAgICAgbXBf
c2V0X2h3ZShzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CisgICAgICAgIG1wX3NldF9jb25m
KHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKTsKKyAgICAgICAgbXBfc2V0X2RlZmF1bHQoc2Fu
X3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIERFRkFVTFRfRVJSX0NIRUNLUyk7CitvdXQ6CisgICAg
ICAgIHByaW50X29mZl9pbnRfdW5kZWYoYnVmZiwgMTIsICZtcC0+c2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWUpOworICAgICAgICBjb25kbG9nKDMsICIlczogc2FuX3BhdGhfZXJyX3JlY292ZXJ5
X3RpbWUgPSAlcyAlcyIsIG1wLT5hbGlhcywgYnVmZiwgb3JpZ2luKTsKKyAgICAgICAgcmV0dXJu
IDA7CisKK30KIGludCBzZWxlY3Rfc2tpcF9rcGFydHggKHN0cnVjdCBjb25maWcgKmNvbmYsIHN0
cnVjdCBtdWx0aXBhdGggKiBtcCkKIHsKIAljaGFyICpvcmlnaW47CmRpZmYgLS1naXQgYS9saWJt
dWx0aXBhdGgvcHJvcHNlbC5oIGIvbGlibXVsdGlwYXRoL3Byb3BzZWwuaAppbmRleCBhZDk4ZmE1
Li5lNWI2ZjkzIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvcHJvcHNlbC5oCisrKyBiL2xpYm11
bHRpcGF0aC9wcm9wc2VsLmgKQEAgLTI0LDMgKzI0LDYgQEAgaW50IHNlbGVjdF9kZWxheV93YXRj
aF9jaGVja3MgKHN0cnVjdCBjb25maWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKiBtcCk7CiBp
bnQgc2VsZWN0X2RlbGF5X3dhaXRfY2hlY2tzIChzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3Qg
bXVsdGlwYXRoICogbXApOwogaW50IHNlbGVjdF9za2lwX2twYXJ0eCAoc3RydWN0IGNvbmZpZyAq
Y29uZiwgc3RydWN0IG11bHRpcGF0aCAqIG1wKTsKIGludCBzZWxlY3RfbWF4X3NlY3RvcnNfa2Ig
KHN0cnVjdCBjb25maWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKiBtcCk7CitpbnQgc2VsZWN0
X3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZShzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3QgbXVs
dGlwYXRoICptcCk7CitpbnQgc2VsZWN0X3Nhbl9wYXRoX2Vycl90aHJlc2hvbGQoc3RydWN0IGNv
bmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXApOworaW50IHNlbGVjdF9zYW5fcGF0aF9l
cnJfcmVjb3ZlcnlfdGltZShzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3QgbXVsdGlwYXRoICpt
cCk7CmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvc3RydWN0cy5oIGIvbGlibXVsdGlwYXRoL3N0
cnVjdHMuaAppbmRleCAzOTZmNjlkLi42ZWRkOTI3IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
c3RydWN0cy5oCisrKyBiL2xpYm11bHRpcGF0aC9zdHJ1Y3RzLmgKQEAgLTE1Miw5ICsxNTIsOSBA
QCBlbnVtIHNjc2lfcHJvdG9jb2wgewogCVNDU0lfUFJPVE9DT0xfVU5TUEVDID0gMHhmLCAvKiBO
byBzcGVjaWZpYyBwcm90b2NvbCAqLwogfTsKIAotZW51bSBkZWxheV9jaGVja3Nfc3RhdGVzIHsK
LQlERUxBWV9DSEVDS1NfT0ZGID0gLTEsCi0JREVMQVlfQ0hFQ0tTX1VOREVGID0gMCwKK2VudW0g
bm9fdW5kZWZfc3RhdGVzIHsKKwlOVV9OTyA9IC0xLAorCU5VX1VOREVGID0gMCwKIH07CiAKIGVu
dW0gaW5pdGlhbGl6ZWRfc3RhdGVzIHsKQEAgLTIyMyw3ICsyMjMsMTAgQEAgc3RydWN0IHBhdGgg
ewogCWludCBpbml0aWFsaXplZDsKIAlpbnQgcmV0cmlnZ2VyczsKIAlpbnQgd3dpZF9jaGFuZ2Vk
OwotCisJdW5zaWduZWQgaW50IHBhdGhfZmFpbHVyZXM7CisJdGltZV90IGRpc19yZWluc3RhdGVf
dGltZTsKKwlpbnQgZGlzYWJsZV9yZWluc3RhdGU7CisJaW50IHNhbl9wYXRoX2Vycl9mb3JnZXRf
cmF0ZTsKIAkvKiBjb25maWdsZXQgcG9pbnRlcnMgKi8KIAlzdHJ1Y3QgaHdlbnRyeSAqIGh3ZTsK
IH07CkBAIC0yNTUsNiArMjU4LDkgQEAgc3RydWN0IG11bHRpcGF0aCB7CiAJaW50IGRlZmVycmVk
X3JlbW92ZTsKIAlpbnQgZGVsYXlfd2F0Y2hfY2hlY2tzOwogCWludCBkZWxheV93YWl0X2NoZWNr
czsKKwlpbnQgc2FuX3BhdGhfZXJyX3RocmVzaG9sZDsKKwlpbnQgc2FuX3BhdGhfZXJyX2Zvcmdl
dF9yYXRlOworCWludCBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZTsKIAlpbnQgc2tpcF9rcGFy
dHg7CiAJaW50IG1heF9zZWN0b3JzX2tiOwogCXVuc2lnbmVkIGludCBkZXZfbG9zczsKZGlmZiAt
LWdpdCBhL2xpYm11bHRpcGF0aC9zdHJ1Y3RzX3ZlYy5jIGIvbGlibXVsdGlwYXRoL3N0cnVjdHNf
dmVjLmMKaW5kZXggMjJiZThlMC4uMWRiYzNiMiAxMDA2NDQKLS0tIGEvbGlibXVsdGlwYXRoL3N0
cnVjdHNfdmVjLmMKKysrIGIvbGlibXVsdGlwYXRoL3N0cnVjdHNfdmVjLmMKQEAgLTU3MCw2ICs1
NzAsMTIgQEAgaW50IHVwZGF0ZV9tdWx0aXBhdGggKHN0cnVjdCB2ZWN0b3JzICp2ZWNzLCBjaGFy
ICptYXBuYW1lLCBpbnQgcmVzZXQpCiAJCQkJaW50IG9sZHN0YXRlID0gcHAtPnN0YXRlOwogCQkJ
CWNvbmRsb2coMiwgIiVzOiBtYXJrIGFzIGZhaWxlZCIsIHBwLT5kZXYpOwogCQkJCW1wcC0+c3Rh
dF9wYXRoX2ZhaWx1cmVzKys7CisJCQkJLyphc3NpZ25lZCAgdGhlIHBhdGhfZXJyX2ZvcmdldF9y
YXRlIHdoZW4gd2Ugc2VlIHRoZSBmaXJzdCBmYWlsdXJlIG9uIHRoZSBwYXRoKi8KKwkJCQlpZiAo
cHAtPnBhdGhfZmFpbHVyZXMgPT0gMCkgeworCQkJCQlwcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9y
YXRlID0gcHAtPm1wcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlOworCQkJCX0KKwkJCQkvKklu
Y3JlbWVudCB0aGUgbnVtYmVyIG9mIHBhdGggZmFpbHVyZXMqLworCQkJCXBwLT5wYXRoX2ZhaWx1
cmVzKys7CiAJCQkJcHAtPnN0YXRlID0gUEFUSF9ET1dOOwogCQkJCWlmIChvbGRzdGF0ZSA9PSBQ
QVRIX1VQIHx8CiAJCQkJICAgIG9sZHN0YXRlID09IFBBVEhfR0hPU1QpCmRpZmYgLS1naXQgYS9t
dWx0aXBhdGgvbXVsdGlwYXRoLmNvbmYuNSBiL211bHRpcGF0aC9tdWx0aXBhdGguY29uZi41Cmlu
ZGV4IDM2NTg5ZjUuLjNjNTY0YWQgMTAwNjQ0Ci0tLSBhL211bHRpcGF0aC9tdWx0aXBhdGguY29u
Zi41CisrKyBiL211bHRpcGF0aC9tdWx0aXBhdGguY29uZi41CkBAIC03NTEsNiArNzUxLDQ1IEBA
IFRoZSBkZWZhdWx0IGlzOiBcZkIvZXRjL211bHRpcGF0aC9jb25mLmQvXGZSCiAuCiAuCiAuVFAK
Ky5CIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKK0lmIHNldCB0byBhIHZhbHVlIGdyZWF0ZXIgdGhh
biAwLCBtdWx0aXBhdGhkIHdpbGwgd2F0Y2ggcGF0aHMgYW5kIGNoZWNrIGhvdyBtYW55Cit0aW1l
cyBhIHBhdGggaGFzIGJlZW4gZmFpbGVkIGR1ZSB0byBlcnJvcnMuSWYgdGhlIG51bWJlciBvZiBm
YWlsdXJlcyBvbiBhIHBhcnRpY3VsYXIKK3BhdGggaXMgZ3JlYXRlciB0aGVuIHRoZSBzYW5fcGF0
aF9lcnJfdGhyZXNob2xkIHRoZW4gdGhlIHBhdGggd2lsbCBub3QgIHJlaW5zdGFudGUKK3RpbGwg
c2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUuVGhlc2UgcGF0aCBmYWlsdXJlcyBzaG91bGQgb2Nj
dXIgd2l0aGluIGEgCitzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUgY2hlY2tzLCBpZiBub3Qgd2Ug
d2lsbCBjb25zaWRlciB0aGUgcGF0aCBpcyBnb29kIGVub3VnaAordG8gcmVpbnN0YW50YXRlLgor
LlJTCisuVFAKK1RoZSBkZWZhdWx0IGlzOiBcZkJub1xmUgorLlJFCisuCisuCisuVFAKKy5CIHNh
bl9wYXRoX2Vycl9mb3JnZXRfcmF0ZQorSWYgc2V0IHRvIGEgdmFsdWUgZ3JlYXRlciB0aGFuIDAs
IG11bHRpcGF0aGQgd2lsbCBjaGVjayB3aGV0aGVyIHRoZSBwYXRoIGZhaWx1cmVzCitoYXMgZXhj
ZWVkZWQgIHRoZSBzYW5fcGF0aF9lcnJfdGhyZXNob2xkIHdpdGhpbiB0aGlzIG1hbnkgY2hlY2tz
IGkuZSAKK3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSAuIElmIHNvIHdlIHdpbGwgbm90IHJlaW5z
dGFudGUgdGhlIHBhdGggdGlsbAorc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUuCisuUlMKKy5U
UAorVGhlIGRlZmF1bHQgaXM6IFxmQm5vXGZSCisuUkUKKy4KKy4KKy5UUAorLkIgc2FuX3BhdGhf
ZXJyX3JlY292ZXJ5X3RpbWUKK0lmIHNldCB0byBhIHZhbHVlIGdyZWF0ZXIgdGhhbiAwLCBtdWx0
aXBhdGhkIHdpbGwgbWFrZSBzdXJlIHRoYXQgd2hlbiBwYXRoIGZhaWx1cmVzCitoYXMgZXhjZWVk
ZWQgdGhlIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQgd2l0aGluIHNhbl9wYXRoX2Vycl9mb3JnZXRf
cmF0ZSB0aGVuIHRoZSBwYXRoCit3aWxsIGJlIHBsYWNlZCBpbiBmYWlsZWQgc3RhdGUgZm9yIHNh
bl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lIGR1cmF0aW9uLk9uY2Ugc2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWUKK2hhcyB0aW1lb3V0ICB3ZSB3aWxsIHJlaW5zdGFudGUgdGhlIGZhaWxlZCBwYXRo
IC4KK3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lIHZhbHVlIHNob3VsZCBiZSBpbiBzZWNzLgor
LlJTCisuVFAKK1RoZSBkZWZhdWx0IGlzOiBcZkJub1xmUgorLlJFCisuCisuCisuVFAKIC5CIGRl
bGF5X3dhdGNoX2NoZWNrcwogSWYgc2V0IHRvIGEgdmFsdWUgZ3JlYXRlciB0aGFuIDAsIG11bHRp
cGF0aGQgd2lsbCB3YXRjaCBwYXRocyB0aGF0IGhhdmUKIHJlY2VudGx5IGJlY29tZSB2YWxpZCBm
b3IgdGhpcyBtYW55IGNoZWNrcy4gSWYgdGhleSBmYWlsIGFnYWluIHdoaWxlIHRoZXkgYXJlCkBA
IC0xMDE1LDYgKzEwNTQsMTIgQEAgYXJlIHRha2VuIGZyb20gdGhlIFxmSWRlZmF1bHRzXGZSIG9y
IFxmSWRldmljZXNcZlIgc2VjdGlvbjoKIC5UUAogLkIgZGVmZXJyZWRfcmVtb3ZlCiAuVFAKKy5C
IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKy5UUAorLkIgc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRl
CisuVFAKKy5CIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCisuVFAKIC5CIGRlbGF5X3dhdGNo
X2NoZWNrcwogLlRQCiAuQiBkZWxheV93YWl0X2NoZWNrcwpAQCAtMTEyOCw2ICsxMTczLDEyIEBA
IHNlY3Rpb246CiAuVFAKIC5CIGRlZmVycmVkX3JlbW92ZQogLlRQCisuQiBzYW5fcGF0aF9lcnJf
dGhyZXNob2xkCisuVFAKKy5CIHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZQorLlRQCisuQiBzYW5f
cGF0aF9lcnJfcmVjb3ZlcnlfdGltZQorLlRQCiAuQiBkZWxheV93YXRjaF9jaGVja3MKIC5UUAog
LkIgZGVsYXlfd2FpdF9jaGVja3MKQEAgLTExOTIsNiArMTI0MywxMiBAQCB0aGUgdmFsdWVzIGFy
ZSB0YWtlbiBmcm9tIHRoZSBcZklkZXZpY2VzXGZSIG9yIFxmSWRlZmF1bHRzXGZSIHNlY3Rpb25z
OgogLlRQCiAuQiBkZWZlcnJlZF9yZW1vdmUKIC5UUAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9s
ZAorLlRQCisuQiBzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUKKy5UUAorLkIgc2FuX3BhdGhfZXJy
X3JlY292ZXJ5X3RpbWUKKy5UUAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5
X3dhaXRfY2hlY2tzCmRpZmYgLS1naXQgYS9tdWx0aXBhdGhkL21haW4uYyBiL211bHRpcGF0aGQv
bWFpbi5jCmluZGV4IGFkYzMyNTguLjQzZDA3YWIgMTAwNjQ0Ci0tLSBhL211bHRpcGF0aGQvbWFp
bi5jCisrKyBiL211bHRpcGF0aGQvbWFpbi5jCkBAIC0xNDg2LDcgKzE0ODYsNTcgQEAgdm9pZCBy
ZXBhaXJfcGF0aChzdHJ1Y3QgcGF0aCAqIHBwKQogCWNoZWNrZXJfcmVwYWlyKCZwcC0+Y2hlY2tl
cik7CiAJTE9HX01TRygxLCBjaGVja2VyX21lc3NhZ2UoJnBwLT5jaGVja2VyKSk7CiB9CitzdGF0
aWMgaW50IGNoZWNrX3BhdGhfdmFsaWRpdHlfZXJyICggc3RydWN0IHBhdGggKiBwcCkgeworCXN0
cnVjdCB0aW1lc3BlYyBzdGFydF90aW1lOworCWludCBkaXNhYmxlX3JlaW5zdGF0ZSA9IDA7CiAK
KwlpZiAoISgocHAtPm1wcC0+c2FuX3BhdGhfZXJyX3RocmVzaG9sZCA+IDApICYmIAorCSAgICAo
cHAtPm1wcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlID4gMCkgJiYKKwkgICAgKHBwLT5tcHAt
PnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lID4wKSkpIHsKKwkJcmV0dXJuIGRpc2FibGVfcmVp
bnN0YXRlOworCX0KKwkKKwlpZiAoY2xvY2tfZ2V0dGltZShDTE9DS19NT05PVE9OSUMsICZzdGFy
dF90aW1lKSAhPSAwKSB7CisJCXJldHVybiBkaXNhYmxlX3JlaW5zdGF0ZTsJCisJfQorCisJaWYg
KCFwcC0+ZGlzYWJsZV9yZWluc3RhdGUpIHsKKwkJaWYgKHBwLT5wYXRoX2ZhaWx1cmVzKSB7CisJ
CQkvKmlmIHRoZSBlcnJvciB0aHJlc2hvbGQgaGFzIGhpdCBoaXQgd2l0aGluIHRoZSBzYW5fcGF0
aF9lcnJfZm9yZ2V0X3JhdGUKKwkJCSAqY3ljbGVzIGRvbm90IHJlaW5zdGFudGUgdGhlIHBhdGgg
dGlsbCB0aGUgc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUKKwkJCSAqcGxhY2UgdGhlIHBhdGgg
aW4gZmFpbGVkIHN0YXRlIHRpbGwgc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUgc28gdGhhdCB0
aGUKKwkJCSAqY3V0b21lciBjYW4gcmVjdGlmeSB0aGUgaXNzdWUgd2l0aGluIHRoaXMgdGltZSAu
T25jZSB0aGUgY29tcGxldGlvbiBvZgorCQkJICpzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSBp
dCBzaG91bGQgYXV0b21hdGljYWxseSByZWluc3RhbnRhdGUgdGhlIHBhdGgKKwkJCSAqLworCQkJ
aWYgKChwcC0+cGF0aF9mYWlsdXJlcyA+IHBwLT5tcHAtPnNhbl9wYXRoX2Vycl90aHJlc2hvbGQp
ICYmCisJCQkJCShwcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlID4gMCkpIHsKKwkJCQlwcmlu
dGYoIlxuJXM6JWQ6ICVzIGhpdCBlcnJvciB0aHJlc2hvbGQgXG4iLF9fZnVuY19fLF9fTElORV9f
LHBwLT5kZXYpOworCQkJCXBwLT5kaXNfcmVpbnN0YXRlX3RpbWUgPSBzdGFydF90aW1lLnR2X3Nl
YyA7CisJCQkJcHAtPmRpc2FibGVfcmVpbnN0YXRlID0gMTsKKwkJCQlkaXNhYmxlX3JlaW5zdGF0
ZSA9IDE7CisJCQl9IGVsc2UgaWYgKChwcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlID4gMCkp
IHsKKwkJCQlwcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlLS07CisJCQl9IGVsc2UgeworCQkJ
CS8qZm9yIGV2ZXJ5IHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSBudW1iZXIKKwkJCQkgKm9mIHN1
Y2Nlc3NmdWwgcGF0aCBjaGVja3MgZGVjcmVtZW50IHBhdGhfZmFpbHVyZXMgYnkgMQorCQkJCSAq
LworCQkJCXBwLT5wYXRoX2ZhaWx1cmVzIC0tOworCQkJCXBwLT5zYW5fcGF0aF9lcnJfZm9yZ2V0
X3JhdGUgPSBwcC0+bXBwLT5zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGU7CisJCQl9CisJCX0KKwl9
IGVsc2UgeworCQlkaXNhYmxlX3JlaW5zdGF0ZSA9IDE7CisJCWlmICgocHAtPm1wcC0+c2FuX3Bh
dGhfZXJyX3JlY292ZXJ5X3RpbWUgPiAwKSAmJgorCQkJCShzdGFydF90aW1lLnR2X3NlYyAtIHBw
LT5kaXNfcmVpbnN0YXRlX3RpbWUgKSA+IHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90
aW1lKSB7CisJCQlkaXNhYmxlX3JlaW5zdGF0ZSA9MDsKKwkJCXBwLT5wYXRoX2ZhaWx1cmVzID0g
MDsKKwkJCXBwLT5kaXNhYmxlX3JlaW5zdGF0ZSA9IDA7CisJCQlwcC0+c2FuX3BhdGhfZXJyX2Zv
cmdldF9yYXRlID0gcHAtPm1wcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlOworCQkJY29uZGxv
ZygzLCJcbnBhdGggJXMgOnJlaW5zdGF0ZSB0aGUgcGF0aCBhZnRlciBlcnIgcmVjb3ZlcnkgdGlt
ZVxuIixwcC0+ZGV2KTsKKwkJfQorCX0KKwlyZXR1cm4gIGRpc2FibGVfcmVpbnN0YXRlOworfQog
LyoKICAqIFJldHVybnMgJzEnIGlmIHRoZSBwYXRoIGhhcyBiZWVuIGNoZWNrZWQsICctMScgaWYg
aXQgd2FzIGJsYWNrbGlzdGVkCiAgKiBhbmQgJzAnIG90aGVyd2lzZQpAQCAtMTUwMiw3ICsxNTUy
LDcgQEAgY2hlY2tfcGF0aCAoc3RydWN0IHZlY3RvcnMgKiB2ZWNzLCBzdHJ1Y3QgcGF0aCAqIHBw
LCBpbnQgdGlja3MpCiAJaW50IG9sZGNoa3JzdGF0ZSA9IHBwLT5jaGtyc3RhdGU7CiAJaW50IHJl
dHJpZ2dlcl90cmllcywgY2hlY2tpbnQ7CiAJc3RydWN0IGNvbmZpZyAqY29uZjsKLQlpbnQgcmV0
OworCWludCByZXQ7CQogCiAJaWYgKChwcC0+aW5pdGlhbGl6ZWQgPT0gSU5JVF9PSyB8fAogCSAg
ICAgcHAtPmluaXRpYWxpemVkID09IElOSVRfUkVRVUVTVEVEX1VERVYpICYmICFwcC0+bXBwKQpA
QCAtMTYxMCwxNyArMTY2MCwzMSBAQCBjaGVja19wYXRoIChzdHJ1Y3QgdmVjdG9ycyAqIHZlY3Ms
IHN0cnVjdCBwYXRoICogcHAsIGludCB0aWNrcykKIAkJCXBwLT53YWl0X2NoZWNrcyA9IDA7CiAJ
fQogCisJaWYgKG5ld3N0YXRlID09IFBBVEhfRE9XTiB8fCBuZXdzdGF0ZSA9PSBQQVRIX0dIT1NU
KSB7CisJCS8qYXNzaWduZWQgIHRoZSBwYXRoX2Vycl9mb3JnZXRfcmF0ZSB3aGVuIHdlIHNlZSB0
aGUgZmlyc3QgZmFpbHVyZSBvbiB0aGUgcGF0aCovCisJCWlmKHBwLT5wYXRoX2ZhaWx1cmVzID09
IDApeworCQkJcHAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSA9IHBwLT5tcHAtPnNhbl9wYXRo
X2Vycl9mb3JnZXRfcmF0ZTsKKwkJfQorCQlwcC0+cGF0aF9mYWlsdXJlcysrOworCX0KKwogCS8q
CiAJICogZG9uJ3QgcmVpbnN0YXRlIGZhaWxlZCBwYXRoLCBpZiBpdHMgaW4gc3RhbmQtYnkKIAkg
KiBhbmQgaWYgdGFyZ2V0IHN1cHBvcnRzIG9ubHkgaW1wbGljaXQgdHBncyBtb2RlLgogCSAqIHRo
aXMgd2lsbCBwcmV2ZW50IHVubmVjZXNzYXJ5IGkvbyBieSBkbSBvbiBzdGFuZC1ieQogCSAqIHBh
dGhzIGlmIHRoZXJlIGFyZSBubyBvdGhlciBhY3RpdmUgcGF0aHMgaW4gbWFwLgorCSAqCisJICog
d2hlbiBwYXRoIGZhaWx1cmVzIGhhcyBleGNlZWRlZCB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9s
ZCAKKwkgKiB3aXRoaW4gc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlIHRoZW4gd2UgZG9uJ3QgcmVp
bnN0YXRlCisJICogZmFpbGVkIHBhdGggZm9yIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCiAJ
ICovCi0JZGlzYWJsZV9yZWluc3RhdGUgPSAobmV3c3RhdGUgPT0gUEFUSF9HSE9TVCAmJgorCWRp
c2FibGVfcmVpbnN0YXRlID0gKChuZXdzdGF0ZSA9PSBQQVRIX0dIT1NUICYmCiAJCQkgICAgcHAt
Pm1wcC0+bnJfYWN0aXZlID09IDAgJiYKLQkJCSAgICBwcC0+dHBncyA9PSBUUEdTX0lNUExJQ0lU
KSA/IDEgOiAwOworCQkJICAgIHBwLT50cGdzID09IFRQR1NfSU1QTElDSVQpID8gMSA6CisJCQkg
ICAgY2hlY2tfcGF0aF92YWxpZGl0eV9lcnIocHApKTsKIAogCXBwLT5jaGtyc3RhdGUgPSBuZXdz
dGF0ZTsKKwogCWlmIChuZXdzdGF0ZSAhPSBwcC0+c3RhdGUpIHsKIAkJaW50IG9sZHN0YXRlID0g
cHAtPnN0YXRlOwogCQlwcC0+c3RhdGUgPSBuZXdzdGF0ZTsK

--_004_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_004_26d8e0b78873443c8e15b863bc33922dBRMWPEXMB12corpbrocadec_--
