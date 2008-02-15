From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipath errors on first set-up
Date: Fri, 15 Feb 2008 14:19:30 -0600
Message-ID: <20080215201930.GG15608@ether.msp.redhat.com>
References: <DFB2D7E03264FB4392B70A38BFF9FC7101FFB4C3@BRBSEVS20000.s2.ms.unilever.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <DFB2D7E03264FB4392B70A38BFF9FC7101FFB4C3@BRBSEVS20000.s2.ms.unilever.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Fri, Feb 15, 2008 at 04:22:07PM -0000, Rogan, Julian wrote:
>    Hi,
>    I am using multipath for the first time with little joy.

<snip>
 
>    based on some other documents I made the following changes to
>    /etc/multipath.conf

You can probably leave the entire /etc/multipath.conf commented out.
Everything should just autodetect correctly.
 
>    I ran
>    multipath -v3 to recreate I get the following:

<snip>

>    device-mapper ioctl cmd 14 failed: Invalid argument
>    message 3600508b300930230a7495ae1b9500074 0 switch_group 1
>    failed
> 
>    Note sure if "path sdX not found in pathvec" relevant

No, that's supposed to be there.
 
>    anyway no mpaths have been created.
> 
>    I hope there is someone out there who can give me some help with this.

No chance you can update to a more recent version of RHEL4?

The device-mapper message means the command you send to device-mapper
didn't work.  However, it looks completely sensible.  What version
of device-mapper are you using?

# rpm -q device-mapper

I'm guessing that you will see something like
device-mapper-1.01.04-1.0.RHEL4

device-mapper-multipath-0.4.5-6.0.RHEL4 needs
device-mapper-1.02.*

Look at things from my side, it definitely seems like RHEL 4.2 says it
uses device-mapper-1.01, which doesn't make any sense, since
device-mapper-multipath-0.4.5-6.0.RHEL4 was definitely compiled against
device-mapper-1.02, and I don't believe that the can both 1.01 and 1.02
can coexist on a system.

The easy solution is to upgrade to at least RHEL 4.3

If that's impossible, you can try to upgrade device-mapper to
device-mapper-1.02.02-1.0.RHEL4 or later.  This might cause all sorts of
dependancy issues. It may be easier to downgrade device-mapper-multipath
to device-mapper-multipath-0.4.5-5.2.RHEL4

I'm not sure why this incompatibility exists now, since it obviously
didn't when RHEL 4.2 was originally released. My best guess is that
device-mapper-multipath-0.4.5-6.0.RHEL4 didn't really get released
until RHEL 4.3, but that's just a guess.

Of course, if you already have device-mapper-1.02.* on your system, and
are still seeing these issues, then something else is going on.

-Ben

>    with regards,
>    Julian Rogan

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
