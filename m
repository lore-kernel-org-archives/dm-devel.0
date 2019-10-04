From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: multipath-tools: RH-patches for upstream ???
Date: Fri, 4 Oct 2019 07:03:26 +0000
Message-ID: <5d38873e4ea51f00d1d49e9e9fb86419542598e8.camel@suse.com>
References: <e2b955d0-69ea-2c2b-9f0f-ccf3b5f369d0@gmail.com>
	<20191003214420.GE25414@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191003214420.GE25414@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <B5EA101DCFB37841BA149AE71BED68C9@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Hi Xose, hi Ben,

On Thu, 2019-10-03 at 16:44 -0500, Benjamin Marzinski wrote:
> On Thu, Oct 03, 2019 at 08:28:06PM +0200, Xose Vazquez Perez wrote:
> > Hi Benjamin,
> > 
> > 
> > Is there any relevant RH-patch for upstream in fedora repo:
> > https://src.fedoraproject.org/rpms/device-mapper-multipath/ ???
> > 
> > Maybe:
> > 
> > - 
> > https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0022-RH-Remove-the-property-blacklist-exception-builtin.patch
> > 
> >    Subject: [PATCH] RH: Remove the property blacklist exception
> > builtin
> > 
> >     Multipath set the default property blacklist exceptions to	
> >     (ID_SCSI_VPD|ID_WWN).  This has the effect of blacklisting some
> > internal
> >     devices.  These devices may never have multiple paths, but it
> > is nice
> >     to be able to set multipath up on them all the same.  This
> > patch simply
> >     removes the default, and makes it so that if no property
> >     blacklist_exception is given, then devices aren't failed for
> > not matching
> >     it.
> 
> Redhat doesn't include the udev rules file that sets ID_SCSI_VPD, so
> there are some rare cases where this property blacklists valid
> devices.
> Thus, it's easier for us to simply include this property line in the
> default multipath.conf, and let users remove it if necessary. I would
> be
> fine with this being included upstream, but I suspect it would mess
> with
> other ditsros which are currently assuming that it is there.

Hm. ID_SCSI_VPD is nowhere referenced in the upstream code. The default
is "(SCSI_IDENT_|ID_WWN)", where SCSI_IDENT_ could be regarded as a
SUSE-ism because the SCSI_IDENT_* properties are set by sg_inq / sg_vpd
calls, and I'm not sure if other distros consequently use sg_inq rather
than scs_id like we do. We (SUSE) have been working on replacing
scsi_id by sg3_utils calls in upstream systemd, but so far that hasn't
been merged, systemd maintainers are very cautious about touching these
udev rules.

I'd be interested in seeing an example for a device that is erroneously
excluded by the default blacklist rule.

In general, it's a shortcoming of multipath-tools that the built-in
blacklists can only be appended to, not replaced, by user
configuration.

> > 
> > - https://src.fedoraproject.org/rpms/device-mapper-
> > multipath/blob/master/f/0026-RH-add-wwids-from-kernel-cmdline-
> > mpath.wwids-with-A.patch
> > 
> >    Subject: [PATCH] RH: add wwids from kernel cmdline mpath.wwids
> > with -A
> > 
> >     This patch adds another option to multipath, "-A", which reads
> >     /proc/cmdline for mpath.wwid=<WWID> options, and adds any wwids
> > it finds
> >     to /etc/multipath/wwids.  While this isn't usually important
> > during
> >     normal operation, since these wwids should already be added, it
> > can be
> >     helpful during installation, to make sure that multipath can
> > claim
> >     devices as its own, before LVM or something else makes use of
> > them.  The
> >     patch also execs "/sbin/multipath -A" before running multipathd
> > in
> >     multipathd.service
> > 
> 
> I posted this upstream and Hannes NAKed it a while back. We still
> find
> it useful, since the default multipath.conf file for Redhat sets
> find_multipaths to yes. You can currently avoid the race that this is
> fixing by setting find_multipaths to smart, but there were objections
> to
> using that as a default in Redhat. However, I never really understood
> the objection to this patch, and I'd be fine with re-posting it.

https://www.redhat.com/archives/dm-devel/2014-July/msg00011.html

I'm with Hannes. Doing this in dracut, udev rules, or systemd service
files seems cleaner to me than yet another daemon that tries to
interpret the kernel command line.

See e.g. how we implemented multipath=off (cd3184e).

> > - 
> > https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0027-RH-warn-on-invalid-regex-instead-of-failing.patch
> > 
> >    Subject: [PATCH] RH: warn on invalid regex instead of failing
> > 
> >     multipath.conf used to allow "*" as a match everything regular
> > expression,
> >     instead of requiring ".*". Instead of erroring when the old
> > style
> >     regular expressions are used, it should print a warning and
> > convert
> >     them.
> c45d2a0e
> When multipath used its old regex code, "*" worked to match
> everything.
> This patch just exists to make sure that customers didn't need to
> change
> their configs when the regex code changed. Since it's been there
> posting
> warning messages for a while, I plan to eventually drop it entirely,
> and
> let anyone who has been ignoring the warning messages for years
> finally
> have their config error. I see no reason to add it back to the
> upstream
> code now.

Ack. Upstream has removed support for "*" in 2014 (b9d11f3), and did
it deliberately.

>  
> > - 
> > https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0028-RH-reset-default-find_mutipaths-value-to-off.patch
> > 
> >    Subject: [PATCH] RH: reset default find_mutipaths value to off
> > 
> >     Upstream has changed to default find_multipaths to "strict".
> > For now
> >     Redhat will retain the previous default of "off".
> 
> This is simply to retain the previous default behavior, for much the
> same reason as the above patch. I see no reason to change this
> upstream.

Ack. Btw SUSE changes the default, too (to "greedy", though).

> 
> > - 
> > https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0029-RH-Fix-nvme-compilation-warning.patch
> > 
> >    Subject: [PATCH] RH: Fix nvme compilation warning
> > 
> 
> I assume that other people aren't seeing these compilation warnings,
> and
> this it due to different options that redhat uses when compiling.  I
> really should push this patch upstream, but that upstream isn't
> multipath-tools, its nvme-cli, where we copied this file from. Once
> it's
> changed there, we can pull the updated files back to multipath-tools.

Ack. Which compiler option triggers this warning?

>  
> > - 
> > https://src.fedoraproject.org/rpms/device-mapper-multipath/blob/master/f/0030-RH-attempt-to-get-ANA-info-via-sysfs-first.patch
> > 
> >    Subject: [PATCH] RH: attempt to get ANA info via sysfs first
> > 
> >     When the ANA prioritizer is run, first see if the "ana_state"
> > sysfs file
> >     exists, and if it does, try to read the state from there. If
> > that fails,
> >     fallback to using an ioctl.
> > 
> 
> This won't do anything upstream. This requires a redhat specific
> kernel
> patch that wasn't accepted in the upstream nvme kernel code.  It
> really
> doesn't make much of a difference. It just makes multipath try to
> grab
> ANA state info from sysfs, before failing back to the same ioctl that
> upstream uses.

Ack.

Martin
