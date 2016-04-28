From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Thu, 28 Apr 2016 17:10:45 -0500
Message-ID: <20160428221045.GH26117@octiron.msp.redhat.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
	<CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
	<1986ca6b-d281-4faf-2b50-11c3dc132463@gmail.com>
	<571F026C.5040102@suse.de>
	<20160427224601.GG26117@octiron.msp.redhat.com>
	<5721AC70.3070606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5721AC70.3070606@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Peter Volkov <peter.volkov@gmail.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 28, 2016 at 08:23:44AM +0200, Hannes Reinecke wrote:
> On 04/28/2016 12:46 AM, Benjamin Marzinski wrote:
> > Like I said, Red Hat doesn't use them. I'll post our multipath.rules
> > shortly.
> > 
> Which would be cool.
> I was actually hoping to meet you in Raleigh last week, but then it
> didn't work out.
> 
Here is a heavily commented copy of our rules file.
----------

SUBSYSTEM!="block", GOTO="end_mpath"
ACTION!="add|change", GOTO="end_mpath"
# If /etc/multipath.conf doesn't exist or multipathing is disabled
# on the kernel commandline, we do nothing.
IMPORT{cmdline}="nompath"
ENV{nompath}=="?*", GOTO="end_mpath"
TEST!="/etc/multipath.conf", GOTO="end_mpath"

ENV{DEVTYPE}=="partition", IMPORT{parent}="DM_MULTIPATH_DEVICE_PATH"
ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
	GOTO="end_mpath"

ENV{MPATH_SBIN_PATH}="/sbin"
TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"

# I know that we run the multipath rules later that SUSE does (after blkid
# runs, for one thing), but I've never seen the issue that caused Hannes to
# add the -u option. I don't see any reason why we couldn't use it however.
#
# Also, we only unconditionally check if the device is a multipath device
# on addition, because it takes a while, and we've run into issues where
# udev times out if we do it on every change event.
ACTION=="add", ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -c $tempnode", \
	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="mpath_member"

ACTION!="change", GOTO="update_timestamp"
# Load some variables from the database. The new ones will get explained
# down below
IMPORT{db}="DM_MULTIPATH_TIMESTAMP"
IMPORT{db}="DM_MULTIPATH_DEVICE_PATH"
IMPORT{db}="DM_MULTIPATH_WIPE_PARTS"
IMPORT{db}="DM_MULTIPATH_NEED_KPARTX"

# o.k. this whole next part is so hacky, it will make your eyes bleed.
# The idea is sound, however. Like I mentioned above, I was seeing udev
# timeout issues when I checked the path on every change event. My idea
# to stop this was to have multipathd write out a timestamp when it
# starts, and update this whenever a new path is added to the wwids file
# or the configuration is reload. If neither of these thing has happened,
# then rechecking the path will give you the same answer as before, so
# it's not necessary. The the udev rules could read in the timestamp file,
# check it against the existing timestamp, and only run this check if
# the timestamp was different. The problem is that there is no way to do
# that in the udev rules. You can compare variables to constants. You
# can assign variables to other variables, but you can't compare
# variables to other variables. I've filed a bug and sent emails about this
# to the udev people, but I haven't gotten any response. So, as a
# workaround, I added a multipath option, -T, which does the timestamp
# comparison as soon as multipath starts up, and if they're equal, simply
# returns the value you passed in with the timestamp. It's not as fast as
# not execing multipath at all, but it is enough faster to fix the issue
# I was seeing. But this should really be fixed in the udev rules, not
# in multipath.  That's why I've never posted this upstream. It's a hack.
#
# But the general idea here is that this is where multipath checks devices
# on change events instead of add events.
PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -T $env{DM_MULTIPATH_TIMESTAMP}:$env{DM_MULTIPATH_DEVICE_PATH} -c $env{DEVNAME}", \
	ENV{DM_MULTIPATH_DEVICE_PATH}="1", ENV{ID_FS_TYPE}="mpath_member", \
	GOTO="update_timestamp"

# If the device isn't part of a multipath device, clear these
ENV{DM_MULTIPATH_DEVICE_PATH}=""
ENV{DM_MULTIPATH_WIPE_PARTS}=""

LABEL="update_timestamp"
# This deletes the partition devnodes from any multipath path device. We want
# to be careful to only run this once. If the users recreates the partition
# devices for some reason, we don't want to keep blowing them away. That's why
# we set DM_MULTIPATH_WIPE_PARTS and import it on future events.
ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{DM_MULTIPATH_WIPE_PARTS}!="1", \
	ENV{DM_MULTIPATH_WIPE_PARTS}="1", \
	RUN+="/sbin/partx -d --nr 1-1024 $env{DEVNAME}"

# this sets DM_MULTIPATH_TIMESTAMP
IMPORT{file}="/run/multipathd/timestamp"

LABEL="check_kpartx"
# This is where we create the kpartx partitions
KERNEL!="dm-*", GOTO="end_mpath"
# This sets the link priority for all multipath and kpartx devices
# so that udev creates the /dev/disk/by-* symlinks to them instead of
# to the path devices.
ENV{DM_UUID}=="mpath-?*|part[0-9]*-mpath-?*", OPTIONS+="link_priority=10"
ACTION!="change", GOTO="end_mpath"
ENV{DM_UUID}!="mpath-?*", GOTO="end_mpath"
# We don't want to run kpartx on every change event (which will happen
# whenever multipathd reloads the table). So only run it in the same
# situations where lvm would scan the device. However, sometimes
# multipath is suspended when this happens. In that case, we use
# DM_MULTIPATH_NEED_KPARTX to remember that we need to run kpartx
# when the next event is generated (and since the device is suspended
# the next even should be arriving shortly)
ENV{DM_ACTIVATION}=="1", ENV{DM_MULTIPATH_NEED_KPARTX}="1"
ENV{DM_SUSPENDED}=="1", GOTO="end_mpath"
ENV{DM_ACTION}=="PATH_FAILED", GOTO="end_mpath"
ENV{DM_ACTIVATION}!="1", ENV{DM_MULTIPATH_NEED_KPARTX}!="1", GOTO="end_mpath"
RUN+="$env{MPATH_SBIN_PATH}/kpartx -a $tempnode", \
	ENV{DM_MULTIPATH_NEED_KPARTX}=""
LABEL="end_mpath"
