From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 00/10] dm: zoned block device support
Date: Wed, 17 May 2017 14:54:34 -0400
Message-ID: <20170517185434.GC21862@redhat.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
	<20170516200356.GA17063@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170516200356.GA17063@redhat.com>
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
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Tue, May 16 2017 at  4:03pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> I see quite a few issues with this patchset (only gotten through patches
> 1 - 6).  I'll work through it in more detail and share my
> feedback/revisions tomorrow.  Mostly just cleanups, renames, etc.  But
> "the fun" is obviously once I get to the last patch.

FYI, couldn't get to this like I planned.  And I'm taking some time off,
won't get back to this until next Tuesday (5/23).  To be clear, the
things I noticed in the preliminary patches were very benign, but do
need cleaning up.

I have every intention of getting this reviewed and staged for 4.13.

But would be useful to understand:
1) who will be regression testing this target once it is merged?
2) what is needed to test it? (I assume SMR drives?)

Mike
