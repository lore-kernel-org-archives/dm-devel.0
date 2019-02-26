From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 7/9] multipathd: ignore failed wwid recheck
Date: Tue, 26 Feb 2019 14:29:30 -0600
Message-ID: <20190226202930.GL3023@octiron.msp.redhat.com>
References: <1550854692-19873-1-git-send-email-bmarzins@redhat.com>
	<1550854692-19873-8-git-send-email-bmarzins@redhat.com>
	<5f7bbbbb0bf8879380b000f9f24849b885ffa136.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5f7bbbbb0bf8879380b000f9f24849b885ffa136.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 26, 2019 at 10:42:49AM +0100, Martin Wilck wrote:
> On Fri, 2019-02-22 at 10:58 -0600, Benjamin Marzinski wrote:
> > If disable_changed_wwids is set, when multipathd gets a change event
> > on
> > a path, it verifies that the wwid hasn't changed in
> > uev_update_path().
> > If get_uid() failed, uev_update_path treated this as a wwid change to
> > 0.
> > This could cause paths to suddenly be dropped due to an issue with
> > getting the wwid.  Even if get_uid() failed because the path was
> > down,
> > it no change uevent happend when it later became active, multipathd
> > would continue to ignore the path.
> > 
> > Instead, multipathd should neither set nor clear wwid_changed if
> > get_uid() returned failure.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/main.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Hm. Failure of get_uid() is a rather severe problem. With this change,
> if get_uid() fails, pp->wwid won't be reset to the original value, and
> dm_fail_path() won't be called. So the path will continue to be
> considered "good", but it will have a zero WWID from this point on. Or
> am I overlooking someting?

Nope. This patch is buggy. Well, actually, check_path() will call
update_multipath_strings() which will eventually call disassemble_map(),
which will reset the path's WWID to match the multipath device wwid
(since it's empty), which is why I didn't notice the issue right away.

This could easily be solved by simply resetting the WWID when get_uid
fails.  But there are bigger issues with the patch. Sometimes get_uid()
doesn't return failure, it just returns 0 and an empty wwid. This still
allows the issue I am seeing to occur.

The problem I'm seeing is that sometimes (like when firmware gets
updated on a controller) multipath is temporarily unable to get the
wwid. If a change event happens during this period, get_uid() will set
the wwid to "", possibly without returning an error.  After that,
multipathd will treat the path as if it was down, until a change event
occurs and multipath can successfully get the wwid.
 
> Maybe we should rather change the treatment of this case in
> check_path(). In uev_update_path(), we could leave the WWID at 0 and
> fail the path. Then in check_path(), when the path is up to be checked
> next time, we'd detect the strlen(pp->wwid) == 0 case (indicating
> previously failed get_uid()) and try to call get_uid() again to see if
> this was just a temporary WWID lookup failure or if the WWID actually
> changed (IOW: pp->wwid differs from pp->mpp->wwid). Would this make
> sense?

Sure. I'll try something along those lines (although I'll probably keep
the old wwid, and just set a flag, so the I don't have to make sure that
all of the code that deals with paths with blank wwids does the correct
thing in this case).

-Ben
 
> Martin
> 
> 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 678ecf8..81ad6c0 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1234,9 +1234,9 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  			goto out;
> >  
> >  		strcpy(wwid, pp->wwid);
> > -		get_uid(pp, pp->state, uev->udev);
> > +		rc = get_uid(pp, pp->state, uev->udev);
> >  
> > -		if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
> > +		if (rc == 0 && strncmp(wwid, pp->wwid, WWID_SIZE) != 0)
> > {
> >  			condlog(0, "%s: path wwid changed from '%s' to
> > '%s'. %s",
> >  				uev->kernel, wwid, pp->wwid,
> >  				(disable_changed_wwids ? "disallowing"
> > :
> > @@ -1252,7 +1252,8 @@ uev_update_path (struct uevent *uev, struct
> > vectors * vecs)
> >  				goto out;
> >  			}
> >  		} else {
> > -			pp->wwid_changed = 0;
> > +			if (rc == 0)
> > +				pp->wwid_changed = 0;
> >  			udev_device_unref(pp->udev);
> >  			pp->udev = udev_device_ref(uev->udev);
> >  			conf = get_multipath_config();
> 
