From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: multipath-tools: Potential issue in blacklist entry
	handling
Date: Thu, 7 Aug 2014 17:23:22 +0000
Message-ID: <1407432215.1299.14.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-ID: <F230011C70B97C4C918E145F0D51624C@hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

In our test labs, we recently had an issue where a hardware entry with a
product_blacklist attribute wasn't getting properly blacklisted. I
figured out it was because there was an overlap in the vendor id regex
between that entry, and an existing blacklist entry, so it threw the
entire thing out.  I wanted to see if anyone on the list had an opinion
about how this should be getting handled.

Built-in blacklist entry:
        device {
                vendor "(LSI|ENGENIO)"
                product "Universal Xport"
        }

Device entry:
   device {
      vendor                    "(NETAPP|LSI)"
      product                   "INF-01-00"
      product_blacklist         "Universal Xport"
      path_grouping_policy      group_by_prio
      path_checker              rdac
      features                  "2 pg_init_retries 50"
      hardware_handler          "1 rdac"
      prio                      rdac
      failback                  immediate
      no_path_retry             30
   }

Now, I can see why the code does what it does.. The regex function
matches the device entry with the blacklist entry because they both have
LSI in them, but then it silently throws out the NETAPP portion, which
is what I'd have a problem with.. It's basically ignoring the users
wishes and overriding with a built in default.

        vector_foreach_slot (blist, ble, i) {
                if (!regexec(&ble->vendor_reg, vendor, 0, NULL, 0) &&
                    !regexec(&ble->product_reg, product, 0, NULL, 0))
                        return 1;
        }

So, would we say this is working correctly?  I'd imagine our choices
would be something like (just brainstorming here):
1.  Add another blacklist entry, maybe unless the VID and PID are
exactly the same as an existing entry
2.  Try to merge the vendor ids in the bl entry
3.  Throw a warning


Does anyone have any further thoughts on how this _should_ be handled?


Thanks!
-- 
--
Sean Stewart
Software Engineer, E-Series Linux Failover
sean.stewart@netapp.com
316.636.8032

NetApp
3718 N Rock Rd
Wichita, KS 67226
