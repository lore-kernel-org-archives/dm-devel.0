From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Updated cluster log patch (take 3)
Date: Tue, 12 May 2009 13:28:19 +0100
Message-ID: <20090512122819.GB3966@agk-dp.fab.redhat.com>
References: <1242075783.32352.4.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1242075783.32352.4.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 11, 2009 at 04:03:03PM -0500, Jon Brassow wrote:
> +	select CONNECTOR

Mention this below?

> +	---help---
> +	  The cluster logging module provides a mechanism for
> +	  keeping log state coherent amoung a cluster of machines.

Define cluster!  i.e. shared storage

> +	  Device-mapper mirroring (RAID1) can leverage this log type
> +	  to make mirrors that are cluster-aware.


> + * (DM_CLOG_REQUEST_MASK & request_type) to get the request type

Provide a macro and use it?

> + * We are reserving 8 bits of the 32-bit 'request_type' field for the
> + * various request types above.  The remaining 24-bits can be
> + * reserved for future use and compatibility concerns.

Oughtn't we to require that the remaining bits are set to zero rather
than leaving them undefined so they could be used as compatibility flags in
future?

> +#define SHORT_UUID(x) (strlen(x) > 8) ? ((x) + (strlen(x) - 8)) : (x)
> +static uint32_t seq;

Please use DM_ or dm_ prefixes on most constants, statics, structs, macros etc.
outside the body of functions.
And perhaps change seq to avoid confusion with its normal usage (seq_file -
see raid5.c for example).

> +static DEFINE_MUTEX(_lock);

Another name that is too generic - what sort of lock?  What does the underscore
signify?

Also, since this is processing data to/from userspace, can you provide a
brief security overview?  What limits are there on the data that
userspace can supply?  E.g. only root can send data because...  its
maximum length is N because, or its length is unbounded but this is OK
because...  it is validated in functions X and Y which guarantee
addressability & values only within ranges that can be procesed... data
sent to userspace is guaranteed not to leak uninitialised or unintended
memory contents because... etc.

I'm also seeking documentation of the protocol used:
- Generic info about its format (requests/responses/error-handling etc.)
- Specific info in the .h file next to each of the request types.
(Look at dm-ioctl.h for an example of the minimum level of detail I'm
asking is documented.)

> +		size = sizeof(struct cn_msg) +

size_t ?

Alasdair
