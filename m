From: Wendy Cheng <s.wendy.cheng@gmail.com>
Subject: Re: [dm-devel] generic wrappers for multi-device FS operations
Date: Tue, 8 Mar 2011 10:05:40 -0800
Message-ID: <AANLkTi=uMMN3jEdh3auijdxM+1ZR529oPri4HqRaasYx@mail.gmail.com>
References: <4D766199.4010307@gmail.com>
	<20110308174308.GP10767@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110308174308.GP10767@agk-dp.fab.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Jim Meyering <jim@mey>
List-Id: dm-devel.ids

> On Tue, Mar 08, 2011 at 12:04:25PM -0500, Ric Wheeler wrote:
>> To make this trivial to do for users, I think that it would be really
>> nice to have a two-level wrappers for things like resize, add a volume,
>> shrink, etc. Similar to the way we have mount or fsck invoke file system
>> specific bits.
>> Good idea? Bad idea?
>

So the "resize" is on the filesystem, not the volume ? The "grow" part
is probably easy. Unfortunately, the "shrink" may not be easy for some
of the filesystems:

-- Wendy
