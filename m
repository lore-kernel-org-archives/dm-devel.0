From: Scott Dungan <scott@gps.caltech.edu>
Subject: Re: FS directly on top of dm devices?
Date: Fri, 17 Apr 2009 08:55:18 -0700
Message-ID: <49E8A666.9060608@gps.caltech.edu>
References: <49E7C4A6.3080301@gps.caltech.edu>
	<7bc80d500904161747n588b5b27v54b6c346ecd824d7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7bc80d500904161747n588b5b27v54b6c346ecd824d7@mail.gmail.com>
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

Stripe alignment was the benefit we were thinking as well. These devices 
will be used for ext3 file systems that will store a mix of file sizes 
and types that are accessed by user-written and executed applications on 
an HPC cluster.

It is difficult to tune the file system or the underlying SAN LUNs for 
such a mix, so we are choosing our best estimate for general i/o.

It is comforting to know that others are using no partitioning.

Thanks.



Christopher Chen wrote:
> I run md over mpath dm'd devices, without partitioning. Of course, I
> use dm-multipath to reach individual disks in a JBOD with two FC-AL
> loops.
>
> Lots of people like to do this to preserve stripe alignment.
>
> I also use LVM, with the metadatasize option on creation of the PV, to
> preserve stripe alignment.
>
> Do you have a specific application in mind, like a database?
>
> On Thu, Apr 16, 2009 at 4:52 PM, Scott Dungan <scott@gps.caltech.edu> wrote:
>   
>> We recently had an engineer from a large storage vendor suggest that we make
>> our file systems directly onto the multipathed devices without first
>> creating underlying partitions or using LVM.  Having not run with this
>> method in production before, we would like to gather as much information as
>> possible first. Initial searches for documentation on this method has
>> produced few results, short of a Suse/Novell document from 2005 under
>> section 4:
>>
>> http://support.novell.com/techcenter/sdb/en/2005/04/sles_multipathing.html
>>
>> Does anyone have any experience with this or can point us to more
>> documentation. thoughts or recommendations?
>>
>> Thanks,
>>
>> --
>>
>> Scott A Dungan
>>
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>>     
>
>
>
>   

-- 

Scott A Dungan
Systems Administrator
GPS Division
California Institute of Technology
Phone: (626) 395-3170
Fax:   (626) 585-1917
