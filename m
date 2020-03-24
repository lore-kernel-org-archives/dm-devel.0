From: Martin Wilck <mwilck@suse.com>
Subject: Re: multipathd: fix check_path could not resume path
	state
Date: Tue, 24 Mar 2020 11:58:16 +0100
Message-ID: <a0a0ed10c9208c7be10adb483298ceb1d10ef0c8.camel@suse.com>
References: <723608783F175343AAB90DD84928BC3405B3531C@dggeml530-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <723608783F175343AAB90DD84928BC3405B3531C@dggeml530-mbs.china.huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: wangjufeng <wangjufeng@huawei.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Wangjufeng,

On Sat, 2020-03-21 at 15:53 +0000, wangjufeng wrote:
> From fb655da18aefccaa09c70036b08c88a03609ec45 Mon Sep 17 00:00:00
> 2001
> From: wangjufeng <wangjufeng@huawei.com>
> Date: Sat, 21 Mar 2020 22:23:10 +0800
> Subject: [PATCH] multipathd: fix check_path could not resume path
> state
> 
> For some unknown reason, after network recovery from disconnection,
> the paths in a multipath are still in fail state. Use gdb attached
> multipathd, the paths seem to be changed by orphan_path function,
> pp->initialized is INIT_OK while pp->mpp is NULL, pp->dmstate is
> PSTATE_UNDEF, pp->fd is -1. And the multipath could not be found in
> gvecs->mpvec while it could be found by dmsetup table command.
> 
> It will lead to that the path state could not be activated by
> check_path even if the iscsi device is already available.
> 
> This patch intend to add the multipath map again to avoid IO failure
> or IO blocked when the above phenomenon occur.
> 
> Signed-off-by: wangjufeng <wangjufeng@huawei.com>
> Reviewed-by: linfeilong <linfeilong@huawei.com>

thank you for your patch. 

I'm not sure if this is the right approach. The purpose of check_path()
is to check existing paths, not for adding new ones, and not for adding
multipath maps.

I'd like to understand your failure scenario better. 

You seem to disconnect all paths of a multipath map, causing the
path devices to be deleted from the system. Indeed, if this happens,
and the last path is removed, multipathd will also remove the multipath
map from mpvec. But then, if the paths are re-added, I'd expect ADD
udev events to occur. multipathd should notice these uevents and re-add 
both the paths and the map.

If this fails in your scenario, something is wrong with uevent
handling. 

 - please indicate exactly what multipath-tools version you've been
using
 - how do you disconnect / reconnect devices? are the lowlevel devices
set offline, blocked / unreachable, or actually removed from the
system?
 - in any case, please provide a log of multipathd taken with at least
verbosity 3 showing what's going on in your system in the failure
scenario. Help us understand your log by indicating when you
disconnected or reconnected storage volumes.

You may also want to run "udevadm monitor" separately, to figure out if
uevents are correctly generated.

Regards
Martin

PS: Your patch has whitespace issues. Next time, please make sure that
you get the indentation right.
