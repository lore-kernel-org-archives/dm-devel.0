From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Tue, 08 Mar 2011 13:51:20 -0500
Message-ID: <4D767AA8.9080604@gmail.com>
References: <4D766199.4010307@gmail.com> <20110308174308.GP10767@agk-dp.fab.redhat.com> <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com> <20110308183709.GC2527@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110308183709.GC2527@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Cc: Wendy Cheng <s.wendy.cheng@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Jim Meyering <jim@meyering.net>, Chris Mason <chris.mason@oracle.com>
List-Id: dm-devel.ids

On 03/08/2011 01:37 PM, Josef Bacik wrote:
> On Tue, Mar 08, 2011 at 10:05:40AM -0800, Wendy Cheng wrote:
>>> On Tue, Mar 08, 2011 at 12:04:25PM -0500, Ric Wheeler wrote:
>>>> To make this trivial to do for users, I think that it would be really
>>>> nice to have a two-level wrappers for things like resize, add a volume,
>>>> shrink, etc. Similar to the way we have mount or fsck invoke file system
>>>> specific bits.
>>>> Good idea? Bad idea?
>> So the "resize" is on the filesystem, not the volume ? The "grow" part
>> is probably easy. Unfortunately, the "shrink" may not be easy for some
>> of the filesystems:
>>
> Who wants to make their fs smaller anyway?  ;)
>
> Josef

I have been surprised more than once by customers who do this on a regular basis :)

Ric

