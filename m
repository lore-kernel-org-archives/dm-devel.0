From: Adam Williamson <awilliam@redhat.com>
Subject: Changes in DM_MULTIPATH_DEVICE_PATH in multipath-tools
	0.7.7
Date: Thu, 13 Sep 2018 18:16:29 -0700
Message-ID: <96e2092ae7f7638732745758d8aa7d4e2972b515.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, mwilck@suse.com
List-Id: dm-devel.ids

Hi, folks!

So I've just been on a two-day debugging odyssey into why Fedora 29's
installer couldn't see firmware RAID devices, and the culprit turned
out to be multipath-tools:

https://bugzilla.redhat.com/show_bug.cgi?id=1628192

to summarize, the problem is in how multipath-tool's udev rules set the
DM_MULTIPATH_DEVICE_PATH udev device property. The relevant commits are
these two:

https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commit;h=b729b8f3a21fe6867165b2533496ebdfbc493263
https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commit;h=7e867718d1d0133e8ed34835320451f93358f2f9

Prior to the first commit, for a device that is a valid multipath
device, the property would be set with a value of '1'. For a device
that is *not* a valid multipath device, the property would *not be set
at all*. The udev rule that set it was:

ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
       PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
       ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="mpath_member", \
       ENV{SYSTEMD_READY}="0"

...which basically means "run multipath -u (device), if that command
succeeds, set DM_MULTIPATH_DEVICE_PATH to '1' (and a couple other
values too). If it fails, don't do anything."

So obviously, for non-multipath devices, the property wasn't set. The
first commit changed this. It changed the udev rule to this:

IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"

That basically means "run multipath -u (device), expect its output to
be lines of 'KEY=value' pairs, and import those pairs as device
properties". At the same time, multipath -u itself was changed so that
if the device *is* a valid multipath device, it outputs this to stdout:

DM_MULTIPATH_DEVICE_PATH="1"

if the device is *not* a valid multipath device, it outputs this:

DM_MULTIPATH_DEVICE_PATH="0"

so it's pretty easy to see that the behaviour has changed: now, if the
device is not a valid multipath device, DM_MULTIPATH_DEVICE_PATH is set
to the value "0", instead of not being set at all.

This turns out to have consequences, because two *other* udev rules
files (in Fedora at least) use this check:

ENV{DM_MULTIPATH_DEVICE_PATH}=="?*"

that check will match if DM_MULTIPATH_DEVICE_PATH is set to *any one or
more characters at all*...including '0'.

The upshot of this is that 65-md-incremental.rules basically gets
skipped entirely any time this happens, and our firmware RAID set
doesn't get initialized by that rule set as it should. The other rules
file that uses this check is 80-udisks2.rules; the impact there is that
various UDISKS_MD_(FOO) device properties may not get set. I'm not sure
what the consequences of that are.

(In passing I'll note that the commit message claims "The exit status
remains as usual.", but that is not true. The old 'multipath -u' exited
1 if the device was not a valid multipath device. The new one exits 0
in this case. I don't know if this is intentional or an oversight).

The *second* commit introduces a new possible value for
DM_MULTIPATH_DEVICE_PATH - "2", meaning "this *might* be a multipath
device, but we're not sure yet." This *may* also be significant to
other rules, because there are several that use this check:

ENV{DM_MULTIPATH_DEVICE_PATH}=="1"

it's at least *possible* that some of them should do this instead:

ENV{DM_MULTIPATH_DEVICE_PATH}=="[12]"

but I'm not sure. If they should go ahead and do their thing anyway in
the '2' case, obviously, it's fine. Also, I'm not sure the '2' value
ever really "escapes" the multipath rules file - it looks like it may
only ever be handled there, and other rules will only ever see 0, 1 or
'unset'. Again, in that case this wouldn't be a problem.

So basically I just wanted to flag this up and see what folks want to
do about it. To fix the immediate issue for Fedora I sent an mdadm
build that changes the check from "?*" to "1". However, we may want to
consider changing all the checks to "1" or "[12]", and/or changing
multipath -u to behave more like it used to. It could just print
*nothing* if the device is not a valid multipath one, for instance
(which should result in the device property not being set at all, just
like the old behaviour). Or it could print this:

DM_MULTIPATH_DEVICE_PATH=""

though I'm not 100% sure of the consequences of doing that, in the
context of udev device properties.

Thanks folks!
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net
