From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RFCv2 01/10] dm-dedup: main data structures
Date: Wed, 26 Nov 2014 10:38:34 -0500
Message-ID: <20141126153834.GD30136@redhat.com>
References: <53ffb64d.c58d320a.14c8.1413@mx.google.com>
	<20140926152416.GA4464@redhat.com>
	<CAFTzLMP07qBzEBaaOuFQvi0W219YqLpz8epWdMLO36Sj8gBJoQ@mail.gmail.com>
	<CAFTzLMNJ7=zc-qTcLY_BLQPRD4hiJYUAvs_AHgTgxsfg3Bb49Q@mail.gmail.com>
	<20141017174251.GA25948@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141017174251.GA25948@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vasily Tarasov <tarasov@vasily.name>
Cc: Joe Thornber <thornber@redhat.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 17 2014 at  1:42pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Oct 17 2014 at  1:11pm -0400,
> Vasily Tarasov <tarasov@vasily.name> wrote:
> 
> > Hi Mike,
> > 
> > Sonam Mandal, who also works on dm-dedup project, has addressed your
> > comments about BUG() and BUG_ON(). She has also updated the code
> > related to mark and sweep. The changes are staged here (on top of your
> > dm-dedup repo):
> > 
> > git://git.fsl.cs.stonybrook.edu/scm/git/linux-dmdedup
> > branch: dm-dedup-devel
> > 
> > I'm not sure if you want us to send the patches to device-mapper
> > mailing list in addition to that. Let us know if we should do it.
> 
> I'll take a look next week, I need to finish up some dm-thinp work this
> week.  Your repo is perfect for now.
> 
> Thanks for doing this work.
> Mike

Hi Vasily,

I've been slammed with working on DM thinp and DM cache.  High priority
issues got elevated and we're only now putting those issues to rest.

So that said, I'll have time to focus on dm-dedup review starting next
week.  BUT this time it is different in that I'll be working closely
with Vivek Goyal (cc'd).  Vivek just joined Red hat's kernel storage
team and will be able to help with this review.  I'm asking Vivek to
focus on the meat of the dedup strategy you've deployed (algorithms,
etc).

I'll be maintain focus on the DM target mechanics (which should be in
good shape coming off the first cycle of review).

Apologies for DM dedup's review/inclusion slipping to the degree it
has.  I could've been much better about communicating my status.

Hopefully we can have DM dedup buttoned up and staged for upstream
inclusion in time for Christmas ;)

Mike
