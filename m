From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: [PATCH] kpartx: Improve finding loopback device by
 file
Date: Tue, 6 Feb 2018 12:19:43 +0100
Message-ID: <20180206111943.zy534jgeqaveveic@jak-x230>
References: <20180205085831.23923-1-julian.klode@canonical.com>
	<1517826733.14196.3.camel@suse.com>
	<20180205104500.n5rrw6nqzamwijvl@jak-x230>
	<1517838787.14196.10.camel@suse.com>
	<20180205144121.27ruwyewpkm3a4kd@jak-x230>
	<1517843520.14196.45.camel@suse.com>
	<20180205154622.axv3cv5wxot3hmbx@jak-x230>
	<1517850433.14196.63.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1517850433.14196.63.camel@suse.com>
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

On Mon, Feb 05, 2018 at 06:07:13PM +0100, Martin Wilck wrote:
> On Mon, 2018-02-05 at 16:46 +0100, Julian Andres Klode wrote:
> > On Mon, Feb 05, 2018 at 04:12:00PM +0100, Martin Wilck wrote:
> > > 
> > > Can we agree on the following:
> > > 
> > >  1 if realpath (filename) results in error, abort
> > 
> > OK
> > 
> > 
> > >  2 if realpath(lo_name) results in ENODEV and filename matches
> > > lo_name,
> > > remove loop device
> > >  3 if realpath(lo_name) results in another error code, skip it
> > >  4 remove if realpath(filename) matches realpath(lo_name)
> > 
> > 
> > This seems like a lot of ifs. It might be easier to just path if
> > realpath(path) fails (as realpath(1) does), something like:
> > 
> > 		
> > 		char *loopname = loopinfo.lo_name;
> > 		if (realpath(loopinfo.lo_name, rloopfilename) != NULL)
> > 			loopname = rloopfilename;
> > 
> > 		if (0 == strcmp(filename, loopinfo.lo_name) ||my
> 		    0 == strcmp(rfilename, loopname))) {
> > 			found = realpath(path, NULL);
> > 			break;
> > 		}
> > 
> > 
> > That should solve all problems and produce useful results with not
> > a lot of logic.
> 
> I've reproduced your issue. I can see that the current behavior is
> wrong. 
> 
> This may be paranoid, but I really want to avoid false positives -
> kpartx removing mappings it isn't supposed to remove. Therefore I'd
> like to avoid compare by "filename" and "loopname". I think it's
> possible.
> 
> IMO it would be better to have kpartx use the realpath while *creating*
> the partition mapping already:
> 
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -341,7 +341,7 @@ main(int argc, char **argv){
>                 if (!loopdev) {
>                         loopdev = find_unused_loop_device();
>  
> -                       if (set_loop(loopdev, device, 0, &ro)) {
> +                       if (set_loop(loopdev, rpath, 0, &ro)) {
>                                 fprintf(stderr, "can't set up loop\n");
>                                 exit (1);
>                         }
> 
> 
> That would make sure that kpartx can delete loop devices created by
> itself, which is what we want. IMO it's sufficient to solve your issue.

I was about to suggest that, but did not do it, as it's kind of weird. You
add /a/b/c.img (pointing to /x/y/z.img) and losetup then shows you /x/y/z.img
- I fear this might break some stuff that checks whether the binding was
actually created (or checks which loop device it was created at).
-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
