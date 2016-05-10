From: Todd Gill <tgill@redhat.com>
Subject: [PATCH v2 0/1] add option to output JSON for multipathd
	command
Date: Tue, 10 May 2016 15:05:27 -0400
Message-ID: <1462907128-28792-1-git-send-email-tgill@redhat.com>
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

Example output:

#multipathd show maps json
{
   "major_version ": 0,
   "minor_version ": 1,
   "maps": [{
      "name" : "mpatha",
      "uuid" : "35000c50071fa66ab",
      "sysfs" : "dm-3",
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
      "vend/prod/rev" : "SEAGATE,ST300MM0026",
      "switch_grp" : 0,
      "map_loads" : 1,
      "total_q_time" : 0,
      "q_timeouts" : 0,
      "path_groups": [{
         "selector" : "service-time 0",
         "pri" : 1,
         "dm_st" : "active",
         "paths": [{
            "uuid" : "35000c50071fa66ab",
            "hcil" : "5:0:0:0",
            "dev" : "sdf",
            "dev_t" : "8:80",
            "dm_st" : "active",
            "dev_st" : "running",
            "chk_st" : "ready",
            "vend/prod/rev" : "SEAGATE,ST300MM0026",
            "checker" : "directio",
            "next_check" : "XXXXXXXX.. 16/20",
            "pri" : 1,
            "size" : "279G",
            "serial" : "S0K23GE20000M4345PKL",
            "host WWNN" : "[undef]",
            "target WWNN" : "0x5000c50071fa66a9",
            "host WWPN" : "[undef]",
            "target WWPN" : "[undef]",
            "host adapter" : "0000:00:07.0"
         }]
      },{
         "selector" : "service-time 0",
         "pri" : 1,
         "dm_st" : "enabled",
         "paths": [{
            "uuid" : "35000c50071fa66ab",
            "hcil" : "5:0:20:0",
            "dev" : "sdy",
            "dev_t" : "65:128",
            "dm_st" : "active",
            "dev_st" : "running",
            "chk_st" : "ready",
            "vend/prod/rev" : "SEAGATE,ST300MM0026",
            "checker" : "directio",
            "next_check" : "XXXXXXXX.. 16/20",
            "pri" : 1,
            "size" : "279G",
            "serial" : "S0K23GE20000M4345PKL",
            "host WWNN" : "[undef]",
            "target WWNN" : "0x5000c50071fa66aa",
            "host WWPN" : "[undef]",
            "target WWPN" : "[undef]",
            "host adapter" : "0000:00:07.0"
         }]
      }]
   },{
      "name" : "mpathb",
      "uuid" : "35000c50071fb212f",
      "sysfs" : "dm-4",
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
      "vend/prod/rev" : "SEAGATE,ST300MM0026",
      "switch_grp" : 0,
      "map_loads" : 1,
      "total_q_time" : 0,
      "q_timeouts" : 0,
      "path_groups": [{
         "selector" : "service-time 0",
         "pri" : 1,
         "dm_st" : "active",
         "paths": [{
            "uuid" : "35000c50071fb212f",
            "hcil" : "5:0:1:0",
            "dev" : "sdg",
            "dev_t" : "8:96",
            "dm_st" : "active",
            "dev_st" : "running",
            "chk_st" : "ready",
            "vend/prod/rev" : "SEAGATE,ST300MM0026",
            "checker" : "directio",
            "next_check" : "XXXXXXXX.. 16/20",
            "pri" : 1,
            "size" : "279G",
            "serial" : "S0K243HH0000B434AASH",
            "host WWNN" : "[undef]",
            "target WWNN" : "0x5000c50071fb212d",
            "host WWPN" : "[undef]",
            "target WWPN" : "[undef]",
            "host adapter" : "0000:00:07.0"
         }]
      },{
         "selector" : "service-time 0",
         "pri" : 1,
         "dm_st" : "enabled",
         "paths": [{
            "uuid" : "35000c50071fb212f",
            "hcil" : "5:0:21:0",
            "dev" : "sdz",
            "dev_t" : "65:144",
            "dm_st" : "active",
            "dev_st" : "running",
            "chk_st" : "ready",
            "vend/prod/rev" : "SEAGATE,ST300MM0026",
            "checker" : "directio",
            "next_check" : "XXXXXXXX.. 16/20",
            "pri" : 1,
            "size" : "279G",
            "serial" : "S0K243HH0000B434AASH",
            "host WWNN" : "[undef]",
            "target WWNN" : "0x5000c50071fb212e",
            "host WWPN" : "[undef]",
            "target WWPN" : "[undef]",
            "host adapter" : "0000:00:07.0"
         }]
      }]
   }]
}

Thanks,
Todd



Todd Gill (1):
  add display of map information in JSON format

 libmultipath/print.c      | 163 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.h      |  63 ++++++++++++++++++
 multipathd/cli.c          |   3 +
 multipathd/cli.h          |   2 +
 multipathd/cli_handlers.c |  93 ++++++++++++++++++++++++++
 multipathd/cli_handlers.h |   2 +
 multipathd/main.c         |   2 +
 7 files changed, 328 insertions(+)

-- 
2.5.5
