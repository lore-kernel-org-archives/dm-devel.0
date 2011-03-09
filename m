From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Wed, 09 Mar 2011 10:13:50 -0500
Message-ID: <4D77992E.1020909@gmail.com>
References: <4D766199.4010307@gmail.com> <20110308174308.GP10767@agk-dp.fab.redhat.com> <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com> <20110309142325.GA11312@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110309142325.GA11312@agk-dp.fab.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Wendy Cheng <s.wendy.cheng@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Jim Meyering <jim@>
List-Id: dm-devel.ids

On 03/09/2011 09:23 AM, Alasdair G Kergon wrote:
> On Tue, Mar 08, 2011 at 10:05:40AM -0800, Wendy Cheng wrote:
>> So the "resize" is on the filesystem, not the volume ? The "grow" part
>> is probably easy. Unfortunately, the "shrink" may not be easy for some
>> of the filesystems:
> The LVM situation today works both ways around.
>
> You can use 'lvresize' with an option to resize the filesystem too,
> or use 'fsadm' with an option to resize the LV.  We felt that 'fsadm'
> was a more-natural approach: allow the user to resize their filesystem
> and automatically adjust the things underneath as necessary.
>
> Long term, we'd like it to be possible to configure a system for resizing
> entire device stacks both top down (fsadm) and bottom up (triggered by the
> appropriate Unit Attention).
>
> (The current fsadm script was written as a proof-of-concept under the
> constraint of just wrapping existing binaries. Of course there are cleaner
> ways to do it when you allow filesystem-specific code.)
>
> Alasdair

Is anyone actively looking at taken it beyond proof of concept?

Ric

