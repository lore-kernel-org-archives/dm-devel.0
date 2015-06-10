From: anup modak <amodak2014@gmail.com>
Subject: Re: block: add a bi_error field to struct bio
Date: Wed, 10 Jun 2015 13:29:43 -0500
Message-ID: <CAEcdTAH2fU_WJWeev0DcsGKUA0M27u=i27eaezchFDxpVpzuag@mail.gmail.com>
References: <1433338959-24808-1-git-send-email-hch@lst.de>
	<1433338959-24808-2-git-send-email-hch@lst.de>
	<20150604153106.GA31567@redhat.com>
	<20150610081138.GA3841@lst.de>
	<20150610152649.GA31140@redhat.com>
	<20150610160112.GB31140@redhat.com>
	<20150610160443.GA14268@lst.de>
	<20150610165023.GA31918@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150610165023.GA31918@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

So Is it safe to use raid 6 with btrfs for home storage now? I will
have backup on ZFS.

On Wed, Jun 10, 2015 at 11:50 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Jun 10 2015 at 12:04pm -0400,
> Christoph Hellwig <hch@lst.de> wrote:
>
>> On Wed, Jun 10, 2015 at 12:01:12PM -0400, Mike Snitzer wrote:
>> > > I'll queue a patch to rename 'error' to 'error_bits' where appropriate.
>> >
>> > See: https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=f368f463e4cef696ad6b102dbaf5c10dfca7cc63
>>
>> Can we wait with this until we're done with bi_error?
>
> Sure, I've moved it out to dm-4.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
