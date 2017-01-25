From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: deterministic io throughput in multipath
Date: Wed, 25 Jan 2017 11:48:33 +0000
Message-ID: <a029ce0e966145218e5da34796ef8356@BRMWP-EXMB11.corp.brocade.com>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
	<20161221160940.GG19659@octiron.msp.redhat.com>
	<8cd4cc5f20b540a1b8312ad485711152@BRMWP-EXMB12.corp.brocade.com>
	<20170103171159.GA2732@octiron.msp.redhat.com>
	<4dfed25f04c04771a732580a4a8cc834@BRMWP-EXMB12.corp.brocade.com>
	<20170117010447.GW2732@octiron.msp.redhat.com>
	<26d8e0b78873443c8e15b863bc33922d@BRMWP-EXMB12.corp.brocade.com>
	<20170125092846.GA2732@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170125092846.GA2732@octiron.msp.redhat.com>
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

Hi Ben,
Thanks for the review .
I will consider the below points and will do the necessary changes.

I have two general questions which may not be related to this.
1)Is there any standard tests that we need to do to check the functionality=
 of the multipath daemon.
2)Iam new to git is there any standard steps which we generally  follow to =
push the changes .

Regards,
Muneendra.



-----Original Message-----
From: Benjamin Marzinski [mailto:bmarzins@redhat.com] =

Sent: Wednesday, January 25, 2017 2:59 PM
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] deterministic io throughput in multipath

This looks fine to me.  If this what you want to push, I'm o.k. with it.
But I'd like to make some suggestions that you are free to ignore.

Right now you have to check in two places to see if the path failed (in upd=
ate_multipath and check_path). If you look at the delayed_*_checks code, it=
 flags the path failures when you reinstate the path in check_path, since t=
his will only happen there.

Next, right now you use the disable_reinstate code to deal with the devices=
 when they shouldn't be reinstated. The issue with this is that the path ap=
pears to be up when people look at its state, but still isn't being used. I=
f you do the check early and set the path state to PATH_DELAYED, like delay=
ed_*_checks does, then the path is clearly marked when users look to see wh=
y it isn't being used. Also, if you exit check_path early, then you won't b=
e running the prioritizer on these likely-unstable paths.

Finally, the way you use dis_reinstate_time, a flakey device can get reinst=
ated as soon as it comes back up, as long it was down for long enough, simp=
ly because pp->dis_reinstate_time reached
mpp->san_path_err_recovery_time while the device was failed.
delayed_*_checks depends on a number of successful path checks, so you know=
 that the device has at least been nominally functional for san_path_err_re=
covery_time.

Like I said, you don't have to change any of this to make me happy with you=
r patch. But if you did change all of these, then the current delay_*_check=
s code would just end up being a special case of your code.
I'd really like to pull out the delayed_*_checks code and just keep your ve=
rsion, since it seems more useful. It would be nice to keep the same functi=
onality. But even if you don't make these changes, I still think we should =
pull out the delayed_*_checks code, since they both do the same general thi=
ng, and your code does it better.

-Ben

On Mon, Jan 23, 2017 at 11:02:42AM +0000, Muneendra Kumar M wrote:
>    Hi Ben,
>    I have made the changes as per the below review comments .
>    =A0
>    Could you please review the attached patch and provide us your valuable
>    comments .
>    Below are the files that has been changed .
>    =A0
>    libmultipath/config.c=A0=A0=A0=A0=A0 |=A0 3 +++
>    libmultipath/config.h=A0=A0=A0=A0=A0 |=A0 9 +++++++++
>    libmultipath/configure.c=A0=A0 |=A0 3 +++
>    libmultipath/defaults.h=A0=A0=A0 |=A0 3 ++-
>    libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0 | 84
>    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------=
--------------
>    libmultipath/dict.h=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +--
>    libmultipath/propsel.c=A0=A0=A0=A0 | 48
>    ++++++++++++++++++++++++++++++++++++++++++++++--
>    libmultipath/propsel.h=A0=A0=A0=A0 |=A0 3 +++
>    libmultipath/structs.h=A0=A0=A0=A0 | 14 ++++++++++----
>    libmultipath/structs_vec.c |=A0 6 ++++++
>    multipath/multipath.conf.5 | 57
>    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>    multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 70
>    =

> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>    =A0
>    =A0
>    Regards,
>    Muneendra.
>    =A0
>    _____________________________________________
>    From: Muneendra Kumar M
>    Sent: Tuesday, January 17, 2017 4:13 PM
>    To: 'Benjamin Marzinski' <bmarzins@redhat.com>
>    Cc: dm-devel@redhat.com
>    Subject: RE: [dm-devel] deterministic io throughput in multipath
>    =A0
>    =A0
>    Hi Ben,
>    Thanks for the review.
>    In dict.c=A0 I will make sure I will make generic functions which will=
 be
>    used by both delay_checks and err_checks.
>    =A0
>    We want to increment the path failures every time the path goes down
>    regardless of whether multipathd or the kernel noticed the failure of
>    paths.
>    Thanks for pointing this.
>    =A0
>    I will completely agree with the idea which you mentioned below by
>    reconsidering the san_path_err_threshold_window with
>    san_path_err_forget_rate. This will avoid counting time when the path =
was
>    down as time where the path wasn't having problems.
>    =A0
>    I will incorporate all the changes mentioned below and will resend the
>    patch once the testing is done.
>    =A0
>    Regards,
>    Muneendra.
>    =A0
>    =A0
>    =A0
>    -----Original Message-----
>    From: Benjamin Marzinski [[1]mailto:bmarzins@redhat.com]
>    Sent: Tuesday, January 17, 2017 6:35 AM
>    To: Muneendra Kumar M <[2]mmandala@Brocade.com>
>    Cc: [3]dm-devel@redhat.com
>    Subject: Re: [dm-devel] deterministic io throughput in multipath
>    =A0
>    On Mon, Jan 16, 2017 at 11:19:19AM +0000, Muneendra Kumar M wrote:
>    >=A0=A0=A0 Hi Ben,
>    >=A0=A0=A0 After the below discussion we=A0 came with the approach whi=
ch will meet
>    our
>    >=A0=A0=A0 requirement.
>    >=A0=A0=A0 I have attached the patch which is working good in our fiel=
d tests.
>    >=A0=A0=A0 Could you please review the attached patch and provide us y=
our
>    valuable
>    >=A0=A0=A0 comments .
>    =A0
>    I can see a number of issues with this patch.
>    =A0
>    First, some nit-picks:
>    - I assume "dis_reinstante_time" should be "dis_reinstate_time"
>    =A0
>    - The indenting in check_path_validity_err is wrong, which made it
>    =A0 confusing until I noticed that
>    =A0
>    if (clock_gettime(CLOCK_MONOTONIC, &start_time) !=3D 0)
>    =A0
>    =A0 doesn't have an open brace, and shouldn't indent the rest of the
>    =A0 function.
>    =A0
>    - You call clock_gettime in check_path, but never use the result.
>    =A0
>    - In dict.c, instead of writing your own functions that are the same as
>    =A0 the *_delay_checks functions, you could make those functions gener=
ic
>    =A0 and use them for both.=A0 To go match the other generic function n=
ames
>    =A0 they would probably be something like
>    =A0
>    set_off_int_undef
>    =A0
>    print_off_int_undef
>    =A0
>    =A0 You would also need to change DELAY_CHECKS_* and ERR_CHECKS_* to
>    =A0 point to some common enum that you created, the way
>    =A0 user_friendly_names_states (to name one of many) does. The generic
>    =A0 enum used by *_off_int_undef would be something like.
>    =A0
>    enum no_undef {
>    =A0=A0=A0=A0=A0=A0=A0 NU_NO =3D -1,
>    =A0=A0=A0=A0=A0=A0=A0 NU_UNDEF =3D 0,
>    }
>    =A0
>    =A0 The idea is to try to cut down on the number of functions that are
>    =A0 simply copy-pasting other functions in dict.c.
>    =A0
>    =A0
>    Those are all minor cleanup issues, but there are some bigger problems.
>    =A0
>    Instead of checking if san_path_err_threshold,
>    san_path_err_threshold_window, and san_path_err_recovery_time are grea=
ter
>    than zero seperately, you should probably check them all at the start =
of
>    check_path_validity_err, and return 0 unless they all are set.
>    Right now, if a user sets san_path_err_threshold and
>    san_path_err_threshold_window but not san_path_err_recovery_time, their
>    path will never recover after it hits the error threshold.=A0 I pretty=
 sure
>    that you don't mean to permanently disable the paths.
>    =A0
>    =A0
>    time_t is a signed type, which means that if you get the clock time in
>    update_multpath and then fail to get the clock time in
>    check_path_validity_err, this check:
>    =A0
>    start_time.tv_sec - pp->failure_start_time) <
>    pp->mpp->san_path_err_threshold_window
>    =A0
>    will always be true.=A0 I realize that clock_gettime is very unlikely =
to
>    fail.=A0 But if it does, probably the safest thing to so is to just
>    immediately return 0 in check_path_validity_err.
>    =A0
>    =A0
>    The way you set path_failures in update_multipath may not get you what=
 you
>    want.=A0 It will only count path failures found by the kernel, and not=
 the
>    path checker.=A0 If the check_path finds the error, pp->state will be =
set to
>    PATH_DOWN before pp->dmstate is set to PSTATE_FAILED. That means you w=
ill
>    not increment path_failures. Perhaps this is what you want, but I would
>    assume that you would want to count every time the path goes down
>    regardless of whether multipathd or the kernel noticed it.
>    =A0
>    =A0
>    I'm not super enthusiastic about how the san_path_err_threshold_window
>    works.=A0 First, it starts counting from when the path goes down, so i=
f the
>    path takes long enough to get restored, and then fails immediately, it=
 can
>    just keep failing and it will never hit the san_path_err_threshold_win=
dow,
>    since it spends so much of that time with the path failed.=A0 Also, the
>    window gets set on the first error, and never reset until the number of
>    errors is over the threshold.=A0 This means that if you get one early =
error
>    and then a bunch of errors much later, you will go for (2 x
>    san_path_err_threshold) - 1 errors until you stop reinstating the path,
>    because of the window reset in the middle of the string of errors.=A0 =
It
>    seems like a better idea would be to have check_path_validity_err reset
>    path_failures as soon as it notices that you are past
>    san_path_err_threshold_window, instead of waiting till the number of
>    errors hits san_path_err_threshold.
>    =A0
>    =A0
>    If I was going to design this, I think I would have san_path_err_thres=
hold
>    and san_path_err_recovery_time like you do, but instead of having a
>    san_path_err_threshold_window, I would have something like
>    san_path_err_forget_rate.=A0 The idea is that every san_path_err_forge=
t_rate
>    number of successful path checks you decrement path_failures by 1. This
>    means that there is no window after which you reset.=A0 If the path fa=
ilures
>    come in faster than the forget rate, you will eventually hit the error
>    threshold. This also has the benefit of easily not counting time when =
the
>    path was down as time where the path wasn't having problems. But if you
>    don't like my idea, yours will work fine with some polish.
>    =A0
>    -Ben
>    =A0
>    =A0
>    >=A0=A0=A0 Below are the files that has been changed .
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 libmultipath/config.c=A0=A0=A0=A0=A0 |=A0 3 +++
>    >=A0=A0=A0 libmultipath/config.h=A0=A0=A0=A0=A0 |=A0 9 +++++++++
>    >=A0=A0=A0 libmultipath/configure.c=A0=A0 |=A0 3 +++
>    >=A0=A0=A0 libmultipath/defaults.h=A0=A0=A0 |=A0 1 +
>    >=A0=A0=A0 libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 80
>    >=A0=A0=A0
>    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++
>    >=A0=A0=A0 libmultipath/dict.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
>    >=A0=A0=A0 libmultipath/propsel.c=A0=A0=A0=A0 | 44
>    >=A0=A0=A0 ++++++++++++++++++++++++++++++++++++++++++++
>    >=A0=A0=A0 libmultipath/propsel.h=A0=A0=A0=A0 |=A0 6 ++++++
>    >=A0=A0=A0 libmultipath/structs.h=A0=A0=A0=A0 | 12 +++++++++++-
>    >=A0=A0=A0 libmultipath/structs_vec.c | 10 ++++++++++
>    >=A0=A0=A0 multipath/multipath.conf.5 | 58
>    >=A0=A0=A0 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>    >=A0=A0=A0 multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 61
>    >=A0=A0=A0 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
--
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 We have added three new config parameters whose description=
 is below.
>    >=A0=A0=A0 1.san_path_err_threshold:
>    >=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 If set to a value greater than 0, mul=
tipathd will watch paths
>    and
>    >=A0=A0=A0 check how many times a path has been failed due to errors. =
If the
>    number
>    >=A0=A0=A0 of failures on a particular path is greater then the
>    >=A0=A0=A0 san_path_err_threshold then the path will not=A0 reinstate=
=A0 till
>    >=A0=A0=A0 san_path_err_recovery_time. These path failures should occu=
r within a
>    >=A0=A0=A0 san_path_err_threshold_window time frame, if not we will co=
nsider the
>    path
>    >=A0=A0=A0 is good enough to reinstate.
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 2.san_path_err_threshold_window:
>    >=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 If set to a value greater than 0, mul=
tipathd will check
>    whether
>    >=A0=A0=A0 the path failures has exceeded=A0 the san_path_err_threshol=
d within
>    this
>    >=A0=A0=A0 time frame i.e san_path_err_threshold_window . If so we wil=
l not
>    reinstate
>    >=A0=A0=A0 the path till=A0=A0=A0=A0=A0=A0=A0=A0=A0 san_path_err_recov=
ery_time.
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 3.san_path_err_recovery_time:
>    >=A0=A0=A0 If set to a value greater than 0, multipathd will make sure=
 that when
>    path
>    >=A0=A0=A0 failures has exceeded the san_path_err_threshold within
>    >=A0=A0=A0 san_path_err_threshold_window then the path=A0 will be plac=
ed in failed
>    >=A0=A0=A0 state for san_path_err_recovery_time duration. Once
>    >=A0=A0=A0 san_path_err_recovery_time has timeout=A0 we will reinstate=
 the failed
>    path
>    >=A0=A0=A0 .
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 Regards,
>    >=A0=A0=A0 Muneendra.
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 -----Original Message-----
>    >=A0=A0=A0 From: Muneendra Kumar M
>    >=A0=A0=A0 Sent: Wednesday, January 04, 2017 6:56 PM
>    >=A0=A0=A0 To: 'Benjamin Marzinski' <[4]bmarzins@redhat.com>
>    >=A0=A0=A0 Cc: [5]dm-devel@redhat.com
>    >=A0=A0=A0 Subject: RE: [dm-devel] deterministic io throughput in mult=
ipath
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 Hi Ben,
>    >=A0=A0=A0 Thanks for the information.
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 Regards,
>    >=A0=A0=A0 Muneendra.
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 -----Original Message-----
>    >=A0=A0=A0 From: Benjamin Marzinski [[1][6]mailto:bmarzins@redhat.com]
>    >=A0=A0=A0 Sent: Tuesday, January 03, 2017 10:42 PM
>    >=A0=A0=A0 To: Muneendra Kumar M <[2][7]mmandala@Brocade.com>
>    >=A0=A0=A0 Cc: [3][8]dm-devel@redhat.com
>    >=A0=A0=A0 Subject: Re: [dm-devel] deterministic io throughput in mult=
ipath
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 On Mon, Dec 26, 2016 at 09:42:48AM +0000, Muneendra Kumar M=
 wrote:
>    >=A0=A0=A0 > Hi Ben,
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > If there are two paths on a dm-1 say sda and sdb as below.
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > #=A0 multipath -ll
>    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0 mpathd (3600110d001ee7f0102050001cc0=
b6751) dm-1
>    SANBlaze,VLUN
>    >=A0=A0=A0 MyLun
>    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0 size=3D8.0M features=3D'0' hwhandler=
=3D'0' wp=3Drw
>    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0 `-+- policy=3D'round-robin 0' prio=
=3D50 status=3Dactive
>    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0=A0=A0 |- 8:0:1:0=A0 sda 8:48 active =
ready=A0 running
>    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0=A0=A0 `- 9:0:1:0=A0 sdb 8:64 active =
ready=A0 running=A0=A0=A0=A0=A0=A0=A0=A0=A0
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > And on sda if iam seeing lot of errors due to which the s=
da path is
>    >=A0=A0=A0 fluctuating from failed state to active state and vicevera.
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > My requirement is something like this if sda is failed fo=
r more
>    then 5
>    >=A0=A0=A0 > times in a hour duration ,then I want to keep the sda in =
failed
>    state
>    >=A0=A0=A0 > for few hours (3hrs)
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > And the data should travel only thorugh sdb path.
>    >=A0=A0=A0 > Will this be possible with the below parameters.
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 No. delay_watch_checks sets how may path checks you watch a=
 path that
>    has
>    >=A0=A0=A0 recently come back from the failed state. If the path fails=
 again
>    within
>    >=A0=A0=A0 this time, multipath device delays it.=A0 This means that t=
he delay is
>    >=A0=A0=A0 always trigger by two failures within the time limit.=A0 It=
's possible
>    to
>    >=A0=A0=A0 adapt this to count numbers of failures, and act after a ce=
rtain
>    number
>    >=A0=A0=A0 within a certain timeframe, but it would take a bit more wo=
rk.
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 delay_wait_checks doesn't guarantee that it will delay for =
any set
>    length
>    >=A0=A0=A0 of time.=A0 Instead, it sets the number of consecutive succ=
essful path
>    >=A0=A0=A0 checks that must occur before the path is usable again. You=
 could set
>    this
>    >=A0=A0=A0 for 3 hours of path checks, but if a check failed during th=
is time,
>    you
>    >=A0=A0=A0 would restart the 3 hours over again.
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 -Ben
>    >=A0=A0=A0 =A0
>    >=A0=A0=A0 > Can you just let me know what values I should add for
>    delay_watch_checks
>    >=A0=A0=A0 and delay_wait_checks.
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > Regards,
>    >=A0=A0=A0 > Muneendra.
>    >=A0=A0=A0 >
>    >=A0=A0=A0 >
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > -----Original Message-----
>    >=A0=A0=A0 > From: Muneendra Kumar M
>    >=A0=A0=A0 > Sent: Thursday, December 22, 2016 11:10 AM
>    >=A0=A0=A0 > To: 'Benjamin Marzinski' <[4][9]bmarzins@redhat.com>
>    >=A0=A0=A0 > Cc: [5][10]dm-devel@redhat.com
>    >=A0=A0=A0 > Subject: RE: [dm-devel] deterministic io throughput in mu=
ltipath
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > Hi Ben,
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > Thanks for the reply.
>    >=A0=A0=A0 > I will look into this parameters will do the internal tes=
ting and
>    let
>    >=A0=A0=A0 you know the results.
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > Regards,
>    >=A0=A0=A0 > Muneendra.
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > -----Original Message-----
>    >=A0=A0=A0 > From: Benjamin Marzinski [[6][11]mailto:bmarzins@redhat.c=
om]
>    >=A0=A0=A0 > Sent: Wednesday, December 21, 2016 9:40 PM
>    >=A0=A0=A0 > To: Muneendra Kumar M <[7][12]mmandala@Brocade.com>
>    >=A0=A0=A0 > Cc: [8][13]dm-devel@redhat.com
>    >=A0=A0=A0 > Subject: Re: [dm-devel] deterministic io throughput in mu=
ltipath
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > Have you looked into the delay_watch_checks and delay_wai=
t_checks
>    >=A0=A0=A0 configuration parameters?=A0 The idea behind them is to min=
imize the
>    use of
>    >=A0=A0=A0 paths that are intermittently failing.
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > -Ben
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > On Mon, Dec 19, 2016 at 11:50:36AM +0000, Muneendra Kumar=
 M wrote:
>    >=A0=A0=A0 > >=A0=A0=A0 Customers using Linux host (mostly RHEL host) =
using a SAN
>    network
>    >=A0=A0=A0 for
>    >=A0=A0=A0 > >=A0=A0=A0 block storage, complain the Linux multipath st=
ack is not
>    resilient
>    >=A0=A0=A0 to
>    >=A0=A0=A0 > >=A0=A0=A0 handle non-deterministic storage network behav=
iors. This has
>    caused
>    >=A0=A0=A0 many
>    >=A0=A0=A0 > >=A0=A0=A0 customer move away to non-linux based servers.=
 The intent of
>    the
>    >=A0=A0=A0 below
>    >=A0=A0=A0 > >=A0=A0=A0 patch and the prevailing issues are given belo=
w. With the
>    below
>    >=A0=A0=A0 design we
>    >=A0=A0=A0 > >=A0=A0=A0 are seeing the Linux multipath stack becoming =
resilient to
>    such
>    >=A0=A0=A0 network
>    >=A0=A0=A0 > >=A0=A0=A0 issues. We hope by getting this patch accepted=
 will help in
>    more
>    >=A0=A0=A0 Linux
>    >=A0=A0=A0 > >=A0=A0=A0 server adoption that use SAN network.
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0 I have already sent the design details to the =
community in a
>    >=A0=A0=A0 different
>    >=A0=A0=A0 > >=A0=A0=A0 mail chain and the details are available in th=
e below link.
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0
>    >=A0=A0=A0
>    [1][9][14]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.r=
edhat.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3D=
IL_XqQWOjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3D=
vfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo=
_Uj7MRu52hG3MKzM&e=3D
>    >=A0=A0=A0 .
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0 Can you please go through the design and send =
the comments to
>    us.
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0 =A0
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0 Regards,
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0 Muneendra.
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0 =A0
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0 =A0
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > > References
>    >=A0=A0=A0 > >
>    >=A0=A0=A0 > >=A0=A0=A0 Visible links
>    >=A0=A0=A0 > >=A0=A0=A0 1.
>    >=A0=A0=A0 > >
>    >=A0=A0=A0
>    [10][15]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.red=
hat.com_
>    >=A0=A0=A0 > > ar
>    >=A0=A0=A0 > >
>    chives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_XqQW=
Oj
>    >=A0=A0=A0 > > ub
>    >=A0=A0=A0 > >
>    gfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp=
6e
>    >=A0=A0=A0 > > 1K
>    >=A0=A0=A0 > >
>    XtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7M
>    >=A0=A0=A0 > > Ru
>    >=A0=A0=A0 > > 52hG3MKzM&e=3D
>    >=A0=A0=A0 >
>    >=A0=A0=A0 > > --
>    >=A0=A0=A0 > > dm-devel mailing list
>    >=A0=A0=A0 > > [11][16]dm-devel@redhat.com
>    >=A0=A0=A0 > >
>    >=A0=A0=A0
>    [12][17]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.red=
hat.com_
>    >=A0=A0=A0 > > ma
>    >=A0=A0=A0 > >
>    ilman_listinfo_dm-2Ddevel&d=3DDgIDAw&c=3DIL_XqQWOjubgfqINi2jTzg&r=3DE3=
ftc4
>    >=A0=A0=A0 > >
>    7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6e1KXtRA0ctwHYJ7cDmPsL
>    >=A0=A0=A0 > >
>    > i2C1L9pox7uexsY&s=3DUyE46dXOrNTbPz_TVGtpoHl3J3h_n0uYhI4TI-PgyWg&e=3D
>    >=A0=A0=A0 =A0
>    >
>    > References
>    >
>    >=A0=A0=A0 Visible links
>    >=A0=A0=A0 1. [18]mailto:bmarzins@redhat.com
>    >=A0=A0=A0 2. [19]mailto:mmandala@brocade.com
>    >=A0=A0=A0 3. [20]mailto:dm-devel@redhat.com
>    >=A0=A0=A0 4. [21]mailto:bmarzins@redhat.com
>    >=A0=A0=A0 5. [22]mailto:dm-devel@redhat.com
>    >=A0=A0=A0 6. [23]mailto:bmarzins@redhat.com
>    >=A0=A0=A0 7. [24]mailto:mmandala@brocade.com
>    >=A0=A0=A0 8. [25]mailto:dm-devel@redhat.com
>    >=A0=A0=A0 9.
>    [26]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.=
com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_XqQ=
WOjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp=
6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MR=
u52hG3MKzM&e
>    >=A0=A0 10.
>    [27]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.=
com_
>    >=A0=A0 11. [28]mailto:dm-devel@redhat.com
>    >=A0=A0 12.
>    > =

> [29]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.co
> m_
>    =A0
>    =A0
>    =A0
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
>    9. mailto:bmarzins@redhat.com
>   10. mailto:dm-devel@redhat.com
>   11. mailto:bmarzins@redhat.com
>   12. mailto:mmandala@brocade.com
>   13. mailto:dm-devel@redhat.com
>   14. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_XqQW=
OjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6=
e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu=
52hG3MKzM&e
>   15. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_
>   16. mailto:dm-devel@redhat.com
>   17. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_
>   18. mailto:bmarzins@redhat.com
>   19. mailto:mmandala@brocade.com
>   20. mailto:dm-devel@redhat.com
>   21. mailto:bmarzins@redhat.com
>   22. mailto:dm-devel@redhat.com
>   23. mailto:bmarzins@redhat.com
>   24. mailto:mmandala@brocade.com
>   25. mailto:dm-devel@redhat.com
>   26. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_XqQW=
OjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6=
e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7MRu=
52hG3MKzM&e
>   27. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.c=
om_
>   28. mailto:dm-devel@redhat.com
>   29. =

> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_
