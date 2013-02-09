From: Spelic <spelic@shiftmail.org>
Subject: Source that sets max_segments
Date: Sat, 09 Feb 2013 03:09:41 +0100
Message-ID: <5115AFE5.7030605@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hello list
sorry this is a bit OT but I didn't know where to ask.
I am trying to raise max_segments above 128 by kernel recompile but it 
seems I am not able to.

I have identified this place in the sources

void blk_set_default_limits(struct queue_limits *lim)
{
         lim->max_segments = BLK_MAX_SEGMENTS;
....

so I have raised the value of corresponding enum BLK_MAX_SEGMENTS (which 
was indeed set at 128), but I was surprised to notice that after booting 
the new kernel the value is still stuck at 128, for all devices: sd*, 
md*, dm-* .

So such value must come from elsewhere, but where?

( I am on 3.4.x fwiw.... )

Thanks in advance
