From: Todd Gill <tgill@redhat.com>
Subject: Re: [PATCH v2 1/1] add display of map information in
 JSON format
Date: Thu, 12 May 2016 15:07:30 -0400
Message-ID: <5734D472.1000300@redhat.com>
References: <1462907128-28792-1-git-send-email-tgill@redhat.com>
	<1462907128-28792-2-git-send-email-tgill@redhat.com>
	<CABr-Gnd1+P8No_7E-ThXwPTUiS-cq0jqTQfh3M3ThOcXbkAd5w@mail.gmail.com>
	<573492F6.5060202@citrix.com>
Reply-To: tgill@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <573492F6.5060202@citrix.com>
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

On 05/12/2016 10:28 AM, Germano Percossi wrote:
> Hi,
> 
> If there are not specific reasons to have them
> merged, I would rather have vendor and product split.
>

Hi,

I changed the code to split them up, I'll send a v3 patch as soon as I'm
done testing.

To split the fields up, I added new "wildcards" to the map.

      {'v', "vend",          0, snprint_multipath_vend},
      {'p', "prod",          0, snprint_multipath_prod},
      {'e', "rev",           0, snprint_multipath_rev},

Hopefully that is acceptable.

I also removed the vend/prod/rev field from the path level of the JSON.
 It isn't needed since the path is contained in the map.

Here is an example of the updated JSON for a single map:

# multipathd show map mpathi json
{
   "major_version ": 0,
   "minor_version ": 1,
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
            "next_check" : "X......... 3/20",
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
            "next_check" : "X......... 3/20",
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

Also, I noticed that the vend/prod/rev doesn't include rev.  Is that
intentional?   snprint_multipath_vpr() returns:

      snprintf(buff, len, "%s,%s", pp->vendor_id, pp->product_id);

Note that no pp->rev is included in the string.

Thanks,
Todd
