From: Tim Burgess <tim.burgess@anu.edu.au>
Subject: Multipath target does not shift block offset?
Date: Thu, 10 Feb 2005 16:02:28 +1100
Message-ID: <420AEAE4.8090506@anu.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi,

I've just been playing with the multipath dm target, and would like to 
create a single device mapper device consisting of several, 
concatenated, multipathed devices.  The intuitive way to do this would be:

# HBA 2 failing to 3
0 286749488 multipath 2 round-robin 1 0 /dev/sdd round-robin 1 0 /dev/sdl
286749488 286749488 multipath 2 round-robin 1 0 /dev/sde round-robin 1 0 
/dev/sdm
573498976 286749488 multipath 2 round-robin 1 0 /dev/sdf round-robin 1 0 
/dev/sdn
<snip>

However, when one tries to set up such a device, we get the error message:

kernel: device-mapper: device /dev/sde too small for target

I would have assumed that the mapping specified above would map the 
whole (sector range 0-286749487) of the sde/sdm device into the range 
286749488-573498975 of the dm device.  However, dm appears to be trying 
to map the range 286749488-573498975 of the dm device to the same 
offsets in the sde/sdm device.

Is this what was intended?

Cheers,
Tim

--------------------------------------------------------------------------
                                     ANU Supercomputer Facility
    tim.burgess@anu.edu.au           and APAC National Facility
    Phone: +61 2 6125 1431           Leonard Huxley Bldg (No. 56)
    Fax:   +61 2 6125 8199           Australian National University
                                     Canberra, ACT, 0200, Australia
--------------------------------------------------------------------------

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
