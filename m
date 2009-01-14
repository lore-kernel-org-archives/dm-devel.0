From: "Ty! Boyack" <ty@nrel.colostate.edu>
Subject: Could device-mapper offer multi-tier storage?
Date: Wed, 14 Jan 2009 12:43:31 -0700
Message-ID: <496E4063.5070502@nrel.colostate.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hi all,

I'm seeing a good bit of interest in multi-tier storage in high end 
systems, and was wondering if this functionality could be offered by 
device-mapper.

By multi-tier, I'm speaking of systems where various speed/quality 
storage units are used in an analogous way to the way cache is used for 
memory:  The most recently/often used data blocks are placed on the 
fastest storage device, then over time gets flushed out to slower 
systems.  It seems the trend is to use a smaller array of 15k rpm SAS 
drives as the first tier, then flush it out to much larger arrays of 
7200 rpm SATA drives as the second tier.

While this clearly has benefits in large systems, I would think the same 
concept could be brought in-box as well, by using a fast 15k or solid 
state drive as the first tier, and then pushing out to 7200 rpm SATA as 
a second tier. 

My interest is more in the large system side, but if this functionality 
was available and easy to use, I could see it getting wide adoption in 
smaller systems too -- just as RAID was once limited to big systems, 
this could be a cool technology to make available to all.

So the questions:

1)  Is device-mapper the right layer to look at applying this?

2)  If so, any ideas on how hard it would be to implement?

3)  If device-mapper is not the right place, any idea where this 
functionality should go, or if it is already out there in another form?

Thanks -- I would love to hear any thoughts or questions on this.

-Ty!




-- 
-===========================-
  Ty! Boyack
  NREL Unix Network Manager
  ty@nrel.colostate.edu
  (970) 491-1186
-===========================-
