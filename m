From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: Re: online disk resizing
Date: Thu, 5 Jul 2007 08:56:03 -0400
Message-ID: <5fb0f77b0707050556v70f280bqa8126de952fadcc7@mail.gmail.com>
References: <E43E8EC1853DF64D8DF70C7FDC14E92A027093C5@dewdfe26.wdf.sap.corp>
	<468CE787.6040500@sigmatrans.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0906933449=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <468CE787.6040500@sigmatrans.ru>
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

--===============0906933449==
Content-Type: multipart/alternative;
	boundary="----=_Part_126295_9382667.1183640163096"

------=_Part_126295_9382667.1183640163096
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Alexander
Here is what I do (RHEL4u4) I use iscsi over a qlogic HBA but its basically
the same.. still "scsi" to RH :-)
Oh yea no partitions on my volumes either, It seems cleaner that way.

1. stop access to volume and unmount
2. resize your san volume
3. locate the scsi target number
    > cat /proc/scsi/qla4xxx/<controller>
   I find the volume Im interested in via our naming schema .. your milage
my very with that.
   I now have my volume def in scsi terms .. ie 2 0 2 0 or <host> <channel>
<scsi id> <lun>
4. remove and readd the scsi device
   > echo "scsi remove-single-device 2 0 2 0" > /proc/scsi/scsi
   > echo "scsi add-single-device 2 0 2 0" > /proc/scsi/scsi
6. at this point I have a new scsi device ie /dev/sdg or such which should
reflect the new size via your dmesg
   ( i usually have a tail -f of /var/log/messages going :-)
7. next run my ext2online to get the FS in sync with the actual size of the
volume
8. remount and re access the volume

Hope that helps out some ..

-- 
:wq!
kevin.foote

On 7/5/07, Alexander Benaguev <zul@sigmatrans.ru> wrote:
>
> Raayman, Sebastian wrote:
> > this is also dependant on the HBA you are using. With a Qlogic adapter
> > you can simply send an:
> >
> > echo scsi-qlascan
> >
> > to your Qlogic adapter (for example under /proc/scsqi/qla2xxx)
>
> thanks for attention, guys
>
> Sebastian, yes, I use qlogic, but, you will laught, I have not
> /proc/scsqi/qla2xxx. googling around
> shows that:
> "as of RHEL4 U3 (and I'd imagine upstream kernel.org kernels) the
> 'scsi-qlascan' no longer works
> with the qla2xxx driver. The new method is:
>
> echo 1 > /sys/class/fc_host/host<ID>/issue_lip
> echo "- - -" > /sys/class/scsi_host/host<ID>/scan" but it does not work
> for me.
> I tried "echo 1 >
> /sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/0000:06:01.0
> /host1/rport-1:0-1/target1:0:1/1:0:1:2/rescan"
> too. so, it was much better: dmesg showed me disks with new capacity, but
> "fdisk -l" still showing
> old capacity;( any thoughts?
>
> alexander
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_126295_9382667.1183640163096
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Alexander <br>Here is what I do (RHEL4u4) I use iscsi over a qlogic HBA but its basically the same.. still &quot;scsi&quot; to RH :-)<br>Oh yea no partitions on my volumes either, It seems cleaner that way.<br><br>1. stop access to volume and unmount
<br>2. resize your san volume<br>3. locate the scsi target number <br>&nbsp;&nbsp;&nbsp; &gt; cat /proc/scsi/qla4xxx/&lt;controller&gt; <br>&nbsp;&nbsp; I find the volume Im interested in via our naming schema .. your milage my very with that.<br>
&nbsp;&nbsp; I now have my volume def in scsi terms .. ie 2 0 2 0 or &lt;host&gt; &lt;channel&gt; &lt;scsi id&gt; &lt;lun&gt;<br>4. remove and readd the scsi device <br>&nbsp;&nbsp; &gt; echo &quot;scsi remove-single-device 2 0 2 0&quot; &gt; /proc/scsi/scsi
<br>&nbsp;&nbsp; &gt; echo &quot;scsi add-single-device 2 0 2 0&quot; &gt; /proc/scsi/scsi<br>6. at this point I have a new scsi device ie /dev/sdg or such which should reflect the new size via your dmesg <br>&nbsp;&nbsp; ( i usually have a tail -f of /var/log/messages going :-)
<br>7. next run my ext2online to get the FS in sync with the actual size of the volume <br>8. remount and re access the volume<br><br>Hope that helps out some ..<br><br>-- <br>:wq!<br>kevin.foote
<br><br><div><span class="gmail_quote">On 7/5/07, <b class="gmail_sendername">Alexander Benaguev</b> &lt;<a href="mailto:zul@sigmatrans.ru">zul@sigmatrans.ru</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Raayman, Sebastian wrote:<br>&gt; this is also dependant on the HBA you are using. With a Qlogic adapter<br>&gt; you can simply send an:<br>&gt;<br>&gt; echo scsi-qlascan<br>&gt;<br>&gt; to your Qlogic adapter (for example under /proc/scsqi/qla2xxx)
<br><br>thanks for attention, guys<br><br>Sebastian, yes, I use qlogic, but, you will laught, I have not /proc/scsqi/qla2xxx. googling around<br>shows that:<br>&quot;as of RHEL4 U3 (and I&#39;d imagine upstream <a href="http://kernel.org">
kernel.org</a> kernels) the &#39;scsi-qlascan&#39; no longer works<br>with the qla2xxx driver. The new method is:<br><br>echo 1 &gt; /sys/class/fc_host/host&lt;ID&gt;/issue_lip<br>echo &quot;- - -&quot; &gt; /sys/class/scsi_host/host&lt;ID&gt;/scan&quot; but it does not work for me.
<br>I tried &quot;echo 1 &gt;<br>/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/0000:06:01.0/host1/rport-1:0-1/target1:0:1/1:0:1:2/rescan&quot;<br>too. so, it was much better: dmesg showed me disks with new capacity, but &quot;fdisk -l&quot; still showing
<br>old capacity;( any thoughts?<br><br>alexander<br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel
</a><br></blockquote></div><br><br clear="all"><br>

------=_Part_126295_9382667.1183640163096--


--===============0906933449==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0906933449==--
