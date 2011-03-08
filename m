From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Tue, 08 Mar 2011 13:13:51 -0500
Message-ID: <4D7671DF.4060108@gmail.com>
References: <4D766199.4010307@gmail.com>	<20110308174308.GP10767@agk-dp.fab.redhat.com> <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Wendy Cheng <s.wendy.cheng@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Jim Meyering <jim@meyering.net>, Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>
List-Id: dm-devel.ids

On 03/08/2011 01:05 PM, Wendy Cheng wrote:
>> On Tue, Mar 08, 2011 at 12:04:25PM -0500, Ric Wheeler wrote:
>>> To make this trivial to do for users, I think that it would be really
>>> nice to have a two-level wrappers for things like resize, add a volume,
>>> shrink, etc. Similar to the way we have mount or fsck invoke file system
>>> specific bits.
>>> Good idea? Bad idea?
> So the "resize" is on the filesystem, not the volume ? The "grow" part
> is probably easy. Unfortunately, the "shrink" may not be easy for some
> of the filesystems:
>
> -- Wendy

I think any "standard" operation would be allowed to fail with "notsupported" 
effectively. Shrink is definitely a challenge & even when it works, it often has 
performance implications.

I think that adding support to fsadm might be the easy path forward, but we 
would need to be able to do at least a handful of more advanced things (add a 
whole device for example).

Ric

