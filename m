From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Tue, 18 Aug 2015 10:45:05 -0400
Message-ID: <20150818144505.GA15832@redhat.com>
References: <20150801163356.GA21478@redhat.com>
	<yq18u9liwhj.fsf@sermon.lab.mkp.net>
	<1439099990.7880.0.camel@hasee>
	<20150809064128.GB2436@infradead.org>
	<1439103347.7880.3.camel@hasee>
	<20150809070128.GA25739@infradead.org>
	<1439104707.7880.8.camel@hasee> <20150810150216.GA22719@redhat.com>
	<CAF1ivSZFCVRDQf-N0JOBweX4se3iZZJzUCR_Uqdq1AV3Vd+Srg@mail.gmail.com>
	<CAF1ivSaAX8sHFyaW69da8arm4fpLD-T656GgV3-KYQxt0H_DYg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAF1ivSaAX8sHFyaW69da8arm4fpLD-T656GgV3-KYQxt0H_DYg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lin <mlin@kernel.org>
Cc: Joe Thornber <ejt@redhat.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

On Tue, Aug 18 2015 at  3:04am -0400,
Ming Lin <mlin@kernel.org> wrote:

> On Mon, Aug 17, 2015 at 10:09 PM, Ming Lin <mlin@kernel.org> wrote:
> > On Mon, Aug 10, 2015 at 8:02 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> >> p.s. I'll be working with Joe Thornber on optimizing DM (particularly
> >> dm-thinp and dm-cache) once this patchset is included upstream.  You'll
> >> see I've already added a couple WIP dm-thinp patches ontop.
> >
> > Hi Mike,
> >
> > Just to avoid duplicated work.
> > Are you going to work on the dm-thinp/dm-cache discard rewritten?
> 
> Seems dm-stripe discard also needs rewrite.

Can you elaborate on what you feel needs re-writing in these targets?

This is the basic initial cleanup I had in mind for dm-thinp:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=dm-4.4&id=cb0aca0a6bfad6b7f7146dde776f374082a73db6

A much more involved refactoring of the dm-cache and dm-thinp targets to
eliminate the need for splitting will involve bio-prison range locking
and a new metadata format for both targets to express ranges as opposed
to blocks.  This line of work is on Joe's radar but it is much further
out given the associated on-disk metadata format change.

That aside, I do need to look at DM core to see how we can do things
differently so that block core's bio_split() et al is doing the
splitting rather than DM core having a role.

I'd prefer to be the one working these DM changes.  But if you have
ideas of how things should be cleaned up I'd be happy to consider them.

Thanks,
Mike
