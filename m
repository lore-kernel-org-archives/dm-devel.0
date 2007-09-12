From: Hannes Reinecke <hare@suse.de>
Subject: Re: alias multipath by fibre channel AL_PA instead of wwid?
Date: Wed, 12 Sep 2007 10:26:17 +0200
Message-ID: <20070912102617.wjjbr4u4pvok8cgo@imap.suse.de>
References: <448b15030709111856t6aa3808v50b7db9c2731e263@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <448b15030709111856t6aa3808v50b7db9c2731e263@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Am Wed 12 Sep 2007 03:56:59 AM CEST schrieb David Strand <dpstrand@gmail.com>:

> I see that multipath persistant link options are very dependent on knowing
> the disk wwid. In my setup, I will not know wwid but each drive is hardware
> strapped to obtain a hard AL_PA (disks are on a fibre channel arbitrated
> loop). Is there a way to setup alias names based on this information without
> knowing the wwid?
>

Not yet. But you can just write your own getuid program which returns  
the AL_PA ID instead of the disks WWID.

Cheers,

Hannes
---
No .sig today, my .message went away ...
