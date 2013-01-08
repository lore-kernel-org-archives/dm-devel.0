From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [multipath tools] pgp->priority average calculation
Date: Tue, 08 Jan 2013 16:51:31 -0600
Message-ID: <50ECA2F3.7070501@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, christophe.varoqui@gmail.com
List-Id: dm-devel.ids

Hey Ben and Hannes and Christophe,

Happy multipath-tools patch submission day :)

I had a question on the pgp->priority average calculation and its
display to the user.


Ben, you added the patch

commit cd21bd290a57eed350d564bac403da9d6941a144
Author: Benjamin Marzinski <bmarzins@redhat.com>
Date:   Wed Nov 10 12:52:20 2010 -0600

    multipath: sort all pathgroups by priority


which did

@@ -25,14 +25,17 @@ path_group_prio_update (struct pathgroup * pgp)
                        pgp->enabled_paths++;
                }
        }
-       pgp->priority = priority;
+       if (pgp->enabled_paths)
+               pgp->priority = priority / pgp->enabled_paths;
+       else
+

and

@@ -387,9 +386,7 @@ snprint_pg_pri (char * buff, size_t len, struct
pathgroup *
         * Printing is another reason to update.
         */
        path_group_prio_update(pgp);
-       if (pgp->enabled_paths)
-               avg_priority = pgp->priority / pgp->enabled_paths;
-       return snprint_int(buff, len, avg_priority);
+


but then Hannes later added the patch:


commit 750db1f0dc08bf1d96ce64d32786dfe07b8ae3f9
Author: Hannes Reinecke <hare@suse.de>
Date:   Wed Mar 17 08:32:51 2010 +0100

    Display avg priority as group priority


which added it back in the print code:


-       return snprint_int(buff, len, pgp->priority);
+       if (pgp->enabled_paths)
+               avg_priority = pgp->priority / pgp->enabled_paths;
+       return snprint_int(buff, len, avg_priority);


So when we print the prio, it ends up getting divided by the number of
enabled paths twice.


Was Hannes's patch a mistake? Should it be reverted?
