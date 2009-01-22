From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Thu, 22 Jan 2009 07:14:18 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
    <E463DF2B2E584B4A82673F53D62C2EF45CEAB48E@cosmail01.lsi.com>
 <39FF78AD-75CB-4495-99C7-C4FAFB23999D@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <39FF78AD-75CB-4495-99C7-C4FAFB23999D@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Yes, the naming conventions look good. Here is the output of ls

-rw-r--r-- 1 root root  76802 Jan 21 16:41 ql2100_fw.bin
-rw-r--r-- 1 root root  84566 Jan 21 16:41 ql2200_fw.bin
-rw-r--r-- 1 root root 125088 Jan 21 16:41 ql2300_fw.bin
-rw-r--r-- 1 root root 135896 Jan 21 16:41 ql2322_fw.bin
-rw-r--r-- 1 root root 228056 Jan 21 16:41 ql2400_fw.bin
-rw-r--r-- 1 root root 239052 Jan 21 16:41 ql2400_fw.bin_mid
-rw-r--r-- 1 root root 200064 Jan 21 16:41 ql2500_fw.bin
-rw-r--r-- 1 root root 219924 Jan 21 16:41 ql2500_fw.bin_mid

Thanks
Babu Moger 

-----Original Message-----
From: Seokmann Ju [mailto:seokmann.ju@qlogic.com] 
Sent: Wednesday, January 21, 2009 6:26 PM
To: Moger, Babu
Cc: linux-scsi@vger.kernel.org; device-mapper development
Subject: Re: qla2xxx 0000:03:0c.0: Firmware image unavailable


On Jan 21, 2009, at 4:00 PM, Moger, Babu wrote:

> Hi All,
> Have you guys seen this following error?
>
> Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: Firmware image  
> unavailable.
> Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: Firmware images  
> can be retrieved from: ftp://ftp.qlogic.com/outgoing/linux/firmware/.
>
> After this error, qlogic driver fails to detect the LUNs attached.
>
> I am running 2.6.29-rc2 kernel on x86_64 machine.
>
> I tried couple of things without any success. I downloaded all the  
> qlogic firmwares available and kept it in /lib/firmware. Tried  
> rebuilding the kernel. Did not help. Thanks in advance.
Could you double check that those firmware binaries under /lib/ 
firmware have correct naming convention as defined in qla_os.c:  
FW_FILE_ISP2XXX?

>
>
>
> Thanks
> Babu Moger
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

