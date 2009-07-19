From: Diego Jacobi <jacobidiego@gmail.com>
Subject: Re: [linux-lvm] Re: Parallel mirroring
Date: Sun, 19 Jul 2009 18:12:30 +0200
Message-ID: <5de034af0907190912w3e09fdcdv2ba3bc05cfe6b5be@mail.gmail.com>
References: <5de034af0907121156s491df9cei264569333ea6a787@mail.gmail.com>
	<5de034af0907161407p5a3315f9r96104f4dd035de76@mail.gmail.com>
	<20090716212446.GA30411@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090716212446.GA30411@us.ibm.com>
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

Hello people.
I have been refered to this list from the lvm list.

I have 2 disk in lvm and some logical volumes with mirroring.
I did some tests but i wonder if it could also work as a raid1, i mean
a parallel scheduller as told in HP-UX docs but for linux.

I want to have the read speed benefit of having a mirrored lvolume as
with raid1.

Is it possible and stable at current time? if so, how? I couldnt find
anything on the net, and nobody could answer on linux-lvm list.

Thanks in advance.
Diego


2009/7/16  <malahal@us.ibm.com>:
> Diego Jacobi [jacobidiego@gmail.com] wrote:
>> Hi.
>>
>> Sry for retry but the lvm list is my last resource.
>
> Try dm-devel mailing list. Linux LVM is based on device mapper
> framework.
>
>> Does Linux-LVM have Parallel scheduler mode for mirroring at all?
>> If yes, how do you set it up, or check if it is enabled?
>
> Writes happen in parallel, of course! At the moment it only reads from
> the default mirror leg (unless the default leg is broken). There was
> some patch for round-robin reading among mirrored legs, but it is not in
> the upstream yet.
>
> --Malahal.
>
> _______________________________________________
> linux-lvm mailing list
> linux-lvm@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-lvm
> read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
>


This are my tests:

sda1 = /boot in disk 1, no lvm
sdb1 = /boot in disk 2, no lvm
data/data = lvm without mirroring
data/root = lvm with mirroring


linux-8mmd:~ # hdparm -t /dev/sda1
/dev/sda1:
 Timing buffered disk reads:  262 MB in  3.02 seconds =  86.83 MB/sec

linux-8mmd:~ # hdparm -t /dev/sdb1
/dev/sdb1:
 Timing buffered disk reads:  174 MB in  3.03 seconds =  57.36 MB/sec

linux-8mmd:~ # hdparm -t /dev/data/data
/dev/data/data:
 Timing buffered disk reads:  272 MB in  3.02 seconds =  90.02 MB/sec

linux-8mmd:~ # hdparm -t /dev/data/root
/dev/data/root:
 Timing buffered disk reads:  278 MB in  3.02 seconds =  92.16 MB/sec



As you can see, the read speed are mostly the same. This could mean a
secuenced scheduler.

And this is my system setup:

lvm> version
 LVM version:     2.02.39 (2008-06-27)
 Library version: 1.02.27 (2008-06-25)
 Driver version:  4.14.0

linux-8mmd:~ # pvs
 PV         VG   Fmt  Attr PSize   PFree
 /dev/sda3  data lvm2 a-   537.11G 395.12G
 /dev/sda5  data lvm2 a-   996.00M 988.00M         <--- Note 1 Gb, for log
 /dev/sdb3  data lvm2 a-   138.99G 118.99G

linux-8mmd:~ # lvs -a -o +devices
 LV              VG   Attr   LSize   Origin Snap%  Move Log
Copy%  Convert Devices
 data            data -wi-ao 121.50G
          /dev/sda3(125)
 home            data mwi-ao  10.00G                    home_mlog
100.00         home_mimage_0(0),home_mimage_1(0)
 [home_mimage_0] data iwi-ao  10.00G
          /dev/sda3(33788)
 [home_mimage_1] data iwi-ao  10.00G
          /dev/sdb3(2560)
 [home_mlog]     data lwi-ao   4.00M
          /dev/sda5(1)
 root            data mwi-ao  10.00G                    root_mlog
100.00         root_mimage_0(0),root_mimage_1(0)
 [root_mimage_0] data iwi-ao  10.00G
          /dev/sda3(31228)
 [root_mimage_1] data iwi-ao  10.00G
          /dev/sdb3(0)
 [root_mlog]     data lwi-ao   4.00M
          /dev/sda5(0)
 test            data -wi-a- 500.00M
          /dev/sda3(0)
