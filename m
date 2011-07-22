From: Jeff Cook <jeff@deserettechnology.com>
Subject: Re: dm-crypt: add mapping table option to allowing
	discard requests
Date: Fri, 22 Jul 2011 03:41:12 -0600
Message-ID: <4E2945B8.10303@deserettechnology.com>
References: <1310644590-14438-1-git-send-email-mbroz@redhat.com>
	<4E1F9023.5020801@deserettechnology.com>
	<20110715011311.GA27697@redhat.com>
Reply-To: jeff@deserettechnology.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110715011311.GA27697@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On 07/14/2011 07:13 PM, Mike Snitzer wrote:
> On Thu, Jul 14 2011 at  8:56pm -0400,
> Jeff Cook <jeff@deserettechnology.com> wrote:
>> Thanks very much for this patch Milan. I will try compiling it shortly
>> and see where things go -- are you expecting this to be submitted for
>> inclusion in mainline soon?
> 
> It is already staged for linux-next (and upstream inclusion when the 3.1
> merge window opens):
> ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-crypt-optionally-support-discard-requests.patch
> 
> NOTE: this version of the patch depends on additional changes that were
> also staged, e.g.:
> ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-table-share-target-argument-parsing-functions.patch

Sorry to be a pest, but I have a few more basic questions about the
application of these patches and their use on my encrypted disk.

First of all, I attempted to apply these patches to 3.0-rc6 and HEAD
(slightly after 3.0-rc7) and they did not apply cleanly. I was able to
get a correct application once, but then the compile failed, assumedly
due to a mispatching. Now that 3.0 has been tagged, should I assume that
the patches will apply cleanly to that tree? I tried both manual patch
via /usr/bin/patch and git apply. I suppose I can just wait for 3.1-rc1
if I must.

Secondly, I am not sure how I go about modifying the crypt table mapping
to activate the discard pass-through option.

I recognize that Milan's commit message indicates support is missing in
cryptsetup -- does this mean that a patch must be written to cryptsetup
before the new option can be activated or can this be accessed by the
lower-level dmsetup tool? I would guess the latter, though I don't
imagine it would be difficult to patch cryptsetup if needed (I haven't
looked at the code yet, though).

Is the mapping table modifiable at mount time, so this feature can be
activated on existing dm-crypt partitions, or would this require the
partition to be formatted with different options? If it can be modified
on mount, how do we set those parameters? Can I just boot off of a live
medium, mount manually with (patched) cryptsetup luksOpen, and have the
change kept on disk, or do I need to do something else?

Apologies for these noob-ish questions -- just thought I'd get much
better information straight from the source. All help is appreciated,
and I would like to express my gratitude once more for the construction
of this patch in the first place. Thanks Milan, Mike, and anyone else
involved for your effort, this will be a big help to a lot of people I
think. I almost didn't buy a SSD due to the lack of TRIM support in
dm-crypt. :)

Thanks again.

From
Jeff
