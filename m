From: David Wysochanski <davidw@netapp.com>
Subject: Re: multipathd:checkerloop() - why not check path state
	before calling pathinfo(), which calls path priority callouts?
Date: Wed, 01 Mar 2006 18:54:11 -0500
Message-ID: <44063423.5030803@netapp.com>
References: <C2EEB4E538D3DC48BF57F391F422779321B072@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010509070805050909020706"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321B072@SRMANNING.eng.emc.com>
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

This is a multi-part message in MIME format.
--------------010509070805050909020706
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

egoggin@emc.com wrote:
>
> On Wednesday, March 01, 2006 2:55 PM David Wysochans wrote
>
> >
> > Looking through the mulitpathd code, in particular
> > checkerloop() and the
> > below snippit.  I'm wondering why the path state isn't
> > checked and then the
> > pathinfo() not called if the path state is PATH_DOWN (or
> > maybe !PATH_UP).
> > Seems like we shouldn't be trying to refresh the priority if
> > we know the
> > path is bad anyway, since the callouts all issue scsi
> > passthru commands,
> > which will always fail.  Is this right or am I missing something?
>
> I think you are definitely right, but ...
>
> Keep in mind that some of the multipath path checkers set the
> multipath user state to PATH_DOWN even though the scsi pass
> through io succeeded.  So some scsi pass through commands may
> succeed, including path priority checking, path health testing,
> uid generation, and serial number retrieval even though the
> path's multipath state is PATH_DOWN.  So I think another reason
> to not issue the path priority update for a path in the PATH_DOWN
> state is that the updated priority value isn't even used.
>
> The calculation of a path group's priority does not include paths
> in a PATH_DOWN state.  See select_path_group() in
> libmultipath/switchgroup.c.  So there is no need to check if the
> priority of a path in a PATH_DOWN state has changed.
>
> But, I would instead patch pathinfo() in libmultipath/discovery.c
> to not call get_prio() if the path's state is PATH_DOWN.  Doing
> so will catch all other cases of calls to pathinfo() with
> DI_PRIO (like in need_switch_pathgroup() in multipathd/main.c).
>  
>
Ok, attached is the 1-line patch against libmultipath/discovery.c
Should apply cleanly against latest source.


> >
> > Thanks.
> >
> >
> >
> >             /*
> >              * path prio refreshing
> >              */
> >             condlog(4, "path prio refresh");
> >             pathinfo(pp, conf->hwtable, DI_PRIO);
> >
> >             if (need_switch_pathgroup(pp->mpp, 0)) {
> >                 if (pp->mpp->pgfailback > 0 &&
> >                     pp->mpp->failback_tick <= 0)
> >                     pp->mpp->failback_tick =
> >                         pp->mpp->pgfailback + 1;
> >                 else if (pp->mpp->pgfailback ==
> >                         -FAILBACK_IMMEDIATE)
> >                     switch_pathgroup(pp->mpp);
> >             }
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


--------------010509070805050909020706
Content-Type: text/x-patch;
 name="dont-call-get-prio-if-path-down.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dont-call-get-prio-if-path-down.patch"

--- libmultipath/discovery.c.orig	2006-03-01 18:29:38.000000000 -0500
+++ libmultipath/discovery.c	2006-03-01 18:33:10.000000000 -0500
@@ -652,7 +652,7 @@ pathinfo (struct path *pp, vector hwtabl
 	/*
 	 * get path prio
 	 */
-	if (mask & DI_PRIO) {
+	if (mask & DI_PRIO && pp->state != PATH_DOWN) {
 		if (!pp->getprio)
 			select_getprio(pp);
 

--------------010509070805050909020706
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010509070805050909020706--
