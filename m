From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: RHEL 6 I/O error messages during booting
Date: Tue, 10 May 2011 11:31:05 -0700
Message-ID: <1305052265.7661.185.camel@chandra-lucid.beaverton.ibm.com>
References: <OF01186CE2.F2A5FC34-ONC1257887.00332068-C1257887.003C3C98@de.ibm.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF01186CE2.F2A5FC34-ONC1257887.00332068-C1257887.003C3C98@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Christian May <christian_may@de.ibm.com>
List-Id: dm-devel.ids

Create a new initramds by using the --preload option to mkinitrd.

Exact syntax can be found in section 5.1 of
http://sourceware.org/lvm2/wiki/MultipathUsageGuide

chandra
On Thu, 2011-05-05 at 12:58 +0200, Christian May wrote:
> Hi, 
> 
> I'm new to this community so maybe my question is alreayd
> answered/solved. In that case please let me know how... 
> 
> I have several IBM blades running RHEL6 and RHEL 6.1 attached via FC
> switch to different FastT storage servers (prefered/non-prefered
> pathes). 
> During booting  I've noticed billions of I/O error messages which
> extend the boot process. I found that the scsi_dh_rdac 
> driver is build into the initramfs, so it should be available when the
> system is recognizing the SCSI LUNs. When taking a look to the
> messages 
> I found this statement "kernel: rdac: device handler registered" after
> the SCSI LUNs were recognized?! 
> 
> Any ideas? 
> 
> Regards, 
> 
> Christian 
> 
>  
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
