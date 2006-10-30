From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: reboot problem
Date: Mon, 30 Oct 2006 10:45:33 -0600
Message-ID: <f4eecfb9818a11ba9525b0a838628664@redhat.com>
References: <454567BF.04EDDA.27845>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: multipart/mixed; boundary="===============1007328613=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <454567BF.04EDDA.27845>
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


--===============1007328613==
Content-Type: multipart/alternative; boundary=Apple-Mail-1--764059792


--Apple-Mail-1--764059792
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=HZ-GB-2312;
	format=flowed

Device Mapper does not remember the tables you have created across 
reboots.  For persistent volume creation, I would use LVM2.

If you must use device mapper, you could create an init script that 
creates the devices you've mentioned and mounts "v2".  Be forewarned, 
Linux can reorder block devices, so hard-coding block device names in 
your init script may result in mapping the wrong device(s).  (LVM2 gets 
around this by writing labels to the devices, so that it can identify 
the proper devices and assemble them in the correct order.)

  brassow

On Oct 29, 2006, at 8:01 PM, ~{KNUq;*~} wrote:

> Hi all:
> 	I'm a beginner to Device Mapper, now I have a problem perhaps stupid.
> 	However, I have made a mapped device named "v1" with table "t1", then 
> I made a mapped device named "v2" with table "t2" using "v1" as the 
> targed device, and mount "/dev/mapper/v2" at "/mnt/vd".
> 	Now I hope that after reboot there are still "v1","v2" and "v2" will 
> be still mounted at "/mnt/vd". How should I do for these? Thanks!
>
> ~{!!!!!!!!!!!!!!!!~}Song Zhenhua
> ~{!!!!!!!!!!!!!!!!~}songzhh81@163.com
> ~{!!!!!!!!!!!!!!!!!!!!~}2006-10-30
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--Apple-Mail-1--764059792
Content-Transfer-Encoding: 7bit
Content-Type: text/enriched;
	charset=HZ-GB-2312

Device Mapper does not remember the tables you have created across
reboots.  For persistent volume creation, I would use LVM2.


If you must use device mapper, you could create an init script that
creates the devices you've mentioned and mounts "v2".  Be forewarned,
Linux can reorder block devices, so hard-coding block device names in
your init script may result in mapping the wrong device(s).  (LVM2
gets around this by writing labels to the devices, so that it can
identify the proper devices and assemble them in the correct order.)


 brassow


On Oct 29, 2006, at 8:01 PM,
<fontfamily><param>Hiragino Kaku Gothic Pro</param>~{KNUq~}</fontfamily><fontfamily><param>STHeiti</param>~{;*~}</fontfamily>
wrote:


<excerpt>Hi all:

	I'm a beginner to Device Mapper, now I have a problem perhaps stupid. 

	However, I have made a mapped device named "v1" with table "t1", then
I made a mapped device named "v2" with table "t2" using "v1" as the
targed device, and mount "/dev/mapper/v2" at "/mnt/vd". 

	Now I hope that after reboot there are still "v1","v2" and "v2" will
be still mounted at "/mnt/vd". How should I do for these? Thanks!


<fontfamily><param>STHeiti</param>~{!!!!!!!!!!!!!!!!~}</fontfamily>Song Zhenhua

<fontfamily><param>STHeiti</param>~{!!!!!!!!!!!!!!!!~}</fontfamily>songzhh81@163.com

<fontfamily><param>STHeiti</param>~{!!!!!!!!!!!!!!!!!!!!~}</fontfamily>2006-10-30


--

dm-devel mailing list

dm-devel@redhat.com

https://www.redhat.com/mailman/listinfo/dm-devel


</excerpt>
--Apple-Mail-1--764059792--


--===============1007328613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1007328613==--
