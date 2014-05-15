From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: an interesting note on LUN coalescing
Date: Thu, 15 May 2014 20:40:42 +0000
Message-ID: <1400186442.19394.29.camel@ict-vth-stewarts01.ict.englab.netapp.com>
References: <9E356404-6E9E-4271-A8DC-8A95DD66AC81@purestorage.com>
	<1400173675.19394.13.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<CDE8FB77-CD2E-4FF6-8485-C08FA3A7AE74@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CDE8FB77-CD2E-4FF6-8485-C08FA3A7AE74@purestorage.com>
Content-Language: en-US
Content-ID: <57EB537EB8342141845F2160C7692D3E@hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Thu, 2014-05-15 at 10:23 -0700, Brian Bunker wrote:
> I will get both the page 0x83 and page 0x80 data of the path when the problem happens. In our case the page 0x83 and page 0x80 data are the same always. The page 0x83 data has the additional encoding and OUI information but the bytes after that 3624a9370 are exactly the same. I am wondering about how the path gets its wwid when it comes back. 

This is through the call to /lib/udev/scsi_id, which pulls it from page
0x83.  The function that does it is called get_uid().  It calls the
external program, then strips trailing whitespace, replacing spaces with
null characters.  You could try simply making the log message in that
function a level 2 instead of a 3, so we'll know that get_uid completed
for the path, and what it found for the uid.

> 
> In our case we have a controller coming back online after doing something. All the LUNs are re-discovered by the initiator and an sd device gets created for each LUN path which came back. The serial of the sd device at that time I believe is known to the initiator. The multipathd gets that sd device and comes up with a wwid. I would expect that wwid would be just the serial number plus some bytes in the beginning but that is not what we see in the fail case. The path wwid and path serial are pointing to different volumes on the array. I expect that the sd device will show the same data for page 0x83 and page 0x80 pointing to the same volume on the array but I will verify that with more logging.
> 
Similar to what I said above, you could change the log message in
scsi_ioctl_pathinfo (after the get_serial call) from level 3 to level 2.

Beyond that, I don't have many more ideas here..  Another wild guess, I
suppose it's possible that the data from the 0x83 inquiry at the time of
discovery could be incomplete?  Then, when you run the command later,
manually, after it comes up, it appears just fine. I don't think I see
the code zeroing the memory for the wwid in the newly allocated path
struct before it tries to populate the buffer, but that seems kind of
farfetched.

> You can see from my previous posts on this issue. (They go back for some time). That the page 0x83 and page 0x80 from sg3_utils show that they point to same LUN but different from the dm device that they are coalesced under.
> 
> Thanks,
> Brian

Hope this helps.

Thanks,
Sean
