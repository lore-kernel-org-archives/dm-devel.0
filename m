From: Mike Christie <michaelc@cs.wisc.edu>
Subject: LSI/Engenio support
Date: Sat, 08 Oct 2005 00:15:23 -0500
Message-ID: <434755EB.4000300@cs.wisc.edu>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Well, not really but the beginning becuase people keep asking for it. I 
am working on sending the sense info up to the block layer and on how to 
share scsi_decide_disposistion processing between dm and scsi for the 
failover command processing. I do not really know EMC or HP HW, but do 
know the LSI stuff a little bit since I worked on dm when I was at IBM.

I put a basic hw handler here
http://www.cs.wisc.edu/~michaelc/block/dm/dm-hw-handler/v4/
(you should apply all the patches and select engenio support)

There are also some fixes to the other functions in that patchset. I 
have not gotton a good chance to test the hw handler against real HW, 
instead I have been faking it with scsi_debug.

If some of the people with the LSI/Engenio/FASTt/DS4000 boxes that have 
been requesting manual failover support have a chance, could you just 
try this out real quick.  I just want to make sure I have the failover 
command correct, so just run dd and pull a cable and make sure IO goes 
to the other paths. Nothing fancy.

Oh yeah check your log, you should see something like this:

Oct  7 23:59:42 max kernel: device-mapper: rdac: queueing MODE_PAGE 
command on 8:32
Oct  7 23:59:42 max kernel: device-mapper: dm_scsi_end_rq: errors 134217730
Oct  7 23:59:42 max kernel:
Oct  7 23:59:42 max kernel: device-mapper: rdac: rdac_rq_error 0x8000002
Oct  7 23:59:42 max kernel: dm-engenio-rdac: Current: sense key: Illegal 
RequestOct  7 23:59:42 max kernel:     Additional sense: Invalid command 
operation code

Your output will be different since the above is just from using 
scsi_debug (send me your output).

The next step will be to handle the more fun cases where we need the 
sense in the dm layer. Then we can do the preffered path stuff and all 
those other features and possibly integrate AVT support if needed.

Thanks
