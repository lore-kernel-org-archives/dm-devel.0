From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: deterministic io throughput in multipath
Date: Wed, 1 Feb 2017 11:58:52 +0000
Message-ID: <af56a18e992f4a8cb474de87a208e02a@BRMWP-EXMB12.corp.brocade.com>
References: <1649d4b8538d4b4cb1efacdfe8cf31eb@BRMWP-EXMB12.corp.brocade.com>
	<20161221160940.GG19659@octiron.msp.redhat.com>
	<8cd4cc5f20b540a1b8312ad485711152@BRMWP-EXMB12.corp.brocade.com>
	<20170103171159.GA2732@octiron.msp.redhat.com>
	<4dfed25f04c04771a732580a4a8cc834@BRMWP-EXMB12.corp.brocade.com>
	<20170117010447.GW2732@octiron.msp.redhat.com>
	<26d8e0b78873443c8e15b863bc33922d@BRMWP-EXMB12.corp.brocade.com>
	<20170125092846.GA2732@octiron.msp.redhat.com>
	<a029ce0e966145218e5da34796ef8356@BRMWP-EXMB11.corp.brocade.com>
	<20170125130703.GA22981@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_af56a18e992f4a8cb474de87a208e02aBRMWPEXMB12corpbrocadec_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170125130703.GA22981@octiron.msp.redhat.com>
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

--_002_af56a18e992f4a8cb474de87a208e02aBRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Ben,
I have made the changes as per the below review comments .
Could you please review the attached patch and provide us your valuable com=
ments .

Below are the files that has been changed .=20

libmultipath/config.c      |  3 +++
 libmultipath/config.h      |  9 +++++++++
 libmultipath/configure.c   |  3 +++
 libmultipath/defaults.h    |  3 ++-
 libmultipath/dict.c        | 84 ++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++++++------------------------
 libmultipath/dict.h        |  3 +--
 libmultipath/propsel.c     | 48 ++++++++++++++++++++++++++++++++++++++++++=
++++--
 libmultipath/propsel.h     |  3 +++
 libmultipath/structs.h     | 14 ++++++++++----
 multipath/multipath.conf.5 | 57 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++
 multipathd/main.c          | 97 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++----
 11 files changed, 287 insertions(+), 37 deletions(-)

Thanks for the general info provided below.
I will commit the changes as below once the review is done.

Regards,
Muneendra.


-----Original Message-----
From: Benjamin Marzinski [mailto:bmarzins@redhat.com]=20
Sent: Wednesday, January 25, 2017 6:37 PM
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] deterministic io throughput in multipath

On Wed, Jan 25, 2017 at 11:48:33AM +0000, Muneendra Kumar M wrote:
> Hi Ben,
> Thanks for the review .
> I will consider the below points and will do the necessary changes.
>=20
> I have two general questions which may not be related to this.
> 1)Is there any standard tests that we need to do to check the functionali=
ty of the multipath daemon.

No. multipath doesn't have a standard set of regression tests.  You need to=
 do your own testing.

> 2)Iam new to git is there any standard steps which we generally  follow t=
o push the changes .

You don't need to use git to push a patch, but it is easier to process if y=
our patch is inline in the email instead of as an attachment (assuming your=
 mail client doesn't mangle the patch).

If you want to use git, you just need to commit your patches to a branch of=
f the head of master. Then you can build patches with

# git format-patch --cover-letter -s -n -o <dir> origin

and send them with

# git send-email --to "device-mapper development <dm-devel@redhat.com>" --c=
c "Christophe Varoqui <christophe.varoqui@opensvc.com>" --no-chain-reply-to=
 --suppress-from <dir>

You may need to first need to set up your git name and email

-Ben

> Regards,
> Muneendra.
>=20
>=20
>=20
> -----Original Message-----
> From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
> Sent: Wednesday, January 25, 2017 2:59 PM
> To: Muneendra Kumar M <mmandala@Brocade.com>
> Cc: dm-devel@redhat.com
> Subject: Re: [dm-devel] deterministic io throughput in multipath
>=20
> This looks fine to me.  If this what you want to push, I'm o.k. with it.
> But I'd like to make some suggestions that you are free to ignore.
>=20
> Right now you have to check in two places to see if the path failed (in u=
pdate_multipath and check_path). If you look at the delayed_*_checks code, =
it flags the path failures when you reinstate the path in check_path, since=
 this will only happen there.
>=20
> Next, right now you use the disable_reinstate code to deal with the devic=
es when they shouldn't be reinstated. The issue with this is that the path =
appears to be up when people look at its state, but still isn't being used.=
 If you do the check early and set the path state to PATH_DELAYED, like del=
ayed_*_checks does, then the path is clearly marked when users look to see =
why it isn't being used. Also, if you exit check_path early, then you won't=
 be running the prioritizer on these likely-unstable paths.
>=20
> Finally, the way you use dis_reinstate_time, a flakey device can get=20
> reinstated as soon as it comes back up, as long it was down for long=20
> enough, simply because pp->dis_reinstate_time reached
> mpp->san_path_err_recovery_time while the device was failed.
> delayed_*_checks depends on a number of successful path checks, so you kn=
ow that the device has at least been nominally functional for san_path_err_=
recovery_time.
>=20
> Like I said, you don't have to change any of this to make me happy with y=
our patch. But if you did change all of these, then the current delay_*_che=
cks code would just end up being a special case of your code.
> I'd really like to pull out the delayed_*_checks code and just keep your =
version, since it seems more useful. It would be nice to keep the same func=
tionality. But even if you don't make these changes, I still think we shoul=
d pull out the delayed_*_checks code, since they both do the same general t=
hing, and your code does it better.
>=20
> -Ben
>=20
> On Mon, Jan 23, 2017 at 11:02:42AM +0000, Muneendra Kumar M wrote:
> >    Hi Ben,
> >    I have made the changes as per the below review comments .
> >    =A0
> >    Could you please review the attached patch and provide us your valua=
ble
> >    comments .
> >    Below are the files that has been changed .
> >    =A0
> >    libmultipath/config.c=A0=A0=A0=A0=A0 |=A0 3 +++
> >    libmultipath/config.h=A0=A0=A0=A0=A0 |=A0 9 +++++++++
> >    libmultipath/configure.c=A0=A0 |=A0 3 +++
> >    libmultipath/defaults.h=A0=A0=A0 |=A0 3 ++-
> >    libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0 | 84
> >    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------=
----------------
> >    libmultipath/dict.h=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +--
> >    libmultipath/propsel.c=A0=A0=A0=A0 | 48
> >    ++++++++++++++++++++++++++++++++++++++++++++++--
> >    libmultipath/propsel.h=A0=A0=A0=A0 |=A0 3 +++
> >    libmultipath/structs.h=A0=A0=A0=A0 | 14 ++++++++++----
> >    libmultipath/structs_vec.c |=A0 6 ++++++
> >    multipath/multipath.conf.5 | 57
> >    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >    multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 70
> >   =20
> > +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >    =A0
> >    =A0
> >    Regards,
> >    Muneendra.
> >    =A0
> >    _____________________________________________
> >    From: Muneendra Kumar M
> >    Sent: Tuesday, January 17, 2017 4:13 PM
> >    To: 'Benjamin Marzinski' <bmarzins@redhat.com>
> >    Cc: dm-devel@redhat.com
> >    Subject: RE: [dm-devel] deterministic io throughput in multipath
> >    =A0
> >    =A0
> >    Hi Ben,
> >    Thanks for the review.
> >    In dict.c=A0 I will make sure I will make generic functions which wi=
ll be
> >    used by both delay_checks and err_checks.
> >    =A0
> >    We want to increment the path failures every time the path goes down
> >    regardless of whether multipathd or the kernel noticed the failure o=
f
> >    paths.
> >    Thanks for pointing this.
> >    =A0
> >    I will completely agree with the idea which you mentioned below by
> >    reconsidering the san_path_err_threshold_window with
> >    san_path_err_forget_rate. This will avoid counting time when the pat=
h was
> >    down as time where the path wasn't having problems.
> >    =A0
> >    I will incorporate all the changes mentioned below and will resend t=
he
> >    patch once the testing is done.
> >    =A0
> >    Regards,
> >    Muneendra.
> >    =A0
> >    =A0
> >    =A0
> >    -----Original Message-----
> >    From: Benjamin Marzinski [[1]mailto:bmarzins@redhat.com]
> >    Sent: Tuesday, January 17, 2017 6:35 AM
> >    To: Muneendra Kumar M <[2]mmandala@Brocade.com>
> >    Cc: [3]dm-devel@redhat.com
> >    Subject: Re: [dm-devel] deterministic io throughput in multipath
> >    =A0
> >    On Mon, Jan 16, 2017 at 11:19:19AM +0000, Muneendra Kumar M wrote:
> >    >=A0=A0=A0 Hi Ben,
> >    >=A0=A0=A0 After the below discussion we=A0 came with the approach w=
hich will meet
> >    our
> >    >=A0=A0=A0 requirement.
> >    >=A0=A0=A0 I have attached the patch which is working good in our fi=
eld tests.
> >    >=A0=A0=A0 Could you please review the attached patch and provide us=
 your
> >    valuable
> >    >=A0=A0=A0 comments .
> >    =A0
> >    I can see a number of issues with this patch.
> >    =A0
> >    First, some nit-picks:
> >    - I assume "dis_reinstante_time" should be "dis_reinstate_time"
> >    =A0
> >    - The indenting in check_path_validity_err is wrong, which made it
> >    =A0 confusing until I noticed that
> >    =A0
> >    if (clock_gettime(CLOCK_MONOTONIC, &start_time) !=3D 0)
> >    =A0
> >    =A0 doesn't have an open brace, and shouldn't indent the rest of the
> >    =A0 function.
> >    =A0
> >    - You call clock_gettime in check_path, but never use the result.
> >    =A0
> >    - In dict.c, instead of writing your own functions that are the same=
 as
> >    =A0 the *_delay_checks functions, you could make those functions gen=
eric
> >    =A0 and use them for both.=A0 To go match the other generic function=
 names
> >    =A0 they would probably be something like
> >    =A0
> >    set_off_int_undef
> >    =A0
> >    print_off_int_undef
> >    =A0
> >    =A0 You would also need to change DELAY_CHECKS_* and ERR_CHECKS_* to
> >    =A0 point to some common enum that you created, the way
> >    =A0 user_friendly_names_states (to name one of many) does. The gener=
ic
> >    =A0 enum used by *_off_int_undef would be something like.
> >    =A0
> >    enum no_undef {
> >    =A0=A0=A0=A0=A0=A0=A0 NU_NO =3D -1,
> >    =A0=A0=A0=A0=A0=A0=A0 NU_UNDEF =3D 0,
> >    }
> >    =A0
> >    =A0 The idea is to try to cut down on the number of functions that a=
re
> >    =A0 simply copy-pasting other functions in dict.c.
> >    =A0
> >    =A0
> >    Those are all minor cleanup issues, but there are some bigger proble=
ms.
> >    =A0
> >    Instead of checking if san_path_err_threshold,
> >    san_path_err_threshold_window, and san_path_err_recovery_time are gr=
eater
> >    than zero seperately, you should probably check them all at the star=
t of
> >    check_path_validity_err, and return 0 unless they all are set.
> >    Right now, if a user sets san_path_err_threshold and
> >    san_path_err_threshold_window but not san_path_err_recovery_time, th=
eir
> >    path will never recover after it hits the error threshold.=A0 I pret=
ty sure
> >    that you don't mean to permanently disable the paths.
> >    =A0
> >    =A0
> >    time_t is a signed type, which means that if you get the clock time =
in
> >    update_multpath and then fail to get the clock time in
> >    check_path_validity_err, this check:
> >    =A0
> >    start_time.tv_sec - pp->failure_start_time) <
> >    pp->mpp->san_path_err_threshold_window
> >    =A0
> >    will always be true.=A0 I realize that clock_gettime is very unlikel=
y to
> >    fail.=A0 But if it does, probably the safest thing to so is to just
> >    immediately return 0 in check_path_validity_err.
> >    =A0
> >    =A0
> >    The way you set path_failures in update_multipath may not get you wh=
at you
> >    want.=A0 It will only count path failures found by the kernel, and n=
ot the
> >    path checker.=A0 If the check_path finds the error, pp->state will b=
e set to
> >    PATH_DOWN before pp->dmstate is set to PSTATE_FAILED. That means you=
 will
> >    not increment path_failures. Perhaps this is what you want, but I wo=
uld
> >    assume that you would want to count every time the path goes down
> >    regardless of whether multipathd or the kernel noticed it.
> >    =A0
> >    =A0
> >    I'm not super enthusiastic about how the san_path_err_threshold_wind=
ow
> >    works.=A0 First, it starts counting from when the path goes down, so=
 if the
> >    path takes long enough to get restored, and then fails immediately, =
it can
> >    just keep failing and it will never hit the san_path_err_threshold_w=
indow,
> >    since it spends so much of that time with the path failed.=A0 Also, =
the
> >    window gets set on the first error, and never reset until the number=
 of
> >    errors is over the threshold.=A0 This means that if you get one earl=
y error
> >    and then a bunch of errors much later, you will go for (2 x
> >    san_path_err_threshold) - 1 errors until you stop reinstating the pa=
th,
> >    because of the window reset in the middle of the string of errors.=
=A0 It
> >    seems like a better idea would be to have check_path_validity_err re=
set
> >    path_failures as soon as it notices that you are past
> >    san_path_err_threshold_window, instead of waiting till the number of
> >    errors hits san_path_err_threshold.
> >    =A0
> >    =A0
> >    If I was going to design this, I think I would have san_path_err_thr=
eshold
> >    and san_path_err_recovery_time like you do, but instead of having a
> >    san_path_err_threshold_window, I would have something like
> >    san_path_err_forget_rate.=A0 The idea is that every san_path_err_for=
get_rate
> >    number of successful path checks you decrement path_failures by 1. T=
his
> >    means that there is no window after which you reset.=A0 If the path =
failures
> >    come in faster than the forget rate, you will eventually hit the err=
or
> >    threshold. This also has the benefit of easily not counting time whe=
n the
> >    path was down as time where the path wasn't having problems. But if =
you
> >    don't like my idea, yours will work fine with some polish.
> >    =A0
> >    -Ben
> >    =A0
> >    =A0
> >    >=A0=A0=A0 Below are the files that has been changed .
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 libmultipath/config.c=A0=A0=A0=A0=A0 |=A0 3 +++
> >    >=A0=A0=A0 libmultipath/config.h=A0=A0=A0=A0=A0 |=A0 9 +++++++++
> >    >=A0=A0=A0 libmultipath/configure.c=A0=A0 |=A0 3 +++
> >    >=A0=A0=A0 libmultipath/defaults.h=A0=A0=A0 |=A0 1 +
> >    >=A0=A0=A0 libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
 80
> >    >=A0=A0=A0
> >    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++
> >    >=A0=A0=A0 libmultipath/dict.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> >    >=A0=A0=A0 libmultipath/propsel.c=A0=A0=A0=A0 | 44
> >    >=A0=A0=A0 ++++++++++++++++++++++++++++++++++++++++++++
> >    >=A0=A0=A0 libmultipath/propsel.h=A0=A0=A0=A0 |=A0 6 ++++++
> >    >=A0=A0=A0 libmultipath/structs.h=A0=A0=A0=A0 | 12 +++++++++++-
> >    >=A0=A0=A0 libmultipath/structs_vec.c | 10 ++++++++++
> >    >=A0=A0=A0 multipath/multipath.conf.5 | 58
> >    >=A0=A0=A0 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+
> >    >=A0=A0=A0 multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 61
> >    >=A0=A0=A0 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++--
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 We have added three new config parameters whose descripti=
on is below.
> >    >=A0=A0=A0 1.san_path_err_threshold:
> >    >=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 If set to a value greater than 0, m=
ultipathd will watch paths
> >    and
> >    >=A0=A0=A0 check how many times a path has been failed due to errors=
. If the
> >    number
> >    >=A0=A0=A0 of failures on a particular path is greater then the
> >    >=A0=A0=A0 san_path_err_threshold then the path will not=A0 reinstat=
e=A0 till
> >    >=A0=A0=A0 san_path_err_recovery_time. These path failures should oc=
cur within a
> >    >=A0=A0=A0 san_path_err_threshold_window time frame, if not we will =
consider the
> >    path
> >    >=A0=A0=A0 is good enough to reinstate.
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 2.san_path_err_threshold_window:
> >    >=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 If set to a value greater than 0, m=
ultipathd will check
> >    whether
> >    >=A0=A0=A0 the path failures has exceeded=A0 the san_path_err_thresh=
old within
> >    this
> >    >=A0=A0=A0 time frame i.e san_path_err_threshold_window . If so we w=
ill not
> >    reinstate
> >    >=A0=A0=A0 the path till=A0=A0=A0=A0=A0=A0=A0=A0=A0 san_path_err_rec=
overy_time.
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 3.san_path_err_recovery_time:
> >    >=A0=A0=A0 If set to a value greater than 0, multipathd will make su=
re that when
> >    path
> >    >=A0=A0=A0 failures has exceeded the san_path_err_threshold within
> >    >=A0=A0=A0 san_path_err_threshold_window then the path=A0 will be pl=
aced in failed
> >    >=A0=A0=A0 state for san_path_err_recovery_time duration. Once
> >    >=A0=A0=A0 san_path_err_recovery_time has timeout=A0 we will reinsta=
te the failed
> >    path
> >    >=A0=A0=A0 .
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 Regards,
> >    >=A0=A0=A0 Muneendra.
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 -----Original Message-----
> >    >=A0=A0=A0 From: Muneendra Kumar M
> >    >=A0=A0=A0 Sent: Wednesday, January 04, 2017 6:56 PM
> >    >=A0=A0=A0 To: 'Benjamin Marzinski' <[4]bmarzins@redhat.com>
> >    >=A0=A0=A0 Cc: [5]dm-devel@redhat.com
> >    >=A0=A0=A0 Subject: RE: [dm-devel] deterministic io throughput in mu=
ltipath
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 Hi Ben,
> >    >=A0=A0=A0 Thanks for the information.
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 Regards,
> >    >=A0=A0=A0 Muneendra.
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 -----Original Message-----
> >    >=A0=A0=A0 From: Benjamin Marzinski [[1][6]mailto:bmarzins@redhat.co=
m]
> >    >=A0=A0=A0 Sent: Tuesday, January 03, 2017 10:42 PM
> >    >=A0=A0=A0 To: Muneendra Kumar M <[2][7]mmandala@Brocade.com>
> >    >=A0=A0=A0 Cc: [3][8]dm-devel@redhat.com
> >    >=A0=A0=A0 Subject: Re: [dm-devel] deterministic io throughput in mu=
ltipath
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 On Mon, Dec 26, 2016 at 09:42:48AM +0000, Muneendra Kumar=
 M wrote:
> >    >=A0=A0=A0 > Hi Ben,
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > If there are two paths on a dm-1 say sda and sdb as bel=
ow.
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > #=A0 multipath -ll
> >    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0 mpathd (3600110d001ee7f0102050001c=
c0b6751) dm-1
> >    SANBlaze,VLUN
> >    >=A0=A0=A0 MyLun
> >    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0 size=3D8.0M features=3D'0' hwhandl=
er=3D'0' wp=3Drw
> >    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0 `-+- policy=3D'round-robin 0' prio=
=3D50 status=3Dactive
> >    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0=A0=A0 |- 8:0:1:0=A0 sda 8:48 activ=
e ready=A0 running
> >    >=A0=A0=A0 >=A0=A0=A0=A0=A0=A0=A0=A0=A0 `- 9:0:1:0=A0 sdb 8:64 activ=
e ready=A0 running=A0=A0=A0=A0=A0=A0=A0=A0=A0
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > And on sda if iam seeing lot of errors due to which the=
 sda path is
> >    >=A0=A0=A0 fluctuating from failed state to active state and vicever=
a.
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > My requirement is something like this if sda is failed =
for more
> >    then 5
> >    >=A0=A0=A0 > times in a hour duration ,then I want to keep the sda i=
n failed
> >    state
> >    >=A0=A0=A0 > for few hours (3hrs)
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > And the data should travel only thorugh sdb path.
> >    >=A0=A0=A0 > Will this be possible with the below parameters.
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 No. delay_watch_checks sets how may path checks you watch=
 a path that
> >    has
> >    >=A0=A0=A0 recently come back from the failed state. If the path fai=
ls again
> >    within
> >    >=A0=A0=A0 this time, multipath device delays it.=A0 This means that=
 the delay is
> >    >=A0=A0=A0 always trigger by two failures within the time limit.=A0 =
It's possible
> >    to
> >    >=A0=A0=A0 adapt this to count numbers of failures, and act after a =
certain
> >    number
> >    >=A0=A0=A0 within a certain timeframe, but it would take a bit more =
work.
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 delay_wait_checks doesn't guarantee that it will delay fo=
r any set
> >    length
> >    >=A0=A0=A0 of time.=A0 Instead, it sets the number of consecutive su=
ccessful path
> >    >=A0=A0=A0 checks that must occur before the path is usable again. Y=
ou could set
> >    this
> >    >=A0=A0=A0 for 3 hours of path checks, but if a check failed during =
this time,
> >    you
> >    >=A0=A0=A0 would restart the 3 hours over again.
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 -Ben
> >    >=A0=A0=A0 =A0
> >    >=A0=A0=A0 > Can you just let me know what values I should add for
> >    delay_watch_checks
> >    >=A0=A0=A0 and delay_wait_checks.
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > Regards,
> >    >=A0=A0=A0 > Muneendra.
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > -----Original Message-----
> >    >=A0=A0=A0 > From: Muneendra Kumar M
> >    >=A0=A0=A0 > Sent: Thursday, December 22, 2016 11:10 AM
> >    >=A0=A0=A0 > To: 'Benjamin Marzinski' <[4][9]bmarzins@redhat.com>
> >    >=A0=A0=A0 > Cc: [5][10]dm-devel@redhat.com
> >    >=A0=A0=A0 > Subject: RE: [dm-devel] deterministic io throughput in =
multipath
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > Hi Ben,
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > Thanks for the reply.
> >    >=A0=A0=A0 > I will look into this parameters will do the internal t=
esting and
> >    let
> >    >=A0=A0=A0 you know the results.
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > Regards,
> >    >=A0=A0=A0 > Muneendra.
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > -----Original Message-----
> >    >=A0=A0=A0 > From: Benjamin Marzinski [[6][11]mailto:bmarzins@redhat=
.com]
> >    >=A0=A0=A0 > Sent: Wednesday, December 21, 2016 9:40 PM
> >    >=A0=A0=A0 > To: Muneendra Kumar M <[7][12]mmandala@Brocade.com>
> >    >=A0=A0=A0 > Cc: [8][13]dm-devel@redhat.com
> >    >=A0=A0=A0 > Subject: Re: [dm-devel] deterministic io throughput in =
multipath
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > Have you looked into the delay_watch_checks and delay_w=
ait_checks
> >    >=A0=A0=A0 configuration parameters?=A0 The idea behind them is to m=
inimize the
> >    use of
> >    >=A0=A0=A0 paths that are intermittently failing.
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > -Ben
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > On Mon, Dec 19, 2016 at 11:50:36AM +0000, Muneendra Kum=
ar M wrote:
> >    >=A0=A0=A0 > >=A0=A0=A0 Customers using Linux host (mostly RHEL host=
) using a SAN
> >    network
> >    >=A0=A0=A0 for
> >    >=A0=A0=A0 > >=A0=A0=A0 block storage, complain the Linux multipath =
stack is not
> >    resilient
> >    >=A0=A0=A0 to
> >    >=A0=A0=A0 > >=A0=A0=A0 handle non-deterministic storage network beh=
aviors. This has
> >    caused
> >    >=A0=A0=A0 many
> >    >=A0=A0=A0 > >=A0=A0=A0 customer move away to non-linux based server=
s. The intent of
> >    the
> >    >=A0=A0=A0 below
> >    >=A0=A0=A0 > >=A0=A0=A0 patch and the prevailing issues are given be=
low. With the
> >    below
> >    >=A0=A0=A0 design we
> >    >=A0=A0=A0 > >=A0=A0=A0 are seeing the Linux multipath stack becomin=
g resilient to
> >    such
> >    >=A0=A0=A0 network
> >    >=A0=A0=A0 > >=A0=A0=A0 issues. We hope by getting this patch accept=
ed will help in
> >    more
> >    >=A0=A0=A0 Linux
> >    >=A0=A0=A0 > >=A0=A0=A0 server adoption that use SAN network.
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0 I have already sent the design details to th=
e community in a
> >    >=A0=A0=A0 different
> >    >=A0=A0=A0 > >=A0=A0=A0 mail chain and the details are available in =
the below link.
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0
> >    >=A0=A0=A0
> >    [1][9][14]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www=
.redhat.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=
=3DIL_XqQWOjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=
=3DvfwpVp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiy=
iPo_Uj7MRu52hG3MKzM&e=3D
> >    >=A0=A0=A0 .
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0 Can you please go through the design and sen=
d the comments to
> >    us.
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0 =A0
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0 Regards,
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0 Muneendra.
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0 =A0
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0 =A0
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > > References
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0 > >=A0=A0=A0 Visible links
> >    >=A0=A0=A0 > >=A0=A0=A0 1.
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0
> >    [10][15]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.r=
edhat.com_
> >    >=A0=A0=A0 > > ar
> >    >=A0=A0=A0 > >
> >    chives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_Xq=
QWOj
> >    >=A0=A0=A0 > > ub
> >    >=A0=A0=A0 > >
> >    gfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3Dvfwp=
Vp6e
> >    >=A0=A0=A0 > > 1K
> >    >=A0=A0=A0 > >
> >    XtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj=
7M
> >    >=A0=A0=A0 > > Ru
> >    >=A0=A0=A0 > > 52hG3MKzM&e=3D
> >    >=A0=A0=A0 >
> >    >=A0=A0=A0 > > --
> >    >=A0=A0=A0 > > dm-devel mailing list
> >    >=A0=A0=A0 > > [11][16]dm-devel@redhat.com
> >    >=A0=A0=A0 > >
> >    >=A0=A0=A0
> >    [12][17]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.r=
edhat.com_
> >    >=A0=A0=A0 > > ma
> >    >=A0=A0=A0 > >
> >    ilman_listinfo_dm-2Ddevel&d=3DDgIDAw&c=3DIL_XqQWOjubgfqINi2jTzg&r=3D=
E3ftc4
> >    >=A0=A0=A0 > >
> >    7B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpVp6e1KXtRA0ctwHYJ7cDmP=
sL
> >    >=A0=A0=A0 > >
> >    > i2C1L9pox7uexsY&s=3DUyE46dXOrNTbPz_TVGtpoHl3J3h_n0uYhI4TI-PgyWg&e=
=3D
> >    >=A0=A0=A0 =A0
> >    >
> >    > References
> >    >
> >    >=A0=A0=A0 Visible links
> >    >=A0=A0=A0 1. [18]mailto:bmarzins@redhat.com
> >    >=A0=A0=A0 2. [19]mailto:mmandala@brocade.com
> >    >=A0=A0=A0 3. [20]mailto:dm-devel@redhat.com
> >    >=A0=A0=A0 4. [21]mailto:bmarzins@redhat.com
> >    >=A0=A0=A0 5. [22]mailto:dm-devel@redhat.com
> >    >=A0=A0=A0 6. [23]mailto:bmarzins@redhat.com
> >    >=A0=A0=A0 7. [24]mailto:mmandala@brocade.com
> >    >=A0=A0=A0 8. [25]mailto:dm-devel@redhat.com
> >    >=A0=A0=A0 9.
> >    [26]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redha=
t.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_X=
qQWOjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3Dvfwp=
Vp6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7=
MRu52hG3MKzM&e
> >    >=A0=A0 10.
> >    [27]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redha=
t.com_
> >    >=A0=A0 11. [28]mailto:dm-devel@redhat.com
> >    >=A0=A0 12.
> >    >
> > [29]https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.
> > co
> > m_
> >    =A0
> >    =A0
> >    =A0
> >    =A0
> >=20
> > References
> >=20
> >    Visible links
> >    1. mailto:bmarzins@redhat.com
> >    2. mailto:mmandala@brocade.com
> >    3. mailto:dm-devel@redhat.com
> >    4. mailto:bmarzins@redhat.com
> >    5. mailto:dm-devel@redhat.com
> >    6. mailto:bmarzins@redhat.com
> >    7. mailto:mmandala@brocade.com
> >    8. mailto:dm-devel@redhat.com
> >    9. mailto:bmarzins@redhat.com
> >   10. mailto:dm-devel@redhat.com
> >   11. mailto:bmarzins@redhat.com
> >   12. mailto:mmandala@brocade.com
> >   13. mailto:dm-devel@redhat.com
> >   14. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat=
.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_Xq=
QWOjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpV=
p6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7M=
Ru52hG3MKzM&e
> >   15. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat=
.com_
> >   16. mailto:dm-devel@redhat.com
> >   17. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat=
.com_
> >   18. mailto:bmarzins@redhat.com
> >   19. mailto:mmandala@brocade.com
> >   20. mailto:dm-devel@redhat.com
> >   21. mailto:bmarzins@redhat.com
> >   22. mailto:dm-devel@redhat.com
> >   23. mailto:bmarzins@redhat.com
> >   24. mailto:mmandala@brocade.com
> >   25. mailto:dm-devel@redhat.com
> >   26. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat=
.com_archives_dm-2Ddevel_2016-2DDecember_msg00122.html&d=3DDgIDAw&c=3DIL_Xq=
QWOjubgfqINi2jTzg&r=3DE3ftc47B6BGtZ4fVaYvkuv19wKvC_Mc6nhXaA1sBIP0&m=3DvfwpV=
p6e1KXtRA0ctwHYJ7cDmPsLi2C1L9pox7uexsY&s=3Dq5OI-lfefNC2CHKmyUkokgiyiPo_Uj7M=
Ru52hG3MKzM&e
> >   27. https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat=
.com_
> >   28. mailto:dm-devel@redhat.com
> >   29.=20
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.redhat.com_
>=20

--_002_af56a18e992f4a8cb474de87a208e02aBRMWPEXMB12corpbrocadec_
Content-Type: application/octet-stream; name="san_path_error.patch"
Content-Description: san_path_error.patch
Content-Disposition: attachment; filename="san_path_error.patch"; size=23194;
	creation-date="Wed, 01 Feb 2017 05:58:31 GMT";
	modification-date="Wed, 01 Feb 2017 06:03:04 GMT"
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
LWdpdCBhL211bHRpcGF0aC9tdWx0aXBhdGguY29uZi41IGIvbXVsdGlwYXRoL211bHRpcGF0aC5j
b25mLjUKaW5kZXggMzY1ODlmNS4uM2M1NjRhZCAxMDA2NDQKLS0tIGEvbXVsdGlwYXRoL211bHRp
cGF0aC5jb25mLjUKKysrIGIvbXVsdGlwYXRoL211bHRpcGF0aC5jb25mLjUKQEAgLTc1MSw2ICs3
NTEsNDUgQEAgVGhlIGRlZmF1bHQgaXM6IFxmQi9ldGMvbXVsdGlwYXRoL2NvbmYuZC9cZlIKIC4K
IC4KIC5UUAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZAorSWYgc2V0IHRvIGEgdmFsdWUgZ3Jl
YXRlciB0aGFuIDAsIG11bHRpcGF0aGQgd2lsbCB3YXRjaCBwYXRocyBhbmQgY2hlY2sgaG93IG1h
bnkKK3RpbWVzIGEgcGF0aCBoYXMgYmVlbiBmYWlsZWQgZHVlIHRvIGVycm9ycy5JZiB0aGUgbnVt
YmVyIG9mIGZhaWx1cmVzIG9uIGEgcGFydGljdWxhcgorcGF0aCBpcyBncmVhdGVyIHRoZW4gdGhl
IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQgdGhlbiB0aGUgcGF0aCB3aWxsIG5vdCAgcmVpbnN0YW50
ZQordGlsbCBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZS5UaGVzZSBwYXRoIGZhaWx1cmVzIHNo
b3VsZCBvY2N1ciB3aXRoaW4gYSAKK3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSBjaGVja3MsIGlm
IG5vdCB3ZSB3aWxsIGNvbnNpZGVyIHRoZSBwYXRoIGlzIGdvb2QgZW5vdWdoCit0byByZWluc3Rh
bnRhdGUuCisuUlMKKy5UUAorVGhlIGRlZmF1bHQgaXM6IFxmQm5vXGZSCisuUkUKKy4KKy4KKy5U
UAorLkIgc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlCitJZiBzZXQgdG8gYSB2YWx1ZSBncmVhdGVy
IHRoYW4gMCwgbXVsdGlwYXRoZCB3aWxsIGNoZWNrIHdoZXRoZXIgdGhlIHBhdGggZmFpbHVyZXMK
K2hhcyBleGNlZWRlZCAgdGhlIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQgd2l0aGluIHRoaXMgbWFu
eSBjaGVja3MgaS5lIAorc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlIC4gSWYgc28gd2Ugd2lsbCBu
b3QgcmVpbnN0YW50ZSB0aGUgcGF0aCB0aWxsCitzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZS4K
Ky5SUworLlRQCitUaGUgZGVmYXVsdCBpczogXGZCbm9cZlIKKy5SRQorLgorLgorLlRQCisuQiBz
YW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZQorSWYgc2V0IHRvIGEgdmFsdWUgZ3JlYXRlciB0aGFu
IDAsIG11bHRpcGF0aGQgd2lsbCBtYWtlIHN1cmUgdGhhdCB3aGVuIHBhdGggZmFpbHVyZXMKK2hh
cyBleGNlZWRlZCB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9sZCB3aXRoaW4gc2FuX3BhdGhfZXJy
X2ZvcmdldF9yYXRlIHRoZW4gdGhlIHBhdGgKK3dpbGwgYmUgcGxhY2VkIGluIGZhaWxlZCBzdGF0
ZSBmb3Igc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUgZHVyYXRpb24uT25jZSBzYW5fcGF0aF9l
cnJfcmVjb3ZlcnlfdGltZQoraGFzIHRpbWVvdXQgIHdlIHdpbGwgcmVpbnN0YW50ZSB0aGUgZmFp
bGVkIHBhdGggLgorc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUgdmFsdWUgc2hvdWxkIGJlIGlu
IHNlY3MuCisuUlMKKy5UUAorVGhlIGRlZmF1bHQgaXM6IFxmQm5vXGZSCisuUkUKKy4KKy4KKy5U
UAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiBJZiBzZXQgdG8gYSB2YWx1ZSBncmVhdGVyIHRoYW4g
MCwgbXVsdGlwYXRoZCB3aWxsIHdhdGNoIHBhdGhzIHRoYXQgaGF2ZQogcmVjZW50bHkgYmVjb21l
IHZhbGlkIGZvciB0aGlzIG1hbnkgY2hlY2tzLiBJZiB0aGV5IGZhaWwgYWdhaW4gd2hpbGUgdGhl
eSBhcmUKQEAgLTEwMTUsNiArMTA1NCwxMiBAQCBhcmUgdGFrZW4gZnJvbSB0aGUgXGZJZGVmYXVs
dHNcZlIgb3IgXGZJZGV2aWNlc1xmUiBzZWN0aW9uOgogLlRQCiAuQiBkZWZlcnJlZF9yZW1vdmUK
IC5UUAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZAorLlRQCisuQiBzYW5fcGF0aF9lcnJfZm9y
Z2V0X3JhdGUKKy5UUAorLkIgc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUKKy5UUAogLkIgZGVs
YXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5X3dhaXRfY2hlY2tzCkBAIC0xMTI4LDYgKzEx
NzMsMTIgQEAgc2VjdGlvbjoKIC5UUAogLkIgZGVmZXJyZWRfcmVtb3ZlCiAuVFAKKy5CIHNhbl9w
YXRoX2Vycl90aHJlc2hvbGQKKy5UUAorLkIgc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlCisuVFAK
Ky5CIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCisuVFAKIC5CIGRlbGF5X3dhdGNoX2NoZWNr
cwogLlRQCiAuQiBkZWxheV93YWl0X2NoZWNrcwpAQCAtMTE5Miw2ICsxMjQzLDEyIEBAIHRoZSB2
YWx1ZXMgYXJlIHRha2VuIGZyb20gdGhlIFxmSWRldmljZXNcZlIgb3IgXGZJZGVmYXVsdHNcZlIg
c2VjdGlvbnM6CiAuVFAKIC5CIGRlZmVycmVkX3JlbW92ZQogLlRQCisuQiBzYW5fcGF0aF9lcnJf
dGhyZXNob2xkCisuVFAKKy5CIHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZQorLlRQCisuQiBzYW5f
cGF0aF9lcnJfcmVjb3ZlcnlfdGltZQorLlRQCiAuQiBkZWxheV93YXRjaF9jaGVja3MKIC5UUAog
LkIgZGVsYXlfd2FpdF9jaGVja3MKZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvbWFpbi5jIGIvbXVs
dGlwYXRoZC9tYWluLmMKaW5kZXggYWRjMzI1OC4uZDZkNjhhNCAxMDA2NDQKLS0tIGEvbXVsdGlw
YXRoZC9tYWluLmMKKysrIGIvbXVsdGlwYXRoZC9tYWluLmMKQEAgLTE0ODcsNiArMTQ4Nyw3MCBA
QCB2b2lkIHJlcGFpcl9wYXRoKHN0cnVjdCBwYXRoICogcHApCiAJTE9HX01TRygxLCBjaGVja2Vy
X21lc3NhZ2UoJnBwLT5jaGVja2VyKSk7CiB9CiAKK3N0YXRpYyBpbnQgY2hlY2tfcGF0aF9yZWlu
c3RhdGVfc3RhdGUoc3RydWN0IHBhdGggKiBwcCkgeworCXN0cnVjdCB0aW1lc3BlYyBzdGFydF90
aW1lOworCWludCBkaXNhYmxlX3JlaW5zdGF0ZSA9IDE7CisKKwlpZiAoISgocHAtPm1wcC0+c2Fu
X3BhdGhfZXJyX3RocmVzaG9sZCA+IDApICYmIAorCQkJCShwcC0+bXBwLT5zYW5fcGF0aF9lcnJf
Zm9yZ2V0X3JhdGUgPiAwKSAmJgorCQkJCShwcC0+bXBwLT5zYW5fcGF0aF9lcnJfcmVjb3Zlcnlf
dGltZSA+MCkpKSB7CisJCXJldHVybiBkaXNhYmxlX3JlaW5zdGF0ZTsKKwl9CisKKwlpZiAoY2xv
Y2tfZ2V0dGltZShDTE9DS19NT05PVE9OSUMsICZzdGFydF90aW1lKSAhPSAwKSB7CisJCXJldHVy
biBkaXNhYmxlX3JlaW5zdGF0ZTsJCisJfQorCisJaWYgKChzdGFydF90aW1lLnR2X3NlYyAtIHBw
LT5kaXNfcmVpbnN0YXRlX3RpbWUgKSA+IHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90
aW1lKSB7CisJCWRpc2FibGVfcmVpbnN0YXRlID0wOworCQlwcC0+cGF0aF9mYWlsdXJlcyA9IDA7
CisJCXBwLT5kaXNhYmxlX3JlaW5zdGF0ZSA9IDA7CisJCXBwLT5zYW5fcGF0aF9lcnJfZm9yZ2V0
X3JhdGUgPSBwcC0+bXBwLT5zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGU7CisJCWNvbmRsb2coMywi
XG5wYXRoICVzIDpyZWluc3RhdGUgdGhlIHBhdGggYWZ0ZXIgZXJyIHJlY292ZXJ5IHRpbWVcbiIs
cHAtPmRldik7CisJfQorCXJldHVybiAgZGlzYWJsZV9yZWluc3RhdGU7Cit9CisKK3N0YXRpYyBp
bnQgY2hlY2tfcGF0aF92YWxpZGl0eV9lcnIgKHN0cnVjdCBwYXRoICogcHApIHsKKwlzdHJ1Y3Qg
dGltZXNwZWMgc3RhcnRfdGltZTsKKwlpbnQgZGlzYWJsZV9yZWluc3RhdGUgPSAwOworCisJaWYg
KCEoKHBwLT5tcHAtPnNhbl9wYXRoX2Vycl90aHJlc2hvbGQgPiAwKSAmJiAKKwkJCQkocHAtPm1w
cC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlID4gMCkgJiYKKwkJCQkocHAtPm1wcC0+c2FuX3Bh
dGhfZXJyX3JlY292ZXJ5X3RpbWUgPjApKSkgeworCQlyZXR1cm4gZGlzYWJsZV9yZWluc3RhdGU7
CisJfQorCisJaWYgKGNsb2NrX2dldHRpbWUoQ0xPQ0tfTU9OT1RPTklDLCAmc3RhcnRfdGltZSkg
IT0gMCkgeworCQlyZXR1cm4gZGlzYWJsZV9yZWluc3RhdGU7CQorCX0KKwlpZiAoIXBwLT5kaXNh
YmxlX3JlaW5zdGF0ZSkgeworCQlpZiAocHAtPnBhdGhfZmFpbHVyZXMpIHsKKwkJCS8qaWYgdGhl
IGVycm9yIHRocmVzaG9sZCBoYXMgaGl0IGhpdCB3aXRoaW4gdGhlIHNhbl9wYXRoX2Vycl9mb3Jn
ZXRfcmF0ZQorCQkJICpjeWNsZXMgZG9ub3QgcmVpbnN0YW50ZSB0aGUgcGF0aCB0aWxsIHRoZSBz
YW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZQorCQkJICpwbGFjZSB0aGUgcGF0aCBpbiBmYWlsZWQg
c3RhdGUgdGlsbCBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSBzbyB0aGF0IHRoZQorCQkJICpj
dXRvbWVyIGNhbiByZWN0aWZ5IHRoZSBpc3N1ZSB3aXRoaW4gdGhpcyB0aW1lIC5PbmNlIHRoZSBj
b21wbGV0aW9uIG9mCisJCQkgKnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lIGl0IHNob3VsZCBh
dXRvbWF0aWNhbGx5IHJlaW5zdGFudGF0ZSB0aGUgcGF0aAorCQkJICovCisJCQlpZiAoKHBwLT5w
YXRoX2ZhaWx1cmVzID4gcHAtPm1wcC0+c2FuX3BhdGhfZXJyX3RocmVzaG9sZCkgJiYKKwkJCQkJ
KHBwLT5zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUgPiAwKSkgeworCQkJCXByaW50ZigiXG4lczol
ZDogJXMgaGl0IGVycm9yIHRocmVzaG9sZCBcbiIsX19mdW5jX18sX19MSU5FX18scHAtPmRldik7
CisJCQkJcHAtPmRpc19yZWluc3RhdGVfdGltZSA9IHN0YXJ0X3RpbWUudHZfc2VjIDsKKwkJCQlw
cC0+ZGlzYWJsZV9yZWluc3RhdGUgPSAxOworCQkJCWRpc2FibGVfcmVpbnN0YXRlID0gMTsKKwkJ
CX0gZWxzZSBpZiAoKHBwLT5zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUgPiAwKSkgeworCQkJCXBw
LT5zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUtLTsKKwkJCX0gZWxzZSB7CisJCQkJLypmb3IgZXZl
cnkgc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlIG51bWJlcgorCQkJCSAqb2Ygc3VjY2Vzc2Z1bCBw
YXRoIGNoZWNrcyBkZWNyZW1lbnQgcGF0aF9mYWlsdXJlcyBieSAxCisJCQkJICovCisJCQkJcHAt
PnBhdGhfZmFpbHVyZXMgLS07CisJCQkJcHAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSA9IHBw
LT5tcHAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZTsKKwkJCX0KKwkJfQorCX0KKwlyZXR1cm4g
IGRpc2FibGVfcmVpbnN0YXRlOworfQogLyoKICAqIFJldHVybnMgJzEnIGlmIHRoZSBwYXRoIGhh
cyBiZWVuIGNoZWNrZWQsICctMScgaWYgaXQgd2FzIGJsYWNrbGlzdGVkCiAgKiBhbmQgJzAnIG90
aGVyd2lzZQpAQCAtMTUwMiw3ICsxNTY2LDcgQEAgY2hlY2tfcGF0aCAoc3RydWN0IHZlY3RvcnMg
KiB2ZWNzLCBzdHJ1Y3QgcGF0aCAqIHBwLCBpbnQgdGlja3MpCiAJaW50IG9sZGNoa3JzdGF0ZSA9
IHBwLT5jaGtyc3RhdGU7CiAJaW50IHJldHJpZ2dlcl90cmllcywgY2hlY2tpbnQ7CiAJc3RydWN0
IGNvbmZpZyAqY29uZjsKLQlpbnQgcmV0OworCWludCByZXQ7CQogCiAJaWYgKChwcC0+aW5pdGlh
bGl6ZWQgPT0gSU5JVF9PSyB8fAogCSAgICAgcHAtPmluaXRpYWxpemVkID09IElOSVRfUkVRVUVT
VEVEX1VERVYpICYmICFwcC0+bXBwKQpAQCAtMTYwMSw2ICsxNjY1LDE4IEBAIGNoZWNrX3BhdGgg
KHN0cnVjdCB2ZWN0b3JzICogdmVjcywgc3RydWN0IHBhdGggKiBwcCwgaW50IHRpY2tzKQogCQly
ZXR1cm4gMDsKIAogCWlmICgobmV3c3RhdGUgPT0gUEFUSF9VUCB8fCBuZXdzdGF0ZSA9PSBQQVRI
X0dIT1NUKSAmJgorCSAgICAgcHAtPmRpc2FibGVfcmVpbnN0YXRlKSB7CisJCS8qCisJCSAqIGNo
ZWNrIGlmIHRoZSBwYXRoIGlzIGluIGZhaWxlZCBzdGF0ZSBmb3IgbW9yZSB0aGFuIHNhbl9wYXRo
X2Vycl9yZWNvdmVyeV90aW1lCisJCSAqIGlmIG5vdCBwbGFjZSB0aGUgcGF0aCBpbiBkZWxheWVk
IHN0YXRlCisJCSAqLworCQlpZiAoY2hlY2tfcGF0aF9yZWluc3RhdGVfc3RhdGUocHApKSB7CisJ
CQlwcC0+c3RhdGUgPSBQQVRIX0RFTEFZRUQ7CisJCQlyZXR1cm4gMTsKKwkJfQorCX0KKwkKKwlp
ZiAoKG5ld3N0YXRlID09IFBBVEhfVVAgfHwgbmV3c3RhdGUgPT0gUEFUSF9HSE9TVCkgJiYKIAkg
ICAgIHBwLT53YWl0X2NoZWNrcyA+IDApIHsKIAkJaWYgKHBwLT5tcHAtPm5yX2FjdGl2ZSA+IDAp
IHsKIAkJCXBwLT5zdGF0ZSA9IFBBVEhfREVMQVlFRDsKQEAgLTE2MDksMTggKzE2ODUsMzEgQEAg
Y2hlY2tfcGF0aCAoc3RydWN0IHZlY3RvcnMgKiB2ZWNzLCBzdHJ1Y3QgcGF0aCAqIHBwLCBpbnQg
dGlja3MpCiAJCX0gZWxzZQogCQkJcHAtPndhaXRfY2hlY2tzID0gMDsKIAl9Ci0KKwlpZiAoKG5l
d3N0YXRlID09IFBBVEhfRE9XTiB8fCBuZXdzdGF0ZSA9PSBQQVRIX0dIT1NUIHx8CisJCXBwLT5z
dGF0ZSA9PSBQQVRIX0RPV04pKSB7CisJCS8qYXNzaWduZWQgIHRoZSBwYXRoX2Vycl9mb3JnZXRf
cmF0ZSB3aGVuIHdlIHNlZSB0aGUgZmlyc3QgZmFpbHVyZSBvbiB0aGUgcGF0aCovCisJCWlmKHBw
LT5wYXRoX2ZhaWx1cmVzID09IDApeworCQkJcHAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSA9
IHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZTsKKwkJfQorCQlwcC0+cGF0aF9mYWls
dXJlcysrOworCX0KIAkvKgogCSAqIGRvbid0IHJlaW5zdGF0ZSBmYWlsZWQgcGF0aCwgaWYgaXRz
IGluIHN0YW5kLWJ5CiAJICogYW5kIGlmIHRhcmdldCBzdXBwb3J0cyBvbmx5IGltcGxpY2l0IHRw
Z3MgbW9kZS4KIAkgKiB0aGlzIHdpbGwgcHJldmVudCB1bm5lY2Vzc2FyeSBpL28gYnkgZG0gb24g
c3RhbmQtYnkKIAkgKiBwYXRocyBpZiB0aGVyZSBhcmUgbm8gb3RoZXIgYWN0aXZlIHBhdGhzIGlu
IG1hcC4KKwkgKgorCSAqIHdoZW4gcGF0aCBmYWlsdXJlcyBoYXMgZXhjZWVkZWQgdGhlIHNhbl9w
YXRoX2Vycl90aHJlc2hvbGQgCisJICogd2l0aGluIHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSB0
aGVuIHdlIGRvbid0IHJlaW5zdGF0ZQorCSAqIGZhaWxlZCBwYXRoIGZvciBzYW5fcGF0aF9lcnJf
cmVjb3ZlcnlfdGltZQogCSAqLwotCWRpc2FibGVfcmVpbnN0YXRlID0gKG5ld3N0YXRlID09IFBB
VEhfR0hPU1QgJiYKKwlkaXNhYmxlX3JlaW5zdGF0ZSA9ICgobmV3c3RhdGUgPT0gUEFUSF9HSE9T
VCAmJgogCQkJICAgIHBwLT5tcHAtPm5yX2FjdGl2ZSA9PSAwICYmCi0JCQkgICAgcHAtPnRwZ3Mg
PT0gVFBHU19JTVBMSUNJVCkgPyAxIDogMDsKKwkJCSAgICBwcC0+dHBncyA9PSBUUEdTX0lNUExJ
Q0lUKSA/IDEgOgorCQkJICAgIGNoZWNrX3BhdGhfdmFsaWRpdHlfZXJyKHBwKSk7CiAKIAlwcC0+
Y2hrcnN0YXRlID0gbmV3c3RhdGU7CisKIAlpZiAobmV3c3RhdGUgIT0gcHAtPnN0YXRlKSB7CiAJ
CWludCBvbGRzdGF0ZSA9IHBwLT5zdGF0ZTsKIAkJcHAtPnN0YXRlID0gbmV3c3RhdGU7Cg==

--_002_af56a18e992f4a8cb474de87a208e02aBRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_af56a18e992f4a8cb474de87a208e02aBRMWPEXMB12corpbrocadec_--
