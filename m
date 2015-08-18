From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Mon, 17 Aug 2015 22:09:07 -0700
Message-ID: <CAF1ivSZFCVRDQf-N0JOBweX4se3iZZJzUCR_Uqdq1AV3Vd+Srg@mail.gmail.com>
References: <CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
	<20150731213831.GA16464@redhat.com>
	<1438412290.26596.14.camel@hasee>
	<20150801163356.GA21478@redhat.com>
	<yq18u9liwhj.fsf@sermon.lab.mkp.net>
	<1439099990.7880.0.camel@hasee>
	<20150809064128.GB2436@infradead.org>
	<1439103347.7880.3.camel@hasee>
	<20150809070128.GA25739@infradead.org>
	<1439104707.7880.8.camel@hasee> <20150810150216.GA22719@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150810150216.GA22719@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

On Mon, Aug 10, 2015 at 8:02 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> p.s. I'll be working with Joe Thornber on optimizing DM (particularly
> dm-thinp and dm-cache) once this patchset is included upstream.  You'll
> see I've already added a couple WIP dm-thinp patches ontop.

Hi Mike,

Just to avoid duplicated work.
Are you going to work on the dm-thinp/dm-cache discard rewritten?

Otherwise, I can work on it.

Thanks,
Ming
