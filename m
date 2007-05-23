From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [2.6.22-rc1-mm1 PATCH 9/10]
	dm-raid1-handle-read-failures.patch
Date: Wed, 23 May 2007 12:02:06 -0500
Message-ID: <8DBC12F7-FD78-4F13-9176-AE1738259F99@redhat.com>
References: <1179785339.13913.37.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1179785339.13913.37.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


On May 21, 2007, at 5:08 PM, Jonathan Brassow wrote:

> +/* Asynchronous read. */
> +static void read_async_bio(struct mirror *m, struct bio *bio)
> +{
> +	struct io_region io;
> +	struct dm_io_request io_req = {
> +		.bi_rw = READ,
> +		.mem.type = DM_IO_BVEC,
> +		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
> +		.notify.fn = read_callback,
> +		.notify.context = bio,
> +		.client = m->ms->io_client,
> +	};
> +
> +	map_region(&io, m, bio);
> +	bio_set_m(bio, m);
> +	(void) dm_io(&io_req, m->ms->nr_mirrors, &io, NULL);
>  }
>

The call to dm_io is wrong here, it should be:
(void) dm_io(&io_req, 1, &io, NULL);

Will send substitute patch shortly,
  brassow
