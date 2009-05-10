From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1 of 1]  Updated cluster log patch (take 2)
Date: Sun, 10 May 2009 20:04:45 +0400
Message-ID: <20090510160444.GA19360@2ka.mipt.ru>
References: <1241725528.9774.7.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1241725528.9774.7.camel@hydrogen.msp.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Jonathan.

On Thu, May 07, 2009 at 02:45:28PM -0500, Jonathan Brassow (jbrassow@redhat.com) wrote:
> Evgeniy, I'm copying you on this post because I am making use of your
> 'connector' interface.
> 
> agk, I've replied to your concerns in the previous thread about this
> patch.  This mail contains the updated patch.

I have some trivial issue below, otherwise it looks good, thank you.

> +static int fill_pkg(struct cn_msg *msg, struct dm_clog_request *tfr)
> +{
> +	uint32_t rtn_seq = (msg) ? msg->seq : (tfr) ? tfr->seq : 0;
> +	struct receiving_pkg *pkg;
> +
> +	list_for_each_entry(pkg, &receiving_list, list) {

Here we process a list of statically allocated structures, and while for
the kernel space it should be ok, but please write a huge comment which
will explain that it relies on the kernel stack nature about unified
addressing between processes.

> +		if (rtn_seq != pkg->seq)
> +			continue;
> +
> +		if (msg) {
> +			pkg->error = -msg->ack;
> +			/*
> +			 * If we are trying again, we will need to know our
> +			 * storage capacity.  Otherwise, along with the
> +			 * error code, we make explicit that we have no data.
> +			 */
> +			if (pkg->error != -EAGAIN)
> +				*(pkg->data_size) = 0;
> +		} else if (tfr->data_size > *(pkg->data_size)) {
> +			DMERR("Insufficient space to receive package [%u]::",
> +			      tfr->request_type);
> +			DMERR("  tfr->data_size    = %u", tfr->data_size);
> +			DMERR("  *(pkg->data_size) = %lu", *(pkg->data_size));
> +
> +			*(pkg->data_size) = 0;
> +			pkg->error = -ENOSPC;
> +		} else {
> +			pkg->error = tfr->error;
> +			memcpy(pkg->data, tfr->data, tfr->data_size);
> +			*(pkg->data_size) = tfr->data_size;
> +		}
> +		complete(&pkg->complete);
> +		return 0;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +/*
> + * cn_clog_callback
> + * @data
> + *

Please also drop this kind of comment prefix, it does not really tells
anything about function, but below part does (as well as next function's
kerneldoc one).

> + * This is the connector callback that delivers data
> + * that was sent from userspace.
> + */
> +static void cn_clog_callback(void *data)
> +{
> +	struct cn_msg *msg = (struct cn_msg *)data;
> +	struct dm_clog_request *tfr = (struct dm_clog_request *)(msg + 1);
> +
> +	spin_lock(&receiving_list_lock);
> +	if (msg->len == 0)
> +		fill_pkg(msg, NULL);
> +	else if (msg->len < sizeof(*tfr))
> +		DMERR("Incomplete message received: [%u]", msg->seq);
> +	else
> +		fill_pkg(NULL, tfr);
> +	spin_unlock(&receiving_list_lock);
> +}
> +
> +/*
> + * dm_clog_consult_server
> + * @uuid: log's uuid (must be DM_UUID_LEN in size)
> + * @request_type:
> + * @data: data to tx to the server
> + * @data_size: size of data in bytes
> + * @rdata: place to put return data from server
> + * @rdata_size: value-result (amount of space given/amount of space used)
> + *
> + * Only one process at a time can communicate with the server.
> + * rdata_size is undefined on failure.
> + *
> + * Returns: 0 on success, -EXXX on failure
> + */

-- 
	Evgeniy Polyakov
