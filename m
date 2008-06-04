From: "Laurent GEHLEN" <list.4.gehlen@gmail.com>
Subject: Re: Re: domap (0) failure for create/reload map
Date: Wed, 4 Jun 2008 17:58:34 +0200
Message-ID: <cbca94860806040858r17906cf5pde563ee765212ad9@mail.gmail.com>
References: <cbca94860805230258l48eaf9a9u4d4b1ee91ed79294@mail.gmail.com>
	<cbca94860805240247g49712dc5sd93d862bc4ce12a1@mail.gmail.com>
	<cbca94860806030201l6dbee6ceh26f356f0109d0650@mail.gmail.com>
	<20080603145216.GA7518@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1950788863=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080603145216.GA7518@us.ibm.com>
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

--===============1950788863==
Content-Type: multipart/alternative;
	boundary="----=_Part_2176_18824477.1212595114540"

------=_Part_2176_18824477.1212595114540
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Yes I have LVM on the SAN Disk. But everything is on the sdd5. So i don't
see by what the sd{a,b,c} could be in use ...

# dmsetup table
san_vg_root-san_lv_home: 0 4096000 linear 8:53 4096384
san_vg_root-san_lv_opt: 0 4096000 linear 8:53 8192384
san_vg_root-san_lv_root: 0 4096000 linear 8:53 384
san_vg_root-san_lv_tmp: 0 4096000 linear 8:53 12288384
san_vg_root-san_lv_usr: 0 4096000 linear 8:53 16384384
san_vg_root-san_lv_var: 0 10240000 linear 8:53 20480384

# ls -l /dev/sd* | grep "$majeur, *$mineur"
brw-r----- 1 root disk 8,  0 May 21 13:22 /dev/sda
brw-r----- 1 root disk 8,  1 May 21 13:22 /dev/sda1
brw-r----- 1 root disk 8,  2 May 21 13:22 /dev/sda2
brw-r----- 1 root disk 8,  3 May 21 13:22 /dev/sda3
brw-r----- 1 root disk 8,  5 May 21 13:22 /dev/sda5
brw-r----- 1 root disk 8, 16 May 21 13:22 /dev/sdb
brw-r----- 1 root disk 8, 17 May 21 13:22 /dev/sdb1
brw-r----- 1 root disk 8, 18 May 21 13:22 /dev/sdb2
brw-r----- 1 root disk 8, 19 May 21 13:22 /dev/sdb3
brw-r----- 1 root disk 8, 21 May 21 13:22 /dev/sdb5
brw-r----- 1 root disk 8, 32 May 21 13:22 /dev/sdc
brw-r----- 1 root disk 8, 33 May 21 13:22 /dev/sdc1
brw-r----- 1 root disk 8, 34 May 21 13:22 /dev/sdc2
brw-r----- 1 root disk 8, 35 May 21 13:22 /dev/sdc3
brw-r----- 1 root disk 8, 37 May 21 13:22 /dev/sdc5
brw-r----- 1 root disk 8, 48 May 21 13:22 /dev/sdd
brw-r----- 1 root disk 8, 49 May 21 13:26 /dev/sdd1
brw-r----- 1 root disk 8, 50 May 21 13:22 /dev/sdd2
brw-r----- 1 root disk 8, 51 May 21 13:22 /dev/sdd3
brw-r----- 1 root disk 8, 53 May 21 13:22 /dev/sdd5

# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sdd5
  VG Name               san_vg_root
  PV Size               149.83 GB / not usable 1.43 MB
  Allocatable           yes
  PE Size (KByte)       4096
  Total PE              38356
  Free PE               34606
  Allocated PE          3750
  PV UUID               i2xhAY-1xyK-cNg0-Sfob-v76b-Kc4e-L4NS7e



2008/6/3 <malahal@us.ibm.com>:

> Laurent GEHLEN [list.4.gehlen@gmail.com] wrote:
> >    I've find some more info in my /var/log/syslog:
> >        kernel: device-mapper: table: 253:12: multipath: error getting
> device
> >        kernel: device-mapper: ioctl: error adding target to table
> >
> >    Still no clue ?
> >
> >    Laurent
>
> Generally that means the devices you are trying to multipath are in use.
> See if LVM has taken over them! What does "dmsetup table" tell you?
>
> --Malahal.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_2176_18824477.1212595114540
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br>Yes I have LVM on the SAN Disk. But everything is on the sdd5. So i don&#39;t see by what the sd{a,b,c} could be in use ...<br><br># dmsetup table<br>san_vg_root-san_lv_home: 0 4096000 linear 8:53 4096384<br>san_vg_root-san_lv_opt: 0 4096000 linear 8:53 8192384<br>
san_vg_root-san_lv_root: 0 4096000 linear 8:53 384<br>san_vg_root-san_lv_tmp: 0 4096000 linear 8:53 12288384<br>san_vg_root-san_lv_usr: 0 4096000 linear 8:53 16384384<br>san_vg_root-san_lv_var: 0 10240000 linear 8:53 20480384<br>
<br># ls -l /dev/sd* | grep &quot;$majeur, *$mineur&quot;<br>brw-r----- 1 root disk 8,&nbsp; 0 May 21 13:22 /dev/sda<br>brw-r----- 1 root disk 8,&nbsp; 1 May 21 13:22 /dev/sda1<br>brw-r----- 1 root disk 8,&nbsp; 2 May 21 13:22 /dev/sda2<br>
brw-r----- 1 root disk 8,&nbsp; 3 May 21 13:22 /dev/sda3<br>brw-r----- 1 root disk 8,&nbsp; 5 May 21 13:22 /dev/sda5<br>brw-r----- 1 root disk 8, 16 May 21 13:22 /dev/sdb<br>brw-r----- 1 root disk 8, 17 May 21 13:22 /dev/sdb1<br>brw-r----- 1 root disk 8, 18 May 21 13:22 /dev/sdb2<br>
brw-r----- 1 root disk 8, 19 May 21 13:22 /dev/sdb3<br>brw-r----- 1 root disk 8, 21 May 21 13:22 /dev/sdb5<br>brw-r----- 1 root disk 8, 32 May 21 13:22 /dev/sdc<br>brw-r----- 1 root disk 8, 33 May 21 13:22 /dev/sdc1<br>brw-r----- 1 root disk 8, 34 May 21 13:22 /dev/sdc2<br>
brw-r----- 1 root disk 8, 35 May 21 13:22 /dev/sdc3<br>brw-r----- 1 root disk 8, 37 May 21 13:22 /dev/sdc5<br>brw-r----- 1 root disk 8, 48 May 21 13:22 /dev/sdd<br>brw-r----- 1 root disk 8, 49 May 21 13:26 /dev/sdd1<br>brw-r----- 1 root disk 8, 50 May 21 13:22 /dev/sdd2<br>
brw-r----- 1 root disk 8, 51 May 21 13:22 /dev/sdd3<br>brw-r----- 1 root disk 8, 53 May 21 13:22 /dev/sdd5<br><br># pvdisplay<br>&nbsp; --- Physical volume ---<br>&nbsp; PV Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /dev/sdd5<br>&nbsp; VG Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; san_vg_root<br>
&nbsp; PV Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 149.83 GB / not usable 1.43 MB<br>&nbsp; Allocatable&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; yes<br>&nbsp; PE Size (KByte)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096<br>&nbsp; Total PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 38356<br>&nbsp; Free PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 34606<br>&nbsp; Allocated PE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3750<br>&nbsp; PV UUID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i2xhAY-1xyK-cNg0-Sfob-v76b-Kc4e-L4NS7e<br>
<br><br><br><div class="gmail_quote">2008/6/3  &lt;<a href="mailto:malahal@us.ibm.com" target="_blank">malahal@us.ibm.com</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div>Laurent GEHLEN [<a href="mailto:list.4.gehlen@gmail.com" target="_blank">list.4.gehlen@gmail.com</a>] wrote:<br>
&gt; &nbsp; &nbsp;I&#39;ve find some more info in my /var/log/syslog:<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;kernel: device-mapper: table: 253:12: multipath: error getting device<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp;kernel: device-mapper: ioctl: error adding target to table<br>
&gt;<br>
&gt; &nbsp; &nbsp;Still no clue ?<br>
&gt;<br>
&gt; &nbsp; &nbsp;Laurent<br>
<br>
</div>Generally that means the devices you are trying to multipath are in use.<br>
See if LVM has taken over them! What does &quot;dmsetup table&quot; tell you?<br>
<br>
--Malahal.<br>
<font color="#888888"><br>
--<br>
dm-devel mailing list<br>
<a href="mailto:dm-devel@redhat.com" target="_blank">dm-devel@redhat.com</a><br>
<a href="https://www.redhat.com/mailman/listinfo/dm-devel" target="_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</font></blockquote></div><br>

------=_Part_2176_18824477.1212595114540--


--===============1950788863==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1950788863==--
