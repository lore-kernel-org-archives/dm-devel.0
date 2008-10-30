From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Buffer I/O error
Date: Thu, 30 Oct 2008 10:29:33 -0700
Message-ID: <20081030172933.GA23948@linux.vnet.ibm.com>
References: <49022078.6010700@datadirectnet.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49022078.6010700@datadirectnet.com>
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

Kit Westneat <kwestneat@datadirectnet.com> wrote:
> Hi dm-devel,
>
> I'm running into an issue with dm-multipath  
> (device-mapper-multipath-0.4.5-27.el4_6.3) that has me confused and I  
> was hoping I could get some guidance.
>
> Here are the relevant dmesg messages:
> device-mapper: dm-multipath: Failing path 8:48.
> device-mapper: dm-multipath: Failing path 8:48.
> device-mapper: dm-multipath: Failing path 8:48.
> device-mapper: dm-multipath: Failing path 65:80.
> printk: 1004 messages suppressed.
> Buffer I/O error on device dm-13, logical block 1192525829
> lost page write due to I/O error on dm-13
>

What is the output of multipath -ll. I would assume that you have
queue_if_no_path no set. The "Buffer I/O error on device dm-13" is the dm
failing back the IO vs. possible previous errors that you saw accompanied
by SCSI errors where sd is failing the IO back to dm.

If you not seeing any SCSI errors, I would assume that it is the patch
checker that is failing your paths. Can try using the tur checker to see
if this changes your error signature?

> Normally when I have seen Buffer I/O errors in the past, they have been  
> accompanied by SCSI errors as well, but in this case I am not getting  
> anything. One odd thing is that the filesystem reported extremely slow  
> writes before the buffer I/O errors occurred. I have checked and  
> double-checked the storage array and everything seems fine. I am using  
> directio as my path checker if that makes a difference.
>
> I have been able to reproduce the problem consistently by attempting an  
> fsck on dm-13. However, I am now doing an fsck on the underlying sd  
> device and it hasn't bombed out yet with the buffer I/O errors.
>
> Has anyone encountered these seemingly inexplicable buffer I/O errors  
> before? Any advice on how to debug it?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
