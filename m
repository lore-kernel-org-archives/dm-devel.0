From: Alexander Benaguev <zul@sigmatrans.ru>
Subject: Re: online disk resizing
Date: Thu, 05 Jul 2007 16:43:51 +0400
Message-ID: <468CE787.6040500@sigmatrans.ru>
References: <E43E8EC1853DF64D8DF70C7FDC14E92A027093C5@dewdfe26.wdf.sap.corp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E43E8EC1853DF64D8DF70C7FDC14E92A027093C5@dewdfe26.wdf.sap.corp>
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

Raayman, Sebastian wrote:
> this is also dependant on the HBA you are using. With a Qlogic adapter
> you can simply send an:
> 
> echo scsi-qlascan 
> 
> to your Qlogic adapter (for example under /proc/scsqi/qla2xxx)

thanks for attention, guys

Sebastian, yes, I use qlogic, but, you will laught, I have not /proc/scsqi/qla2xxx. googling around 
shows that:
"as of RHEL4 U3 (and I'd imagine upstream kernel.org kernels) the 'scsi-qlascan' no longer works 
with the qla2xxx driver. The new method is:

echo 1 > /sys/class/fc_host/host<ID>/issue_lip
echo "- - -" > /sys/class/scsi_host/host<ID>/scan" but it does not work for me.
I tried "echo 1 > 
/sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/0000:06:01.0/host1/rport-1:0-1/target1:0:1/1:0:1:2/rescan" 
too. so, it was much better: dmesg showed me disks with new capacity, but "fdisk -l" still showing 
old capacity;( any thoughts?

alexander
