From: guy keren <choo@actcom.co.il>
Subject: Re: dm-multipath and multipathd verbose mode or debug mode
Date: Fri, 27 Nov 2009 15:58:21 +0200
Message-ID: <4B0FDAFD.4040100@actcom.co.il>
References: <A510D7CF8900D246979209B696F496F66531A09494@GVW1088EXB.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <A510D7CF8900D246979209B696F496F66531A09494@GVW1088EXB.americas.hpqcorp.net>
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

Janec, Jozef wrote:
> Hello All,
> 
> I have some issues on my server. And I need get more information from multupath and device mapper about all operation . Is possible enable some debug mode?
> 
> I have one vg with two EVA luns, and 4 luns on this VG
> 
> Is possible that the multipath cam mix the ids?
> 
> For example: 
> PV1 = LUN1
> PV2 = LUN2
> 
> PV1 = MPATHA = LUN2
> PV2 = MPATHB = LUN1
> 
> The problem is when I have multipath enabled lvm can see lvols from those two luns but the fs on the luns don't exists and when the multipath is disabled the fs on the lvols is ok?
> 
> Or when the boot.multipath is started the FS is mounted without problem
> But when the server is done with booting (after the multipatd daemon) the fs is not more accesible. Is possible that multipathd daemon cad so something what will mix some information that the fs is not available after this  for os? Can activate the paths across?
> 
> Best regards
> 
> Jozef

Hi Jozef,

i think the first ting you need to check, is whether the paths appear to 
be in active mode, or in failed mode. after the multipathd comes up, and 
before you try to mount the file system, run the command:

    multipathd -ll

make sure that the paths to your device appear in the 'up' state. you 
will also be able to see if multipath performed the path merging 
correctly or not.

if the paths do not appear in the 'active' state (at least one of them) 
- you will need to check why this happens.

if they paths are ok, try to mount the file system, and when this fails 
- check the paths again. if they failed - you might find information in 
/var/log/messages to show you what happened with them.

one more question: is your EVA Working in active-active mode (i.e. both 
paths are active and I/O may be sent to any of them), or in 
active-passive mode? if it works in active-passive mode - it could be 
that multipath did not recognize the active path properly, and is 
attempting to send the I/O to the passive path - which will result I/O 
errors.

--guy
