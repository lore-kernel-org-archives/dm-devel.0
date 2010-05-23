From: pg_devm@devm.for.sabi.co.UK (Peter Grandi)
Subject: Re: Questions regarding request based dm-multipath and
	blk-layer/elevator
Date: Sun, 23 May 2010 16:54:04 +0100
Message-ID: <19449.20380.798892.407194@tree.ty.sabi.co.uk>
References: <201005191716.38617.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201005191716.38617.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linux DM devel <dm-devel@redhat.com>
List-Id: dm-devel.ids


> 1. With request based multipath, we have 2 elevators in the
>    path to the device. Doesn't 2 idling I/O schedulers affect
>    performance? Is it better to use the noop elevator for the
>    dm device? [ ... ]

Usually "metadrivers" (DM, MD, 'loop', ...) in Linux use only
one elevator (and it should be that of the _physical device_).

But if you are concerned by that kind of stuff, consider also
the impact of the (short-sightedly idiotic, and IIRC it cannot
be disabled) plugging/unplugging logic.
