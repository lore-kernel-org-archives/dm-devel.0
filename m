From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RHEL 6 I/O error messages during booting
Date: Thu, 5 May 2011 09:38:09 -0400
Message-ID: <20110505133809.GA9548@redhat.com>
References: <OF01186CE2.F2A5FC34-ONC1257887.00332068-C1257887.003C3C98@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
To: Christian May <christian_may@de.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, May 05 2011 at  6:58am -0400,
Christian May <christian_may@de.ibm.com> wrote:

> Hi,
> 
> I'm new to this community so maybe my question is alreayd answered/solved. 
> In that case please let me know how...
> 
> I have several IBM blades running RHEL6 and RHEL 6.1 attached via FC 
> switch to different FastT storage servers (prefered/non-prefered pathes).
> During booting  I've noticed billions of I/O error messages which extend 
> the boot process. I found that the scsi_dh_rdac
> driver is build into the initramfs, so it should be available when the 
> system is recognizing the SCSI LUNs. When taking a look to the messages
> I found this statement "kernel: rdac: device handler registered" after the 
> SCSI LUNs were recognized?!
> 
> Any ideas?

The scsi_dh_rdac module is loaded after the FC driver.  This is a known
issue (happens for scsi_dh_emc too).

Mike
