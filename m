From: Josef Bacik <josef@redhat.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Tue, 8 Mar 2011 13:37:10 -0500
Message-ID: <20110308183709.GC2527@localhost.localdomain>
References: <4D766199.4010307@gmail.com> <20110308174308.GP10767@agk-dp.fab.redhat.com> <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Wendy Cheng <s.wendy.cheng@gmail.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Jim Meyering <jim@meyering.net>, Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 08, 2011 at 10:05:40AM -0800, Wendy Cheng wrote:
> > On Tue, Mar 08, 2011 at 12:04:25PM -0500, Ric Wheeler wrote:
> >> To make this trivial to do for users, I think that it would be really
> >> nice to have a two-level wrappers for things like resize, add a volume,
> >> shrink, etc. Similar to the way we have mount or fsck invoke file system
> >> specific bits.
> >> Good idea? Bad idea?
> >
> 
> So the "resize" is on the filesystem, not the volume ? The "grow" part
> is probably easy. Unfortunately, the "shrink" may not be easy for some
> of the filesystems:
>

Who wants to make their fs smaller anyway?  ;)

Josef 
