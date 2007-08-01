From: Andrew Miklas <public@mikl.as>
Subject: Re: Size affects performance?
Date: Wed, 1 Aug 2007 18:01:53 -0400
Message-ID: <E909CD7E-123F-43D6-BEBB-56D60AED11C9@mikl.as>
References: <OF4938AA3C.6B364A5A-ONC125732A.003345EF-C125732A.00338569@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF4938AA3C.6B364A5A-ONC125732A.003345EF-C125732A.00338569@de.ibm.com>
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

Hi,

On 1-Aug-07, at 5:24 AM, Stefan Bader wrote:

> If you use dd for performance tests I would suggest to use  
> oflags=sync.
> Otherwise there might be caching effects.
>

<snip>

Thanks for the advice.

I considered using sync, but the problem is that I don't think it  
would be a fair evaluation of the system.  Writing slows to a crawl,  
as would be expected.  However, the write speed with sync on doesn't  
reflect how I will be using the system in practice.

In case its useful, turning sync on does eliminate the effect where  
the throughput is dependent on the size of the device.
However, the problem could just be masked by the synchronous I/O  
overhead.

The problem is also noticeable when using the zero target, suggesting  
that the problem isn't in the SCSI driver:

flanders1:~# dmsetup create zero
0 20971520 zero

flanders1:~# dd if=/dev/zero of=/dev/mapper/zero bs=1K count=10485760
10485760+0 records in
10485760+0 records out
10737418240 bytes (11 GB) copied, 36.8242 seconds, 292 MB/s

-----

flanders1:~# dmsetup create zero
0 20971521 zero

flanders1:~# dd if=/dev/zero of=/dev/mapper/zero bs=1K count=10485760
10485760+0 records in
10485760+0 records out
10737418240 bytes (11 GB) copied, 55.7523 seconds, 193 MB/s



-- Andrew
