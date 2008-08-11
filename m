From: Sharif Nassar <lists-dmdevel@mrwacky.com>
Subject: RE: Status of resizing/growing dm-multipath devices on
	the fly
Date: Mon, 11 Aug 2008 13:18:13 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0808111316560.13407@mrwacky.com>
References: <20080806125355.GM3771@edu.joroinen.fi>
	<Pine.LNX.4.64.0808061432330.13407@mrwacky.com>
	<8B7CBAA22D114D888B0ECBE0BE410641@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8B7CBAA22D114D888B0ECBE0BE410641@pitagora.it>
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

On Thu, 7 Aug 2008, Domenico Viggiani wrote:

> * Sharif Nassar wrote:
>>
>> We seem to have a working method for resizing multipath luns
>> from our NetApp filers.  It works on CentOS 4 & 5, for us,
>> and our NetApps.
>> (2 HBA, times 2 paths on each makes for four SCSI LUN to resize)
>>
>> The poorly formatted, unpolished, YMMV, no warranty recipe is:
>>
>> ...
>>
>> Pfew! Done!
>
> Incredible! I will study this later, thanks.
> Any idea if this could work with an EMC Clariion CX 700 array?


While we haven't tested it, I don't see any reason why not.  Since the 
core concern is freeing the device so the kernel can see the new size, it 
shouldn't be an issue.

-sharif
