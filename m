From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: SUSE multipath-tools patch resync
Date: Wed, 25 May 2011 14:10:31 +0200
Message-ID: <1306325431.2290.30.camel@lapoo.opensvc.com>
References: <4DD3DFC0.9050300@suse.de>
	<1306309907.2290.14.camel@lapoo.opensvc.com> <4DDCC72A.8000601@suse.de>
	<1306322079.2290.25.camel@lapoo.opensvc.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1306322079.2290.25.camel@lapoo.opensvc.com>
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

On mer., 2011-05-25 at 13:14 +0200, Christophe Varoqui wrote:
> On mer., 2011-05-25 at 11:08 +0200, Hannes Reinecke wrote:
> > On 05/25/2011 09:51 AM, Christophe Varoqui wrote:
> > > On mer., 2011-05-18 at 17:03 +0200, Hannes Reinecke wrote:
> > >> git.kernel.org:/pub/scm/linux/kernel/git/hare/multipath-tools.git
> > >
> > > I started the merge. I'll post comments along the reading. It seems
> > > there won't be much : this patchset is clearly a must-have.
> > >
> > :-)
> > 
> > With some things so bloody obvious that I keep wondering if I'm the
> > only one seeing these ...
> > 
> The merge is done. No change wrt your branch. Still not pushed to korg.
> I struggle with a hwtable corruption with no /etc/multipath.conf ... can
> you reproduce that ?
> 
Well, forget it ... it was just a matter of 'make clean && make' as some
structures changed length.

The merge is over and pushed to korg.
I catched only to problems.
You might want to review the fixes.

1/
commit e2ae02287aaec0b56ac832841130e3c855a5a471
Author: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date:   Wed May 25 14:00:52 2011 +0200

    Fix segfault in dm reassign code path
    
    alias is allocated and freed in multipathd/main.c:uev_add_map().
    
    Don't free it in ev_add_map() called from uev_add_map() to avoid
    double free.

diff --git a/multipathd/main.c b/multipathd/main.c
index 4497609..cc75921 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -272,7 +272,6 @@ ev_add_map (char * dev, char * alias, struct vectors
* vecs)
                                alias);
                        dm_reassign(alias);
                }
-               FREE(alias);
                return 0;
        }

2/
commit 7b541d1e2cee70ad5e61edf12333e7ff49615c8c
Author: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date:   Wed May 25 13:59:53 2011 +0200

    Set an internal default for feature
    
    Fix segfault when no /etc/multipath.conf is present.

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 87039f0..4236088 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -493,6 +493,7 @@ load_config (char * file)
        conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
        conf->bindings_read_only = 0;
        conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
+       conf->features = set_default(DEFAULT_FEATURES);
        conf->flush_on_last_del = 0;
        conf->attribute_flags = 0;
        conf->reassign_maps = DEFAULT_REASSIGN_MAPS;

-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
