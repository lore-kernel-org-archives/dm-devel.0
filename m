From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/12] Make multipath add wwids from kernel
 cmdline mpath.wwids with -A
Date: Wed, 02 Jul 2014 08:03:38 +0200
Message-ID: <53B3A0BA.9040502@suse.de>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>	<1404105243-5071-7-git-send-email-bmarzins@redhat.com>
	<CABr-GnedX62W_U988FjXs4eV+GisRjt_AhPe4J6XhBPzF+_uCw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GnedX62W_U988FjXs4eV+GisRjt_AhPe4J6XhBPzF+_uCw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/01/2014 09:22 PM, Christophe Varoqui wrote:
> Hannes,
>
> would you Ack this one, or do you have some other idea for this in
> your tree ?
>
Sigh. The whole multipath / systemd / dracut integration
is _a mess_.
The main problem is that RH and SUSE treat multipath handling =

differently.
(From what I can see. I've still a hard time to understand how
  multipath booting works with RH. So there might be errors.)

RH is taking a restrictive approach, ie it'll allow only configured =

multipath devices during boot. IE it'll accept only devices present
in '/etc/multipath/wwids' for booting. So when coming across a new
wwid multipath won't be setup there, so of course they'll need an
additional parameter for that.

SUSE, OTOH, is taking the permissive approach. When multipath is =

included in dracut it'll try to generate multipath devices for _all_ =

existing devices; the wwid file is not really required here.
And, consequently, the '-A' parameter isn't required, too.

While this is nice and proper, both approaches have issues:
- From what I've seen RH is building a 'generic' initrd, and
   configures them via the kernel or dracut commandline.
   Which makes it a bit hard for multipathing as the wwid
   most certainly cannot be part of /etc/multipath/wwids.
   But I guess this is what should be fixed by this patch.
- SUSE is building a 'per-host' initrd, ie it'll generate
   an initrd for that specific installation.
   So there isn't actually a _need_ for the permissive approach,
   as chances are it'll never come across anything else
   _but_ the configured device.
   Plus I haven't really evaluated whether the permissive
   approach actually works properly, ie that multipath will
   try to create device-mapper devices for unknown wwids.

But back to the patch.
I must say I'm not really in favour of this.
Implementing kernel commandline parsing in the _daemon_ is just =

downright evil.
It would be _far_ more sensible to have it implemented in dracut
as a commandline hook, which just adds the wwid from the kernel =

commandline to /etc/multipath/wwids.
That's a simple shell script with no magic involved.
Then the wwids would be in place when multipathd is started and =

everything will work.

Cheers,

Hannes
P.S.: And yes, I do have some patches queued, too ...
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
