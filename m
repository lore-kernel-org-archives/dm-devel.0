From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Trouble configuring MPIO with multipath-tools
Date: Mon, 31 Oct 2005 20:49:54 +0100
Message-ID: <1130788194.13850.126.camel@zezette>
References: <200510311820.j9VIKTUJ012571@mh0.sv.mailhost.seagate.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200510311820.j9VIKTUJ012571@mh0.sv.mailhost.seagate.com>
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

On lun, 2005-10-31 at 11:20 -0700, Dale.R.Fowle@seagate.com wrote:
> Hi all, I'm wondering if anyone can help un-confuse me. =-)
> 
> I've been through about every document I can find on the internet trying to
> chase down exactly how I'm supposed to configure devices for MPIO. I
> haven't seen the same answer twice. Everything is different.
> 
> The most formal documentation I found was here:
> http://portal.suse.com/sdb/en/2005/04/sles_multipathing.html
> 
> I've also been out to the multipath-tools resource page:
> http://christophe.varoqui.free.fr/
> 
I bet you'll volonteer to make some really nice doc when you'll have a
good insight of Linux mp-tools. :/

> I really haven't gotten anything to work yet. =-)
> 
> I also saw another issue addressed from this e-mail discussion board that
> said really all you need to do is uncomment some lines in
> /etc/multipath.conf and comment out some other lines and you're good to go.
> 
Yes, it all boils down to that.

But for a safe start, you should be happy with no config file at all.
Safe defaults should apply, and you can tweak one param at a time from
there to see its effect.

> So, to clear things up with the device mapper piece of things. Is there any
> requirement of the multipath command that these devices have to be
> pre-built using dmsetup before multipath will recognize and built a path
> under /dev/dm-*?

No. dmsetup is not recquired for mpio operation.
As for /dev/dm-* : they are not recquired to exist at all.
The agreement is to use /dev/mapper/{alias,wwid} nodes.

>  If so,...how do you setup two paths to one device in your
> target_file?

No target_file. No manual assemble.

>  What's confusing to me for setting up two devices in a
> "linear" fashion would seem like it's creating a concatenation of two
> separate devices instead of creating two paths to one device (i.e. "0
> 1028160 linear /dev/hda 0 1028160 3903762 linear /dev/hdb 0" from the
> dmsetup manpage). The only other options are to set them up as stripe or
> error devices.
> 
linear, stripe, error, multipath, ... are target policies.
Concatenation is the *only* policy to chain multi-line tables.
Each line can have a different target policy.

multipath-tools use only 1-line tables. All paths of a multipath are
specified on this single line.

Users should not have to mess with this low-level stuff.

> I'm not sure where to go next with this. I can see my two paths at /dev/sda
> and /dev/sdb. Whether I partition them or not, multipath won't pick
> anything up and display it with 'multipath -v2 -d' or 'multipath -l'. What
> I get from 'multipath -v2 -d' is an error like this:
> 
> #multipath -v2 -d
> error calling out /bin/false
> error calling out /bin/false
> #
> 
multipath -d won't do anything (dry mode).
You need to comment out the /bin/false prioritizer in the config file.

> Also, does multipathd or the multipath command itself update
> /etc/multipath.conf when multipath configures or recognizes a device,..or
> is it all a manual process?

The tools never touch /etc/multipath.conf

>  I can't say I've ever seen a device addressed
> like this before:
>                                                                             
>           3600601607cf30e00184589a37a31d911                                 
>                                                                             
>                                                                             
> Coming from a Solaris background, I'm used seeing the WWNN and/or the WWPN.
> =-) I'm pretty new to the Linux world, so I understand that I'll have to
> get used to seeing things differently sometimes.
> 
This is the default naming before recent upstream version.
You'll find the nodes in /dev/mapper/

> Anyways, I'd appreciate any help anyone can offer. FYI, I'm running SLES 9
> with SP2, multipath-tools 0.4.4 is installed, and I'm using a pair of
> Qlogic 2340 HBAs. The storage array controllers are configured as
> active/active. The Qlogic failover parameter is disabled due to my previous
> trials playing with mdadm's mpio features as well.
> 
Good. Keep it that way.

Regards,
cvaroqui
