From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm
	resume	ioctl.
Date: Fri, 19 Mar 2010 16:51:53 +0100
Message-ID: <4BA39D99.1090608@redhat.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>	<4BA29CA4.9070000@redhat.com>	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>	<20100319090656.GR6379@soda.linbit>	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>	<4BA37B06.1040107@redhat.com>
	<4BA38567.1050106@suse.de>	<4BA392B2.50903@redhat.com>
	<7b13a0f81003190814y56a3ed76yf06ed23a11747b4@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7b13a0f81003190814y56a3ed76yf06ed23a11747b4@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Zeuthen <zeuthen@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/19/2010 04:14 PM, David Zeuthen wrote:
>> Generally, it carries hints for udev rules to instruct them
>> how they should be applied correctly, which parts should be
>> run based on the type of the device, it's real meaning with all
>> relations to other devices taken into account within that
>> DM subsystem used (e.g. LVM2's snapshots, mirrors...).
>>
>> Most of this information is really not suitable to be stored
>> as a sysfs attribute since it deals with userspace notions,
>> an abstraction layer above device-mapper...
>>
> 
> Presumably this information originates from user space when
> setting up the device-mapper device, right? Why can't you
> simply store it in, say, /var/run/device-mapper?
> 
> (Or, better, store it in /dev/.device-mapper/ to avoid hitting
> the real disk - /dev is guaranteed to be on tmpfs)

Sure, this is a possibility...

But that would mean *duplicating* the (part) of udev db functionality
(so it could be considered as another workaround?) I just asked
myself if there would be more people who could benefit from such
feature in udev db directly. A more proper and official solution
others can use if needed as well.

(Maybe we can even write our own udev daemon, called dm-udevd :))


Peter
