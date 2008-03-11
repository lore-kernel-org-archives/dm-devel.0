From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Missing path
Date: Tue, 11 Mar 2008 07:15:29 -0700
Message-ID: <1205244929.30246.1.camel@linuxchandra>
References: <000501c8837f$53f835c0$cf42e3c1@pitagora.it>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <000501c8837f$53f835c0$cf42e3c1@pitagora.it>
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

On Tue, 2008-03-11 at 14:53 +0100, Domenico Viggiani wrote:

That is weird. Any other error messages in /var/log/messages ?

Anyways, you can try this

echo - - - > /sys/class/scsi_host/host0/scan

chandra
> After adding a LUN from a EMC Clariion CX700 to a system with already many
> of these, I noticed that multipath doesn't see a path:
> 
> 360060160eb241700284f88a159efdc11
> [size=450 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
> \_ round-robin 0 [prio=1][enabled]
>  \_ 1:0:0:70  sdbo 68:32  [active][ready]
> \_ round-robin 0 [enabled]
>  \_ 0:0:3:70  sdbn 68:16  [active][ready]
>  \_ 1:0:1:70  sdbp 68:48  [active][ready]
> 
> >From SCSI layer, it is OK:
> 
> Host: scsi0 Channel: 00 Id: 02 Lun: 70
>   Vendor: DGC      Model: RAID 5           Rev: 0219
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi0 Channel: 00 Id: 03 Lun: 70
>   Vendor: DGC      Model: RAID 5           Rev: 0219
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi1 Channel: 00 Id: 00 Lun: 70
>   Vendor: DGC      Model: RAID 5           Rev: 0219
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> Host: scsi1 Channel: 00 Id: 01 Lun: 70
>   Vendor: DGC      Model: RAID 5           Rev: 0219
>   Type:   Direct-Access                    ANSI SCSI revision: 04
> 
> but one device is missing under /dev:
> 
> brw-rw----  1 root disk 68,  16 Mar 11 14:44 /dev/sdbn
> brw-rw----  1 root disk 68,  32 Mar 11 14:45 /dev/sdbo
> brw-rw----  1 root disk 68,  48 Mar 11 14:45 /dev/sdbp
> 
> How can I fix this?
> 
> Thanks in advance
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
