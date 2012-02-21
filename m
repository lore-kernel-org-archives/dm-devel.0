From: Spelic <spelic@shiftmail.org>
Subject: Re: DM / LVM hangs if snapshot present on kernel v3.0.3
Date: Tue, 21 Feb 2012 11:22:03 +0100
Message-ID: <4F43704B.50903@shiftmail.org>
References: <4F405E1B.5030609@shiftmail.org>
	<20120220135103.GB27388@redhat.com> <4F426234.1020704@shiftmail.org>
	<4F428012.6090302@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <4F428012.6090302@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

On 02/20/12 18:17, Zdenek Kabelac wrote:
> Dne 20.2.2012 16:09, Spelic napsal(a):
>> On 02/20/12 14:51, Mike Snitzer wrote:
>>> I've never seen this. Which distro are you using?
>> Ubuntu 11.04  64-bit but with vanilla 3.0.3 kernel
>>
>> Ubuntu's lvm:
>> # lvm version
>>    LVM version:     2.02.66(2) (2010-05-20)
>>    Library version: 1.02.48 (2010-05-20)
>>
> So I'd guess you might be a 'victim' of Debian home-brew udev rules for lvm2,
> which were unfortunately not consulted with upstream (nor udev, nor lvm).

Indeed I have had a few bad experiences with Ubuntu's udev rules, but 
never like this...
I don't think a wrong udev rule can hangup the whole machine with such 
symptoms, you really think so?

- lvs and/or "lvchange --refresh ..." processes hanging forever in 
kernel code (and AFAIR it was in DM region, that's the /proc/pid/stack 
trace which I unfortunately lost)

- "sync" also cannot complete, so I can only do force reboot without flush
