From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [dm-devel] IBM request to allow unprivledged ioctls [Was: Revert
 "dm mpath: fix stalls when handling invalid ioctls"]
Date: Thu, 29 Oct 2015 12:47:06 -0200
Message-ID: <5632316A.5060909@linux.vnet.ibm.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20151029131810.GA26841@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

Hi Mike,

On 10/29/2015 11:18 AM, Mike Snitzer wrote:
> Sorry but I fail to see why your request to revert is viable.

No problem. Thanks for moving this for a discussion on a proper fix.

I'm somewhat new to kernel and SCSI workings and its community process,
so that's certainly appreciated.

> Wouldn't the correct fix be to train scsi_verify_blk_ioctl() to work
> even without SYS_CAP_RAWIO?

I see it would fix the problem as well, but I don't happen to know
all of its usages, so I'd have to defer to question to someone who
knows more of it.

> I'm not doubting that the commit caused problems for the case you care
> about (unprivledged users issueing ioctls) but that is an entirely
> different issue that needs to be discussed more directly (with the
> broader linux-scsi community, now cc'd).

Sure. Thanks for opening the discussion.

> p.s. leaving full context for linux-scsi so they don't need to track
> down other mails (btw, thanks for the detailed patch header but it
> enabled me to be skeptical of your request to revert):

You're welcome. If it's been useful for rejecting this patch and
getting a better one later, it's worth it. :)

Kind regards,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center

