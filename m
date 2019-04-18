From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: fix endianess annotations around
	org_sector_of_dmreq
Date: Thu, 18 Apr 2019 15:57:51 -0400
Message-ID: <20190418195751.GA2810@redhat.com>
References: <20190404163334.4453-1-hch@lst.de>
	<5f7ecb42-a89c-40da-a8f2-b2f416520bef@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5f7ecb42-a89c-40da-a8f2-b2f416520bef@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Wed, Apr 17 2019 at  9:28am -0400,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 4/4/19 9:33 AM, Christoph Hellwig wrote:
> > The sector used here is a little endian value, so use the right
> > type for it.
> 
> Hi Christoph,
> 
> You may want to fix the spelling of "endianness" in the subject. Anyway:

I fixed the subject's typo and staged this for 5.2, thanks.

Mike
