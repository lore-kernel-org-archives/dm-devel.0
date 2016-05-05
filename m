From: Todd Gill <tgill@redhat.com>
Subject: Re: [PATCH 0/1] add option to output JSON for multipathd
 command
Date: Wed, 4 May 2016 21:45:30 -0400
Message-ID: <572AA5BA.6030402@redhat.com>
References: <1462393428-13929-1-git-send-email-tgill@redhat.com>
	<20160504232236.GA24139@agk-dp.fab.redhat.com>
Reply-To: tgill@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160504232236.GA24139@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 05/04/2016 07:22 PM, Alasdair G Kergon wrote:
> On Wed, May 04, 2016 at 04:23:47PM -0400, Todd Gill wrote:
>> I had earlier sent an email to dm-devel proposing we add a feature
>> in multipathd to output multipath map topology in JSON format. This
>> patch contains to the code for that feature.
>> Having an option for the  CLI to output in JSON would allow higher
>> level applications to more easily monitor/manage multipath.
>  
> Got any examples to show what the output actually looks like?
> 

I edited the following JSON to only include 2 of the multipath maps on
the system.

The JSON contains an array of maps.  Inside each map are elements and
the array of paths.

I was planning on adding they path groups if this gets accepted.

# multipathd show maps json
{
"maps":[
	{
	"name" : "360a98000423664653024426830595062",
	"uuid" : "360a98000423664653024426830595062",
	"sysfs" : "dm-9",
	"failback" : "immediate",
	"queueing" : "on",
	"paths" : "2",
	"write_prot" : "rw",
	"dm-st" : "active",
	"size" : "16G",
	"features" : "4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handle",
	"hwhandler" : "0",
	"action" : "",
	"path_faults" : "0",
	"vend/prod/rev" : "NETAPP,LUN",
	"switch_grp" : "0",
	"map_loads" : "1",
	"total_q_time" : "0",
	"q_timeouts" : "0",
	"paths":[
		{
		"uuid" : "360a98000423664653024426830595062",
		"hcil" : "6:0:0:0",
		"dev" : "sdc",
		"dev_t" : "8:32",
		"dm_st" : "active",
		"dev_st" : "running",
		"chk_st" : "ready",
		"vend/prod/rev" : "NETAPP,LUN",
		"checker" : "tur",
		"next_check" : "XXXXXXXX.. 16/20",
		"pri" : "50",
		"size" : "16G",
		"serial" : "B6de0$Bh0YPb",
		"multipath" : "360a98000423664653024426830595062",
		"host WWNN" : "0x50014380120d8425",
		"target WWNN" : "0x500a098080ba5a64",
		"host WWPN" : "0x50014380120d8424",
		"target WWPN" : "0x500a098180ba5a64",
		"host adapter" : "0000:00:03.0"
		},
		{
		"uuid" : "360a98000423664653024426830595062",
		"hcil" : "7:0:0:0",
		"dev" : "sdj",
		"dev_t" : "8:144",
		"dm_st" : "active",
		"dev_st" : "running",
		"chk_st" : "ready",
		"vend/prod/rev" : "NETAPP,LUN",
		"checker" : "tur",
		"next_check" : "XXXXXXXX.. 16/20",
		"pri" : "10",
		"size" : "16G",
		"serial" : "B6de0$Bh0YPb",
		"multipath" : "360a98000423664653024426830595062",
		"host WWNN" : "0x50014380120d8427",
		"target WWNN" : "0x500a098080ba5a64",
		"host WWPN" : "0x50014380120d8426",
		"target WWPN" : "0x500a098190ba5a64",
		"host adapter" : "0000:00:03.0"
		}
	]
	},
	{
	"name" : "360a98000423664653024426830595064",
	"uuid" : "360a98000423664653024426830595064",
	"sysfs" : "dm-2",
	"failback" : "immediate",
	"queueing" : "on",
	"paths" : "2",
	"write_prot" : "rw",
	"dm-st" : "active",
	"size" : "16G",
	"features" : "4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handle",
	"hwhandler" : "0",
	"action" : "",
	"path_faults" : "0",
	"vend/prod/rev" : "NETAPP,LUN",
	"switch_grp" : "0",
	"map_loads" : "1",
	"total_q_time" : "0",
	"q_timeouts" : "0",
	"paths":[
		{
		"uuid" : "360a98000423664653024426830595064",
		"hcil" : "6:0:0:1",
		"dev" : "sdd",
		"dev_t" : "8:48",
		"dm_st" : "active",
		"dev_st" : "running",
		"chk_st" : "ready",
		"vend/prod/rev" : "NETAPP,LUN",
		"checker" : "tur",
		"next_check" : "XXXXXXXX.. 16/20",
		"pri" : "50",
		"size" : "16G",
		"serial" : "B6de0$Bh0YPd",
		"multipath" : "360a98000423664653024426830595064",
		"host WWNN" : "0x50014380120d8425",
		"target WWNN" : "0x500a098080ba5a64",
		"host WWPN" : "0x50014380120d8424",
		"target WWPN" : "0x500a098180ba5a64",
		"host adapter" : "0000:00:03.0"
		},
		{
		"uuid" : "360a98000423664653024426830595064",
		"hcil" : "7:0:0:1",
		"dev" : "sdk",
		"dev_t" : "8:160",
		"dm_st" : "active",
		"dev_st" : "running",
		"chk_st" : "ready",
		"vend/prod/rev" : "NETAPP,LUN",
		"checker" : "tur",
		"next_check" : "XXXXXXXX.. 16/20",
		"pri" : "10",
		"size" : "16G",
		"serial" : "B6de0$Bh0YPd",
		"multipath" : "360a98000423664653024426830595064",
		"host WWNN" : "0x50014380120d8427",
		"target WWNN" : "0x500a098080ba5a64",
		"host WWPN" : "0x50014380120d8426",
		"target WWPN" : "0x500a098190ba5a64",
		"host adapter" : "0000:00:03.0"
		}
	]
	}
]
}
