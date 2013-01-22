From: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: RE: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Date: Tue, 22 Jan 2013 13:00:35 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D5DFC@MYMBX.MY.STEC-INC.AD>
References: <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net> <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
 <50F9963A.2080608@warr.net> <20130118212543.GB6425@blackbox.djwong.org>
 <20130118213759.GA30278@redhat.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D5D4D@MYMBX.MY.STEC-INC.AD>
 <20130121130951.GA16574@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130121130951.GA16574-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Joe Thornber <ejt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, January 21, 2013 6:40 PM
> To: Amit Kale
> Cc: Darrick J. Wong; device-mapper development; linux-
> bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; LKML; lsf-
> pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org; Joe Thornber
> Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO
> SSD caching software for Linux kernel
> 
> On Mon, Jan 21 2013 at 12:26am -0500,
> Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org> wrote:
> 
> > > -----Original Message-----
> > > From: Mike Snitzer [mailto:snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > > Sent: Saturday, January 19, 2013 3:08 AM
> > > To: Darrick J. Wong
> > > Cc: device-mapper development; Amit Kale;
> > > linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; LKML;
> > > lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org; Joe Thornber
> > > Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC
> > > EnhanceIO SSD caching software for Linux kernel
> > >
> > > On Fri, Jan 18 2013 at  4:25pm -0500, Darrick J. Wong
> > > <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > > Since Joe is putting together a testing tree to compare the three
> > > > caching things, what do you all think of having a(nother) session
> > > > about ssd caching at this year's LSFMM Summit?
> > > >
> > > > [Apologies for hijacking the thread.] [Adding lsf-pc to the cc
> > > > list.]
> > >
> > > Hopefully we'll have some findings on the comparisons well before
> > > LSF (since we currently have some momentum).  But yes it may be
> > > worthwhile to discuss things further and/or report findings.
> >
> > We should have performance comparisons presented well before the
> > summit. It'll be good to have ssd caching session in any case. The
> > likelihood that one of them will be included in Linux kernel before
> > April is very low.
> 
> dm-cache is under active review for upstream inclusion.  I wouldn't
> categorize the chances of dm-cache going upstream when the v3.9 merge
> window opens as "very low".  But even if dm-cache does go upstream it
> doesn't preclude bcache and/or enhanceio from going upstream too.

I agree. We haven't seen a full comparison yet, IMHO. If different solutions offer mutually exclusive benefits, it'll be worthwhile including them all.

We haven't submitted EnhanceIO for an inclusion yet. Need more testing from the community before we can mark it Beta.
-Amit

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
