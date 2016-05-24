From: Todd Gill <tgill@redhat.com>
Subject: [PATCH v5 0/1] add option to output JSON for multipathd
	command
Date: Tue, 24 May 2016 14:03:06 -0400
Message-ID: <1464112987-11577-1-git-send-email-tgill@redhat.com>
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

v5:
- add group number at the group level
- use an underscore to seperate words in the key part of the
JSON
- remove hcil, next_check, size, serial fields
- remove uuid from the path level - it is already in the map
- change JSON key from dm-st to dm_st
- make all keys lower case
- remove unnecessary call to memset - this addresses the performance
problem.  memset is already called in MALLOC (zalloc)
- multiply the initial allocation of memory with VECTOR_SIZE(vecs->mpvec)
to reduce the number of realloc calls.
- corrected reply + 1 in return of string length, correct length is
c - reply, not c - reply + 1

# multipathd show map dm-4 json
{
   "major_version": 0,
   "minor_version": 1,
   "map":{
      "name" : "360a980004236646530244268305a3147",
      "uuid" : "360a980004236646530244268305a3147",
      "sysfs" : "dm-4",
      "failback" : "immediate",
      "queueing" : "on",
      "paths" : 2,
      "write_prot" : "rw",
      "dm_st" : "active",
      "features" : "4 queue_if_no_path pg_init_retries 50 retain_attached_hw_handle",
      "hwhandler" : "0",
      "action" : "",
      "path_faults" : 0,
      "vend" : "NETAPP",
      "prod" : "LUN",
      "rev" : "811a",
      "switch_grp" : 0,
      "map_loads" : 1,
      "total_q_time" : 0,
      "q_timeouts" : 0,
      "path_groups": [{
         "selector" : "service-time 0",
         "pri" : 50,
         "dm_st" : "active",
         "group" : 1,
         "paths": [{
            "dev" : "sdi",
            "dev_t" : "8:128",
            "dm_st" : "active",
            "dev_st" : "running",
            "chk_st" : "ready",
            "checker" : "tur",
            "pri" : 50,
            "host_wwnn" : "0x50014380120d8425",
            "target_wwnn" : "0x500a098080ba5a64",
            "host_wwpn" : "0x50014380120d8424",
            "target_wwpn" : "0x500a098180ba5a64",
            "host_adapter" : "0000:00:03.0"
         }]
      },{
         "selector" : "service-time 0",
         "pri" : 10,
         "dm_st" : "enabled",
         "group" : 2,
         "paths": [{
            "dev" : "sdp",
            "dev_t" : "8:240",
            "dm_st" : "active",
            "dev_st" : "running",
            "chk_st" : "ready",
            "checker" : "tur",
            "pri" : 10,
            "host_wwnn" : "0x50014380120d8427",
            "target_wwnn" : "0x500a098080ba5a64",
            "host_wwpn" : "0x50014380120d8426",
            "target_wwpn" : "0x500a098190ba5a64",
            "host_adapter" : "0000:00:03.0"
         }]
      }]
   }
}

Todd Gill (1):
  add display of map information in JSON format

 libmultipath/print.c      | 222 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.h      |  61 +++++++++++++
 multipathd/cli.c          |   3 +
 multipathd/cli.h          |   2 +
 multipathd/cli_handlers.c |  93 +++++++++++++++++++
 multipathd/cli_handlers.h |   2 +
 multipathd/main.c         |   2 +
 7 files changed, 385 insertions(+)

-- 
2.5.5
