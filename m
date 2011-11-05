From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 04 Nov 2011 23:50:57 -0400
Message-ID: <4EB4B2A1.9090700@cfl.rr.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com> <4EB2E4B7.7000103@cfl.rr.com>
	<CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
	<4EB407DC.8070307@cfl.rr.com> <20111104155228.GY4417@google.com>
	<4EB4121A.1060102@cfl.rr.com> <20111104163207.GA4417@google.com>
	<4EB45467.4060605@cfl.rr.com> <20111104215025.GB4417@google.com>
	<4EB49191.6060609@cfl.rr.com>
	<CAOS58YNVoghyAxfj-MnTGNmRSt_4Mff2s9adq78UnzxsUv_Eug@mail.gmail.com>
	<4EB49EDD.3020708@cfl.rr.com>
	<CAOS58YOH68c2=79YywBN+JzZMn08XZYUwjK5ogbKnOqxKi=AOQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOS58YOH68c2=79YywBN+JzZMn08XZYUwjK5ogbKnOqxKi=AOQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/04/2011 10:52 PM, Tejun Heo wrote:
> Hello,
> 
>> Well if it breaks under Windows, then we can't be faulted for
>> having the same results now can we?
> 
> Heh, let's just remove all hpa features and screw all the current 
> users which depend on them!

The only users that depend on them are those who originally installed
a version of Linux that did it wrong, and those can be handled with
proper distribution upgrade scripts, so yes, why not stop unlocking by
default, and leave it up to the distro upgrade scripts to enable the
override when backward compatibility requires it?

>> The other argument is that unlocking by default trashes whatever
>> data the bios was trying to hide in the HPA, and deviates from
>> the behavior of Windows.
> 
> On the former point, I don't think it matters. If the user doesn't 
> know what it is, [s]he can leave it alone. Maybe userland can do 
> something smarter if it knows the partition lives in hpa locked
> area, like not mounting it by default or hiding it from browser.

You don't think it matters that we are overwriting data that the bios
marked as reserved for its use only, and Windows respects that?  And
user land certainly can do things smarter, the question is what the
kernel default should be.

When upgrading, user land scripts can decide that the previous kernel
was doing it wring, and force the new kernel to continue doing it
wrong for the sake of backward compatibility, but I see no reason why
the default on new installs should deviate from Windows and refuse to
respect the will of the bios.

In other words, if a new install of Windows respects the HPA, then so
should a new install of Linux.

> On the point of not deviating from windows, I kinda agree and my 
> previous "let's just remove all hpa stuff" isn't all that
> sarcastic, but it really isn't that simple. On BIOS raid configs,
> the vendor controls both bios and driver and those drivers are very
> self contained. They implement all from bit pushing driver itself
> to raid stack and high level device management, and actually
> assumes that they have full control of the whole stack and do good
> number of crazy things. It would be surprising if no driver is
> unlocking hpa during driver init. And they do all sorts of crazy
> and broken stuff. Try to follow windows bios raid troubleshooting
> threads, it often ends up "umm... I lost everything and had to
> reinitialized the whole array from BIOS and reinstall".

Again though, it doesn't really have anything to do with fakeraid.  If
there is an HPA without a fakeraid, and Linux violates that HPA, then
Linux is causing damage that Windows does not.  The only reason that
fakeraid has anything to do with it is that for reasons unknown, there
seems to be a general overlap between boards that create an HPA and
boards that do fakeraid.  If fakeraid is out of the picture, and you
have a drive that has an HPA for whatever reason, Windows respects it,
and Linux trashes it.  That's not a good policy.

> If you have a great new idea to solve them all, please go ahead.
> I'll be happy to review.

I'm still looking for a problem that is not both caused by a broken
Linux policy in the past ( installing with an older kernel that
automatically unlocked ), and is solved by unlocking now.  The fact
that the broken Linux policy seems to mostly affect fakeraid users
does not justify continuing that broken policy.

In other words, Windows respects the protected area, so we should as
well, unless we have very good reason to believe that doing so would
cause loss of existing user data.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk60sqEACgkQJ4UciIs+XuLtuwCgg2fBXxE+PjW9i38jYvxFUrqa
qAMAn0+KBgzMnstTZpaOUKZXZeXQ3oU3
=106j
-----END PGP SIGNATURE-----
