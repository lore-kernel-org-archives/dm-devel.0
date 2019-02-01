From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Thu, 31 Jan 2019 23:35:27 -0800
Message-ID: <20190201073527.GA14758@infradead.org>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
	<20190128221441.GA24102@redhat.com> <yq1lg34f4i7.fsf@oracle.com>
	<CAMeeMh85T_qui=LWd0u=b_oMN5XLqowqkvLuYGBM2Ae6tS-mzg@mail.gmail.com>
	<20190131103924.GA22503@infradead.org>
	<CAMeeMh-uxiee7rKutnr3jrMjzkc8=R2Y3DPPBLvLYjqSwjfi_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAMeeMh-uxiee7rKutnr3jrMjzkc8=R2Y3DPPBLvLYjqSwjfi_w@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Dorminy <jdorminy@redhat.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 31, 2019 at 02:41:52PM -0500, John Dorminy wrote:
> > On Wed, Jan 30, 2019 at 09:08:50AM -0500, John Dorminy wrote:
> > > (I use WRITE_SAME to fill devices with a particular pattern in order
> > > to catch failures to initialize disk structures appropriately,
> > > personally, but it's just for convenience/speed.)
> >
> > How do you use it?  We don't have a user interface to generate
> > REQ_OP_WRITE_SAME requests.
> 
> A not-checked-in test module, similar to Zhang Xiaoxu's reproducer,
> exposing a sysfs node to trigger filling a block device with a test
> pattern.

Any reason you don't just use SCSI/NVMe passthrough directly from
userspace for that?
