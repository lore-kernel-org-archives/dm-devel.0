From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: Getting mapped device namw
Date: Mon, 06 Jul 2015 12:32:33 +0300
Message-ID: <559A4B31.9000509@kyup.com>
References: <DUB115-W139FD64ED5BB7A83E674F2696930@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DUB115-W139FD64ED5BB7A83E674F2696930@phx.gbl>
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


On 07/06/2015 12:20 PM, Gili B wrote:
> hi
> when a user run :
> dmsetup create [device name] ....
> Can a device mapper target find out the device name that the user entered ?

Apparently the name is being associated with a hash_cell object, which
in turn is associated with struct mapped_device in dm_hash_insert
(called from dev_create, which is invoked as part of the create IOCTL).
So presumably if you get an instance of struct mapped_device and then
invoke dm_get_mdptr(md). What you'd get is a pointer to struct hash_cell

> I need it for creating entries in proc for example.
>  
> Thanks
> -gili
>  		 	   		  
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
