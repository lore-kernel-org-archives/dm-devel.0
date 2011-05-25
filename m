From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: SUSE multipath-tools patch resync
Date: Wed, 25 May 2011 09:51:47 +0200
Message-ID: <1306309907.2290.14.camel@lapoo.opensvc.com>
References: <4DD3DFC0.9050300@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DD3DFC0.9050300@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mer., 2011-05-18 at 17:03 +0200, Hannes Reinecke wrote:
> git.kernel.org:/pub/scm/linux/kernel/git/hare/multipath-tools.git

I started the merge. I'll post comments along the reading. It seems
there won't be much : this patchset is clearly a must-have.

...

Shouldn't this one be reverted ? Seems the real thing is
10d68a92b2a0027d5468cf76656692f34f6dbc54


commit efc8ace4b335e752a7d28aca6040af0f9fe37530
Author: Hannes Reinecke <hare@suse.de>
Date:   Mon Feb 1 09:46:57 2010 +0100

    Add 'max_polling_interval' config variable
    
    We should be able to set the 'max_polling_interval' variable
    manually. Especially systems requiring precise failover timing
    will want to disable the automatic polling interval increase.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/multipathd/main.c b/multipathd/main.c
index 7659bb2..6867f23 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1096,9 +1096,9 @@ check_path (struct vectors * vecs, struct path *
pp)
                         * max at conf->max_checkint
                         */
                        if (pp->checkint < (conf->max_checkint / 2))
-                               pp->checkint = 2 * pp->checkint;
+                           pp->checkint = 2 * pp->checkint;
                        else
-                               pp->checkint = conf->max_checkint;
+                           pp->checkint = conf->max_checkint;
 
                        pp->tick = pp->checkint;
                        condlog(4, "%s: delay next check %is",
