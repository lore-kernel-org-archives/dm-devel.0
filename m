From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Does dm handle tape devices?
Date: Mon, 05 Nov 2007 17:23:56 -0500
Message-ID: <472F97FC.5000509@cfl.rr.com>
References: <B6FF36386FC9AC4BB098A4528811409F4B7802@CORPUSMX40A.corp.emc.com>	<20071102195126.GA3712@linux.vnet.ibm.com>
	<B6FF36386FC9AC4BB098A4528811409F4B7882@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B6FF36386FC9AC4BB098A4528811409F4B7882@CORPUSMX40A.corp.emc.com>
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

lemons_terry@emc.com wrote:
> Hi
> 
> Thanks for the reply.  I have a customer who runs three tape-aware
> applications in one Linux system.  Two of those applications use device
> files (ex., dev/nst0) to access the tape devices, so the persistent
> udev-created symbolic links in /dev/tape/by-id and /dev/generic/by-id
> will work fine for those applications.
> 
> A third application, alas, uses SCSI IDs to refer to the tape devices.
> I've been instructed to seek a persistent naming solution for this
> application, too, one that (hopefully) won't require modification of the
> application.  I started out looking at the QLogic FC HBA's persistence
> capability, and saw that it functions at the target level within a
> single HBA.  But I found that some vendors don't support this method of
> persistence, opting instead to use device mapper.
> 
> Hope this is clear.

Device mapper has nothing at all to do with persistent device names. 
Device mapper is a kernel device driver that creates virtual block 
devices with interesting mappings to underlying block devices, such as 
raid.  Device naming is handled by udev.
