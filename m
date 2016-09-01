From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Thu, 1 Sep 2016 18:26:55 -0400
Message-ID: <20160901222654.GA13292@redhat.com>
References: <e8cf7d03-82a6-cba3-60c4-c436ae3a24f7@sandisk.com>
	<20160901190505.GA12106@redhat.com>
	<235c0ca3-0c01-6dc8-208e-1a4c153dd69c@sandisk.com>
	<20160901203332.GB12407@redhat.com>
	<889bdb89-a16b-927a-adf0-fa04418a0c06@sandisk.com>
	<20160901204806.GA12742@redhat.com>
	<66e36ae7-19ff-058f-049a-3e91a62b19b3@sandisk.com>
	<20160901211718.GA12894@redhat.com>
	<20160901221823.GA13209@redhat.com>
	<f276cf3d-cad3-3e61-2903-754970f90445@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f276cf3d-cad3-3e61-2903-754970f90445@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Sep 01 2016 at  6:22pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 09/01/2016 03:18 PM, Mike Snitzer wrote:
> >FYI I get the same 'dmsetup suspend --nolockfs --noflush mp' hang,
> >running mptest's test_02_sdev_delete, when I try your unmodified
> >patchset, see:
> >
> >http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel.bart
> 
> Hello Mike,
> 
> Are you aware that the code on that branch is a *modified* version
> of my patch series? The following patch is not present on that
> branch: "dm path selector: Avoid that device removal triggers an
> infinite loop". There are also other (smaller) differences.

No, you're obviously talking about the 'devel' branch and not the
'devel.bart' branch I pointed to.  The 'devel.bart' branch is the
_exact_ patchset you sent.  It has the same problem as the 'devel'
branch.
