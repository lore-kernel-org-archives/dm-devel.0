From: Todd Gill <tgill@redhat.com>
Subject: [PATCH v4 0/1] add option to output JSON for multipathd
	command
Date: Wed, 18 May 2016 13:26:33 -0400
Message-ID: <1463592394-18974-1-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: dm-devel@redhat.com
Cc: Todd Gill <tgill@redhat.com>
List-Id: dm-devel.ids

Hi,

I had earlier sent an email to dm-devel proposing we add a feature
in multipathd to output multipath map topology in JSON format. This
patch contains to the code for that feature.

Having an option for the  CLI to output in JSON would allow higher
level applications to more easily monitor/manage multipath.

I thought it was best to take advantage of some of the existing
snprintf_xxx functions rather than adding a library dependency
to multipathd.

Any feedback welcome.

v2:
- added major/minor version fields
- updates from feedback
- added path groups
- changed indent levels to make it easier to read
- removed quotes from integer fields
- fixed bug when the JSON string length exceeded the allocated memory
- removed multipath field from path object - it isn't needed since
  the path is inside the map

v3:
- split out vend/prod/rev into seperate fields
- added new format specifiers for map:
  %v - vend
  %p - prod
  %e - rev
- removed vend/prod/rev from the path level since it is in the map

v4:
- removed space from major/minor version fields

Example of v4 JSON:

# multipathd show map mpathi json
{
   "major_version": 0,
   "minor_version": 1,
   "map":{
      "name" : "mpathi",
      "uuid" : "35000c5008868201b",
      "sysfs" : "dm-11",
      "failback" : "-",
      "queueing" : "-",
      "paths" : 2,
      "write_prot" : "rw",
      "dm-st" : "active",
      "size" : "279G",
      "features" : "0",
      "hwhandler" : "0",
      "action" : "",
      "path_faults" : 0,
      "vend" : "SEAGATE",
      "prod" : "ST300MM0026",
      "rev" : "0003",
      "switch_grp" : 0,
      "map_loads" : 1,
      "total_q_time" : 0,
      "q_timeouts" : 0,
      "path_groups": [{
         "selector" : "service-time 0",
         "pri" : 1,
         "dm_st" : "active",
         "paths": [{
            "uuid" : "35000c5008868201b",
            "hcil" : "5:0:16:0",
            "dev" : "sdv",
            "dev_t" : "65:80",
            "dm_st" : "active",
            "dev_st" : "running",
            "chk_st" : "ready",
            "checker" : "directio",
            "next_check" : "XXXXX..... 10/20",
            "pri" : 1,
            "size" : "279G",
            "serial" : "S0K41A7W0000M535KGGG",
            "host WWNN" : "[undef]",
            "target WWNN" : "0x5000c50088682019",
            "host WWPN" : "[undef]",
            "target WWPN" : "[undef]",
            "host adapter" : "0000:00:07.0"
         }]
      },{
         "selector" : "service-time 0",
         "pri" : 1,
         "dm_st" : "enabled",
         "paths": [{
            "uuid" : "35000c5008868201b",
            "hcil" : "5:0:36:0",
            "dev" : "sdao",
            "dev_t" : "66:128",
            "dm_st" : "active",
            "dev_st" : "running",
            "chk_st" : "ready",
            "checker" : "directio",
            "next_check" : "XXXXX..... 10/20",
            "pri" : 1,
            "size" : "279G",
            "serial" : "S0K41A7W0000M535KGGG",
            "host WWNN" : "[undef]",
            "target WWNN" : "0x5000c5008868201a",
            "host WWPN" : "[undef]",
            "target WWPN" : "[undef]",
            "host adapter" : "0000:00:07.0"
         }]
      }]
   }
}

Todd Gill (1):
  add display of map information in JSON format

 libmultipath/print.c      | 220 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.h      |  65 ++++++++++++++
 multipathd/cli.c          |   3 +
 multipathd/cli.h          |   2 +
 multipathd/cli_handlers.c |  93 ++++++++++++++++++++
 multipathd/cli_handlers.h |   2 +
 multipathd/main.c         |   2 +
 7 files changed, 387 insertions(+)

-- 
2.5.5
