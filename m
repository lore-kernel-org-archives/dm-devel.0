From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [LSF/MM TOPIC] Re: [dm-devel] Announcement: STEC EnhanceIO SSD
 caching software for Linux kernel
Date: Mon, 4 Feb 2013 12:33:26 -0800
Message-ID: <20130204203326.GA21532@google.com>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
 <50F970A3.4000403@warr.net>
 <20130118161135.GA3118@raspberrypi>
 <50F97C0F.9010405@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7345@MYMBX.MY.STEC-INC.AD>
 <50F9963A.2080608@warr.net>
 <20130118212543.GB6425@blackbox.djwong.org>
 <20130118213759.GA30278@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130118213759.GA30278@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, device-mapper development <dm-devel@redhat.com>, Amit Kale <akale@stec-inc.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, LKML <linux-kernel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 18, 2013 at 04:37:59PM -0500, Mike Snitzer wrote:
> On Fri, Jan 18 2013 at  4:25pm -0500,
> Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > Since Joe is putting together a testing tree to compare the three caching
> > things, what do you all think of having a(nother) session about ssd caching at
> > this year's LSFMM Summit?
> > 
> > [Apologies for hijacking the thread.]
> > [Adding lsf-pc to the cc list.]
> 
> Hopefully we'll have some findings on the comparisons well before LSF
> (since we currently have some momentum).  But yes it may be worthwhile
> to discuss things further and/or report findings.

I'd be willing to go and talk a bit about bcache. Curious to hear more
about the dm caching stuff, too.
