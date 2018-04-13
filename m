From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 20/20] multipath.rules: find_multipaths
	"smart" logic
Date: Fri, 13 Apr 2018 11:01:38 -0500
Message-ID: <20180413160138.GE3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-21-mwilck@suse.com>
	<20180412184851.GV3103@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180412184851.GV3103@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Thu, Apr 12, 2018 at 01:48:51PM -0500, Benjamin Marzinski wrote:
> On Wed, Apr 04, 2018 at 06:16:27PM +0200, Martin Wilck wrote:
> > When the first path to a device appears, we don't know if more paths are going
> > to follow. find_multipath "smart" logic attempts to solve this dilemma by
> > waiting for additional paths for a configurable time before giving up
> > and releasing single paths to upper layers.
> > 
> > These rules apply only if both find_multipaths is set to "smart" in
> > multipath.conf. In this mode, multipath -u sets DM_MULTIPATH_DEVICE_PATH=2 if
> > there's no clear evidence wheteher a given device should be a multipath member
> > (not blacklisted, not listed as "failed", not in WWIDs file, not member of an
> > existing map, only one path seen yet). In this case, "multipath -u" also sets the
> > variable FIND_MULTIPATHS_WAIT_UNIL to a relative time stamp (we need to use
> > relative "monotonic" time stamps because this may be triggered early during
> > boot, before system "calendar" time is correctly initialized).
> > 
> > In the DM_MULTIPATH_DEVICE_PATH=2 case, pretend that the path is multipath
> > member, disallow further processing by systemd (allowing multipathd some time
> > to grab the path), and set a systemd timer to check again after the given
> > timeout. If the path is still not multipathed by then, pass it on to systemd
> > for further processing.
> > 
> 
> 
> Like I've mentioned, I think multipath -u should be called with a
> special option on add events or if FIND_MULTIPATHS_WAIT_UNTIL exists and
> is non-zero (or perhaps we should IMPORT DM_MULTIPATH_DEVICE_PATH, and
> check if it's 2 or import SYSTEMD_READY and check if it's 0), that smart
> mode could use to allow maybes and new claims on existing paths because
> another path appeared.

Since you have a different way of solving the issue, that doesn't need this
change to the udev rules

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  multipath/multipath.rules | 64 ++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 60 insertions(+), 4 deletions(-)
> > 
> > diff --git a/multipath/multipath.rules b/multipath/multipath.rules
> > index aab64dc..77b9f16 100644
> > --- a/multipath/multipath.rules
> > +++ b/multipath/multipath.rules
> > @@ -19,9 +19,65 @@ LABEL="test_dev"
> >  ENV{MPATH_SBIN_PATH}="/sbin"
> >  TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
> >  
> > -# multipath -u sets DM_MULTIPATH_DEVICE_PATH
> > -ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
> > -ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
> > -	ENV{SYSTEMD_READY}="0"
> > +# FIND_MULTIPATHS_WAIT_UNTIL is the timeout (in seconds after the
> > +# epoch).
> > +IMPORT{db}="FIND_MULTIPATHS_WAIT_UNTIL"
> > +ENV{.SAVED_FM_WAIT_UNTIL}="$env{FIND_MULTIPATHS_WAIT_UNTIL}"
> > +
> > +# multipath -u sets DM_MULTIPATH_DEVICE_PATH and,
> > +# if "find_multipaths smart", also FIND_MULTIPATHS_WAIT_UNTIL.
> > +ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
> > +	IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
> > +
> > +# case 1: this is definitely multipath
> > +ENV{DM_MULTIPATH_DEVICE_PATH}=="1", \
> > +	ENV{ID_FS_TYPE}="mpath_member", ENV{SYSTEMD_READY}="0", \
> > +	GOTO="stop_wait"
> > +
> > +# case 2: this is definitely not multipath, or timeout has expired
> > +ENV{DM_MULTIPATH_DEVICE_PATH}!="2", \
> > +	GOTO="stop_wait"
> > +
> > +# Code below here is only run in "smart" mode.
> > +# multipath -u has indicated this is "maybe" multipath.
> > +
> > +# This shouldn't happen, just in case.
> > +ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="?*", GOTO="end_mpath"
> > +
> > +# Be careful not to start the timer twice.
> > +ACTION!="add", GOTO="pretend_mpath"
> > +ENV{.SAVED_FM_WAIT_UNTIL}=="?*", GOTO="pretend_mpath"
> > +
> > +# At this point, we are seeing this path for the first time, and it's "maybe" multipath.
> > +
> > +# The actual start command for the timer.
> > +#
> > +# The purpose of this command is only to make sure we will receive another
> > +# uevent eventually. *Any* uevent may cause waiting to finish if it either ends
> > +# in case 1-3 above, or if it arrives after FIND_MULTIPATHS_WAIT_UNTIL.
> > +#
> > +# Note that this will try to activate multipathd if it isn't running yet.
> > +# If that fails, the unit starts and expires nonetheless. If multipathd
> > +# startup needs to wait for other services, this wait time will add up with
> > +# the --on-active timeout.
> > +#
> > +# We must trigger an "add" event because LVM2 will only act on those.
> > +
> > +RUN+="/usr/bin/systemd-run --unit=cancel-multipath-wait-$kernel --description 'cancel waiting for multipath siblings of $kernel' --no-block --timer-property DefaultDependencies=no --timer-property Conflicts=shutdown.target --timer-property Before=shutdown.target --timer-property AccuracySec=500ms --property DefaultDependencies=no --property Conflicts=shutdown.target --property Before=shutdown.target --property Wants=multipathd.service --property After=multipathd.service --on-active=$env{FIND_MULTIPATHS_WAIT_UNTIL} /usr/bin/udevadm trigger --action=add $sys$devpath"
> > +
> > +LABEL="pretend_mpath"
> > +ENV{DM_MULTIPATH_DEVICE_PATH}="1"
> > +ENV{SYSTEMD_READY}="0"
> > +GOTO="end_mpath"
> > +
> > +LABEL="stop_wait"
> > +# If timeout hasn't expired but we're not in "maybe" state any more, stop timer
> > +# Do this only once, and only if the timer has been started before
> > +IMPORT{db}="FIND_MULTIPATHS_WAIT_CANCELLED"
> > +ENV{FIND_MULTIPATHS_WAIT_CANCELLED}!="?*", \
> > +	ENV{FIND_MULTIPATHS_WAIT_UNTIL}=="?*", \
> > +	ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="0", \
> > +	ENV{FIND_MULTIPATHS_WAIT_CANCELLED}="1", \
> > +	RUN+="/usr/bin/systemctl stop cancel-multipath-wait-$kernel.timer"
> >  
> >  LABEL="end_mpath"
> > -- 
> > 2.16.1
