From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: kernel update and dmraid causing grub errors
Date: Tue, 09 Nov 2010 23:49:16 -0600
Message-ID: <4CDA325C.9070500@suddenlinkmail.com>
References: <4CCF3EC4.1020708@suddenlinkmail.com>	<1288785893.25565.42.camel@o>	<4CD1E8BC.4060806@suddenlinkmail.com>	<1288873952.26244.39.camel@o>
	<4CD2DC9B.8010302@suddenlinkmail.com>
	<4CD98B1A.3080401@suddenlinkmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CD98B1A.3080401@suddenlinkmail.com>
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

On 11/09/2010 11:55 AM, David C. Rankin wrote:
> On 11/04/2010 11:17 AM, David C. Rankin wrote:
>> Hi Heinz,
>>
>> 	No, grub is (grub-0.97-17) and it hasn't changed since April 25, 2010. So
>> whatever is happening, isn't due to a grub change. Some of the Arch devs think
>> it might be a kernel issue. Last night, I posted the issue to the kernel list at
>> kernel.org and we will see what response we get back. The post to kernel.org was
>> pretty much the complete history of the issue, so I'll include the additional
>> information posted to the kernel list below for completeness:
> 
> Heinz,
> 
> 	Just as a follow-up, I didn't get a response from the kernel.org list on the
> issue. In fact the only dm related post on the list in the past week was the CFQ
> dm-crypt post that I also see was cc'ed here. I'll try the grub list and see if
> they have any ideas. If I get a response, I'll let you know. If you have any
> epiphanies on the issue, please let me know. Thanks.
> 

Heinz,

    I have one more piece of input and one more question. The issue may be more
than just this one box. I have two x86_64 nv dmraid boxes at the house
(primary/backup servers). The one I have had the boot problems with (MSI K9N2
SLI Platinum - Award BIOS) (running 2.6.35.7) and the other one is based on a
Tyan Tomcat K8e (Model: S2865 - Pheonix BIOS/Opteron 180) (running 2.6.35.8)
Both have similar nv dmraid setups. (MSI box has 2 RAID 1 arrays, Tyan box has 1
RAID 1 array)

    What I have noticed recently, the Tyan box boots and experiences what sounds
like disk/drive controller "confusion." What is weird is that it depends on how
the box inits. The problem is either "there" or it "isn't".

    What I mean is that when the problem occurs on the Tyan box -- it effects
the box from boot until shutdown. It behaves just like there is an interrupt
conflict or drive/controller fault. I can hear consistent read/write head
excursions (once every 2-3 secs.) and I get 15-30-60 second delays with
everything (type ls -- then wait 30,60 seconds for the listing or rt-click on
the desktop and wait, and wait... for the context menu). It doesn't matter
whether I have a desktop running or boot to runlevel 3 -- it's a low-level
issue.

    Normally that is a "Hey stupid, you have a drive failing... go fix it"
issue. But it's not. smartctl is fine on all drives -- "no errors logged".
Nothing in syslog or dmesg, and the disks are clean.

    A shutdown or reboot will completely "fix" the problem. Although today I had
to shutdown/restart 3 times before it "fixed" itself. When the box "inits"
without having this problem - it never exhibits *any* problem until the next
boot when whatever it is strikes again.

    Since I rarely boot the box, I don't exactly know when this started, but it
has been within the past month -- which is consistent with the latest round of
boot failures on the MSI box moving from kernel 2.6.35.7 to .8.

    I don't know what to make of it? It seems like something has just gone
"flaky" with how dmraid is working (or grub or kernel or whatever), and it's
like some part of the setup is just confused. On the MSI box, it appears as some
attempt to read beyond the partition boundary or the box thinking there is a
corrupt partition table and booting fails with the latest kernels. On the Tyan
box, it appears as something that causes read/write head excursions and causes
the 15-60 second hangs like there is an interrupt conflict or some hardware
thing waiting on a timeout.

    One item that did catch my eye on the kernel list was a dmraid issue
concerning a "CFQ dm-crypt" problem. I have no idea what that is other than
gleaning it had to do with some type of dmraid queue/scheduler that was causing
problems. I don't know if that could point to some area of dmraid that might be
the culprit.

    If you have any ideas of any type of test and/or diagnostic I could use the
next time the Tyan box exhibits the problem -- to look at where the hang/timeout
issue is, I would appreciate your ideas. (that's an area where I have no clue...
how or what to look for)

    Thanks for all your continued help and willingness to provide ideas. I know
this is a weird issue, but now that I have two boxes showing some signs of a
similar problem -- hopefully that will help me narrow it down.


-- 
David C. Rankin, J.D.,P.E.
Rankin Law Firm, PLLC
510 Ochiltree Street
Nacogdoches, Texas 75961
Telephone: (936) 715-9333
Facsimile: (936) 715-9339
www.rankinlawfirm.com
