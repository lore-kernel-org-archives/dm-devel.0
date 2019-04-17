From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] dm-crypt: fix endianess annotations around
 org_sector_of_dmreq
Date: Wed, 17 Apr 2019 06:28:08 -0700
Message-ID: <5f7ecb42-a89c-40da-a8f2-b2f416520bef@acm.org>
References: <20190404163334.4453-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190404163334.4453-1-hch@lst.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 4/4/19 9:33 AM, Christoph Hellwig wrote:
> The sector used here is a little endian value, so use the right
> type for it.

Hi Christoph,

You may want to fix the spelling of "endianness" in the subject. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
