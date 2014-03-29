From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 9/9] dm crypt: sort writes
Date: Sat, 29 Mar 2014 09:11:47 +0100
Message-ID: <53368043.5000808@gmail.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-10-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1396037476-26595-10-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/28/2014 09:11 PM, Mike Snitzer wrote:
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Write requests are sorted in a red-black tree structure and are submitted
> in the sorted order.
> 
> In theory the sorting should be performed by the underlying disk scheduler,
> however, in practice the disk scheduler accepts and sorts only 128 requests.
> In order to sort more requests, we need to implement our own sorting.

Hi,

I think it would be nice to mention why simply increasing queue nr_request
doesn't help. It is definitely not limited to 128, it is only default value.

(I just wonder how this helps for SSDs where I think it depends what's fw
doing with io requests anyway).

It would be nice to have sysfs switch to disable sorting in dmcrypt but that
can be added later.

Anyway, thanks for rebasing these patches!

...
> +#define io_node rb_entry(parent, struct dm_crypt_io, rb_node)
> +		if (sector < io_node->sector)
> +			p = &io_node->rb_node.rb_left;
> +		else
> +			p = &io_node->rb_node.rb_right;
> +#undef io_node

Btw, could this be switched to inline function instead of define,
or it is only me who thinks #define here is ugly? :)

Thanks,
Milan
