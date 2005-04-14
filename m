From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: kcopyd_client_create. allocate memory fail
Date: Wed, 13 Apr 2005 22:42:39 -0400
Message-ID: <1113446559.5396.22.camel@localhost.localdomain>
References: <1113403277.6045.50.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1113403277.6045.50.camel@localhost.localdomain>
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

Turn on the kernel hack option and i found this.

every time a snapshot created, it will create and hold a kcopyd_client.
so will call kcopyd_client_create() --> dm_io_get() --> resize_pool() --
> mempool_resize() which has this "new_elements = kmalloc(new_min_nr *
sizeof(*new_elements), gfp_mask);".

_num_ios is a static variable and will keep increasing by pages_to_ios
(num_pages) here. 

so eventually the new_min_nr * sizeof(*new_elements) will be larger than
what is allowed in kmalloc and thus get failed.

so i think we can not use mempool here, or we have to have several
pools.

ming


On Wed, 2005-04-13 at 10:41 -0400, Ming Zhang wrote:
> Hi folks
> 
> I knew this is reported before but seems no much discussion on it.
> 
> I met a failure when creating 18th snapshot on my volume. the error is
> in kcopyd_client_create(), seems alloc_page fails. i know there is 1MB
> ram for each dm snapshot, but this is only 18th snapshot, so around
> 18MB, not a big number on my 392MB ram box. i check free and there are
> still ~200MB available.
> 
> it is a fedora core 2 box with 2.6.8 kernel and lvm2. but i donot think
> this is a fc specific problem.
> 
> thanks.
> 
> Ming
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
