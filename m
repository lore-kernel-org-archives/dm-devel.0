From: Tore Anderson <tore@linpro.no>
Subject: Re: multibus / failover and EMC CX600
Date: Wed, 17 Oct 2007 14:32:55 +0200
Message-ID: <471600F7.5090607@linpro.no>
References: <061401c810a7$cac685d0$0a00a8c0@ALDI2>
	<4715E6A4.7060308@linpro.no> <4715ED28.9020102@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4715ED28.9020102@suse.de>
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

* Hannes Reinecke

> That's the dev_loss_tmo setting. Just increase it to something to
> your liking.

Oh, sweet.  This knob won't affect how long the layer will hold I/O
before failing it (like lpfc_nodev_tmo), I assume?  (I'm worried about
it taking longer for dm-multipath to detect failed paths).

I wish it could've been set to unlimited, though.  Seems like there's
always some kind of trouble with re-adding the devices, either I run
into that -EEXIST bug, or udev doesn't do it's job properly and the
revived device isn't added back into the dm-multipath map.  In addition
it somtimes breaks queue_if_no_path with earlier multipath-tools that
doesn't use no_flush on suspend.  Those versions are of course included
in most server distributions...  Sigh.

Regards
-- 
Tore Anderson
