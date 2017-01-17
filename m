From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: deterministic io throughput in multipath
Date: Mon, 16 Jan 2017 19:04:47 -0600
Message-ID: <20170117010447.GW2732@octiron.msp.redhat.com>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
	<20161221160940.GG19659@octiron.msp.redhat.com>
	<8cd4cc5f20b540a1b8312ad485711152@BRMWP-EXMB12.corp.brocade.com>
	<20170103171159.GA2732@octiron.msp.redhat.com>
	<4dfed25f04c04771a732580a4a8cc834@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4dfed25f04c04771a732580a4a8cc834@BRMWP-EXMB12.corp.brocade.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 16, 2017 at 11:19:19AM +0000, Muneendra Kumar M wrote:
>    Hi Ben,
>    After the below discussion we=A0 came with the approach which will mee=
t our
>    requirement.
>    I have attached the patch which is working good in our field tests.
>    Could you please review the attached patch and provide us your valuable
>    comments .

I can see a number of issues with this patch.

First, some nit-picks:
- I assume "dis_reinstante_time" should be "dis_reinstate_time"

- The indenting in check_path_validity_err is wrong, which made it
  confusing until I noticed that

if (clock_gettime(CLOCK_MONOTONIC, &start_time) !=3D 0)

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
	NU_NO =3D -1,
	NU_UNDEF =3D 0,
}

  The idea is to try to cut down on the number of functions that are
  simply copy-pasting other functions in dict.c.


Those are all minor cleanup issues, but there are some bigger problems.

Instead of checking if san_path_err_threshold,
san_path_err_threshold_window, and san_path_err_recovery_time are
greater than zero seperately, you should probably check them all at the
start of check_path_validity_err, and return 0 unless they all are set.
Right now, if a user sets san_path_err_threshold and
san_path_err_threshold_window but not san_path_err_recovery_time, their
path will never recover after it hits the error threshold.  I pretty
sure that you don't mean to permanently disable the paths.


time_t is a signed type, which means that if you get the clock time in
update_multpath and then fail to get the clock time in
check_path_validity_err, this check:

start_time.tv_sec - pp->failure_start_time) < pp->mpp->san_path_err_thresho=
ld_window

will always be true.  I realize that clock_gettime is very unlikely to
fail.  But if it does, probably the safest thing to so is to just
immediately return 0 in check_path_validity_err.


The way you set path_failures in update_multipath may not get you what
you want.  It will only count path failures found by the kernel, and not
the path checker.  If the check_path finds the error, pp->state will be
set to PATH_DOWN before pp->dmstate is set to PSTATE_FAILED. That means
you will not increment path_failures. Perhaps this is what you want, but
I would assume that you would want to count every time the path goes
down regardless of whether multipathd or the kernel noticed it.


I'm not super enthusiastic about how the san_path_err_threshold_window
works.  First, it starts counting from when the path goes down, so if
the path takes long enough to get restored, and then fails immediately,
it can just keep failing and it will never hit the
san_path_err_threshold_window, since it spends so much of that time with
the path failed.  Also, the window gets set on the first error, and
never reset until the number of errors is over the threshold.  This
means that if you get one early error and then a bunch of errors much
later, you will go for (2 x san_path_err_threshold) - 1 errors until you
stop reinstating the path, because of the window reset in the middle of
the string of errors.  It seems like a better idea would be to have
check_path_validity_err reset path_failures as soon as it notices that
you are past san_path_err_threshold_window, instead of waiting till the
number of errors hits san_path_err_threshold.


If I was going to design this, I think I would have
san_path_err_threshold and san_path_err_recovery_time like you do, but
instead of having a san_path_err_threshold_window, I would have
something like san_path_err_forget_rate.  The idea is that every
san_path_err_forget_rate number of successful path checks you decrement
path_failures by 1. This means that there is no window after which you
reset.  If the path failures come in faster than the forget rate, you
will eventually hit the error threshold. This also has the benefit of
easily not counting time when the path was down as time where the path
wasn't having problems. But if you don't like my idea, yours will
work fine with some polish.

-Ben


>    Below are the files that has been changed .
>    =A0
>    libmultipath/config.c=A0=A0=A0=A0=A0 |=A0 3 +++
>    libmultipath/config.h=A0=A0=A0=A0=A0 |=A0 9 +++++++++
>    libmultipath/configure.c=A0=A0 |=A0 3 +++
>    libmultipath/defaults.h=A0=A0=A0 |=A0 1 +
>    libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 80
>    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++
>    libmultipath/dict.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
>    libmultipath/propsel.c=A0=A0=A0=A0 | 44
>    ++++++++++++++++++++++++++++++++++++++++++++
>    libmultipath/propsel.h=A0=A0=A0=A0 |=A0 6 ++++++
>    libmultipath/structs.h=A0=A0=A0=A0 | 12 +++++++++++-
>    libmultipath/structs_vec.c | 10 ++++++++++
>    multipath/multipath.conf.5 | 58
>    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>    multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 61
>    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>    =A0
>    We have added three new config parameters whose description is below.
>    1.san_path_err_threshold:
>    =A0=A0=A0=A0=A0=A0=A0 If set to a value greater than 0, multipathd wil=
l watch paths and
>    check how many times a path has been failed due to errors. If the numb=
er
>    of failures on a particular path is greater then the
>    san_path_err_threshold then the path will not=A0 reinstate=A0 till
>    san_path_err_recovery_time. These path failures should occur within a
>    san_path_err_threshold_window time frame, if not we will consider the =
path
>    is good enough to reinstate.
>    =A0
>    2.san_path_err_threshold_window:
>    =A0=A0=A0=A0=A0=A0=A0 If set to a value greater than 0, multipathd wil=
l check whether
>    the path failures has exceeded=A0 the san_path_err_threshold within th=
is
>    time frame i.e san_path_err_threshold_window . If so we will not reins=
tate
>    the path till=A0=A0=A0=A0=A0=A0=A0=A0=A0 san_path_err_recovery_time.
>    =A0
>    3.san_path_err_recovery_time:
>    If set to a value greater than 0, multipathd will make sure that when =
path
>    failures has exceeded the san_path_err_threshold within
>    san_path_err_threshold_window then the path=A0 will be placed in failed
>    state for san_path_err_recovery_time duration. Once
>    san_path_err_recovery_time has timeout=A0 we will reinstate the failed=
 path
>    .
>    =A0
>    Regards,
>    Muneendra.
>    =A0
>    -----Original Message-----
>    From: Muneendra Kumar M
>    Sent: Wednesday, January 04, 2017 6:56 PM
>    To: 'Benjamin Marzinski' <bmarzins@redhat.com>
>    Cc: dm-devel@redhat.com
>    Subject: RE: [dm-devel] deterministic io throughput in multipath
>    =A0
>    Hi Ben,
>    Thanks for the information.
>    =A0
>    Regards,
>    Muneendra.
>    =A0
>    -----Original Message-----
>    From: Benjamin Marzinski [[1]mailto:bmarzins@redhat.com]
>    Sent: Tuesday, January 03, 2017 10:42 PM
>    To: Muneendra Kumar M <[2]mmandala@Brocade.com>
>    Cc: [3]dm-devel@redhat.com
>    Subject: Re: [dm-devel] deterministic io throughput in multipath
>    =A0
>    On Mon, Dec 26, 2016 at 09:42:48AM +0000, Muneendra Kumar M wrote:
>    > Hi Ben,
>    >
>    > If there are two paths on a dm-1 say sda and sdb as below.
>    >
>    > #=A0 multipath -ll
>    >=A0=A0=A0=A0=A0=A0=A0 mpathd (3600110d001ee7f0102050001cc0b6751) dm-1=
 SANBlaze,VLUN
>    MyLun
>    >=A0=A0=A0=A0=A0=A0=A0 size=3D8.0M features=3D'0' hwhandler=3D'0' wp=
=3Drw
>    >=A0=A0=A0=A0=A0=A0=A0 `-+- policy=3D'round-robin 0' prio=3D50 status=
=3Dactive
>    >=A0=A0=A0=A0=A0=A0=A0=A0=A0 |- 8:0:1:0=A0 sda 8:48 active ready=A0 ru=
nning
>    >=A0=A0=A0=A0=A0=A0=A0=A0=A0 `- 9:0:1:0=A0 sdb 8:64 active ready=A0 ru=
nning=A0=A0=A0=A0=A0=A0=A0=A0=A0
>    >
>    > And on sda if iam seeing lot of errors due to which the sda path is
>    fluctuating from failed state to active state and vicevera.
>    >
>    > My requirement is something like this if sda is failed for more then=
 5
>    > times in a hour duration ,then I want to keep the sda in failed state
>    > for few hours (3hrs)
>    >
>    > And the data should travel only thorugh sdb path.
>    > Will this be possible with the below parameters.
>    =A0
>    No. delay_watch_checks sets how may path checks you watch a path that =
has
>    recently come back from the failed state. If the path fails again with=
in
>    this time, multipath device delays it.=A0 This means that the delay is
>    always trigger by two failures within the time limit.=A0 It's possible=
 to
>    adapt this to count numbers of failures, and act after a certain number
>    within a certain timeframe, but it would take a bit more work.
>    =A0
>    delay_wait_checks doesn't guarantee that it will delay for any set len=
gth
>    of time.=A0 Instead, it sets the number of consecutive successful path
>    checks that must occur before the path is usable again. You could set =
this
>    for 3 hours of path checks, but if a check failed during this time, you
>    would restart the 3 hours over again.
>    =A0
>    -Ben
>    =A0
>    > Can you just let me know what values I should add for delay_watch_ch=
ecks
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
>    > To: 'Benjamin Marzinski' <[4]bmarzins@redhat.com>
>    > Cc: [5]dm-devel@redhat.com
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
>    > To: Muneendra Kumar M <[7]mmandala@Brocade.com>
>    > Cc: [8]dm-devel@redhat.com
>    > Subject: Re: [dm-devel] deterministic io throughput in multipath
>    >
>    > Have you looked into the delay_watch_checks and delay_wait_checks
>    configuration parameters?=A0 The idea behind them is to minimize the u=
se of
>    paths that are intermittently failing.
>    >
>    > -Ben
>    >
>    > On Mon, Dec 19, 2016 at 11:50:36AM +0000, Muneendra Kumar M wrote:
>    > >=A0=A0=A0 Customers using Linux host (mostly RHEL host) using a SAN=
 network
>    for
>    > >=A0=A0=A0 block storage, complain the Linux multipath stack is not =
resilient
>    to
>    > >=A0=A0=A0 handle non-deterministic storage network behaviors. This =
has caused
>    many
>    > >=A0=A0=A0 customer move away to non-linux based servers. The intent=
 of the
>    below
>    > >=A0=A0=A0 patch and the prevailing issues are given below. With the=
 below
>    design we
>    > >=A0=A0=A0 are seeing the Linux multipath stack becoming resilient t=
o such
>    network
>    > >=A0=A0=A0 issues. We hope by getting this patch accepted will help =
in more
>    Linux
>    > >=A0=A0=A0 server adoption that use SAN network.
>    > >
>    > >=A0=A0=A0 I have already sent the design details to the community i=
n a
>    different
>    > >=A0=A0=A0 mail chain and the details are available in the below lin=
k.
>    > >
>    > >=A0=A0=A0
>    [1][9]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redha=
t.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_X=
qQWOjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3Dvfwp=
Vp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7=
MRu52hG3MKzM&e=3D
>    .
>    > >
>    > >=A0=A0=A0 Can you please go through the design and send the comment=
s to us.
>    > >
>    > >=A0=A0=A0 =A0
>    > >
>    > >=A0=A0=A0 Regards,
>    > >
>    > >=A0=A0=A0 Muneendra.
>    > >
>    > >=A0=A0=A0 =A0
>    > >
>    > >=A0=A0=A0 =A0
>    > >
>    > > References
>    > >
>    > >=A0=A0=A0 Visible links
>    > >=A0=A0=A0 1.
>    > >
>    [10]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.=
com_
>    > > ar
>    > > chives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_=
XqQWOj
>    > > ub
>    > > gfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3Dvf=
wpVp6e
>    > > 1K
>    > > XtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_=
Uj7M
>    > > Ru
>    > > 52hG3MKzM&e=3D
>    >
>    > > --
>    > > dm-devel mailing list
>    > > [11]dm-devel@redhat.com
>    > >
>    [12]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.=
com_
>    > > ma
>    > > ilman_listinfo_dm-2Ddevel&d=3DDgIDAw&c=3DIL_XqQWOjubgfqINi2jTzg&r=
=3DE3ftc4
>    > > 7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6e1KXtRA0ctwHYJ7cD=
mPsL
>    > > i2C1L9pox7uexsY&s=3DUyE46dXOrNTbPz_TVGtpoHl3J3h_n0uYhI4TI-PgyWg&e=
=3D
>    =A0
> =

> References
> =

>    Visible links
>    1. mailto:bmarzins@redhat.com
>    2. mailto:mmandala@brocade.com
>    3. mailto:dm-devel@redhat.com
>    4. mailto:bmarzins@redhat.com
>    5. mailto:dm-devel@redhat.com
>    6. mailto:bmarzins@redhat.com
>    7. mailto:mmandala@brocade.com
>    8. mailto:dm-devel@redhat.com
>    9. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_XqQW=
OjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6=
e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu=
52hG3MKzM&e
>   10. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_
>   11. mailto:dm-devel@redhat.com
>   12. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_
