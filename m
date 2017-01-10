From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 2/3] dm: Add support to poll for dm events
Date: Mon, 9 Jan 2017 18:10:42 -0800
Message-ID: <a0dc1add-9260-d3ff-6579-82b49a32a69b@redhat.com>
References: <20170109182040.31337-1-agrover@redhat.com>
	<20170109182040.31337-3-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170109182040.31337-3-agrover@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Please see below for some bugs I spotted.

The surest way to find bugs is to post patches to a public list :-/

On 01/09/2017 10:20 AM, Andy Grover wrote:
> +int dm_release(struct inode *inode, struct file *filp)

> +	if (priv->md) {

should be "if (priv && priv->md)"

> +static unsigned int dm_poll(struct file *filp, poll_table *wait)

> +	if (!priv->md)

should be "if (!priv || !priv->md)"

Regards -- Andy
