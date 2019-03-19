From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/3] New approach at handling changed WWIDs
Date: Tue, 19 Mar 2019 12:11:15 -0500
Message-ID: <20190319171115.GF13295@octiron.msp.redhat.com>
References: <20190318121235.8942-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190318121235.8942-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 18, 2019 at 01:12:32PM +0100, Martin Wilck wrote:
> Hi Ben, hi Christophe,
> 
> after reviewing Ben's last patch set, I've been pondering over the
> handling of changed WWIDs, which seems to have become a bit too clever
> and complex for my taste, and I came up with this new approach
> instead.
> 
> TL;DR: instead of treating paths with changed WWIDs as faulty, act
> as if the path was removed, and another path was then added and
> obtained the device ID of the removed path.
> 
> Long version:

Mine is even longer. Sorry :(

> What would cause the WWID of an in-use path to change on the fly? Other than
> a) gross malfunction of the storage or kernel (which would be almost certain
> to corrupt data anyway, whether or not multipathd is taking precautions),
> I can think of two scenarios: b) multipathd might have missed both a
> "remove" and a subsequent "add" uevent for the device in question; c)
> the admin may have played with the udev rules, and solicited change
> uevents manually.

The issue that orginally caused me to check for a changed wwid was a
user remapping in-use storage on the array, so an existing device no
longer mapped to the same underlying disks. That generally fits under c)
"admin did something stupid". 

I don't believe that b) is something we actually need to worry about.
In that case, multipathd will still have the old fd for the path device,
which will remain unusable, so the path will never get re-enabled.
Also, the kernel should never reuse a device name, if things still have
the old device name open.

So, as far as I know, the only way that the wwid could get legitimately
remapped, barring something like a), which there is no point in trying
to fix, is because of user error (or at least some other program's
error). 

While I agree that a path's wwid changing to a different non-null wwid
is always bad, and removing and re-adding the path seems perfectly
sensible for that scenario, I've can think of two other case where the
wwid can change to null.  d) a change event happens while the path is
down.  e) there is a uevent storm and udev times out while handling a
change event.

d) and e) seem to me like by far the most likely scenarios, so doing
something suboptimal for them, in order to optimize the very unlikely
scenarios seems wrong.

Have you ever seen this happen where it was multipaths fault?  I
have never seen this happen in the real world where I didn't also see
a kernel message like this in the logs:

kernel: sd 10:0:0:0: Warning! Received an indication that the LUN assignments on this target have changed. The Linux SCSI layer does not automatically remap LUN assignments.
 
This is a pretty clear sign that something bad has happened to the
storage. And it as always been that someone or something has
reconfigured in-use storage in a dangerous way.

> In case b), doing what my patch does is obviously the right thing. In case
> c), the right thing would be throwing slimy stinking things at the admin,
> but as we can't do that, removing and re-adding seems still more reasonable
> than pretending the path was faulty. Even in case a), removing the path
> from the current map is no worse than failing it.
> 
> What remains to be considered is what Ben was dealing with in his latest set,
> a permanent or temporary failure to retrieve the WWID, resulting in a 0-length
> WWID to be returned. IMO it's actually the best thing about this new approach
> that this doesn't need to be special-cased. The path initialization logic
> that we already have would take care of it using the INIT_MISSING_UDEV logic.
> Either the WWID would be successfully retrieved eventually, in which case the
> path would be re-added to the previous map, or (depending on configuration)
> added to a new map or left alone. Or the failure is permanent, in which case
> multipathd would eventually give up and orphan the path. AFAICS this would
> be the "right thing" to do in all these different cases, without any
> additional logic.

This is where I don't fully agree. It means that we can be stuck waiting
for a uevent to occur when the device has come back up, instead of just
restoring it.  I would really like to keep as little code as possible
that needs to get run before we restore a working path, because that
could be, for instance, the last path to your root filesystem, and you
can't touch any non-cached files on it, until you restore that path.

Even aside from the extreme case, multipathd is doing a lot of extra
work, and quite possibly adding a lot of confusing log messages, simply
because of an unfortunately timed change event.
 
> Note also that if a "reconfigure" was carried out in the presence of
> paths with changed WWID, the final outcome would likely be the same that
> my patch now achieves without "reconfigure".

Yeah. I just checked, and this is very broken, and something needs to be
done to fix it.  If a device gets a change event while it's down, it
will no longer have the udev properties necessary to not be blacklisted,
so the device gets blacklisted, and ignored.  Even after it comes back
up and gest another change event to restore these values, multipathd
still ignores it, because the device was blacklisted during its add
event.

However, if you just set the wwid of a path to NULL and run reconfigure,
it will stay added to the map, and get it's wwid restored to the
multipath device's wwid, because configure() calls map_discovery(),
which ends up calling disassemble_map(). This will set a NULL path wwid
to the multipath device wwid, since disassemble_map() assumes that NULL
wwids just mean that multipathd couldn't get the wwid temporarily.

> I case I've come to the wrong conclusions because I overlooked something
> essential, please tell me.
> 
> Going one step futher, I've actually come to think differently about the
> "fallback logic" for the case that no WWID can be obtained from udev. I
> believe now that such fallback logic should _not_ be used. The point is not
> to derive _some_ WWID, but _the right one_, and that's udev's job. But udev
> can be customized in complex ways that multipathd has no idea about.
> In the worst case, we'd receive some WWIDs from udev and some from our
> own logic, and combine paths into a map which wouldn't acutally belong
> together. Therefore I vote for ripping out the fallback logic altogether
> and depend on udev exclusively for WWID generation. I haven't included this
> in the current patch set in order not to make it too controversial.
>
> The only purpose for the fallback logic that I could see is to provide
> a configuration option to force multipathd to _always_ determine the
> WWID by itself, ignoring udev device properties.

I understand your concern.  There are currently safeguards (obviously
not foolproof ones). The fallback wwid has to match the existing wwid,
otherwise the path gets disabled. It seems very unlikely that a path
configured to use the default uid_attribute, which switched to the
fallback method and still got the same wwid, should actually have a
different udev wwid than the one it previously had and that the fallback
method still has.  Also, once a path starts using the fallback method,
it clears uid_attribute, so that it keeps using the fallback method.

But to get back to dealing with changed wwids, I agree with removing an
re-adding a device if it's wwid has changed. So, leaving that aside, the
sticky question is "what to do with a path that has a NULL wwid?"

There are a number of options:

1. Ignore the NULL wwid. This is what my patch 07 does, and I'd like to
make the case for this yet again. I feel pretty sure that a NULL wwid on
a change event is almost always going to occur because that change event
happened when the path was down. If that's not the reason, then I
believe it is either your reasons a) or c) from above. a) is not
fixable. c) is not really our problem. It's a service to try saving the
sysadmin from their own mistakes. But there is no way to make it
foolproof. It is always possible for the device to get remapped and
start getting IO before multipathd ever gets the uevent. The best we can
guarantee is that we will eventually detect when this happens, report
it, and stop it from doing more damage.  Given this, I think it's
perfectly reasonable to just let NULL wwids slide, because that's
ususally the right thing to do, and everything else makes the common
case work worse, while still not providing a guarantee that the worst
case is avoided. This is still my preferred solution.

2. Fail the path on a NULL wwid. In the checker loop, when the path is
up again, re-attempt to get the wwid.  However, since the udev
information we have won't contain the new wwid, use the fallback
information. This is my patch 12, and I agree that there could be issues
with the fallback wwid being determined differently, although like I
mentioned above, multipathd tries to deal with them.

3. Fail the path on a NULL wwid. In the checker loop, when the path is
up again, trigger a change uevent to get the new information. This
delays restoring a path once it's up, and increases the number of things
outside of multipathd's control that could go wrong which would keep the
path from getting restored (udev timeouts, inability for udev to
complete, because access to a necessary device is down).

4. Some sort of hybrid of 2 and 3, where devices can either get their
wwid from udev or directly from the device, and depending on how they
get their wwid, by necessity they do different things. This is workable
but a lot of code for something that is just a best-effort attempt to
protect sysadmins from themselves.

4. Completely remove the path, and try to re-add it.  This method will
likely cause at least as much delay as 3, with an even larger chance
that something goes wrong and keeps access from being restored. That's
completely fine if the wwid has changed to something else, but I really
don't like having to do all that work just because a change event
occurred on a device that was down.

Thoughts?

-Ben
 
> Regards
> Martin
> 
> Martin Wilck (3):
>   multipathd: handle changed wwids by removal and addition
>   multipathd: remove "wwid_changed" path attribute
>   multipathd: ignore "disable_changed_wwids"
> 
>  libmultipath/config.c      |  1 -
>  libmultipath/config.h      |  1 -
>  libmultipath/dict.c        | 18 +++++++--
>  libmultipath/structs.h     |  1 -
>  multipath/multipath.conf.5 |  8 +---
>  multipathd/main.c          | 77 +++++++++++++++++++-------------------
>  6 files changed, 55 insertions(+), 51 deletions(-)
> 
> -- 
> 2.21.0
