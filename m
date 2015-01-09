From: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
Subject: Re: Device mapper target driver for Write tracking or
 Write split
Date: Fri, 9 Jan 2015 06:51:28 -0800 (PST)
Message-ID: <a6164707-a0dc-426d-9324-a5fba2170682@default>
References: <e1aa69e2-7af2-4003-8b8c-5a2b6987a3e2@default>
	<20150109142313.GB24745@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150109142313.GB24745@redhat.com>
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
Cc: vgoyal@redhat.com
List-Id: dm-devel.ids

Vivek, 
  1) Basically we map the LUN from storage arrary to one of linux host . Linux host sees that  LUN with mutlipath ( dm-multipath) abstact device /dev/mapper/LUNID . Linux host can mount that lun and do some read and write operation  on that . We want to cature those writes and send those writes  to another appliance . we will use that appilance for CDP( continues data protection)  of that LUN . 

2) My idea is To track writes  on the mapped lun  in Linux,  Can we  instantiate a write tracking Device Mapper device stacked on top of the mapped lun device ( /dev/mapper/LUIN) ?. Then, whenever the write tracking Device Mapper device receives  write request, it tracks the write. After that, it passes the  write request down to the underlying  lun device. In addition, to track writes to a Lun device, Linux host needs to be told to access the write tracking device instead of the LUN device itself. 

Kind of  Host side  write splitter in Storage domain,

Do we have any implemention which does  this ?. or  the work is in progress which we  can leverage ?. ?. Please kindly share any web links or pointers on this . Thanks in advance .

/Suresh

 
-----Original Message-----
From: Vivek Goyal [mailto:vgoyal@redhat.com] 
Sent: Friday, January 09, 2015 7:53 PM
To: device-mapper development
Subject: Re: [dm-devel] Device mapper target driver for Write tracking or Write split

On Thu, Jan 08, 2015 at 09:23:21PM -0800, Suresh Babu Kandukuru wrote:
> Hi List,
> 
>  
> 
> I am mainly looking at write tracking Device Mapper device .  Do we  have any device mapper target driver for write tacking or write splitting ?. or any work  happening on this to leverage  ?. Please kindly share any web links or pointers on this . Thanks in advance .
> 

Hi Suresh,

Could you give more details. What is write tracking/splitting and what are you planning to do with that.

Thanks
Vivek

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
