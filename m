From: Elliot Lee <sopwith@gmail.com>
Subject: Re: DM performance issues
Date: Wed, 7 Mar 2007 19:39:21 -0500
Message-ID: <2380985A-6791-4CE9-B8F8-45072F0DC391@gmail.com>
References: <45FA1454-F5C7-45AD-8BCA-B4EDCC955EFF@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45FA1454-F5C7-45AD-8BCA-B4EDCC955EFF@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Sorry, I really should have given details on my system, especially  
the kernel version:

Linux 2.6.19-1.2911.fc6 #1 SMP x86_64

Pentium 4 3.00 GHz CPU, 1G RAM
ext3 on LVM on RAID-5 on 5 * 500G SATA drives.

Best,
-- Elliot

On Mar 7, 2007, at 19:36 , Elliot Lee wrote:

> Hi all,
>
> I've got a 1.8TB LVM-on-RAID filesystem that was performing OK but  
> really didn't seem like it was going as fast as it should. I ran  
> the commands below and got some pretty startling results...
>
> A 60% performance hit for a linear mapping is heinous. What can I  
> do to help get this fixed?
>
> Best,
> -- Elliot
>
> # dmsetup create foo --table '0 3880910848 linear 9:0 0'
>
> # dd if=/dev/md0 of=/dev/null bs=1048576 count=4096
> 4096+0 records in
> 4096+0 records out
> 4294967296 bytes (4.3 GB) copied, 20.2362 seconds, 212 MB/s
>
> # dd if=/dev/mapper/foo of=/dev/null bs=1048576 count=4096
> 4096+0 records in
> 4096+0 records out
> 4294967296 bytes (4.3 GB) copied, 55.3597 seconds, 77.6 MB/s
>
